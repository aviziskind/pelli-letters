function X_pad = symmetricPad(X, newSize)

    curSize = size(X);
    
    extraRows = newSize(1)-curSize(1);
    extraCols = newSize(2)-curSize(2);
    assert(extraRows >= 0);
    assert(extraCols >= 0);

    nAbove = floor(extraRows/2);
    nBelow = extraRows-nAbove;
    
    nLeft = floor(extraCols/2);
    nRight = extraCols-nLeft;
    %%
    X_pad = zeros(newSize);
    
    idx_v = [1:curSize(1)]+nAbove;
    idx_h = [1:curSize(2)]+nLeft;
    
    X_pad(idx_v, idx_h) = X;

end