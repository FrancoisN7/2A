clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread('ishihara-0.png');
figure(1);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

% Affichage du canal R :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(R);
axis off;
axis equal;
title('Canal R','FontSize',20);

% Affichage du canal V :
subplot(2,2,3);
imagesc(V);
axis off;
axis equal;
title('Canal V','FontSize',20);

% Affichage du canal B :
subplot(2,2,4);
imagesc(B);
axis off;
axis equal;
title('Canal B','FontSize',20);

% Affichage du nuage de pixels dans le repere RVB :
figure(2);				% Deuxieme fenetre d'affichage
plot3(R,V,B,'b.');
axis equal;
xlabel('R');
ylabel('V');
zlabel('B');
rotate3d;

% Matrice des donnees :
X_non_centre = [R(:) V(:) B(:)]; % Les trois canaux sont vectorises et concatenes
Moyenne_R = sum(R(:))/length(R(:));
Moyenne_V = sum(V(:))/length(V(:));
Moyenne_B = sum(B(:))/length(B(:));
R_centre = R(:) - Moyenne_R;
V_centre = V(:) - Moyenne_V;
B_centre = B(:) - Moyenne_B ;
X = [R_centre V_centre B_centre];


% Matrice de variance/covariance :
Sigma = 1/size(X,1)* transpose(X)*X;

% Coefficients de correlation lineaire :
coeff_correlation_RV = Sigma(1,2)/(sqrt(Sigma(1,1))*sqrt(Sigma(2,2)));
%disp (coeff_correlation_RV);
coeff_correlation_VB = Sigma(2,3)/(sqrt(Sigma(3,3))*sqrt(Sigma(2,2)));
%disp (coeff_correlation_VB);
coeff_correlation_RB = Sigma(1,3)/(sqrt(Sigma(3,3))*sqrt(Sigma(1,1)));
%disp (coeff_correlation_RB);

% Proportions de contraste :
Prop_contraste_R = Sigma(1,1)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));
%disp (Prop_contraste_R);
Prop_contraste_V = Sigma(2,2)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));
%disp (Prop_contraste_V);
Prop_contraste_B = Sigma(3,3)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));
%disp(Prop_contraste_B);

% Calcul des valeurs propres et des vecteurs propres :
[Vecteurs_propres,Valeurs_propres] = eig(Sigma);
% disp (Valeurs_propres);

% Trier les valeurs propres par ordre décroissant :
[Valeurs_propres_triees, indices] = sort (diag(Valeurs_propres), 'descend');
% disp(Valeurs_propres_triees);
Vecteurs_propres_triees= Vecteurs_propres(:,indices);

% Calculer la matrice C des composantes principales des pixels comme la projection de l'image de
%départ I par la matrice de passage Vecteurs_propres :
C = X*Vecteurs_propres_triees(:,1);
% disp (C);

% Affichez les trois colonnes de la matrice C sous forme d’images avec les fonctions reshape et size de
%Matlab :
%disp (R_image);

%disp (V_image);


%disp (B_image);
colormap gray;	
C_image = reshape (C, size(B));

imagesc (C_image);

% Calculez les coefficients de corrélation linéaire et les proportions de contraste dans le nouveau repère
% ainsi que la proportion de contraste obtenue par projection sur la
% première composante principale :
Matrice_correlation = corr (C_image);
disp (Matrice_correlation);



