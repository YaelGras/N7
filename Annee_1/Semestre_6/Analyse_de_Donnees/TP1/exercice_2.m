clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread(['Quizz_GroupeMN/ishihara-35.png']);
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
X = [R(:) V(:) B(:)];			% Les trois canaux sont vectorises et concatenes
[n, ~] = size(X);
g = (1/n) * X' * ones(n,1);

X_centree = X - ones(n,1)*g';

% Matrice de variance/covariance :

Sigma =  (1/n) * (X_centree') * X_centree;

%ACP
[W, D] = eig(Sigma);
[diag, indice] = sort(diag(D), 'descend');
W(:,:) = W(:,indice); %tri des vecteur propres selon la valeur des valeurs propres

%C = [X * W(:,1) X * W(:,2) X * W(:,3)];
C = X_centree * W;

[n,m,o] = size(I);
Image = zeros(size(I));
Image(:,:,1) = reshape(C(:,1), [n, m]);
Image(:,:,2) = reshape(C(:,2), [n, m]);
Image(:,:,3) = reshape(C(:,3), [n, m]);

figure('Name',"Image sur le nouveau repère")
imagesc(Image);


% Matrice de variance/covariance :

Sigma =  (1/n) * (C') * C;

% Coefficients de correlation lineaire :
coeff_RV = Sigma(1,2)/sqrt(Sigma(1,1)*Sigma(2,2));

coeff_RB = Sigma(1,3)/sqrt(Sigma(1,1)*Sigma(3,3));

coeff_VB = Sigma(2,3)/sqrt(Sigma(2,2)*Sigma(3,3));

% Proportions de contraste :
c_R = (Sigma(1,1)^2 / (Sigma(1,1)^2 + Sigma(2,2)^2 + Sigma(3,3)^2));
c_V = (Sigma(2,2)^2 / (Sigma(1,1)^2 + Sigma(2,2)^2 + Sigma(3,3)^2));
c_B = (Sigma(3,3)^2 / (Sigma(1,1)^2 + Sigma(2,2)^2 + Sigma(3,3)^2));
