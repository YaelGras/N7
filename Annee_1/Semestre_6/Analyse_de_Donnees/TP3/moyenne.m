function moy = moyenne(Image)
    Image = single(Image);
    R = Image(:,:,1);
    V = Image(:,:,2);
    B = Image(:,:,3);

    R = R(:);
    V = V(:);
    B = B(:);

    somme = R + V + B;
    maxi = max(1, somme);

    r = R./maxi;
    v = V./maxi;

    r_barre = mean(r);
    v_barre = mean(v);

    moy = [r_barre ; v_barre];

end
