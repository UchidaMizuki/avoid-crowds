module Model exposing (..)

import Element.Font as Font


type alias Model =
    { position : Position
    , velocity : Float
    , config : Config
    }


type alias Position =
    { x : Float
    , y : Float
    }


type alias Config =
    { acceleration : Float
    , friction : Float
    , bodyBackgroundColor : Color
    , mainSize : Size
    , mainBackgroundColor : Color
    , fontFamily : Font.Font
    , fontSize : Float
    }


type alias Color =
    { red : Int
    , green : Int
    , blue : Int
    , alpha : Float
    }

type alias Size =
    { width : Float
    , height : Float
    }
