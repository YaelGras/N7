%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Analyse de donnees
% TP4 - Reconnaissance de chiffres manuscrits par k plus proches voisins
% TP4AD.m
%--------------------------------------------------------------------------

clear
close all
clc

% Chargement des images d'apprentissage et de test
load MNIST

%   database_test_images       10000x784             
%   database_test_labels       10000x1             
%   database_train_images      60000x784           
%   database_train_labels      60000x1      

DataA = database_train_images;
clear database_train_images
DataT = database_test_images;
clear database_test_images
LabelA = database_train_labels;
clear database_train_labels
LabelT = database_test_labels;
clear database_test_labels

% Choix du nombre de voisins
K = 1;

% Initialisation du vecteur des classes
ListeClass = 0:9;

% Nombre d'images test
[Nt,~] = size(DataT);
Nt_test = 200; % A changer, pouvant aller de 1 jusqu'à Nt

% Classement par l'algorithme des k-ppv
[Partition, Confusion, Erreur] = kppv(DataA, LabelA, DataT, LabelT, Nt_test, K, ListeClass);

% affichage des images avec leur label calculé
display(Confusion);
display(Erreur);

figure('Name', "Images avec leur label calculé")
grille = round(sqrt(Nt_test));
if (grille ~= sqrt(Nt_test))
    grille = grille + 1;
end

icour = 0;

for i = 1:Nt_test
    if grille <= 10 
        subplot(grille, grille, i)
        imshow(reshape(DataT(i,:), [28, 28]));
        title(Partition(i));
    else 
        if icour >= 100
            figure('Name', "Images avec leur label calculé")
            icour = 0;
        end
        icour = icour + 1;
        subplot(10, 10, icour)
        imshow(reshape(DataT(i,:), [28, 28]));
        title(Partition(i));
    end
end
