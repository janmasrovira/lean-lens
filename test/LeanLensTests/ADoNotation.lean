module

import all LeanLens
meta import LeanLens

/-!
# Tests for `ado` applicative do-notation

Each block is bound to a `def`, then checked at compile time with `#guard`
(a false guard fails the build).
-/

open LeanLens

section Option

def pureVal : Option Nat := ado return 5
#guard pureVal == some 5

def addTwo : Option Nat := ado
  let a ← some 1
  let b ← some 2
  return a + b
#guard addTwo == some 3

def shortCircuit : Option Nat := ado
  let a ← some 1
  let _ ← (none : Option Nat)
  return a
#guard shortCircuit == none

/-- Binder order: first binder ↔ first effect. -/
def order : Option Nat := ado
  let a ← some 10
  let b ← some 3
  return a - b
#guard order == some 7

def typed : Option Nat := ado
  let a ← some 2
  let b : Nat ← some 5
  return a * b
#guard typed == some 10

def discardAction : Option Nat := ado
  let a ← some 1
  (some 99 : Option Nat)
  return a
#guard discardAction == some 1

def finalAction : Option Nat := ado
  some 1
  (some 42 : Option Nat)
#guard finalAction == some 42

def finalActionFail : Option Nat := ado
  (none : Option Nat)
  (some 42 : Option Nat)
#guard finalActionFail == none

end Option

section Except

def exceptOk : Except String Nat := ado
  let a ← (Except.ok 3 : Except String Nat)
  let b ← (Except.ok 4 : Except String Nat)
  return a + b
#guard exceptOk.toOption == some 7

def exceptErr : Except String Nat := ado
  let _ ← (Except.error "boom" : Except String Nat)
  let b ← (Except.ok 4 : Except String Nat)
  return b
#guard exceptErr.toOption == none

end Except

section Const

/-- `Const r` is `Applicative` when `r` is a `Monoid`, accumulating the `r`
    components via `Seq.seq`. With `Monoid (First a)` (first non-`none` wins)
    the second effect is reached and contributes, so the result is `some 5`. -/
def constAcc : Const (First Nat) Nat := ado
  let _ ← (⟨⟨none⟩⟩ : Const (First Nat) Nat)
  let _ ← (⟨⟨some 5⟩⟩ : Const (First Nat) Nat)
  return 0
#guard constAcc.get.get == some 5

end Const

section PureBranching

-- `ado` is applicative-only, so it cannot branch on an effect's value. A branch
-- on a *pure* condition is just an ordinary term, and works in every term
-- position without special macro support.

def ifInReturn (c : Bool) : Option Nat := ado
  let a ← some 1
  let b ← some 2
  return (if c then a + b else a - b)
#guard ifInReturn true == some 3
#guard ifInReturn false == some 0  -- both effects ran; 1 - 2 truncates to 0 in Nat

def matchInReturn (n : Nat) : Option Nat := ado
  let a ← some 10
  return (match n with | 0 => a | _ => a + n)
#guard matchInReturn 0 == some 10
#guard matchInReturn 5 == some 15

def ifChoosesEffect (c : Bool) : Option Nat := ado
  let a ← some 1
  let b ← (if c then some 2 else some 3)
  return a + b
#guard ifChoosesEffect true == some 3
#guard ifChoosesEffect false == some 4

def matchChoosesEffect (n : Nat) : Option Nat := ado
  let a ← some 1
  let b ← (match n with | 0 => some 100 | _ => some 200)
  return a + b
#guard matchChoosesEffect 0 == some 101
#guard matchChoosesEffect 9 == some 201

def ifAsBareEffect (c : Bool) : Option Nat := ado
  let a ← some 1
  (if c then some 9 else (none : Option Nat))
  return a
#guard ifAsBareEffect true == some 1
#guard ifAsBareEffect false == none  -- the discarded branch still short-circuits

end PureBranching

section Errors

/--
error: unsupported element in `ado` block; only `let x ← e`, `let x : τ ← e`, `let _ ← e`, and bare term are supported (no `let :=`, `if`, `match`, …)
-/
#guard_msgs in
example : Option Nat := ado
  let x := 5
  return x

/--
error: unsupported final element in `ado` block; the last element must be `return e` or a bare term
-/
#guard_msgs in
example : Option Nat := ado
  let a ← some 1
  let b ← some 2

-- A bare final term is sequenced outside the binder lambda, so it cannot
-- reference an earlier binder — the binder is out of scope.
/--
error: Unknown identifier `x`
-/
#guard_msgs in
example : Option Nat := ado
  let x ← some 5
  (some x : Option Nat)

end Errors
