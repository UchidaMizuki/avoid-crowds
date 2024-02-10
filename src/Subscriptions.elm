module Subscriptions exposing (..)

import Browser.Events as Events
import Json.Decode as Decode
import Messages exposing (Direction(..), Msg(..))
import Model exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Events.onKeyDown (Decode.map KeyDownDirection keyDecoder)
        , Events.onKeyUp (Decode.map KeyUpDirection keyDecoder)
        ]


keyDecoder : Decode.Decoder Direction
keyDecoder =
    Decode.map toDirection (Decode.field "key" Decode.string)


toDirection : String -> Direction
toDirection key =
    case key of
        "ArrowLeft" ->
            Left

        "ArrowRight" ->
            Right

        _ ->
            Other
