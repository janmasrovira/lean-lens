module

public import VersoManual
public import LeanLens
import all LeanLens.Type
import all LeanLens.Combinators
import all LeanLens.Lenses

open Verso.Genre Manual

set_option verso.docstring.allowMissing true

public section

#doc (Manual) "LeanLens" =>

LeanLens is a minimal van Laarhoven optics library.

# Types

{docstring LeanLens.LensLike}

{docstring LeanLens.Lens}

{docstring LeanLens.Traversal}

{docstring LeanLens.ASetter}

{docstring LeanLens.Getting}

{docstring LeanLens.SimpleGetter}

{docstring LeanLens.SimpleFold}

# Builders

{docstring LeanLens.mkLens}

{docstring LeanLens.mkSimpleGetter}

{docstring LeanLens.via}

{docstring LeanLens.mkASetter}

# Eliminators

{docstring LeanLens.view}

{docstring LeanLens.over}

{docstring LeanLens.set}

{docstring LeanLens.traverseOf}

# Setters

{docstring LeanLens.mapped}

# Folds

{docstring LeanLens.foldMapOf}

{docstring LeanLens.toListOf}

{docstring LeanLens.preview}

{docstring LeanLens.has}

# Optics

{docstring LeanLens.fst_}

{docstring LeanLens.snd_}

{docstring LeanLens.both}
