function idxs = textureStatsIdx_a_range(Nsc,Nor,Na, a_use)

%     Nsc = 2; Nor = 3; Na = 9; a_use = [3,5];
    
    fieldsWithA = {'autoCorrReal', 'autoCorrMag'};
    
    
    S.pixelStats = [1 6];
    S.pixelLPStats = [Nsc+1, 2];
    S.autoCorrReal = [Na,Na,Nsc+1];
    S.autoCorrMag = [Na,Na,Nsc,Nor];
    S.magMeans = [(Nsc*Nor)+2 1];
    S.cousinMagCorr = [Nor,Nor,Nsc+1];
    S.parentMagCorr = [Nor,Nor,Nsc];
    
    S.cousinRealCorr = [2*Nor,2*Nor,Nsc+1];
    S.parentRealCorr = [2*Nor,2*Nor,Nsc];
    
    S.varianceHPR = [1 1];

    fn = fieldnames(S);
    nFields = length(fn);
    for i = 1:length(fn)
        n(i) = prod(S.(fn{i}));
    end
    n_tot = sum(n);
    n_endIdx = cumsum(n);
    n_startIdx = [1, n_endIdx(1:end-1)+1];
    
    autoCorrReal_fld_idx = 3;
    autoCorrMag_fld_idx = 4;
    a_range_idx = a_use;
    
    idxs_C = cell(1, nFields);

    %%
    allPossA = 1:2:Na;
    nPossA = length(allPossA);
    a_idxs = cell(1, nPossA);
    
    for ai = 1:nPossA
        a = allPossA(ai);
        a_idxs{ai} =    (Na+1)/2 + [-(a-1)/2:(a-1)/2];
    end
    idx_a_use = nonzeros( binarySearch(allPossA, a_use, 1, 0) );
%     assert(all(idx_a_use));
    %%
    
    for fi = 1:length(fn)
        if any(strcmp(fn{fi}, fieldsWithA))
            if strcmp(fn{fi}, 'autoCorrReal')
                autoCorrReal_idxs = reshape( 1:n(fi), S.autoCorrReal);
                
                autoCorrReal_a_idxs = cell(1, nPossA);
                for ai = 1:nPossA
                    autoCorrReal_a_idxs{ai} = autoCorrReal_idxs(a_idxs{ai}, a_idxs{ai}, :);
                    autoCorrReal_a_idxs{ai} = autoCorrReal_a_idxs{ai}(:)';
                    for aj = 1:ai-1
                        autoCorrReal_a_idxs{ai} = setdiff(autoCorrReal_a_idxs{ai}, autoCorrReal_a_idxs{aj});
                    end
                end
                assert( isequal( sort([autoCorrReal_a_idxs{:}]), [1: n(autoCorrReal_fld_idx)]) );
                
                
                idxs_C{fi} = [n_startIdx(fi)-1] + [autoCorrReal_a_idxs{idx_a_use}];
                
                
            elseif strcmp(fn{fi}, 'autoCorrMag')
                
                autoCorrMag_idxs = reshape( 1:n(fi), S.autoCorrMag);
                
                autoCorrMag_a_idxs = cell(1, nPossA);
                for ai = 1:nPossA
                    autoCorrMag_a_idxs{ai} = autoCorrMag_idxs(a_idxs{ai}, a_idxs{ai}, :, :);
                    autoCorrMag_a_idxs{ai} = autoCorrMag_a_idxs{ai}(:)';
                    for aj = 1:ai-1
                        autoCorrMag_a_idxs{ai} = setdiff(autoCorrMag_a_idxs{ai}, autoCorrMag_a_idxs{aj});
                    end
                end
                assert( isequal( sort([autoCorrMag_a_idxs{:}]), [1: n(autoCorrMag_fld_idx)]) );
                
                
                idxs_C{fi} = [n_startIdx(fi)-1] + [autoCorrMag_a_idxs{idx_a_use}];
                
                
                
            end
        else
            idxs_C{fi} = n_startIdx(fi) : n_endIdx(fi);
            
        end
        
        
        
    end
        
    idxs = sort([idxs_C{:}]);
    
    if isequal(a_use, allPossA)
        assert(isequal(sort(idxs), 1:n_tot))
    end
        
    3;
    
    
end