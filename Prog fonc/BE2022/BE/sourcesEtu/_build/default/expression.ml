(* Exercice 3 *)
module type Expression = sig
  (* Type pour représenter les expressions *)
  type exp

  (* eval *)
  (* eval : exp -> int *)
  (* Calcule la valeur associée au calcul représenté par l'arbre de type exp *)
  (* Paramètre arbre : L'arbre de type exp qui représente le calcul *)
  (* Résultat : le calcul que représente l'arbre *)
  val eval : exp -> int
end

(* Exercice 4 *)

(* TO DO avec l'aide du fichier  expressionArbreBinaire.txt *)
module ExpAvecArbreBinaire : Expression =
struct
  (* Type pour représenter les expressions binaires *)
  type op = Moins | Plus | Mult | Div
  type exp = Binaire of exp * op * exp | Entier of int
 
  (* eval *)
  (* eval : exp -> int *)
  (* Calcule la valeur associée au calcul représenté par l'arbre de type exp *)
  (* Paramètre arbre : L'arbre de type exp qui représente le calcul *)
  (* Résultat : le calcul que représente l'arbre *)
  let rec eval arbre = 
    match arbre with
    |Entier e -> e
    |Binaire (Entier exp1, Moins, Entier exp2) -> exp1 - exp2
    |Binaire (Entier exp1, Plus, Entier exp2) -> exp1 + exp2
    |Binaire (Entier exp1, Mult, Entier exp2) -> exp1 * exp2
    |Binaire (Entier exp1, Div, Entier exp2) -> exp1 / exp2
    |Binaire (exp1, ope, exp2)  -> eval (Binaire(Entier (eval exp1), ope, Entier(eval exp2)))


  (* Tests : TO DO *)
  let%test _  = eval (Binaire(Entier 3, Plus, Entier 4)) = 7
  let%test _  = eval (Binaire(Entier 3, Moins, Entier 4)) = -1
  let%test _  = eval (Binaire (Entier 3, Mult, Entier 4)) = 12
  let%test _  = eval (Binaire (Entier 12, Div, Entier 3)) = 4
  let%test _  = eval (Binaire (Binaire(Entier 3, Plus, Entier 4), Moins, Entier 12)) = -5 (*exemple du texte*)
  let%test _  = eval (Binaire (Binaire(Entier 6, Plus, Entier 4), Mult, Entier 2)) = 20
  let%test _  = eval (Binaire (Binaire(Entier 6, Mult, Entier 4), Plus, Entier 2)) = 26 
  let%test _  = eval (Binaire (Binaire(Entier 4, Div, Entier 4), Moins, Entier 12)) = -11
  let%test _  = eval (Binaire (Binaire(Entier 12, Plus, Entier 0), Div, Entier 1)) = 12   
  let%test _  = eval (Binaire (Binaire(Entier 12, Plus, Entier 12), Div, Binaire(Entier 3, Mult, Entier 4))) = 2 
end

(* Exercice 5 *)

(* TO DO avec l'aide du fichier  expressionArbreNaire.txt *)
module ExpAvecArbreNaire : Expression =
struct
  (* Exception levée quand le code est malformé *)
  exception Malformee
  (* Linéarisation des opérateurs binaire associatif gauche et droit *)
  type op = Moins | Plus | Mult | Div
  type exp = Naire of op * exp list | Valeur of int

  
(* bienformee : exp -> bool *)
(* Vérifie qu'un arbre n-aire représente bien une expression n-aire *)
(* c'est-à-dire que les opérateurs d'addition et multiplication ont au moins deux opérandes *)
(* et que les opérateurs de division et soustraction ont exactement deux opérandes.*)
(* Paramètre : l'arbre n-aire dont ont veut vérifier si il correspond à une expression *)
let bienformee arbre = 
  match arbre with 
  |Valeur t -> true
  |Naire (Moins, l) -> List.length l = 2
  |Naire (Div, l) -> List.length l = 2
  |Naire (Mult, l) -> List.length l > 1
  |Naire (Plus, l) -> List.length l > 1

let en1 = Naire (Plus, [ Valeur 3; Valeur 4; Valeur 12 ])
let en2 = Naire (Moins, [ en1; Valeur 5 ])
let en3 = Naire (Mult, [ en1; en2; en1 ])
let en4 = Naire (Div, [ en3; Valeur 2 ])
let en1err = Naire (Plus, [ Valeur 3 ])
let en2err = Naire (Moins, [ en1; Valeur 5; Valeur 4 ])
let en3err = Naire (Mult, [ en1 ])
let en4err = Naire (Div, [ en3; Valeur 2; Valeur 3 ])

let%test _ = bienformee en1
let%test _ = bienformee en2
let%test _ = bienformee en3
let%test _ = bienformee en4
let%test _ = not (bienformee en1err)
let%test _ = not (bienformee en2err)
let%test _ = not (bienformee en3err)
let%test _ = not (bienformee en4err)

(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Précondition : l'expression est bien formée *)
(* Résultat : la valeur de l'expression *)
let rec eval_bienformee arbre = 
  match arbre with
    |Valeur e -> e
    |Naire (Moins, (Valeur exp1)::((Valeur exp2)::[])) -> exp1 - exp2
    |Naire (Plus, (Valeur exp1)::((Valeur exp2)::[])) -> exp1 + exp2
    |Naire (Mult, (Valeur exp1)::((Valeur exp2)::[])) -> exp1 * exp2
    |Naire (Div, (Valeur exp1)::((Valeur exp2)::[])) -> exp1 / exp2
    |Naire (Mult, (t::q)) -> (eval_bienformee t) * (eval_bienformee (Naire(Mult, q)))
    |Naire (Plus, (t::q)) -> (eval_bienformee t) * (eval_bienformee (Naire(Mult, q)))

let%test _ = eval_bienformee en1 = 19
let%test _ = eval_bienformee en2 = 14
let%test _ = eval_bienformee en3 = 5054
let%test _ = eval_bienformee en4 = 2527

(* Définition de l'exception Malformee *)
(* TO DO *)

(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Résultat : la valeur de l'expression *)
(* Exception  Malformee si le paramètre est mal formé *)
let eval  = fun _ -> assert false

let%test _ = eval en1 = 19
let%test _ = eval en2 = 14
let%test _ = eval en3 = 5054
let%test _ = eval en4 = 2527
(*
let%test _ =
  try
    let _ = eval en1err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en2err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en3err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en4err in
    false
  with Malformee -> true
*)
end