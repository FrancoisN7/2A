% Algorithme 1 : Spectral Clustering Algorithm
%% 1/ Construction de la matrice affinité
function [A, D, L, Y, Clusters] = classification_spectrale(S, k, sigma)
[n, p] = size(S);
display(p);
display(n);
A = zeros(n);
for i=1:n
    xi = S(i,:);
    for j=1:n
        xj = S(j,:);
        A(i,j) = exp(-norm(xi-xj)^2/(2*sigma^2));
    end
end
% On veut la diagonale nulle
A = A - eye(n);

%% 2/ Construction de la matrice normalisée L
D = zeros(n);
racD = zeros(n);
for i=1:n
    D(i,i)= sum(A(i,:));
    racD(i,i) = 1/sqrt(D(i,i));
end

% Calcul de L
L = racD * A * racD;



%% 3/ Construction de la matrice X formée des k plus grands vecteurs propres de L
% Calcul des valeurs propres et des vecteurs propres :
[Vecteurs_propres,Valeurs_propres] = eig(L);

% Trier les valeurs propres par ordre décroissant :
[Valeurs_propres_triees, indices] = sort(diag(Valeurs_propres), 'descend');
Vecteurs_propres_triees= Vecteurs_propres(:,indices);
X = Vecteurs_propres_triees(:,1:k);

%% 4/ Construction de la matrice Y formée en normalisant les lignes de X
Y = X;
for j=1:k
    Y(:,j) = X(:,j)/norm(X(:,j),2);
end

%% 5/ Traiter chaque ligne de Y comme un point de R^k et les classer en k clusters via la méthode K-means
[IDX, C] = kmeans(Y, k);

%% 6/ Assigner le point original xi au cluster j si et seulement si la ligne i de la
% matrice Y est assignée au cluster j
Clusters = IDX;