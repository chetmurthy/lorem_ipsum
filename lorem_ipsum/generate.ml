(**pp -syntax camlp5o -package camlp5,pa_ppx.base,pa_ppx.utils,pa_ppx_regexp *)

open Pa_ppx_base
open Pa_ppx_utils
open Ppxutil

let punc = Array.of_list (String.fold_right (fun c acc -> (String.make 1 c)::acc) "..........??!" [])
let inpunc = Array.of_list ((String.fold_right (fun c acc -> (String.make 1 c)::acc) ",,,,,,,,,,;;:" [])@[" --"])

let _process_source text =
  let text = [%subst {|[\n\r]|} / {| |} / g m] text in
  let text = [%subst {|[[:punct:]]|} / {||} / g m] text in
  let words = [%split {|\s+|}] text in
  let words = List.map String.lowercase_ascii words in
  Array.of_list words

type t = { sources : string array array
         ; paragraphs : int * int
         ; sentences : int * int
         ; words : int * int
         ; prng : Random.State.t
         }

let make ?text ?(paragraphs=(2,8)) ?(sentences=(2,8)) ?(words=(5,15)) ?prng () =
  let prng = Random.State.(match prng with None -> make_self_init () | Some arg -> make arg) in
  let text = match text with None -> Greek.text | Some t -> t in
  let sources = Array.of_list [_process_source text] in
  { sources ; paragraphs ; sentences ; words ; prng }

let paragraphs (min,max) t = { t with paragraphs = (min,max) }
let sentences (min,max) t = { t with sentences = (min,max) }
let words (min,max) t = { t with words = (min,max) }

let source text t = { t with sources = Array.append t.sources (Array.of_list [_process_source text]) }

let prlist_with_sep elem ?sep l =
  let sep = match sep with Some sep -> sep
                         | None -> (fun () -> [< >]) in
  let rec prec = function
      [] -> [< >]
    | h::(_::_ as t) ->
       [< elem h ; sep() ; prec t >]
    | [h] -> elem h
  in prec l

let generate_sentence t =
  let rand n = Random.State.int t.prng n in
  let random_get a = Array.get a (Random.State.int t.prng (Array.length a)) in
  let range ~min ~max = Random.State.int_in_range t.prng ~min ~max in
  let (phramin, phramax) = t.words in
  let wcount = range ~min:phramin ~max:phramax in
  let words = random_get t.sources in
  let nwords = Array.length words in
  [< 
     (Std.range wcount
      |> Std.stream_of_list
      |> Std.stream_concat_map (fun w ->
             [< (let word = random_get words in
                 if w = 1 then
                   [< 'String.capitalize_ascii word >]
                 else
                   [< '" " ; 'word >]) ;
              (if w+1 < wcount && (rand 10) = 0 then
                 [< 'random_get inpunc >]
               else [< >])
              >]
           )

     ) ;
   '(random_get punc)
   >]


let generate_paragraph t =
  let rand n = Random.State.int t.prng n in
  let range ~min ~max = Random.State.int_in_range t.prng ~min ~max in
  let (sentmin, sentmax) = t.sentences in
  let scount = range ~min:sentmin ~max:sentmax in

  [< Std.range scount
   |> prlist_with_sep (fun _ -> generate_sentence t) ~sep:(fun () -> [< '" " >]) ;
   '"\n\n" >]

let generate t =
  let rand n = Random.State.int t.prng n in
  let range ~min ~max = Random.State.int_in_range t.prng ~min ~max in
  let (paramin, paramax) = t.paragraphs in
  let pcount = range ~min:paramin ~max:paramax in

  Std.range pcount
  |> Std.stream_of_list
  |> Std.stream_concat_map (fun _ -> generate_paragraph t)

