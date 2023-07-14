open Util
open Mem

(* get_assoc : mem -> (int * char) list -> mem
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
                        
let%test _ = gray_code "e" [] "def" = "def"
let%test _ = gray_code 2 [(1,4),(2,8),(3,5)] "def" = 8
let%test _ = gray_code 5 [(1,4),(2,8),(3,5)] "def" = "def"
let%test _ = gray_code 1 [(1,4),(2,8),(3,5)] "def" = 4
let%test _ = gray_code 1 [(1,"r"),(2,"i"),(3,"e")] "def" = "r"

(* Tests unitaires : TODO *)

(* set_assoc : TODO
 *)
let rec set_assoc e l x = failwith "TODO"

(* Tests unitaires : TODO *)

(*
module AssocMemory : Memory =
struct
    (* Type = liste qui associe des adresses (entiers) à des valeurs (caractères) *)
    type mem_type = unit (* TODO *)

    (* Un type qui contient la mémoire + la taille de son bus d'adressage *)
    type mem = int * mem_type

    (* Nom de l'implémentation *)
    let name = "assoc"

    (* Taille du bus d'adressage *)
    let bussize (bs, _) = bs

    (* Taille maximale de la mémoire *)
    let size (bs, _) = pow2 bs

    (* Taille de la mémoire en mémoire *)
    let allocsize (bs, m) = failwith "TODO"

    (* Nombre de cases utilisées *)
    let busyness (bs, m) = failwith "TODO"

    (* Construire une mémoire vide *)
    let clear bs = failwith "TODO"

    (* Lire une valeur *)
    let read (bs, m) addr = failwith "TODO"

    (* Écrire une valeur *)
    let write (bs, m) addr x = failwith "TODO"
end
*)