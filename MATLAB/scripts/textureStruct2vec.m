function [textureVec, idx_use, textureStruct] = textureStruct2vec(S, idx_use, useAllStats_flag, imageSize)
    %%
        
    haveIdxs = exist('idx_use', 'var') && ~isempty(idx_use);
    if haveIdxs
%         Sv_C = cellfun(@(x) x(:), struct2cell(Sv), 'un', 0);
%%
        S_C = cellfun(@(x) x(:), struct2cell(S), 'un', 0);
        textureVec_full = vertcat(S_C{:});
        textureVec = textureVec_full(idx_use);
        %%
        return;
    end
    
    useAllStats = exist('useAllStats_flag', 'var') && isequal(useAllStats_flag, 1);

    doChecks = 1;

    calculateIdxs = nargout > 1 || doChecks;
    
    
%     if nargin < 4
%         imageSize = [32, 32];
%     end
    
    useOnlyValidStatsFromImageSize = exist('imageSize', 'var') && ~isempty(imageSize);
    
    if useOnlyValidStatsFromImageSize
%         sampleImage = reshape(1:prod(imageSize), imageSize);
        sampleImage = randn(imageSize);
%         sampleImage = randn([32, 160]);
        if isstruct(S)
            [Na, ~, Nsc, Nor] = size(S.autoCorrMag);
        elseif isvector(S)
            assert(length(S) == 3);
            [Nsc, Nor, Na] = dealV(S);
        end
        S = textureAnalysis(sampleImage, Nsc, Nor, Na);
    end

    [Na, ~, Nsc, Nor] = size(S.autoCorrMag);
    
    
    Na_sqr = (Na^2+1)/2;    
    tf_use_autoCorr = mtx_selectUniqueAutocorr(Na);
    
    
    %% 1. Marginal statistics
    % 1a. marginal pixel statistics (6 params): 
        % [mean, variance, skew, kurtosis, min, max]
    Sv.pixelStats = S.pixelStats(:);
    if calculateIdxs
        S_idx.pixelStats = 1:length(S.pixelStats(:));
    end
    
    % 1b. marginial Low pass bands statistics (2*(Nsc+1))
    Sv.pixelLPStats = S.pixelLPStats(:);
    if calculateIdxs
        S_idx.pixelLPStats = 1:length(S.pixelLPStats(:));
    end
            


    
    %% 2. Raw coefficient correlation: 
    %  Central samples of the auto-correlation of the partially reconstructed 
    %  lowpass images, including the lowpass band: (Nsc+1)*(Na^2+1)/2
    Sv.autoCorrReal = zeros(Na_sqr, Nsc+1);
    if calculateIdxs
        S_idx.autoCorrReal = zeros(Na_sqr, Nsc+1);
    end
    for sc = 1:Nsc+1
        acr = S.autoCorrReal(:,:,sc);
        Sv.autoCorrReal(:,sc) = acr ( tf_use_autoCorr );
        if doChecks
            %%
            acr_used = sort( acr ( tf_use_autoCorr ));
            acr_notUsed = acr ( ~tf_use_autoCorr );
            assert(  containedIn( nonnans(acr_notUsed), nonnans(acr_used), 1e-10) );  % check that only leaving out redundant values
%             assert( setdiff(
            
        end
        
        if calculateIdxs
            S_idx.autoCorrReal(:,sc) = find( tf_use_autoCorr) + (sc-1) * (Na*Na);
        end

        tf_nans_autoCorrReal = isnan(Sv.autoCorrReal);
        if any(tf_nans_autoCorrReal(:))
%             fprintf('Removing %d nans from autoCorrReal\n', nnz(tf_nans_autoCorrReal(:)));
            Sv.autoCorrReal(tf_nans_autoCorrReal) = [];
            if calculateIdxs
                S_idx.autoCorrReal(tf_nans_autoCorrReal) = [];
            end
        end

        
    end
    if doChecks
        assert( isequal(S.autoCorrReal(S_idx.autoCorrReal(:)), Sv.autoCorrReal(:)) ); % check indexing is accurate
    end

    
    %% 3. Coefficient magnitude statistics
    % 3a Central samples of the auto-correlation of magnitude of each subband
    % ( Nsc * Nor  * (M^2 + 1)/2  params)
    Sv.autoCorrMag     = zeros(Na_sqr, Nsc, Nor); 
    if calculateIdxs
        S_idx.autoCorrMag = zeros(Na_sqr, Nsc, Nor);
    end
    for sc = 1:Nsc
        for or = 1:Nor
            acm = S.autoCorrMag(:,:,sc, or);
            Sv.autoCorrMag(:,sc,or)     = acm ( tf_use_autoCorr );
                            
            if doChecks
            %%
                acm_used =    acm ( tf_use_autoCorr  );
                acm_notUsed = acm ( ~tf_use_autoCorr );
                assert(  containedIn(acm_notUsed, acm_used, 1e-10) ); % check that only leaving out redundant values
                
            end
            
%             diff([ac_notUse, ac_use(binarySearch(ac_use, ac_notUse))], [], 2)    
            
            if calculateIdxs
                S_idx.autoCorrMag(:,sc,or) = find(tf_use_autoCorr) + (sc-1 + Nsc*(or-1)) *Na*Na; 
            end
        end
    end
    if doChecks
        assert( isequal(S.autoCorrMag(S_idx.autoCorrMag(:)), Sv.autoCorrMag(:)) ); % check indexing is accurate
    end
    
        
    % [[ 1d. ]] 
    if useAllStats  % means of magnitude of each band
        Sv.magMeans = S.magMeans;
        if calculateIdxs
             S_idx.magMeans = 1:numel(S.magMeans(:));
        end
    end
    
    
    %%
    % 3b. cross-correlation of each subband magnitudes with those of other 
    % orientations at the same scale   (  Nsc * K * (K-1)/2 params )
    ur_corner = triu(ones(Nor), 1) > 0;
    ll_corner = tril(ones(Nor), -1) > 0;
    if useAllStats % also include diagonal
        ur_corner_use = triu(ones(Nor), 0) > 0; 
        Nor_sqr = Nor*(Nor+1)/2;
    else  % just include values above diagonal (exclude autocorrelation of orientation bands)
        ur_corner_use = ur_corner;
        Nor_sqr = Nor*(Nor-1)/2;
    end

    Sv.cousinMagCorr     = zeros(Nor_sqr, Nsc);
    if calculateIdxs
        S_idx.cousinMagCorr = zeros(Nor_sqr, Nsc);
    end
    
    for sc = 1:Nsc
        C0 = S.cousinMagCorr(:,:,sc);
        Sv.cousinMagCorr    (:,sc) = C0(ur_corner_use);    
        if doChecks
            L = sort(C0(ll_corner)); U = sort(C0(ur_corner));
            assert( max(abs(L-U)) == 0);  % check that only leaving out redundant values
        end
        
        if calculateIdxs
            S_idx.cousinMagCorr(:,sc) = find(ur_corner_use) + (sc-1)*Nor*Nor;    
        end
    end
    
    if doChecks
        assert( all( vector(S.cousinMagCorr(:,:,Nsc+1) ) == 0 ) ); %% Nsc+1 layer is not used (is all zeros).
    end
    
    
    if doChecks
        assert( isequal(S.cousinMagCorr(S_idx.cousinMagCorr(:)), Sv.cousinMagCorr(:)) ); % check indexing is accurate
    end

    %%
    % 3c and crosscorrelation of subband magnitudes with all orientations 
    % at a coarser scale  (  K^2  * (Nsc - 1)   params )
    Sv.parentMagCorr     = S.parentMagCorr(:,:,1:Nsc-1); % ***   Cx0
    
    if calculateIdxs
        parentMagCorr_use_tf = false(Nor,Nor,Nsc+1);
        parentMagCorr_use_tf(:,:,1:Nsc-1) = 1;
        S_idx.parentMagCorr = find(parentMagCorr_use_tf); % ***   Cx0
        if doChecks
            assert( isequal(S.parentMagCorr(S_idx.parentMagCorr(:)), Sv.parentMagCorr(:)) ); % check indexing is accurate
        end
    end
    
    assert( all( vector(S.parentMagCorr(:,:,Nsc) ) == 0 ) ); % Nsc layer is not used (is all zeros);

    %% 4a. Same-scale phase statistics  
    if useAllStats
        
        Sv.cousinRealCorr     = zeros(Nor_sqr, Nsc);
        if calculateIdxs
            %%
            m = max(2*Nor,5);
            cousinRealCorr_use_tf = false(m,m,Nsc+1);    
            cousinRealCorr_use_tf_layer = false(m,m);
            [ur_corner_use_i, ur_corner_use_j] = find(ur_corner_use);
            cousinRealCorr_use_tf_layer( sub2indV([m, m], [ur_corner_use_i, ur_corner_use_j]) ) = 1;
            
%             S_idx.cousinRealCorr = zeros(Nor_sqr, Nsc);
        end
    
        for sc = 1:Nsc
            Cr0 = S.cousinRealCorr(1:Nor, 1:Nor, sc);
            
            Sv.cousinRealCorr    (:,sc) = Cr0(ur_corner_use);    
            if doChecks
                L = sort(Cr0(ll_corner)); U = sort(Cr0(ur_corner));
                assert( max(abs(L-U)) == 0); % check that only leaving out redundant values
            end

            if calculateIdxs
                cousinRealCorr_use_tf(:,:,sc) = cousinRealCorr_use_tf_layer;
%                 S_idx.cousinRealCorr(:,sc) = find(ur_corner_use) + (sc-1)*size(S.cousinRealCorr(:,:,1)); %  (2*Nor)*(2*Nor);    
            end
        end
        
        if useAllStats % add last layer
            lastLayer = S.cousinRealCorr(1:5, 1:5, Nsc+1);
            Sv.cousinRealCorr = [Sv.cousinRealCorr(:); lastLayer(:)];
            
            if calculateIdxs
                cousinRealCorr_use_tf(1:5, 1:5, Nsc+1) = 1;
                S_idx.cousinRealCorr = find(cousinRealCorr_use_tf);
                
%                 ;[S_idx.cousinRealCorr(:), ]; find(ur_corner_use) + (sc-1)*size(S.cousinRealCorr(:,:,1)); %  (2*Nor)*(2*Nor);    
            end
            
        end
        
        if doChecks
            assert( isequal(S.cousinRealCorr(S_idx.cousinRealCorr(:)), Sv.cousinRealCorr(:)) ); % check indexing is accurate
        end
        %%

    
    end
    
    
    %% 4. Cross-scale phase statistics: cross-correlation of the real part of
    % coefficients with both the real and imaginary part of the phase-doubled 
    % coefficients at all orientations at the next coarser scale  :
    % 2 Nor^2 (Nsc - 1)  params

    Sv.parentRealCorr = S.parentRealCorr(1:Nor, 1:(2*Nor), 1:Nsc-1);
    
    if calculateIdxs
        parentRealCorr_use_tf = false(2*Nor,max(2*Nor,5),Nsc);
        parentRealCorr_use_tf(1:Nor, 1:(2*Nor), 1:Nsc-1) = 1;
        
        if useAllStats
            lastLayer = S.parentRealCorr(1:Nor, 1:5, Nsc);
            Sv.parentRealCorr = [Sv.parentRealCorr(:); lastLayer(:)];
                        
            parentRealCorr_use_tf(1:Nor, 1:5, Nsc) = 1;
        end
            
        S_idx.parentRealCorr = find(parentRealCorr_use_tf); % ***   Cx0
        if doChecks
            assert( isequal(S.parentRealCorr(S_idx.parentRealCorr(:)), Sv.parentRealCorr(:)) );  % check indexing is accurate
        end
    end    
    
    %%
    

    
    % 1c. Variance of the high-pass band  (1 param)
    Sv.varianceHPR = S.varianceHPR;
    if calculateIdxs
        S_idx.varianceHPR = 1;
    end


    
    %{
    Na_sqr = (Na^2+1)/2;
    
    S.pixelStats = 6;                     % orig size = 6
    S.pixelLPStats = 2*(Nsc+1);           % orig size = [Nsc+1, 2]
    S.varianceHPR = 1;                    % orig size = 1
    
    S.autoCorrReal = Na_sqr * (Nsc+1);    % orig size  = [Na, Na, Nsc+1]
    S.autoCorrMag  = Na_sqr * Nsc * Nor;  % orig size = [Na, Na, Nsc, Nor]

%     S.magMeans = (Nsc*Nor)+2;           % orig size = (Nsc*Nor)+2
    S.magMeans = 0;

    S.cousinMagCorr = Nor * (Nor-1)/2 * Nsc;  % orig size =  [Nor,Nor,Nsc+1]
    S.parentMagCorr = Nor * Nor * (Nsc-1);    % orig size =  [Nor,Nor,Nsc]
    
%     S.cousinRealCorr = (2*Nor)*(2*Nor)*(Nsc+1); % orig size = [2*Nor,2*Nor,Nsc+1];
    S.cousinRealCorr = 0;                     

    S.parentRealCorr = (2*Nor^2)*(Nsc-1);     % orig size =   [2*Nor,2*Nor,Nsc];
    
    %}

    
    
    
  
    
    
    %%
    Sv_C = cellfun(@(x) x(:), struct2cell(Sv), 'un', 0);
    textureVec = vertcat(Sv_C{:});

    if calculateIdxs
    
        nEachField = structfun(@numel, S);
        idxOffsets = [0; cumsum( nEachField )];

        fn = fieldnames(S);
        nFields = length(fn);
        idx_use_C = cell(1,nFields);
        for fld_i = 1:nFields
            %%
            if isfield(Sv, fn{fld_i})
                idx_use_C{fld_i} = idxOffsets(fld_i) + S_idx.(fn{fld_i})(:);
            end
        end

        idx_use = vertcat(idx_use_C{:});

        idx_nans = find(isnan(textureVec));
        if ~isempty(idx_nans)
            idx_use(idx_nans) = [];
        end
        
        if doChecks
            S_C = cellfun(@(x) x(:), struct2cell(S), 'un', 0);
            textureVec_full = vertcat(S_C{:});
            assert(isequal(textureVec_full(idx_use), nonnans(textureVec)));
        end
        textureVec = textureVec_full(idx_use);
    else
        textureVec = nonnans(textureVec);
        
    end
    
    textureStruct = Sv;

    %%
    

    
%%
    3;
    
    
    %%

%     c_vec = cellfun(@(x) x(:), c, 'un', 0);
%     v = vertcat(c_vec{:});

%     if Nor == 4 && Nsc == 4 && Na == 7
%         assert(length(textureVec) == 710)
%     end

    
end






%{
function [v, idx_removed] = textureStruct2vec(S)
    %%
    c = struct2cell(S);
    c_vec = cellfun(@(x) x(:), c, 'un', 0);
    v = vertcat(c_vec{:});
    
    if exist('skipNansFlag', 'var') && isequal(skipNansFlag, 1)
        idx_removed = find(isnan(v));
        v(idx_removed) = [];
    end
    
end
%}
function tf_use = mtx_selectUniqueAutocorr(M)
    tf_use = flipud( tril(ones(M) ) > 0 );

    tf_remove = flipud( diag(1:M) ) > (M/2+1);

    tf_use(tf_remove) = 0;

    assert(nnz(tf_use) == (M^2+1)/2);
end





function tf = containedIn(vals_notUsed, vals_used, tol)
    vals_used = sort(vals_used);
    vals_closestToUsed = vals_used(binarySearch(vals_used, vals_notUsed));

    tf = max(abs( diff([vals_notUsed, vals_closestToUsed], [], 2))) < tol;
end