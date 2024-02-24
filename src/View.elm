module View exposing (..)

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Time
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
        , Background.color <| Element.fromRgb255 model.view.color2
        ]
    <|
        Element.column
            [ Element.centerX ]
            [ viewHeader model
            , viewGame model
            ]


viewHeader : Model -> Element Msg
viewHeader model =
    let
        backGropundColor =
            if model.player.agent.bump then
                model.view.color5

            else
                model.view.color4
    in
    Element.el
        [ Element.width <| Element.px <| boxZoom model model.view.boxWidth
        , Element.height <| Element.px <| boxZoom model model.view.headerHeight
        , Element.centerX
        , Element.centerY
        , Background.color <| Element.fromRgb255 backGropundColor
        , Font.family [ model.view.headerFontFamily ]
        , Font.size <| boxZoom model model.view.headerFontSize
        , Font.color <| Element.fromRgb255 model.view.color1
        ]
    <|
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.padding <| boxZoom model model.view.headerPadding
            ]
            [ Element.text "Avoid Crowds"
            , Element.el [ Element.alignRight ] <|
                Element.text <|
                    (String.fromInt <| floor model.score)
                        ++ " m"
            ]


boxZoom : Model -> Float -> Int
boxZoom model size =
    floor (model.view.boxZoom * size)


viewGame : Model -> Element Msg
viewGame model =
    let
        gameSizeWidth =
            boxZoom model model.view.boxWidth

        gameSizeHeight =
            boxZoom model model.view.gameHeight
    in
    Element.el
        [ Element.width <| Element.px gameSizeWidth
        , Element.height <| Element.px gameSizeHeight
        , Element.centerX
        , Element.alignBottom
        , Background.color <| Element.fromRgb255 model.view.color1
        ]
    <|
        Element.html <|
            TypedSvg.svg
                [ Attributes.viewBox 0 0 (toFloat gameSizeWidth) (toFloat gameSizeHeight)
                ]
            <|
                viewGameGround model
                    ++ viewGamePlayer model
                    :: viewGameOpponents model


viewGameGround : Model -> List (Svg Msg)
viewGameGround model =
    let
        gameSizeWidth =
            boxZoom model model.view.boxWidth

        gameSizeHeight =
            boxZoom model model.view.gameHeight

        distance =
            boxZoom model <| Utils.distance model.player.agent.velocity.y <| Time.posixToMillis model.time

        gameGroundDashedLength =
            boxZoom model model.view.gameGroundDashedLength

        gameGroundDashedStart =
            modBy gameGroundDashedLength distance - gameGroundDashedLength

        gameGroundDashedNumber =
            gameSizeHeight // gameGroundDashedLength + 1
    in
    List.range 1 gameGroundDashedNumber
        |> List.map
            (\i ->
                let
                    gameGroundDashedFrom =
                        toFloat <| gameGroundDashedStart + gameGroundDashedLength * (i - 1)

                    gameGroundDashedTo =
                        gameGroundDashedFrom + toFloat gameGroundDashedLength / 2
                in
                TypedSvg.line
                    [ Attributes.x1 <| Types.px <| (toFloat gameSizeWidth / 2)
                    , Attributes.y1 <| Types.px <| gameGroundDashedFrom
                    , Attributes.x2 <| Types.px <| (toFloat gameSizeWidth / 2)
                    , Attributes.y2 <| Types.px <| gameGroundDashedTo
                    , Attributes.stroke <| Types.Paint <| Utils.fromRgb255 model.view.color2
                    , Attributes.strokeWidth <| Types.Px <| toFloat <| boxZoom model model.view.gameGroundDashedWidth
                    ]
                    []
            )


viewGamePlayer : Model -> Svg Msg
viewGamePlayer model =
    let
        color =
            if model.player.agent.bump then
                model.view.color5

            else
                model.view.color4
    in
    TypedSvg.circle
        [ Attributes.cx <| Types.px <| toFloat <| boxZoom model model.player.agent.position.x
        , Attributes.cy <| Types.px <| toFloat <| boxZoom model model.view.gamePlayerPositionY
        , Attributes.r <| Types.px <| toFloat <| boxZoom model model.player.agent.radius
        , Attributes.fill <| Types.Paint <| Utils.fromRgb255 color
        ]
        []


viewGameOpponents : Model -> List (Svg Msg)
viewGameOpponents model =
    List.map
        (\agent ->
            let
                color =
                    if agent.bump then
                        model.view.color5

                    else
                        model.view.color3
            in
            TypedSvg.circle
                [ Attributes.cx <| Types.px <| toFloat <| boxZoom model agent.position.x
                , Attributes.cy <| Types.px <| toFloat <| boxZoom model <| model.view.gamePlayerPositionY + model.player.agent.position.y - agent.position.y
                , Attributes.r <| Types.px <| toFloat <| boxZoom model agent.radius
                , Attributes.fill <| Types.Paint <| Utils.fromRgb255 color
                ]
                []
        )
        model.opponents.agents
