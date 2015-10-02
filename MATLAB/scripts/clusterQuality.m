function q = clusterQuality(w, inter_diffs, intra_diffs, pCorr_func)
    global nIter col_idx
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
    if mod(nIter, 500) == 0
        pCorr = pCorr_func(w);
        fprintf('Niter %d : q = %.2f. pCorr = %.1f\n', nIter, q, pCorr)
        if mod(nIter, 5000) == 0
            if isempty(col_idx)
                col_idx = 1;
            end
            figure(87);
            plot(1:length(w), w, color_s(col_idx));
            col_idx = col_idx + 1;
            3;
        end
    end
    
    
end
