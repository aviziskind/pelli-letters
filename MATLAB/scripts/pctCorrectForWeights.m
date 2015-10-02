
function pCorr = pctCorrectForWeights(w, templates, inputMtx, labels) 
    w = w(:).^2/norm(w);
    
    w_nonzero_idx = find(w ~= 0);
    
    w_nz = w(w_nonzero_idx);
    
    templates_wgt = bsxfun(@times, templates(:,w_nonzero_idx), w_nz(:)');
    inputMtx_wgt = bsxfun(@times, inputMtx(:,w_nonzero_idx), w_nz(:)');
    pCorr = getMinSqrErrorPctCorrect(templates_wgt, inputMtx_wgt, labels);

%     pCorr = getMinSqrErrorPctCorrect(templates, inputMtx, labels);
end
