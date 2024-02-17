module Utils exposing (..)

import Color
import Model
import Random


fromRgb255 : Model.Color -> Color.Color
fromRgb255 color =
    Color.rgb255 color.red color.green color.blue


exponential : Float -> Random.Generator Float
exponential lambda =
    Random.float 0 1
        |> Random.map (\x -> -(logBase e x) / lambda)


distance : Float -> Int -> Float
distance velocity delta =
    velocity * toFloat delta / 1000
