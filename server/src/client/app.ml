open Tea.App;;
open Tea.Html;;

type msg =
  | Noop
;;

let init () = 1;;

let update model =
  function
  | Noop -> model
;;

let view model =
  text "hello world"
;;

let main =
  beginnerProgram {
    model = init ();
    update;
    view;
  }
;;
