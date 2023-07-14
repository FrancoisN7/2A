### Exercice 4
# Récupération de ozone
data = read.table("DataTP.txt", header = TRUE)

# Afficher les valeurs de max03 associées aux valeurs de T15>30
print(data$STATION)
print(data$maxO3[data$T15>30])

# Créer une extraction data2
data_Aix = data[data$STATION=="Aix",]
# Calcul des stats de base
summary(data_Aix)

#Calcul des variances de O3o et O3p
variance_O3o = var(data_Aix$O3o)
variance_O3p = var(data_Aix$O3p)
print(variance_O3o)
print(variance_O3p)
#Calcul des écart-types de O3o et O3p
e_O3o = sd(data_Aix$O3o)
e_O3p = sd(data_Aix$O3p)
print(e_O3o)
print(e_O3p)

#Comparer les variances de O3o et O3p
#On teste si le rapport des variances peut être considéré comme égal à 1 (H0 : v1/v2 = 1)
#Si p_val > 0.05, non rejet de l'hypothèse H0, sinon on rejette H0
var.test(data_Aix$O3o,data_Aix$O3p)

#On teste si la différence des moyennes peut être considéré comme égale à 0 (H0 : m1-m2 = 0)
#Si p_val > 0.05, non rejet de l'hypothèse H0, sinon on rejette H0
# var.equal = TRUE -> test de Student (les variances sont considérées égales)
# var.equal = FALSE -> test de Welch (les variances sont considérées différentes)
t.test(data_Aix$O3o,data_Aix$O3p,var.equal = TRUE)


#Tracés d'histogrammes
#Pour la fenêtre graphique(mettre les 2 à coté)
par(mfrow=c(1,2))
hist(data_Aix$O3o, breaks = seq(0,300,30), ylim = c(0, 100))
hist(data_Aix$O3p, breaks = seq(0,300,30), ylim = c(0, 100))

#Diagramme moustaches
boxplot(data_Aix$O3o,data_Aix$O3p, names=c("obs", "prev"))


#Coefficient de corrélation
cor(data_Aix$O3o,data_Aix$O3p)
#On teste si le coefficient de corrélation est nul (H0 : r = 0)
cor.test(data_Aix$O3o,data_Aix$O3p)


#Tracer le nuage de points(plot)
plot(data_Aix$O3p,data_Aix$O3o)


#Faire un modèle de régression linéaire
regsimple = lm(data_Aix$O3o~data_Aix$O3p, data_Aix)
#Savoir ce qu'il y a dans regsimple
# Dans coefficients, il y a Beta
# Dans residuals, il y a Epsilon
# Dans fitted-values, il y a Y
names(regsimple)
#Résumé du modèle
summary(regsimple)

#Ajout de la droite sur le graphe
abline(regsimple,col="red")


#Représenter la série chronologique relative à l'ozone O3o
plot(data_Aix$O3o, type="l")
points(data_Aix$O3p, col = 'blue', pch ='+')
points(fitted(regsimple), col="red", pch ="+")
#Ajout de croix bleues pour O3phist(data$FF)







## Partie 2
par(mfrow=c(2,3))
hist(data_Aix$O3p, breaks = seq(0,300,30), ylim = c(0, 100))
hist(data$TEMPE)
hist(data$RMH2O)
hist(data$NO2)
# Utilisation du log pour augmenter la corrélation entre prédicteur et prédictand -> Plus proche du modèle gaussien du prédictand
hist(log(data$NO2))
hist(data$FF)
