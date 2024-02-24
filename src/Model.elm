module Model exposing (..)

import Element.Font as Font
import Time


type alias Model =
    { time : Time.Posix
    , player : Player
    , opponents : Opponents
    , score : Float
    , acceleration : Float
    , friction : Float
    , pause : Bool
    , pauseDelta : Int
    , view : View
    }


type alias Player =
    { movesLengthMax : Int
    , agent : Agent
    }


type alias Agent =
    { time : Time.Posix
    , radius : Float
    , position : Vector
    , velocity : Vector
    , moves : List Move
    , bump : Bool
    }


type alias Vector =
    { x : Float
    , y : Float
    }


type alias Move =
    { delta : Int
    , direction : Direction
    }


type Direction
    = Left
    | Right
    | Other


type alias Opponents =
    { delta : Int
    , deltaMin : Int
    , rate : Float
    , radius : Float
    , movesLengthMax : Int
    , agents : List Agent
    }


type alias View =
    { boxZoom : Float
    , boxWidth : Float
    , headerHeight : Float
    , headerFontFamily : Font.Font
    , headerFontSize : Float
    , headerPadding : Float
    , gameHeight : Float
    , gameGroundDashedLength : Float
    , gameGroundDashedWidth : Float
    , gamePlayerPositionY : Float
    , color1 : Color
    , color2 : Color
    , color3 : Color
    , color4 : Color
    , color5 : Color
    }


type alias Color =
    { red : Int
    , green : Int
    , blue : Int
    , alpha : Float
    }
