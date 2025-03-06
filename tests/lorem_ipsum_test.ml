(**pp -syntax camlp5o -package pa_ppx.testutils,pa_ppx.utils,lorem_ipsum,pa_ppx.deriving_plugins.std *)
open OUnit2
open Pa_ppx_testutils
open Pa_ppx_base
open Pa_ppx_utils

Pa_ppx_runtime.Exceptions.Ploc.pp_loc_verbose := true ;;
Pa_ppx_runtime_fat.Exceptions.Ploc.pp_loc_verbose := true ;;

let simple ctxt =
  ()
  ; assert_equal "" ""

let suite = "Test lorem_ipsum" >::: [
      "simple"   >:: simple
    ]

let _ = 
if not !Sys.interactive then
  run_test_tt_main suite
else ()

