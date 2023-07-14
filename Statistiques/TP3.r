data = read.table("DataTP.txt", header = TRUE)
library(MASS);library(verification)
# Création de deux nouvelles colonnes dans data
data$OCC = as.factor(as.numeric(data$O3o>180))
data$OCCp = as.factor(as.numeric(data$O3p>180))
summary(data)

# Import de la fonction scores
source("scores.R")
scores(data$OCCp, data$OCC)

# On ne prend pas la 2e data car elle n'est plus un prédictant
glm.out=glm(OCC~.,data[,-2], family=binomial)
summary(glm.out)
glm.outBIC = stepAIC(glm.out, k =log(nrow(data)))
names(glm.out)

roc.plot(as.numeric(data$OCC)-1, fitted(glm.out))
# 0.1 et 0.5 sont des seuils choisis avec la courbe ROC)
# On veut être au plus proche du point (1,1). On veut la plus petite distance 
# avec la courbe et (1,1). 
scores(fitted(glm.out)>0.5, data$OCC)
scores(fitted(glm.out)>0.1, data$OCC)
