function X_rescaled = rescaleToRange(X, newRange)
%%
    lo = newRange(1);
    hi = newRange(2);

    idx_valid = ~isinf(X(:)) & ~isnan(X(:));
    mn_val = min(X(idx_valid));
    mx_val = max(X(idx_valid));
    
    X_rescaled = lo + (X- mn_val)/(mx_val - mn_val)*(hi-lo);
end
