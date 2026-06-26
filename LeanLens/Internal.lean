namespace LeanLens

structure Const (r : Type) (a : Type) where
  get : r

instance : Functor (Const r) where
  map _ c := ⟨c.get⟩

end LeanLens
