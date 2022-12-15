function [mu, sigma] = estimation_mu_Sigma(Donnees)
    mu = (mean(Donnees))';
    Xc = Donnees - mean(Donnees);
    sigma =  1/length(Donnees) * (Xc)' * Xc;
end