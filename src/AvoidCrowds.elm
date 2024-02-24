module AvoidCrowds exposing (..)

import Browser
import Init exposing (init)
import Msg exposing (Msg)
import Model exposing (Model)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
