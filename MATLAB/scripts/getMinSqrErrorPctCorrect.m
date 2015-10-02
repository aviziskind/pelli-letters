function pctCorrect = getMinSqrErrorPctCorrect(templates, inputMtx, labels)
%%
    [nSamples, N] = size(inputMtx);
    
    if ~isempty(templates)
        [~, N2] = size(templates);
        assert(N == N2);
    else
        %%
        [~, class_idx] = uniqueList(labels);
        templates_C = cellfun(@(idx) mean(inputMtx(idx,:),1), class_idx, 'un', 0);
        templates = vertcat(templates_C{:});
    end
    
    nCorrect = 0;
    

    templates_t = templates';
    for stim_i = 1:nSamples
%%
        sumSqrErrs = sumSqrErrors(templates_t, inputMtx(stim_i,:));

        [~,idx_lowest_err]=min(sumSqrErrs);

        if idx_lowest_err == labels(stim_i)
            nCorrect = nCorrect + 1;
        end
    end
    
    pctCorrect = nCorrect / nSamples * 100;
    
end
