let (>>) f g x = g (f x);;

let succeed x = Some x;;
let fail _ = None;;

let either on_success on_fail =
  function
  | None -> on_fail ()
  | Some s -> on_success s
;;

let bind f = either f fail;;

let compose f g = f >> (bind g);;

let map f = either (f >> succeed) fail;;

let tee f x = f x; x;;

let rec choose parts =
  fun arg ->
    match parts with
    | [] -> None
    | part :: parts ->
      begin match part arg with
      | Some result -> Some result
      | None -> choose parts arg
      end
;;

module Operators = struct
  let (>=>) = compose;;
end
