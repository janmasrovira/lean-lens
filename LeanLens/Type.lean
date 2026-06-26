import LeanLens.Internal

namespace LeanLens

def LensLike (f : Type → Type) (s t a b : Type) := (a → f b) → s → f t

def LensLike' (f : Type → Type) (s a : Type) := LensLike f s s a a

def ASetter (s t a b : Type) := (a → Id b) → s → Id t

def ASetter' (s a : Type) := ASetter s s a a

-- Use in a combinator's argument type to consume a getter.
def Getting (r s a : Type) := (a → Const r a) → s → Const r s

-- Use in getter definition.
def SimpleGetter (s a : Type) := ∀ {r : Type}, Getting r s a

def SimpleFold (s a : Type) := ∀ {r : Type} [Monoid r], Getting r s a

def Lens (s t a b : Type) := ∀ {f : Type → Type} [Functor f], (a → f b) → s → f t

def Lens' (s a : Type) := Lens s s a a

def Traversal (s t a b : Type) := ∀ {f : Type → Type} [Applicative f], (a → f b) → s → f t

def Traversal' (s a : Type) := Traversal s s a a

end LeanLens
