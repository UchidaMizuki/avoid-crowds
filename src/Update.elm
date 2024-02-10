module Update exposing (..)

import Messages exposing (Direction(..), Msg(..))
import Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDownDirection direction ->
            updatePositionKeyDown direction model

        KeyUpDirection direction ->
            resetDirection direction model

        ButtonPressDirection direction ->
            updatePositionButtonPress direction model


updatePositionKeyDown : Direction -> Model -> ( Model, Cmd Msg )
updatePositionKeyDown direction model =
    case direction of
        Left ->
            ( { model
                | position = { x = model.position.x - 1, y = model.position.y }
                , direction = Left
              }
            , Cmd.none
            )

        Right ->
            ( { model
                | position = { x = model.position.x + 1, y = model.position.y }
                , direction = Right
              }
            , Cmd.none
            )

        Other ->
            ( { model
                | direction = Other
              }
            , Cmd.none
            )


resetDirection : Direction -> Model -> ( Model, Cmd Msg )
resetDirection direction model =
    ( if direction == model.direction then
        { model | direction = Other }

    else
        model
    , Cmd.none
    )


updatePositionButtonPress : Direction -> Model -> ( Model, Cmd Msg )
updatePositionButtonPress direction model =
    case direction of
        Left ->
            ( { model
                | position = { x = model.position.x - 1, y = model.position.y }
              }
            , Cmd.none
            )

        Right ->
            ( { model
                | position = { x = model.position.x + 1, y = model.position.y }
              }
            , Cmd.none
            )

        Other ->
            ( model
            , Cmd.none
            )
