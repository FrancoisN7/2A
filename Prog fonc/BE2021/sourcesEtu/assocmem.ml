open Util
open Mem

(* get_assoc : 'a -> ('a * 'b) list -> 'b -> 'b
     Retourne la valeur associée à la clé dans la liste l ou la valeur
     fournie de f si la clef n'exite pas

     * Paramètres :
     *   e : 'a
     *   l : ('a * 'b) list, liste de couples (cle, valeur) à écrire
     *   def : 'b
     * Retour :
     *   la valeur associée à la clé ou def si il n'y a pas de valeur associée
     *
*)
let rec get_assoc e l def = 
    match l with 
    |[] -> def
    |(cle, valeur)::q -> if cle = e then valeur
                        else get_assoc e q def
                        
let%test _ = get_assoc "e" [] "def" = "def"
let%test _ = get_assoc 2 [(1,4);(2,8);(3,5)] 0 = 8
let%test _ = get_assoc 5 [(1,4);(2,8);(3,5)] 0 = 0
let%test _ = get_assoc 1 [(1,4);(2,8);(3,5)] 0 = 4
let%test _ = get_assoc 1 [(1,"r");(2,"i");(3,"e")] "def" = "r"


(* Tests unitaires : TODO *)

(* set_assoc : 'a -> ('a * 'b) list -> 'b -> 'b
     Remplace la valeur associée à la clef e dans la liste l par x, 
     ou ajoute le couple (e, x) si la clef n’existe pas déjà.

     * Paramètres :
     *   e : 'a
     *   l : ('a * 'b) list, liste de couples (cle, valeur) à écrire
     *   x : 'b
     * Retour :
     *   La nouvelle liste de couples (cle, valeur)
     *
*)
let rec set_assoc e l x = 
    match l with 
    |[] -> [(e,x)]
    |(t1,t2)::q -> if t1=e then (t1,x)::q
    else (t1,t2)::(set_assoc e q x)
                        
let%test _ = set_assoc "e" [] "def" = [("e", "def")]
let%test _ = set_assoc 2 [(1,4);(2,8);(3,5)] 0 = [(1,4);(2,0);(3,5)]
let%test _ = set_assoc 5 [(1,4);(2,8);(3,5)] 0 = [(1,4);(2,8);(3,5);(5,0)]
let%test _ = set_assoc 1 [(1,4);(2,8);(3,5)] 0 = [(1,0);(2,8);(3,5)]
let%test _ = set_assoc 1 [(1,"r");(2,"i");(3,"e")] "def" = [(1,"def");(2,"i");(3,"e")]

(* Tests unitaires : TODO *)

module AssocMemory : Memory =
struct
    (* Type = liste qui associe des adresses (entiers) à des valeurs (caractères) *)
    type mem_type = (int * char) list

    (* Un type qui contient la mémoire + la taille de son bus d'adressage *)
    type mem = int * mem_type

    (* Nom de l'implémentation *)
    let name = "assoc"

    (* Taille du bus d'adressage *)
    let bussize (bs, _) = bs

    (* Taille maximale de la mémoire *)
    let size (bs, _) = pow2 bs

    (* Taille de la mémoire en mémoire *)
    let allocsize (bs, m) = 2 * List.length m

    (* Nombre de cases utilisées *)
    let busyness (bs, m) = List.length m

    (* Construire une mémoire vide *)
    let clear bs = 
        (bs, [])

    (* Lire une valeur *)
    let read (bs, m) addr = if addr > size (bs, m) then raise OutOfBound else get_assoc addr m _0

    (* Écrire une valeur *)
    let write (bs, m) addr x = if addr > size (bs, m) then raise OutOfBound else (bs, set_assoc addr m x)
end
