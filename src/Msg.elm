module Msg exposing (..)

import Model
import Time
import Browser.Events as Events


type Msg
    = Now Time.Posix
    | Resize Float Float
    | OpponentsDelta Int
    | AnimationFrame Time.Posix
    | KeyDownDirection Model.Direction
    | AddOpponent Model.Agent
    | VisibilityChange Events.Visibility
    | PauseDelta Int
