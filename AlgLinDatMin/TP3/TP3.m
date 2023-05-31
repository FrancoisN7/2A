[m, n] = size(V);
A = sparse(V(:,1), V(:,2), ones(m,1), 6, 6);
disp('valeur de A')
disp(A)
% Calcul de Q
[Q] = matrix_representation(A,6);
disp('valeur de Q')
disp(Q)
% Calcul de P
[P] = columnstochastic_matrix(Q);
disp('valeur de P')
disp(P)
% Calcul de A_alpha,v
alpha = 0.3;
v = rand(6,1);
v = v/norm(v);
[A_av] = irreducible_matrix(P,alpha,v);
disp('valeur de v')
disp(v)
disp('valeur de A_alpha,v')
disp(A_av)

spy(Q)
figure()
spy(P)
figure()
spy(A_av)


% Paramètres
itermax = 500;
[r, k] = power_method_sparse(Q,v,alpha,eps,itermax);
disp('valeur de r')
disp(r)
disp('nombre itérations')
disp(k)