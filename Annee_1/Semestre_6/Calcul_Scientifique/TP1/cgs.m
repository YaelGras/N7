%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% cgs.m
%--------------------------------------------------------------------------

function Q = cgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;

    %------------------------------------------------
    % Algorithme de Gram-Schmidt classique
    %------------------------------------------------
    for i=1:m
        scal = A(:,i)'*Q;
        scal(i:end) = 0;
        
        Q(:,i) = Q(:,i) -  sum(scal.*Q, 2);
        
        Q(:,i) = Q(:,i)/norm(Q(:,i));        
    end
end