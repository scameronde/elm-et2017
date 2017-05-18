module Sideeffect exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode
import Json.Decode.Pipeline


type alias Random =
    { rnd : Int
    }


type alias Model =
    Int


type Msg
    = ReqRndVal
    | NewRndVal (Result Http.Error Random)


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReqRndVal ->
            ( model, makeRESTRequestForRnd NewRndVal )

        NewRndVal (Ok rnd) ->
            ( rnd.rnd, Cmd.none )

        NewRndVal (Err error) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ span [] [ text (toString model) ]
        , button [ onClick ReqRndVal ] [ text "New random value" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



--


makeRESTRequestForRnd : (Result Http.Error Random -> msg) -> Cmd msg
makeRESTRequestForRnd msg =
    let
        getRandomRequest =
            Http.get ("http://localhost:4567/random") decodeRandom
    in
        Http.send msg getRandomRequest


decodeRandom : Json.Decode.Decoder Random
decodeRandom =
    Json.Decode.Pipeline.decode Random
        |> Json.Decode.Pipeline.required "rnd" (Json.Decode.int)
