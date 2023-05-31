% Définition de f
J = 10;
N = 2^J;
X = linspace(0,2,N);
f = sqrt(abs(cos(2*pi*X)));
plot(X,f);
[matrice_moy, D] = decomposition_Haar(f, J);
C = recomposition_Haar(matrice_moy, D, J);
plot(C,f);