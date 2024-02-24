module Update exposing (..)

import Browser.Events as Events
import Init
import Model exposing (Model)
import Msg exposing (Msg(..))
import Random
import Task
import Time
import Utils
import View exposing (view)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Now time ->
            updateNow model time

        Resize w h ->
            updateResize model w h

        OpponentsDelta delta ->
            updateOpponentsDelta model delta

        AnimationFrame time ->
            updateAnimationFrame model time

        KeyDownDirection direction ->
            updateKeyDownDirection model direction

        AddOpponent agent ->
            updateAddOpponent model agent

        VisibilityChange visibility ->
            updateVisibilityChange model visibility

        PauseDelta pauseDelta ->
            ( { model | pauseDelta = pauseDelta }, Cmd.none )


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


updateResize : Model -> Float -> Float -> ( Model, Cmd Msg )
updateResize model w h =
    let
        view =
            model.view

        boxWidth =
            view.boxWidth

        boxHeight =
            view.headerHeight + view.gameHeight + view.footerHeight

        boxZoom =
            if w / h < boxWidth / boxHeight then
                w / boxWidth

            else
                h / boxHeight
    in
    ( { model | view = { view | boxZoom = boxZoom } }, Cmd.none )


updateOpponentsDelta : Model -> Int -> ( Model, Cmd Msg )
updateOpponentsDelta model delta =
    let
        opponents =
            model.opponents
    in
    ( { model | opponents = { opponents | delta = delta } }, Cmd.none )


updateAnimationFrame : Model -> Time.Posix -> ( Model, Cmd Msg )
updateAnimationFrame model time =
    if model.pause then
        ( model, Cmd.none )

    else
        let
            delta =
                Time.posixToMillis time - Time.posixToMillis model.time - model.pauseDelta

            player =
                model.player

            playerAgent =
                updateAnimationFrameAgent model player.agent time delta

            opponents =
                updateAnimationFrameOpponents model model.opponents playerAgent time delta

            playerAgentBump =
                playerAgent.bump || List.any (\agent -> agent.bump) opponents.agents

            score =
                if playerAgentBump then
                    model.score

                else
                    playerAgent.position.y
            
            pauseDelta =
                0
        in
        ( { model
            | time = time
            , player = { player | agent = { playerAgent | bump = playerAgentBump } }
            , opponents = opponents
            , score = score
            , pauseDelta = pauseDelta
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
                Random.float radius (model.view.boxWidth - radius)

            generatorAgentMoves =
                Random.int 0 (List.length moves)
                    |> Random.map (\index -> List.drop index moves |> List.take opponents.movesLengthMax)

            generatorAgent =
                Random.map2
                    (\positionX moves_ ->
                        { time = time
                        , position = { x = positionX, y = agent.position.y + model.view.gameHeight + radius * 2 }
                        , velocity = { x = 0, y = -agent.velocity.y }
                        , radius = radius
                        , moves = moves_
                        , bump = False
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
            model.view.boxWidth - radius

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
            if position.x <= radius || position.x >= model.view.boxWidth - radius then
                0

            else if velocity.x > model.friction then
                velocity.x - model.friction

            else if velocity.x < -model.friction then
                velocity.x + model.friction

            else
                0
    in
    { velocity | x = x }


updateAnimationFrameOpponents : Model -> Model.Opponents -> Model.Agent -> Time.Posix -> Int -> Model.Opponents
updateAnimationFrameOpponents model opponents playerAgent time delta =
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
                |> List.filter (\agent -> model.player.agent.position.y - agent.position.y <= model.view.gameHeight - model.view.gamePlayerPositionY + playerAgent.radius)
                |> List.map
                    (\agent ->
                        let
                            positionXDelta =
                                playerAgent.position.x - agent.position.x

                            positionYDelta =
                                playerAgent.position.y - agent.position.y

                            distance =
                                sqrt (positionXDelta ^ 2 + positionYDelta ^ 2)
                        in
                        if distance < playerAgent.radius + agent.radius then
                            { agent | bump = True }

                        else
                            { agent | bump = False }
                    )
    }


updateKeyDownDirection : Model -> Model.Direction -> ( Model, Cmd Msg )
updateKeyDownDirection model direction =
    if model.player.agent.bump then
        ( model, Cmd.none )

    else
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


updateVisibilityChange : Model -> Events.Visibility -> ( Model, Cmd Msg )
updateVisibilityChange model visibility =
    case visibility of
        Events.Hidden ->
            ( { model | pause = True }, Cmd.none )

        _ ->
            ( { model | pause = False }
            , Time.now
                |> Task.map (\time -> Time.posixToMillis time - Time.posixToMillis model.time)
                |> Task.perform PauseDelta
            )
