module Init exposing (..)

import Browser.Dom
import Element.Font as Font
import Messages exposing (Msg(..))
import Model exposing (Config, Model)
import Task


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, getWindowSize )


defaultModel : Model
defaultModel =
    { position = { x = 1 / 2, y = 7 / 8 }
    , velocity = 0
    , config = defaultConfig
    }



-- https://colorhunt.co/palette/f4f4f2e8e8e8bbbfca495464


defaultConfig : Config
defaultConfig =
    { acceleration = 1 / 16
    , friction = 1 / 64
    , bodyBackgroundColor = { red = 232, green = 232, blue = 232, alpha = 1 }
    , mainSize = { width = 1, height = 1 }
    , mainBackgroundColor = { red = 244, green = 244, blue = 242, alpha = 1 }
    , fontFamily =
        Font.external
            { name = "Poppins"
            , url = "https://fonts.googleapis.com/css?family=Poppins"
            }
    , fontSize = 1 / 16
    }


getWindowSize : Cmd Msg
getWindowSize =
    Browser.Dom.getViewport
        |> Task.map (\{ viewport } -> ( viewport.width, viewport.height ))
        |> Task.perform (\( width, height ) -> ResizeWindow width height)
