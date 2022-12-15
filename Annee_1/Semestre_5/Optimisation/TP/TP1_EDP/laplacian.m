function L = laplacian(nu,dx1,dx2,N1,N2)
%
%  Cette fonction construit la matrice de l'opérateur Laplacien 2D anisotrope
%
%  Inputs
%  ------
%
%  nu : nu=[nu1;nu2], coefficients de diffusivité dans les dierctions x1 et x2. 
%
%  dx1 : pas d'espace dans la direction x1.
%
%  dx2 : pas d'espace dans la direction x2.
%
%  N1 : nombre de points de grille dans la direction x1.
%
%  N2 : nombre de points de grilles dans la direction x2.
%
%  Outputs:
%  -------
%
%  L      : Matrice de l'opérateur Laplacien (dimension N1N2 x N1N2)
%
% 

% Initialisation
    %Ah taille N1*N2 x N1*N2
    nu1 = nu(1,1);
    nu2 = nu(2,1);
    e = ones(N1*N2, 1);
    Ah = spdiags([-e*nu1/(dx1^2) -e*nu2/(dx2^2) e*((2*nu1/(dx1^2))+(2*nu2/(dx2^2))) -e*nu2/(dx2^2) -e*nu1/(dx1^2)],[-N2 -1 0 1 N2], N1*N2, N1*N2);
    for k = 1:N1-1
        Ah(k*N2, k*N2 +1) = 0;
        Ah(k*N2-1, k*N2) = 0;
    end
    L=sparse(Ah);
    


end    
