module Model exposing (..)

import Element exposing (Color, Length)
import Messages exposing (Direction)


type alias Model =
    { position : Position
    , direction : Direction
    , config : Config
    }


type alias Position =
    { x : Int
    , y : Int
    }


type alias Config =
    { bodyBackgroundColor : Color
    , boxWidth : Length
    , boxHeight : Length
    , mainWidth : Length
    , mainHeight : Length
    , mainBackgroundColor : Color
    , controlsActiveBackgroundColor : Color
    , controlsPressedBackgroundColor : Color
    }
