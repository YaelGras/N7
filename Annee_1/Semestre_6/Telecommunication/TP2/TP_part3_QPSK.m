clc;
clear all;
close all;

alpha = 0.5;
Rb = 48 * 10^3;
TEBmax = 10^(-2);

Fe = 20 * 10^4;
Te = 1/Fe;

nb_bits = 1000;
bits = randi([0,1], 1, nb_bits);
Temission = nb_bits / Rb;

%% QPSK
M = 4;
Ts = Temission * log2(M) / nb_bits;
Ns = floor(Ts/Te);

mapping = (reshape(bits ,2, []))';
mapping = (bi2de(mapping, 'left-msb'));

mapping = pskmod(mapping, M, pi/M)';

bitsmap = kron(mapping, [1 zeros(1, Ns - 1)]);

h = rcosdesign(alpha, Ns, Ns);
ordre = Ns*Ns+1;
xe = filter(h, 1, [bitsmap zeros(1, (ordre-1)/2)]);
xe = xe((ordre-1)/2 + 1 : end);

t = [0:1:(length(xe) - 1)] *Te;

I = real(xe);
Q = imag(xe);

% Calcul du periodogram me de Welch
[Y, ~] = pwelch(xe, [], [], [], Fe,'twosided');
X = linspace(-Fe/2, Fe/2, length(Y));

xrecu = xe;
reception =  filter(h, 1, [xrecu zeros(1, (ordre-1)/2)]);
reception = reception ((ordre-1)/2 + 1 : end);

ech = 1 : Ns: length(reception);
xech = reception(ech);

signal_recu = pskdemod(xech', M, pi/M)';

bits_recu = reshape(de2bi(signal_recu, 'left-msb').', 1, length(bits));
display("Taux d'erreur binaire avec n0 = Ns : " + sum(bits_recu ~= bits)/nb_bits);

%% Affichage 

figure("Name","Constellation en sortie de mapping", 'NumberTitle','off')
grid on
const = plot(real(mapping), imag(mapping), '+');
const.LineStyle = 'none';
xlim([-1.1 1.1])
ylim([-1.1 1.1])

%% Ajout du bruit

P_x = mean(abs(xe).^2);
Eb_N0 = power(10, (0:1:6)/10)';
signal_emis_sans_bruit = repmat(xe, 7, 1);
bruitI = sqrt((P_x*Ns)./(2*log2(M)* Eb_N0)) .* randn(1, length(xe)) ;
bruitQ = sqrt((P_x*Ns)./(2*log2(M)* Eb_N0)) .* randn(1, length(xe)) ;
signal_bruite = xe + bruitI + 1i*bruitQ;

TEB = zeros(1, 7);
figure
% On calcule le TEB pour chaque valeur de bruit
for i=1:7

    
    xrecu = signal_bruite(i,:);
    reception = filter(h, 1, [signal_bruite(i,:) zeros(1, (ordre-1)/2)]);
    reception = reception((ordre - 1)/2 + 1 : end);
    
    ech = 1 : Ns: length(reception);
    xech = reception(ech);
    
    signal_recu = pskdemod(xech', M, pi/M)';

    bits_recu = reshape(de2bi(signal_recu, 'left-msb').', 1, length(bits));

    TEB(i) = sum(bits_recu ~= bits)/nb_bits;
    
    %Diagramme de l'oeil
    subplot(4,3, i)
    const = plot(real(xech), imag(xech), '+');
    const.LineStyle = 'none';
    xlim([-3.5 3.5])
    ylim([-3.5 3.5])
    title(i-1 + "dB")
    
end

subplot(4,3, [10 : 12])
plot((0:1:6), TEB)

