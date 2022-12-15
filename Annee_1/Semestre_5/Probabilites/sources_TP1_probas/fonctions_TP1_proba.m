
% TP1 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : Gras
% Prénom : Yael
% Groupe : 1SN-N

function varargout = fonctions_TP1_proba(varargin)

    switch varargin{1}     
        case 'ecriture_RVB'
            varargout{1} = feval(varargin{1},varargin{2:end});
        case {'vectorisation_par_colonne','decorrelation_colonnes'}
            [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
        case 'calcul_parametres_correlation'
            [varargout{1},varargout{2},varargout{3}] = feval(varargin{1},varargin{2:end}); 
    end

end

% Fonction ecriture_RVB (exercice_0.m) ------------------------------------
% (Copiez le corps de la fonction ecriture_RVB du fichier du meme nom)
function image_RVB = ecriture_RVB(image_originale)

    V1 = image_originale(1:2:end,1:2:end);
    R = image_originale(1:2:end,2:2:end);
    V2 =image_originale(2:2:end,2:2:end);
    B = image_originale(2:2:end,1:2:end);
    V = (V1+V2)/2;
    image_RVB = cat(3,R,V,B) ;

end

% Fonction vectorisation_par_colonne (exercice_1.m) -----------------------
function [Vd,Vg] = vectorisation_par_colonne(I)

    Md = I(:,2:2:end);
    Mg = I(:,1:2:end-1);
    Vd = Md(:);
    Vg = Mg(:);


end

% Fonction calcul_parametres_correlation (exercice_1.m) -------------------
function [r,a,b] = calcul_parametres_correlation(Vd,Vg)

    moy_Vd = mean(Vd);
    Var_Vd = mean((Vd-moy_Vd).^2);
    ET_Vd = sqrt(Var_Vd);
    
    moy_Vg = mean(Vg);
    Var_Vg = mean((Vg-moy_Vg).^2);
    ET_Vg= sqrt(Var_Vg);
    
    cov_VdVg = mean(Vd.*Vg) - moy_Vd * moy_Vg;
    
    r = cov_VdVg / (ET_Vd*ET_Vg);
    a = cov_VdVg / Var_Vd;
    b = moy_Vg - moy_Vd * cov_VdVg / Var_Vd;
    
end

% Fonction decorrelation_colonnes (exercice_2.m) --------------------------
function [I_decorrelee,I_min] = decorrelation_colonnes(I,I_max)

    I_decorrelee = I(:,:);
    matrice = zeros(size(I)); 
    matrice(:,2:end) = I(:,1:end-1);
    I_decorrelee = I_decorrelee - matrice;
    I_min = -I_max;
    
end



