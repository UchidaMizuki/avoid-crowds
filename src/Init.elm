module Init exposing (..)

import Browser.Dom
import Element.Font as Font
import Messages exposing (Msg(..))
import Model exposing (Model)
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
    , acceleration = 5
    , friction = 2.5
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
    }


initModelOpponents : Model.Opponents
initModelOpponents =
    { delta = 0
    , deltaMin = 250
    , rate = 0.0025
    , radius = 0.25
    , movesLengthMax = 100
    , agents = []
    }



-- https://colorhunt.co/palette/f4f4f2e8e8e8bbbfca495464
-- https://colorate.azurewebsites.net


initModelView : Model.View
initModelView =
    { zoom = 1
    , bodyBackgroundColor = colorGray
    , headerSize = { width = 10, height = 1.25 }
    , headerBackgroundColor = colorGrayishBlue
    , headerFontFamily = Font.external { name = "Poppins", url = "https://fonts.googleapis.com/css?family=Poppins" }
    , headerFontColor = colorWhite
    , headerFontSize = 0.675
    , headerPadding = 0.25
    , gameSize = { width = 10, height = 10 }
    , gameBackgroundColor = colorWhite
    , gameGroundDashedLength = 2
    , gameGroundDashedWidth = 0.125
    , gameGroundDashedColor = colorGray
    , gamePlayerPositionY = 8.75
    , gamePlayerFillColor = colorGrayishBlue
    , gameOpponentsFillColor = colorPaleNavy
    }


colorWhite : Model.Color
colorWhite =
    { red = 244, green = 244, blue = 242, alpha = 1 }


colorGray : Model.Color
colorGray =
    { red = 232, green = 232, blue = 232, alpha = 1 }


colorPaleNavy : Model.Color
colorPaleNavy =
    { red = 187, green = 191, blue = 202, alpha = 1 }


colorGrayishBlue : Model.Color
colorGrayishBlue =
    { red = 73, green = 84, blue = 100, alpha = 1 }


initNow : Model -> Cmd Msg
initNow _ =
    Time.now
        |> Task.perform Now


initResize : Model -> Cmd Msg
initResize _ =
    Browser.Dom.getViewport
        |> Task.map (\{ viewport } -> ( viewport.width, viewport.height ))
        |> Task.perform (\( w, h ) -> Resize { width = w, height = h })


initOpponentsDelta : Model -> Cmd Msg
initOpponentsDelta model =
    Random.generate OpponentsDelta <|
        Random.map (max model.opponents.deltaMin << floor) <|
            Utils.exponential model.opponents.rate
