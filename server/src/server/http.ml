type http_method =
  | GET
  | POST
  | PUT
  | DELETE
  | OTHER of string
;;
let http_method_from_string = function
  | "GET" -> GET
  | "POST" -> POST
  | "PUT" -> PUT
  | "DELETE" -> DELETE
  | m -> OTHER m
;;

type http_status =
  | OK
  | NOT_FOUND
  | OTHER of int
;;
let http_status_as_int = function
  | OK -> 200
  | NOT_FOUND -> 404
  | OTHER status -> status
;;

type request = {
  _method : http_method;
  url : string;
  path : string;
  query : string option;
};;

module Request = struct
  let empty = {
    _method = OTHER "";
    url = "";
    path = "";
    query = None;
  };;
  let from _method url =
    let parts = Js.String.splitAtMost "?" 1 url in
    {
      _method = http_method_from_string _method;
      url;
      path = parts.(0);
      query = if Array.length parts = 2 then Some parts.(1) else None
    }
  ;;
end;;

type response = {
  status : http_status;
  body : string;
};;

module Response = struct
  let empty = {
    status = NOT_FOUND;
    body = "";
  };;
  let status s res = { res with status = s };;
  let body s res = { res with body = s };;
end;;

type context = {
  request : request;
  response : response;
};;

module Context = struct
  let empty = {
    request = Request.empty;
    response = Response.empty;
  };;
end;;

let request apply (a : context) = apply a.request a;;
let context apply (a : context) = apply a a;;

module Filters = struct
  open WebPart;;

  let iff expr x = if expr then succeed x else fail x;;

  let path p = fun ctx -> iff (p = ctx.request.path) ctx;;
  let path_starts p = fun ctx -> iff (Js.String.startsWith p ctx.request.path) ctx;;
  let path_scan fmt apply = fun ctx ->
    try
      ctx |> Scanf.sscanf ctx.request.path fmt apply
    with _ -> fail ()
  ;;
  let url = path;;
  let url_starts = path_starts;;
  let url_scan = path_scan;;

  let _method m = fun ctx -> iff (m = ctx.request._method) ctx;;
  let get = _method GET;;
  let put = _method PUT;;
  let post = _method POST;;
  let delete = _method DELETE;;
end

module Successful = struct
  open WebPart;;
  let ok s = fun ctx ->
    { ctx with response =
      ctx.response
      |> Response.status OK
      |> Response.body s
    } |> succeed
  ;;
end

module RequestErrors = struct
  open WebPart;;
  let not_found s = fun ctx ->
    { ctx with response =
      ctx.response
      |> Response.status NOT_FOUND
      |> Response.body s
    } |> succeed
  ;;
end
