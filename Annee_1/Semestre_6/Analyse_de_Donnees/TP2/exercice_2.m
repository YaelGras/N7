clear all;
close all;

load SG3;
load ImSG3;


% MCO
[n m] = size(I);

A = [-I(:) ones(n*m, 1)];
b = log(ImMod(:));

Beta = pinv(A) * b;

figure("Name", "Images", "NumberTitle","off")
subplot(2, 2, 1)
imshow(I);
title("Image originale");
subplot(2, 2, 2)
imshow(ImMod);
title("Image modifié");

image = (log(ImMod) - Beta(2)) / (-Beta(1));

subplot(2, 2, [3,4])
imshow(image);
title("Image reconstituée par MCO");

erreur = sqrt(mean((image(:) - I(:)).^2));

