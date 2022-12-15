clear;
close all;
clc;

%% Donnée :
Fe = 24000; %Hz
Rb = 3000; %bit/s

nb_bits = 100;
bits = randi([0,1], 1, nb_bits);
Temission = nb_bits / Rb;

%% Mapping binaire à moyenne nulle et modulation
Ts = 1/Rb;
Ns = Ts * Fe;
B = [1 zeros(1, Ns - 1)];
bitsmap = kron(bits * 2 - 1, B);
h = ones(1, Ns);
x = filter(h,1,bitsmap);

% Démodulation 
recep = filter(h,1,x);

% Recupération des bits avec n0 = Ns
ech = Ns : Ns: length(recep);
xech = recep(ech);
signal_recu = xech;
signal_recu(xech > 0) = 1;
signal_recu(xech < 0) = 0;
display("Taux d'erreur avec n0 = Ns : " + sum(signal_recu ~= bits)/nb_bits);

% Recuperation des bits avec n0 = 3
ech = 3 : Ns: length(recep);
xech = recep(ech);
signal_recu = xech;
signal_recu(xech > 0) = 1;
signal_recu(xech < 0) = 0;
display("Taux d'erreur avec n0 = 3: " + sum(signal_recu ~= bits)/nb_bits);

%% Affichage des graphique de la chaine de transmission sans canal
figure('Name','Chaine de transmission sans canal de propagation', 'NumberTitle','off', Position=[0 0 600 450])
subplot(2,2, 1);
plot([0:1:length(x) - 1] * Temission / length(x), x);
title('Signal après modulation')
xlabel("Temps en secondes")
ylabel("Amplitude")

subplot(2,2,2);
plot(conv(h,h))
title("Reponse impulsionnelle")
xlabel("Echantillons")
ylabel("Amplitude")

subplot(2,2,3);
plot(reshape(recep(Ns+1 : end ),Ns,length(recep(Ns+1:end))/Ns));
title("Diagramme de l'oeil")
xlabel("Echantillons")
ylabel("Amplitude")
%n0 = 8 = Ns d'après le diagramme de l'oeil

subplot(2,2,4);
plot([0:1:length(recep) - 1] * Temission / length(recep), recep);
xlabel("Temps en secondes")
ylabel("Amplitude")
title("Signal après filtrage de reception")


%% Canal de propagation a bande limité avec BW = 8000Hz
N = 101;
fc = 8000;  
hc = (2 * fc/Fe) * sinc(2 * (fc/Fe) * [-(N-1)/2 : (N-1)/2]); % Filtre passe-bas coupé à 8000Hz

signal_canal = filter(hc,1,[x zeros(1, (N-1)/2)]);
signal_canal = signal_canal((N+1)/2 : end);
recep = filter(h,1, signal_canal);

% Recupération des bits avec n0 = 8
ech = 8 : Ns: length(recep);
xech = recep(ech);
signal_recu = xech;
signal_recu(xech > 0) = 1;
signal_recu(xech < 0) = 0;
display("Taux d'erreur binaire pour BW = 8000Hz : " + sum(signal_recu ~= bits)/nb_bits);

%% Affichage des graphique de la chaine de transmission avec canal de propagation et BW = 8000Hz

figure('Name',"Chaine de transmission avec canal et BW = 8000Hz", 'NumberTitle','off', Position=[650 0 600 450])
subplot(2,2,1);
plot(conv(h, conv(h, hc)));
title("Reponse impulsionnelle")
xlabel("Echantillons")
ylabel("Amplitude")

subplot(2,2,2);
plot(reshape(recep(Ns+1:end),Ns,length(recep(Ns+1:end))/Ns));
title("Diagramme de l'oeil")
xlabel("Echantillons")
ylabel("Amplitude")
% 6 < n0 <= 8 = Ns d'après le diagramme de l'oeil

subplot(2,2,[3:4]);
hh = abs(fft(h,length(hc))'*fft(h,length(hc)));
plot(fftshift(hh/max(hh)), 'black');
hold on
abshc = abs(fft(hc,length(hc)));
plot(fftshift(abshc/max(abshc)), 'red');
hold off
title("Reponse en fréquence")
xlabel("Fréquence en Hz")
ylabel("Spectre")
legend("Reponse en fréquence de la chaine de transmission sans canal", "Reponse en fréquence du filtre canal")


%% Canal de propagation a bande limité avec BW = 1000Hz
fc = 1000;
hc = (2 * fc/Fe) * sinc(2 * (fc/Fe) * [-(N-1)/2 : (N-1)/2]);
signal_canal = filter(hc,1,[x zeros(1, (N-1)/2)]);
signal_canal = signal_canal((N+1)/2 : end);
recep = filter(h,1, signal_canal);  

% Recupération des bits avec n0 = 8
ech = 8 : Ns: length(recep);
xech = recep(ech);
signal_recu = xech;
signal_recu(xech > 0) = 1;
signal_recu(xech < 0) = 0;
display("Taux d'erreur binaire pour BW = 1000Hz : " + sum(signal_recu ~= bits)/nb_bits);


%% Affichage des graphique de la chaine de transmission avec canal de propagation et BW = 1000Hz

figure('Name',"Chaine de transmission avec canal et BW = 1000Hz", 'NumberTitle','off', Position=[1300 0 600 450])
subplot(2,2,1);
title("Reponse impulsionnelle")
plot(conv(h, conv(h, hc)));
xlabel("Echantillons")
ylabel("Amplitude")

subplot(2,2,2);
plot(reshape(recep(Ns+1:end),Ns,length(recep(Ns+1:end))/Ns));
title("Diagramme de l'oeil")
xlabel("Echantillons")
ylabel("Amplitude")

subplot(2,2,[3:4]);
hh = abs(fft(h,length(hc))'*fft(h,length(hc)));
plot(fftshift(hh/max(hh)), 'black');
hold on
abshc = abs(fft(hc,length(hc)));
plot(fftshift(abshc/max(abshc)), 'red');
hold off
title("Reponse en fréquence")
xlabel("Fréquence en Hz")
ylabel("Spectre")
legend("Reponse en fréquence de la chaine de transmission sans canal", "Reponse en fréquence du filtre canal")
