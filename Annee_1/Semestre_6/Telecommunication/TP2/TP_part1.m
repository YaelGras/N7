clc;
clear all;
close all;

alpha = 0.35;
fp = 2*10^3;
Fe = 10 * 10^3;
Te = 1/Fe;
Rb = 2 * 10^3;

nb_bits = 1000;
bits = randi([0,1], 1, nb_bits);
Temission = nb_bits / Rb;

%%
M = 4;
Ts = Temission * log2(M) / nb_bits;
Ns = floor(Ts/Te);


mapping = (reshape(bits ,2, []))';
a0 = complex(-1, -1); %00 = 0
a1 = complex(-1, 1); %01 = 1
a2 = complex(1, -1); %10 = 2
a3 = complex(1, 1); %11 = 3

mapping = (bi2de(mapping, 'left-msb'))';
mapping(mapping == 3) = a3;
mapping(mapping == 2) = a2;
mapping(mapping == 1) = a1;
mapping(mapping == 0) = a0;

bitsmap = kron(mapping, [1 zeros(1, Ns - 1)]);

h = rcosdesign(alpha, Ns, Ns);
ordre = Ns*Ns+1;
xe = filter(h, 1, [bitsmap zeros(1, (ordre-1)/2)]);
xe = xe((ordre-1)/2 + 1 : end);

t = [0:1:(length(xe) - 1)] *Te;

x = real(xe .* exp(1i*2*pi*fp*t));
I = real(xe);
Q = imag(xe);

% Calcul du periodogramme de Welch
[Y, ~] = pwelch(x, [], [], [], Fe,'twosided');
X = linspace(-Fe/2, Fe/2, length(Y));

xcos = x .* cos(2*pi*fp*t);
xsin = x .* sin(2*pi*fp*t);

xrecu = xcos - 1i*xsin;
reception =  filter(h, 1, [xrecu zeros(1, (ordre-1)/2)]);
reception = reception ((ordre-1)/2 + 1 : end);

ech = 1 : Ns: length(reception);
xech = reception(ech);
signal_recu = xech;

signal_recu(real(xech) < 0 & imag(xech) < 0) = 0;
signal_recu(real(xech) < 0 & imag(xech) > 0) = 1;
signal_recu(real(xech) > 0 & imag(xech) < 0) = 2;
signal_recu(real(xech) > 0 & imag(xech) > 0) = 3;

bits_recu = reshape(de2bi(signal_recu, 'left-msb').', 1, length(bits));
display("Taux d'erreur binaire avec n0 = Ns : " + sum(bits_recu ~= bits)/nb_bits);

%% Affichage 

figure('Name',"Signaux émis", "NumberTitle","off", Position=[400 0 1200 900])
subplot(2,2,[1 2])
plot(t, x);
title("Signal sur fréquence porteuse")

subplot(2,2,3)
plot(t, I);
title("Signal en phase")

subplot(2,2,4)
plot(t, Q);
title("Signal en quadrature")


figure('Name',"DSP du signal émis", "NumberTitle","off")
semilogy(X, fftshift(Y)/max(Y));
hold on
title("Periodogramme de Welch")
xlabel("Echelle fréquentielle en Hz")

figure 
plot([1:Ns], reshape(reception(Ns+1 : end),Ns,length(reception(Ns+1:end))/Ns));
title("Diagramme de l'oeil")

%% Ajout du bruit

P_x = mean(abs(x).^2);
Eb_N0 = power(10, (0:1:6)/10)';
signal_emis_sans_bruit = repmat(x, 7, 1);
bruit = sqrt((P_x*Ns)./(2*log2(M)* Eb_N0)) .* randn(1, length(x)) ;
signal_bruite = x + bruit;

TEB = zeros(1, 7);
figure
% On calcule le TEB pour chaque valeur de bruit
for i=1:7

    xcos = signal_bruite(i,:) .* cos(2*pi*fp*t);
    xsin = signal_bruite(i,:) .* sin(2*pi*fp*t);
    
    xrecu = xcos - 1i*xsin;
    reception = filter(h, 1, [xrecu zeros(1, (ordre-1)/2)]);
    reception = reception((ordre - 1)/2 + 1 : end);
    
    ech = 1 : Ns: length(reception);
    xech = reception(ech);
    signal_recu = xech;
    
    signal_recu(real(xech) < 0 & imag(xech) < 0) = 0;
    signal_recu(real(xech) < 0 & imag(xech) > 0) = 1;
    signal_recu(real(xech) > 0 & imag(xech) < 0) = 2;
    signal_recu(real(xech) > 0 & imag(xech) > 0) = 3;

    bits_recu = reshape(de2bi(signal_recu, 'left-msb').', 1, length(bits));

    TEB(i) = sum(bits_recu ~= bits)/nb_bits;
    
    %Diagramme de l'oeil
    subplot(4,3, i)
    plot([1:Ns], reshape(reception(Ns+1 : end),Ns,length(reception(Ns+1:end))/Ns));
    title(i-1 + "dB")
    
end
