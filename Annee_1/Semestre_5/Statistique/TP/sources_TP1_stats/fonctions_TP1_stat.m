    
    % TP1 de Statistiques : fonctions a completer et rendre sur Moodle
    % Nom : Gras
    % Prénom : Yael
    % Groupe : 1SN-N
    
    function varargout = fonctions_TP1_stat(varargin)
    
        [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
    
    end
    
    % Fonction G_et_R_moyen (exercice_1.m) ----------------------------------
    function [G, R_moyen, distances] = ...
             G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
            
        G = [mean(x_donnees_bruitees) mean(y_donnees_bruitees)];
        distances = sqrt((y_donnees_bruitees - G(1,2)).^2 + (x_donnees_bruitees - G(1,1)).^2);
        R_moyen = mean(distances);
         
         
    end
    
    % Fonction estimation_C_uniforme (exercice_1.m) ---------------------------
    function [C_estime, R_moyen] = ...
             estimation_C_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)
    
         [G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
         C_possible = 2*R_moyen*(rand(n_tests,2) -0.5) + G;

         X = repmat(x_donnees_bruitees, n_tests, 1);
         Y = repmat(y_donnees_bruitees, n_tests, 1);

         X_C = repmat(C_possible(:,1), 1, length(x_donnees_bruitees));
         Y_C = repmat(C_possible(:,2), 1, length(y_donnees_bruitees));

         Dist_X = (X - X_C).^2;
         Dist_Y = (Y - Y_C).^2;

         Dist = (sqrt(Dist_X + Dist_Y)- R_moyen).^2;

         C_etoile = sum(Dist,2);

         [M, Index_min] = min(C_etoile);

         C_estime = C_possible(Index_min,:);



    
         
    
    end
    
    % Fonction estimation_C_et_R_uniforme (exercice_2.m) ----------------------
    function [C_estime, R_estime] = ...
             estimation_C_et_R_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)

        [G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);

        C_possible = 2*R_moyen*(rand(n_tests,2) -0.5) + G;
        R_possible = 0.5*R_moyen*(rand(n_tests,1)-0.5) + R_moyen;

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

    end
    
    % Fonction occultation_donnees (donnees_occultees.m) ----------------------
    function [x_donnees_bruitees, y_donnees_bruitees] = ...
             occultation_donnees(x_donnees_bruitees, y_donnees_bruitees, theta_donnees_bruitees)
        
        theta_1 = 2*pi*rand();
        theta_2 = 2*pi*rand();


        if theta_1 <= theta_2
            ind_remove = ((theta_donnees_bruitees(1,:) > theta_2) | (theta_donnees_bruitees(1,:) < theta_1));

            x_donnees_bruitees(ind_remove) = [];
            y_donnees_bruitees(ind_remove) = [];

        elseif theta_1 >= theta_2
            ind_remove = ((theta_donnees_bruitees(1,:) > theta_2) & (theta_donnees_bruitees(1,:) < theta_1));

            x_donnees_bruitees(ind_remove) = [];
            y_donnees_bruitees(ind_remove) = [];
        end


    end
    
    % Fonction estimation_C_et_R_normale (exercice_4.m, bonus) ----------------
    function [C_estime, R_estime] = ...
             estimation_C_et_R_normale(x_donnees_bruitees,y_donnees_bruitees,n_tests)
    
        [G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);

        C_possible = 2*R_moyen*(randn(n_tests, 2) -0.5) + G;
        R_possible = 0.5*R_moyen*(randn(n_tests, 1)-0.5) + R_moyen;

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
    
    end
