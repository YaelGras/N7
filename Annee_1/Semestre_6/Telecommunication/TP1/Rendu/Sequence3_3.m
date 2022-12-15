clear;
close all;
clc;

%% Données
Fe = 24000; %Hz
Rb = 3000; %bit/s

nb_bits = 10000;
bits = randi([0,1], 1, nb_bits);
seuil = 10^2;
%% Mapping quaternaire à moyenne nulle et modulation
Ts = 2/Rb;
Ns = Ts * Fe;
B = [1 zeros(1, Ns - 1)];
symbole = (2 * bi2de(reshape(bits, 2, length(bits)/2).') - 3).';
nb_symbole = length(symbole); %nb_bits /2
bitsmap = kron(symbole, B);

% Filtre d'émission rectangulaire de longueur Ts et de hauteur 1
h = ones(1, Ns);
x = filter(h,1,bitsmap);

% Démodulation avec filtre de reception identiqueau filtre d'emission
recep = filter(h,1,x);

% Décision
ech = Ns : Ns: length(recep);
xech = recep(ech);
symbole_recu = xech;
symbole_recu(xech > 32) = 3;
symbole_recu(xech > 0 & xech < 32) = 1;
symbole_recu(xech < 0 & xech > -32) = -1;
symbole_recu(xech < -32) = -3;
display("TES = " + sum(symbole_recu ~= symbole)/nb_symbole)
BitsDecides = reshape(de2bi((symbole_recu + 3)/2).', 1, length(bits));
display("Taux d'erreur avec n0 = Ns : " + sum(BitsDecides ~= bits)/nb_bits);

%% Affichage de la chaine de transmission sans bruit
figure('Name','Chaine de transmission sans canal et sans bruit', 'NumberTitle','off', Position=[0 700 600 450])
% subplot(2,2, 1);
% plot(x);
% title('Signal après modulation')
% 
% subplot(2,2,2);
% plot(conv(h,h,'same'))
% title("Repone impulsionnelle")
% 
% subplot(2,2,[3:4]); 
plot(reshape(recep(Ns+1 : end),Ns,length(recep(Ns+1:end))/Ns));
title("Diagramme de l'oeil")
%Intant d'echantillonnage optimal : Ns

%% Diagramme de l'oeil avec du bruit
figure('Name',"Diagramme de l'oeil en fonction de E_b / N_0", 'NumberTitle','off', Position=[650 0 600 450])

P_x = mean(abs(x).^2);
M = 4;
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
%% TEB, TES et ajout du bruit

P_x = mean(abs(x).^2);
M = 4;
Eb_N0 = power(10, (0:8/1000:8)/10)';
signal_emis_sans_bruit = repmat(x, length(Eb_N0), 1);
bruit = sqrt((P_x*Ns)./(2*log2(M)* Eb_N0)) .* randn(1, length(x)) ;
signal_bruite = signal_emis_sans_bruit + bruit;

TEB = zeros(1, length(Eb_N0));
TES = zeros(1, length(Eb_N0));


% Calcul des TEB et du TES experimentale pour chaque valeur du bruit

for i=1:length(Eb_N0)
    recep = filter(h,1,signal_bruite(i,:));

    ech = Ns : Ns: length(recep);
    xech = recep(ech);
    symbole_recu = xech;
    symbole_recu(xech > 32) = 3;
    symbole_recu(xech > 0 & xech < 32) = 1;
    symbole_recu(xech < 0 & xech > -32) = -1;
    symbole_recu(xech < -32) = -3;

    BitsDecides = reshape(de2bi((symbole_recu + 3)/2).', 1, length(bits));
    
    TES(i) = sum(symbole_recu ~= symbole)/nb_symbole;
    TEB(i) = sum(BitsDecides ~= bits)/nb_bits;
    if (sum(BitsDecides ~= bits)) < seuil 
        display("Taux d'erreur pas suffisamment précis pour le TEB " + i)
        
    end
end

% Calcul du TEB et du TES théorique
value = sqrt((4/5) * Eb_N0);
TES_the = (3/2) * qfunc(value);
TEB_the = (3/4) * qfunc(value);
nb_bits = 100000;
bits = randi([0,1], 1, nb_bits);


%% On enregistre les TEB pour pouvoir comparer les TEB avec les différentes chaine de transmission
% L'affichage des courbes  de TEB et TES se fait dans le fichier Sequence3_TEB.m

save tp3_3 TEB_the TEB TES_the TES