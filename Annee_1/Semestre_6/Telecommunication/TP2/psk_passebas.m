function [] = psk_passebas(M, Rb, Fe, bits_propose, alpha)
%   PSK_PASSEBAS 
% M : Ordre de modulation
% Rb : debit binaire
% Fe : fréquence d'echantillonnage
% nb_bits : Nombre de bits à transmettre
% bits : bits à transmettre


if mod(length(bits_propose), log2(M)) ~= 0
    display("a")
    bits = [bits_propose, zeros(1, log2(M) - mod(length(bits_propose), log2(M)))];
else 
    bits = bits_propose;
end

nb_bits = length(bits);
Temission = nb_bits / Rb;
Ts = Temission * log2(M) / nb_bits;
Ns = floor(Ts*Fe);



mapping = (reshape(bits , log2(M), []))';
mapping = (bi2de(mapping, 'left-msb'));

mapping = pskmod(mapping, M, pi/M)';

bitsmap = kron(mapping, [1 zeros(1, Ns - 1)]);

h = rcosdesign(alpha, Ns, Ns);
ordre = Ns*Ns+1;
xe = filter(h, 1, [bitsmap zeros(1, (ordre-1)/2)]);
xe = xe((ordre-1)/2 + 1 : end);

t = [0:1:(length(xe) - 1)] * (1/Fe);

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
figure("Name", "Constellation pour un ordre de modulation de : " + M, "NumberTitle","off")
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
ylim([0 0.5])


end

