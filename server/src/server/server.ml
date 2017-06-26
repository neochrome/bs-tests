type config = {
  port : int;
};;

let defaultConfig = {
  port = 3000;
};;

open Http;;
open Ffi;;

let start config web_part =
  let server = http##createServer (fun [@bs] req res ->
    { Http.Context.empty with
      request = Http.Request.from req##method_ req##url;
    }
    |> web_part
    |> begin function
      | None -> Http.Response.empty
      | Some ctx -> ctx.response
      end
    |> fun response ->
      res##statusCode #= (response.status |> http_status_as_int);
      res##end_ response.body;
  ) in
  server##listen config.port "localhost" (fun [@bs] () ->
    Printf.printf "server listening on port %d\n" config.port
  )
;;
