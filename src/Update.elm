module Update exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDownDirection direction ->
            updateKeyDownDirection direction model

        ResizeWindow width height ->
            updateResizeWindow width height model

        Tick delta ->
            updateTick delta model


updateKeyDownDirection : Messages.Direction -> Model -> ( Model, Cmd Msg )
updateKeyDownDirection direction model =
    case direction of
        Messages.Left ->
            ( { model
                | velocity = model.velocity - model.config.acceleration
              }
            , Cmd.none
            )

        Messages.Right ->
            ( { model
                | velocity = model.velocity + model.config.acceleration
              }
            , Cmd.none
            )

        Messages.Other ->
            ( model
            , Cmd.none
            )


updateResizeWindow : Float -> Float -> Model -> ( Model, Cmd Msg )
updateResizeWindow w h model =
    let
        ratio =
            w / h

        config =
            model.config

        -- mainSize
        ratiomainSize =
            config.mainSize.width / config.mainSize.height

        mainSizeWidth =
            if ratio < ratiomainSize then
                w

            else
                h * ratiomainSize

        ratioWidth =
            mainSizeWidth / config.mainSize.width

        mainSizeHeight =
            config.mainSize.height * ratioWidth

        mainSize =
            { width = mainSizeWidth, height = mainSizeHeight }

        -- position
        position =
            { x = model.position.x * ratioWidth
            , y = model.position.y * ratioWidth
            }

        -- velocity
        velocity =
            model.velocity * ratioWidth

        -- acceleration
        acceleration =
            config.acceleration * ratioWidth

        -- friction
        friction =
            config.friction * ratioWidth

        -- fontSize
        fontSize =
            config.fontSize * ratioWidth
    in
    ( { model
        | position = position
        , velocity = velocity
        , config =
            { config
                | acceleration = acceleration
                , friction = friction
                , mainSize = mainSize
                , fontSize = fontSize
            }
      }
    , Cmd.none
    )


updateTick : Float -> Model -> ( Model, Cmd Msg )
updateTick delta model =
    let
        position =
            { x = model.position.x + model.velocity * delta / 1000
            , y = model.position.y
            }

        velocity =
            if model.velocity > model.config.friction then
                model.velocity - model.config.friction

            else if model.velocity < -model.config.friction then
                model.velocity + model.config.friction

            else
                0
    in
    ( { model
        | position = position
        , velocity = velocity
      }
    , Cmd.none
    )
