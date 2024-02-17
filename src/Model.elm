module Model exposing (..)

import Element.Font as Font
import Time


type alias Model =
    { time : Time.Posix
    , player : Player
    , opponents : Opponents
    , acceleration : Float
    , friction : Float
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
    { zoom : Float
    , bodyBackgroundColor : Color
    , headerSize : Size
    , headerBackgroundColor : Color
    , headerFontFamily : Font.Font
    , headerFontColor : Color
    , headerFontSize : Float
    , headerPadding : Float
    , gameSize : Size
    , gameBackgroundColor : Color
    , gameGroundDashedLength : Float
    , gameGroundDashedWidth : Float
    , gameGroundDashedColor : Color
    , gamePlayerPositionY : Float
    , gamePlayerFillColor : Color
    , gameOpponentsFillColor : Color
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
