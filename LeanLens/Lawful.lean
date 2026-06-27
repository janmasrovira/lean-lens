import LeanLens.Type

namespace LeanLens

variable {s a : Type}

def view (l : Lens' s a) (src : s) : a :=
  (l (f := Const a) (fun x => ⟨x⟩) src).get

def over (l : Lens' s a) (g : a → a) (src : s) : s :=
  l (f := Id) g src

def set (l : Lens' s a) (v : a) (src : s) : s :=
  over l (fun _ => v) src

def lens (get : s → a) (put : a → s → s) : Lens' s a :=
  fun {f} [Functor f] k src => (fun v => put v src) <$> k (get src)

@[simp] theorem view_lens (get : s → a) (put : a → s → s) (src : s) :
    view (lens get put) src = get src := rfl

@[simp] theorem over_lens (get : s → a) (put : a → s → s) (g : a → a) (src : s) :
    over (lens get put) g src = put (g (get src)) src := rfl

@[simp] theorem set_lens (get : s → a) (put : a → s → s) (v : a) (src : s) :
    set (lens get put) v src = put v src := rfl

class LawfulLens (l : Lens' s a) : Prop where
  view_set : ∀ (v : a) (src : s), view l (set l v src) = v
  set_view : ∀ (src : s), set l (view l src) src = src
  set_set : ∀ (v v' : a) (src : s), set l v' (set l v src) = set l v' src

export LawfulLens (view_set set_view set_set)

end LeanLens
