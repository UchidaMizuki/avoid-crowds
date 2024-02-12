module Model exposing (..)

import Element.Font as Font


type alias Model =
    { distance : Float
    , player : Player
    , opponents : List Player
    , acceleration : Float
    , friction : Float
    , moveDistance : Float
    , moveLengthMax : Int
    , config : Config
    }


type alias Player =
    { position : Position
    , velocity : Velocity
    , move : List Move
    }


type alias Position =
    { x : Float
    , y : Float
    }


type alias Velocity =
    Position


type alias Move =
    { distanceDelta : Float
    , direction : Direction
    }


type Direction
    = Left
    | Right
    | Other


type alias Config =
    { backgroundColor : Color
    , size : Size
    , zoom : Float
    , padding : Float
    , fontFamily : Font.Font
    , fontSize : Float
    , fontColor : Color
    , headerBackgroundColor : Color
    , gameSize : Size
    , gameBackgroundColor : Color
    , groundDashedLength : Float
    , groundDashedWidth : Float
    , groundDashedColor : Color
    , playerRadius : Float
    , playerFillColor : Color
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
