function newSignalMatrix = addMargin(signalMatrix, marginWidth, marginValue)

    if nargin < 3
        marginValue = 0;
    end
    
    if length(marginWidth) == 1
        marginWidth = ones(1,4)*marginWidth;
    elseif length(marginWidth) == 2
        marginWidth = [floor(marginWidth(1)/2), ceil(marginWidth(1)/2), floor(marginWidth(2)/2), ceil(marginWidth(2)/2)];        
    end
    assert(all(marginWidth >= 0));
    
    margin_up = marginWidth(1);
    margin_down = marginWidth(2);
    margin_left = marginWidth(3);
    margin_right = marginWidth(4);

    
    [m,n, nLet] = size(signalMatrix);
    new_m = m + margin_up + margin_down;
    new_n = n + margin_left + margin_right;

    newSignalMatrix = ones(new_m, new_n, nLet)*marginValue;
    idx_rows = [1:m] + margin_up;
    idx_cols = [1:n] + margin_left;
    
    newSignalMatrix(idx_rows, idx_cols, :) = signalMatrix;    
end
