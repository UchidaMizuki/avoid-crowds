module View exposing (..)

import Element exposing (Element, alignRight, centerX, centerY, column, el, explain, fill, fillPortion, height, layout, padding, paddingXY, rgb255, row, spacing, spacingXY, text, width)
import Element.Background as Background
import Element.Input as Input
import Html exposing (Html)
import Messages exposing (Direction(..), Msg(..))
import Model exposing (Model)


view : Model -> Html Msg
view model =
    layout [ Background.color model.config.bodyBackgroundColor ] <| viewBox model


viewBox : Model -> Element Msg
viewBox model =
    column
        [ width model.config.boxWidth
        , height model.config.boxHeight
        , centerX
        , centerY
        , spacingXY 0 30
        ]
        [ viewMain model
        , viewControls model
        ]


viewMain : Model -> Element Msg
viewMain model =
    el
        [ width fill
        , height model.config.mainHeight
        , Background.color model.config.mainBackgroundColor
        , centerX
        ]
    <|
        text <|
            String.fromInt model.position.x


viewControls : Model -> Element Msg
viewControls model =
    row
        [ width fill
        , height fill
        , spacingXY 30 0
        ]
        [ viewControlsLeft model
        , el
            [ width <| fillPortion 4
            , height fill
            , Background.color model.config.controlsActiveBackgroundColor
            ]
          <|
            text "TODO"
        , viewControlsRight model
        ]


viewControlsLeft : Model -> Element Msg
viewControlsLeft model =
    Input.button
        [ width <| fillPortion 3
        , height fill
        , if model.direction == Left then
            Background.color model.config.controlsPressedBackgroundColor

          else
            Background.color model.config.controlsActiveBackgroundColor
        , Element.mouseDown
            [ Background.color model.config.controlsPressedBackgroundColor ]
        ]
        { onPress = Just (ButtonPressDirection Left)
        , label = el [ centerX ] <| text "🡨"
        }


viewControlsRight : Model -> Element Msg
viewControlsRight model =
    Input.button
        [ width <| fillPortion 3
        , height fill
        , if model.direction == Right then
            Background.color model.config.controlsPressedBackgroundColor

          else
            Background.color model.config.controlsActiveBackgroundColor
        , Element.mouseDown
            [ Background.color model.config.controlsPressedBackgroundColor ]
        ]
        { onPress = Just (ButtonPressDirection Right)
        , label = el [ centerX ] <| text "🡪"
        }



-- [ Background.color model.config.pageBackgroundColor
-- , width <| px 864
-- , height <| px 864
-- , centerX
-- , centerY
-- ]
-- myRowOfStuff : Element msg
-- myRowOfStuff =
--     row [ width fill, centerY, spacing 30 ]
--         [ myElement
--         , myElement
--         , el [ alignRight ] myElement
--         ]
-- myElement : Element msg
-- myElement =
--     el
--         [ Background.color (rgb255 240 0 245)
--         , Font.color (rgb255 255 255 255)
--         , Border.rounded 3
--         , padding 30
--         ]
--         (text "stylish!")
-- let
--     direction =
--         case model.direction of
--             Just Up ->
--                 "Up"
--             Just Down ->
--                 "Down"
--             Just Left ->
--                 "Left"
--             Just Right ->
--                 "Right"
--             Nothing ->
--                 "None"
-- in
-- [ Svg.svg
--     [ SvgAttrs.width <| String.fromInt model.config.boxWidth
--     , SvgAttrs.height <| String.fromInt model.config.boxHeight
--     , SvgAttrs.viewBox model.config.boxViewBox
--     ]
--     [ Svg.circle
--         [ SvgAttrs.cx <| String.fromInt model.position.x
--         , SvgAttrs.cy <| String.fromInt model.position.y
--         , SvgAttrs.r "50"
--         ]
--         []
--     , Svg.rect
--         [ SvgAttrs.x "0"
--         , SvgAttrs.y "0"
--         , SvgAttrs.width <| String.fromInt model.config.boxWidth
--         , SvgAttrs.height <| String.fromInt model.config.boxHeight
--         , SvgAttrs.rx "10"
--         , SvgAttrs.ry "10"
--         ]
--         []
--     ]
-- ]
