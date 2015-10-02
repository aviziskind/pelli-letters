function h = hashvariable(X)
    h = 1;
    if isstruct(X)
        fn = sort(fieldnames(X));
        for i = 1:length(fn)
            h = h * hashvariable(fn{i}) * hashvariable(X.(fn{i}));
        end        
    elseif iscell(X)
        for i = 1:numel(X)
            h = h * hashvariable(X{i});
        end        
    elseif ischar(X)
        h = prod( sum(X - 'A' + 1) );
    elseif isnumeric(X)
        idx_use = ~isnan(X) & ~isinf(X) & (X ~= 0);
        h = prod( double(  abs(X(idx_use)) ) );
    end
    
    h = (h-floor(h)) + mod(h, 2^32);
 
end