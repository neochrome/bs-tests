open WebPart;;
open WebPart.Operators;;
open Http;;
open Http.Filters;;
open Http.Successful;;
open Http.RequestErrors;;

let app =
  choose [
    get >=> path "/" >=> ok "got get @ root!!\n";
    get >=> path_scan "/add/%d/%d" (fun a b -> ok (Printf.sprintf "res=%d\n" (a + b)));
    get >=> path_starts "/add/" >=> not_found "";
    get >=> request (fun r -> ok (Printf.sprintf "got get %s\n" r.url));
    put >=> ok "got put\n";
  ]
;;

let () =
  Server.start Server.defaultConfig app
;;
