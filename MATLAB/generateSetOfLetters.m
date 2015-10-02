function letterSet = generateSetOfLetters(signal, params)
    
    [nLetters, nX, nY, nOri] = size(signal); %#ok<ASGLU>
    letterSet.signal=signal;

    setSize = params.setSize;
        
    
    
    signalContrast = 1;   
    %% Are we going to add noise? (and we need to know signal / noise contrast)
    addNoise = isfield(params, 'logSNR') && ~isnan(params.logSNR) && ~isinf(params.logSNR);
    if addNoise
        logSNR = params.logSNR;
    
        [signalContrast, noiseContrast, logE, logN] = getSignalNoiseContrast(logSNR, params);
        letterSet.logE = logE;
        letterSet.logN = logN;
        letterSet.logEOverN = logE - logN;
%         assert(logE-logN == logSNR);
        assert( isequalToPrecision(logE-logN,  logSNR, 1e-5) );
        letterSet.noiseContrast=noiseContrast;
        
        noiseSamples = params.noiseSamples;        
    end

    letterSet.signalContrast = signalContrast;
    

    %% Possible positions of target letters
    xs = params.xs;
    if ~isfield(params, 'targetPosition') || strcmp(params.targetPosition, 'all')
        target_xs_available_idx = 1:length(xs);
    elseif isfield(params, 'targetPosition')
        target_xs_available_idx = params.targetPosition;
    end

    %% Are we going to put in multiple letters?
    addDistractors = isfield(params, 'nDistractors') && params.nDistractors > 0;

    if addDistractors
        nDistractors = params.nDistractors;
        distractorSpacing = params.distractorSpacing;
%         distractContrast = signalContrast * (10^ params.logTDR);

        logDNR = params.logDNR;
%         logDNR = 3;
        [distractContrast_sigFixed, noiseContrast_sigFixed] = getSignalNoiseContrast(logDNR, params);
        distractContrast = distractContrast_sigFixed * (noiseContrast / noiseContrast_sigFixed);
        %%
%         xs_withSpacingOnLeft = xs >= xs(1)   + distractorSpacing;
%         xs_withSpacingOnRight  = xs <= xs(end) - distractorSpacing;
        if isfield(params, 'targetPosition') && strcmp(params.targetPosition, 'all')  % automatically select target positions that have space for the distractor(s)
            xs_withSpacingOnRight = 1:length(xs) >= distractorSpacing+1;
            xs_withSpacingOnLeft  = 1:length(xs) <= length(xs) - distractorSpacing;
            if nDistractors == 1
                target_xs_withSpace_idx = find( xs_withSpacingOnLeft | xs_withSpacingOnRight);
            elseif nDistractors == 2
                target_xs_withSpace_idx = find( xs_withSpacingOnLeft & xs_withSpacingOnRight);
            end
            if isempty(target_xs_withSpace_idx)
                error('Not enough space for the target and the distractor(s)');
            end

            target_xs_available_idx = intersect(target_xs_available_idx, target_xs_withSpace_idx);
        end
    else
        nDistractors = 0;        
        
    end
%     target_xs_available = xs(target_xs_available_idx);
    nTarget_Xs_available = length(target_xs_available_idx);

%     if nTarget_Xs_available > 1
%         targetPosition = params.targetPosition;
%     else
%         targetPosition = target_xs_available_idx;
%     end
                

    %% If we're adding noise, is it going to be filtered?
    filterNoise = addNoise && isfield(params, 'noiseFilter') && ~isempty(params.noiseFilter) && ~strcmp(params.noiseFilter.filterType, 'white');
    allNoiseImageVars = zeros(1,setSize);
    showFourierMask = 0;
    all_f_exp = [];
    if filterNoise
        imageSize = size(signal(1).image);
        [noiseMasks, noiseMasks_fftshifted, all_f_exp] = getNoiseMask(params.noiseFilter, imageSize);
        
        if showFourierMask
            %%
            figure(65); clf; subplot(1,2,1);
            imagesc(noiseMasks_fftshifted{1}); axis image;
            colormap('gray');
            if strcmp(filtType, 'band')
                title(sprintf('c/let = %.2f', params.noiseFilter.cycPerLet_centFreq))
            end
            3;
            
        end

        nMasks = length(noiseMasks);
        
    end

    
    %% Are we going to add blur to the entire image (signal + noise)
    blurImage = isfield(params, 'blurStd') && params.blurStd > 0;
    if blurImage
        blurStd = params.blurStd;
    end
    %%
    
    %% Are we going to output texture statistics instead of raw images?
    outputTextureStatistics = isfield(params, 'doTextureStatistics') && params.doTextureStatistics == 1;
    if outputTextureStatistics
        Nscl_txt = params.textureStatsParams.Nscl_txt;
        Nori_txt = params.textureStatsParams.Nori_txt;
        Na_txt = params.textureStatsParams.Na_txt;
        if isfield(params, 'idx_textureStats_use')
            idx_textureStats_use = params.idx_textureStats_use;
        else
            idx_textureStats_use = [];
        end
    end
    %%
    
    nPBars = 30; 
    doProgressBar = 1;
    fprintf('Generating Noisy Letter Set (n = %d samples): ', setSize);
    if doProgressBar
        progressBar('init-', setSize, nPBars);
    else 
        tic;
        step = round(setSize/nPBars);
    end
    
    
    
    for sample_idx = 1:setSize

        % Pick a Target letter (a..z)
        targetLetter_idx = randi(nLetters);  

        % Pick a target X (horizontal) position
        
%         if strcmp(targetPosition, 'all') 
        target_x_idx_idx = randi(nTarget_Xs_available);
        target_x_idx = target_xs_available_idx(target_x_idx_idx);
%         elseif isnumeric(targetPosition)
%             target_x_idx_idx = randi( length(targetPosition) );
%             target_x_idx = targetPosition(target_x_idx_idx);
%         end
        
        % Pick a target Y position
        target_y_idx = randi(nY);

        % Pick a target Orientation
        target_ori_idx = randi(nOri);
        
        target_image = signal(targetLetter_idx, target_x_idx, target_y_idx, target_ori_idx).image;
        if signalContrast ~= 1
            target_image = target_image * signalContrast;
        end
        
        new_image = target_image;
                    
        if nDistractors > 0
            distract_let_idx = randi(nLetters, [1, nDistractors]);

            xs_distract_options = [target_x_idx - distractorSpacing, target_x_idx + distractorSpacing];
            xs_distract_options = xs_distract_options( xs_distract_options >= 1 & xs_distract_options <= length(xs));
        end
        
        for d_i = 1:nDistractors
        
            if nDistractors == 1  % pick one of the two sides randomly
                distract_x_idx_idx = randi(size(xs_distract_options));
            else  % on first iteration, pick left slot; on second iteration, pick right slot
                distract_x_idx_idx = d_i; 
            end
            
            distract_x_idx = xs_distract_options(distract_x_idx_idx);
            distract_y_idx   = randi(nY);
            distract_ori_idx   = randi(nOri);

            
            distract_image = signal(distract_let_idx(d_i), distract_x_idx, distract_y_idx, distract_ori_idx).image;

            assert( ~any(distract_image(:) & target_image(:) ) );

            new_image = new_image + distract_image * distractContrast;

            
            x_dist_pix_signed = xs(distract_x_idx)-xs(target_x_idx);
            
            dist_sign = sign(x_dist_pix_signed);               
            x_dist_pix = abs(x_dist_pix_signed);
        end
        
        
        if addNoise % add random gaussian noises
            noiseImage = qRandSample(noiseSamples.noiseList, noiseSamples.noiseSize);

            if filterNoise
                idx_mask_use = mod(sample_idx-1, nMasks)+1; %
%                 noiseMasks{idx_mask_use} = noiseMasks{idx_mask_use};
                
                if ~isempty( noiseMasks{idx_mask_use} )
                    noiseImage = ifft2( noiseMasks{idx_mask_use} .* fft2(noiseImage), 'symmetric');
                end
                
                if showFourierMask && sample_idx < 2
                    %%
                    figure(65); subplot(1,2,2);
                    imagesc(new_image + noiseImage); axis image;
                    drawnow;
                    3;
                end
                    
            end
            
            if 0
                %%
                 noiseImage = qRandSample(noiseSamples.noiseList, noiseSamples.noiseSize);
                    noiseImage_orig = noiseImage;
                    
%                     noiseImage = noiseImage + new_image;
                    
                    noiseMask = noiseMasks{idx_mask_use};
                    
                    noiseMask = noiseMask - min(noiseMask(:)) + .01;
                    noiseMask = fourierMaskCorrectionFactor(noiseMask) * noiseMask;
                    
                    noiseImage_filt = ifft2( noiseMask .* fft2(noiseImage), 'symmetric');
                    
                    noiseImage_filt = noiseImage_filt * 10 + new_image * signalContrast;
                    
                    invMask = 1./noiseMask;
                    invMask(noiseMask == 0) = 0;
                    invMask = invMask * fourierMaskCorrectionFactor(invMask);

                    noiseImage_recovered = ifft2( invMask .* fft2(noiseImage_filt), 'symmetric');
                    
                    letter_defiltered = ifft2( invMask .* fft2(new_image), 'symmetric');
                    
                    figure(98); clf;
                    subplot(1,6,1);
                    imagesc(noiseImage); ticksOff; colormap(gray(256));
                    colorbar('location', 'southoutside'); title('Noise')

                    subplot(1,6,2);
                    imagesc( ( fftshift(noiseMask) ) ); ticksOff;
                    colorbar('location', 'southoutside');  title('MASK ')

                    subplot(1,6,3);
                    imagesc(noiseImage_filt); ticksOff; 
                    colorbar('location', 'southoutside'); title('Filtered Noise + letter')

                    subplot(1,6,4);
                    imagesc( ( fftshift( invMask) ) ); ticksOff;
                    colorbar('location', 'southoutside');  title(' INV MASK')
                    
                    
                    subplot(1,6,5);
                    imagesc(noiseImage_recovered); ticksOff;
                    colorbar('location', 'southoutside'); title('Recovered Noise + de-filtered letter')

                    
                    subplot(1,6,6);
                    imagesc(letter_defiltered); ticksOff;
                    colorbar('location', 'southoutside'); title('de-filtered letter')
%                     caxis([-.1, .1]);
                    
                    %%
                    
                    figure(65); subplot(1,2,2);
                    imagesc(new_image + noiseImage); axis image;
                    drawnow;
                
            end
            
            allNoiseImageVars(sample_idx) = var(noiseImage(:));
            noiseImage= noiseContrast * noiseImage;
            
            new_image = new_image + noiseImage;
        end
        
        
        
        if blurImage
            stim_i.nonBlurredImage = new_image;
            new_image = gaussSmooth( gaussSmooth(new_image, blurStd, 1), blurStd, 2);   
        end

        if outputTextureStatistics
                        
            switch params.textureStatsUse
                case {'V2', 'V2r'}
                    useAllStats = strcmp(params.textureStatsUse, 'V2');
                    
                    textureStatistics_struct = textureAnalysis(double(new_image), Nscl_txt, Nori_txt, Na_txt, 0);
                    if sample_idx <= 20
                        [textureStatistics_vector, idx_textureStats_use_i] = textureStruct2vec(textureStatistics_struct, [], useAllStats);
                        if isempty(idx_textureStats_use)
                            idx_textureStats_use = idx_textureStats_use_i;
                        end
                        assert(isequal(idx_textureStats_use, idx_textureStats_use_i)) % check that get the same indexing vector each time
                    else
                        textureStatistics_vector = textureStruct2vec(textureStatistics_struct, idx_textureStats_use, useAllStats);
                    end
                    stim_i.textureStats_S = textureStatistics_struct;

                case {'V1', 'V1s', 'V1c', 'V1x'}
                                    
                    [V1s, V1c, V1hp, V1lp] = getSteerDecomp_V1(double(new_image), Nscl_txt, Nori_txt);
                    switch params.textureStatsUse
                        case 'V1s', textureStatistics_vector = V1c;
                        case 'V1c', textureStatistics_vector = V1s;
                        case 'V1',  textureStatistics_vector = [V1s; V1c];
                        case 'V1x', textureStatistics_vector = [V1s; V1c; V1hp; V1lp];
                    end
            end
                
            stim_i.textureStats = single( textureStatistics_vector );
            
        end
        
        show = 0;
        if show
            %%
            figure(21); clf;
%             subplot(1,2,1);
%             imagesc(signal_i.image); axis equal tight;
%             title(sprintf('Sample %d', sample_idx));
% 
%             subplot(1,2,2);
            imagesc(new_image); axis equal tight;
            colormap('gray');
%             imageToScale;
            3;
        end
   
        stim_i.image  = single( new_image );
        stim_i.targetLetter_idx = single(targetLetter_idx);
        stim_i.target_x_idx = single( target_x_idx     );
        stim_i.target_y_idx = single( target_y_idx     );
        stim_i.target_ori_idx = single( target_ori_idx  );
                
        if nDistractors > 0    
            stim_i.distractLetter_idx=distract_let_idx(1);
            stim_i.x_dist = distractorSpacing;
            stim_i.x_dist_pix = x_dist_pix;
            stim_i.dist_sign = dist_sign;
        end
        if nDistractors > 1
            stim_i.distractLetter2_idx=distract_let_idx(2);
        end
        
        if sample_idx == 1
            allStims(setSize) = blankStruct(stim_i); %#ok<AGROW>
        end
        allStims(sample_idx) = stim_i; %#ok<AGROW>
        
        
        
        if doProgressBar
            progressBar(sample_idx);
        elseif mod(sample_idx, step) == 0 %#ok<*UNRCH>
            fprintf('.');
        end
        
    end
    
    if doProgressBar
        progressBar('done');
    else 
        fprintf(' done. '); toc;
    end
     
    letterSet.inputMatrix  = single( cat(3, allStims.image) );
    
    if outputTextureStatistics
        letterSet.textureStats = single( cat(3, allStims.textureStats) );
        if isfield(allStims(1), 'textureStats_S')
            letterSet.textureStats_S = cat(1, allStims.textureStats_S);
        end
    end
    
    letterSet.labels        = single( [allStims.targetLetter_idx] );
    letterSet.targetX_idx   = single( [allStims.target_x_idx] );
    letterSet.targetY_idx   = single( [allStims.target_y_idx] );
    letterSet.targetOri_idx = single( [allStims.target_ori_idx] );
    
    
    if nDistractors > 0    
        letterSet.labels_distract = single( [allStims.distractLetter_idx] );
        if nDistractors > 1
            letterSet.labels_distract2 = single( [allStims.distractLetter2_idx] );
        end
        
        letterSet.x_dist = [allStims.x_dist];
        letterSet.dist_sign = [allStims.dist_sign];
    end
        
    
    if blurImage
        letterSet.nonBlurredImages = single( cat(3, allStims.nonBlurredImage));
    end
    
%     fprintf('%s\n', char('A' -1 + letterSet.labels(1:10)))
    letterSet.fontSize=params.fontSize;
    letterSet.fontName=params.fontName;

    letterSet.xs=params.xs;
    letterSet.ys=params.ys;
    letterSet.orientations = params.orientations;
    letterSet.nLetters=nLetters;
    letterSet.all_f_exp = all_f_exp;

end



    
    %{
    
        if filterNoise
        filtType = params.noiseFilter.filterType;
        whiteMask = ones(imageSize);
        
        if any(strcmp(filtType, {'band', 'lo', 'hi'}))
            %%
            cycPerPix_range = params.noiseFilter.cycPerPix_range;
            mask_fftshifted = fourierMask(imageSize, cycPerPix_range, 'band_cycPerPix', params);
            bandMask = ifftshift(mask_fftshifted);
            noiseMasks{1} = bandMask;
                        
            
        elseif ~isempty(strfind(filtType, '1/f'))
            f_exp = params.noiseFilter.f_exp;
            f_exp_std = params.noiseFilter.f_exp_std;
            
%             if f_exp_std > 0
%                 nMasks = 1000;
%                 noiseMasks = cell(1,nMasks);
%                 all_f_exp = f_exp + randn(1,nMasks)*f_exp_std;
%                 for mask_i = 1:nMasks
%                     mask_fftshifted = fourierMask(imageSize, all_f_exp(mask_i), '1/f', params);
%                     pinkMask = ifftshift(mask_fftshifted);
%                     
%                 end
%                 
%                 
%             else
                nMasks = 1;
                mask_fftshifted = fourierMask(imageSize, f_exp, '1/f', params);
                pinkMask = ifftshift(mask_fftshifted);
%             end
                        

            switch filtType
                case '1/f', 
                    noiseMasks{1} = pinkMask;
                    
                case '1/fOwhite',
                    
                    noiseMasks{1} = pinkMask;
                    noiseMasks{2} = [];
                    
                case '1/fPwhite'
                    
                    maskSum = pinkMask + whiteMask;
                    maskSum = maskSum * fourierMaskCorrectionFactor(maskSum);
                    noiseMasks{1} = maskSum;
                    
            end
                
                
%                         allPinkPlusWhiteNoiseFilters = arrayfun(@(f) struct('filterType', '1/fPwhite', 'f_exp', f), allF_exps, 'un', 0);
%         allPinkOrWhiteNoiseFilters = arrayfun(@(f) struct('filterType',   '1/fOwhite', 'f_exp', f), allF_exps, 'un', 0);

                
        end    
        letterSet.fourierMask = mask_fftshifted;
        
        if showFourierMask
            %%
            figure(65); clf; subplot(1,2,1);
            imagesc(mask_fftshifted); axis image;
            colormap('gray');
            if strcmp(filtType, 'band')
                title(sprintf('c/let = %.2f', params.noiseFilter.cycPerLet_centFreq))
            end
            3;
            
        end
            

        nMasks = length(noiseMasks);
        

    end
    %}