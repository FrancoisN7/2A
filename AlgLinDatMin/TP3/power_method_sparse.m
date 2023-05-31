function [r, k]=power_method_sparse(Q,v,alpha,eps)
% Algorithme de la puissance it?r?e dans le cas "creux"
% Q est la matrice repr?sentative du graphe d'Internet.
% v est le vecteur de personalisation.
% alpha est le param?tre de poids.
% eps est la pr?cision souhait?e (crit?re d'arret).
% r est le vecteur propre assoic?e ? la valeur propre 1.

% Initialisation
n=length(Q(:,1));
r=ones(n,1)./n;
e = ones(n,1);
k = 0;
non_convergence = true; 

while non_convergence
    % Calcul du produit Qr
    Qr = Q * r;
    % Calcul du produit scalaire d,r
    ps_dr = 1 - e' * Qr;
    % Calcul de q
    q = alpha * (Qr + 1/n * ps_dr * e) + (1-alpha)*v;
    % Calcul de la condition de convergence
    non_convergence = (norm(q-r,1)>=eps*norm(q,1));
    % Sauvegarde de la valeur de r
    r = q;
    % Incrémentation
    k = k + 1;
end
end