open Assoc
open Arbre
open Chaines

(* le type trie :
    triplet arbre,
            fonction de décomposition mot -> liste de caractères,
            fonction de recomposition liste de caractères -> mot *)
type ('a,'b) trie = Trie of ('b arbre) * ('a -> 'b list) * ('b list -> 'a)

(******************************************************************************)
(*   fonction de création d'un nouveau trie                                   *)
(*   signature  : nouveau :                                                   *)
(*          ('a -> 'b list) -> ('b list -> 'a) -> ('a, 'b) trie = <fun>       *)
(*   paramètres : - une fonction de décomposition                             *)
(*                     mot -> liste de caractères                             *)
(*                -  une fonction de recomposition                            *)
(*                     liste de caractères -> mot                             *)
(*   résultat     : un nouveau trie "vide"                                    *)
(******************************************************************************)
let nouveau fd fr = Trie(Noeud(false,[]), fd, fr)

(******************************************************************************)
(*   fonction d'appartenance d'un élément à un trie                           *)
(*   signature  : appartient : 'a -> ('a, 'b) trie -> bool = <fun>            *)
(*   paramètres : - un mot                                                    *)
(*                - un trie                                                   *)
(*   résultat   : le résultat booléen du test                                 *)
(******************************************************************************)
let appartient mot (Trie(arbre, fd, fr)) = appartient_arbre (fd mot) arbre

let arbre_sujet_T = Trie(arbre_sujet, decompose_chaine, recompose_chaine)

let%test _ = appartient "lard"  arbre_sujet_T
let%test _ = appartient "le" arbre_sujet_T
let%test _ = appartient "les"  arbre_sujet_T
let%test _ = appartient "long" arbre_sujet_T
let%test _ = not (appartient "toto" arbre_sujet_T)
let%test _ = not (appartient "ba" arbre_sujet_T)
let%test _ = not (appartient "lon" arbre_sujet_T)

(******************************************************************************)
(*   fonction d'ajout d'un élément dans un trie                               *)
(*   signature  : ajout : 'a -> ('a, 'b) trie -> ('a, 'b) trie = <fun>        *)
(*   paramètres : - un mot                                                    *)
(*                - un trie                                                   *)
(*   résultat   : le trie avec le mot ajouté                                  *)
(******************************************************************************)
let ajout mot (Trie(arbre, decompose, recompose)) =
  Trie (ajout_arbre (decompose mot) arbre,decompose,recompose)

(*  Pour les tests *)
let trie_sujet =
  List.fold_right ajout
    ["bas"; "bât"; "de"; "la"; "lai"; "laid"; "lait"; "lard"; "le"; "les"; "long"]
    (nouveau decompose_chaine recompose_chaine)

(******************************************************************************)
(*   fonction de retrait d'un élément d'un trie                               *)
(*   signature  : trie_retrait : 'a -> ('a, 'b) trie -> ('a, 'b) trie = <fun> *)
(*   paramètres : - un mot                                                    *)
(*                - un trie                                                   *)
(*   résultat   : le trie avec le mot retiré                                  *)
(******************************************************************************)
let retrait mot (Trie(arbre, decompose, recompose)) =
Trie ( retrait_arbre (decompose mot) arbre,decompose,recompose)

let arbre_sujet_T = Trie(arbre_sujet, decompose_chaine, recompose_chaine)

let%test _ = let nv_arbre = retrait "bas" arbre_sujet_T in (appartient "bat" nv_arbre && not( appartient "bas" nv_arbre) )
let%test _ = let nv_arbre = retrait "le" arbre_sujet_T in (appartient "les" nv_arbre && not( appartient "le" nv_arbre) )

(******************************************************************************)
(*   fonction interne au Module qui génère la liste de tous les mots          *)
(*   d'un trie                                                                *)
(*   signature    : trie_dico : ('a, 'b) trie -> 'a list = <fun>              *)
(*   paramètre(s) : le trie                                                   *)
(*   résultat     : la liste des mots                                         *)
(******************************************************************************)
let trie_dico trie = failwith "trie_dico"

(******************************************************************************)
(* procédure d'affichage d'un trie                                            *)
(*   signature  : affiche : ('a -> unit) -> ('a, 'b) trie -> unit = <fun>     *)
(*   paramètres : - une procédure d'affichage d'un mot                        *)
(*                - un trie                                                   *)
(*   résultat   : aucun                                                       *)
(******************************************************************************)
let affiche p (Trie(arbre, decompose, recompose)) = 
 List.iter p (List.map (recompose) (liste_arbre arbre))

 