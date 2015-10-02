% function [propCorrectLetter, propCorrectEachLetter, propCorrectOrientation, propCorrectXY, propCorrectFont, idealLabels] = calcIdealPerformanceForNoisySet(noisySet, statTestName, arg3, parMethod)
function [propCorrectLetter, propCorrectEachLetter, propCorrectOrientation, propCorrectXY, propCorrectFont, idealLabels] = calcIdealPerformanceForNoisySet(noisySet, opts)
% 
%     statTestName, arg3, parMethod
    if nargin < 2
        opts = struct;
    end
    
    statTestName = 'rawImage';
    if isfield(opts, 'test')
        statTestName = opts.test;
    end
    assert(any(strcmp(statTestName, {'rawImage', 'pooledImage', 'textureStats', 'PCA'})));
    
    useRawImage    =   strcmp(statTestName, 'rawImage');
    usePooledImage =   strcmp(statTestName, 'pooledImage');
    useTextureStats =  strcmp(statTestName, 'textureStats');
    usePCA          =  strcmp(statTestName, 'PCA');
    

%     if nargin < 2 || isempty(statTestName)
%         statTestName = 'RawImage';
%     end
    statTestName(1) = upper(statTestName(1));
        
    parMethod = [];
    if isfield(opts, 'parMethod')
        parMethod = opts.parMethod;
    end
        

    useCombinedTemplates = false;
    if  isfield(opts, 'combinedTemplates')
        useCombinedTemplates = opts.combinedTemplates;
    end
%     useCombinedTemplates = strcmp(arg3, 'CombinedTemplates');

    
    calcMethod = 'sumSqrDiffs';
    if isfield(opts, 'calcMethod')
        calcMethod = opts.calcMethod;
    end
    assert(any(strcmp(calcMethod, {'sumSqrDiffs', 'innerProduct'})))
    
    calcInnerProducts = strcmp(calcMethod, 'innerProduct');
    calcSumSqrDiffs = ~calcInnerProducts;
        

    trainingNoise = [];
    if isfield(opts, 'trainingNoise')
        trainingNoise = opts.trainingNoise;
    end
    
    
    
    if isfield(noisySet, 'targetPosition') && isnumeric(noisySet.targetPosition) &&  ~strcmp(noisySet.targetPosition, 'all')  && noisySet.nLettersEachImage > 1
        assert(length(noisySet.xs) > 1)
        signals = noisySet.signal(:,noisySet.targetPosition);
    else
        signals = noisySet.signal;
    end
    
    
    signalSize = size(signals);
    if strcmp(statTestName, 'RawImage') && useCombinedTemplates && numel(signals) > size(signals, 1)
%         assert(length(signals_size) == 2)
        % testing testing
        nPositions = signalSize(2);
        assert(nPositions > 1)
        for let_i = 1:signalSize(1)
            
            for tmp_i = 2:nPositions
                signals(let_i, 1).image = signals(let_i, 1).image +  signals(let_i, tmp_i).image;
            end
%             signals(let_i, 1).image = signals(let_i, 1).image / nPositions;
        end       
        signals = signals(:,1);
        residualEnergy = [noisySet.signal(:,1).E1]' * (nPositions-1);        
        
    end
        
    halfSignalEnergies = 0;
    if calcInnerProducts
        signalEnergies = [noisySet.signal.E1];
        halfSignalEnergies = signalEnergies(:)'/2;
    end
    
    %%
    signalSize = size(signals);
    nSignals = numel(signals);
    nLetters = size(signals, 1); % [nLetters, nX, nY, nOri] = size(signals_use);
    [imageH, imageW] = size(signals(1).image);
    
    
    
    [let_idxMtx, ori_idxMtx, x_idxMtx, y_idxMtx, font_idxMtx] = deal( zeros(signalSize) );
    for i = 1:nSignals
        [let_idxMtx(i), x_idxMtx(i), y_idxMtx(i), ori_idxMtx(i), font_idxMtx(i)] = ind2sub(signalSize, i);
    end
    setSize = length(noisySet.labels);

    
    multiLetterCorrect = 'onlyTarget';
    if isfield(opts, 'multiLetterCorrect')
        multiLetterCorrect = opts.multiLetterCorrect;
    end
    
    haveSecondLabels = isfield(noisySet, 'labels_distract');
    haveThirdLabels = isfield(noisySet, 'labels_distract2');
    useDistractorLabels_str = '';
    if haveSecondLabels 
        useDistractorLabels = switchh(multiLetterCorrect, {'AnyLetter', 'OnlyTarget'}, [true, false]);        
        useDistractorLabels_str = sprintf('(%s)', multiLetterCorrect);
    else
        useDistractorLabels = true;
    end

    labels_distract = [];
    labels_distract2 = [];
    if haveSecondLabels
        labels_distract = noisySet.labels_distract;
    end
    if haveThirdLabels
        labels_distract2 = noisySet.labels_distract2;
    end    
    
    
    
    inputMatrix = noisySet.inputMatrix;
    
    doPctCorrectOris = nargout >= 3;
    doPctCorrectXYs  = nargout >= 4;
    
    useUnblurredImagesIfAvailable = true;
    trainfilterStr = '';
    
    if useRawImage || usePooledImage
        %%
        nRep = 1;
        
        signalTemplates_3D = cat(3, signals(:).image);        
        
        %%
        if isfield(noisySet, 'nonBlurredImages') && useUnblurredImagesIfAvailable
            inputMatrix = noisySet.nonBlurredImages;
        end
        
        
        % "Train" the template matcher to deal with a particular noise in an optimal way
        trainFilterStr = '';
        if ~isempty(trainingNoise)
            
            switch trainingNoise.filterType
                case '1/f',
                    %%
                    trainingNoise.applyFourierMaskGainFactor = true; % always normalize the filter, so that don't affect the letter spectrum.
                    applyReverseMask = true;
                    f_exp = trainingNoise.f_exp;
                    mask_fftshifted = fourierMask([imageH, imageW], f_exp, '1/f', trainingNoise);
                    pinkMask = ifftshift(mask_fftshifted);
                    reverseNoiseMask_unnorm = 1./pinkMask;
                    reverseNoiseMask_unnorm(pinkMask == 0) = 1;
                    
                    f = fourierMaskCorrectionFactor(reverseNoiseMask_unnorm);
                    reverseNoiseMask = f * reverseNoiseMask_unnorm;
                    

                case {'band', 'lo', 'hi'}
                    %%
                    applyReverseMask = true;
%                     error('Cannot undo band/hi/lo filter')

                    [~, fontXheight, ~] = getFontSize(noisySet.fontName, noisySet.sizeStyle);  
       
                    if any(strcmp (trainingNoise.filterType, {'band', 'lo', 'hi'}))
                        trainingNoise.cycPerLet_range = getCycPerLet_range(trainingNoise);
                        trainingNoise.cycPerPix_range = trainingNoise.cycPerLet_range / fontXheight;
                    end
                    trainingNoise.applyFourierMaskGainFactor = false;  % we will normalize it outselves after inverting it.
                    
                    mask_fftshifted = fourierMask([imageH, imageW], trainingNoise.cycPerPix_range, 'band_cycPerPix', trainingNoise);
                    offset_to_add = 1e-6;
                    bandMask = ifftshift(mask_fftshifted) + offset_to_add;

                    reverseNoiseMask_unnorm = 1./bandMask;
                    reverseNoiseMask_unnorm(bandMask == 0) = 0;
                    f = fourierMaskCorrectionFactor(reverseNoiseMask_unnorm);
                    
                    reverseNoiseMask = reverseNoiseMask_unnorm * f;                    
                    
                    
                case 'white',
                    applyReverseMask = false;  % for white noise, don't need to do anything.
            end
                        %%
            if applyReverseMask                        
                
                if ~exist('inputMatrix_orig', 'var')
                    inputMatrix_orig = inputMatrix; 
                    signalTemplates_3D_orig = signalTemplates_3D; 
                end
                
                inputMatrix = ifft2( bsxfun(@times, reverseNoiseMask_unnorm,  fft2(inputMatrix_orig)), 'symmetric') ;
                signalTemplates_3D = ifft2( bsxfun(@times, reverseNoiseMask_unnorm,  fft2(signalTemplates_3D_orig) ), 'symmetric');
            end
            3;
            %%
            show = 0;
            if show
                %%
%                 mask_use = reverseNoiseMask_unnorm;
                mask_use = reverseNoiseMask;
                X = inputMatrix_orig(:,:,1);
                X_signal_orig = signalTemplates_3D_orig(:,:, noisySet.labels(1));
                
                Xf = fft2(X);
                Xfm = Xf .* mask_use;
                
                XfmF = ifft2(Xfm, 'symmetric');
                
                X_signal_filt = ifft2( fft2(X_signal_orig) .* mask_use, 'symmetric');
                
                figure(41); clf;
                subplot(1,6,1); imagesc(X);  ticksOff;   title('Original input (with noise)'); colorbar('location', 'southoutside');
                subplot(1,6,2); imagesc( fftshift( log10( abs( Xf )) ) );  ticksOff; title('fft(Original)'); colorbar('location', 'southoutside');
                subplot(1,6,3); imagesc( fftshift( mask_use) );  ticksOff; title('INV MASK'); colorbar('location', 'southoutside');
                subplot(1,6,4); imagesc( fftshift( log10( abs( Xfm ) ) )  );  ticksOff; title(' fft (Original x MASK)'); colorbar('location', 'southoutside');
                subplot(1,6,5); imagesc( XfmF ); ticksOff; title(' Output (filtered)'); colorbar('location', 'southoutside');
                subplot(1,6,6); imagesc( X_signal_filt ); ticksOff; title(' Signal (filtered)'); colorbar('location', 'southoutside');
                colormap('gray');

                
                X = inputMatrix_orig(:,:,1); 

            end
            
            trainFilterStr = sprintf('[Ideal for: %s]', filterStr(trainingNoise, 1));

        end
        
        
        
        
        if usePooledImage
            poolSize = opts.poolSize;
            poolType = 1;
            %%
%             [h,w, setSize] = size(noisySet.inputMatrix);
            nH = ceil(imageH/poolSize);
            nW = ceil(imageW/poolSize);
            h_idxs = arrayfun(@(i) (i-1)*poolSize+1 :  min(i*poolSize, imageH),  1:nH, 'un', 0);
            w_idxs = arrayfun(@(j) (j-1)*poolSize+1 :  min(j*poolSize, imageW),  1:nW, 'un', 0);
            %%
            3;
            newNoisyInput = zeros(nH, nW, setSize);
            newSignalTemplates_3D = zeros(nH, nW, nSignals);
            for i=1:nH 
                for j = 1:nW
                    X_noisy = inputMatrix(h_idxs{i},w_idxs{j},:);
                    X_signal = signalTemplates_3D(h_idxs{i},w_idxs{j},:);
                    
                    if isequal(poolType, 1)
                        X_noisy_pooled = mean(mean(X_noisy.^2,1),2);
                        X_signal_pooled = mean(mean(X_signal.^2,1),2);
                    elseif isequal(poolType, 2)
                        X_noisy_pooled = sqrt(mean(mean(X_noisy.^2,1),2) );
                        X_signal_pooled = sqrt(mean(mean(X_signal.^2,1),2) );

                    end                    
                    newNoisyInput(i,j,:) = X_noisy_pooled;
                    newSignalTemplates_3D(i,j,:) = X_signal_pooled;
                    
                end
            end            
            
            inputMatrix = newNoisyInput;
            signalTemplates_3D = newSignalTemplates_3D;
        end
        

        inputMatrix = reshape(inputMatrix, [numel(inputMatrix(:,:,1)), setSize]);        
        signalTemplates = reshape( signalTemplates_3D, [numel(signalTemplates_3D(:,:,1)), nSignals]);
        
%         if isa(inputMatrix, 'double') && ~isa(signalTemplates, 'double')
%             signalTemplates = double(signalTemplates);
%         end

        signalTemplates = double(signalTemplates);
        inputMatrix = double(inputMatrix);
        

    elseif usePCA
        %%
        scoreSize = numel(signals(1).imageScore);
        signalTemplates = cat(3, signals(:).imageScore);
        signalTemplates = reshape( signalTemplates, [scoreSize, nSignals]);

        allImageScores = noisySet.stimulusScores';
        
        nPcaScoresToTest = opts.nPCA;
        nPcaScoresToTest(nPcaScoresToTest > scoreSize) = [];
        nRep = length(nPcaScoresToTest);

    elseif useTextureStats
        %%
        nStats = numel(signals(1).textureStats);
        signalTemplates = single( cat(2, signals(:).textureStats) );
%         signalTemplates = reshape( signalTemplates, [nStats, nSignals]);

        allTextureStats = reshape(noisySet.textureStats, [nStats, setSize]); %length(noisySet.textureStats(1,:))]);
        normType = '';
        if isfield(opts, 'norm')
            normType = opts.norm;
        end        
        
        idx_use = max(abs(allTextureStats), [], 2)>0;
        allTextureStats_raw = allTextureStats(idx_use ,:);
        
        
        %%
        nRep = 1;
            
        if ~isempty(normType)
            %%
            meanNoisy = mean(allTextureStats_raw,2);
            allTextureStats_ms = bsxfun(@minus, allTextureStats_raw, meanNoisy);
            %%
            switch normArg

                case 'std',
                    %%
                    stdNoisy  =  std(allTextureStats_raw, [], 2);
                    stdNoisy_reg = max(stdNoisy, eps(class(allTextureStats_raw)) );
                    allTextureStats = bsxfun(@rdivide, allTextureStats_ms, stdNoisy_reg);                
                    plotOffset = 1;
                case 'cov',
                %%
                    covNoisy = cov(allTextureStats_raw');
                    [V,D] = eig(covNoisy);
                    whitenMtx = sqrt(D)\V'; % texture whitening matrix

                    allTextureStats = whitenMtx * allTextureStats_ms;
                    plotOffset = 2;
            end

            3;

            if 0
                signalTemplates = bsxfun(@rdivide, bsxfun(@minus, signalTemplates, meanNoisy), stdNoisy_reg);
                meanSignal = mean(signalTemplates,2);
                stdSignal =  std(signalTemplates, [], 2);

                maxStd = max(max(stdSignal,stdNoisy), eps(class(signalTemplates)));
            end

            signalTemplates = classMeans(allTextureStats, noisySet.labels);

            show = 0;
            if show
                %%
                figure(84+plotOffset); clf;
%                     subplot(2,1,1); plot(signalTemplates)
%                     subplot(2,1,2); plot(allTextureStats)
                nClasses = length(unique(noisySet.labels));                    
                set(gca,'colorOrder', jet(nClasses))

                plot(signalTemplates);
            end
            3;

        else
            %%
            weights = arg3;
            idx_nz_weights = find(weights ~= 0);
            weights_nz = weights(idx_nz_weights);

            signalTemplates = bsxfun(@times, signalTemplates(idx_nz_weights,:), weights_nz(:));
            allTextureStats = bsxfun(@times, allTextureStats(idx_nz_weights,:), weights_nz(:));
        end                        
        
        
    end
    
    
%     allImages = cat(3, noisySet.stimulus.image);
%     allImages = reshape(allImages, [imageH*imageW, setSize]);
%     allImages_GPU = gpuArray(allImages);
    
%     allStimuli = [noisySet.stimulus];
    tic;
    
    
    [nCorrectLetters, nCorrectOrientations, nCorrectXYs, nCorrectFonts] = deal(  zeros(1, nRep) );

    %%
%     assert(noisySet.background == 0);

    nCorrectEachLetter = zeros(nRep, nLetters);
    nEachLetter = zeros(nRep, nLetters);
    idealLabels = zeros(nRep, setSize);
    
    nCorrectCP = 0;
    
    useGPU = strcmp(parMethod, 'GPU');
    useParPool = strcmp(parMethod, 'parpool');
    
    par_str = '';
    if useGPU
                                %     allImages = cat(3, noisySet.stimulus.image);
%     allImages = reshape(allImages, );
%     allImages_GPU = gpuArray(allImages);
%%  
        par_str = '[GPU]';
        mem_needed = (numel(signalTemplates) * 4) * 2;
        gpu_dev = gpuDevice(1);
        total_mem = gpu_dev.TotalMemory;
        if total_mem > mem_needed 
            inputMatrix_GPU = gpuArray(inputMatrix);
            signalTemplates_GPU = gpuArray(signalTemplates);
        else
            par_str = '[cpu]';
            useGPU = 0;
        end

    end
    
    if useParPool
        curPool = gcp; 
        par_str = '[par]';
    end
    
%     t_gpu = 0;
%     t_mex = 0;
    
    for rep_i = 1:nRep
        
        calcMethod_str = '';
        combinedTemplateStr = iff(useCombinedTemplates, '[CombinedTemplates]', '');

        if usePCA
            n_comp = nPcaScoresToTest(rep_i);
            test_str = sprintf(' (with %2d PCA components)', n_comp);
        elseif useTextureStats
            test_str = '(Texture Stats)';
            if exist('weights', 'var')
                test_str = [test_str '[selected]'];
            end
        else
            test_str = '(Full Image)';
            calcMethod_str = ['[' calcMethod ']'];    
            
        end
        fprintf('Testing ideal %s%s%s%s%s%s: ', test_str, calcMethod_str, combinedTemplateStr, useDistractorLabels_str, par_str, trainFilterStr)

        nPBars = 25; step = setSize/nPBars;
        useProgressBar = 1;
        if useProgressBar
%             progressBar('init', setSize, nPBars);
            progressBar('init', nPBars, nPBars);
        end
        
        if ~useParPool 
            
                    
            for stim_i = 1:setSize
    %             s = allStimuli(stim_i);

                if useRawImage || usePooledImage


                    if calcSumSqrDiffs
                        if useGPU
                            errors_GPU = bsxfun(@minus, signalTemplates_GPU, inputMatrix_GPU(:,stim_i));    % templates: [nPix x nTemplates] - [1 x nPix]
                            sqrErrors_GPU = errors_GPU .* errors_GPU;
                            sumSqrErrs_GPU = sum(sqrErrors_GPU, 1);
                            sumSqrErrs = gather(sumSqrErrs_GPU);

                        else
                            sumSqrErrs = sumSqrErrors(signalTemplates, inputMatrix(:,stim_i));
                        end


                        if useCombinedTemplates
                            sumSqrErrs = sumSqrErrs - residualEnergy;
                        end

                    elseif calcInnerProducts
                        
                        
                        if useGPU
                            image_timesEachTemplate_GPU = inputMatrix_GPU(:,stim_i)' * signalTemplates_GPU;
                            image_timesEachTemplate = gather(image_timesEachTemplate_GPU);
                        else                        
                        
                            image_timesEachTemplate =  (inputMatrix(:,stim_i)' * signalTemplates);
                        end

%                         imageEnergy = sum(inputMtx_i(:).^2);
%                         sumSqrErrs = imageEnergy + signalEnergies(:) - 2 * image_timesEachTemplate; %  min(sumSqrErr) = max(dot product) = min(-dot product)
                        
                        sumSqrErrs = halfSignalEnergies - image_timesEachTemplate; 

                        check = 0;
                        if check
                            sumSqrErrs_actual = sumSqrErrors(signalTemplates, input_i);
%                             assert( all (ord(sumSqrErrs) == ord(sumSqrErrs_actual) ) );
                            assert(max(abs(sumSqrErrs - sumSqrErrs_actual))/max(abs(sumSqrErrs)) < 1e-5 );
                        end
                        
                    end
    %                 crossProduct =  (inputMtx_i(:)' * signalTemplates)';
    %                 idx_min_err = indmin(sumSqrErrs);
    %                 idx_max_cp = indmax(crossProduct);



                elseif usePCA
                    sumSqrErrs = sumSqrErrors(signalTemplates, allImageScores(:,stim_i), n_comp);

                elseif useTextureStats

                    sumSqrErrs = sumSqrErrors(signalTemplates, allTextureStats(:, stim_i) );

                end

                [~,idx_lowest_err]=min(sumSqrErrs);

                idealLabels(rep_i, stim_i) = idx_lowest_err;

                let_i = let_idxMtx(idx_lowest_err);
                ori_i = ori_idxMtx(idx_lowest_err);
                xi    = x_idxMtx(idx_lowest_err);
                yi    = y_idxMtx(idx_lowest_err);
                font_i = font_idxMtx(idx_lowest_err);

                correctLabel_idx = noisySet.labels(stim_i);

                if useDistractorLabels && haveSecondLabels
                    isCorrect = (let_i== correctLabel_idx) || (haveSecondLabels && (let_i == labels_distract(stim_i))) ...
                                                           || (haveThirdLabels  && (let_i == labels_distract2(stim_i)));
                else
                    isCorrect = (let_i== correctLabel_idx);
                end

                if ~isCorrect
                    3;
                end

    %             if exist('crossProduct', 'var')
    %                 nCorrectCP = nCorrectCP + (idx_max_cp == correctLabel_idx);
    %                 if (idx_max_cp == correctLabel_idx) && (idx_min_err ~= correctLabel_idx)
    %                     %%
    % %                     figure(14);
    % %                     D1 = reshape( signalTemplates(:,correctLabel_idx), size(inputMtx_i) ) - inputMtx_i;
    % %                     subplot(2,1,1); imagesc(  ); axis image; caxis([-1.1, 1.1]);
    % %                     
    % %                     D2 = reshape( signalTemplates(:,idx_min_err), size(inputMtx_i) ) - inputMtx_i;
    % %                     subplot(2,1,2); imagesc( reshape( signalTemplates(:,idx_min_err), size(inputMtx_i) ) - inputMtx_i ); axis image; caxis([-1.1, 1.1]);
    %                     3;
    %                 end
    %             end

                if isCorrect
                    nCorrectLetters(rep_i) = nCorrectLetters(rep_i)+1;
                    nCorrectEachLetter(rep_i, correctLabel_idx) = nCorrectEachLetter(rep_i, correctLabel_idx)+1;
                end
                nEachLetter(rep_i, correctLabel_idx) = nEachLetter(rep_i, correctLabel_idx) + 1;

                if doPctCorrectOris &&  ori_i == noisySet.targetOri_idx(stim_i)  
                    nCorrectOrientations(rep_i) = nCorrectOrientations(rep_i)+1;
                end
                if doPctCorrectXYs && xi == noisySet.targetX_idx(stim_i) && yi==noisySet.targetY_idx(stim_i)
                    nCorrectXYs(rep_i) = nCorrectXYs(rep_i) + 1;
                end
                if doPctCorrectXYs && font_i == noisySet.font_idx(stim_i)
                    nCorrectFonts(rep_i) = nCorrectFonts(rep_i) + 1;
                end



%                 if 0 %useProgressBar    
%                     progressBar(stim_i)
%                 else
                    if mod(stim_i, step) == 0
                        if useProgressBar
                            progressBar(stim_i/step)     
                        else
                            fprintf('.');
                        end
                    end
%                 end
            end
        
            
            if useProgressBar    
                progressBar('done');
            end
            
        elseif useParPool

            %%     
            
            
            assert(~useGPU);

            %             ppool = parpool;
            all_isCorrect = false(1, setSize);
            allLabels = noisySet.labels;
            %%
            tic()
            parfor stim_i = 1:setSize
    
                sumSqrErrs_c = 0;
                
%                 inputMtx_j = ;

                if calcSumSqrDiffs
                    sumSqrErrs_c = sumSqrErrors(signalTemplates, inputMatrix(:,stim_i));

                elseif calcInnerProducts                
                    image_timesEachTemplate =  (inputMatrix(:,stim_i)' * signalTemplates);
    
                    sumSqrErrs_c = halfSignalEnergies - image_timesEachTemplate; 
                end
                
                [~,idx_lowest_err]=min(sumSqrErrs_c);

                idealLabels(rep_i, stim_i) = idx_lowest_err;

                let_i = let_idxMtx(idx_lowest_err);
%                 ori_i = ori_idxMtx(idx_lowest_err);
%                 xi    = x_idxMtx(idx_lowest_err);
%                 yi    = y_idxMtx(idx_lowest_err);
%                 font_i = font_idxMtx(idx_lowest_err);

                correctLabel_idx = allLabels(stim_i);

                if useDistractorLabels && haveSecondLabels
%                     all_isCorrect(stim_i) = (let_i== correctLabel_idx) || (haveSecondLabels && (let_i == labels_distract(stim_i))) ...
%                                                                        || (haveThirdLabels  && (let_i == labels_distract2(stim_i)));
                else
                    all_isCorrect(stim_i) = (let_i== correctLabel_idx);
                end
                
%                 nDone = nDone+1;
                if mod(stim_i, step) == 0
%                     fprintf('[%d]', stim_i/step)
                    fprintf('.');
%                     if useProgressBar
%                         progressBar;
%                     else
                end
%                 end
                
            end
            
            %%
            nCorrectLetters = nnz(all_isCorrect);
            fprintf(repmat('.', 1, nPBars));

            for let_i = 1:nLetters
                idx_thisLetter = (allLabels == let_i);
                nEachLetter(rep_i, let_i) = nnz(idx_thisLetter);

                nCorrectEachLetter(rep_i, let_i) = nnz(all_isCorrect ( idx_thisLetter ));
            end                        
            
            toc();
%                 if doPctCorrectOris &&  ori_i == noisySet.targetOri_idx(stim_i)  
%                     nCorrectOrientations(rep_i) = nCorrectOrientations(rep_i)+1;
%                 end
%                 if doPctCorrectXYs && xi == noisySet.targetX_idx(stim_i) && yi==noisySet.targetY_idx(stim_i)
%                     nCorrectXYs(rep_i) = nCorrectXYs(rep_i) + 1;
%                 end
%                 if doPctCorrectXYs && font_i == noisySet.font_idx(stim_i)
%                     nCorrectFonts(rep_i) = nCorrectFonts(rep_i) + 1;
%                 end


% 
%                 if 0 % useProgressBar    
%                     progressBar(stim_i)
%                 else
%                     if mod(stim_i, step) == 0
%                         if useProgressBar
%                             progressBar(stim_i/step)     
%                         else
%                             fprintf('.');
%                         end
%                     end
%                 end
%                         end

            
                        
            
        end
            
            
        

        prop_correct_letter_i = nCorrectLetters(rep_i)/setSize;
        prop_correct_ori_i = nCorrectOrientations(rep_i)/setSize;
        prop_correct_xy_i = nCorrectXYs(rep_i)/setSize;
        
        showPctCorrectOriXY = 0;
        if showPctCorrectOriXY
            fprintf(' --> %.2f %% correct [oris: %.1f %%, xy: %.1f %%] ', prop_correct_letter_i*100, prop_correct_ori_i*100, prop_correct_xy_i*100);
        else
            fprintf('-> %.2f %% correct ', prop_correct_letter_i*100);
        end

        
    end    
    
    
    if exist('crossProduct', 'var')
       3; 
    end
    
    %%
    t_elapsed = toc;
    fprintf('(took %s)\n', sec2hms(t_elapsed))
    propCorrectLetter = nCorrectLetters / setSize;
    propCorrectEachLetter = nCorrectEachLetter ./ nEachLetter;
    assert(sum(nCorrectEachLetter) == nCorrectLetters);
    assert(sum(nEachLetter) == setSize);

    propCorrectOrientation = nCorrectOrientations / setSize;
    propCorrectXY = nCorrectXYs / setSize;
    propCorrectFont = nCorrectFonts / setSize;
    

        3;

end




%{


 for stim_i = 1:setSize
%             s = allStimuli(stim_i);
            inputMtx_i = noisySet.inputMatrix(:,:,stim_i);

            if ~usePCA
                sumSqrErrs = sumSqrErrors(signalTemplates, inputMtx_i);
            else
                sumSqrErrs = sumSqrErrors(signalTemplates, allImageScores(:,stim_i), n_comp);
            end
%             if ~usePCA
%                 sqrErrors2 = bsxfun(@minus, signalTemplates, allImages(:,stim_i)).^2;    % templates: [nPix x nTemplates] - [1 x nPix] 
%                 sumSqrErrs2 = sum(sqrErrors2, 1);
%             else
%                 sqrErrors2 = bsxfun(@minus, signalTemplates(1:n_comp,:), allImageScores(1:n_comp,stim_i)).^2;  % templates: [nPCA x nTemplates] - [1 x nPCA] 
%                 sumSqrErrs2 = sum(sqrErrors2(1:n_comp,:), 1);
%             end
            
%             if ~usePCA
%                 errors3 = bsxfun(@minus, signalTemplates_GPU, allImages_GPU(:,stim_i));    % templates: [nPix x nTemplates] - [1 x nPix] 
%                 sqrErrors3 = errors3 .* errors3;
% %                 sumSqrErrs3a = sum(gather(sqrErrors3), 1);
%                 sumSqrErrs3 = sum(sqrErrors3, 1);
% 
%                 [~,idx_lowest_err2]=min(sumSqrErrs3);
%                 idx_lowest_err2 = gather(idx_lowest_err2);
% %                 assert(isequal(sumSqrErrs3a, sumSqrErrs3));
%             else
%                 sqrErrors3 = bsxfun(@minus, signalTemplates_GPU(1:n_comp,:), allImageScores(1:n_comp,stim_i)).^2;  % templates: [nPCA x nTemplates] - [1 x nPCA] 
%                 sumSqrErrs3 = sum(sqrErrors3(1:n_comp,:), 1);
%             end

            [~,idx_lowest_err]=min(sumSqrErrs);

%             mx = max(sumSqrErrs3(:));
%             assert(isequal(sumSqrErrs(:), sumSqrErrs2(:)))
%             assert( gather( max(abs( (sumSqrErrs(:) - sumSqrErrs3(:))/mx  ))) < 1e-4 )
%             assert(isequal(idx_lowest_err, idx_lowest_err2));
            
            let_i = let_idxMtx(idx_lowest_err);
            ori_i = ori_idxMtx(idx_lowest_err);
            xi    = x_idxMtx(idx_lowest_err);
            yi    = y_idxMtx(idx_lowest_err);

    %             [let_i2,ori_i2,xi2,yi2]=ind2sub(signalSize,idx_lowest_err);  % much slower
    %             assert(isequal([let_i, ori_i, xi, yi], [let_i2,ori_i2,xi2,yi2]))
            correctLabel_idx = noisySet.labels(stim_i);
    
            if let_i== correctLabel_idx
                nCorrectLetters(rep_i) = nCorrectLetters(rep_i)+1;
                nCorrectEachLetter(rep_i, correctLabel_idx) = nCorrectEachLetter(rep_i, correctLabel_idx)+1;
            end
            nEachLetter(rep_i, correctLabel_idx) = nEachLetter(rep_i, correctLabel_idx) + 1;
            
            if ori_i== noisySet.inputOri_idx(stim_i)  
                nCorrectOrientations(rep_i) = nCorrectOrientations(rep_i)+1;
            end
            if xi== noisySet.inputX_idx(stim_i) && yi==noisySet.inputY_idx(stim_i)
                nCorrectXYs(rep_i) = nCorrectXYs(rep_i) + 1;
            end

            if mod(stim_i, step) == 0
                fprintf('.');
            end
        end

%}

%{

    testPCAuntilMatchesFullImage = 0;
        fracMatch = 0.99;
        alsoRequireOriandXY = 0;


        if testPCAuntilMatchesFullImage
            propCorrectLetter_fullImage = noisySet.propLetterCorrect_ideal;
            propCorrectOrientation_fullImage = noisySet.propOrientationCorrect_ideal;
            propCorrectXY_fullImage = noisySet.propXYCorrect_ideal;
            doNExtra = 5;
        end


%%%%%%%%%%%%%%%%

        if usePCA && testPCAuntilMatchesFullImage

            matchedFullImagePerformance = (prop_correct_letter_i >= propCorrectLetter_fullImage * fracMatch);
            if alsoRequireOriandXY
                
                 matchedFullImagePerformance = matchedFullImagePerformance && ...
                     (prop_correct_ori_i >= propCorrectOrientation_fullImage * fracMatch) && ...
                     (prop_correct_xy_i >= propCorrectXY_fullImage * fracMatch);
            end
                
            if matchedFullImagePerformance
                if (doNExtra == 0) || (rep_i == nRep)
                    nCorrectLetters(rep_i+1:end) = [];
                    nCorrectOrientations(rep_i+1:end) = [];
                    nCorrectXYs(rep_i+1:end) = [];
                    break;
                else
                    doNExtra = doNExtra-1;
                end 
            end
        end

%}

%{


%}