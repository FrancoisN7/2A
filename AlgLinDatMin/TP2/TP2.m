% Récupération des données
DataSagittale=load("DataSagittale.mat");
DataTransverse=load("DataTransverse.mat");
ToyExample=load("ToyExample.mat");
m = 64*54;
n = 20;

% Pour S
Image_DataS = DataSagittale.Image_DataS;
Image_ROI_S = DataSagittale.Image_ROI_S;
DataS=reshape(Image_DataS,m,n);

% Pour T
Image_DataT = DataTransverse.Image_DataT;
Image_ROI_T = DataTransverse.Image_ROI_T;
DataTempsT=reshape(Image_DataT,m,n);
DataT=reshape(Image_DataT,m,n);

% Exemple test avant résultats
Data = ToyExample.Data;

figure(1)
imagesc(Image_ROI_T);
[A, D, L, Y, Clusters] = classification_spectrale(DataT, 5, 2);

figure(2)
imagesc(reshape(Clusters, 64, 54));