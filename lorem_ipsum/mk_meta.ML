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
requires = "pcre2,camlp5,fmt,pa_ppx.base,pa_ppx.utils,lorem_ipsum_runtime,camlp5.parser_quotations,pa_ppx_regexp.runtime,sedlex,markup"
version = "%s"
description = "lorem_ipsum: lorem_ipsum library"

# For linking
package "link" (
requires = "camlp5,fmt,pa_ppx.base.link,pa_ppx.utils,camlp5.parser_quotations.link,pa_ppx_regexp.runtime,sedlex,markup"
archive(byte) = "lorem_ipsum.cma"
archive(native) = "lorem_ipsum.cmxa"
)

# For the toploop:
archive(byte,toploop) = "lorem_ipsum.cma"

  # For the preprocessor itself:
  requires(syntax,preprocessor) = "camlp5,fmt,pa_ppx.base,pa_ppx.utils,camlp5.parser_quotations,pa_ppx_regexp.runtime,sedlex,markup"
  archive(syntax,preprocessor,-native) = "lorem_ipsum.cma"
  archive(syntax,preprocessor,native) = "lorem_ipsum.cmxa"

|} version)
