close all;
clear all;
load donnees1.mat;
load donnees2.mat;

F_e = 120000;
T_e = 1/F_e;
T_s = 40/1000;
N_s = round(T_s/(T_e * length(bits_utilisateur1)), -1); 

% Emetteur


% Génération des signaux
m_1 = kron(bits_utilisateur1*2 -1, ones(1, N_s));
m_2 = kron(bits_utilisateur2 *2 -1, ones(1, N_s));

% Génération du signal à 5 timeslot
f_p1 = 0;
f_p2 = 46000;

Time_signal = 0:T_e:(5*T_s-T_e);

% Génération des NRZ
NRZ_m1 = zeros(1, 5*T_s/T_e);

if length(m_1)<T_s/T_e
    NRZ_m1(1, T_s/T_e + 1:T_s/T_e + length(m_1)) = m_1;
else 
    NRZ_m1(1, T_s/T_e +1:2*T_s/T_e) = m_1(1:T_s/T_e);
end

NRZ_m2 = zeros(1, 5*T_s/T_e);
if length(m_2)<T_s/T_e
    NRZ_m2(1, 4*T_s/T_e+1:4*T_s/T_e + length(m_2)) = m_2;
else 
    NRZ_m2(1, 4*T_s/T_e+1:5*T_s/T_e) = m_2(1:T_s/T_e);
end

% Génération du signal x émis
x_1 = cos(2*pi*f_p1*Time_signal).*NRZ_m1;
x_2 = cos(2*pi*f_p2*Time_signal).*NRZ_m2;   
x = x_1+x_2;

% Ajout du bruit blanc
Ps = mean(abs(x).^2);
SNR = 10; 
x = awgn(x, SNR);



% Récépteur

% filtre passe-bas

N=2^17;
f_cb = 23000/F_e;
Ordre_filtre_bas = 131;
retard = (Ordre_filtre_bas-1)/2;
intervalle_bas = -(Ordre_filtre_bas-1)/2:1:(Ordre_filtre_bas-1)/2;
hpb_bas = 2*f_cb*sinc(2*f_cb*intervalle_bas);
filtre_bas = filter(hpb_bas, 1, [x zeros(1, retard)]);
filtre_bas = filtre_bas(retard+1:end);
signal_filtre_bas = 1/N *abs(fft(filtre_bas, N)).^2;

% filtre passe-haut
f_ch = 23000/F_e;
Ordre_filtre_haut = Ordre_filtre_bas;
retard = (Ordre_filtre_haut-1)/2;
intervalle_haut = -(Ordre_filtre_haut-1)/2:1:(Ordre_filtre_haut-1)/2;
hpb_haut = -2*f_ch*sinc(2*f_ch*intervalle_haut);
hpb_haut(retard+1) = 1 + hpb_haut(retard+1);

filtre_haut = filter(hpb_haut, 1, [x zeros(1, retard)]);
filtre_haut = filtre_haut(retard+1:end);
signal_filtre_haut = 1/N *abs(fft(filtre_haut,N)).^2;


% Signaux reçus
x_1_recu = filtre_bas.*cos(2*pi*f_p1*Time_signal);
x_2_recu = filtre_haut.*cos(2*pi*f_p2*Time_signal);

%Filtre passe-bas
filtre_bas = filter(hpb_bas, 1, [x_1_recu zeros(1, retard)]);
x_1_recu = filtre_bas(retard+1:end);

filtre_bas = filter(hpb_bas, 1, [x_2_recu zeros(1, retard)]);
x_2_recu = filtre_bas(retard+1:end);
% Detection du slot utile pour l'utilisateur 1
X1 = x_1_recu(1:T_s/T_e);    
X2 = x_1_recu(T_s/T_e+1:2*T_s/T_e);   
X3 = x_1_recu(2*T_s/T_e+1:3*T_s/T_e+1);    
X4 = x_1_recu(3*T_s/T_e+1:4*T_s/T_e);    
X5 = x_1_recu(4*T_s/T_e+1:5*T_s/T_e);   
x_1r_decompose = [X1 ; X2 ; X3 ; X4 ; X5];
X = [sum(X1.^2); sum(X2.^2); sum(X3.^2); sum(X4.^2); sum(X5.^2)];
[~ , i_max]=max(X);


% Demodulation bande de base pour l'utilisateur 1 
SignalFiltre_1 = filter(ones(1,N_s), 1, x_1r_decompose(i_max, :));
SignalEchantillonne_1 = SignalFiltre_1(N_s : N_s : end);
BitsRecuperes_1 = (sign(SignalEchantillonne_1) + 1) /2;

% Detection du slot utile pour l'utilisateur 2
Y1 = x_2_recu(1:T_s/T_e);    
Y2 = x_2_recu(T_s/T_e+1:2*T_s/T_e);   
Y3 = x_2_recu(2*T_s/T_e+1:3*T_s/T_e+1);    
Y4 = x_2_recu(3*T_s/T_e+1:4*T_s/T_e);    
Y5 = x_2_recu(4*T_s/T_e+1:5*T_s/T_e);   
x_2r_decompose = [Y1 ; Y2 ; Y3 ; Y4 ; Y5];
Y = [sum(Y1.^2); sum(Y2.^2); sum(Y3.^2); sum(Y4.^2); sum(Y5.^2)];
[~ , j_max]=max(Y);

% Demodulation bande de base pour l'utilisateur 2
SignalFiltre_2 = filter(ones(1,N_s), 1, x_2r_decompose(j_max, :));
SignalEchantillonne_2 = SignalFiltre_2(N_s : N_s : end);
BitsRecuperes_2 = (sign(SignalEchantillonne_2) + 1) /2;

% Vérification des messages
disp("Nombre de bits différents pour le message 1 :")
disp(-sum(1-((bits_utilisateur1) == (BitsRecuperes_1))))
disp("Nombre de bits différents pour le message 2 :")
disp(-sum(1-((bits_utilisateur2) == (BitsRecuperes_2))))

%% Signal m1

figure ("Name","Signal m1", 'NumberTitle','off')
plot(0:length(m_1) - 1, m_1)

%% Signal m2

figure ("Name","Signal m2", 'NumberTitle','off')
plot(0:length(m_2) - 1, m_2)

%% DSP de m1

N = 1024;
M1 = 1/N *abs(fft(m_1,N)).^2;

figure ("Name","DSP de m1", 'NumberTitle','off')
xlabel("Frequence");
ylabel("log");
semilogy((0:N-1) / N, M1);

%% DSP de m2

N = 1024;
M2 = 1/N *abs(fft(m_2,N)).^2;

figure ("Name","DSP de m2", 'NumberTitle','off')
xlabel("Frequence");
ylabel("log");
semilogy((0:N-1) / N, M2);

%% NRZ de m1

figure("Name","NRZ de m1", 'NumberTitle','off')
plot(Time_signal, NRZ_m1);
xlabel("Time (s)");
ylabel("value");

%% NRZ de m2

figure("Name","NRZ de m2", 'NumberTitle','off')
plot(Time_signal, NRZ_m2);
xlabel("Time (s)");
ylabel("value");

%% Tracé du signal émis

figure("Name","Signal", 'NumberTitle','off')
plot(Time_signal, x);
xlabel("Time (s)");
ylabel("value");

%% DSP du signal émis
N = 2^17;
DSP_Signal = 1/N *abs(fft(x,N)).^2;

figure ("Name","DSP du signal", 'NumberTitle','off')
semilogy((0:N-1) / N, DSP_Signal);
xlabel("Frequence");
ylabel("log");

%% Réponse impulsionnelle du filtre passe-bas

figure("Name","Réponse impulsionnelle du filtre passe-bas", 'NumberTitle','off')
stem(hpb_bas);

%% Réponse en fréquence du filtre passe-bas

N = 2^17;
figure('Name','Reponse frequentielle du filtre passe-bas','NumberTitle','off')
xlabel("Frequence");
ylabel("log");
plot((0:N-1)/N, abs(fft(hpb_bas, N)))

%% Filtrage passe-bas

N = 2^17;
DSP_Signal = 1/N *abs(fft(x,N)).^2;

figure ("Name","DSP du signal avec filtrage passe-bas", 'NumberTitle','off')
semilogy((0:N-1) / N, DSP_Signal);
xlabel("Frequence");
ylabel("log");

hold on;

semilogy((0:N-1) / N, signal_filtre_bas);

%% Réponse impulsionnelle du filtre passe-haut

figure("Name","Réponse impulsionnelle du filtre passe-haut", 'NumberTitle','off')
stem(hpb_haut);

%% Réponse en fréquence du filtre passe-haut

N = 2^17;
figure('Name','Reponse frequentielle du filtre passe-bas','NumberTitle','off')
xlabel("Frequence");
ylabel("log");
plot((0:N-1)/N, abs(fft(hpb_haut, N)))

%% Filtrage passe-haut

N = 2^17;
DSP_Signal = 1/N *abs(fft(x,N)).^2;

figure ("Name","DSP du signal", 'NumberTitle','off')
semilogy((0:N-1) / N, DSP_Signal);
xlabel("Frequence");
ylabel("log");

hold on;

semilogy((0:N-1) / N, signal_filtre_haut);

%% Signaux reçu de l'utilisateur 1

figure("Name","Signal reçu utilisateur 1", 'NumberTitle','off')
plot(Time_signal, x_1_recu);
xlabel("Time (s)");
ylabel("value");

%% Signaux reçu de l'utilisateur 2

figure("Name","Signal reçu utilisateur 2", 'NumberTitle','off')
plot(Time_signal, x_2_recu);
xlabel("Time (s)");
ylabel("value");

%% Signaux filtré de l'utilisateur 1

figure("Name","Signal filtré utilisateur 1", 'NumberTitle','off')
plot(Time_signal(((i_max - 1) * T_s/T_e) +1: i_max*T_s/T_e), SignalFiltre_1);
xlabel("Time (s)");
ylabel("value");
%% Signaux filtré de l'utilisateur 2

figure("Name","Signal filtré utilisateur 2", 'NumberTitle','off')
plot(Time_signal(((i_max - 1) * T_s/T_e) +1: i_max*T_s/T_e), SignalFiltre_2);
xlabel("Time (s)");
ylabel("value");

%% Bits récupérés de l'utilisateur 1

figure("Name","Bits Récupérés pour l'utilisateur 1", 'NumberTitle','off')
plot(0:(length(BitsRecuperes_1)-1), BitsRecuperes_1);
xlabel("Time (s)");
ylabel("value");

%% Bits récupérés de l'utilisateur 2

figure("Name","Bits Récupérés pour l'utilisateur 2", 'NumberTitle','off')
plot(0:(length(BitsRecuperes_2)-1), BitsRecuperes_2);
xlabel("Time (s)");
ylabel("value");
%%
close all;