module Subscriptions exposing (..)

import Browser.Events as Events
import Json.Decode as Decode
import Messages exposing (Msg(..))
import Model exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Events.onResize <| \width height -> Resize { width = toFloat width, height = toFloat height }
        , Events.onAnimationFrame AnimationFrame
        , Events.onKeyDown (Decode.map KeyDownDirection keyDecoder)
        ]


keyDecoder : Decode.Decoder Model.Direction
keyDecoder =
    Decode.map toDirection (Decode.field "key" Decode.string)


toDirection : String -> Model.Direction
toDirection key =
    case key of
        "ArrowLeft" ->
            Model.Left

        "ArrowRight" ->
            Model.Right

        _ ->
            Model.Other
