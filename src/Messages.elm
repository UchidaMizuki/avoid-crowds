module Messages exposing (..)


type Msg
    = KeyDownDirection Direction
    | KeyUpDirection Direction
    | ButtonPressDirection Direction
    | ResizeWindow Float Float


type Direction
    = Left
    | Right
    | Other
