function n_tot = countStructElements(S)
    n_each = structfun(@(a) numel(a), S);
    n_tot = sum(n_each);
end