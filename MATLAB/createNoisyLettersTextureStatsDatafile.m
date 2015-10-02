function createNoisyLettersTextureStatsDatafile(fontName, fontSize, imageHeight, Nscl, Nori, Na, Na_sub, blurStd, textureStatsUse, noiseFilter, set_idx)

%     allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'BookmanB', 'BookmanU', 'Georgia', 'Yung', 'Kuenstler'};
    % pelli complexity:    28,            65         67          100,       107         57          139                        199       451  

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   unrotated   rot 5,     rot 10    rot 15   rot 20 
%     defaultFontSize.Braille      =  9; % 20 x 29.  29 x 21,  31 x 23,  31 x 25,  33 x 27.   C0 = 27  C2 = 28
%     defaultFontSize.Sloan        = 16; % 28 x 29.  29 x 31,  31 x 31,  33 x 33,  35 x 35.   C0 = 42  C2 = 43
%     defaultFontSize.Helvetica    = 20; % 33 x 25.  33 x 25,  35 x 27,  35 x 29,  35 x 29.   C0 = 49  C2 = 55
%     defaultFontSize.Bookman      = 18; % 32 x 30.  31 x 31,  32 x 31,  33 x 31,  33 x 33.   C0 = 55  C2 = 63
%     defaultFontSize.GeorgiaU = 16; % 26 x 31.  27 x 33,  28 x 33,  30 x 35,  32 x 37.   C0 = 59  C2 = 85
%     defaultFontSize.Courier      = 21; % 32 x 24.  32 x 25,  32 x 25,  34 x 29,  34 x 31.   C0 = 78  C2 = 121
%     defaultFontSize.Yung         = 21; % 32 x 32.  32 x 32,  33 x 32,  34 x 34,  34 x 34.   C0 = 78  C2 = 114
%     defaultFontSize.Kuenstler    = 14; % 24 x 33.  25 x 33,  27 x 35,  30 x 36,  32 x 37.   C0 = 83  C2 = 286
    testMode = 0;
    
    precision = 'single'; precision_func = @single;

    skipIfFilesAlreadyPresent = 1;
    skipIfFilesNotPresent = 1;
    
%     blurStd = 1;
    
    if (nargin < 1) 
%          fontNames = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'Yung', 'KuenstlerU'};
%         fontNames = {'KuenstlerU'};
        fontNames = {'Bookman'};
%         fontNames = {'Sloan', 'Helvetica', 'Courier', 'Bookman', 'Yung', 'KuenstlerU'};
%         fontNames = {'Yung', 'KuenstlerU'};
%         allFontSizes = {'med'}; % 'k18'
%         allFontSizes = {'k60'}; % 'k18'
        allFontSizes = {'k40'}; % 'k18'
%         allFontSizes = {'k38'}; % 'k18'
%         allNScales = {1,2,3};
        allNScales = {3};
        allNOrientations = {4}; %3,4};
        allNa = {5}; %5};
%         allNa_sub = {0,1,3,5,7,9};
        allNa_sub = {[]};
        allImageSizes = {64};
        allBlurStd = {0};
        
%         allStatsUse = {'V1', 'V1x', 'V2', 'V2r'};
        allTextureStatsUse = {'V2'};

        
%         allCycPerLet = [0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13, 20.7];
        allCycPerLet =  [0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.45, 16];
        
%         allCycPerLet= [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];
        allF_exps = [1, 1.5, 2];
        allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f), allCycPerLet, 'un', 0);
        allPinkNoiseFilters = arrayfun(@(f) struct('filterType', '1/f', 'f_exp', f), allF_exps, 'un', 0);
        whiteNoiseFilter = {struct('filterType', 'white')};

        allNoiseFilters = [allPinkNoiseFilters, allBandNoiseFilters, whiteNoiseFilter];
%         allNoiseFilters = whiteNoiseFilter;
        
%         allBlurStd = {0, 1, 2, 3};
        %%
        allSetsToDo = expandOptionsToList( struct( 'tbl_Nscl', {allNScales}, ...
                                                   'tbl_Nori', {allNOrientations}, ...
                                                   'tbl_Na', {allNa}, ...
                                                   'tbl_Na_sub', {allNa_sub}, ...
                                                   'tbl_imageSize', {allImageSizes}, ...
                                                   'tbl_fontSize', {allFontSizes}, ...
                                                   'tbl_blurStd', {allBlurStd}, ...
                                                   'tbl_fontName', {fontNames}, ...
                                                   'tbl_textureStatsUse', {allTextureStatsUse}, ...
                                                   'tbl_noiseFilter', {allNoiseFilters} ...
                                                ) );
          %%         
%         allSetsToDo = struct('imageSize', 64, 'Nscl', 2, 'Nori', 3, 'Na', 5,  'maxNIter', maxNIter);

%         allSetsToDo = fliplr(allSetsToDo);
        setsToDoIdx = 1:length(allSetsToDo);
        
%         setsToDoIdx = fliplr(setsToDoIdx);

        for set_idx = setsToDoIdx
            set_i = allSetsToDo(set_idx);
            Na_sub_str = iff(~isempty(set_i.Na_sub), sprintf('[(Na_sub = %d)]',set_i.Na_sub), ' ');
            [filter_str] = filterStr( set_i.noiseFilter, 1 ); 
%             [fontName, fontSz, imageSiz, Nsc, Nor, Na] = dset_i.fontSize
            fprintf('\n\n======= Set %d/%d === [font = %s, size %s, image %dx%d. Nscl = %d, Nor = %d, Na = %d %s blur = %d  [%s] [Noise=%s] ======= \n', ...
                set_idx, length(allSetsToDo), set_i.fontName, set_i.fontSize, set_i.imageSize*[1, 1], set_i.Nscl, set_i.Nori, set_i.Na, Na_sub_str,    set_i.blurStd, set_i.textureStatsUse, filter_str);
            createNoisyLettersStatsDatafile(  set_i.fontName, set_i.fontSize, set_i.imageSize,        set_i.Nscl, set_i.Nori, set_i.Na, set_i.Na_sub, set_i.blurStd, set_i.textureStatsUse, set_i.noiseFilter, set_idx);
            3;
        end
        return;
    end
    
    
%     fontSize = getFontSize(fontName, fontSizeStyle);

    if nargin < 2
        imageHeight = 32;
    end
    imageWidth = imageHeight;
    imagePadding = ceil(imageHeight/10);
    imagePadding = 4;
    
        
    
    signalContrast = 1;
    logEstimatedEOverNIdealThreshold = -1;
    background = 0;
    pixPerDeg = 1;
    setSize = 10000;
    
    if strncmp(textureStatsUse, 'V1', 2)
        setSize = 2000;
    end
    
%     imageHeight = 64;
    
%     fontSize = 36;  % 64x64
%     fontSize = 18;  % 32x32
      
        
    noisyLettersStatsPath = [datasetsPath 'NoisyLettersStats' filesep]; % 'sz32x32' filesep];
    noisyLettersStatsPath_thisFont = [noisyLettersStatsPath fontName filesep];
    if ~exist(noisyLettersStatsPath_thisFont, 'dir')
        mkdir(noisyLettersStatsPath_thisFont)
    end
    
    A_offset = 'A' - 1;

    % % %     defaultFontSize.Georgia = 10;   % 17 x 21. C0 = 42. C2 = 86
    
%     setSize_approx = 2000;

    
    if ~exist('fontSize', 'var') || isempty(fontSize)
        error('please provide font')
    
        boxHW = max(fontData.boxW, fontData.boxH);
        fontSize_idx = find(boxHW <= imageHeight-imagePadding, 1, 'last');
        fontSize = fontData.sizes(fontSize_idx);
    else
        if ischar(fontSize), 
            sizeStyle = fontSize;
            fontSize = getFontSize(fontName, sizeStyle);
        else
            sizeStyle = fontSize;
        end
        
    end
    
    [allLetters, fontData] = loadLetters(fontName, fontSize);
    fontHeight = fontData.k_height;    
    
    let_idxs_use = [1:26];
    if testMode
%         let_idxs_use = [1:2];
        let_idxs_use = [1:1];
        allLetters = allLetters(:,:,let_idxs_use);
        setSize_approx = length(let_idxs_use)*5;
    end
%     allLetters(:,end+1,:) = 0;
    
    allLetters_orig = allLetters;
    allLetters = addMarginToPow2(allLetters, 0);
    
    orientations = 0;
    xs = 0;
    ys = 0;
    
%     h_let = size(allLetters,1);
    
    maxNScales = floor(log2(imageWidth)) - 2;
            
    nLetters = size(allLetters, 3);
%%    
    if nargin < 4 || isempty(Nscl)
        Nscl = 4; % Number of scales
    end
    if nargin < 5 || isempty(Nori)
        Nori = 4; % Number of orientations
    end
    if nargin < 6 || isempty(Na)
        Na = 9;  % Spatial neighborhood is Na x Na coefficients
    end          % It must be an odd number!
              
    

    if strcmp(noiseFilter.filterType, 'band');
%         noiseFilter = struct('filterType', 'band', 'cycPerLet_centFreq', cycPerLet_centFreq, 'cycPerLet_range', filterBand_cycPerPix_range, 'cycPerPix_range', filterBand_cycPerPix_range);
        filterBand_cycPerLet_range = noiseFilter.cycPerLet_centFreq * [1/sqrt(2), sqrt(2)];
        filterBand_cycPerPix_range = filterBand_cycPerLet_range / fontHeight;

        noiseFilter.cycPerPix_range = filterBand_cycPerPix_range;
    end
    
%     switch noiseFilterType
%         case 'white',             
% %             noiseFilter = struct('filterType', 'white');
%         case 'band',  
%             cycPerLet_centFreq = noiseFilter.cycPerLet_centFreq;
%             if ~isnan(cycPerLet_centFreq)
% 
%                 noiseFilter = struct('filterType', 'band', 'cycPerLet_centFreq', cycPerLet_centFreq, 'cycPerLet_range', filterBand_cycPerPix_range, 'cycPerPix_range', filterBand_cycPerPix_range);
%             end
%         case '1/f', 
% %             noiseFilter = struct('filterType', '1/f', 'f_exp', noiseFilterArg{2});
%         case 'low',
%         case 'high',
%         otherwise,
%             error('Unknown filterType : %s\n', noiseFilterType);
%     end

    
    assert(Nscl <= maxNScales)
    
    textureStatsParams_allA = struct('imageSize', imageHeight, 'fontSize', sizeStyle, 'textureStatsUse', textureStatsUse, ...
        'Nscl_txt', Nscl, 'Nori_txt', Nori, 'Na_txt', Na, 'noiseFilter', noiseFilter, ...
        'blurStd', blurStd, 'tf_test', testMode);
    
    textureStatsParams_subA = textureStatsParams_allA;
    textureStatsParams_subA.Na_sub_txt = Na_sub;
    
    

    
%     all_SNRs = [0,   1,  1.5,  2,   3,   3.5,     4,  4.5,   5];

%     all_SNRs = [1:5];
%     all_SNRs = [0, 1, 2, 2.5, 3, 4, 5];
    
%     if any(strcmp(noiseFilter.filterType, {'band', '1/f'}))
        all_SNRs = [-1, 0, 1, 2, 3, 4, 5];
        
        all_SNRs = fliplr(all_SNRs);
%     end
%     all_SNRs = [3];
    all_SNRs_toDo = all_SNRs;

    if skipIfFilesAlreadyPresent 
       
        haveFiles = false(1, length(all_SNRs));
        haveFiles_full = false(1, length(all_SNRs));
        for si = 1:length(all_SNRs)
            filename_sub{si} = getNoisyLettersTextureStatsFileName(fontName, all_SNRs(si), textureStatsParams_subA);
            haveFiles(si) = exist([noisyLettersStatsPath_thisFont  filename_sub{si}], 'file');
            
            if ~isempty(Na_sub)
                filename_full = getNoisyLettersTextureStatsFileName(fontName, all_SNRs(si), textureStatsParams_allA);
                haveFiles_full(si) = exist([noisyLettersStatsPath_thisFont  filename_full], 'file');
            end
                        
        end
        
        if all(haveFiles)
            fprintf('Already have all files for this set: [eg: %s]\n', filename_sub{1})
            return;
        end

        all_SNRs_toDo = all_SNRs_toDo(~haveFiles);
    end
    
    
    
        
    %%
%     textureStatistics = [];

    letter_params = struct('pixPerDeg', 1, 'imageHeight', imageHeight, 'imageWidth', imageWidth, 'horizPosition', 'centered', 'vertPosition', 'centered');
    signal = generateLetterSignals(allLetters, xs, ys, orientations, letter_params);
    idx_textureStats_use = [];
    for i = 1:numel(signal)
        %%
        image_i = double(signal(i).image);
        switch textureStatsUse
            case {'V2', 'V2r'}
                useAllStats = strcmp(textureStatsUse, 'V2');
        
                signal(i).textureStats_S = textureAnalysis(image_i, Nscl, Nori, Na, 0); 
        
                [textureStats_vec, idx_textureStats_use_i] = textureStruct2vec( signal(i).textureStats_S, [], useAllStats);
                
                
                if isempty(idx_textureStats_use)
                    idx_textureStats_use = idx_textureStats_use_i;
                else
                    assert(isequal(idx_textureStats_use_i, idx_textureStats_use_i));
                end

            case {'V1', 'V1s', 'V1c', 'V1x'}
                
                [V1s, V1c, V1hp, V1lp] = getSteerDecomp_V1(image_i, Nscl, Nori);
                switch textureStatsUse
                    case 'V1s', textureStats_vec = V1c;
                    case 'V1c', textureStats_vec = V1s;
                    case 'V1',  textureStats_vec = [V1s; V1c];
                    case 'V1x',  textureStats_vec = [V1s; V1c; V1hp; V1lp];
                end
        end
        signal(i).textureStats = single(textureStats_vec);
                
        if any(isnan(signal(i).textureStats))
            error('NaN!')
        end
    end
    %%
    logE1=log10([signal(:).E1]);

    rand_seed = 0; %mod(fontSize * sum(fontName) * (imageHeight*imageWidth) * (Dx+1) *(Dy+1) * (nOris+1), 2^32);
        
    noiseType = 'gaussian';
    nNoiseSamples = 1e5;
    
    noiseSamples = generateNoiseSamples(nNoiseSamples, noiseType, rand_seed);
    noiseSamples.noiseSize=[imageHeight,imageWidth];
%     all_SNRs = [3];
    nRows = length(all_SNRs);

    params.signalContrast = signalContrast;
    params.logEstimatedEOverNIdealThreshold = logEstimatedEOverNIdealThreshold;
    params.background = background;
    params.pixPerDeg = pixPerDeg;
    params.setSize = setSize;
    params.noiseSamples = noiseSamples;
    params.logE1 = logE1;
    
    params.orientations = orientations;
    params.xs = xs;
    params.ys = ys;
    params.fontSize = fontSize;
    params.fontName = fontName;
    
    params.textureStatsParams = textureStatsParams_subA;
    params.idx_textureStats_use = idx_textureStats_use;
    params.doTextureStatistics = true;
    params.blurStd = blurStd;
    params.textureStatsUse = textureStatsUse;
    params.noiseFilter = noiseFilter;
    
    global w_best_use
    w = w_best_use;
    
    for cond_i = 1:length(all_SNRs_toDo)
        logSNR = all_SNRs_toDo(cond_i);
        fprintf('======= Now computing set #%d [logSNR = %.2f] ==\n', cond_i, logSNR);


        filename = getNoisyLettersTextureStatsFileName(fontName, logSNR, textureStatsParams_subA);
                        
       
        if ~isempty(Na_sub) && ~haveFiles(cond_i) && haveFiles_full(cond_i)

            %%
            filename_sub = getNoisyLettersTextureStatsFileName(fontName, all_SNRs(cond_i), textureStatsParams_subA);
            filename_full = getNoisyLettersTextureStatsFileName(fontName, all_SNRs(cond_i), textureStatsParams_allA);
            %%
            S_full = load([noisyLettersStatsPath_thisFont filename_full]);
    %                 idx_textStat_use = textureStatsIdx_a_range(Nscl, Nori, Na, Na_sub);
            tf_textStat_use = false(1, nTextureStatisticsForParams(Nscl, Nori, Na));
            idx_textStat_use_thisA = textureStatsIdx_a_range(Nscl, Nori, Na, Na_sub);

            tf_textStat_use(idx_textStat_use_thisA) = true;

            tf_textStat_use(idx_textureStats_use) = [];

            S_full.inputMatrix = S_full.inputMatrix(tf_textStat_use, :,:);
            S_full.signalMatrix = S_full.signalMatrix(tf_textStat_use, :,:);

            fprintf('From the original vector of %d statistics, using %d \n', length(tf_textStat_use), nnz(tf_textStat_use));

            S_full = rmfield(S_full, 'propEachLetterCorrect_ideal_image');
            S_full = rmfield(S_full, 'propEachLetterCorrect_ideal_texture');

            signal_copy = signal;
            for i = 1:length(signal_copy)
                signal_copy(i).textureStats = signal(i).textureStats(tf_textStat_use);
            end

            %% get  %correct.
            noisySet_tmp = struct('signal', signal_copy, 'labels', S_full.labels, 'inputMatrix', [], 'textureStats', S_full.inputMatrix);
            propLetterCorrect_ideal_texture = calcIdealPerformanceForNoisySet(noisySet_tmp, struct('test', 'textureStats',  'norm', 'normStd'));
            
            S_full.propLetterCorrect_ideal_texture = propLetterCorrect_ideal_texture;
%%
            fprintf('   => Saving Noisy Image data to file %s \n', filename)
            save([noisyLettersStatsPath_thisFont  filename], '-struct', 'S_full', '-v6');
            continue;

        end

        params.logSNR = logSNR;
        noisySet = generateSetOfLetters(signal, params);
        3;
%         noisySet.origImages = noisySet.inputMatrix;
%         noisySet.inputMatrix = noisySet.textureStats;
%         profile viewer;
        3;
        
        

        addPCAcomp = 1;
        nComps = 3;
        noisySet_copy = noisySet;
        %%
        [ss.propLetterCorrect_ideal_image, ss.propEachLetterCorrect_ideal_image, ~,~, ss.idealLabels_image] = calcIdealPerformanceForNoisySet(noisySet);
        [ss.propLetterCorrect_ideal_texture_unnorm, ss.propEachLetterCorrect_ideal_texture_unnorm, ~,~, ss.idealLabels_texture_norm] = calcIdealPerformanceForNoisySet(noisySet, struct('test', 'textureStats'));
        [ss.propLetterCorrect_ideal_texture,        ss.propEachLetterCorrect_ideal_texture,        ~,~, ss.idealLabels_texture     ] = calcIdealPerformanceForNoisySet(noisySet, struct('test', 'textureStats', 'norm', 'std'));
%         [ss.propLetterCorrect_ideal_texture_cov,    ss.propEachLetterCorrect_ideal_texture_cov,    ~,~, ss.idealLabels_texture_cov ] = calcIdealPerformanceForNoisySet(noisySet, 'struct('test', 'textureStats', 'norm', 'cov');
%%
        noisySet = mergeStructs(noisySet, ss);
        
%         profile on
        findW = 0;
        if findW
            [w, pCorrVsNw, w_best_history] = getBestWeightVector(noisySet);
        
            [noisySet.propLetterCorrect_ideal_texture_best, ~,~,~, noisySet.idealLabels_texture_best] = calcIdealPerformanceForNoisySet(noisySet, 'textureStats', w);
            noisySet.bestW = w;
            noisySet.pCorrVsNw = pCorrVsNw;
            noisySet.bestW_history = w_best_history;
        end
        
        addPCAcomp = 0;
        if addPCAcomp 
            fprintf('Adding PCA components to Set ...');
            noisySet = addPCAtoSet(noisySet, nComps);
            fprintf('done\n');
%             noisySet = addPCAtoSet(noisySet, nComps);
        end
         
        fprintf('Set %d. logSNR %5.2f, logEOverN %5.2f, signalContrast %.2f, noiseContrast %.3f\n', ...
            cond_i, logSNR, noisySet.logEOverN, noisySet.signalContrast,noisySet.noiseContrast);

        
%       3;

        allNoisySets{cond_i} = noisySet;

        labels = [noisySet.labels];

    
        createStatFiles = 1;
        if createStatFiles % && all_SNRs_toDo_im(cond_i)
            %%
            
            setToSave = struct('fontName', fontName, 'fontSize', fontSize, 'fontSizeStyle', fontSize, 'date', datestr(now), ...
                'inputMatrix', [], 'labels', labels, 'signalMatrix', [], 'propLetterCorrect_ideal', [], ...
                'nClasses', nLetters, 'height', imageHeight, 'width', imageWidth, ...
                'orientations', orientations, 'xs', xs, 'ys', ys, 'imageSize', [imageHeight, imageWidth]); ...
                ...'complexity_bool_mean', complexity_bool_mean, 'complexity_bool_all', complexity_bool_all, ...
                ...'complexity_grey_mean', complexity_grey_mean, 'complexity_grey_all', complexity_grey_all);

            setToSave.inputMatrix = noisySet.textureStats;  %%%% ** instead of inputMatrix *** 
            setToSave.propLetterCorrect_ideal_image      = noisySet.propLetterCorrect_ideal_image;        
            setToSave.propLetterCorrect_ideal_texture    = noisySet.propLetterCorrect_ideal_texture;        
            setToSave.propEachLetterCorrect_ideal_image  = noisySet.propEachLetterCorrect_ideal_image;        
            setToSave.propEachLetterCorrect_ideal_texture= noisySet.propEachLetterCorrect_ideal_texture;        
            setToSave.signalMatrix = cat(3, signal.textureStats);
            setToSave.logEOverNReIdeal = logSNR;
            setToSave.logEOverN = noisySet.logEOverN;
            setToSave.logE = noisySet.logE;
            setToSave.logN = noisySet.logN;
            setToSave.logE1 = params.logE1;
            setToSave.signalContrast = noisySet.signalContrast; 
            setToSave.noiseContrast = noisySet.noiseContrast;
            

%%
            
            %%
            fprintf('   => Saving Noisy Image data to file %s \n', filename)
            save([noisyLettersStatsPath_thisFont  filename], '-struct', 'setToSave', '-v6');
        end
%         return
                
        
        showSamplesWithNoise = 0;
        if showSamplesWithNoise && createStatFiles %&& all_SNRs_done_im(cond_i)
            % Show the stimulus, signal, and stimulus minus signal, which should be just noise. One for each noisySet. 
            fig_id = set_idx*100 + font_loc_idx;
            
            figure(fig_id);
            if cond_i == 1
                clf
            end
            fig=1+3*(cond_i-1);
            rows=nRows;
            snImage=noisySet.stimulus(1).image;
            h_ax(cond_i) = subplot(rows,3,fig,'align'); imagesc(snImage); xlabel(filename_stat, 'interp', 'none'); axis equal tight; %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
            which=noisySet.stimulus(1).whichSignal;
            whichOrientation=noisySet.stimulus(1).whichOrientation;
            whichX=noisySet.stimulus(1).whichX;
            whichY=noisySet.stimulus(1).whichY;
            sImage=noisySet.signal(which,whichOrientation,whichX,whichY).image;
            subplot(rows,3,fig+1,'align'); imagesc(sImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
            nImage=snImage-sImage;
            subplot(rows,3,fig+2,'align'); imagesc(nImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
%             energy=sum(sum((sImage-1).^2));
%             noiseLevel=var(nImage(:));
            caxis auto
            colormap('gray')
%         fprintf('cond %d, log E/N nominal %.2f, actual %.2f\n',cond,set.logEOverN,log10(energy/noiseLevel));
        end


        
    end
    
    
    showAtEnd = 0;
    if showAtEnd 
       %% 
        noisySets = [allNoisySets{:}];
    
        pctCorr_img = [noisySets.propLetterCorrect_ideal_image];
        pctCorr_txt = [noisySets.propLetterCorrect_ideal_texture];
        pctCorr_txt_unnorm = [noisySets.propLetterCorrect_ideal_texture_unnorm];
    
        figure(41); clf; hold on; box on;
        plot(all_SNRs, pctCorr_img*100, 'bo-')
        plot(all_SNRs, pctCorr_txt_unnorm*100, 'k*-')
        plot(all_SNRs, pctCorr_txt*100, 'rs-')
  
        xlabel('log SNR');
        ylabel('% Correct');
        legend('Ideal (image)', 'Ideal (unnormalized)',  'Ideal (normalized)', 'location', 'SE')
        
        %%
        figure(42); clf; hold on; box on;
        for i = 1:length(noisySets)
            plot(noisySets(i).pCorrVsNw, [color_s(i) 'o-']);
        end
        
        
    end
    
    if showAtEnd

        %%
        offset = 'A'-1;
        nClasses = 26;
        colrs = jet(nClasses);
        for si = 1:length(all_SNRs)
            %%
            figure(55+si); clf; 
            noisySet = allNoisySets{si};
            tmp_scores = double( noisySet.templateTextureScores );
            noisy_scores = noisySet.noisyTextureScores;

            subplot(1,2,1); hold on; box on;
            for ci = 1:nClasses
                idx = noisySet.labels== ci;
                plot(noisy_scores(idx,1), noisy_scores(idx,2), ['.'], 'color', colrs(ci,:)); 
            end
            
            for ci = 1:nClasses
                text(tmp_scores(ci,1), tmp_scores(ci,2), char(offset+ci), 'horiz', 'center', 'vert', 'middle', 'fontweight', 'bold', 'color', 'k', 'fontsize', 13);
                text(tmp_scores(ci,1), tmp_scores(ci,2), char(offset+ci), 'horiz', 'center', 'vert', 'middle', 'fontweight', 'bold', 'color', 'w', 'fontsize', 10);
            end
            %%
%             plot(tmp_scores(:,1), tmp_scores(:,2), 'ko', 'linewidth', 1);
        
            axis square;
            xlabel('PCA #1'); ylabel('PCA #2');
            title(sprintf('SNR = 10^{%d}. Ideal: %.1f%% correct', all_SNRs(si), noisySet.propLetterCorrect_ideal_texture*100)); %            
%             %%
            nExamples = 2;
            nMetamersPerExample = 2;
            subM = nExamples; subN = 2*(nMetamersPerExample+1);
            idx_errs = find(noisySet.labels ~= noisySet.idealLabels_texture);
            nExamples = min(nExamples, length(idx_errs));
            for ex_i = 1:nExamples
                3;
                idx = idx_errs(ex_i);
                im = noisySet.inputMatrix(:,:,idx);
                
                textStat_S = noisySet.textureStats_S(idx);
%                 textStat_S = noisySet.signal(1).textureStats_S; %noisySet.signal(1).         textureStats_S(idx);
        
                subplot(subM,subN, subN*(ex_i-1) + nMetamersPerExample + 2); imagesc(im);  colormap('gray'); axis square; set(gca, 'xtick', [], 'ytick', []);
                title(sprintf('%c', char(noisySet.labels(idx) + offset)))
                for mi = 1:nMetamersPerExample
%                     metamer_j = textureSynthesis(textStat_S, size(im), 100);
                
%                     metamer_j = createMetamer(textStat_S, size(im), mi, 1, 25);
                    
%                     subplot(subM,subN,subN*(ex_i-1) + nMetamersPerExample + 2 + mi); 
%                     imagesc(metamer_j); axis square; set(gca, 'xtick', [], 'ytick', []);
                    title(sprintf('"%c"', char(noisySet.idealLabels_texture(idx) + offset) ))
                end
3;
            end
            
        end
        
        
        keyboard;
    end

    



end



function noisySet = addPCAtoSet(noisySet, nComps, pca_name)
%%
    textureStats_templates = [noisySet.signal.textureStats]';    
    textureStats_noisy =  permute(noisySet.textureStats, [3,1,2]);
    
    if exist('w', 'var') && ~isempty(w)
        textureStats_templates = bsxfun(@times, textureStats_templates, w(:)');
        textureStats_noisy = bsxfun(@times, textureStats_noisy, w(:)');
    end
    
    
     meanNoisy = mean(textureStats_noisy,1);
     stdNoisy  =  std(textureStats_noisy, [], 1);
     stdNoisy_reg = max(stdNoisy, eps(class(textureStats_noisy)) );
     textureStats_noisy_norm = bsxfun(@rdivide, bsxfun(@minus, textureStats_noisy, meanNoisy), stdNoisy_reg);
    
    
%      useNoisyStatsForPCA = 1;

     [coeff, score] = pca(textureStats_noisy_norm, 'NumComponents', nComps);    
     
%      meanTemplateTextureStats = mean(textureStats_templates,1);
    
    
%     textureStats_noisy_ms = bsxfun(@minus, imageMtx, meanImageVec);
%     noisySet.textureScores = getPcaScore(
%     textureScore_noisy = centdata/coeff';
    
    noisyTextureScores = getPcaScore(textureStats_noisy_norm, meanNoisy, coeff);
    templateTextureScores = getPcaScore(textureStats_templates, meanNoisy, coeff);
    
%     assert(max(abs(score(:)-templateTextureScores(:))) < 1e-3);

    if nargin < 4 
        pca_name = '';
    end
    noisySet.(['templateTextureScores' pca_name]) = templateTextureScores;
    noisySet.(['noisyTextureScores' pca_name]) = noisyTextureScores;
    %%
%     textureStats_scores_cm = classMeans(noisyTextureScores, noisySet.labels);
    show = 0;
    if show 
        %%
        figure(55); clf; hold on; box on;
        cols = jet(26);
%         set(gca, 'colorOrder', );
        [uCls, cls_idx] = uniqueList(noisySet.labels);
        nClasses = length(uCls);
        for i = 1:nClasses
%         plot(score(:,1), score(:,2), 'ro');
            plot(noisyTextureScores(cls_idx{i},1), noisyTextureScores(cls_idx{i},2), '.', 'color', cols(i,:));        
        end
        for i = 1:nClasses
%             plot(textureStats_scores_cm(:,1), textureStats_scores_cm(:,2), 'ro');
        end
    end
    

    3;

end



function [w_best, pCorrVsN, w_best_history] = getBestWeightVector(noisySet)

    statTemps = [noisySet.signal.textureStats]';
    noisyStats = permute(noisySet.textureStats, [3,1,2]);
    noisyLabels = noisySet.labels;    

 %%
    nStats = size(statTemps,2);
%     [nClasses, nStats] = size(statTemps);
%     [nSamples, nStats2] = size(noisyStats);
    
    w0 = ones(nStats,1); w0 = w0/norm(w0);

    prevBestPcorr = -1;
    curBestPCorr = 0;
    
    w0_blank = zeros(nStats,1);
    w_best = w0_blank;
    
    pCorr_func = @(wgt) pctCorrectForWeights(wgt, statTemps, noisyStats, noisyLabels);
    pCorr0 = pCorr_func(w0);
    iter = 0;
    pCorrVsN = [];
    show = 0;
    if show
       figure(98); clf;  
        
    end
    w_list = [];
    w_best_history = {};
    %%
    dx = 1;
    %%
    while abs(dx) > .001
    %%
        prevBestPcorr = -1;
        while curBestPCorr > prevBestPcorr
            %%
            %%
            prevBestPcorr = curBestPCorr;
            
            N = length(w0);
            pCorrs = zeros(1,N);
            ws = cell(1,N);
            for i = 1:N
                ws{i} = w_best;
                ws{i}(i) = abs(ws{i}(i)+dx);
                pCorrs(i) =  pCorr_func(ws{i});
            end

            
            [curBestPCorr, indbest] = max(pCorrs);

            if curBestPCorr > prevBestPcorr
                w_best = ws{indbest};
                w_list = [w_list, indbest];
                w_best_history{end+1} = w_best;

            else
                curBestPCorr = prevBestPcorr;
            end

            if show
                %%
                idxs_active = find(w_best);
                plot(1:nStats, pCorrs/100, 'b-', 1:nStats, w_best/max(w_best), 'r-');
                

            %     title(sprintf('n = %d, ', idxs_active));
                title(sprintf('curBest = %.1f. n = %d [dx = %.1f]', curBestPCorr, length(idxs_active), dx));
                drawnow;
                3;
            end

            fprintf('%d. curBest = %.2f\n', iter, curBestPCorr);
            iter = iter+1;
            pCorrVsN(iter) = curBestPCorr; %#ok<AGROW>
        end
        
        dx = dx /(-1.5);
    end
    %%
%     if ~isempty(w_list)
        assert(isequal(find(w_best), unique(w_list)'));
%     end
    
%     trySearch = exist('trySearchFlag', 'var') && isequal(trySearchFlag, 1);
%     if trySearchFlag
%         w_best_search = searchForBestWeightVector(statTemps, noisyStats, noisyLabels, w_best);
        
%     end

    w_best = w_best(:).^2/ norm(w_best);
    
end
    %%

function w_best = searchForBestWeightVector(statTemps, noisyStats, noisyLabels, w_init)
    
    
    [nClasses, nStats] = size(statTemps);
    [nSamples, nStats2] = size(noisyStats);
    assert(nStats == nStats2);
    
 %%
    nStats = size(statTemps,2);
%     [nClasses, nStats] = size(statTemps);
%     [nSamples, nStats2] = size(noisyStats);
    
                
    global nIter col_idx
    nIter = 0;
    col_idx = 1;
% nRep = 100;
%     nIterPerRep = 1000;
    
    statTemps = single(statTemps);
    noisyStats = single(noisyStats);
   
    figure(87); clf; hold on;
    
    %%
%     quality_func = @(wgt) -clusterQuality(wgt, cent_cent_sqrdiffs, sample_cent_sqrdiffs);
    pCorr_func = @(wgt) pctCorrectForWeights(wgt, statTemps, noisyStats, noisyLabels);
    pCorr0 = pCorr_func(w_init);
    
    loss_func = @(wgt) lossFuncForWeights(wgt, statTemps, noisyStats, noisyLabels, pCorr_func);
    tic; l0 = loss_func(w_init); toc;
    
    options = optimset('MaxFunEvals', 1e6);
%     w0 = w_best2;
    
    %%
    [w_best, q_best] = fminsearch(loss_func, w_init, options);
    %%
    pCorr_best = pCorr_func(w_best);
    
    w_best2 = w_best(:).^2/norm(w_best);

    q_best2 = quality_func(w_best);
    3;
    
end

    
    
function w_best = getBestWeightVector2(statTemps, noisyStats, noisyLabels)
    
    %%

    [nClasses, nStats] = size(statTemps);
    [nSamples, nStats2] = size(noisyStats);
    assert(nStats == nStats2);
%%
%     sqrdiffs_ = zeros(nClasses, nSamples, nStats);
%     for ci = 1:nDists
%         for si = 1:nSamples
%             sqrdiffs(ci,si,:) = (noisyStats(si,ci) - statTemps(ci,:) )
%         end
%     
%     end
    
    cent_cent_sqrdiffs = zeros(nStats, nClasses, nClasses);
    for ci = 1:nClasses
        for cj = 1:nClasses
            cent_cent_sqrdiffs(:, ci,cj) = (statTemps(ci,:) - statTemps(cj,:) ).^2;
        end
    end
    %%
    sample_cent_sqrdiffs = zeros(nStats, nSamples);
    for si = 1:nSamples
%             idx = noisyLabels(si);
        sample_cent_sqrdiffs(:,si) = (statTemps(noisyLabels(si),:) - noisyStats(si,:) ).^2;
    end
    
    sample_cents_sqrdiffs = zeros(nStats, nSamples, nClasses);
    for si = 1:nSamples
%             idx = noisyLabels(si);
        for ci = 1:nClasses
            sample_cents_sqrdiffs(:,si,ci) = (statTemps(noisyLabels(si),:) - noisyStats(si,:) ).^2;
        end
    end
%%
    sample_correctCent_sqrdiffs = zeros(nStats, nSamples);
    sample_closestIncorrCent_sqrdiffs = zeros(nStats, nSamples);
    for si = 1:nSamples

        idx_correct = noisyLabels(si);
        dists_toCents_si = zeros(1, nClasses);        
        for cj = 1:nClasses
            dists_toCents_si(cj) = sum( (statTemps(cj,:) - noisyStats(si,:) ).^2 );            
        end
        [~, idx_sorted] = sort(dists_toCents_si, 'ascend');
        if idx_sorted(1) == idx_correct
            idx_closestIncorr = idx_sorted(2);
        else
            idx_closestIncorr = idx_sorted(1);
        end

        sample_correctCent_sqrdiffs(:,si)       = (statTemps(idx_correct,:)       - noisyStats(si,:) ).^2;
        sample_closestIncorrCent_sqrdiffs(:,si) = (statTemps(idx_closestIncorr,:) - noisyStats(si,:) ).^2;
        
    end
%%
    
    global nIter col_idx
    nIter = 0;
    col_idx = 1;
% nRep = 100;
%     nIterPerRep = 1000;
    
    statTemps = single(statTemps);
    noisyStats = single(noisyStats);
   
    figure(87); clf; hold on;
    
    %%
%     quality_func = @(wgt) -clusterQuality(wgt, cent_cent_sqrdiffs, sample_cent_sqrdiffs);

    quality_func = @(wgt) -clusterQuality(wgt, sample_closestIncorrCent_sqrdiffs, sample_correctCent_sqrdiffs, pCorr_func);
    
    tic; q0 = quality_func(w0); toc;
    
    options = optimset('MaxFunEvals', 1e6);
%     w0 = w_best2;
    
    %%
    [w_best, q_best] = fminsearch(quality_func, w0, options);
    %%
    
    w_best2 = w_best(:).^2/norm(w_best);

    q_best2 = quality_func(w_best);
    3;
    
end

