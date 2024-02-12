module Messages exposing (..)

import Model 

type Msg
    = KeyDownDirection Model.Direction
    | ResizeWindow Float Float
    | Tick Float
