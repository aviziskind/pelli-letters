function y = ifftshift2_cache(x)
    persistent shift_idxs
    sz = size(x);
    if isempty(shift_idxs) 
        shift_idxs = {};
    end
    
    if any(size(shift_idxs) < sz) || isempty(shift_idxs{sz(1), sz(2)})        

        numDims = ndims(x);
        idx = cell(1, numDims);
        for k = 1:numDims
            m = size(x, k);
            p = floor(m/2);
            idx{k} = [p+1:m 1:p];
        end
        
        shift_idxs{sz(1), sz(2)} = idx;
        
    end
    
    idx = shift_idxs{sz(1), sz(2)};
    
    y = x(idx{:});

end