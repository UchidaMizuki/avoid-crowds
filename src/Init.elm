module Init exposing (..)

import Element exposing (px, rgb255)
import Messages exposing (Msg)
import Model exposing (Config, Model)
import Messages exposing (Direction(..))


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, Cmd.none )


defaultModel : Model
defaultModel =
    { position = { x = 60, y = 60 }
    , direction = Other
    , config = defaultConfig
    }


-- defaultControls : Controls
-- defaultControls =
--     { left = Active
--     , right = Active
--     }



-- https://colorhunt.co/palette/f4f4f2e8e8e8bbbfca495464


defaultConfig : Config
defaultConfig =
    { bodyBackgroundColor = rgb255 244 244 242
    , boxWidth = px 360
    , boxHeight = px 840
    , mainWidth = px 360
    , mainHeight = px 720
    , mainBackgroundColor = rgb255 232 232 232
    , controlsActiveBackgroundColor = rgb255 232 232 232
    , controlsPressedBackgroundColor = rgb255 187 191 202
    }
