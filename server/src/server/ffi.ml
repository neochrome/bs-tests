type req = < method_ : string; url : string > Js.t;;

class type resp_ = object
  method statusCode : int [@@bs.set]
  method setHeader : string -> string -> unit
  method end_ : string -> unit
end [@bs];;
type resp = resp_ Js.t;;

class type server_ = object
  method listen : int -> string -> (unit -> unit [@bs]) -> unit
end [@bs];;
type server = server_ Js.t;;

class type http_ = object
  method createServer : (req -> resp -> unit [@bs] ) -> server
end [@bs];;

type http = http_ Js.t;;
external http : http = "http" [@@bs.module];;
