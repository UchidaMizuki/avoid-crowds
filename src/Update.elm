module Update exposing (..)

import Html.Attributes exposing (width)
import Messages exposing (Direction(..), Msg(..))
import Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDownDirection direction ->
            updateKeyDownDirection direction model

        KeyUpDirection direction ->
            updateKeyUpDirection direction model

        ButtonPressDirection direction ->
            updateButtonPressDirection direction model

        ResizeWindow width height ->
            updateResizeWindow width height model


updateKeyDownDirection : Direction -> Model -> ( Model, Cmd Msg )
updateKeyDownDirection direction model =
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


updateKeyUpDirection : Direction -> Model -> ( Model, Cmd Msg )
updateKeyUpDirection direction model =
    ( if direction == model.direction then
        { model | direction = Other }

      else
        model
    , Cmd.none
    )


updateButtonPressDirection : Direction -> Model -> ( Model, Cmd Msg )
updateButtonPressDirection direction model =
    case direction of
        Left ->
            ( { model | position = { x = model.position.x - 1, y = model.position.y } }
            , Cmd.none
            )

        Right ->
            ( { model | position = { x = model.position.x + 1, y = model.position.y } }
            , Cmd.none
            )

        Other ->
            ( model, Cmd.none )


updateResizeWindow : Float -> Float -> Model -> ( Model, Cmd Msg )
updateResizeWindow width height model =
    let
        ratio =
            width / height

        config =
            model.config

        -- windowSize
        ratiowindowSize =
            config.windowSize.width / config.windowSize.height

        windowSizeWidth =
            if ratio < ratiowindowSize then
                width

            else
                height * ratiowindowSize

        windowSizeHeight =
            windowSizeWidth / ratiowindowSize

        windowSize =
            { width = windowSizeWidth, height = windowSizeHeight }
        
        windowSpacing =
            config.windowSpacing * windowSizeWidth / config.windowSize.width

        -- mainSize
        ratioMainSize =
            config.mainSize.width / config.mainSize.height

        mainSizeWidth =
            windowSizeWidth

        mainSizeHeight =
            mainSizeWidth / ratioMainSize

        mainSize =
            { width = mainSizeWidth, height = mainSizeHeight }
    in
    ( { model
        | config =
            { config
                | windowSize = windowSize
                , windowSpacing = windowSpacing
                , mainSize = mainSize
            }
      }
    , Cmd.none
    )
