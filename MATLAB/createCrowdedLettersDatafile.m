function createCrowdedLettersDatafile(fontName, sizeStyle, imageSize, xrange, trainTargetPosition, testTargetPosition, allNDistractors, allLogDNRs, blurStd, noiseFilter, textureSettings, set_idx)

    %%
% function createCrowdedLettersDatafile(fontName, sizeStyle, xs_mode, nDistractors, targetPosition, set_idx)

%     global CPU_id
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

    
%     allLogDNRs_min = -2;
%     allLogDNRs = [-2, -1, -.75, -0.5, -0.25,  0];
%     allLogDNRs = [-2, -1, -0.5,  0];
%     allLogDNRs = 0;


    global host
    if isempty(host)
        host = getenv('host');
    end
    showAnyFigures = strcmp(host, 'XPS'); 
    showAnyFigures = 0;
         
    skipSave = false;
    
    redoFilesIfExist = 1;
%     redoFilesIfOlderThan = 735839.456774; %sprintf('%.6f', now)
    redoFilesIfOlderThan = 735843.259089; %sprintf('%.6f', now)

    
    
    applyFourierMaskGainFactor = 1;
    allowLettersToFallOffImage = 1;
    
    noiseType = 'gaussian';
    nNoiseSamples = 1e5;
    
    % c1 = target centered, 1 distractor
    % c2 = target centered, 2 distractor
    % r1 = target random position, 1 distractor (only space for 1)    

%     precision = 'single'; precision_func = @single;
    
    doOverFeat = false && 1;

    if (nargin < 1) 
%         allSizeStyles = {'med', 'sml', 'big'};
%         allSizeStyles = {'sml', 'med', 'big'};
%         logSNR = 4;
%         allSizeStyles = {'big'};
%         allSizeStyles = {'k9', 'k18', {'k9', 'k18'}};
        allSizeStyles = {'k16'};

        if doOverFeat
            allSizeStyles = {'k23'};
        end
%         allXranges = {[15,5,55]};
%         allXranges = {[15,30,75]}; %, [15,30,75]};
%         allXranges = {[15,25,65]}; %, [15,30,75]};
%         allXranges = {[12,25,62]}; %, [15,30,75]};
%         allXranges = {[20,35,90]}; %, [for big letters
%         allTargetPositions = {[1:9]};

%         allXranges = {[15,5,55]};  allTrainPositions = {'all'};
%         allXranges = {[15,5,85]};  allTrainPositions = {[1:9]};
%         allXranges = {[15,12,87]};  allTrainPositions = {[1,3,4]};
%         allXranges = {[15,3,87]};  allTrainPositions = {[1,9,13]}; % = binarySearch(15:4:87, [15, 39, 51]) 
        
%         allXranges = {[14, 10, 144]};  allTrainPositions = {[1:12]}; % = binarySearch(15:4:87, [15, 39, 51])  
        allXranges = {[-16, 12, 176]};  allTrainPositions = {[3:15]}; allTestPositions = {9}; % = binarySearch(15:4:87, [15, 39, 51])  

         if doOverFeat
             allXranges = {[-34, 15, 266]};  allTrainPositions = {[4:18]}; allTestPositions = {11}; % = binarySearch(15:4:87, [15, 39, 51])  
         end
%         -44:16:276
        
        %%%%% x_start = 20; imW = 160; dx = 12; pos = x_start + [-10:1:30]*dx; pos= pos(ibetween(pos, -20, imW+20)); [pos; imW-pos]
        
%         binarySearch(15:2:100, [15, 39, 51])
        
%         allTestPositions = {1};
        

%         allXranges = {[15,5,55]};
%         allTrainPositions = {'all'};
%         allTestPositions = {1};
        
        
        allNDistractors = [2, 1];
%         allLogSNRs = {nan};
%         allLogSNRs = {4};
%         allFontNames = {'HelveticaUB', 'CourierU'};
%         allFontNames = {'Sloan'};
        allFontNames = {'Bookman'};
%         allFontNames = {'HelveticaUB'};

%         allBlurStds = {0,1,2,3};
        allBlurStds = {0};
        
%         allImageSizes = {[32, 128]};
        allImageSizes = {[32, 160]};
        
        if doOverFeat
            allImageSizes = {[231, 231]};
        end

        
%         allImageSizes = {[32, 64]};
%         allLogDNRs = [2, 3]; %0.85;
%         allLogDNRs = [2.5, 2.9]; % log10((0.85./[.03, .048, 0.19]).^2) = 2.9046    2.4609    1.3013
        allLogDNRs = [2.5]; % log10((0.85./[.03, .048, 0.19]).^2) = 2.9046    2.4609    1.3013
        
        allTextureSettings = {  [], ...
                                struct('Nscl_txt', 3, 'Nori_txt', 4, 'Na_txt', 5, 'statsUse', 'V2'), ...
                               ...    struct('Nscl_txt', 3, 'Nori_txt', 4, 'Na_txt', 5, 'statsUse', 'V1') ...
                               };
                           
%         allTextureSettings = {};
                           
        if doOverFeat
            allTextureSettings = {[]};
        end
        



%         allF_exps = [1, 1.5, 2];
%         cyc_per_pix = cyc_per_let*18;
        allF_exps = [1];

        allPinkPlusWhiteNoiseFilters = arrayfun(@(f) struct('filterType', '1/fPwhite', 'f_exp', f), allF_exps, 'un', 0);
        allPinkOrWhiteNoiseFilters = arrayfun(@(f) struct('filterType',   '1/fOwhite', 'f_exp', f), allF_exps, 'un', 0);        
        allPinkNoiseFilters = arrayfun(@(f) struct('filterType', '1/f', 'f_exp', f), allF_exps, 'un', 0);
        whiteNoiseFilter = {struct('filterType', 'white')};

        
%         NoiseFilters = [allBandNoiseFilters, allPinkNoiseFilters, whiteNoiseFilter];
%         NoiseFilters = [allPinkNoiseFilters, allPinkOrWhiteNoiseFilters, allPinkPlusWhiteNoiseFilters,whiteNoiseFilter ];

%         NoiseFilters = [{whiteNoiseFilter}];
%         NoiseFilters = allPinkNoiseFilters;
        
%         NoiseFilters = allBandNoiseFilters;
%         NoiseFilters = allHighPassNoiseFilters;

        NoiseFilters = [whiteNoiseFilter, allPinkNoiseFilters];
%         NoiseFilters = [whiteNoiseFilter];


%         allFontNames = {'Sloan', 'CourierU'};
%         all_spacingModes = {  {2, '20pix'}, {2, '30pix'}, {2, '40pix'}, {2, '60pix'}  };
%         all_spacingModes = {  {15:, '20pix'}, {2, '30pix'}, {2, '40pix'}, {2, '60pix'}  };
%         all_spacingModes = {  {2, '20pix'}, {2, '30pix'}, {2, '40pix'}, {2, '60pix'}  };
%         all_spacingModes = {  {2, '1.0let'}, {2, '2.0let'}, {2, '3.0let'}  };
        
%         trainNPos, trainSpacing, testNPos, testSpacing, testNDistractors
        
        allSetsToDo = expandOptionsToList( struct( 'tbl_fontName', {allFontNames}, ... 
                                                   'tbl_sizeStyle', {allSizeStyles}, ...
                                                   'tbl_imageSize', {allImageSizes}, ...
                                                   'tbl_xrange', {allXranges}, ...
                                                   'tbl_trainTargetPosition', {allTrainPositions}, ...
                                                   'tbl_testTargetPosition', {allTestPositions}, ...
                                                   'allNDistractors', allNDistractors, ...    
                                                   'allLogDNRs', allLogDNRs, ...
                                                   'tbl_blurStd', {allBlurStds}, ...
                                                   'tbl_noiseFilter', {NoiseFilters}, ...
                                                   'tbl_textureSettings', {allTextureSettings} ...
                                                ), {'noiseFilter', 'textureSettings'} );
                   
%         allSetsToDo = struct('sizeStyle', 'med', 'spacingMode', {{2, '2let'}});
                            
                           %{[-8:2:8], [0:9], [0:9]};  % 10 x 10 x 10 
                           ...{[-20:2:20], [-4:5], [-4:5]};
                           ...{[-30:5:30], [-4:5], [-4:5]}
                              
        for set_idx = 1:length(allSetsToDo)
            s = allSetsToDo(set_idx);
            fprintf('============================= =========== ===========================\n');
            fprintf('============================= Set %d / %d ===========================\n', set_idx, length(allSetsToDo));
%             fprintf('=============== %s ============== \n', allFontNames{fi})

            createCrowdedLettersDatafile(s.fontName, s.sizeStyle, s.imageSize, s.xrange, s.trainTargetPosition, s.testTargetPosition, s.allNDistractors, ...
                s.allLogDNRs, s.blurStd, s.noiseFilter, s.textureSettings, set_idx);
        end
        return;
    end
%}

    fontSize = getFontSize(fontName, sizeStyle);
    sizeSpec = 'minSize';
    [allLetters, lettersInfo] = loadLetters(fontName, fontSize, sizeSpec);
    
    showLetters = 1;        

    xs = xrange(1) : xrange(2): xrange(3);
    
%     switch sizeStyle 
%         case 'sml',  marginPixels = 5;  letterSpacingPixels = 1;
%         case 'med',  marginPixels = 5;  letterSpacingPixels = 1;
%         case 'big',  marginPixels = 5;  letterSpacingPixels = 1;
%     end
    marginPixels = 5;  letterSpacingPixels = 1;

    
    dX = diff(xs);  assert(length(unique(dX)) == 1);
    
    noiseFilter.applyFourierMaskGainFactor = applyFourierMaskGainFactor;

    fontWidth = lettersInfo.size(2);

    halfLetterWidth = ceil(fontWidth / 2);
    
    if ~allowLettersToFallOffImage
        assert(xs(1)   > halfLetterWidth );
        assert(xs(end) <  ceil(fontWidth / 2) );
    end    
%     switch lower(xSpacingMode)
%         case 'pix', train_x_spacing_pix = xSpacing_n;
%         case 'let', train_x_spacing_pix = ceil(xSpacing_n * fontWidth);
%     end
    

%     xs = [0 : xNPos-1]  * [train_x_spacing_pix + letterSpacingPixels];   
 
    doTextureStatistics = ~isempty(textureSettings);
    if ~doTextureStatistics
        [Nscl_txt, Nori_txt, Na_txt, textureStatsUse] = deal(nan);
    else
        [Nscl_txt, Nori_txt, Na_txt, textureStatsUse] = deal(textureSettings.Nscl_txt,  textureSettings.Nori_txt, textureSettings.Na_txt, textureSettings.statsUse);
    end
    ys = 0;

    
    if doTextureStatistics
        stimType = 'NoisyLettersTextureStats';
    elseif doOverFeat
        stimType = 'NoisyLettersOverFeat';
    else
        stimType = 'NoisyLetters';
    end


    
%     xs = xs-xs(1);
%     ys = ys-ys(1);
%     
    xs=round(xs);
    ys=round(ys);

    Dx = xs(end)-xs(1);
    Dy = ys(end)-ys(1);
    nX = length(xs);
    nY = length(ys);
    orientations = 0;
    
    requireSquareImage = 1;
%     margin_arg = [marginPixels, marginPixels + letterSpacingPixels*2];
    margin_arg = [marginPixels, marginPixels];
    
    xs_start = xs - halfLetterWidth;
    trimXY = 0;
    
%     [imageHeight, imageWidth] = getBestImageSize(orientations, xs_start, ys, fontName, sizeStyle, margin_arg, requireSquareImage, trimXY);
    [imageHeight, imageWidth] = deal(imageSize(1), imageSize(2));
    

%     crowdedLettersPath = [datasetsPath 'Crowding' filesep stimType fontName filesep]; % 'sz32x32' filesep];

    crowdedLetterOpts_1let = struct('expName', 'Crowding',   'stimType', stimType, 'sizeStyle', sizeStyle, 'xrange', xrange, 'imageSize', imageSize, ...
        'nLetters', 1, 'trainTargetPosition', trainTargetPosition,  'testTargetPosition', testTargetPosition, 'blurStd', blurStd, 'noiseFilter', noiseFilter, ...
        'doTextureStatistics', doTextureStatistics, 'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt, 'textureStatsUse', textureStatsUse, ...
        'doOverFeat', doOverFeat); % , 'distSpacing', distractorSpacing
    fprintf('\n=========== font = %s. Size = %s.  Opts = %s. =================\n', fontName, sizeStyle, getCrowdedLetterOptsStr(crowdedLetterOpts_1let));
    
    [~, crowdedLettersPath] = getFileName(fontName, 0, crowdedLetterOpts_1let);
    
%     if 0 && ~redoFilesIfExist 
%         training_filename = getCrowdedLetterFileName('Train', fontName, crowdedLetterOpts);
%         trainFileExists = exist([crowdedLettersPath training_filename], 'file');
%         
%         testingFilesExist = arrayfun(@(dnr) exist([crowdedLettersPath getCrowdedLetterFileName('Test', fontName, crowdedLetterOpts, dnr)], 'file'), allLogDNRs );
% 
%         if trainFileExists && all(testingFilesExist)
%             fprintf('Already completed\n');
%             return
%         end
%         
%     end
    
    
    fprintf(' - Calculating Crowded letter Sets for %s, size %s\n', fontName, sizeStyle);
    fprintf(' - Using %d X positions [%d:%d], and %d Y positions [%d:%d]\n', nX, lims(xs), nY, lims(ys));
    fprintf(' - Using an image size %d x %d\n', imageHeight, imageWidth);
  
    
    if ~exist(crowdedLettersPath, 'dir')
        mkdir(crowdedLettersPath)
    end
    
%     setSize = 10000;
    trainSetSize = 9000;
    testSetSize = 1000;
    if doOverFeat 
        if strcmp(host, 'XPS')
            trainSetSize = 20;
            testSetSize = 10;
        else
            trainSetSize = 1000;
            testSetSize = 100;           
        end
    end
    
    
    addNoise = 1;

    if addNoise
        rand_seed = 0; %mod(fontSize * sum(fontName) * (imageHeight*imageWidth) * (Dx+1) *(Dy+1) * (nOris+1), 2^32);
        noiseSet = generateNoiseSamples(nNoiseSamples, noiseType, rand_seed);
        noiseSet.noiseSize=[imageHeight,imageWidth];
    else
        noiseSet = struct;
    end

    
                        
    nLetters = size(allLetters, 3);
    
    
    
%%

    pixPerDeg = 1;
    signal(nLetters, nX, nY) = struct;
    
%     [idxT, idxB, idxL, idxR] = findLetterBounds(allLetters, 0, 1);
    
    fprintf('Calculating letter Signals...');

%     function signals = generateLetterSignals(allLetters, xs, ys, orientations, imageHeight, imageWidth)
    
    horiz_offset = -halfLetterWidth;

%         allowLettersToFallOffImage = 0;
%     if isfield(params, 'allowLettersToFallOffImage') 
%         allowLettersToFallOffImage = params.allowLettersToFallOffImage);
%     end

    letter_params = struct('pixPerDeg', pixPerDeg, 'imageHeight', imageHeight, 'imageWidth', imageWidth, ...
        'horizPosition', horiz_offset, 'vertPosition', 'centered', 'allowLettersToFallOffImage', allowLettersToFallOffImage);
    signal = generateLetterSignals(allLetters, xs, ys, orientations, letter_params);
    
    3;
   

    params.nX = length(xs);
%     params.spacing = xSpacing
    
    params.xs = xs;
    params.ys = ys;
    params.orientations = orientations;
%     params.x_offset = x_offset;
%     params.y_offset = y_offset;
    params.fontSize = fontSize;
    params.fontName = fontName;
%     params.precision = precision;
    params.signalContrast = 1;
    params.marginPixels = marginPixels;
    params.letterSpacingPixels = letterSpacingPixels;
    params.logEstimatedEOverNIdealThreshold = 1;
    params.logE1= mean( log10([signal(:,1,1,1).E1]) );
    params.pixPerDeg = 1;
    params.noiseSamples = noiseSet;
    params.targetPosition = trainTargetPosition;
    params.blurStd = blurStd;
    params.noiseFilter = noiseFilter;
    params.doTextureStatistics = doTextureStatistics;
    params.textureStatsParams = textureSettings;
    params.textureStatsUse = textureStatsUse;
    
    
    tryGetLocks = ~strcmp(host, 'XPS') && (doTextureStatistics || doOverFeat);
    
    
    allLogSNRs = [0, 1, 2, 3, 4, 5, 6];
    allLogSNRs = [3];
    nSNRs = length(allLogSNRs);
    
    %%%% Generate TRAINING data set
    fprintf('Generating Training Samples (with 1 letter) ...');
    
    skipTrainingFilesForNow = false;
    
    for snr_i = 1:nSNRs

        logSNR = allLogSNRs(snr_i);
        
        crowdedLetterOpts_1let.nLetters = 1;
        training_filename = getCrowdedLetterFileName(fontName, logSNR, crowdedLetterOpts_1let);

        haveFileAlready = exist([crowdedLettersPath training_filename], 'file') && ~redoFilesIfExist && ...
            ~fileOlderThan([crowdedLettersPath training_filename], redoFilesIfOlderThan);
        

        if ~haveFileAlready && ~skipTrainingFilesForNow
            
            if tryGetLocks        
                [gotLock, otherProcessID] = lock_createLock(training_filename);
            else
                gotLock = true;
            end
                
            if ~gotLock
                fprintf('Another process (%s) has a lock on this file...\n', otherProcessID);
                
            else
            
                params.setSize = trainSetSize;
                params.nDistractors = 0;
                params.logSNR = logSNR;

                letterSet = generateSetOfLetters(signal, params);


            %%    
                if doTextureStatistics
                    inputMatrix = letterSet.textureStats;
                else
                    inputMatrix = letterSet.inputMatrix;
                end

    %             [propLetterCorrect_ideal, propEachLetterCorrect_ideal] = calcIdealPerformanceForNoisySet(letterSet);

                S_train = struct('inputMatrix', inputMatrix, 'labels', letterSet.labels, ...
                    'xs', xs, 'ys', ys, 'orientations', orientations, 'fontName', fontName, 'fontSize', fontSize, 'nClasses', nLetters, ...
                    'sizeStyle', sizeStyle, 'xrange', xrange, 'targetPosition', trainTargetPosition, ...
                    'OverFeat', doOverFeat ...
                    ...'propLetterCorrect_ideal', propLetterCorrect_ideal, 'propEachLetterCorrect_ideal', propEachLetterCorrect_ideal 
                    ); %#ok<NASGU>
    %%
                showTrainingSet  = 1;
                if showTrainingSet && showAnyFigures
                    %%
%                     [subM, subN] = deal(14,10);
                    [subM, subN] = deal(8,2);
                    
                    nTot = subM*subN;
                    idx_rand = randperm(length(letterSet.labels));
                    idx_use = idx_rand(1:nTot);
                    figure(91+set_idx); clf;

                    tmp = 0;
                    if tmp
                        idx_use = reshape(idx_use, subM, subN);

                        for i = 1:subM
                            for j = 1:subN
                                subplotGap(subM, subN, i, j);
                                imagesc(letterSet.inputMatrix(:,:,idx_use(i,j)));
                                ticksOff;
                                colormap(gray(256));

                            end
                        end
                        imageToScale;
                        3;
                    else
                    %%
                        subplotGap(1,1,1,1);
                        imagesc(tileImages(letterSet.inputMatrix(:,:,idx_use), subM, subN, 3, 1));
                        %         imagesc(tileImages(trainingSetSamples(:,:,1)))
                        axis equal tight;
                        colormap('gray');
                        set(gca, 'xtick', [], 'ytick', [], 'position', [0.01 0.01 .8 .8]);
                        imageToScale;
                    end

                end

                if ~skipSave
                    fprintf('  saving to Training file: %s\n', training_filename)
                    save([crowdedLettersPath training_filename], '-struct', 'S_train', '-v6');
                end
                
                if tryGetLocks
                    lock_removeLock(training_filename);
                end
            end
            
        else
            
            fprintf('Already completed %s\n', training_filename);
        end
        
    end
  %%  
        
    3;    
    fprintf('done\n');
    
    showLetters = 0;
    if showLetters && showAnyFigures
%         if nOris > 1 || nX > 1 || nY > 1
            %%
%             signalImages = cat(3, signal(1:5,:,:,:).image);
%             signalImages_tiled = tileImages(signalImages);
%             figure(34); clf;
%             imagesc(signalImages_tiled); axis equal tight;
%             colormap('gray');
%             imageToScale;

            %%
            figure(35 + set_idx);
            signalImages_all = trainingSetSamples; %cat(3, signal(:,:,:,:).image);
%             subplot(2,8,font_loc_idx);    
            imagesc( log1p( sum(signalImages_all, 3) ) ); axis square;
            title(sprintf('%s [%d]', fontName, fontSize));
            if font_loc_idx == 3
                xlabel(sprintf('nOri = %d, nX = %d, nY = %d. Im = [%d x %d]', nOris, nX, nY, imageHeight, imageWidth));
            end

            %%
            all_used = sum(signalImages_all, 3) > 0;
%             subplot(2,8,8+font_loc_idx);  
            figure(135 + set_idx);
            imagesc(tileImages(signalImages_all) ); axis square;
            [idx_t, idx_b, idx_l, idx_r] = findLetterBounds(all_used);
            gap_t = idx_t-1;
            gap_b = imageHeight-idx_b;
            gap_l = idx_l-1;
            gap_r = imageWidth-idx_r;
            xlabel(sprintf('[%d, %d, %d, %d]', gap_t, gap_b, gap_l, gap_r), 'fontsize', 9)
            colormap('gray');
            
            3;
            
%         end
       
        return
    end
    
    
    params.setSize = testSetSize;
%     testTargetPosition = 'all';
    params.targetPosition = testTargetPosition;

    nDNRs = length(allLogDNRs);
    
    fprintf('======= Now computing all multiple-letter sets \n');

    nnDistractors = length(allNDistractors);

    crowdedLetterOpts_nlet = crowdedLetterOpts_1let;
    
    for ndist_i = 1:nnDistractors
        nDistractors = allNDistractors(ndist_i);
        nLettersTest = nDistractors + 1;

        
        [allDistractSpacings_pix, allDistractSpacings] = getAllDistractorSpacings(xrange, fontWidth, nDistractors, testTargetPosition);
% %         allDistractSpacings_pix = allDistractSpacings_pix([1, end]);
% %         allDistractSpacings = allDistractSpacings([1, end]);
        
        nSpacings = length(allDistractSpacings);
        
        params.nDistractors = nDistractors;
        params.allDistractSpacings = allDistractSpacings;
        
        
        for dnr_i = 1:nDNRs
            logDNR = allLogDNRs(dnr_i);

            for ds_i = 1:nSpacings
                distractorSpacing = allDistractSpacings(ds_i);
                distractorSpacing_pix = allDistractSpacings_pix(ds_i);

                for snr_i = 1:nSNRs
                    logSNR = allLogSNRs(snr_i);

                    crowdedLetterOpts_nlet.logDNR = logDNR;
                    crowdedLetterOpts_nlet.logSNR = logSNR;
                    crowdedLetterOpts_nlet.distractorSpacing = distractorSpacing_pix;
                    crowdedLetterOpts_nlet.testTargetPosition = testTargetPosition;
                    crowdedLetterOpts_nlet.nLetters = nLettersTest;
                    crowdedLetterOpts_nlet.trainTargetPosition = testTargetPosition;  % so don't label file with 'TrainedWithX'

                    testing_filename = getCrowdedLetterFileName(fontName, logSNR, crowdedLetterOpts_nlet);
                    fprintf('\n nDistract %d/%d.  DNR %d/%d.   Spacing %d/%d. SNR: %d/%d [ logSNR = %.2f] \n   === FileName = %s === : ', ...
                        ndist_i, nnDistractors,   dnr_i, nDNRs,  ds_i, nSpacings, snr_i, nSNRs, logSNR, testing_filename)

                    haveFileAlready = exist([crowdedLettersPath testing_filename], 'file') && ~redoFilesIfExist && ...
                        ~fileOlderThan([crowdedLettersPath testing_filename], redoFilesIfOlderThan);
                    if ~haveFileAlready
                        %%
                        
                        if tryGetLocks
                            [gotLock, otherProcessID] = lock_createLock(testing_filename);
                        else
                            gotLock = true;
                        end
                        
                        if ~gotLock
                            fprintf('Another process (%s) has a lock on this file...\n', otherProcessID);
                            
                        else

                            params.logSNR = logSNR;
                            params.logDNR = logDNR;
                            params.nDistractors = nDistractors;
                            params.distractorSpacing = distractorSpacing;

                            %%%%%%% Generate the dataset %%%%%%%%%%%%%%%%%%5
                            crowdedSet = generateSetOfLetters(signal, params);

                            if doTextureStatistics
                                inputMatrix = crowdedSet.textureStats;
                            else
                                inputMatrix = crowdedSet.inputMatrix;
                            end

                            if nDistractors == 2
                                labels2_C = {'labels_distract2', crowdedSet.labels_distract2};
                            else
                                labels2_C = {};
                            end

    %                         [propLetterCorrect_ideal, propEachLetterCorrect_ideal] = calcIdealPerformanceForNoisySet(crowdedSet, 'RawImage', 'AnyLetter');

                            crowdedSet.targetPosition = testTargetPosition;
                            crowdedSet.nLettersEachImage = nLettersTest;
    %                         [propLetterCorrect_ideal_target, propEachLetterCorrect_ideal_target] = calcIdealPerformanceForNoisySet(crowdedSet, 'RawImage', 'OnlyTarget');
                            3;

                            S_test = struct('inputMatrix', inputMatrix, 'labels', crowdedSet.labels, 'labels_distract', crowdedSet.labels_distract, labels2_C{:}, ...
                                'xs', xs, 'ys', ys, 'orientations', orientations, 'fontName', fontName, 'fontSize', fontSize, ...
                                'logSNR', logSNR, 'logDNR', logDNR, 'distractorSpacing', distractorSpacing, 'distractorSpacing_pix', distractorSpacing_pix, 'nClasses', nLetters, ...
                                'x_dist', crowdedSet.x_dist, 'dist_sign', crowdedSet.dist_sign, ...
                                'OverFeat', doOverFeat ...
                                ...'propLetterCorrect_ideal', propLetterCorrect_ideal, 'propEachLetterCorrect_ideal', propEachLetterCorrect_ideal, ...
                                ...'propLetterCorrect_ideal_target', propLetterCorrect_ideal_target, 'propEachLetterCorrect_ideal_target', propEachLetterCorrect_ideal_target
                                );  %#ok<NASGU>

                            if ~skipSave
                                save([crowdedLettersPath testing_filename], '-struct', 'S_test', '-v6')
                            end
                            
                            all_S_test(ds_i) = S_test;
                             
                            if tryGetLocks
                                lock_removeLock(testing_filename);
                            end
                            
                        end
                            
                            
                    else
                        
                        fprintf('Already completed \n');
                    end

                    showTestingSet = 1; %&& ~haveFileAlready;
                    if showTestingSet && showAnyFigures
                        %%
                        tmp = 0;
                        if tmp;
                            figure(678);
                            imagesc(snImage); colormap(gray(256));
                            imageToScale;
                            ticksOff;    
                            
                        end


                        
                        fig_id2 = 250 + set_idx*10 + (ndist_i *nDNRs) + dnr_i;
                        figure(fig_id2); 
                        if snr_i == 1 && ds_i == 1
                            clf;
                        end
                        
                        h_ax = subplotGap(nSNRs, nSpacings, find(logSNR == sort(allLogSNRs)), ds_i);
%                         [subM, subN] = deal(14,10);
                        
                        
                        [subM, subN] = deal(1,1);
                        nTot = subM*subN;

                        idx_rand = randperm(length(crowdedSet.labels));
                        idx_use = idx_rand(1:nTot);

                        imagesc(tileImages(crowdedSet.inputMatrix(:,:,idx_use), subM, subN, 3, 1));
                        %         imagesc(tileImages(trainingSetSamples(:,:,1)))
                        axis equal tight;
                        colormap('gray');
%                         set(gca, 'xtick', [], 'ytick', [], 'position', [0.01 0.01 .8 .8]);
                        ticksOff;
                        xlabel(sprintf('ds = %d, snr = %d', distractorSpacing, logSNR)); %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
                        3;
                    end
                    3;

            %%
                   



                end
                
            end
            
            tmp = 0;
            if tmp
                %%
                figure(93); clf;
                for i = 1:nSpacings-1
                    subplotGap(nSpacings-1, 1, i, 1);
                    idx = randi( length(all_S_test(i).labels) );
                    imagesc(all_S_test(i).inputMatrix(:,:,idx))
                    ticksOff;
                end
                colormap(gray(256));
                imageToScale;
                
            end
            
            
        end
    end
%%
%         return
 
    
%     fprintf('%s',readme);  
    fprintf('Done.\n');
    
end



% function [spacing_n, spacingMode] = parseSpacingArg(spacingArg)
%     
%     n = regexp(spacingArg, '[\d.]+', 'match');
%     md = regexp(spacingArg, '[a-z]+', 'match');
%     
%     spacing_n = str2double( n );
%     spacingMode = lower(md);
%     if any(strcmp(spacingMode, {'p', 'pix', 'pixels'}))
%         spacingMode = 'pix';
%     elseif any(strcmp(spacingMode, {'l', 'let', 'letters'}))
%         spacingMode = 'let';
%     end
%     
% end

% function xSpacing = makeSpacingArg(xSpacing_n, xSpacingMode)
%     switch xSpacingMode
%         case 'pix',
%             assert(xSpacing_n == round(xSpacing_n));
%             xSpacing = sprintf('%dpix', xSpacing_n);
%         case 'let',
%             xSpacing = sprintf('%.1flet', xSpacing_n);
%     end
% end
% 
% function new_image = addToImage(orig_image, letter_idx, position, allLetters)
% 
% 
% end





%{

% old way of generating a signal - which allowed for putting in a target /
distractor at random positions:

    for sample_idx=1:params.setSize
        %%

        sig_let_idx = randi(nLetters, params.precision);
        if targetPosition == 'c'
            if fixedDistractorPosition
                sig_x_idx = randi(2);
            else
                sig_x_idx = ceil(nX/2);
            end
            sig_y_idx = ceil(nY/2);
            
        else
            sig_x_idx   = randi(nX, params.precision);
            sig_y_idx   = randi(nY, params.precision);
            assert(nDistractors == 1);
        end
        
         
        signal_i = signal(sig_let_idx,sig_x_idx,sig_y_idx);
        new_image = signal_i.image * signalContrast;

        
        distract_let_idx = randi(nLetters, [1, nDistractors], params.precision);
        
%         distract_let = allLetters(idxT(distract_let_idx):idxB(distract_let_idx), idxL(distract_let_idx):idxR(distract_let_idx),distract_let_idx);
        for d_i = 1:nDistractors

            if fixedDistractorPosition
                dist_x_idx = setdiff( randperm(nX), sig_x_idx);
                dist_y_idx = 1;
                dist_signal = signal(distract_let_idx,dist_x_idx(1),dist_y_idx(1)).image;

                assert( sum(dist_signal(:) .* new_image(:) ) == 0);
                
                new_image = new_image + dist_signal * distractContrast;
                
                x_dist = 0;
                dist_sign = 0;
            else

                distract_let = allLetters(:, idxL(distract_let_idx(d_i)):idxR(distract_let_idx(d_i)),distract_let_idx(d_i));
                [n_h, n_w] = size(distract_let);

                %%

                nPixBefore = signal_i.x_bnd(1) - 1;
                nPixAfter  = im_w - signal_i.x_bnd(2);

                nBeforeOptions = nPixBefore - n_w - nPixelSpacing - nPixelsMargin+1;
                nAfterOptions  = nPixAfter - n_w - nPixelSpacing - nPixelsMargin+1;

                idx_starts_before = nPixelsMargin + [1:nBeforeOptions];
                idx_starts_after = signal_i.x_bnd(2) + nPixelSpacing + [1:nAfterOptions];

                if nBeforeOptions < 1 && nAfterOptions < 1
                    error('Image Too narrow')
                end

                if targetPosition == 'c'
                    if nDistractors == 1
                        left_right = randi(2);
                    else
                        left_right = d_i;
                    end

                    if left_right == 1
                        x_pos = idx_starts_before( ceil(nBeforeOptions/2) );
                    elseif left_right == 2
                        x_pos = idx_starts_after( ceil(nAfterOptions/2) );
                    end

                else
                    % randomly choose a position for the distractor
                    idx_starts = [idx_starts_before, idx_starts_after];
                    idx_start_select = randi(length(idx_starts));
            %         idx_start_select = 1; %length(idx_starts);
                    x_pos = idx_starts(idx_start_select);


                end
                y_pos = signal_i.y_bnd(1);

                if doChecks
                    cur = new_image(y_pos + [0:n_h-1], x_pos + [0:n_w-1]);
                    assert(all(cur(:) == 0));
                end
                new_image(y_pos + [0:n_h-1], x_pos + [0:n_w-1]) = distract_let * distractContrast;
                

                if x_pos < signal_i.x_bnd(1)  % distract image is on the left
                    x_dist = signal_i.x_bnd(1) - (x_pos + n_w-1) - 1;
                    dist_sign = -1;
                else  % distract image is on the right
                    x_dist = x_pos - signal_i.x_bnd(2) - 1;
                    dist_sign = 1;
                end
                assert(x_dist >= 1);
                
                
            end
    %         for i = 1:length(idx_starts)
    %             new_image(y_pos + [0:n_h-1], idx_starts(i) + [0:n_w-1]) = new_image(y_pos + [0:n_h-1], idx_starts(i) + [0:n_w-1]) + distract_let*.5;
    %         end
 

        end
        
        if doChecks
            should_be_blank = new_image(:,[1, signal_i.x_bnd+[-1, 1], im_w]);
            assert(all(should_be_blank(:)) == 0);

            assert(isequal(size(new_image), size(signal_i.image)))
        end

        
        show = 0;
        if show
            %%
            figure(1); clf;
            subplot(1,2,1);
            imagesc(signal_i.image); axis equal tight;

            subplot(1,2,2);
            imagesc(new_image); axis equal tight;
            colormap('gray');
%             imageToScale;
            3;
        end
   
        
%         x_before = 
        
        % 
        
        crowdedSet.stimulus(sample_idx).image= new_image;
        crowdedSet.stimulus(sample_idx).whichTargetLetter=sig_let_idx;
%         crowdedSet.stimulus(sample_i).text=textSignals(whichSignal);
        crowdedSet.stimulus(sample_idx).sig_x=xs(sig_x_idx);
        crowdedSet.stimulus(sample_idx).whichX=sig_x_idx;
        crowdedSet.stimulus(sample_idx).sig_y=ys(sig_y_idx);
        crowdedSet.stimulus(sample_idx).whichY=sig_y_idx;
        crowdedSet.stimulus(sample_idx).whichDistractLetter=distract_let_idx(1);
        if nDistractors > 1
            crowdedSet.stimulus(sample_idx).whichDistractLetter2=distract_let_idx(2);
        end
        crowdedSet.stimulus(sample_idx).x_dist = x_dist;
        crowdedSet.stimulus(sample_idx).dist_sign = dist_sign;
        
        
        if mod(sample_idx, step) == 0
            fprintf('.');
        end

    end



%}

%{

%     if ~exist('fontName', 'var') || isempty(fontName)
%         fontName = 'Sloan';
%     end
%     
%     if ~exist('sizeStyle', 'var') || isempty(sizeStyle)
%         sizeStyle = 'med';
%     end
%     
%     if ~exist('xrange', 'var') || isempty(xrange)
%         xrange = [15,10,95];
%     end
%     
%     if ~exist('targetPosition', 'var') || isempty(targetPosition)
%         targetPosition = 'all';
%     end
%     
%     if ~exist('nDistractors', 'var') || isempty(nDistractors)
%         nDistractors = 1;
%     end
% 
%     if ~exist('logSNR', 'var') || isempty(logSNR)
%         logSNR = 0;  % 0 == no noise
%     end
%}


%{
%             crowdedSet_old = generateSetOfCrowdedLetters(signal, params);
%             testSetSamples = cat(3, crowdedSet.stimulus(:).image);
%             labels_signal = [crowdedSet.stimulus.whichTargetLetter];
%             labels_distract = [crowdedSet.stimulus.whichDistractLetter];
%}


%     allL = 30:100;
%     nAfterFilt5 = [allL]-5+1;
%     okpool2 = mod( nAfterFilt5, 2) == 0;
%     okpool4 = mod( nAfterFilt5, 4) == 0;
%     okpool6 = mod( nAfterFilt5, 6) == 0;
%     allL(okpool2 & okpool4 & okpool6);
%          ==>  40    52    64    76    88   100



%{

 showSamples_withSignalNoiseSeparate = 0;
                    if showSamples_withSignalNoiseSeparate
                        % Show the stimulus, signal, and stimulus minus signal, which should be just noise. One for each crowdedSet. 
                        fig_id = 50 + set_idx;

                        figure(fig_id);
                        if snr_i == 1
                            clf;
                        end
                        fig=1+3*(snr_i-1);
                        rows=length(allLogDNRs);
                        snImage=crowdedSet.stimulus(1).image;
                        h_ax(snr_i) = subplot(rows,4,1,'align'); imagesc(snImage); xlabel(testing_filename, 'interp', 'none', 'horiz', 'left'); axis equal tight; %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
                        whichTargetLetter=crowdedSet.stimulus(1).whichTargetLetter;
                        whichX=crowdedSet.stimulus(1).whichX;
                        whichY=crowdedSet.stimulus(1).whichY;
                        sImage=signal(whichTargetLetter,whichX,whichY).image;
                        subplot(rows,4,2,'align'); imagesc(sImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
                        nImage=snImage-sImage;
                        subplot(rows,4,3,'align'); imagesc(nImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
                        subplot(rows,4,4,'align'); imagesc(sum(testSetSamples,3) ); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
                    %             energy=sum(sum((sImage-1).^2));
                    %             noiseLevel=var(nImage(:));
                        caxis auto
                        colormap('gray')


                    end

                    showMultipleSamples = 0;
                    if showMultipleSamples
                        %%
                        % Show the stimulus, signal, and stimulus minus signal, which should be just noise. One for each set. 
                        fig_id2 = 250 + set_idx*10;

                        nImages = 16;
                        figure(fig_id2); 
                        if snr_i == 1 && ds_i == 1
                            clf;
                        end
        %                 rows=length(allLogDNRs);
        %                 cols=length(allDistractSpacings);
                        allImages=cat(3, crowdedSet.stimulus(1:nImages).image);
                        tiledImages = tileImages(allImages, [], [], 4);
                        h_ax(snr_i) = subplotGap(nDNRs,nSpacings,snr_i, ds_i); 
                        imagesc(tiledImages); 
                        xlabel(sprintf('ds = %d, dnr = %d', distractorSpacing, logDNR)); axis equal tight; %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
                        set(gca, 'xtick', [], 'ytick', []);
                    %             energy=sum(sum((sImage-1).^2));
                    %             noiseLevel=var(nImage(:));
                        caxis auto
                        colormap('gray')
                    %         fprintf('cond %d, log E/N nominal %.2f, actual %.2f\n',cond,crowdedSet.logEOverN,log10(energy/noiseLevel));
                        3;

                    end

%}