module Model exposing (..)

import Element exposing (Color)
import Messages exposing (Direction)
import Element exposing (spacing)


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
    , windowSize : Size
    , windowSpacing : Float
    , mainSize : Size
    , mainBackgroundColor : Color
    , controlsActiveBackgroundColor : Color
    , controlsPressedBackgroundColor : Color
    }


type alias Size =
    { width : Float
    , height : Float
    }
