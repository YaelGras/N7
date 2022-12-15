
% TP2 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Gras    
% Prénom : Yael
% Groupe : 1SN-N

function varargout = fonctions_TP2_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)

     x_G = mean(x_donnees_bruitees);
     y_G = mean(y_donnees_bruitees);
     x_donnees_bruitees_centrees = x_donnees_bruitees - x_G;
     y_donnees_bruitees_centrees = y_donnees_bruitees - y_G;
     
end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)

    psi = rand(n_tests, 1) * pi - pi/2;
    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
    
    X = repmat(x_donnees_bruitees_centrees, n_tests, 1);
    Y = repmat(y_donnees_bruitees_centrees, n_tests, 1);
    
    tanpsi = tan(psi);

    argsum = (Y - tanpsi.*X).^2;
    somme = sum(argsum, 2);

    [~, mini] = min(somme);

    a_Dyx = tanpsi(mini);
    b_Dyx = y_G - x_G * a_Dyx;
           
end

% Fonction estimation_Dyx_MC (exercice_2.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)
    
    A = [x_donnees_bruitees; ones(1, length(x_donnees_bruitees))]';
    B = y_donnees_bruitees';
    Aplus = inv(A'*A)*A';
    X = Aplus*B;

    a_Dyx = X(1);
    b_Dyx = X(2);

end

% Fonction estimation_Dorth_MV (exercice_3.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
         estimation_Dorth_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)

    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
    
    theta = rand(n_tests, 1) * pi - pi/2;
    X = repmat(x_donnees_bruitees_centrees, n_tests, 1);
    Y = repmat(y_donnees_bruitees_centrees, n_tests, 1);

    argsum = (cos(theta).*X + sin(theta).*Y).^2;
    somme = sum(argsum, 2);
    [~, mini] = min(somme);
    theta_Dorth = theta(mini);

    rho_Dorth = x_G * cos(theta_Dorth) + y_G * sin(theta_Dorth);

end

% Fonction estimation_Dorth_MC (exercice_4.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
                 estimation_Dorth_MC(x_donnees_bruitees,y_donnees_bruitees)

    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    C = [x_donnees_bruitees_centrees ; y_donnees_bruitees_centrees]';

    [V, D] = eig(C' * C);
    [~,ind] = sort(diag(D));
    imin = ind(1); %position de la première valeur propre 


    Yetoile = V(imin, :); % récupératin du vecteur propre correspondant à la plus petite valeur propre

    
    theta_Dorth = atan(Yetoile(2)/Yetoile(1));
    rho_Dorth = x_G * cos(theta_Dorth) + y_G * sin(theta_Dorth);

end
