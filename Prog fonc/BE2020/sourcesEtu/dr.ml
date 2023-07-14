(*  Module qui permet la décomposition et la recomposition de données **)
(*  Passage du type t1 vers une liste d'éléments de type t2 (décompose) **)
(*  et inversement (recopose).**)
module type DecomposeRecompose =
sig
  (*  Type de la donnée **)
  type mot
  (*  Type des symboles de l'alphabet de t1 **)
  type symbole

  val decompose : mot -> symbole list
  val recompose : symbole list -> mot
end

(*  Module qui permet la décomposition et la recomposition de données de 
chaînes de caractères à liste de caractères et inversement*)
module DRString : DecomposeRecompose with type mot = string and type symbole = char =
struct
  (*  Type de la donnée **)
  type mot = string
  (*  Type des symboles de l'alphabet de t1 **)
  type symbole = char

  (******************************************************************************)
  (*                                                                            *)
  (*      fonction de décomposition pour les chaînes de caractères              *)
  (*                                                                            *)
  (*   signature : decompose_chaine : string -> char list = <fun>               *)
  (*                                                                            *)
  (*   paramètre(s) : une chaîne de caractères                                  *)
  (*   résultat     : la liste des caractères composant la chaîne paramètre     *)
  (*                                                                            *)
  (******************************************************************************)
  let decompose s =
    let rec decompose i accu =
      if i < 0 then accu
      else decompose (i-1) (s.[i]::accu)
    in decompose (String.length s - 1) []

  let%test _ = decompose "" = []
  let%test _ = decompose "a" = ['a']
  let%test _ = decompose "aa" = ['a';'a']
  let%test _ = decompose "ab" = ['a';'b']
  let%test _ = decompose "abcdef" = ['a'; 'b'; 'c'; 'd'; 'e'; 'f']
  
  (******************************************************************************)
  (*                                                                            *)
  (*      fonction de recomposition pour les chaînes de caractères              *)
  (*                                                                            *)
  (*   signature : recompose_chaine : char list -> string = <fun>               *)
  (*                                                                            *)
  (*   paramètre(s) : une liste de caractères                                   *)
  (*   résultat     : la chaîne des caractères composant la liste paramètre     *)
  (*                                                                            *)
  (******************************************************************************)
  let recompose lc =
    List.fold_right (fun t q -> String.make 1 t ^ q) lc ""

  let%test _ = recompose [] = ""
  let%test _ = recompose ['a'] = "a"
  let%test _ = recompose ['a';'a'] = "aa"
  let%test _ = recompose ['a';'b'] = "ab"
  let%test _ = recompose ['a'; 'b'; 'c'; 'd'; 'e'; 'f'] = "abcdef"
end








(*  Module qui permet la décomposition et la recomposition de données d'entiers 
  à liste de chiffres et inversement*)
module DRNat : DecomposeRecompose with type mot = int and type symbole = int =
struct
  (*  Type de la donnée **)
  type mot = int
  (*  Type des symboles de l'alphabet de t1 **)
  type symbole = int

  (******************************************************************************)
  (*                                                                            *)
  (*      fonction de décomposition pour les entiers                            *)
  (*                                                                            *)
  (*   signature : decompose_chaine : int -> int list = <fun>                   *)
  (*                                                                            *)
  (*   paramètre(s) : une chaîne de caractères                                  *)
  (*   résultat     : la liste des caractères composant la chaîne paramètre     *)
  (*                                                                            *)
  (******************************************************************************)
  let rec decompose s = if s/10 = 0 then [s] else (decompose (s/10))@[s mod 10]

  let%test _ = decompose 0 = [0]
  let%test _ = decompose 5 = [5]
  let%test _ = decompose 15 = [1; 5]
  let%test _ = decompose 236 = [2; 3; 6]
  let%test _ = decompose 123045 = [1; 2; 3; 0; 4; 5]
  
  (******************************************************************************)
  (*                                                                            *)
  (*      fonction de recomposition pour les chaînes de caractères              *)
  (*                                                                            *)
  (*   signature : recompose_chaine : int list -> int = <fun>                   *)
  (*                                                                            *)
  (*   paramètre(s) : une liste de caractères                                   *)
  (*   résultat     : la chaîne des caractères composant la liste paramètre     *)
  (*                                                                            *)
  (******************************************************************************)
  let recompose l = List.fold_left(fun q t -> q * 10 + t) 0 l
  let%test _ = recompose [0] = 0
  let%test _ = recompose [5] = 5
  let%test _ = recompose [1; 5] = 15
  let%test _ = recompose [2; 3; 6] = 236
  let%test _ = recompose [1; 2; 3; 0; 4; 5] = 123045
  
end