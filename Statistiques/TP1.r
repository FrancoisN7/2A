# Exercice 1
bissextile <- function(annee){
    bis <- FALSE
    if (annee%%4==0 & annee%%100!=0){
        bis <- TRUE
    }

    else if (annee%%400==0){
        bis <- TRUE
    }
    return(bis)
}

liste_bis <- function(annee){
    annees = annee:2023
    return(annees[((annees%%4==0) & (annees%%100!=0))|
                    (annees%%400==0)])
}




### Exercice 2
# Question 1
# Génération de 1000 vecteurs de dim 12 suivant une loi uniforme
A = matrix(runif(12000),nrow=12)
# Question 2 : histogramme
hist(A)

# Question 3
# Calculer les moyennes des 1000 vecteurs
M = apply(A,2,mean)
hist(M)
# Supprimer A
rm(A)
# Tout supprimer
rm(list=ls())





### Exercice 3
# Question 1 : Récupération de la base de données connue
data(iris)
# Calcul des stats de base
summary(iris)

# Question 2 : Extraction des versicolor
iris2 = iris[iris$Species=="versicolor",]
# Calcul des stats de base
summary(iris2)

# Tri par ordre décroissant de iris2 
# en fonction de la variable Sepal.Length
indices = order(iris2$Sepal.Length, decreasing = TRUE)
print(indices)
iris3 = iris2[indices,]
print(iris3)



### Exercice 4
# Récupération de ozone
data = read.table("ozone.txt", header = TRUE)

# Afficher les valeurs de max03 associées aux valeurs de T15>30
print(data$T15)
print(data$maxO3[data$T15>30])

# Créer une extraction data2
data2 = data[data$pluie=="Sec",]

# Trier par ordre croissant en fonction de T12
indices = order(data2$T12, decreasing = TRUE)
print(indices)
data3 = data2[indices,]
summary(data3)

# Tracer l'histogramme et la boîte à moustache relatifs à Ne9
