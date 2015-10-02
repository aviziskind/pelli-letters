function loss = getMSE_softMax(templates, inputMtx, labels, pCorr_func)

    
    
    [~, N] = size(templates);
    [nSamples, N2] = size(inputMtx);
    
    assert(N == N2);
%     labels(stim_i)    

    loss = 0;
    for stim_i = 1:nSamples
%%
        sumSqrErrs = sumSqrErrors(templates', inputMtx(stim_i,:));
        smax = softmax(sumSqrErrs);
        
        smax(labels(stim_i)) = smax(labels(stim_i)) - 1;  % subtract 'correct label' vector
        loss_i = sum( smax.^2 );
        
        loss = loss + loss_i; 
    end
    


end


