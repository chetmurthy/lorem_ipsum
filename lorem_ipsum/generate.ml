(**pp -syntax camlp5o -package camlp5,pa_ppx.base,pa_ppx.utils,pa_ppx_regexp *)

open Pa_ppx_base
open Pa_ppx_utils
open Ppxutil

let punc = Array.of_list (String.fold_right (fun c acc -> (String.make 1 c)::acc) "..........??!" [])
let inpunc = Array.of_list ((String.fold_right (fun c acc -> (String.make 1 c)::acc) ",,,,,,,,,,;;:" [])@[" --"])

let process_source text =
  let text = [%subst {|[\n\r]|} / {| |} / g m] text in
  let text = [%subst {|[[:punct:]]|} / {||} / g m] text in
  let words = [%split {|\s+|}] text in
  let words = List.map String.lowercase_ascii words in
  words
