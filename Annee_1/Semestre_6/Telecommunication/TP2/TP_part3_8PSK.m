clc;
clear all;
close all;

alpha = 0.5;
Rb = 48 * 10^3;
TEBmax = 10^(-2);

Fe = 20 * 10^4;

nb_bits = 1000;
bits = randi([0,1], 1, nb_bits);
Temission = nb_bits / Rb;

%% 8PSK
M = 8;

psk_passebas(M, Rb, Fe, bits, alpha)
