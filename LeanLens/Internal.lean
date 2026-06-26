import Mathlib.Algebra.Group.Defs

namespace LeanLens

structure Const (r : Type) (a : Type) where
  get : r

instance {r : Type} : Functor (Const r) where
  map _ c := ⟨c.get⟩

instance {r : Type} [Monoid r] : Applicative (Const r) where
  pure _ := ⟨1⟩
  seq f x := ⟨f.get * (x ()).get⟩

end LeanLens
