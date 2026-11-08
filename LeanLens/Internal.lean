module

public import Mathlib.Algebra.Group.Defs

@[expose] public section

namespace LeanLens

structure Const (r : Type) (a : Type) where
  get : r

instance {r : Type} : Functor (Const r) where
  map _ c := ⟨c.get⟩

instance {r : Type} [Monoid r] : Applicative (Const r) where
  pure _ := ⟨1⟩
  seq f x := ⟨f.get * (x ()).get⟩

structure First (a : Type) where
  get : Option a

instance {a : Type} : Monoid (First a) where
  one := {get := none}
  mul x y := {get := x.get.orElse (fun () => y.get)}
  mul_assoc x y z := by
    rcases x with ⟨g⟩
    cases g <;> rfl
  one_mul x := by rfl
  mul_one x := by
    rcases x with ⟨g⟩
    cases g <;> rfl

end LeanLens
