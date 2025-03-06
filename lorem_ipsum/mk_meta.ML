#include "version.inc"

let top = try Sys.getenv "TOP" with Not_found -> "" ;;
let destdir = ref (top ^ "/local-install") ;;

Arg.(parse [
         "-destdir", (Arg.String (fun s -> destdir := s)),
         ("<path>    Set the destination directory (default: " ^
	    !destdir ^ ")")
       ]
       (fun _ -> failwith "mk_meta: no anonymous args supported")
     "mk_meta -destdir <dir>")
;;

Fmt.(pf stdout {|
# Specifications for the "lorem_ipsum" library:
requires = "pcre2,camlp5,fmt,pa_ppx.base,pa_ppx.utils,lorem_ipsum_runtime,pa_ppx_regexp.runtime"
version = "%s"
description = "lorem_ipsum: lorem_ipsum library"

# For the toploop:
archive(byte,toploop) = "lorem_ipsum.cma"

  # For the preprocessor itself:
  requires(syntax,preprocessor) = "camlp5,fmt,pa_ppx.base,pa_ppx.utils,pa_ppx_regexp.runtime"
  archive(syntax,preprocessor,-native) = "lorem_ipsum.cma"
  archive(syntax,preprocessor,native) = "lorem_ipsum.cmxa"

|} version)
