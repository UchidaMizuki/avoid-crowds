module Init exposing (..)

import Browser.Dom
import Element.Font as Font
import Model exposing (Model)
import Msg exposing (Msg(..))
import Random
import Task
import Time
import Utils


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel
    , Cmd.batch
        [ initNow initModel
        , initResize initModel
        , initOpponentsDelta initModel
        ]
    )


initModel : Model
initModel =
    { time = Time.millisToPosix 0
    , player = initModelPlayer
    , opponents = initModelOpponents
    , score = 0 
    , acceleration = 1 / 2
    , friction = 1 / 8
    , pause = False
    , pauseDelta = 0
    , view = initModelView
    }


initModelPlayer : Model.Player
initModelPlayer =
    { movesLengthMax = 1000
    , agent = initModelPlayerAgent
    }


initModelPlayerAgent : Model.Agent
initModelPlayerAgent =
    { time = Time.millisToPosix 0
    , radius = 0.25
    , position = { x = 5, y = 0 }
    , velocity = { x = 0, y = 1 }
    , moves = []
    , bump = False
    }


initModelOpponents : Model.Opponents
initModelOpponents =
    { delta = 0
    , deltaMin = 250
    , rate = 1 / 500
    , radius = 0.25
    , movesLengthMax = 100
    , agents = []
    }



-- https://colorhunt.co/palette/f4f4f2e8e8e8bbbfca495464
-- https://colorhunt.co/palette/d04848f3b95ffde7676895d2


initModelView : Model.View
initModelView =
    { boxZoom = 1
    , boxWidth = 10
    , headerHeight = 1.25
    , headerFontFamily = Font.external { name = "Poppins", url = "https://fonts.googleapis.com/css?family=Poppins" }
    , headerFontSize = 0.675
    , headerPadding = 0.25
    , gameHeight = 10
    , gameGroundDashedLength = 2
    , gameGroundDashedWidth = 0.125
    , gamePlayerPositionY = 8.75
    , footerHeight = 0.5
    , footerFontSize = 0.25
    , color1 = { red = 244, green = 244, blue = 242, alpha = 1 }
    , color2 = { red = 232, green = 232, blue = 232, alpha = 1 }
    , color3 = { red = 187, green = 191, blue = 202, alpha = 1 }
    , color4 = { red = 73, green = 84, blue = 100, alpha = 1 }
    , color5 = { red = 208, green = 72, blue = 72, alpha = 1 }
    }


initNow : Model -> Cmd Msg
initNow _ =
    Time.now
        |> Task.perform Now


initResize : Model -> Cmd Msg
initResize _ =
    Browser.Dom.getViewport
        |> Task.map (\{ viewport } -> ( viewport.width, viewport.height ))
        |> Task.perform (\( w, h ) -> Resize w h)


initOpponentsDelta : Model -> Cmd Msg
initOpponentsDelta model =
    Random.generate OpponentsDelta <|
        Random.map (max model.opponents.deltaMin << floor) <|
            Utils.exponential model.opponents.rate
