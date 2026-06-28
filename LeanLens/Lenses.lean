import LeanLens.Type

namespace LeanLens

variable {a b c : Type}

def fst_ : Lens (a × c) (b × c) a b :=
  fun {f} [Functor f] k p => (fun x => (x, p.2)) <$> k p.1

def snd_ : Lens (c × a) (c × b) a b :=
  fun {f} [Functor f] k p => (fun x => (p.1, x)) <$> k p.2

end LeanLens
