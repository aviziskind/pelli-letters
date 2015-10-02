function noisySet = generateSetOfNoisyLetters(signal, params)
  
%     logEOverN = params.logEOverN;
    [nLetters, nOris, nX, nY] = size(signal);
    noisySet.signal=signal;
    xs = params.xs;
    ys = params.ys;
    orientations = params.orientations;
    setSize = params.setSize;

    
    signalContrast = 1;

    addNoise = isfield(params, 'logSNR') && ~isnan(params.logSNR) && ~isinf(params.logSNR);
    if addNoise
        logSNR = params.logSNR;
    
        [signalContrast, noiseContrast, logE, logN] = getSignalNoiseContrast(logSNR, params);
        noisySet.logE = logE;
        noisySet.logN = logN;
        noisySet.logEOverN = logE - logN;
        assert(logE-logN == logSNR);
        noisySet.noiseContrast=noiseContrast;
        
        noiseSamples = params.noise;        
    end

    noisySet.signalContrast = signalContrast;

    
    
    outputTextureStatistics = isfield(params, 'doTextureStatistics') && params.doTextureStatistics == 1;
    if outputTextureStatistics
        Nscl = params.textureStatsParams.Nscl_txt;
        Nori = params.textureStatsParams.Nori_txt;
        Na = params.textureStatsParams.Na_txt;
    end
    
    
    allStims = struct;
    doProgressBar = 1;
    fprintf('Generating Noisy Letter Set : ');
    if doProgressBar
        progressBar('init-', setSize, 40);
    else 
        tic;
        nPBars = 30; step = round(setSize/nPBars);
    end
    
    blurImage = isfield(params, 'blurStd') && params.blurStd > 0;
    if blurImage
        blurStd = params.blurStd;
    end
    
    filterNoise = isfield(params, 'noiseFilter') && ~isempty(params.noiseFilter);
    if filterNoise
        switch params.noiseFilter.filterType
            case 'band',
                cycPerPix_range = params.noiseFilter.cycPerPix_range;
                imageSize = size(signal(1).image);
                [mask_shifted, gain_factor] = fourierMask(imageSize, cycPerPix_range, 'cycPerPix');
                mask = ifftshift(mask_shifted);
                
        end
        
    end
    
    
    for sample_idx=1:setSize
        noiseImage_raw=RandSample(noiseSamples.noiseList,noiseSamples.noiseSize);

        if filterNoise
            noiseImage_raw = ifft2( mask .* fft2(noiseImage_raw), 'symmetric') * gain_factor;
        end
        noiseImage=noiseContrast*noiseImage_raw;
        

        letter_idx=randi(nLetters);
        xpos_idx=randi(nX);
        ypos_idx=randi(nY);
        ori_idx=randi(nOris);
        curSignal=noisySet.signal(letter_idx,ori_idx,xpos_idx,ypos_idx).image;
        
        curImage = noiseImage + curSignal;        
        
        if blurImage
            nonBlurredImage = curImage;
            curImage = gaussSmooth( gaussSmooth(curImage, blurStd, 1), blurStd, 2);            
            allStims(sample_idx).nonBlurredImage=nonBlurredImage;
        end
        
        
        allStims(sample_idx).image=curImage;
        
        show = 0;
        if show
            figure(11); 
            imagesc(curImage); colormap('gray'); axis equal tight;
            3;
            
        end
        
        if outputTextureStatistics
            textureStatistics_struct = textureAnalysis(double(curImage), Nscl, Nori, Na, 0);
            [textureStatistics_vector, idx_removed] = struct2vec(textureStatistics_struct, 1);            
            assert(isequal(params.idx_textureStat_removed, idx_removed));
            allStims(sample_idx).textureStats = textureStatistics_vector;
            allStims(sample_idx).textureStats_S = textureStatistics_struct;
        end
        
        allStims(sample_idx).letter_idx=letter_idx;
        allStims(sample_idx).orientation=orientations(ori_idx);
        allStims(sample_idx).ori_idx=ori_idx;
        allStims(sample_idx).x=xs(xpos_idx);
        allStims(sample_idx).xpos_idx=xpos_idx;
        allStims(sample_idx).y=ys(ypos_idx);
        allStims(sample_idx).ypos_idx=ypos_idx;
        
        
        if doProgressBar
            progressBar(sample_idx);
        elseif mod(sample_idx, step) == 0 %#ok<*UNRCH>
            fprintf('.');
        end
    end
    
    
    noisySet.fontSize=params.fontSize;
    noisySet.fontName=params.fontName;

    noisySet.orientations=orientations;
    noisySet.xs=xs;
    noisySet.ys=ys;
    noisySet.nLetters=nLetters;

    %%

    noisySet.inputMatrix  = single( cat(3, allStims.image) );
    
    if outputTextureStatistics
        noisySet.textureStats = single( cat(3, allStims.textureStats) );
        noisySet.textureStats_S = cat(1, allStims.textureStats_S);
    end
    
    noisySet.labels       = single( [allStims.letter_idx] );
    noisySet.inputOri_idx = single( [allStims.ori_idx] );
    noisySet.inputX_idx   = single( [allStims.xpos_idx] );
    noisySet.inputY_idx   = single( [allStims.ypos_idx] );
    
    if blurImage
        noisySet.nonBlurredImages = single( cat(3, allStims.nonBlurredImage));
    end
    
    if doProgressBar
        progressBar('done');
    else
        fprintf('done. '); toc;
    end

    3;
    
end

