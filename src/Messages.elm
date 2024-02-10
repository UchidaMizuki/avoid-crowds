module Messages exposing (..)


type Msg
    = KeyDownDirection Direction
    | KeyUpDirection Direction
    | ButtonPressDirection Direction

type Direction
    = Left
    | Right
    | Other
