-- Types and functions to support FZF config construction
let Key =
      { Type =
          { name : Text, synonyms : List Text, description : Optional Text }
      , default = { synonyms = [] : List Text, description = None Text }
      }
let Action = \(arg : Text) ->
    {
            Type = {
                    name : Text,
                    description : Text,
                }
        }

in  False
