(*  Exercice à rendre **)
(*  pgcd : int -> int -> int
   calcule le plus grand diviseur commun entre deux entiers
   Parametre a : int, le premier entier
   Parametre b : int, le second entier
   Resultat : int, le plus grand diviseur commun entre a et b*
   Pré-condition : a!=0 et b!= 0 *)

let  pgcd a b = 
let rec pgcdrec a b =
  if (a=b) then a 
  else 
     if  (a>b) then pgcdrec (a-b) (b)
    else pgcdrec (a) (b-a)
and absolu a = if (a>=0) then a else -a
in pgcdrec (absolu a) (absolu b)

let%test _ = pgcd 4 4 = 4
let%test _ = pgcd 18 12 = 6
let%test _ = pgcd 11 13 = 1
let%test _ = pgcd 6 3 = 3
let%test _ = pgcd (-8) (-12) = 4
let%test _ = pgcd (-8) 4 = 4
let%test _ = pgcd 12 (-18) = 6 
 

