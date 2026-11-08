module

public import LeanLens.Internal

@[expose] public section

namespace LeanLens

/-- All lenses have a type that has this shape -/
def LensLike (f : Type → Type) (s t a b : Type) := (a → f b) → s → f t

def LensLike' (f : Type → Type) (s a : Type) := LensLike f s s a a

/-- Lens for single element -/
def Lens (s t a b : Type) := ∀ {f : Type → Type} [Functor f], LensLike f s t a b

def Lens' (s a : Type) := Lens s s a a

/-- Lens for zero or more elements -/
def Traversal (s t a b : Type) := ∀ {f : Type → Type} [Applicative f], LensLike f s t a b

def Traversal' (s a : Type) := Traversal s s a a

/-- Setter for one element -/
def ASetter (s t a b : Type) := LensLike Id s t a b

def ASetter' (s a : Type) := ASetter s s a a

/-- Getter for one element. This type is used by consumers of getters. -/
def Getting (r s a : Type) := LensLike' (Const r) s a

/-- Getter for one element. This type is used in definitions of getters. -/
def SimpleGetter (s a : Type) := ∀ {r : Type}, Getting r s a

/-- Reads zero ore more elements. -/
def SimpleFold (s a : Type) := ∀ {r : Type} [Monoid r], Getting r s a

end LeanLens
