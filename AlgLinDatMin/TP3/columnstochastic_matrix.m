function [P]=columnstochastic_matrix(Q)
% Modification par une matrice de rang 1 afin d'obtenir une matrice
% stochastique par colonne
% Q est la matrice carr?e du graphe d'internet. 
% P est la matrice carr?e du graphe d'internet modifi?.


% Initialisation
n=length(Q(:,1));
S = (sum(Q, 1))';
d = 1-spones(S);
e = ones(n,1);
P = Q + 1/n * e * d';
end