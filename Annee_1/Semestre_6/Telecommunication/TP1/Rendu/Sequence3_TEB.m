clc;
clear all;
close all;



%% Chaîne de référence 
load tp3_1.mat;
TEB_the_1 = TEB_the;
TEB_1 = TEB;
x = 0:8/(length(TEB_the_1)-1):8;

%% Affichage du TEB
figure('Name',"TEB en fonction de E_b / N_0", 'NumberTitle','off', Position=[0 600 600 450])
semilogy((0:8/1000:8), TEB, 'red');
hold on
grid on
semilogy((0:8/1000:8), TEB_the, "black")
xlabel("Rapport signal sur bruit en dB")
ylabel("TEB")
legend('TEB expérimental', 'TEB théorique')

%% Chaîne 1
load tp3_2.mat;
TEB_the_2 = TEB_the;
TEB_2 = TEB;

%% Affichage du TEB
figure('Name',"Chaîne 1 : TEB en fonction de E_b / N_0", 'NumberTitle','off', Position=[650 600 600 450])
semilogy(0:8/1000:8, TEB_2, 'red');
hold on
grid on
semilogy(0:8/1000:8, TEB_the_2, "black")
xlabel("Rapport signal sur bruit en dB")
ylabel("TEB")
legend('TEB expériemental', 'TEB théorique')
%% Comparaison chaine de reference et chaine 1
figure("Name", "Chaîne 1 : Comparaison des TEB théorique", 'NumberTitle','off', Position=[1300 600 600 450])
semilogy(x, TEB_the_1, 'red');
hold on
grid on
semilogy(x, TEB_the_2, "black")
xlabel("Rapport signal sur bruit en dB")
ylabel("TEB théoriques")
legend('TEB reference', 'TEB chaine 1')
%% Chaîne 2
load tp3_3.mat;
TEB_the_3 = TEB_the;
TEB_3 = TEB;
%% Affichage du TES 
figure('Name',"Chaîne 2 : TES en fonction de E_b / N_0", 'NumberTitle','off', Position=[0 0 600 450])
semilogy((0:8/1000:8), TES, 'red');
xlabel("Rapport signal sur bruit en dB")
ylabel("TES")
grid;

%% Comparaison théorique et expérimental
figure('Name',"Chaîne 2 : Comparaison TES en fonction de E_b / N_0", 'NumberTitle','off', Position=[650 0 600 450])

semilogy((0:8/1000:8), TES, 'red');
hold on
grid on
semilogy((0:8/1000:8), TES_the, "black")
xlabel("Rapport signal sur bruit en dB")
ylabel("TES")
legend('TES expérimental', 'TES théorique')

figure('Name',"Chaîne 2 : Comparaison TEB en fonction de E_b / N_0", 'NumberTitle','off', Position=[1300 0 600 450])

semilogy((0:8/1000:8), TEB_3, 'red');
hold on
grid on
semilogy((0:8/1000:8), TEB_the_3, "black")
xlabel("Rapport signal sur bruit en dB")
ylabel("TEB")
legend('TEB expérimental', 'TEB théorique')

%% Comparaison chaine de reference et chaine 2
figure("Name", "Chaîne 2 : Comparaison des TEB théorique avec la chaine de référence", 'NumberTitle','off', Position=[1300 500 600 450])
semilogy(x, TEB_the_1, 'red');
hold on
grid on
semilogy(x, TEB_the_3, "black")
xlabel("Rapport signal sur bruit en dB")
ylabel("TEB théoriques")
legend('TEB reference', 'TEB chaine 2')