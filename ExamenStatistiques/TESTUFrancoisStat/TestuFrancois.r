## 1 Chargement des données
data = read.table("Data.txt", header = TRUE)
summary(data)

## 2 Régression simple 
lm.out1 = lm(O3~O3v, data)
summary(lm.out1)

plot(data$O3v,data$O3)
#Ajout de la droite sur le graphe
abline(lm.out1,col="red")

# Analyse
# On lit d'abord que le modèle explique seulement 46,9% de la variance du prédictant -> C'est peu
# On voit que la régressilm.out2 = lm(O3~O3v+T+N+FF+DD+RR, data)on linéaire est mauvaise. Le nuage de points ne correspond en effet pas à une droite.
# Cependant, on voit quand même que le prédictant O3v a une importance. (Sa p_value est d'ailleurs bien inférieure à 0.05)
# Il faut donc ajouter des prédictants. 




## 3 Modèles sans interaction
# Extraction des modalités "Pluie" et "Sec"

# Extraction de la modalité "Pluie"
dataRRPluie = data[data$RR=="Pluie",]
summary(dataRRPluie)
       O3              T               N               FF         
 Min.   : 42.0   Min.   :11.30   Min.   :1.000   Min.   :-6.1284  
 1st Qu.: 63.0   1st Qu.:15.45   1st Qu.:5.500   1st Qu.:-4.4632  
 Median : 70.0   Median :16.90   Median :7.000   Median :-2.9544  
 Mean   : 73.4   Mean   :16.85   Mean   :6.209   Mean   :-2.6252  
 3rd Qu.: 77.5   3rd Qu.:18.20   3rd Qu.:7.000   3rd Qu.:-0.8172  
 Max.   :117.0   Max.   :21.60   Max.   :8.000   Max.   : 2.0000  
      O3v             DD         RR    
 Min.   : 42.00   Est  : 1   Pluie:43  
 1st Qu.: 65.50   Nord :34   Sec  : 0  
 Median : 72.00   Ouest: 4             
 Mean   : 77.19   Sud  : 4             
 3rd Qu.: 85.00                        
 Max.   :126.00  
 
# Extraction de la modalité "Sec"
dataRRSec = data[data$RR=="Sec",]
summary(dataRRSec)
       O3              T              N              FF         
 Min.   : 63.0   Min.   :13.3   Min.   :0.00   Min.   :-7.8785  
 1st Qu.: 79.0   1st Qu.:16.9   1st Qu.:1.00   1st Qu.:-1.5321  
 Median : 92.0   Median :19.2   Median :4.00   Median : 0.0000  
 Mean   :100.8   Mean   :19.3   Mean   :4.13   Mean   :-0.3351  
 3rd Qu.:114.0   3rd Qu.:20.9   3rd Qu.:7.00   3rd Qu.: 1.0000  
 Max.   :166.0   Max.   :27.0   Max.   :8.00   Max.   : 5.1962  
      O3v             DD         RR    
 Min.   : 54.00   Est  : 3   Pluie: 0  
 1st Qu.: 76.00   Nord :31   Sec  :69  
 Median : 90.00   Ouest: 6             
 Mean   : 98.91   Sud  :29             
 3rd Qu.:116.00                        
 Max.   :166.00
 
# On remarque que les valeurs de O3 sont plus faibles en temps de pluie et plus fortes en temps sec
# Le paramètre semble donc avoir une importance significative dans la prédiction de O3
# Nous chercherons à réfuter ou non cette hypothèse par la suite avec une régression.

# Modèle lm.out2
lm.out2 = lm(O3~O3v+T+N+FF+DD+RR, data)
summary(lm.out2)

# Impact de la variable N
# La p_value de la variable N est <0.05. On peut donc rejeter l'hypothèse nulle. La variable N a une importance 
# pour prédire O3.

# Interprétation des résultats relatifs au facteur DD
# La p_value de DD_Ouest ne permet pas de rejeter HO. Elle ne semnble pas très intéressante pour la prédiction.
# A l'inverse les p_value de DDNord et DDSud sont <0.05 -> rejet de H0. 
# Les variables DDNord et DDSud ont une importance pour prédire O3


# Hypothèses sur l'erreur du cadre théorique du modèle 
# normales
# centrées
# indépendantes
# homoscédasticité (var cte)

# Analyse de l'homoscédasticité
plot(fitted(lm.out2),residuals(lm.out2)) #Il faut que les valeurs soient en forme de bande
# Regarder si la structure est en cône ou en bande(rectangulaire)
# Ici les valeurs ne sont pas tellement en forme de bande

# Analyse de la normalité
#Tracé de l'histogramme
hist(residuals(lm.out2))
mean(residuals(lm.out2)) #moyenne nulle (centrée)
# Ici on est assez proche d'une allure normale

#Tracé un diagramme quantile-quantile
qqnorm(residuals(lm.out2)) #Si les données suivent une loi normale, on trouve une droite
#Si il y a une droite sur le milieu mais pas sur les extrêmes c'est OK car le modèle du 
# prédictand avec l'espérance fait qu'on ne considère pas bien les valeurs extrêmes
# Ici, c'est exeactement le cas. L'hypothèse est validéé.

#Indépendance entre les varaibles
#Calcul de l'autocorrélation 
acf(residuals(lm.out2)) #Au départ (le premier pic est forcément à 1)
# Idéalement, il faudrait que ce soit nul ensuite
# On considère que c'est nul quand les pics sont en dessous des pointillés bleus
# Si il y a la plupart considéré nul, on considère que les variables sont bien indépendantes
# Ici, on respecte bien ce critère. Les variables sont bien indépendantes.

# Regroupement des 4 graphiques importants
par(mfrow=c(2,2))
plot(fitted(lm.out2),residuals(lm.out2))
hist(residuals(lm.out2))
qqnorm(residuals(lm.out2))
acf(residuals(lm.out2)) 

# Bilan 
# normales -> OK
# centrées -> OK
# indépendantes -> OK
# homoscédasticité (var cte) -> pas terrible

# Prédicteurs à conserver
# Il faut conserver les prédicteurs avec une p_value < 0.05. C'est-à-dire, il faut conserver O3v, T, N, DDNord, DDSud. 
# Remarque : Finalement, l'intuition de départ sur RR n'était à priori pas la bonne.



# Modèle BIC
library(MASS)
lm.outBIC = stepAIC(lm.out2, k=log(nrow(data)))
# Le modèle BIC a lui aussi finalement conservé O3v, T, N et DD.





# 4 Modèles avec interactions
lm.outBICint = stepAIC(lm(O3~.*.,data), k=log(nrow(data)))
# Ce modèle BIC a finalement conservé l'interaction T:FF ainsi que N, 03V et DD. Il y a une dimension 4 car il y a 4 prédicteurs. 
#On retrouve presque les mêmes prédicteurs que précédemment sauf T qui est maintenant en intéraction avec FF.


# 5 Visualisation des prévisions
plot(data$O3, type="l")
points(fitted(lm.out1), col="red", pch="+")
points(fitted(lm.outBICint), pch= "+", col="blue")
# Il est difficile d'analyser précisément des choses sur cette courbe
# On peut néanmoins dire que les 2 modèles suivent à peu près la forme de O3. C'est cohérent
# On remarque néanmois que certains points bleus ont tendance à s'éloigner de la courbe. Peut-être que ce modèle 
# est un peu moins bon mais ce n'est qu'une hypothèse à vu d'oeil.


# 6 Evaluation des modèles
# Création de dataapp et datatest
nappr = round(0.8*nrow(data))
ii = sample(1:nrow(data), nappr)
jj = setdiff(1:nrow(data), ii)
dataapp = data[ii,]
datatest = data[jj,]

# On refait les modèles mais sur dataapp
lm.out1app = lm(O3~O3v, dataapp)
lm.out2app = lm(O3~O3v+T+N+FF+DD+RR, dataapp)
lm.outBICapp = stepAIC(lm.out2app, k=log(nrow(dataapp)))
lm.outBICintapp = stepAIC(lm(O3~.*.,dataapp), k=log(nrow(dataapp)))

# Calcul du biais et de la rmse
eval=function(obs,prev){
    biais = mean(prev-obs)
    rmse = sqrt(mean((prev-obs)**2))
    return(round(c(biais,rmse),3))
}

# Sur dataapp
eval(dataapp$O3, fitted(lm.out1app))
[1]  0.000 20.978
eval(dataapp$O3, fitted(lm.outBICapp))
[1]  0.000 12.092
eval(dataapp$O3, fitted(lm.outBICintapp))
[1]  0.000 11.536

# Sur datatest
eval(datatest$O3, predict(lm.out1app,datatest))
[1]  2.493 18.384
eval(datatest$O3, predict(lm.outBICapp,datatest))
[1]  1.047 10.304
eval(datatest$O3, predict(lm.outBICintapp,datatest))
[1] 1.334 8.629

# Les meilleurs résultats (résultats les plus proches de 0 sur datatest) sont obtenus par lm.outBICintapp
# C'est-à-dire la 3e méthode

# Comparaison à la solution triviale
eval(dataapp$O3, dataapp$O3v)
[1] -0.044 23.381
eval(datatest$O3, datatest$O3v)
[1]  1.545 17.362
# On retrouve ici un fort RMSE pour la solution triviale. Les modèles lm.outBICapp 
# et lm.outBICintapp semblent meilleurs. Pour ce qui est du modèle lm.out1app, les résultats semblent 
# meilleurs avec la solution triviale -> ce n'est donc vraiment pas un bon modèle.

# Appel du fichier CV.R
source("CV.R")

# Je n'ai pas eu le temps de bien modifié le fichier. Il faudrait choisir le modèle qui correspond 
# aux boîtes à moustache qui à la fois :
# - coïncide bien entre les valeurs dataapp et datatest
# maximise le PSS
