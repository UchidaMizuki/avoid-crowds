module Init exposing (..)

import Browser.Dom
import Element exposing (px, rgb255)
import Messages exposing (Direction(..), Msg(..))
import Model exposing (Config, Model)
import Task exposing (Task)


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, getWindowSize )


defaultModel : Model
defaultModel =
    { position = { x = 60, y = 60 }
    , direction = Other
    , config = defaultConfig
    }



-- https://colorhunt.co/palette/f4f4f2e8e8e8bbbfca495464


defaultConfig : Config
defaultConfig =
    { bodyBackgroundColor = rgb255 244 244 242
    , windowSize = { width = 360, height = 840 }
    , windowSpacing = 30
    , mainSize = { width = 360, height = 720 }
    , mainBackgroundColor = rgb255 232 232 232
    , controlsActiveBackgroundColor = rgb255 232 232 232
    , controlsPressedBackgroundColor = rgb255 187 191 202
    }


getWindowSize : Cmd Msg
getWindowSize =
    Browser.Dom.getViewport
        |> Task.map (\{ viewport } -> ( viewport.width, viewport.height ))
        |> Task.perform (\( width, height ) -> ResizeWindow width height)
