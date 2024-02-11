module Subscriptions exposing (..)

import Browser.Events as Events
import Json.Decode as Decode
import Messages exposing (Msg(..))
import Model exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Events.onKeyDown (Decode.map KeyDownDirection keyDecoder)
        , Events.onResize <| \width height -> ResizeWindow (toFloat width) (toFloat height)
        , Events.onAnimationFrameDelta Tick 
        ]


keyDecoder : Decode.Decoder Messages.Direction
keyDecoder =
    Decode.map toDirection (Decode.field "key" Decode.string)


toDirection : String -> Messages.Direction
toDirection key =
    case key of
        "ArrowLeft" ->
            Messages.Left

        "ArrowRight" ->
            Messages.Right

        _ ->
            Messages.Other
