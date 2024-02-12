module Utils exposing (..)

import Color
import Model


fromRgb255 : Model.Color -> Color.Color
fromRgb255 color =
    Color.rgb255 color.red color.green color.blue
