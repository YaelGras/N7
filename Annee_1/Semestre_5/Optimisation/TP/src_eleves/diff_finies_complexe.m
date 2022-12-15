% Auteur : J. Gergaud
% décembre 2017
% -----------------------------
% 

    
function Jac= diff_finies_complexe(fun, x, option)
%
% Cette fonction calcule les différences finies centrées sur un schéma
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
    omega = max(eps, 1*e(-option));

    
    n = length(x);
    m = length(fun(x));
    Jac = zeros(m, n);
    for K=1:n
        h = sgn(x) * sqrt(omega) * max(1, abs(x[K]));

        v = x -x;
        v(K) = 1;
        Jac(:,K) = imag(fun(x + (x +h *i)*v))/(h);
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








