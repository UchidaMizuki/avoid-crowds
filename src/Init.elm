module Init exposing (..)

import Browser.Dom
import Element.Font as Font
import Messages exposing (Msg(..))
import Model exposing (Model)
import Task


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, getWindowSize )


defaultModel : Model
defaultModel =
    { distance = 0
    , player =
        { position = { x = 5, y = 8.75 }
        , velocity = { x = 0, y = 1 }
        , move = []
        }
    , opponents = []
    , acceleration = 2
    , friction = 0.5
    , moveDistance = 0
    , moveLengthMax = 1000
    , config = defaultConfig
    }



-- https://colorhunt.co/palette/f4f4f2e8e8e8bbbfca495464


defaultConfig : Model.Config
defaultConfig =
    { backgroundColor = { red = 232, green = 232, blue = 232, alpha = 1 }
    , size = { width = 10, height = 11.25 }
    , zoom = 1
    , padding = 0.25
    , fontFamily =
        Font.external
            { name = "Poppins"
            , url = "https://fonts.googleapis.com/css?family=Poppins"
            }
    , fontSize = 0.675
    , fontColor = { red = 244, green = 244, blue = 242, alpha = 1 }
    , headerBackgroundColor = { red = 73, green = 84, blue = 100, alpha = 1 }
    , gameSize = { width = 10, height = 10 }
    , gameBackgroundColor = { red = 244, green = 244, blue = 242, alpha = 1 }
    , groundDashedLength = 2
    , groundDashedWidth = 0.125
    , groundDashedColor = { red = 232, green = 232, blue = 232, alpha = 1 } -- { red = 187, green = 191, blue = 202, alpha = 1 }
    , playerRadius = 0.25
    , playerFillColor = { red = 73, green = 84, blue = 100, alpha = 1 }
    }


getWindowSize : Cmd Msg
getWindowSize =
    Browser.Dom.getViewport
        |> Task.map (\{ viewport } -> ( viewport.width, viewport.height ))
        |> Task.perform (\( width, height ) -> ResizeWindow width height)
