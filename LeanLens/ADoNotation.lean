module

public meta import Lean.Elab.Macro

public meta section

/-!
# Applicative Do-Notation

`ado` is `do` for `Applicative`.

```
ado
  let x ← e₁
  let y ← e₂
  return body
```
becomes `(fun x y => body) <$> e₁ <*> e₂`.
-/

open Lean

syntax (name := adoNotation) "ado " doSeq : term

/-- The binder introduced by one `ado` element. -/
private inductive ADoBinder where
  | anon
  | named (x : TSyntax `ident)
  | typed (x : TSyntax `ident) (ty : TSyntax `term)
  deriving Inhabited

/-- Wrap `body` in a single-argument `fun` for this binder. -/
private def ADoBinder.wrap (b : ADoBinder) (body : TSyntax `term) : MacroM (TSyntax `term) :=
  match b with
  | .anon => `(fun _ => $body)
  | .named x => `(fun $x => $body)
  | .typed x ty => `(fun ($x : $ty) => $body)

@[macro adoNotation]
def expandADo : Macro := fun stx => do
  let doSeq := stx[1]
  let itemsNode := if doSeq.getKind == ``Lean.Parser.Term.doSeqIndent then
    doSeq[0]
  else
    doSeq[1]
  let elems := (itemsNode.getArgs.map fun item => item[0]).filter (!·.isMissing)
  if elems.isEmpty then
    Macro.throwError "empty ado block"
  let init := elems.pop
  let last := elems.back!

  -- Each element except the last contributes one effect `(binder, term)`.
  let initEffects ← init.mapM fun elem =>
    match elem with
    | `(doElem| let $x:ident ← $e:term) => pure (ADoBinder.named x, e)
    | `(doElem| let $x:ident : $ty:term ← $e:term) => pure (ADoBinder.typed x ty, e)
    | `(doElem| let _ ← $e:term) => pure (ADoBinder.anon, e)
    | `(doElem| $e:term) => pure (ADoBinder.anon, e)
    | _ =>
      Macro.throwErrorAt elem
        "unsupported element in `ado` block; only `let x ← e`, `let x : τ ← e`, \
         `let _ ← e`, and bare term are supported (no `let :=`, `if`, `match`, …)"

  -- The last element fixes the result: `return e` is pure; a bare term's own
  -- value is the result (bound to a fresh name appended as the final effect).
  let (effects, body) : Array (ADoBinder × TSyntax `term) × TSyntax `term ← match last with
    | `(doElem| return $e:term) => pure (initEffects, e)
    | `(doElem| return) => do pure (initEffects, ← `(()))
    | `(doElem| $e:term) =>
      let z : TSyntax `ident := mkIdent (← MonadQuotation.addMacroScope `adoResult)
      pure (initEffects.push (.named z, e), (⟨z.raw⟩ : TSyntax `term))
    | _ =>
      Macro.throwErrorAt last
        "unsupported final element in `ado` block; \
         the last element must be `return e` or a bare term"

  match effects.toList with
  | [] => `(pure $body)
  | (_, e₀) :: rest =>
    let lam ← effects.foldrM (fun (b, _) acc => b.wrap acc) body
    let head : TSyntax `term ← `($lam <$> $e₀)
    let result : TSyntax `term ← rest.foldlM (fun acc (_, e) => `($acc <*> $e)) head
    return result
