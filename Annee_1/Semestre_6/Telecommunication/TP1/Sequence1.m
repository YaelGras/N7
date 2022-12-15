clear all;
close all;
clc
%% Données :
Fe = 24000;
Te = 1/Fe;
Rb = 3000;
Tb = 1/Rb;

nb_bits = 10000;
bits = randi([0,1], 1, nb_bits);
Temission = nb_bits / Rb;

%% Symbole binaire à moyenne nulle avec filtre de mise en forme rectangulaire
 
Ts1 = Tb;
Ns1 = Ts1 / Te; 

B = zeros(1, Ns1);
B(1) = 1;

bitsmap1 = kron(bits * 2 - 1, B); 
h = ones(1, Ns1); % Le filtre est un filtre rectangulaire de hauteur 1
x1 = filter(h,1,bitsmap1);

% Calcul du periodogramme de Welch
[Y1, ~] = pwelch(x1, [], [], [], Fe,'twosided');
X1 = linspace(-Fe/2, Fe/2, length(Y1));

DSP_theo1 = Ts1 * (sin(pi*X1*Ts1)./(pi*X1*Ts1)).^2; % DSP théorique


%% Symboles 4-aires à moyenne nulle et filtre de mise en forme rectangulaire

% On a 2 bit pour un symbole donc on divise par 2 le temps d'emission
% symbole
Ts2 = Tb / 2;
Ns2 = Ts2/Te;
 
% On mets les bits en 2 colonne pour pouvoir calculer la valeur de 2 bits
% qui se suivent pour ensuite affecter la bonne valeur dans les symboles
mapping = (reshape(bits ,2, []))';
a1 = 3; %10
a2 = 1; %00
a3 = -1; %01
a4 = -3; %11

mapping = (bi2de(mapping, 'left-msb'))';
mapping(mapping == 3) = -3;
mapping(mapping == 2) = 3;
mapping(mapping == 1) = -1;
mapping(mapping == 0) = 1;

B = zeros(1, Ns2);
B(1) = 1;
bitsmap2 = kron(mapping, B);

h = ones(1, Ns2); % filtre rectangulaire de hauteur 1
x2 = filter(h,1,bitsmap2);

% Periodogramme de Welch
[Y2, ~] = pwelch(x2, [], [], [], Fe,'twosided');
X2 = linspace(-Fe/2, Fe/2, length(Y2));

DSP_theo2 = 4 * Ts2 * sinc(X2 * Ts2).^2;
%% Symbole binaire à moyenne nulle avec filtre de mise en forme en racine de cosinus surelevée

Ts3 = Tb;
Ns3 = Ts3/Te;
ordre_filtre_3 = 101;

B = zeros(1, Ns3);
B(1) = 1;
bitsmap3 = kron(bits * 2 - 1, B);

alpha = 0.5;
h = rcosdesign(alpha, 8, 8); % Filtre de mise en forme en racine de cosinus surelevé
x3 = filter(h,1,bitsmap3);

% DSP expérimentale par periodogramme de Welch
[Y3, ~] = pwelch(x3, [], [], [], Fe,'twosided');
X3 = linspace(-Fe/2, Fe/2, length(Y3));

% Calcule de la DSP théorique
% Comme le calcul dépend d'information sur la valeur de x3, on a du le
% faire en plusieurs étapes
var_a = var(x3);
DSP_theo3 = X3;
DSP_theo3(abs(X3) <= (1-alpha)/(2*Ts3)) = var_a;

logic = find((abs(X3) > (1-alpha)/(2*Ts3)) & (abs(X3) <= (1+alpha)/(2*Ts3)));

DSP_theo3(logic) = var_a /2 * (1 + cos((pi*Ts3)/alpha * ...
    (abs(DSP_theo3(logic)) - (1-alpha)/(2*Ts3))));

DSP_theo3(abs(X3) > (1+alpha)/(2*Ts3)) = 0; 




%% Affichage modulateur 1 

figure('Name',"Mapping binaire à moyenne nulle et filtre rectangulaire", NumberTitle="off")
subplot(1, 2, 1)
plot([0:1:length(x1) - 1] * Temission / length(x1), x1);
title("Signal émis")
xlabel("Temps en secondes")
ylabel("Amplitude")

subplot(1,2,2)
semilogy(X1, fftshift(Y1/max(Y1)));
hold on;
semilogy(X1, DSP_theo1/max(DSP_theo1))
title("Periodogramme de Welch")
xlabel("Echelle fréquentielle en Hz")
legend("DSP simulée", "DSP théorique")

%% Affichage modulateur 2

figure('Name',"Mapping quaternaire à moyenne nulle et filtre rectangulaire", NumberTitle="off")
subplot(1, 2, 1)
plot([0:1:length(x2) - 1] *Temission / length(x2), x2);
title("Signal émis")
xlabel("Temps en secondes")
ylabel("Amplitude")


subplot(1,2,2)
semilogy(X2, fftshift(Y2/max(Y2)));
hold on 
semilogy(X2, DSP_theo2/max(DSP_theo2)); % DSP Théorique
title("Periodogramme de Welch")
xlabel("Echelle fréquentielle en Hz")
legend("DSP simulée", "DSP théorique")


%% Affichage modulateur 3
figure('Name',"Mapping quaternaire à moyenne nulle et filtre en racine de cosinus sur élevée", NumberTitle="off")
subplot(1, 2, 1)
plot([0:1:length(x3) - 1] *Temission / length(x3), x3);
title("Signal émis")
xlabel("Temps en secondes")
ylabel("Amplitude")

subplot(1,2,2)
semilogy(X3, fftshift(Y3/max(Y3)));
hold on
semilogy(X3, DSP_theo3/max(DSP_theo3));
title("Periodogramme de Welch")
xlabel("Echelle fréquentielle en Hz")
legend("DSP simulée", "DSP théorique")

%% Comparaison des DSP

figure('Name',"Comparaison des DSP", NumberTitle="off")
semilogy(X1, fftshift(Y1));
hold on
semilogy(X2, fftshift(Y2));
semilogy(X3, fftshift(Y3));

title("Periodogramme de Welch")
xlabel("Echelle fréquentielle en Hz")
legend("Mapping binaire à moyenne nulle et filtre rectangulaire", ...
    "Mapping quaternaire à moyenne nulle et filtre rectangulaire", ...
    "Mapping quaternaire à moyenne nulle et filtre en racine de cosinus sur élevée")