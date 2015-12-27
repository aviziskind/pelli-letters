function X_rescaled = rescaleToRangeWithoutOffset(X, newRange)
%%
    lo = newRange(1);
    hi = newRange(2);
    maxNewVal = max(abs(newRange));
    

    idx_valid = ~isinf(X(:)) & ~isnan(X(:));
    mn_val = min(X(idx_valid));
    mx_val = max(X(idx_valid));

    maxOldVals = max(abs([mn_val, mx_val]));
    
    rescale_factor = maxNewVal / maxOldVals;

    X_rescaled = X * rescale_factor;
end
