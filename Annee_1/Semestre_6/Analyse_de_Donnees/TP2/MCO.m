function Beta = MCO(x,y)    
    x_2 = x.^2;
    xy = x.*y;
    y_2 = y.^2; 

    A = [x_2 xy y_2 x y ones(1, length(x))' ; 1 0 1 0 0 0];
    
    b = [zeros(1, length(x))' ; 1];
    Beta = pinv(A) * b;
end
