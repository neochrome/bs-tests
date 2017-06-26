open Tea;;
open Tea.App;;
open Tea.Html;;

type category =
  | Animal
  | Career
  | Celebrity
  | Dev
  | Fashion
  | Food
  | History
  | Money
  | Music
  | Political
  | Religion
  | Science
  | Sport
  | Travel
;;
let string_of_category = function
  | Animal -> "animal"
  | Career -> "career"
  | Celebrity -> "celebrity"
  | Dev -> "dev"
  | Fashion -> "fashion"
  | Food -> "food"
  | History -> "history"
  | Money -> "money"
  | Music -> "music"
  | Political -> "political"
  | Religion -> "religion"
  | Science -> "science"
  | Sport -> "sport"
  | Travel -> "travel"
;;

type msg =
  | Refresh
  | Category of category option
  | JokeOk of string
  | JokeError
;;

type model = {
  joke: string option;
  category: category option;
};;

let subscriptions model = Sub.none;;

let decode_joke json =
  let module D = Json.Decoder in
  json
  |> D.decodeString (D.field "value" D.string)
  |> function
    | Result.Error _ -> JokeError
    | Result.Ok joke -> JokeOk joke
;;

let refresh model =
  let url = match model.category with
  | None -> "https://api.chucknorris.io/jokes/random"
  | Some category -> "https://api.chucknorris.io/jokes/random?category=" ^ (string_of_category category)
  in
  model,
  Http.getString url
  |> Http.send
    (function
      | Result.Error _ -> JokeError
      | Result.Ok res -> decode_joke res
    )
;;


let init () = {
  joke = None;
  category = None;
}, Cmd.none;;

let update model = function
  | Refresh -> model |> refresh
  | Category cat -> { model with category = cat }, Cmd.none
  | JokeOk joke -> { model with joke = Some joke; }, Cmd.none
  | JokeError -> model, Cmd.none
;;

let view model =
  let joke = match model.joke with None -> "hit refresh, no joke!" | Some joke -> joke in
  let cat_render title msg =
    div [] [
      label [] [
        text title;
        input' [name "category"; type' "radio"; onChange (fun _ -> msg)]  [];
      ]
    ]
  in
  let category cat = cat_render (string_of_category cat) (Category (Some cat)) in
  div [] [
    div [] [text joke];
    button [onClick Refresh] [text "refresh"];
    cat_render "all" (Category None);
    category Animal;
    category Career;
    category Celebrity;
    category Dev;
    category Fashion;
    category Food;
    category History;
    category Money;
    category Music;
    category Political;
    category Religion;
    category Science;
    category Sport;
    category Travel;
  ]
;;

let main =
  standardProgram {
    init;
    subscriptions;
    update;
    view;
  }
;;
