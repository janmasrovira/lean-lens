module

public import LeanLens.Combinators

@[expose] public section

namespace LeanLens

variable {s a : Type}

@[simp] theorem view_lens (get : s → a) (put : a → s → s) (src : s) :
    view (mkLens get put) src = get src := rfl

@[simp] theorem over_lens (get : s → a) (put : a → s → s) (g : a → a) (src : s) :
    over (mkLens get put) g src = put (g (get src)) src := rfl

@[simp] theorem set_lens (get : s → a) (put : a → s → s) (v : a) (src : s) :
    set (mkLens get put) v src = put v src := rfl

class LawfulLens (l : Lens' s a) : Prop where
  view_set : ∀ (v : a) (src : s), view l (set l v src) = v
  set_view : ∀ (src : s), set l (view l src) src = src
  set_set : ∀ (v v' : a) (src : s), set l v' (set l v src) = set l v' src

export LawfulLens (view_set set_view set_set)

end LeanLens
