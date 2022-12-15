
% TP3 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : Gras
% Prénom : Yael
% Groupe : 1SN-N

function varargout = fonctions_TP3_proba(varargin)

    switch varargin{1}
        
        case 'matrice_inertie'
            
            [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
            
        case {'ensemble_E_recursif','calcul_proba'}
            
            [varargout{1},varargout{2},varargout{3}] = feval(varargin{1},varargin{2:end});
    
    end
end

% Fonction ensemble_E_recursif (exercie_1.m) ------------------------------
function [E,contour,G_somme] = ...
    ensemble_E_recursif(E,contour,G_somme,i,j,voisins,G_x,G_y,card_max,cos_alpha)
    
    contour(i,j) =0;
    k = 1;

    while ((k<=8) & (size(E,1) < card_max))
        if contour(i+voisins(k,1), j+voisins(k,2)) == 1
            G_voisin = [G_x(i+voisins(k,1), j+voisins(k,2)), G_y(i+voisins(k,1), j+voisins(k,2))];
            if (G_voisin/norm(G_voisin)) * (G_somme/ norm(G_somme))'> cos_alpha
                E = [E; [i+voisins(k,1) j+voisins(k,2)]];
                G_somme = G_somme + G_voisin;
                [E,contour,G_somme] = ensemble_E_recursif(E,contour,G_somme,i+voisins(k,1), j+voisins(k,2),voisins,G_x,G_y,card_max,cos_alpha);

            end
        end
        k = k+1;
    end 
    
        
        
        
        
    
    
end

% Fonction matrice_inertie (exercice_2.m) ---------------------------------
function [M_inertie,C] = matrice_inertie(E,G_norme_E)
    PI = sum(G_norme_E);
    
    C1 = sum(G_norme_E .* E(:,1)) / PI;
    C2 = sum(G_norme_E .* E(:,2)) / PI;
    
    C=[C2 C1];

    M22 = sum(G_norme_E.*(E(:,1)-C1).^2)/PI;
    M12 = sum(G_norme_E.*(E(:,1)-C1).*(E(:,2)-C2))/PI;
    M21 = M12;
    M11 = sum(G_norme_E.*(E(:,2)-C2).^2)/PI;
    M_inertie = [M11 M12; M21 M22];
end

% Fonction calcul_proba (exercice_2.m) ------------------------------------
function [x_min,x_max,probabilite] = calcul_proba(E_nouveau_repere,p)

    n = size(E_nouveau_repere,1);
    x_min = min(E_nouveau_repere(:,1));
    x_max = max(E_nouveau_repere(:,1));
    y_min = min(E_nouveau_repere(:,2));
    y_max = max(E_nouveau_repere(:,2));
    N = round((x_max - x_min)*(y_max-y_min)); 
    
    probabilite = 1 - binocdf(n-1, N, p);
end
