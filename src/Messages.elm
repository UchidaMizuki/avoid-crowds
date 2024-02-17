module Messages exposing (..)

import Model
import Time


type Msg
    = Now Time.Posix
    | Resize Model.Size
    | OpponentsDelta Int
    | AnimationFrame Time.Posix
    | KeyDownDirection Model.Direction
    | AddOpponent Model.Agent
