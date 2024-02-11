module Messages exposing (..)


type Msg
    = KeyDownDirection Direction
    | ResizeWindow Float Float
    | Tick Float


type Direction
    = Left
    | Right
    | Other
