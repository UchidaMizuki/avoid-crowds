module Update exposing (..)

import Init
import Messages exposing (Msg(..))
import Model exposing (Model)
import Random
import Time
import Utils
import View exposing (view)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Now time ->
            updateNow model time

        Resize size ->
            updateResize model size

        OpponentsDelta delta ->
            updateOpponentsDelta model delta

        AnimationFrame time ->
            updateAnimationFrame model time

        KeyDownDirection direction ->
            updateKeyDownDirection model direction

        AddOpponent agent ->
            updateAddOpponent model agent


updateNow : Model -> Time.Posix -> ( Model, Cmd Msg )
updateNow model time =
    let
        player =
            model.player

        agent =
            player.agent
    in
    ( { model
        | time = time
        , player = { player | agent = { agent | time = time } }
      }
    , Cmd.none
    )


updateResize : Model -> Model.Size -> ( Model, Cmd Msg )
updateResize model size =
    let
        view =
            model.view

        viewSize =
            { width = view.gameSize.width
            , height = view.headerSize.height + view.gameSize.height
            }

        viewZoom =
            if size.width / size.height < viewSize.width / viewSize.height then
                size.width / viewSize.width

            else
                size.height / viewSize.height
    in
    ( { model | view = { view | zoom = viewZoom } }, Cmd.none )


updateOpponentsDelta : Model -> Int -> ( Model, Cmd Msg )
updateOpponentsDelta model delta =
    let
        opponents =
            model.opponents
    in
    ( { model | opponents = { opponents | delta = delta } }, Cmd.none )


updateAnimationFrame : Model -> Time.Posix -> ( Model, Cmd Msg )
updateAnimationFrame model time =
    let
        delta =
            Time.posixToMillis time - Time.posixToMillis model.time

        player =
            model.player

        opponents =
            updateAnimationFrameOpponents model model.opponents time delta
    in
    ( { model
        | time = time
        , player = { player | agent = updateAnimationFrameAgent model player.agent time delta }
        , opponents = opponents
      }
    , addOpponent model time opponents.delta
    )


addOpponent : Model -> Time.Posix -> Int -> Cmd Msg
addOpponent model time delta =
    if delta < 0 then
        let
            player =
                model.player

            agent =
                player.agent

            moves =
                agent.moves

            opponents =
                model.opponents

            radius =
                opponents.radius

            generatorAgentPositionX =
                Random.float radius (model.view.gameSize.width - radius)

            generatorAgentMoves =
                Random.int 0 (List.length moves)
                    |> Random.map (\index -> List.drop index moves |> List.take opponents.movesLengthMax)

            generatorAgent =
                Random.map2
                    (\positionX moves_ ->
                        { time = time
                        , position = { x = positionX, y = agent.position.y + model.view.gameSize.height + radius * 2 }
                        , velocity = { x = 0, y = -agent.velocity.y }
                        , radius = radius
                        , moves = moves_
                        }
                    )
                    generatorAgentPositionX
                    generatorAgentMoves
        in
        Cmd.batch
            [ Random.generate AddOpponent generatorAgent
            , Init.initOpponentsDelta model
            ]

    else
        Cmd.none


updateAnimationFrameAgent : Model -> Model.Agent -> Time.Posix -> Int -> Model.Agent
updateAnimationFrameAgent model agent time delta =
    let
        position =
            updateAnimationFramePosition model agent.radius agent.position agent.velocity time delta
    in
    { agent
        | position = position
        , velocity = updateAnimationFrameVelocity model agent.radius agent.velocity time delta position
    }


updateAnimationFramePosition : Model -> Float -> Model.Vector -> Model.Vector -> Time.Posix -> Int -> Model.Vector
updateAnimationFramePosition model radius position velocity _ delta =
    let
        xMin =
            radius

        xMax =
            model.view.gameSize.width - radius

        x =
            position.x + Utils.distance velocity.x delta
    in
    { position
        | x =
            if x < xMin then
                xMin

            else if x > xMax then
                xMax

            else
                x
        , y = position.y + Utils.distance velocity.y delta
    }


updateAnimationFrameVelocity : Model -> Float -> Model.Vector -> Time.Posix -> Int -> Model.Vector -> Model.Vector
updateAnimationFrameVelocity model radius velocity _ _ position =
    let
        x =
            if position.x <= radius || position.x >= model.view.gameSize.width - radius then
                0

            else if velocity.x > model.friction then
                velocity.x - model.friction

            else if velocity.x < -model.friction then
                velocity.x + model.friction

            else
                0
    in
    { velocity | x = x }


updateAnimationFrameOpponents : Model -> Model.Opponents -> Time.Posix -> Int -> Model.Opponents
updateAnimationFrameOpponents model opponents time delta =
    { opponents
        | delta = opponents.delta - delta
        , agents =
            opponents.agents
                |> List.map
                    (\agent ->
                        let
                            delta_ =
                                Time.posixToMillis time - Time.posixToMillis agent.time

                            agent_ =
                                updateAnimationFrameAgent model agent time delta
                        in
                        case agent_.moves of
                            [] ->
                                agent_

                            move :: moves ->
                                if move.delta < delta_ then
                                    { agent_
                                        | time = time
                                        , velocity = updateKeyDownDirectionVelocity model agent_.velocity move.direction
                                        , moves = moves
                                    }

                                else
                                    agent_
                    )
                |> List.filter (\agent -> model.player.agent.position.y - agent.position.y <= model.view.gamePlayerPositionY + agent.radius * 2)
    }


updateKeyDownDirection : Model -> Model.Direction -> ( Model, Cmd Msg )
updateKeyDownDirection model direction =
    let
        player =
            model.player
    in
    ( { model | player = { player | agent = updateKeyDownDirectionAgent model player.agent direction } }, Cmd.none )


updateKeyDownDirectionAgent : Model -> Model.Agent -> Model.Direction -> Model.Agent
updateKeyDownDirectionAgent model agent direction =
    { agent
        | time = model.time
        , velocity = updateKeyDownDirectionVelocity model agent.velocity direction
        , moves = updateKeyDownDirectionMoves model agent.moves direction agent.time
    }


updateKeyDownDirectionVelocity : Model -> Model.Vector -> Model.Direction -> Model.Vector
updateKeyDownDirectionVelocity model velocity direction =
    case direction of
        Model.Left ->
            { velocity | x = velocity.x - model.acceleration }

        Model.Right ->
            { velocity | x = velocity.x + model.acceleration }

        _ ->
            velocity


updateKeyDownDirectionMoves : Model -> List Model.Move -> Model.Direction -> Time.Posix -> List Model.Move
updateKeyDownDirectionMoves model moves direction time =
    let
        move =
            { delta = Time.posixToMillis model.time - Time.posixToMillis time, direction = direction }
    in
    List.take model.player.movesLengthMax <| moves ++ [ move ]


updateAddOpponent : Model -> Model.Agent -> ( Model, Cmd Msg )
updateAddOpponent model agent =
    let
        opponents =
            model.opponents
    in
    ( { model | opponents = { opponents | agents = opponents.agents ++ [ agent ] } }, Cmd.none )
