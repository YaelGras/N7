% Auteur : J. Gergaud
% décembre 2017
% -----------------------------
% 



function Jac = diff_finies_avant(fun,x,option)
%
% Cette fonction calcule les différences finies avant sur un schéma
% Paramètres en entrées
% fun : fonction dont on cherche à calculer la matrice jacobienne
%       fonction de IR^n à valeurs dans IR^m
% x   : point où l'on veut calculer la matrice jacobienne
% option : précision du calcul de fun (ndigits)
%
% Paramètre en sortie
% Jac : Matrice jacobienne approximé par les différences finies
%        real(m,n)
% ------------------------------------

    omega = max(eps, 10^(-option));
    

    n = length(x);
    m = length(fun(x));
    Jac = zeros(m, n);
    for i=1:n
        h =  sqrt(omega) * max(1, abs(x(i))) *sgn(x);
        v = zeros(n,1);
        v(i) = 1;
        c = (fun(x + h*v) - fun(x))/h;
        Jac = [Jac, c]; 
    end
end

function s = sgn(x)
% fonction signe qui renvoie 1 si x = 0
if x==0
  s = 1;
else 
  s = sign(x);
end
end







