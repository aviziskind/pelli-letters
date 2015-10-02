function X_scl = scaleByPixelRep(X, scaleFactor)
    dx = (1/scaleFactor);
    [m,n] = size(X(:,:,1));
    vidxs = floor(1: dx : m+ 1-dx);  % 1,1, 2,2, 3,3, ... m,m
    hidxs = floor(1: dx : n+ 1-dx);  % 1,1, 2,2, 3,3, ... n,n

    assert(length(vidxs) == m*scaleFactor);
    assert(length(hidxs) == n*scaleFactor);
   
    X_scl = X(vidxs, hidxs, :);
end