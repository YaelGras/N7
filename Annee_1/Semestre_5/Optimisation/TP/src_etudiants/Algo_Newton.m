function [beta, norm_grad_f_beta, f_beta, norm_delta, nb_it, exitflag] ...
          = Algo_Newton(Hess_f_C14, beta0, option)
%************************************************************
% Fichier  ~gergaud/ENS/Optim1a/TP-optim-20-21/Newton_ref.m *
% Novembre 2020                                             *
% Université de Toulouse, INP-ENSEEIHT                      *
%************************************************************
%
% Newton r�sout par l'algorithme de Newton les problemes aux moindres carres
% Min 0.5||r(beta)||^2
% beta \in R^p
%
% Parametres en entrees
% --------------------
% Hess_f_C14 : fonction qui code la hessiennne de f
%              Hess_f_C14 : R^p --> matrice (p,p)
%              (la fonction retourne aussi le residu et la jacobienne)
% beta0  : point de départ
%          real(p)
% option(1) : Tol_abs, tolérance absolue
%             real
% option(2) : Tol_rel, tolérance relative
%             real
% option(3) : nitimax, nombre d'itérations maximum
%             integer
%
% Parametres en sortie
% --------------------
% beta      : beta
%             real(p)
% norm_gradf_beta : ||gradient f(beta)||
%                   real
% f_beta    : f(beta)
%             real
% res       : r(beta)
%             real(n)residu
% norm_delta : ||delta||
%              real
% nbit       : nombre d'itérations
%              integer
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

    H_beta = Hess_f_C14(beta0);
    res = H_beta(2);
    Jres = H_beta(3);    
    norme_grad_f_beta0 = sqrt((Jres' * res)' * (Jres' * res));
    
    beta = beta0;
    memory_beta = beta0;
    continu = true ;  
    
    while continu

        %Calcul de Beta k+1
        nb_it = nb_it + 1;
        
        %Beta k
        memory_beta = beta;
        
        H_beta_memory = Hess_f_C14(memory_beta);

        %Beta k+1
        beta =  memory_beta - (H_beta_memory(1))\ ( H_beta_memory(3)' * H_beta_memory(2));
        disp(beta);
        
        H_beta = Hess_f_C14(beta);
        grad_f = H_beta(3)' * H_beta(2);
        norme_grad_f = sqrt(grad_f' * grad_f);
        
        
        %Condition d'arr�t
        if (norme_grad_f <= max(option(2)* norme_grad_f_beta0, option(1)))
            continu = false;
            exitflag = 1;
        end
        
        if abs(1/2 * (H_beta(2)' * H_beta(2) - H_beta_memory(2)' * H_beta_memory(2))) <= max(option(2)* abs(1/2 * (H_beta_memory(2)' * H_beta_memory(2))), option(1))
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
    H_beta = Hess_f_C14(beta);
    grad_f = H_beta(3)' * H_beta(2);
    norm_grad_f_beta = sqrt(grad_f' * grad_f);

    f_beta = 1/2* H_beta(2)'*H_beta(2);
    nb_it = nb_it;


end
