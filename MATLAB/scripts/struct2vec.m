function [v, idx_removed] = struct2vec(S, skipNansFlag)
    %%
    c = struct2cell(S);
    c_vec = cellfun(@(x) x(:), c, 'un', 0);
    v = vertcat(c_vec{:});
    
    if exist('skipNansFlag', 'var') && isequal(skipNansFlag, 1)
        idx_removed = find(isnan(v));
        v(idx_removed) = [];
    end
    
end