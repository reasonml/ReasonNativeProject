(* Copyright (c) 2015-present, Facebook, Inc. All rights reserved. *)

open Topkg

let native = Conf.(key "native" bool ~absent:false)

let () =
  let cmd c os files =
    let ocamlbuild = Conf.tool "rebuild" os in
    OS.Cmd.run @@ Cmd.(ocamlbuild % "-use-ocamlfind"
                                  %% (v "-I" % "src")
                                  %% of_list files)
  in
  let build = Pkg.build ~cmd () in
  Pkg.describe "ReasonProject" ~build ~change_logs:[] ~licenses:[] ~readmes:[] @@ fun c ->
    Ok [
      Pkg.lib "pkg/META";
      (* .native builds if --native true is passed *)
      Pkg.lib ~cond:(Conf.value c native)
              ~exts:(Exts.exts [".native"])
              ~dst:"test"
              "src/Test";
      (* .byte builds if --native is absent or passed as false *)
      Pkg.lib ~cond:(not (Conf.value c native))
              ~exts:(Exts.exts [".byte"])
              ~dst:"test"
              "src/Test";
    ]
