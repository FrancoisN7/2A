# Partie 3
data = read.table("DataTP.txt", header = TRUE)
# Affichage des nuages de points de tous les prédicteurs
pairs(data[,c(-1,-7)])
# Régression de l'ozone observé par certains prédicteurs
regmult = lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF,data)
# Analyse des lois
summary(regmult) # PLus la p_value est faible, plus le prédicteur est intéressant

# Hypothèses du cadre théorique du modèle
# normales
# centrées
# indépendantes
# homoscédasticité (var cte)

# Analyse de l'homoscédasticité
plot(fitted(regmult),residuals(regmult)) #Il faut que les valeurs soient en forme de bande
# Regarder si la structure est en cône ou en bande(rectangulaire)

# Analyse de la normalité
#Tracé de l'histogramme
hist(residuals(regmult))
mean(residuals(regmult)) #moyenne nulle (centrée) pour l'anecdote

#Tracé un diagramme quantile-quantile
qqnorm(residuals(regmult)) #Si les données suivent une loi normale, on trouve une droite
#Si il y a une droite sur le milieu mais pas sur les extrêmes c'est OK car le modèle du prédictand avec l'espérance fait qu'on ne considère pas bien les valeurs extrêmes

#Indépendance entre les varaibles
#Calcul de l'autocorrélation 
acf(residuals(regmult)) #Au départ (le premier pic est forcément à 1)
# Idéalement, il faudrait que ce soit nul ensuite
# On considère que c'est nul quand les pics sont en dessous des pointillés bleus
# Si il y a la plupart considéré nul, on considère que les variables sont bien indépendantes

# Regroupement des 4 graphiques importants
par(mfrow=c(2,2))
plot(fitted(regmult),residuals(regmult))
hist(residuals(regmult))
qqnorm(residuals(regmult))
acf(residuals(regmult)) 

#Vérifier l'hypothèse de la linéarité de la réponse
#Ce graphe "résume" les précédents
#Le modèle n'est pas adapté au modèle linéaire (si on ne voit pas une forme de droite)



# PARTIE_TP2 (ANOVA)
anoval = lm(O3o~JJ,data)
summary(anoval)
# Le modèle prend comme référence la première valeur qu'il croise (en terme de Alpha)
# JJS = AlphaS - AlphaF -> On a modélisé tel que AlphaF = 0

# On peut imposer la somme nulle avec :
anova2 = lm(O3o~C(JJ,sum),data)


#(ANCOVA)
regcomplet = lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF+STATION+JJ,data)
summary(regcomplet)
#Critère d'Akaïke
# Minimisation de l'indice AIC
library(MASS)
# On retire certains prédictants pour minimiser AIC
regaic = stepAIC(regcomplet)
# Affichage de la régression finale souhaitée/étudiée
formula(regaic)

#On change le coeff 2 par log(n)
regbic = step(AIC, k=log(nrow(data)))
# Affichage de la régression finale souhaitée/étudiée
formula(regbic)



# PARTIE EVALUATION DES MODELES
library(MASS)
plot(data$O3o~O3p,data)
plot(data$O3o, type="l")
points(data$O3p,pch="+", col ="blue")
regsimple = lm(data$O3o~data$O3p, data)
points(fitted(regsimple), col="red", pch="+")
regbicint = stepAIC(lm(O3o~.*.,data),k=log(nrow(data)))
points(fitted(regbicint), pch= "+", col="green")

# Calcul du biais et de la rmse
eval=function(obs,prev){
    biais = mean(prev-obs)
    rmse = sqrt(mean((prev-obs)**2))
    return(round(c(biais,rmse),3))
}

eval(data$O3o, data$O3p)
eval(data$O3o, fitted(regsimple))
eval(data$O3o, fitted(regbicint))


# Création de dataapp et datatest
nappr = round(0.8*nrow(data))
ii = sample(1:nrow(data), nappr)
jj = setdiff(1:nrow(data), ii)
dataapp = data[ii,]
datatest = data[jj,]

# On refait mais sur dataapp
library(MASS)
plot(dataapp$O3o~O3p,dataapp)
plot(dataapp$O3o, type="l")
points(dataapp$O3p,pch="+", col ="blue")
regsimple = lm(O3o~O3p, dataapp)
points(fitted(regsimple), col="red", pch="+")
regbicint = stepAIC(lm(O3o~.*.,dataapp),k=log(nrow(dataapp)))
points(fitted(regbicint), pch= "+", col="green")
regsurap = lm(O3o~.*.*.,dataapp)
length(regsurap$coefficients)

# Calcul du biais et de la rmse
eval=function(obs,prev){
    biais = mean(prev-obs)
    rmse = sqrt(mean((prev-obs)**2))
    return(round(c(biais,rmse),3))
}
eval(dataapp$O3o, dataapp$O3p)
eval(dataapp$O3o, fitted(regsimple))
eval(dataapp$O3o, fitted(regbicint))
eval(datatest$O3o, datatest$O3p)
eval(datatest$O3o, predict(regsimple,datatest))
eval(datatest$O3o, predict(regbicint,datatest))

# Appel du fichier CV.R
source("CV.R")
# Purge de la mémoire
rm(list=ls())
