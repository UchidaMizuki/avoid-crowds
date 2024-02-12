module View exposing (..)

import Circle2d
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Geometry.Svg as Svg
import Html exposing (Html)
import LineSegment2d
import List exposing (range)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Pixels
import Point2d
import TypedSvg
import TypedSvg.Attributes as Attributes
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types as Types
import Utils


view : Model -> Html Msg
view model =
    Element.layout
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color <| Element.fromRgb255 model.config.backgroundColor
        , Font.family [ model.config.fontFamily ]
        , Font.size <| zoom model model.config.fontSize
        , Font.color <| Element.fromRgb255 model.config.fontColor
        ]
    <|
        Element.column
            [ Element.width <| Element.px <| zoom model model.config.size.width
            , Element.height <| Element.px <| zoom model model.config.size.height
            , Element.centerX
            , Element.centerY
            ]
            [ viewHeader model
            , viewGame model
            ]


viewHeader : Model -> Element Msg
viewHeader model =
    Element.el
        [ Element.width <| Element.px <| zoom model model.config.gameSize.width
        , Element.height Element.fill
        , Element.centerX
        , Element.centerY
        , Background.color <| Element.fromRgb255 model.config.headerBackgroundColor
        ]
    <|
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.padding <| zoom model model.config.padding
            ]
            [ Element.text "TODO: Title"
            , Element.el [ Element.alignRight ] <|
                Element.text <|
                    (String.fromInt <| floor model.distance)
                        ++ " m"
            ]


viewGame : Model -> Element Msg
viewGame model =
    let
        gameSizeWidth =
            zoom model model.config.gameSize.width

        gameSizeHeight =
            zoom model model.config.gameSize.height
    in
    Element.el
        [ Element.width <| Element.px gameSizeWidth
        , Element.height <| Element.px gameSizeHeight
        , Element.centerX
        , Element.alignBottom
        , Background.color <| Element.fromRgb255 model.config.gameBackgroundColor
        ]
    <|
        Element.html <|
            TypedSvg.svg
                [ Attributes.viewBox 0 0 (toFloat gameSizeWidth) (toFloat gameSizeHeight) ]
            <|
                viewGround model
                    ++ [ viewGamePlayer model ]


viewGround : Model -> List (Svg Msg)
viewGround model =
    let
        gameSizeWidth =
            zoom model model.config.gameSize.width

        gameSizeHeight =
            zoom model model.config.gameSize.height

        distance =
            zoom model model.distance

        groundDashedLength =
            zoom model model.config.groundDashedLength

        groundDashedStart =
            modBy groundDashedLength distance - groundDashedLength

        groundDashedNumber =
            gameSizeHeight // groundDashedLength + 1
    in
    range 1 groundDashedNumber
        |> List.map
            (\i ->
                let
                    groundDashedStart_ =
                        toFloat <| groundDashedStart + groundDashedLength * (i - 1)
                in
                Svg.lineSegment2d
                    [ Attributes.stroke <| Types.Paint <| Utils.fromRgb255 model.config.groundDashedColor
                    , Attributes.strokeWidth <| Types.Px <| toFloat <| zoom model model.config.groundDashedWidth
                    ]
                    (LineSegment2d.from
                        (Point2d.pixels (toFloat gameSizeWidth / 2) groundDashedStart_)
                        (Point2d.pixels (toFloat gameSizeWidth / 2) (groundDashedStart_ + toFloat groundDashedLength / 2))
                    )
            )


viewGamePlayer : Model -> Svg Msg
viewGamePlayer model =
    Svg.circle2d
        [ Attributes.fill <| Types.Paint <| Utils.fromRgb255 model.config.playerFillColor ]
    <|
        Circle2d.withRadius (Pixels.pixels <| toFloat <| zoom model model.config.playerRadius)
            (Point2d.pixels (toFloat <| zoom model model.player.position.x) (toFloat <| zoom model model.player.position.y))


zoom : Model -> Float -> Int
zoom model size =
    floor (model.config.zoom * size)
