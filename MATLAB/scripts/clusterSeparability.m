function q = clusterSeparability(w, inter_diffs, intra_diffs)
    global nIter
    if isempty(nIter)
        nIter = 1;
    end
    
    w = w(:).^2 / norm(w);
    inter_diffs_wgt = bsxfun(@times, inter_diffs, w);
%     sum_inter = sum(sum(inter_diffs_wgt));
    sum_inter = sum(inter_diffs_wgt(:));
    
    intra_diffs_wgt = bsxfun(@times, intra_diffs, w);
%     sum_intra = sum( sum(  intra_diffs_wgt ) );
    sum_intra = sum( intra_diffs_wgt(:) );

    q = sum_inter / sum_intra;
    
    nIter = nIter + 1;
    if mod(nIter, 100) == 0
        fprintf('Niter %d : q = %.2f\n', nIter, q)
    end
    
    
end
