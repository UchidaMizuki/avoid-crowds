module View exposing (..)

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Messages exposing (Msg(..))
import Model exposing (Model)
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
        , Background.color <| Element.fromRgb255 model.view.bodyBackgroundColor
        ]
    <|
        Element.column
            [ Element.centerX
            ]
            [ viewHeader model
            , viewGame model
            ]


viewHeader : Model -> Element Msg
viewHeader model =
    Element.el
        [ Element.width <| Element.px <| zoom model model.view.headerSize.width
        , Element.height <| Element.px <| zoom model model.view.headerSize.height
        , Element.centerX
        , Element.centerY
        , Background.color <| Element.fromRgb255 model.view.headerBackgroundColor
        , Font.family [ model.view.headerFontFamily ]
        , Font.size <| zoom model model.view.headerFontSize
        , Font.color <| Element.fromRgb255 model.view.headerFontColor
        ]
    <|
        Element.row
            [ Element.width Element.fill
            , Element.centerY
            , Element.padding <| zoom model model.view.headerPadding
            ]
            [ Element.text "Avoid Crowds"
            , Element.el [ Element.alignRight ] <|
                Element.text <|
                    (String.fromInt <| floor model.player.agent.position.y)
                        ++ " m"
            ]


zoom : Model -> Float -> Int
zoom model size =
    floor (model.view.zoom * size)


viewGame : Model -> Element Msg
viewGame model =
    let
        gameSizeWidth =
            zoom model model.view.gameSize.width

        gameSizeHeight =
            zoom model model.view.gameSize.height
    in
    Element.el
        [ Element.width <| Element.px gameSizeWidth
        , Element.height <| Element.px gameSizeHeight
        , Element.centerX
        , Element.alignBottom
        , Background.color <| Element.fromRgb255 model.view.gameBackgroundColor
        ]
    <|
        Element.html <|
            TypedSvg.svg
                [ Attributes.viewBox 0 0 (toFloat gameSizeWidth) (toFloat gameSizeHeight)
                ]
            <|
                viewGameGround model
                    ++ viewGamePlayer model :: viewGameOpponents model


viewGameGround : Model -> List (Svg Msg)
viewGameGround model =
    let
        gameSizeWidth =
            zoom model model.view.gameSize.width

        gameSizeHeight =
            zoom model model.view.gameSize.height

        distance =
            zoom model <| Utils.distance model.player.agent.velocity.y <| Time.posixToMillis model.time

        gameGroundDashedLength =
            zoom model model.view.gameGroundDashedLength

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
                    , Attributes.stroke <| Types.Paint <| Utils.fromRgb255 model.view.gameGroundDashedColor
                    , Attributes.strokeWidth <| Types.Px <| toFloat <| zoom model model.view.gameGroundDashedWidth
                    ]
                    []
            )


viewGamePlayer : Model -> Svg Msg
viewGamePlayer model =
    TypedSvg.circle
        [ Attributes.cx <| Types.px <| toFloat <| zoom model model.player.agent.position.x
        , Attributes.cy <| Types.px <| toFloat <| zoom model model.view.gamePlayerPositionY
        , Attributes.r <| Types.px <| toFloat <| zoom model model.player.agent.radius
        , Attributes.fill <| Types.Paint <| Utils.fromRgb255 model.view.gamePlayerFillColor
        ]
        []


viewGameOpponents : Model -> List (Svg Msg)
viewGameOpponents model =
    List.map
        (\agent ->
            TypedSvg.circle
                [ Attributes.cx <| Types.px <| toFloat <| zoom model agent.position.x
                , Attributes.cy <| Types.px <| toFloat <| zoom model <| model.view.gamePlayerPositionY + model.player.agent.position.y - agent.position.y
                , Attributes.r <| Types.px <| toFloat <| zoom model agent.radius
                , Attributes.fill <| Types.Paint <| Utils.fromRgb255 model.view.gameOpponentsFillColor
                ]
                []
        )
        model.opponents.agents
