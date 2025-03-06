(**pp -syntax camlp5o -package pa_ppx_regexp,pa_ppx.runtime,pa_ppx.runtime_fat,pa_ppx.base,pa_ppx.testutils,pa_ppx.utils,lorem_ipsum,bos *)

open OUnit2
open Pa_ppx_base
open Pa_ppx_testutils
open Pa_ppx_utils

let verbose = ref false ;;
let rev_extra_args = ref [] ;;

if not !Sys.interactive then begin
    Arg.(parse [
             "-verbose", (Arg.Set verbose),
             "verbose"
           ]
           (Std.push rev_extra_args)
           "count_references <args> <input-files>") ;

    ()
  end
;;
