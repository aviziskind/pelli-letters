function X_norm = rescaleBetween0and1(X)
%%
    idx_valid = ~isinf(X(:)) & ~isnan(X(:));
    mn_val = min(X(idx_valid));
    mx_val = max(X(idx_valid));
    
    X_norm = (X- mn_val)/(mx_val - mn_val);
end
