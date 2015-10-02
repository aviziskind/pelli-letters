function loss = lossFuncForWeights(w, templates, inputMtx, labels, pCorr_func) 

    global nIter col_idx
    if isempty(nIter)
        nIter = 1;
    end


    w = w(:).^2/norm(w);
    
    w_nonzero_idx = find(w ~= 0);
    
    w_nz = w(w_nonzero_idx);
    
    templates_wgt = bsxfun(@times, templates(:,w_nonzero_idx), w_nz(:)');
    inputMtx_wgt = bsxfun(@times, inputMtx(:,w_nonzero_idx), w_nz(:)');
    loss = getMSE_softMax(templates_wgt, inputMtx_wgt, labels);

    
    
    nIter = nIter + 1;
    if mod(nIter, 5) == 0
        pCorr = pCorr_func(w);
        fprintf('Niter %d : loss = %.6f. pCorr = %.1f\n', nIter, loss, pCorr)
        if mod(nIter, 100) == 0
            if isempty(col_idx)
                col_idx = 1;
            end
            figure(87);
            plot(1:length(w), w, color_s(col_idx));
            col_idx = col_idx + 1;
            3;
        end
    end
    
%     pCorr = getMinSqrErrorPctCorrect(templates, inputMtx, labels);
end
