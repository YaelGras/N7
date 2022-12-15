clear all;
close all;
clc

%Fréquence d'échantillonnage
Fe = 24000;
% Débit binaire désiré
Rb = 3000;

%Nombre de bits à transmettre
nb_bits = 1000;
%bits à transmettre
bits = randi([0,1], 1, nb_bits);
%Temps totale d'émission
Temission = nb_bits / Rb;

%Période signal
Ts = 1/Rb;
%facteur de suréchantillonage
Ns = Ts * Fe; 

%Suréchantillonnage
B = [1 zeros(1, Ns - 1)];

bitsmap = kron(bits * 2 - 1, B); 
%Réponse impulsionnelle du filtre de mise en forme
he = ones(1, Ns); % Le filtre est un filtre rectangulaire de hauteur 1
%Filtrage de mise en forme
xe = filter(he,1,bitsmap);

%Réponse impulsionnelle du filtre de réception
hr = he;

% Filtrage de réception
recep = filter(hr,1,xe);

% Echantillonage avec n0 = Ns
ech = Ns : Ns: length(recep);
xech = recep(ech);
%Demodulation
signal_recu = xech;
signal_recu(xech > 0) = 1;
signal_recu(xech < 0) = 0;
display("Taux d'erreur avec n0 = Ns : " + sum(signal_recu ~= bits)/nb_bits);

figure('Name',"Diagramme de l'oeil", 'NumberTitle','off', Position=[0 0 600 450])
plot(reshape(recep(Ns+1 : end ),Ns,length(recep(Ns+1:end))/Ns));
title("Diagramme de l'oeil")
%n0 = 8 = Ns d'après le diagramme de l'oeil
