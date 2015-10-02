function idxs = textureStatIdx(Nscl,Nori,Na, statNames, scl_range, ori_range, a_range)

    
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
    for i = 1:length(fn)
        n(i) = prod(S.(fn{i}));
    end
    
    %%
%         S.(fn{i}) = 
    
%     switch 
    
    
    
    
    
end