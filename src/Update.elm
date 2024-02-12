module Update exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDownDirection direction ->
            updateKeyDownDirection model direction

        ResizeWindow width height ->
            updateResizeWindow model width height

        Tick delta ->
            updateTick model delta


updateKeyDownDirection : Model -> Model.Direction -> ( Model, Cmd Msg )
updateKeyDownDirection model direction =
    let
        player =
            model.player

        velocity =
            player.velocity

        move =
            player.move
    in
    case direction of
        Model.Left ->
            ( { model
                | player =
                    { player
                        | velocity = { velocity | x = velocity.x - model.acceleration }
                        , move = updateKeyDownDirectionMove model Model.Left move
                    }
                , moveDistance = model.distance
              }
            , Cmd.none
            )

        Model.Right ->
            ( { model
                | player =
                    { player
                        | velocity = { velocity | x = velocity.x + model.acceleration }
                        , move = updateKeyDownDirectionMove model Model.Right move
                    }
                , moveDistance = model.distance
              }
            , Cmd.none
            )

        Model.Other ->
            ( model
            , Cmd.none
            )


updateKeyDownDirectionMove : Model -> Model.Direction -> List Model.Move -> List Model.Move
updateKeyDownDirectionMove model direction move =
    List.take model.moveLengthMax <|
        { distanceDelta = model.distance - model.moveDistance, direction = direction } :: move


updateResizeWindow : Model -> Float -> Float -> ( Model, Cmd Msg )
updateResizeWindow model w h =
    let
        config =
            model.config

        zoom =
            if w / h < config.size.width / config.size.height then
                w / config.size.width

            else
                h / config.size.height
    in
    ( { model
        | config =
            { config
                | zoom = zoom
            }
      }
    , Cmd.none
    )


updateTick : Model -> Float -> ( Model, Cmd Msg )
updateTick model delta =
    let
        player =
            model.player

        position =
            player.position

        velocity =
            player.velocity

        distance =
            updateTickDistance model delta

        positionX =
            updateTickPositionX model delta

        velocityX =
            updateTickVelocityX model positionX
    in
    ( { model
        | distance = distance
        , player =
            { player
                | position = { position | x = positionX }
                , velocity = { velocity | x = velocityX }
            }
      }
    , Cmd.none
    )


updateTickDistance : Model -> Float -> Float
updateTickDistance model delta =
    model.distance + model.player.velocity.y * delta / 1000


updateTickPositionX : Model -> Float -> Float
updateTickPositionX model delta =
    let
        positionX =
            model.player.position.x + model.player.velocity.x * delta / 1000
    in
    if positionX < positionXMin model then
        positionXMin model

    else if positionX > positionXMax model then
        positionXMax model

    else
        positionX


updateTickVelocityX : Model -> Float -> Float
updateTickVelocityX model positionX =
    if positionX == positionXMin model || positionX == positionXMax model then
        0

    else if model.player.velocity.x > model.friction then
        model.player.velocity.x - model.friction

    else if model.player.velocity.x < -model.friction then
        model.player.velocity.x + model.friction

    else
        0


positionXMin : Model -> Float
positionXMin model =
    model.config.playerRadius


positionXMax : Model -> Float
positionXMax model =
    model.config.gameSize.width - model.config.playerRadius
