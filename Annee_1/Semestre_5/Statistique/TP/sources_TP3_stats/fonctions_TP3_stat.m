
% TP3 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Gras
% Prenom : Yael
% Groupe : 1SN-N

function varargout = fonctions_TP3_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction estimation_F (exercice_1.m) ------------------------------------
function [rho_F,theta_F,ecart_moyen] = estimation_F(rho,theta)

    A = [cos(theta) sin(theta)];
    X = A\rho;
    
    x_F = X(1);
    y_F = X(2);

    rho_F = sqrt(x_F^2 + y_F^2);
    theta_F = atan2(y_F,x_F);




    % A modifier lors de l'utilisation de l'algorithme RANSAC (exercice 2)
    somme = abs(rho - rho_F * cos(theta - theta_F));
    ecart_moyen = 1/(length(rho_F)) * sum(somme);
end

% Fonction RANSAC_2 (exercice_2.m) ----------------------------------------
function [rho_F_estime,theta_F_estime] = RANSAC_2(rho,theta,parametres)

    it_max = parametres(3);

    ecart_moy_min = inf;


    for iteration = 1:it_max
        indices = randperm(length(rho), 2);
        
        candidat = [rho(indices(1)) rho(indices(2)) ; theta(indices(1)) theta(indices(2))];
        [rho_F,theta_F,~] = estimation_F(candidat(1,:)', candidat(2,:)');

        ecart = abs(rho - rho_F * cos(theta - theta_F));

        indices_conformes = find(ecart < parametres(1));

        if length(indices_conformes)/length(rho) > parametres(2)

            [rho_F, theta_F, ecart_moyen] =  estimation_F(rho(indices_conformes),theta(indices_conformes));

            if ecart_moyen < ecart_moy_min
                ecart_moy_min = ecart_moyen;
                rho_F_estime = rho_F;
                theta_F_estime = theta_F;
            end
        end 
        


    end 


end

% Fonction G_et_R_moyen (exercice_3.m, bonus, fonction du TP1) ------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)

    G = [mean(x_donnees_bruitees) mean(y_donnees_bruitees)];
    distances = sqrt((y_donnees_bruitees - G(1,2)).^2 + (x_donnees_bruitees - G(1,1)).^2);
    R_moyen = mean(distances);

end

% Fonction estimation_C_et_R (exercice_3.m, bonus, fonction du TP1) -------
function [C_estime,R_estime,critere] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,n_tests,C_tests,R_tests)
     
    % Attention : par rapport au TP1, le tirage des C_tests et R_tests est 
    %             considere comme etant deje effectue 
    %             (il doit etre fait au debut de la fonction RANSAC_3)


        C_possible = 2*R_tests*(rand(n_tests,2) -0.5) + C_tests;
        R_possible = 0.5*R_tests*(rand(n_tests,1)-0.5) + R_tests;

        X = repmat(x_donnees_bruitees, n_tests, 1);
        Y = repmat(y_donnees_bruitees, n_tests, 1);

        X_C = repmat(C_possible(:,1), 1, length(x_donnees_bruitees));
        Y_C = repmat(C_possible(:,2), 1, length(y_donnees_bruitees));

        Dist_X = (X - X_C).^2;
        Dist_Y = (Y - Y_C).^2;

        Dist = (sqrt(Dist_X + Dist_Y)- R_possible).^2;

        C_etoile = sum(Dist,2);

        [~, Index_min] = min(C_etoile);

        C_estime = C_possible(Index_min,:);
        R_estime = R_possible(Index_min);
        somme = abs(R_estime - sqrt((x_donnees_bruitees - C_estime(1)).^2 + (y_donnees_bruitees - C_estime(2)).^2));
        critere = 1/(length(x_donnees_bruitees)) * sum(somme);
         
end

% Fonction RANSAC_3 (exercice_3, bonus) -----------------------------------
function [C_estime,R_estime] = ...
         RANSAC_3(x_donnees_bruitees,y_donnees_bruitees,parametres)
     
    % Attention : il faut faire les tirages de C_tests et R_tests ici

    it_max = parametres(3);

    ecart_moy_min = inf;

    for iteration = 1:it_max

        indices = randperm(length(x_donnees_bruitees), 3);
        
        x = x_donnees_bruitees(indices);
        y = y_donnees_bruitees(indices);
        
        [C,R] = estimation_cercle_3points(x,y);

        ecart = abs(R - sqrt((x_donnees_bruitees - C(1)).^2 + (y_donnees_bruitees - C(2)).^2));

        indices_conformes = find(ecart < parametres(1));

        if length(indices_conformes)/length(x_donnees_bruitees) > parametres(2)
            
            [G, R_moyen, ~] = G_et_R_moyen(x_donnees_bruitees(indices_conformes),y_donnees_bruitees(indices_conformes));
            [C, R, ecart_moyen] =  estimation_C_et_R(x_donnees_bruitees(indices_conformes),y_donnees_bruitees(indices_conformes), ...
                parametres(4), G, R_moyen);

            if ecart_moyen < ecart_moy_min
                ecart_moy_min = ecart_moyen;
                C_estime = C;
                R_estime = R;
            end
        end 
        


    end 

end
