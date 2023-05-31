function [Q]=matrix_representation(A,n)
% Représentation sous forme de matrice du graphe Internet
% A contient les arcs du graphe orienté.
% n représente le nombre de sommets.
% Q est la matrice du graphe Internet.

% Initialisation
% Q = spones(A);
Q = sparse(A(:,1),A(:,2), ones(length(A(:,1)), 1), n, n);
S = sum(Q, 1);
Q = Q*diag(1./S);
end