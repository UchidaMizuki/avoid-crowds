module View exposing (..)

import Circle2d
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Geometry.Svg as Svg
import Html exposing (Html)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Pixels
import Point2d
import Svg exposing (Svg)
import Svg.Attributes as Attributes


view : Model -> Html Msg
view model =
    Element.layout
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color <| Element.fromRgb255 model.config.bodyBackgroundColor
        , Font.family [ model.config.fontFamily ]
        , Font.size <| floor model.config.fontSize
        ]
    <|
        viewMain model


viewMain : Model -> Element Msg
viewMain model =
    Element.el
        [ Element.width <| Element.px <| floor model.config.mainSize.width
        , Element.height <| Element.px <| floor model.config.mainSize.height
        , Background.color <| Element.fromRgb255 model.config.mainBackgroundColor
        , Element.centerX
        ]
    <|
        Element.html <|
            Svg.svg
                [ Attributes.viewBox <|
                    "0 0 "
                        ++ (String.fromInt <| floor model.config.mainSize.width)
                        ++ " "
                        ++ (String.fromInt <| floor model.config.mainSize.height)
                ]
                [ viewPlayer model
                ]


viewPlayer : Model -> Svg Msg
viewPlayer model =
    Svg.circle2d
        [ Attributes.fill "orange"
        , Attributes.stroke "blue"
        , Attributes.strokeWidth "2"
        ]
        (Circle2d.withRadius (Pixels.pixels 10)
            (Point2d.pixels model.position.x model.position.y)
        )



-- lineSegment : Svg msg
-- lineSegment =
--     Svg.lineSegment2d
--         [ Attributes.stroke "blue"
--         , Attributes.strokeWidth "5"
--         ]
--         (LineSegment2d.from
--             (Point2d.pixels 100 100)
--             (Point2d.pixels 200 200)
--         )
