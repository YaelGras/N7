clear all;
close all;
clc



%Fréquence d'échantillonnage
Fe = 24000;
% Débit binaire désiré
Rb = 3000;
%Coefficient d'atténuation du signal direct
alpha_0 = 1;
%Coefficient d'atténuation du signal réfléchi
alpha_1 = 0.5;

% Transmission d'une chaine aléatoire
nb_bits = 10000;
%bits à transmettre
bits = randi([0,1], 1, nb_bits);
transmission_sans_bruit(Fe, Rb, alpha_0, alpha_1, bits, true, false, true);

%Transmission de la chaîne exemple
%bits à transmettre
bits = [0 1 1 0 0 1];
transmission_sans_bruit(Fe, Rb, alpha_0, alpha_1, bits, false, true, false);






function [] = transmission_sans_bruit(Fe, Rb, alpha0, alpha1, bits, diagrammeOeil, signaux, constellation)
        %Période signal        
        Ts = 1/Rb;
        %facteur de suréchantillonage
        Ns = Ts * Fe;  
        %Nombre de bits à transmettre
        nb_bits = length(bits);
        %Suréchantillonnage
        bitsmap = kron(bits * 2 - 1, [1 zeros(1, Ns - 1)]); 
        %Réponse impulsionnelle du filtre de mise en forme
        he = ones(1, Ns); % Le filtre est un filtre rectangulaire de hauteur 1
        %Filtrage de mise en forme
        x = filter(he,1,bitsmap);
        
        %Réponse impulsionnelle du filtre du canal de propagation
        hc = kron([alpha0 alpha1], [1 zeros(1, Ns-1)]);
        %Passage par le canal de transmission
        xe = filter(hc, 1, x);
        
        %Réponse impulsionnelle du filtre de réception
        hr = he;
        
        % Filtrage de réception
        ye = filter(hr,1,xe);
        
        % Echantillonage avec n0 = Ns
        ech = Ns : Ns: length(ye);
        xech = ye(ech);
        %Demodulation
        signal_recu = xech;
        signal_recu(xech > 0) = 1;
        signal_recu(xech < 0) = 0;
        display("Taux d'erreur avec n0 = Ns : " + sum(signal_recu ~= bits)/nb_bits);
        
        if diagrammeOeil
            %Affichage du diagramme de l'oeil
            figure('Name',"Diagramme de l'oeil", 'NumberTitle','off', Position=[0 0 600 450])
            plot(reshape(ye(2*Ns+1 : end),Ns,length(ye(2*Ns+1:end))/Ns));
            title("Diagramme de l'oeil")
            %n0 = Ns d'après le diagramme de l'oeil
        end

        if signaux
            %affichage des signal en sortie
            figure('Name',"Signal recu", 'NumberTitle','off', Position=[0 0 600 450])
            plot([0:1:length(ye) - 1]/ Rb, ye);
            title("Signal reçu")
            xlabel("Temps (en secondes)");
        end

        if constellation
            %affichage de la constellation
            figure("Name","Constellation en sortie de mapping", 'NumberTitle','off')
            grid on
            const = plot(real(xech(2:end)), imag(xech(2:end)), '+');
            const.LineStyle = 'none';
        end
end