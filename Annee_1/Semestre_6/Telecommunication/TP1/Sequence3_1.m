clear;
close all;
clc;
%% Données
Fe = 24000; %Hz
Rb = 3000; %bit/s

nb_bits = 10^4;
bits = randi([0,1], 1, nb_bits);
Temission = nb_bits / Rb;
seuil = 100;
%% Chaine de référence
% Mapping binaire à moyenne nulle

Ts = 1/Rb;
Ns = Ts * Fe;
B = [1 zeros(1, Ns - 1)];
bitsmap = kron(bits * 2 - 1, B);

% Filtre d'emission rectagulaire de longueur Ts et de hauteur 1
h = ones(1, Ns);
x = filter(h,1,bitsmap);

% filtre de reception identique au filtre d'émission
recep = filter(h,1,x);

% Recupération des bits avec n0 = Ns
ech = Ns : Ns: length(recep);
xech = recep(ech);
signal_recu = xech;
signal_recu(xech > 0) = 1;
signal_recu(xech < 0) = 0;
display("Taux d'erreur avec n0 = Ns : " + sum(signal_recu ~= bits)/nb_bits);

%% Affichage de la chaine de transmission sans bruit
figure('Name','Chaine de transmission sans canal et sans bruit', 'NumberTitle','off', Position=[0 0 600 450])
subplot(2,2, 1);
plot([0:1:length(x) - 1] * Temission / length(x), x);
title('Signal après modulation')

subplot(2,2,2);
plot(conv(h,h))
title("Repone impulsionnelle")

subplot(2,2,3);
plot(reshape(recep(Ns+1 : end ),Ns,length(recep(Ns+1:end))/Ns));
title("Diagramme de l'oeil")
%n0 = 8 = Ns d'après le diagramme de l'oeil

subplot(2,2,4);
plot(recep);
title("Signal après filtrage de reception")


%% Diagramme de l'oeil avec du bruit
figure('Name',"Diagramme de l'oeil en fonction de E_b / N_0", 'NumberTitle','off', Position=[650 0 600 450])

P_x = mean(abs(x).^2);
M = 2;
Eb_N0 =power(10, (4:4:17)/10)';
signal_emis_sans_bruit = repmat(x, length(Eb_N0), 1);
bruit = sqrt((P_x*Ns)./(2*log2(M)* Eb_N0)) .* randn(1, length(x)) ;
signal_bruite = signal_emis_sans_bruit + bruit;

for i=1:length(Eb_N0)
    recep = filter(h,1,signal_bruite(i,:));
    
    subplot(2,2,i);
    plot(reshape(recep(Ns+1 : end ),Ns,length(recep(Ns+1:end))/Ns));
    title("Eb/N_0 = " + i*4 + "dB")    
end
%% TEB 
figure('Name',"TEB experimental en fonction de E_b / N_0", 'NumberTitle','off', Position=[1300 0 600 450])

P_x = mean(abs(x).^2);
M = 2;
Eb_N0 =power(10, (0:1:8)/10)';
signal_emis_sans_bruit = repmat(x, 9, 1);
bruit = sqrt((P_x*Ns)./(2*log2(M)* Eb_N0)) .* randn(1, length(x)) ;
signal_bruite = signal_emis_sans_bruit + bruit;

TEB = zeros(1, 9);

% On calcule le TEB pour chaque valeur de bruit
for i=1:9
    recep = filter(h,1,signal_bruite(i,:));

    ech = Ns : Ns: length(recep);
    xech = recep(ech);
    signal_recu = xech;
    signal_recu(xech > 0) = 1;
    signal_recu(xech < 0) = 0;
    TEB(i) = sum(signal_recu ~= bits)/nb_bits;
    
end
semilogy(0:1:8, TEB, 'red');
grid;
xlabel("Rapport signal sur bruit en dB")
ylabel("TEB")


%% Evolution du TEB
P_x = mean(abs(x).^2);
M = 2;
Eb_N0 =power(10, (0:8/1000:8)/10)';
signal_emis_sans_bruit = repmat(x, length(Eb_N0), 1);
bruit = sqrt((P_x*Ns)./(2*log2(M)* Eb_N0)) .* randn(1, length(x)) ;
signal_bruite = x + bruit;


TEB = zeros(1, length(Eb_N0));

% On calcule le TEB pour chaque valeur de bruit
for i=1:length(Eb_N0)
    recep = filter(h,1,signal_bruite(i,:));

    ech = Ns : Ns: length(recep);
    xech = recep(ech);
    signal_recu = xech;
    signal_recu(xech > 0) = 1;
    signal_recu(xech < 0) = 0;
    TEB(i) = sum(signal_recu ~= bits)/nb_bits;

    % Ce  test permets de juger si notre valeur de TEB est précise, nous ne
    % corrigeons pas la valeur car cela nous a poser plusieurs problème
    % d'arrêt de programme sans que nous arrivions à le solutionner
    if (sum(signal_recu ~= bits)) < seuil 
        display("Taux d'erreur pas suffisamment précis pour le TEB " + i)
        
    end
    
end
value = sqrt((2*Eb_N0));
TEB_the = 1-normcdf(value,0,1);

%% On enregistre les TEB pour pouvoir comparer les TEB avec les différentes chaine de transmission
% L'affichage des courbes de TEB dse fait ans le fichier Sequence3_TEB.m

save tp3_1 TEB_the TEB 