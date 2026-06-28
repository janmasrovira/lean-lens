import LeanLens.Type
import Mathlib.Algebra.FreeMonoid.Basic

namespace LeanLens

variable {s t a b c r : Type}

section Builders

def mkLens (get : s → a) (put : b → s → t) : Lens s t a b :=
  fun {f} [Functor f] k src => (fun v => put v src) <$> k (get src)

def mkSimpleGetter (g : s → a) : SimpleGetter s a :=
  fun {_r} k src => ⟨(k (g src)).get⟩

/-- Short alias for `mkSimpleGetter` that's convenient to use in a lens chain -/
abbrev via (g : s → a) : SimpleGetter s a := mkSimpleGetter g

def mkASetter (m : (a → b) → s → t) : ASetter s t a b :=
  fun k src => m (fun x => k x) src

end Builders

section Eliminators

def view (l : Getting a s a) (src : s) : a :=
  (l (fun x => ⟨x⟩) src).get

def over (l : ASetter s t a b) (g : a → b) (src : s) : t :=
  l g src

def set (l : ASetter s t a b) (v : b) (src : s) : t :=
  over l (fun _ => v) src

def traverseOf {f : Type → Type} (l : LensLike f s t a b) (k : a → f b) (src : s) : f t :=
  l k src

end Eliminators

section Setters

/-- Setter over every element of a functor. -/
def mapped {f : Type → Type} [Functor f] : ASetter (f a) (f b) a b :=
  mkASetter Functor.map

end Setters

section Folds

def foldMapOf (l : Getting r s a) (f : a → r) (src : s) : r :=
  (l (fun x => ⟨f x⟩) src).get

def toListOf (l : SimpleFold s a) (src : s) : List a :=
  foldMapOf (r := FreeMonoid a) l FreeMonoid.of src

/-- The first element of a fold if it's nonempty. -/
def preview (l : SimpleFold s a) (src : s) : Option a :=
  (foldMapOf (r := First a) l (fun x => ⟨some x⟩) src).get

/-- Returns true iff the fold is nonempty. -/
def has (l : SimpleFold s a) (src : s) : Bool :=
  (preview l src).isSome

end Folds

section Composition

/-- Lenses compose with ordinary function composition. -/
example (l : Lens s t a b) (l' : Lens a b c c) : Lens s t c c := l ∘ l'

end Composition

end LeanLens
