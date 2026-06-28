import LeanLens.Type

-- Proofs of the edges in `diagram/hierarchy.dot`: each edge A → B means
-- "an A can be used as a B"

namespace LeanLens.Hierarchy

variable (s t a b r : Type)

example (l : Lens s t a b) : Traversal s t a b := l
example (l : Lens' s a) : SimpleGetter s a := l
example (l : Lens s t a b) : ASetter s t a b := l

example (l : Traversal s t a b) : ASetter s t a b := l
example (l : Traversal' s a) : SimpleFold s a := l

example (l : SimpleGetter s a) : Getting r s a := l
example (l : SimpleGetter s a) : SimpleFold s a := l

example (l : ASetter s t a b) : LensLike Id s t a b := l
example (l : Getting r s a) : LensLike (Const r) s s a a := l
example [Monoid r] (l : SimpleFold s a) : LensLike (Const r) s s a a := l

end LeanLens.Hierarchy
