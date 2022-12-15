function [beta, norm_grad_f_beta, f_beta, norm_delta, nb_it, exitflag] ...
          = Algo_Gauss_Newton(residu, J_residu, beta0, option)
%*****************************************************************
% Fichier  ~gergaud/ENS/Optim1a/TP-optim-20-21/TP-ref/GN_ref.m   *
% Novembre 2020                                                  *
% Université de Toulouse, INP-ENSEEIHT                           *
%*****************************************************************
%
% GN resout par l'algorithme de Gauss-Newton les problemes aux moindres carres
% Min 0.5||r(beta)||^2
% beta \in \IR^p
%
% Paramètres en entrés
% --------------------
% residu : fonction qui code les résidus
%          r : \IR^p --> \IR^n
% J_residu : fonction qui code la matrice jacobienne
%            Jr : \IR^p --> real(n,p)
% beta0 : point de départ
%         real(p)
% option(1) : Tol_abs, tolérance absolue
%             real
% option(2) : Tol_rel, tolérance relative
%             real
% option(3) : n_itmax, nombre d'itérations maximum
%             integer
%
% Paramètres en sortie
% --------------------
% beta      : beta
%             real(p)
% norm_gradf_beta : ||gradient f(beta)||
%                   real
% f_beta : f(beta)
%          real
% r_beta : r(beta)
%          real(n)
% norm_delta : ||delta||
%              real
% nbit : nombre d'itérations
%        integer
% exitflag   : indicateur de sortie
%              integer entre 1 et 4
% exitflag = 1 : ||gradient f(beta)|| < max(Tol_rel||gradient f(beta0)||,Tol_abs)
% exitflag = 2 : |f(beta^{k+1})-f(beta^k)| < max(Tol_rel|f(beta^k)|,Tol_abs)
% exitflag = 3 : ||delta)|| < max(Tol_rel delta^k),Tol_abs)
% exitflag = 4 : nombre maximum d'itérations atteint
%      
% ---------------------------------------------------------------------------------

% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nb_it = 0;
    
    res = residu(beta0);
    Jres = J_residu(beta0);    
    norme_grad_f_beta0 = sqrt((Jres' * res)' * (Jres' * res));
    
    beta = beta0;
    memory_beta = beta0;
    continu = true ;  
    
    
    while continu
        
        nb_it = nb_it + 1;
        
        %Beta k
        memory_beta = beta;
        
        %Beta k+1
        beta =  memory_beta - (J_residu(memory_beta)'*J_residu(memory_beta))\  J_residu(memory_beta)' *residu(memory_beta);
        
        
        
        grad_f = J_residu(beta)' * residu(beta);
        norme_grad_f = sqrt(grad_f' * grad_f);
        
        
        
        if (norme_grad_f <= max(option(2)* norme_grad_f_beta0, option(1)))
            continu = false;
            exitflag = 1;
        end
        
        if abs(1/2 * (residu(beta)' * residu(beta) - residu(memory_beta)' * residu(memory_beta))) <= max(option(2)* abs(1/2 * (residu(memory_beta)' * residu(memory_beta))), option(1))
            continu = false;
            exitflag = 2;
        end
        

        norm_delta = sqrt((beta - memory_beta)' * (beta - memory_beta));
        if norm_delta <= max(option(2)* sqrt(memory_beta' * memory_beta), option(1))
            continu = false;
            exitflag = 3;
        end
        
        if nb_it == option(3) 
            continu = false;
            exitflag = 4;            
        end                
              
        
    end



    
    norm_delta = sqrt((beta - memory_beta)' * (beta - memory_beta));
    beta = memory_beta;
    grad_f = J_residu(beta)' * residu(beta);
    norm_grad_f_beta = sqrt(grad_f' * grad_f);
    f_beta = 1/2* residu(beta)'*residu(beta);
    nb_it = nb_it;

end
