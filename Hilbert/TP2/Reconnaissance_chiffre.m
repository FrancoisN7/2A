% Ce programme est le script principal permettant d'illustrer
% un algorithme de reconnaissance de chiffres.

% Nettoyage de l'espace de travail
clear all; close all;

% Repertories contenant les donnees et leurs lectures
addpath('Data');
addpath('Utils');

rng('shuffle')


% Bruit
sig0=0.2;

%tableau des csores de classification
% intialisation aléatoire pour affichage
r=rand(6,5);
r2=rand(6,5);

for k=1:5
% Definition des donnees
file=['D' num2str(k)]

% Recuperation des donnees
disp('Generation de la base de donnees');
sD=load(file);
D=sD.(file);
%

% Bruitage des données
Db= D+sig0*randn(size(D));


%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des donnees 
%%%%%%%%%%%%%%%%%%%%%%%
disp('PCA : calcul du sous-espace');
% Matrice des donnees :
X_non_centre = Db; % Les trois canaux sont vectorises et concatenes
n = size(Db,1);
m = size(Db,2);
X_centre = zeros(n,m);
Moyenne_X = zeros(n,1);
for p=1:m
    Moyenne_X(p,1) = sum(X_non_centre(p,:))/length(X_non_centre(p,:));
    X_centre(p,:) = X_non_centre(p,:) - Moyenne_X(p);
end
X = X_centre;

% Matrice de variance/covariance :
Sigma = 1/size(X,1)* X*transpose(X);

% Calcul des valeurs propres et des vecteurs propres :
[Vecteurs_propres,Valeurs_propres] = eig(Sigma);

% Trier les valeurs propres par ordre décroissant :
[Valeurs_propres_triees, indices] = sort (diag(Valeurs_propres), 'descend');
% disp(Valeurs_propres_triees);
Vecteurs_propres_triees= Vecteurs_propres(:,indices);


% Trouver le nombre nb_comp_princ qui permet de satisfaire le tau de précision
tau = 0.3;
p = 2;
d1 = Valeurs_propres_triees(1);
dp = Valeurs_propres_triees(2);
ecart = sqrt(dp/d1);
while tau<ecart
    dp = Valeurs_propres_triees(p);
    ecart = sqrt(dp/d1);
    disp(ecart);
    p=p+1;
end
nb_comp_princ = p;
% Calculer la matrice C des composantes principales des pixels comme la projection de l'image de
%départ I par la matrice de passage Vecteurs_propres :
U = Vecteurs_propres_triees(:,1:nb_comp_princ);
C = Vecteurs_propres_triees(:,1:nb_comp_princ)*transpose(X(:,1:nb_comp_princ));



disp('kernel PCA : calcul du sous-espace');
%%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
%Calcul de K
K = zeros(n,n);
for p=1:n
    for j = 1:n
        K(p,j) = D(p,:)*D(j,:)';
    end
end

M_1N = 1/n*ones(n,n);
K_centre = K - M_1N * K - K * M_1N + M_1N * K * M_1N;
K_non_centre = K;
K = K_centre;

% Matrice de variance/covariance :
Sigma_K = 1/size(K,1)* K*transpose(K);

% Calcul des valeurs propres et des vecteurs propres :
[Vecteurs_propres_K,Valeurs_propres_K] = eig(Sigma_K);

% Trier les valeurs propres par ordre décroissant :
[Valeurs_propres_triees_K, indices_K] = sort (diag(Valeurs_propres_K), 'descend');
% disp(Valeurs_propres_triees);
Vecteurs_propres_triees_K = Vecteurs_propres(:,indices_K);


% Trouver le nombre nb_comp_princ qui permet de satisfaire le tau de précision
tau = 0.3;
p = 2;
d1 = Valeurs_propres_triees_K(1);
dp = Valeurs_propres_triees_K(2);
ecart = sqrt(dp/d1);
while tau<ecart
    dp = Valeurs_propres_triees_K(p);
    ecart = sqrt(dp/d1);
    disp(ecart);
    p=p+1;
end
nb_comp_princ = p;
% Calculer la matrice C des composantes principales des pixels comme la projection de l'image de
%départ I par la matrice de passage Vecteurs_propres :
U_K = Vecteurs_propres_triees_K(:,1:nb_comp_princ);

%Création des alpha
alpha_K = U_K;
for i=1:nb_comp_princ
    alpha_K(:,i) = U_K(:,i)/sqrt(Valeurs_propres_triees_K(i));
end
C_K = alpha_K*transpose(K(:,1:nb_comp_princ));




%%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reconnaissance de chiffres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Lecture des chiffres à reconnaitre
 disp('test des chiffres :');
 tes(:,1) = importerIm('test1.jpg',1,1,16,16);
 tes(:,2) = importerIm('test2.jpg',1,1,16,16);
 tes(:,3) = importerIm('test3.jpg',1,1,16,16);
 tes(:,4) = importerIm('test4.jpg',1,1,16,16);
 tes(:,5) = importerIm('test5.jpg',1,1,16,16);
 tes(:,6) = importerIm('test9.jpg',1,1,16,16);

 for tests=1:6
    % Bruitage
    tes(:,tests)=tes(:,tests)+sig0*randn(length(tes(:,tests)),1);
    
    % Classification depuis ACP
     %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
     disp('PCA : classification');
     tes_centre(:,tests) = tes(:,tests) - Moyenne_X;
     r(tests,k) = norm((eye(n,n)-U*U')*tes_centre(:,tests))/norm(tes_centre(:,tests));

     if(tests==k)
       figure(100+k)
       subplot(1,2,1); 
       imshow(reshape(tes(:,tests),[16,16]));
       subplot(1,2,2);
       %imshow(reshape(C'*C*tes_centre(:,tests) + sum(tes(:,tests)/length(tes(:,tests))),[16,16]));
       imshow(reshape((eye(n,n)-U*U')*tes_centre(:,tests) + U*U'*Moyenne_X,[16,16]));
     end  
    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%
  
   % Classification depuis kernel ACP
     %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
     disp('kernel PCA : classification');
     disp('TO DO')

    %% Calcul de la distance
    % Calcul de norm(Pik(Phi(x)-m))^2
    S1 = 0;
    v_diff = zeros(m,1);
    v_diff_2 = zeros(m,1);
    t2_s2 = 0;
    x =0;
    somme_k=0;
    valeur =0;
    for l=1:r
        for a=1:r
            % Création d'un vecteur utile au calcul
            somme_k = 0;
            for h =1:m
                valeur = calcul_k(Db(:,l),Db(:,h));
                somme_k = somme_k + 1/m*valeur;
                disp(somme_k);
            end
    
            % Calcul du vecteur des différences
            for h =1:m
                v_diff(h,1) = calcul_k(tes(:,tests),Db(:,h)) - somme_k;
                x = calcul_k(tes(:,tests),Db(:,h)) - somme_k;
                disp(x)
            end
    
            % Mise à jour de la somme globale
            S1 = S1 + (alpha_K(:,l)'*v_diff)*(alpha_K(:,a)'*v_diff) * alpha_K(:,l)'*K_non_centre*alpha_K(:,a);
            t2_s2 = t2_s2 + somme_k;
            disp(S1);
        end
    end

    % Calcul de norm(Phi(x)-m)^2
    % Calcul du terme 1 
    t1_s2 = 0;
    for h =1:m
        t1_s2 = t1_s2 + calcul_k(Db(:,i),tes(:,tests));
    end
    
    % Calcul du terme 2
    t2_s2 = 1/m * t2_s2;

    S2 = calcul_k(tes(:,tests),tes(:,tests)) - 2/m * t1_s2 + (1/m)^2 * t2_s2;

    r2(tests,k) = sqrt(1-S1/S2);
    

    
     if(tests==k)
       figure(100+k)
       subplot(1,2,1); 
       imshow(reshape(tes(:,tests),[16,16]));
       subplot(1,2,2);
       %imshow(reshape(C'*C*tes_centre(:,tests) + sum(tes(:,tests)/length(tes(:,tests))),[16,16]));
       imshow(reshape((eye(n,n)-U_K*U_K')*tes_centre(:,tests),[16,16]));
     end  
    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%    
 end
end


% Affichage du résultat de l'analyse par PCA
couleur = hsv(6);

figure(11)
for tests=1:6
     hold on
     plot(1:5, r(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r(tests,i):(r(tests,i+1)-r(tests,i))/10:r(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r(tests,5),num2str(testa));
     hold off
 end

% Affichage du résultat de l'analyse par kernel PCA
figure(12)
for tests=1:6
     hold on
     plot(1:5, r2(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r2(tests,i):(r2(tests,i+1)-r2(tests,i))/10:r2(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r2(tests,5),num2str(testa));
     hold off
 end
