module Simple exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


type alias Model =
    Int


type Msg
    = Add
    | Sub


init : Model
init =
    0


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add ->
            model + 1

        Sub ->
            model - 1


view : Model -> Html Msg
view model =
    div []
        [ span [] [ text (toString model) ]
        , button [ onClick Add ] [ text "+" ]
        , button [ onClick Sub ] [ text "-" ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }
