function measurePsychCurves_together(redoFlag)

%     expName = 'Channels';
    expName = 'Grouping';
%     expName = 'Complexity';
    
%     dataFolder = '/media/avi/Storage/Users/Avi/Code/nyu/letters/MATLAB/HumanObserver/'; % replace with folder where you want to keep stimuli & recorded data / thresholds
%     dataFolder = '/media/avi/Storage/Users/Avi/Code/nyu/letters/MATLAB/HumanObserver/'; % replace with folder where you want to keep stimuli & recorded data / thresholds
    dataFolder = [lettersDataPath 'HumanObserver' filesep];


%     userName = 'az_6';  % for hi/lopass
    userName = 'az_5'; % for bandpass
%     userName = 'az_4'; % for 1/f
    userName = 'az_6'; % for bandpass_norm
%     userName = 'dz_1'; % for bandpass_norm
%     userName = 'az_9'; % for bandpass_norm
    userName = 'az_7'; % for bandpass_norm
    
%     userName = 'az_1'; % for wiggle-types v1
    userName = 'az_2'; % for wiggle-types v2
    userName = 'az_3'; % for wiggle-types v2

%     userName = 'az_8'; % for channels for different fonts

%     userName = 'az_1'; % for complexities for different fonts

    %     norm_str = iff(applyFourierMaskGainFactor, '_NORM', '');
%     userName = [userName];


    keepAbsContrastFixed = true;

    contrast_pct = 100;
%     nPixelRep = 1;
    nPixelRep = [];
    
    useMyQuestForNextTrial = 0;
    useMyQuestForThresholdEst = 0;
    
    applyFourierMaskGainFactor_band = 1;
    applyFourierMaskGainFactor_hiLo = 0;
    applyFourierMaskGainFactor_pink = 1;

    showLetterTemplates = 1;
    fontSizeSpec = 'minSize';

    switch expName
        case 'Channels',
             fontNameDefault = 'Braille';
%              fontNameDefault = 'KuenstlerU';
%             fontNameDefault = 'Bookman';
%             fontNameDefault = 'Sloan';
            
%             fontSize = 'k64';  imageSize = [200, 200];
            fontSize = 'k32';  imageSize = [100, 100];
            
            nClasses = 26;

                  noiseMode = 'bandpass';
%                 noiseMode = 'hi&lopass';
%             noiseMode = 'white';
            %     noiseMode = '1/f';

%             allCycPerLet = [0.5,   1,       2,      4,       8,          16];
    
            allCycPerLet = [0.5,   0.71,    1,      1.41,    2,        2.83,    4,      5.66,     8,     11.31,     16];

            allCycPerLet = [0.5,   0.71,    1,      1.41,    2,  2.38,       2.83,   3.36,    4,      5.66,     8,     11.31,     16]; % for Sloan

            allCycPerLet = [0.5,   0.71,    1,      1.41,    2,        2.83,  3.36,   4,      5.66,     8,     11.31,     16]; % for Braille
%             allCycPerLet = [0.5,   0.71,    1,      1.41,    2,        2.83,  3.36,  4,  4.76,    5.66,     8,     11.31,     16]; % For KuenstlerU 
%             allCycPerLet = [0.5,   0.71,    1,      1.41,    2,        2.38,  2.83, 3.36,  4, 4.76,     5.66,     8,     11.31,     16]; % for Bookman ;

%             allCycPerLet = [0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.45, 16];
        %     allCycPerLet = [2,  2.83,   4,    5.66,     8,     11.31,     16];
        %     allCycPerLet = [1, 2,  2.83,   4,    5.66,     8];
        %     allCycPerLet = [2];
            allLetterChars = 'A':'Z';
            allLetterChars_full = 'A':'Z';
            getIdealObserverThresholds = 0;
           
            
        case 'Complexity',
            
              fontNameDefault = 'Bookman';
%               allFontNames = {'Braille', 'Sloan', 'Bookman', 'Helvetica', 'Yung', 'KuenstlerU'};
              allFontNames = {'Braille', 'Sloan', 'Bookman', 'Helvetica', 'KuenstlerU'};
%               allFontNames = {'Yung'};
            
%             fontSize = 'k64';  imageSize = [200, 200];
            fontSize = 'k32';  imageSize = [100, 100];
            
            nClasses = 26;

%               noiseMode = 'bandpass';
%                 noiseMode = 'hi&lopass';
            noiseMode = 'white';
            noiseFilter = struct('filterType', 'white');
            efficiency_plot_scale = 'log';
            %     noiseMode = '1/f';

            allLetterChars = 'A':'Z';
            allLetterChars_full = 'A':'Z';
            getIdealObserverThresholds = 1;
            
        case 'Grouping',
            snakesFontName = 'Snakes';  % modified snake letters
%             snakesFontName = 'Snakesp'; % original snake letters from "p"aper.
            fontNameDefault = [snakesFontName 'N'];

            nClasses = 10;

%             fontSize = 'k32';  imageSize = [64, 64];
            fontSize = 'k64';  imageSize = [100 100];
%             fontSize = 'k128';  imageSize = [200 200];
%             fontSize = 'k256';  imageSize = [400 400];

            noiseMode = 'white';
            
            efficiency_plot_scale = 'linear';
            
%             allWiggles_ori    = [0, 10:5:90];
%             allWiggles_offset = [0, 10:5:60];
%             allWiggles_offset = [   5, 10,15,20,25,30,40,50];


            allWiggles_ori    = [0, 5 : 5: 90];
            allWiggles_offset = [   5 : 5 : 50];
            allWiggles_phase  = [   40.8];
            allWiggleTypes = {'orientation', 'offset', 'phase'};

%             allWiggles_ori    = [0];  allWiggles_offset = []; allWiggles_phase = []; allWiggleTypes = {'orientation'}; 

            %             allWiggleAngles = {allWiggles_ori, allWiggles_offset};
            wiggleList_S = struct;
            for i = 1:length(allWiggleTypes)
                switch allWiggleTypes{i}
                    case 'orientation',  wiggleList_S.orientation = allWiggles_ori;
                    case 'offset',       wiggleList_S.offset      = allWiggles_offset;
                    case 'phase',        wiggleList_S.phase       = allWiggles_phase;
                end
            end
            allWiggles = getWiggleList(wiggleList_S);
            nWiggleTypes = length(allWiggleTypes);
            nWiggles = length(allWiggles);
            
            allLetterChars_full = 'A':'Z';
            allLetterChars = 'CDHKNORSVZ';
            
            noiseFilter = struct('filterType', 'white');
            allFontNames = cellfun(@(w) getSnakeWiggleStr(w), allWiggles, 'un', 0);
            getIdealObserverThresholds = 1;
            
            idealObserverSNRs = [0:.5:5];
            if strcmp(efficiency_plot_scale, 'log')
                xtick_wig0 = 3;
                wiggle_ticks = [xtick_wig0, 5, 10, 15, 25, 40, 60, 90];
                wiggle_ticks_show = wiggle_ticks; wiggle_ticks_show(wiggle_ticks_show == xtick_wig0) = 0;
            elseif strcmp(efficiency_plot_scale, 'linear')
                xtick_wig0 = 0;
                wiggle_ticks = [0 : 10 : 90];
                wiggle_tick_labels = arrayfun(@(x) sprintf('%d', x), wiggle_ticks, 'un', 0);        
                wiggle_lims = lims(wiggle_ticks, .05, []);
                
            end
            
     
            
    end
    
    lettersInDataset = arrayfun(@(let) any(allLetterChars == let), allLetterChars_full);
    
            
    isUppercaseFont_func = @(fontNm) (fontNm(end) == 'U') || any(strncmp(fontNm, {'Snakes', 'Sloan'}, 4));
    isUppercaseFont = isUppercaseFont_func(fontNameDefault);
    upperLower_func = iff(isUppercaseFont, @upper, @lower);
        
    if contrast_pct ~= 100
        contrast_str = sprintf('_c%d', contrast_pct);
        userName = [userName contrast_str];
    end
 
    
    

    warning('off', 'MATLAB:Axes:NegativeDataInLogAxis')
    
%     fontSize = 'k18';
%     imageSize = [45, 45];

%     fontSize = 'k32';
%     imageSize = [64, 64];



%     allLogSNRs = -5:.01:5; %linspace(-1,4,nSNRs);
    allLogSNRs = -5:.1:5; %linspace(-1,4,nSNRs);
%     allLogSNRs = 1; %linspace(-1,4,nSNRs);
        allSNRs = 10.^allLogSNRs;
        nSNRs = length(allLogSNRs);

%     allCycPerLet = [0.5, 0.8, 1.3, 2.0,  3.2, 5.1, 8.1, 13];
%     allCycPerLet = [0.5,   1,     2,     4,     8,      16];
%     allCycPerLet = [0.5,   1];
%     nNoises = length(allCycPerLet);
%     allTh =        [.21            12.3                   ];

%     idx_use = 6;
        
    
%     allLogSNRs = [0, 1, 1.5, 2, 2.5, 3, 4];
%     allLogSNRs = [-1, 0, 0.5, 1, 1.5, 2, 2.5, 3, 4];

    pThreshold = 0.64;
    quest_beta = 2.5;
    quest_delta = 0.01;
    quest_gamma = 1/nClasses;
    quest_range = 20;
    quest_grain = 0.05;


    
    screen_height_mm = 194;  screen_width_mm = 344;
    screenSize = get(0, 'ScreenSize');
    screen_width_pix = screenSize(3); screen_height_pix = screenSize(4);
    
    pix_per_mm_w = screen_width_pix / screen_width_mm;
    pix_per_mm_h = screen_height_pix / screen_height_mm;
    pix_per_mm = (pix_per_mm_w + pix_per_mm_h)/2;
    
    viewingDistance_mm = 500;  % 50cm = 20 inches
    
    radPerMM = 1 / (viewingDistance_mm);
    degPerMM  = radPerMM * (180/pi);
    degPerPix = degPerMM / pix_per_mm;
    3;
%     radPerPix = 1 / (viewingDistance_mm * pix_per_mm);
%     degPerPix = radPerPix * (180/pi);
    
    [fontPointSize, fontXheight, fontKheight] = getFontSize(fontNameDefault, fontSize, fontSizeSpec); 
    if isempty(fontPointSize)
        error('No font at this size');
    end
    if strcmp(expName, 'Channels')
%         targetDegPerLetter = 1;
        targetDegPerLetter = 0.5;
        pixPerLetter = fontXheight;
    elseif strcmp(expName, 'Complexity')
%         targetDegPerLetter = 1;
        targetDegPerLetter = 0.5;
        pixPerLetter = fontXheight;
    elseif strcmp(expName, 'Grouping')
%         targetDegPerLetter = 4;
        targetDegPerLetter = 1;
        pixPerLetter = fontKheight;
    end
    

    degPerScreen = degPerPix * screen_width_pix;    
    degPerIm = degPerPix * imageSize(1);
    degPerLetter = degPerPix * pixPerLetter;

    

    imageScaleRep = max( roundToNearest( targetDegPerLetter/degPerLetter, 1), 1);
    if ~isempty(nPixelRep)
        imageScaleRep = nPixelRep;
    end
    
    
    if ~isempty(imageScaleRep) && imageScaleRep ~= 1
        pixelRep_str = sprintf('_pixRep%d', imageScaleRep); 
        userName = [userName pixelRep_str];
    end
    
%     channel_opt.whiteNoiseTh = 149.62;
    channel_opt.whiteNoiseTh = 138;
    
    f_exp = 1;
    
 
    switch noiseMode
        case {'white', '1/f'}
            if strcmp(noiseMode, 'white')
%             allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor), allCycPerLet, 'un', 0);
                allFilters = {struct('filterType', noiseMode, 'applyFourierMaskGainFactor', 0)};
            else
                allFilters = struct('filterType', noiseMode, 'f_exp', f_exp, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink);
            end
            
            nX = 1;
            if strcmp(expName, 'Channels')
                
                nCurves = 1;
                curve_idxs = {1:nX};
                allCycPerLet = 1;
    %             idx_lo = 1;
                allCycPerLet_full = [1];
                
                allX_plot = allCycPerLet;
                
            elseif strcmp(expName, 'Complexity')
                
                nX = length(allFontNames);
                nCurves = 1;
                curve_idxs = {1:nX};
                allCycPerLet = 1;
    %             idx_lo = 1;
                allCycPerLet_full = [1];
                
                
%                 for i = 1:length(allFontNames)
%                     complexities(i) = getFontComplexity(allFontNames{i}, fontSize_use, fontSizeSpec);
                    font_complexities = cellfun(@(fntName) getFontComplexity(fntName, fontSize, fontSizeSpec), allFontNames);
%                 end
                allX_plot = font_complexities;
                
            elseif strcmp(expName, 'Grouping')
                nCurves = nWiggleTypes;
                               
                nX = nWiggles;
                idx_ori = 1:length(allWiggles_ori); 
                idx_offset = length(allWiggles_ori) + [1:length(allWiggles_offset)];
                idx_phase = length(allWiggles_ori) + length(allWiggles_offset) + [1:length(allWiggles_phase)];
                curve_idxs = {idx_ori, idx_offset, idx_phase};
                assert(isequal([curve_idxs{:}], 1:nX));
                allX = [allWiggles_ori, allWiggles_offset, allWiggles_phase];
                
                allX_plot = allX;
                allX_plot(allX_plot == 0) = xtick_wig0;
            end
            
        case 'bandpass',
            allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_band), allCycPerLet, 'un', 0);
            allFilters = allBandNoiseFilters;
            nX = length(allCycPerLet);
            nCurves = 1;
            curve_idxs = {1:nX};
            allCycPerLet_full = [allCycPerLet];
            allX_plot = allCycPerLet;
            
        case 'hi&lopass',
            allLoPassFilters = arrayfun(@(f) struct('filterType', 'lo', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_hiLo), allCycPerLet, 'un', 0);
            allHiPassFilters = arrayfun(@(f) struct('filterType', 'hi', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_hiLo), allCycPerLet, 'un', 0);
            allFilters = [allLoPassFilters, allHiPassFilters];
            idx_lo = 1:length(allCycPerLet);
            idx_hi = idx_lo(end) + [1:length(allCycPerLet)];
            nCurves = 2;
            nX = length(allFilters);
            curve_idxs = {idx_lo, idx_hi};
            allCycPerLet_full = [allCycPerLet, allCycPerLet];
            allX_plot = allCycPerLet;
    end
    

    [S, allSignals, allLetterTemplates, allNoiseImages, allParams, q, Q, h_txt_top, h_txt_bot] = deal( cell(1, nX) );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    oris = 0; xs = 0; ys = 0;
    logSNR_load = 0;


    
    nMaxNoiseSamples = 200;
    for xi = 1:nX
    

        if strcmp(expName, 'Channels')
            noiseFilter = allFilters{xi};
            fontName_i = fontNameDefault;
        elseif strcmp(expName, 'Complexity')
            fontName_i = allFontNames{xi};    
            
        elseif strcmp(expName, 'Grouping')
            fontName_i = [snakesFontName allFontNames{xi}];
        end
        

        dataFolder_stim = [dataFolder 'Stimuli' filesep]; % 'sz32x32' filesep];
        dataFolder_response = [dataFolder 'Responses' filesep]; % 'sz32x32' filesep];
        if ~exist(dataFolder_stim, 'dir')
            mkdir(dataFolder_stim)
        end
        if ~exist(dataFolder_response, 'dir')
            mkdir(dataFolder_response)
        end
%         noisyLettersPath_thisFont = [dataFolder_stim fontName filesep];

        noisyLetterOpts = struct( ...
            'expName', expName, ...
            'fontName', fontName_i, ...
            'noiseFilter', noiseFilter, ...
            ...
            'OriXY', struct('oris', oris, 'xs', xs, 'ys', ys), 'stimType', 'NoisyLetters', 'tf_pca', 0, ...
            'sizeStyle', fontSize, ...
            'imageSize', imageSize, ...
            'autoImageSize', 0 ...
        );
    
        [noisyLetterOpts_stim, noisyLetterOpts_noise, noisyOpts_response] = deal(noisyLetterOpts);
    
        noisyLetterOpts_stim.noiseFilter = [];
        
        noisyLetterOpts_noise.fontName = '';
        noisyLetterOpts_noise.sizeStyle = iff (any(strcmp(noiseFilter.filterType, {'band', 'lo', 'hi'})), fontSize, '');
            
        noisyOpts_response.userName = userName;
    
            
        fn_response_base{xi} = getNoisyLetterFileName(fontName_i, [], noisyOpts_response); %#ok<AGROW>
        fn_response{xi} = [dataFolder_response fn_response_base{xi}]; %#ok<AGROW>
        
    %%

        stimulus_file_base = getNoisyLetterFileName(fontName_i, nan, noisyLetterOpts_stim);
        noise_file_base = getNoisyLetterFileName('Noise', nan, noisyLetterOpts_noise);

        stimulus_file = [dataFolder_stim stimulus_file_base];
        noise_file = [dataFolder_stim noise_file_base];

        if ~exist(stimulus_file, 'file')
            fprintf('Creating stimulus file : %s ...', stimulus_file_base);
            [allLetters, ~] = loadLetters(fontName_i, fontSize, fontSizeSpec);
            pixPerDeg = 1; margin = 0;
            allLetters_rotated = rotateLetters(allLetters, oris, margin);
            letter_params = struct('pixPerDeg', pixPerDeg, 'imageHeight', imageSize(1), 'imageWidth', imageSize(2), 'horizPosition', 'centered', 'vertPosition', 'centered');
            signal = generateLetterSignals(allLetters_rotated, xs, ys, oris, letter_params);
%             signalMatrix = cat(3, signal.image);
            params.logE1=log10([signal(:).E1]);
            S_signal = struct('signal', signal, 'params', params);
            save(stimulus_file, '-struct', 'S_signal', '-v6');
            fprintf('done\n');
        else
            S_signal = load(stimulus_file);
        end
        allSignals{xi} = S_signal.signal;
        allParams{xi} = S_signal.params;
        
        [~, ~, ~, ~, allLetters] = findLetterBounds( cat(3, allSignals{xi}.image) );
        allLetterTemplates{xi} = allLetters;

        if ~exist(noise_file, 'file')
            fprintf('Creating noise file : %s ...', noise_file_base);
            noiseType = 'gaussian';
            nNoiseSamples = 1e5;
            noiseSamples = generateNoiseSamples(nNoiseSamples, noiseType, 1);
                        
%             logE1=log10([signal(:).E1]);
%             params.logE1 = logE1;
                        
            
            if any(strcmp (noiseFilter.filterType, {'band', 'lo', 'hi'}))
%                 [~, fontXheight, ~] = getFontSize(fontName, fontSize);      
                noiseFilter.cycPerLet_range = getNoiseRange(noiseFilter);
                noiseFilter.cycPerPix_range = noiseFilter.cycPerLet_range / fontXheight;
            end

            noiseImages = zeros(imageSize(1), imageSize(2), nMaxNoiseSamples);
            noiseMasks = getNoiseMask(noiseFilter, imageSize);
            nMasks = length(noiseMasks);
            for noise_i = 1:nMaxNoiseSamples
                noiseImage = qRandSample(noiseSamples.noiseList, imageSize);
                idx_mask_use = mod(noise_i-1, nMasks)+1; 
                mask = noiseMasks{idx_mask_use};
                if ~isempty( mask )
                    noiseImage = ifft2( mask .* fft2(noiseImage), 'symmetric');
                end
                noiseImages(:,:,noise_i) = noiseImage;
            end
           
            S_noise = struct('noiseImages', noiseImages);
            save(noise_file, '-struct', 'S_noise', '-v6');
            fprintf('done\n');
        else
            S_noise = load(noise_file);
        end
        allNoiseImages{xi} = S_noise.noiseImages;
        
        
%         
%         if isfield(Si, 'signalMatrix') && ~isempty(Si.signalMatrix)
%             signalMatrix = Si.signalMatrix;
%         else
%             signalMatrix = Si.signalData;
%         end
%         allSignals{xi} = signalMatrix; 
        
    end
%%
    allM = cellfun(@(L) size(L,1), allLetterTemplates);
    allN = cellfun(@(L) size(L,2), allLetterTemplates);
    maxM = max(allM);
    maxN = max(allN);
    
    
    for xi = 1:nX
        pad_T = floor( (maxM - allM(xi)) /2);
        pad_B = maxM - allM(xi) - pad_T;
        pad_L = floor( (maxN - allN(xi)) /2);
        pad_R = maxN - allN(xi) - pad_L;
        allLetterTemplates_padded{xi} = padarray(  padarray(allLetterTemplates{xi}, [pad_T, pad_L], 'pre'), [pad_B, pad_R], 'post');
        
    end

    %%
    for xi = 1:nX

        logTh_initGuess = 1;
        logStd_initGuess = 2.5;

        Q0 = log10(gaussian(allLogSNRs, logTh_initGuess, logStd_initGuess) ); 
        

        nClasses = length(allSignals{xi});
        gamma = 1/nClasses;
        delta = 0.01;
        weibull = @(params, c) ((1-delta) - ((1-delta)-gamma).* exp (- (( (c) ./params(1)).^(params(2)) ) ) );
        psi0 = @(x) weibull([1 1], 10.^(x));    


        
%         imageScaleRep = 1;

        redoAll = exist('redoFlag', 'var') && isequal(redoFlag, 1);

        haveData = exist(fn_response{xi}, 'file') && ~redoAll;
        havePartialData = 0;

        fprintf('Using file : %s\n', fn_response_base{xi})
        if haveData
            S_loaded = load(fn_response{xi});
            S{xi} = S_loaded;

            if ~isequal(S{xi}.allLogSNRs, allLogSNRs)
                
                havePartialData = true;
%                 beep;
%                 fprintf('Saved data has different set of SNRs - restarting ...\n')
                3;
                idx_copyTo = binarySearch(allLogSNRs, S_loaded.allLogSNRs);
                idx_copyTo_use = abs( allLogSNRs(idx_copyTo) -  S_loaded.allLogSNRs ) < 1e-6;
                idx_copyTo = idx_copyTo(idx_copyTo_use);
            end
            
            if ~isfield(S{xi}, 'snr_th')
                S{xi}.snr_th = nan;
            end
            if ~isfield(S{xi}, 'snr_th_ci')
                S{xi}.snr_th_ci = [nan, nan];
            end
        end

     
        
       q{xi} = quest([], 'init', allLogSNRs, Q0, psi0);        
        Q{xi} = QuestCreate(logTh_initGuess, logStd_initGuess, pThreshold, quest_beta, quest_delta, quest_gamma, quest_grain, quest_range);
        3;
        
        if ~haveData  || havePartialData
            S{xi}.true_labels = cell(1,nSNRs);
            S{xi}.responses_snr = cell(1,nSNRs);

            S{xi}.nCorrect_snr = zeros(1,nSNRs);
            S{xi}.nTrials_snr = zeros(1,nSNRs);

            S{xi}.pCorrect_snr = nan(1,nSNRs);
            S{xi}.stderr_snr = zeros(1,nSNRs);
            S{xi}.pCorrectOK = false(1,nSNRs);
            
            S{xi}.trial_idx = 0;
            S{xi}.allLogSNRs = allLogSNRs;
            S{xi}.snr_th = nan;
            S{xi}.snr_th_ci = [nan, nan];
            
            if havePartialData
                S{xi}.true_labels(idx_copyTo)   = S_loaded.true_labels;
                S{xi}.responses_snr(idx_copyTo) = S_loaded.responses_snr;
                
                S{xi}.nCorrect_snr(idx_copyTo)  = S_loaded.nCorrect_snr;
                S{xi}.nTrials_snr(idx_copyTo)   = S_loaded.nTrials_snr;
                
                S{xi}.pCorrect_snr(idx_copyTo)  = S_loaded.pCorrect_snr;
                S{xi}.stderr_snr(idx_copyTo)    = S_loaded.stderr_snr;
                S{xi}.pCorrectOK(idx_copyTo)    = S_loaded.pCorrectOK;
                
                S{xi}.trial_idx  = S_loaded.trial_idx;
                S{xi}.snr_th     = S_loaded.snr_th;
                S{xi}.snr_th_ci  = S_loaded.snr_th_ci;
            end
        end

        % Re-establish quest function (if have saved data)
        for snr_i = 1:nSNRs
            for tr_i = 1: S{xi}.nCorrect_snr(snr_i)  % successes
                q{xi} = quest(q{xi}, 'add_trial', allLogSNRs(snr_i), 1);
                Q{xi} = QuestUpdate(Q{xi},allLogSNRs(snr_i),1);
            end
            for tr_i = 1: (S{xi}.nTrials_snr(snr_i) - S{xi}.nCorrect_snr(snr_i))  % failures
                q{xi} = quest(q{xi}, 'add_trial', allLogSNRs(snr_i), 0);
                Q{xi} = QuestUpdate(Q{xi},allLogSNRs(snr_i),0);
            end        
        end

    end
    
    
    
    if getIdealObserverThresholds
        
        %%
        
        allIdeal_thresholds = nan(nX,1);
               
        for xi = 1:nX
            if strcmp(expName, 'Channels')
                fontName_i = fontNameDefault;
            elseif strcmp(expName, 'Complexity')
                fontName_i = allFontNames{xi};
            elseif strcmp(expName, 'Grouping')
                fontName_i = [snakesFontName allFontNames{xi}];         
            end
            
            ideal_file_name_base = getIdealObserverFileName(fontName_i, nan, noisyLetterOpts);
            ideal_file_name = [dataFolder_response ideal_file_name_base];
            
            if ~exist(ideal_file_name, 'file')
            
                nSamplesTest = 500;
                idealObserverSNRs = [-1:.5:5];
                nSNRs_ideal = length(idealObserverSNRs);
                

                propCorrectLetter = zeros(1, nSNRs_ideal);

                noisySet.signal = allSignals{xi};
                allParams{xi}.signalContrast = 1;
                allParams{xi}.varyContrast = 'noise';

                noisySet.labels = randi(nClasses, 1, nSamplesTest);
                nNoiseSamplesTot = size(allNoiseImages{xi}, 3);

                inputSignalMatrix = cat(3, allSignals{xi}(noisySet.labels).image);
                inputNoiseMatrix = allNoiseImages{xi}(:,:, randi(nNoiseSamplesTot, 1, nSamplesTest));
                %%
                fprintf('\n\n ** %s **\n', ideal_file_name_base);
                for snr_i = 1:nSNRs_ideal
                    cur_snr = idealObserverSNRs(snr_i);
                    fprintf('SNR = %.1f : ', cur_snr);

                    [signalContrast, noiseContrast] = getSignalNoiseContrast(cur_snr, allParams{xi});

                    noisySet.inputMatrix = inputSignalMatrix * signalContrast + inputNoiseMatrix * noiseContrast;                
                    
                    [propCorrectLetter(snr_i)] = calcIdealPerformanceForNoisySet(noisySet);

                end
                %%
                S_ideal_i.propCorrectLetter = propCorrectLetter;
                S_ideal_i.ideal_threshold = getSNRthreshold(idealObserverSNRs, propCorrectLetter); 
                save(ideal_file_name, '-struct', 'S_ideal_i');
            else
                S_ideal_i = load(ideal_file_name);
            end
            
            allIdeal_thresholds(xi) = S_ideal_i.ideal_threshold;

            
        end
    end

    
    
    %%
    globalCLims = []; %-2.8, 2.8];
    if isempty(globalCLims)
        %%
        nToSampleForMax = 200;
        allLims = cellfun(@(allIm) lims(allIm(:,:, 1:min(nToSampleForMax, size(allIm,3)) )), allNoiseImages, 'un', 0);
        globalCLims = lims( cat(2, allLims{:}) );
    end 
    %%
    
    
    nGrayLevels = 256;
%     levs = linspace(globalCLims(1), globalCLims(2), nGrayLevels+1);
    minPossibleContrast = diff(globalCLims)/(nGrayLevels);
    
   
    %%
%     for noise_i = 1:nNoises
%         %%
%         noiseIms = allNoiseImages{noise_i};
%         [nRow, nCol, nIm] = size(noiseIms);
%         noiseIms = reshape(noiseIms, nRow*nCol, nIm);
%         %%
%         noiseIms_rms{noise_i} = rms(noiseIms, 1);
%         
%     end
    
    %%
    
    %%
    stim_fig = 123;
    psych_fig = 124;
    threshold_fig = 125+10;
    
    channel_fig = 126;
    efficiency_fig = 127;
    template_fig = 128;
    
    figure(stim_fig); clf;
    h_ax_image = subplot(1,1,1);
    h_im = imagesc(zeros(5));
    cmap = gray(256);
    colormap(cmap); ticksOff;
    set(stim_fig, 'color', 'k');
    
    if showLetterTemplates
        %%
        figure(template_fig); clf;
        if nClasses == 10
            [tmp_m, tmp_n] = deal(2,5);
        elseif nClasses == 26
            [tmp_m, tmp_n] = deal(3,9);
        end

        for i = 1:nClasses            
            h_ax_templates(i) = subplotGap(tmp_m, tmp_n, i);
            h_im_templates(i) = imagesc(allLetterTemplates_padded{xi}(:,:,i));
            h_tmp_title(i) = title( upperLower_func (allLetterChars(i)), 'fontsize', 20, 'color', 'w' );
            ticksOff;
            3;
        end
        set(template_fig, 'color', 'k');
        colormap(cmap);
        imageToScale;

        updateLetterTemplates = any(strcmp(expName, {'Grouping', 'Complexity'}));
    end
    
    
    
    showNCorrectText = 1;
    showNTrialsText = 1;
%%

    doSimulatedHuman = false;
    nSamplesToDo = 20;
    powerInHumanChannels = zeros(nSamplesToDo,nX);
    
    
    if doSimulatedHuman
        
        %%
        cycPerLet_centFreq = 3;
        humanChannelWidth_oct = 1;

%         fontheight_use = fontXheight;
%         [~, fontXheight, ~] = getFontSize(fontName, fontSize);
                
        fontheight_use = fontXheight; % if have x-height, use that.
        cycPerLet_range = cycPerLet_centFreq * [1/(sqrt(2)*humanChannelWidth_oct), sqrt(2)*humanChannelWidth_oct];
        cycPerPix_range = cycPerLet_range / fontheight_use;
    
        mask_fftshifted = fourierMask(imageSize, cycPerPix_range, 'band_cycPerPix');
        human_fourierMask = ifftshift(mask_fftshifted);
        %%
        
        progressBar('init-', nSamplesToDo*nX);
        for xi = 1:nX
            
            for samp_j = 1:nSamplesToDo
                im_j = allNoiseImages{xi}(:,:,samp_j);
                prod_fourier = ifftshift(  human_fourierMask .* fft2( im_j ) );
                noise_filtered = ifft2( human_fourierMask .* fft2( im_j ), 'symmetric');
                powerInHumanChannels(samp_j, xi) = rms(noise_filtered(:))^2;
                3;
%             powerInHumanChannel =  
                progressBar;
            end
        end
        progressBar('done');
        3;
        
    end
    
    

    %%
   
    figure(psych_fig); clf;
    subN = ceil(sqrt(nX)/1.5);
    subM = ceil(nX/subN);
    [h_psych_axes, h_psych_curve, h_psych_curve_err, h_weibull_fit, h_psych_tit] = deal( zeros(1, nX));
    for xi = 1:nX
        h_psych_axes(xi) = subplotGap(subM, subN, xi);
        cla; hold on; box on;
        h_psych_curve_err(xi) = errorbar(allLogSNRs, S{xi}.pCorrect_snr, S{xi}.stderr_snr, 'g-');
        h_psych_curve(xi) = plot(allLogSNRs, S{xi}.pCorrect_snr, 'bo-', 'linewidth', 2);
        h_weibull_fit(xi) = plot(0, 0, 'r-');
        h_psych_tit(xi) = title(' ');
        h_psych_line(xi) = line([1 1], [0 1], 'linewidth', 2, 'color', 'k');
        h_psych_line2(xi) = line(10*[-1, 1], pThreshold*[1,1], 'linewidth', 2, 'color', 'k');
        set(h_psych_axes(xi), 'ylim', lims([0, 1], .02), 'xlim', lims(allLogSNRs, .02)); %, 'xtick', allLogSNRs );
        

    %%
        for i = 1:nSNRs
            if S{xi}.nTrials_snr(i) == 0
                str_top = ' '; 
                str_bot = ' ';
            else
                str_top = sprintf('%d', S{xi}.nCorrect_snr(i));
                str_bot = sprintf('%d', S{xi}.nTrials_snr(i));
            end
            if showNCorrectText
                h_txt_top{xi}(i) = text(allLogSNRs(i), 0.05, str_top, 'horiz', 'cent', 'vert', 'bot', 'parent', h_psych_axes(xi), 'fontsize', 7);
            end
            if showNTrialsText
                h_txt_bot{xi}(i) = text(allLogSNRs(i), 0, str_bot, 'horiz', 'cent', 'vert', 'bot', 'parent', h_psych_axes(xi), 'fontsize', 7);
            end
        end
    end
    
    
    figure(threshold_fig); clf; hold on; box on;
    
    allThresholds = cellfun(@(c) c.snr_th, S);
    allThresholds_ci = cellfun(@(c) c.snr_th_ci, S, 'un', 0);
    allThresholds_ci = vertcat(allThresholds_ci{:});
    allThresholds_quest = nan(1, nX);
    allThresholds_quest_ci = nan(2, nX);
    colors_quest = [0 0 .7; .7 0 0; 0 .7 0];  markersize_quest = 12; %'br'; 
    colors_fit   = [.3 .3 1; 1 .3 .3; .3 1 .3];  markersize_fit = 6;
    colors_human = [.4 .3 1; 1 .3 .4];  markersize_fit = 6;
    
    powerInHumanChannels_m = mean(powerInHumanChannels,1);
    human_scale_factor = channel_opt.whiteNoiseTh / max(powerInHumanChannels_m);
    for curve_i = 1:nCurves
        idx = curve_idxs{curve_i};
        h_threshold_curve_quest(curve_i) =  errorbar(allX_plot(idx), allThresholds_quest(idx), allThresholds_quest_ci(1,idx), allThresholds_quest_ci(2,idx), ...
            's:', 'markersize', markersize_quest, 'color', colors_quest(curve_i,:), 'linewidth', 2 ); %#ok<AGROW>
        h_threshold_curve_fit(curve_i) = errorbar(allX_plot(idx), allThresholds(idx), allThresholds_ci(idx,1), allThresholds_ci(idx,2), ...
            'o-', 'markersize', markersize_fit,   'color', colors_fit(curve_i,:), 'linewidth', 1  );  %#ok<AGROW>
        h_threshold_ax = gca;
    
        if doSimulatedHuman
            h_sim_human(curve_i) = plot(allX_plot(idx), powerInHumanChannels_m(idx)*human_scale_factor, '*-', 'markersize', 7, 'color', colors_human(curve_i,:), 'linewidth', 1);  %#ok<NASGU,AGROW>
        end   
        
        if  getIdealObserverThresholds
%             h_threshold_ideal = plot(allX_plot(idx), allIdeal_thresholds(idx), 'k-');  %#ok<NASGU,AGROW>
        end
        3;
%         legend([h_threshold_curve_quest, h_sim_human], {'My Thresholds [Lo]', 'My Thresholds [Hi]', 'Sim. thresholds (2 oct) [Lo]', 'Sim. thresholds (2 oct) [Hi]'}, 'location', 'NW')

    end
    
    
    if nCurves > 1 && doSimulatedHuman
%         h_sim_human(3) = plot(allCycPerLet, (powerInHumanChannels_m(curve_idxs{1}) + powerInHumanChannels_m(curve_idxs{2}) )*human_scale_factor, 'v-', 'markersize', 7, 'color', 'k', 'linewidth', 1);  %#ok<NASGU,AGROW>

    end
        
    
      
    title(sprintf('%s (%s)', userName,fontNameDefault), 'interp', 'none');
    
    if strcmp(expName, 'Channels')

        %%
        logCycPerLet_lims = lims( log2( allCycPerLet) );

        dxtick = 1;
        xticks =  2 .^ [floor(logCycPerLet_lims(1)) : dxtick : ceil(logCycPerLet_lims(2) )];

        set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(allCycPerLet(:), .05, 1, 1), 'xtick', xticks, 'xticklabel', arrayfun(@(x) sprintf('%.1f', x), xticks, 'un', 0));
        xlabel('cycles per letter'); ylabel('Threshold');

        if strcmp(noiseMode, 'hi&lopass')
            legend(h_threshold_curve_quest, {'lo', 'hi'}, 'location', 'SE')
        end
        3;
        %%
        showTextNumbers = 1;
        if ~showTextNumbers
            set([h_txt_top{xi}, h_txt_bot{xi}], 'visible', 'off')
        end
        
        rescale_factors = 540 ./(allCycPerLet.^2);    
    
    elseif strcmp(expName, 'Complexity')

        complexity_xlims = [10, 1000];
%         efficiency_ylims = [.01 1];
%         dxtick = 1;
%         xticks = log[ 2 .^ [floor(logCycPerLet_lims(1)) : dxtick : ceil(logCycPerLet_lims(2) )];

        set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', complexity_xlims);
        xlabel('Complexity'); ylabel('Threshold');

%         %%
%         showTextNumbers = 1;
%         if ~showTextNumbers
%             set([h_txt_top{xi}, h_txt_bot{xi}], 'visible', 'off')
%         end
%         
%         rescale_factors = 540 ./(allCycPerLet.^2);    
        
        
    elseif strcmp(expName, 'Grouping')
                %%
        set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', ...
            'xlim', wiggle_lims, 'xtick', wiggle_ticks, 'xticklabel', wiggle_tick_labels ...
            );
        xlabel('Wiggle'); ylabel('Threshold');
        
        
    end
    let_offset = 'a' - 1;
    
    
    
    
    
     doChannelFig = strcmp(expName, 'Channels') && (strcmp(noiseMode, 'hi&lopass') || strcmp(noiseMode, 'bandpass'));
    cols = 'br';
    if doChannelFig
        ch_f  = zeros(1, length(allCycPerLet)-1);
        
        if strcmp(noiseMode, 'bandpass')
            channel_fig = channel_fig + 1;
        end
        figure(channel_fig); clf; hold on; box on;
        for curve_i = 1:nCurves
            h_channel(curve_i) = plot(ch_f, zeros(size(ch_f)),     [cols(curve_i) 'o-'], 'linewidth', 2);                    %#ok<AGROW>
            h_channel_sim(curve_i) = plot(ch_f, zeros(size(ch_f)), [cols(curve_i) '*-']);                        %#ok<AGROW>
        end
        
        h_channel_ax = gca;
        set(h_channel_ax, 'yscale', 'log', 'xscale', 'log', 'xlim', lims(allCycPerLet(:), .05, 1, 1));
        
        xlabel('Cycles Per Letter'); ylabel('Gain');
%         title('Channels from Hi/Lo pass noise');
    end

    
    
    doEfficiencyFig = any(strcmp(expName, {'Grouping', 'Complexity'}));
    if doEfficiencyFig
        
      
        
        figure(efficiency_fig); clf; 
        allEfficiencies = nan(1, nX);
        allEfficiencies_ci = nan(2, nX);
       
        for curve_i = 1:nCurves
            idx = curve_idxs{curve_i};
            h_efficiency_curve(curve_i) =  errorbar(allX_plot(idx), allEfficiencies(idx), allEfficiencies_ci(1,idx), allEfficiencies_ci(2,idx), ...
                's:', 'markersize', markersize_quest, 'color', colors_quest(curve_i,:), 'linewidth', 2 ); %#ok<AGROW>
            hold on;
            h_efficiency_ax = gca;

        end

        %%
        set(h_efficiency_ax, 'xscale', efficiency_plot_scale, 'yscale', efficiency_plot_scale);
        
        if strcmp(expName, 'Grouping')
            xlab = 'Wiggle';
            
            if strcmp(efficiency_plot_scale, 'log')
                set(h_efficiency_ax, 'xlim', wiggle_lims, 'xtick', wiggle_ticks, 'xticklabel', wiggle_tick_labels, ...
                    'ylim', [.002, .5] ...
                    );
            elseif strcmp(efficiency_plot_scale, 'linear')
                set(h_efficiency_ax, 'xlim', wiggle_lims, 'xtick', wiggle_ticks, 'xticklabel', wiggle_tick_labels, ...
                    'ylim', [.0, .1] ...
                    );
            end
            
            
        elseif strcmp(expName, 'Complexity')
            xlab = 'Complexity';
            complexity_xlims = [10, 1000];
            efficiency_ylims = [.01 1];
             set(h_efficiency_ax, 'xlim', complexity_xlims, ...
                    'ylim', efficiency_ylims ...
                    );
            
            h_ep_line_paper = plot(10,1, 'k:', 'linewidth', 1);
            h_ep_line = plot(10,1, 'r-', 'linewidth', 2);
            h_eff_title = title('');
                
        end
        
       
%%
        xlabel(xlab); ylabel('Efficiency');

        showHumanWiggleFitData = strcmp(expName, 'Grouping');
        if showHumanWiggleFitData
            
             x_wiggle_fit = xtick_wig0:1:100;
             if strcmp(efficiency_plot_scale, 'log')
                 n0 = 0.074;
                 w0 = 15;
                 y_func = @(w) n0 ./ max(1, w/w0); 
                 
             else
                 beta_clipped0 = [9.1501   43.9847    0.0710    0.0189];
                 y_func = @(w) clippedLine(beta_clipped0, w);                  
                 
             end
             y_efficiency_fit = y_func(x_wiggle_fit);
                 
             plot(x_wiggle_fit, y_efficiency_fit, 'r-');

%              set(gca, 'xlim', [8, 100], 'yscale', 'log', 'xscale', 'log', 'xtick', [1, 10:10:90], )
        end     
        3;
%         legend([h_threshold_curve_quest, h_sim_human], {'My Thresholds [Lo]', 'My Thresholds [Hi]', 'Sim. thresholds (2 oct) [Lo]', 'Sim. thresholds (2 oct) [Hi]'}, 'location', 'NW')

        
        
    end
    
    
    
    
    
    dTh = nan;
    
    min_pCorrectToStop = 0.2; 
    dTh_threshold = 0.01;
    minNtrials = 5;
      
    
    requireEnter = 0;
    
    enforceTimeout = false;
        timeoutDelay_sec = 0.5;
    
    offset_max = 2;
    offset_after_NTrials = 30;
    
    
%     global_band_eachTrial = [];
    stayOnSameNoiseForNTrials = 40;
    initialBiasForHighSignal = 1;
    
    all_trial_idxs = cellfun(@(c) c.trial_idx, S);
    global_trial_idx = sum( all_trial_idxs);
    x_order = 1:nX; %randperm(nNoises);
    x_order_idx = 1;
    x_idx = x_order(1);

    firstTime = true;
    
    global noise_order_idx_manual
    global cheatMode
    
    doPermOrder = false;
    permOrders_C = arrayfun(@(i) randperm(nClasses), 1:100, 'un', 0);
    permOrders = [permOrders_C{:}];
    x_order_idx_prev = nan;
    cur_snr_idx_manual = [];
    
    while true %nTrials
        
        
        if ~firstTime

            all_trial_idxs = cellfun(@(c) c.trial_idx, S);            
            x_order_idx = indmin ( floor( all_trial_idxs/stayOnSameNoiseForNTrials ) );
            
            if ~isempty(noise_order_idx_manual)
                x_order_idx = noise_order_idx_manual;
            else
%                 x_order_idx = 1;
            end
            
            
            x_idx = x_order(x_order_idx);
 
            curTrialIdx = S{x_idx}.trial_idx;
            global_trial_idx = sum( all_trial_idxs);
    
%            x_order_idx = mod( ceil(global_trial_idx / stayOnSameNoiseForNTrials), nNoises);
%            
%            if mod(global_trial_idx, stayOnSameNoiseForNTrials) == 0 % adjust noise band               
%                x_order_idx =   x_order_idx + 1;
%                if x_order_idx > nNoises
%                    x_order_idx = 1;
%                end
% %                all_trial_idxs = cellfun(@(c) c.trial_idx, S);        
% %                 wgts = 5 + max(all_trial_idxs) - all_trial_idxs;
% %                 x_idx = randsample(1:nNoises, 1, true, wgts);
%            end

%             global_band_eachTrial(global_trial_idx) = x_idx;
    %         x_idx = randi(nNoises);
            

%             if ~any(S{x_idx}.pCorrectOK & S{x_idx}.pCorrect_snr == 1)
%                 cur_snr_idx = nSNRs;
%             else
            if useMyQuestForNextTrial
                cur_snr_idx = quest(q{x_idx}, 'next_trial');
            else
                cur_logsnr_guess = QuestMean(Q{x_idx});
                cur_snr_idx = indmin( abs(cur_logsnr_guess - allLogSNRs));
            end
            if initialBiasForHighSignal && curTrialIdx < 5
                cur_snr_idx = cur_snr_idx + 5;
            end
            cur_snr_idx = max(min(cur_snr_idx, nSNRs), 1);
                
                
                
%             end
%             cur_snr_idx_guess = cur_snr_idx;
            
            % after 15 trials, have a good estimate of threshold, add some
            % variation so we can estimate beta, too.

            if curTrialIdx > offset_after_NTrials
                doEvenly = curTrialIdx > 40;
                if doEvenly
                    %%
                    allNTrials_near_th =  S{x_idx}.nTrials_snr(cur_snr_idx + [-offset_max:offset_max]);
                    [minNTrial, rel_offset] = min(allNTrials_near_th) ;
                    offset = -offset_max + rel_offset - 1;
                    assert(S{x_idx}.nTrials_snr(cur_snr_idx + offset) == minNTrial)
                else
                    offset = randi(2*offset_max+1)-offset_max-1;
                end
                cur_snr_idx = cur_snr_idx + offset;
            end
    %         offset = 0;
            if ~isempty(cur_snr_idx_manual)
                cur_snr_idx = cur_snr_idx_manual;
            end
    
            snr_trial_idx = S{x_idx}.nTrials_snr(cur_snr_idx)+1;

    %         cur_snr_idx = cur_snr_idx + offset;
            cur_logsnr = allLogSNRs(cur_snr_idx);


            allParams{x_idx}.varyContrast = 'signal';
            allParams{x_idx}.signalContrast = 1;
            
            
            [signalContrast, noiseContrast] = getSignalNoiseContrast(cur_logsnr, allParams{x_idx});
            
%             [signalContrasts, noiseContrasts] = arrayfun(@(logsnr) getSignalNoiseContrast(logsnr, params), allLogSNRs);
            
            belowMin = signalContrast < minPossibleContrast;
%             minPossibleContrast
            
            3;
            if ~doPermOrder
                curLabel = randi(nClasses);
            else
                curLabel = permOrders(1);
                permOrders = permOrders(2:end);
            end
            
%             noiseImage = allNoiseImages{x_idx}(:,:,S{x_idx}.trial_idx);
            noiseIdx_use = randi( size(allNoiseImages{x_idx}, 3) );
            noiseImage = allNoiseImages{x_idx}(:,:,noiseIdx_use);

            randShift_x = randi(imageSize(1));
            randShift_y = randi(imageSize(2));
            noiseImage = circshift(noiseImage, [randShift_x, randShift_y]);
            
            curStim = allSignals{x_idx}(curLabel).image * signalContrast + noiseImage * noiseContrast;

            
            blankChar = char(1);

            if keepAbsContrastFixed
                curLims = globalCLims;
            else  
                curLims = max(abs(curStim(:))) * [-1, 1];
            end
            
            
            if updateLetterTemplates && (x_order_idx ~= x_order_idx_prev)
                %%
                for let_i = 1:length(allLetterChars)
                    allLets_i = allLetterTemplates_padded{x_idx};
                    set(h_im_templates(let_i), 'xdata', 1:size(allLets_i,2), 'ydata', 1:size(allLets_i,1), 'cdata', allLets_i(:,:,let_i));
                    upperLower_func_i = iff(isUppercaseFont_func(allFontNames{x_idx}), @upper, @lower);

                    set(h_tmp_title(let_i), 'string', upperLower_func_i(allLetterChars(let_i)) );
                end
                3;
                imageToScale;
            end            
            
            set(h_im, 'cdata', curStim);
            xlims = [0, size(curStim,2)]+.5;
            ylims = [0, size(curStim,1)]+.5;
            set(h_ax_image, 'xLim', xlims, 'ylim', ylims, 'cLim', curLims/(contrast_pct/100) );
            imageToScale(h_ax_image, imageScaleRep);
            colormap(gray(nGrayLevels));
            tStart = tic;
            tElapsed = 0;
            t_step_sec = 0.05;

            allFigIDs = get(0, 'children');
%%
            set(allFigIDs, 'CurrentCharacter', blankChar);
            figure(stim_fig);
            response_label = 0;
            cheat_str = iff(~isempty(cheatMode) && cheatMode == 1, sprintf('[%s]', curLabel + let_offset), '');
            options_str = '';
            if ~isequal(allLetterChars, allLetterChars_full)
                options_str = ['{' allLetterChars '}']; 
            end
            fprintf('Which letter %s ?%s%s ', options_str, cheat_str, iff (belowMin, '[!]', ''));

            allowBackspace = 0;
            didBackspace = false;

            
            while isempty(response_label) || ~( ibetween(response_label, 1, nClasses)  || didBackspace)
            
    %             backspace(5);
                set(allFigIDs, 'CurrentCharacter', blankChar);
                
                figure(stim_fig)
                curChar = get(gcf, 'CurrentCharacter');

                while strcmp(curChar, blankChar) 
                    pause(t_step_sec);
                    tElapsed = toc(tStart);
                    if enforceTimeout &&  (tElapsed > timeoutDelay_sec)
                        set(h_im, 'cdata', curStim*nan);
                        while waitforbuttonpress ~= 1  % wait for keypress

                        end
                    else
    %                     fprintf('[%.1f]', tElapsed);
                    end

                    curChar = get(gcf, 'CurrentCharacter');
                end

                if strcmp(curChar, ' ') % space bar = display image again for  the appropriate amount.
                    set(gcf, 'CurrentCharacter', blankChar);
                    tStart = tic;
                    set(h_im, 'cdata', curStim);
                    continue;
                end

                3;
    %                 if enforceTimeout
    %                     
    %                     pause(timeoutDelay_sec)
    %                     
    %                     
    %                 end
    %                 
    %                 while waitforbuttonpress ~= 1
    %                    % wait for key press -> outputs 1 
    %                 end

    %                 
    %                 if enforceTimeout && (tElapsed > timeoutDelay_sec)
    %                     set(h_im, 'cdata', curStim*0);
    %                     while ~waitforbuttonpress 
    %                         
    %                     end
    %                 end

                
                response_char = get(gcf, 'CurrentCharacter');
                response_char = lower(response_char);
                response_label = response_char - let_offset;
                if strcmp(expName, 'Grouping')
                    response_label = binarySearch(find(lettersInDataset), response_label, 1, 0);
                end
                
                
                
                if isempty(response_label)
                    continue;
                end
                
                if strcmp(response_char, '1')
                    keyboard;
                end
                if double(response_char) == 8  && ~firstTime && allowBackspace% backspace
                    didBackspace = true;
                end


            end

            tf_success = response_label == curLabel;
            
            showCorrectChar= 1;
            correct_char_str = '';
            if showCorrectChar && ~tf_success
                idx = find(lettersInDataset);
                correct_char_str = sprintf('{%s}', allLetterChars_full(idx(curLabel)));
            end
            
            fprintf('[%s]%s\n', upperLower_func(response_char), upperLower_func(correct_char_str) );
            set(h_im, 'cdata', curStim*0);

            if enforceTimeout
                
            end
            set(h_im, 'cdata', curStim*nan);
            pause(0.3);

            if didBackspace
                
                
            end
            %%
            S{x_idx}.responses_snr{cur_snr_idx}(snr_trial_idx) = response_label;
            S{x_idx}.true_labels{cur_snr_idx}(snr_trial_idx) = curLabel;

            
            if tf_success
                S{x_idx}.nCorrect_snr(cur_snr_idx) = S{x_idx}.nCorrect_snr(cur_snr_idx)+1;        
            else

            end

            S{x_idx}.nTrials_snr(cur_snr_idx) = S{x_idx}.nTrials_snr(cur_snr_idx)+1;
            %%
            q{x_idx} = quest(q{x_idx}, 'add_trial', cur_logsnr, tf_success);
            Q{x_idx} = QuestUpdate(Q{x_idx}, cur_logsnr, tf_success );

    %         if S{x_idx}.nTrials_snr(cur_snr_idx) < minNtrials 
    %             continue;
    %         end
            %%
            
       

            nCorr_i = S{x_idx}.nCorrect_snr(cur_snr_idx);
            nT = S{x_idx}.nTrials_snr(cur_snr_idx);

            pCorr_i = nCorr_i / nT;
            stderr_pcorrect = sqrt( pCorr_i * (1 - nCorr_i) / nT );

            S{x_idx}.pCorrect_snr(cur_snr_idx) = pCorr_i;
            S{x_idx}.stderr_snr(cur_snr_idx)  = stderr_pcorrect;

            S{x_idx}.pCorrectOK = S{x_idx}.nTrials_snr >= minNtrials ;% & S{x_idx}.stderr_snr < 0.1;
            noise_idxs_update = x_idx;
            
        else
             noise_idxs_update = 1:nX;
             
        end
            
        for xi = noise_idxs_update

            if S{xi}.trial_idx > 0
                if useMyQuestForThresholdEst
                    [snr_quest, snr_quest_ci] = quest(q{xi}, 'estimate');
                    snr_quest_LU = [snr_quest - snr_quest_ci(1); snr_quest_ci(2)-snr_quest];
                else

                    logsnr_quest = QuestMean(Q{xi});
                    snr_quest = 10.^logsnr_quest;

                    logsnr_quest_std = QuestSd(Q{xi});
                    snr_quest_LU  = abs( 10.^( logsnr_quest + logsnr_quest_std * [-1, 1]) - snr_quest );
                end            


                allThresholds_quest(xi)       = snr_quest;
                allThresholds_quest_ci(:, xi) = snr_quest_LU ;
            else
                snr_quest = nan;
            end
            
            
            for curve_i = 1:nCurves
                idx = curve_idxs{curve_i};
                set(h_threshold_curve_quest(curve_i), 'ydata', allThresholds_quest(idx)', 'ldata', allThresholds_quest_ci(1,idx)', 'udata', allThresholds_quest_ci(2,idx)' );
                
                if doEfficiencyFig
                    
                       set(h_efficiency_curve(curve_i), 'ydata', allIdeal_thresholds(idx) ./ allThresholds_quest(idx)', ...
                                                    'ldata', nan(size(allIdeal_thresholds(idx))), ... allIdeal_thresholds(idx) ./ allThresholds_quest_ci(1,idx)', ...
                                                    'udata', nan(size(allIdeal_thresholds(idx))) );... allIdeal_thresholds(idx) ./ allThresholds_quest_ci(2,idx)');
                end
                
            end

            
            3;
            %%
            idx_use = ~isnan(S{xi}.pCorrect_snr) & (S{xi}.nTrials_snr >= minNtrials);
            if any(S{xi}.pCorrect_snr(find(idx_use, 1)) < pThreshold) && nnz(idx_use) >= 4
                %%
                snr_opt.assumeMax100pct = 1;
                [snr_th, bestFitFunc, snr_th_ci, params_fit] = getSNRthreshold(allLogSNRs(idx_use), S{xi}.pCorrect_snr(idx_use), snr_opt);
                weibull_slope = params_fit(end);
    %             idx_use = log10(allSNRs) > 
                if ~isempty(bestFitFunc)
                    all_pCorr_fit =  bestFitFunc(allSNRs)/100;

                    dTh = diff(snr_th_ci) / snr_th;
                else
                    all_pCorr_fit = nan(size(allSNRs));
                    dTh = nan;
                end
            else
                snr_th = nan;
                snr_th_ci = [nan, nan];
            end
            %%
            S{xi}.snr_th = snr_th;
            S{xi}.snr_th_ci = snr_th_ci;
            allThresholds(xi) = snr_th;
            allThresholds_ci(xi,:) = snr_th_ci;
            minVal = .1;
            yDist = max(allThresholds' - allThresholds_ci(:,1), minVal);
            allThresholds_ci(:,1) = allThresholds' - yDist;
%             allThresholds_ci(:,1) = allThresholds_ci(:,1) - max(allThresholds - allThresholds_ci(:,1), minVal)

            for curve_i = 1:nCurves
                idx = curve_idxs{curve_i};
                set(h_threshold_curve_fit(curve_i), 'ydata', allThresholds(idx));
                set(h_threshold_curve_fit(curve_i), 'ldata', allThresholds_ci(idx,1));
                set(h_threshold_curve_fit(curve_i), 'udata', allThresholds_ci(idx,2));
                
            end
            
            if doChannelFig
                %%
                f = allCycPerLet;
                if strcmp(noiseMode, 'hi&lopass')
                    
                    th_lo = allThresholds_quest(idx_lo);
                    th_hi = allThresholds_quest(idx_hi);

                    [ch_f, ch_Gain_lo] = getChannelFromThresholds(f, th_lo, 'lo', channel_opt);
                    [ch_f, ch_Gain_hi] = getChannelFromThresholds(f, th_hi, 'hi', channel_opt);

    %                 ch_Gain_lo(ch_Gain_lo <= 0) = nan;
    %                 ch_Gain_hi(ch_Gain_hi <= 0) = nan;
    %                 ch_G2_lo = abs(ch_G2_lo);
    %                 ch_G2_hi = abs(ch_G2_hi);
                    set(h_channel(1), 'xdata', ch_f, 'ydata', ch_Gain_lo);
                    set(h_channel(2), 'xdata', ch_f, 'ydata', ch_Gain_hi);

                    if doSimulatedHuman
                        th_lo_sim = powerInHumanChannels_m(idx_lo);
                        th_hi_sim = powerInHumanChannels_m(idx_hi);

                        [ch_f, ch_Gain_lo_sim] = getChannelFromThresholds(f, th_lo_sim, 'lo', struct('smoothW', 0) );
                        [ch_f, ch_Gain_hi_sim] = getChannelFromThresholds(f, th_hi_sim, 'hi', struct('smoothW', 0) );

                        set(h_channel_sim(1), 'xdata', ch_f, 'ydata', ch_Gain_lo_sim);
                        set(h_channel_sim(2), 'xdata', ch_f, 'ydata', ch_Gain_hi_sim);
                        
                        3;
                    end
                    %%
%                     nSkip = round(length(ch_f)/ 8);
%                     xticks = roundToNearest( ch_f(1:nSkip:end), 0.01);
% %                     set(h_channel_ax, 'xtick', xticks);
%                     set(h_channel_sim, 'xdata', log2(ch_f) );
%                     set(h_channel_ax, 'xscale', 'linear', 'xtickmode', 'auto', 'xlim', log2( lims(ch_f, .05, [], 1) )  );
                    

                elseif strcmp(noiseMode, 'bandpass')
                    
                    if doSimulatedHuman
                        th_sim = powerInHumanChannels_m;
                        [ch_f, ch_Gain_sim] = getChannelFromThresholds(f, th_sim, 'band', struct('smoothW', 0) );
                        set(h_channel_sim, 'xdata', ch_f, 'ydata', ch_Gain_sim);
                    end
                    
                end
                
                %%
                
                
                3;
                
            end
            
           
            
            %%
            S{xi}.trial_idx = sum(S{xi}.nTrials_snr);

            updatePsychCurve = 1;
            if updatePsychCurve

                %%
                pCorr_use = S{xi}.pCorrect_snr(:);
%                 pCorr_use(~S{noise_i}.pCorrectOK) = nan;
                set(h_psych_curve(xi), 'xdata', allLogSNRs(:), 'ydata', pCorr_use(:));
                set(h_psych_curve_err(xi), 'xdata', allLogSNRs(:), 'ydata', pCorr_use(:), 'udata', S{xi}.stderr_snr(:), 'ldata', S{xi}.stderr_snr(:));

                
                
                if firstTime
                    snr_idxs = 1:nSNRs;
                else
                    snr_idxs = cur_snr_idx;
                end
                
                for snr_i = snr_idxs
                    
                    if showNCorrectText
                        nCorr_i = S{xi}.nCorrect_snr(snr_i);
                        set(h_txt_top{xi}(snr_i), 'string', sprintf('%d', nCorr_i), 'visible', 'on');
                    end
                    if showNTrialsText
                        nT_i = S{xi}.nTrials_snr(snr_i);
                        set(h_txt_bot{xi}(snr_i), 'string', iff(nT_i>0, sprintf('%d', nT_i), ''), 'visible', 'on');
                    else
%                         set(h_txt_bot{noise_i}, 'visible', 'off');
                    end
                end
                
                if strcmp(expName, 'Channels')
                    xi_name = sprintf('c/l = %.1f', allCycPerLet_full(xi));
                elseif strcmp(expName, 'Complexity')
                    xi_name = sprintf(allFontNames{xi});
                elseif strcmp(expName, 'Grouping')
                    xi_name = sprintf('wig = %d', allX(xi));
                end
                    
                if ~isnan(snr_th) || ~isnan(snr_quest)
                    if ~isnan(snr_th)
                        th_use = snr_th;
%                         beta_str = sprintf('beta = %.2f', weibull_slope);
                        set(h_weibull_fit(xi), 'xdata', allLogSNRs, 'ydata', all_pCorr_fit);
                    elseif ~isnan(snr_quest)
                        th_use = snr_quest;
%                         beta_str = '';
                    end
                    
%                     set(h_psych_tit(noise_i), 'string', sprintf('c/l=%.1f, nTrials = %d.  Th: %.2f [%.2f - %.2f] (%.2f %%). ', allCycPerLet(noise_i), S{noise_i}.trial_idx, snr_th, snr_th_ci, dTh*100 ))
                    set(h_psych_tit(xi), 'string', sprintf('%s, n=%d. Th:%.2f. LgTh:%.2f', xi_name, S{xi}.trial_idx, th_use, log10(th_use) ));
                    set(h_psych_axes(xi), 'xlim', log10(snr_quest)+0.5*[-1, 1])
                    
                    set(h_psych_line(xi), 'xdata', log10(snr_quest)*[1,1]);
                    

                else
                    set(h_psych_tit(xi), 'string', sprintf('%s. nTrials = %d', xi_name, S{xi}.trial_idx ));
                end
                
            end
           
            
         
            structToSave = S{xi};
            
            save(fn_response{xi}, '-struct', 'structToSave');

            saveAll = 0;
            if saveAll
                %%
                for bnd_i = 1:nX
                    save(fn_response{bnd_i}, '-struct', 'S{bnd_i}');
                end

            end


        end
    
        firstTime = false;
%         global_trial_idx = global_trial_idx + 1;
        3;

        if strcmp(expName, 'Complexity') % update efficiency vs complexity line fit
            %%
            idx_nonnans = find( ~isnan(allThresholds_quest) );
            efficiencies = allIdeal_thresholds(:)' ./ allThresholds_quest(:)';
            if length(idx_nonnans) >= 3
                
                p = polyfit( log10(font_complexities(idx_nonnans)), log10( efficiencies(idx_nonnans) ), 1);
                
                
                comp_xs = logspace(log10(complexity_xlims(1)), log10(complexity_xlims(2)), 20);
                eff_ys = 10.^polyval(p, log10(comp_xs));
                
                
                set(h_ep_line, 'xdata', comp_xs, 'ydata', eff_ys);
                set(h_ep_line_paper, 'xdata', comp_xs, 'ydata', 9.1 ./ comp_xs );
                                
                set(h_eff_title, 'string', sprintf('slope = %.2f', p(1)));
            end
            
            %                 h_ep_line = plot(10,1, 'r-', 'linewidth', 2);
            %                 h_eff_title = title('');
            
        end
%%
        
%         if ~S{x_idx}.pCorrectOK(cur_snr_idx)
%             continue;;
%         end
        
        
%         if ~isnan(dTh) && dTh < dTh_threshold
% %             keyboard;
% %             break;
%         end
% %         if (pCorr > min_pCorrectToStop) && (cur_snr_idx > 1)
%             cur_snr_idx = cur_snr_idx - 1;
%         else
%             break;
%         end
        x_order_idx_prev = x_order_idx;
    end
    





end

function s = fracWithBrac(a, b, addBrackets) 
    if addBrackets
        s1 = '(';
        s2 = ')';
    else
        s1 = '';
        s2 = '';
    end

           
    s = sprintf('%s%d/%d%s', s1, a, b, s2);
end


%{
= [0.5,  0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13];
   0.17, 0.9,  1.4, 16, 129, 103, 124, 21]
                        107, 101, 14, 10  
%}



%}
%%
%{
    % for 32x32
    allCycPerLet = [0.5,   0.8,   1.3,   2.0,    3.2,   5.1,  8.1, 13];
    allTh =        [.21,  .43,   2.03,   12.3,   96.5,  120,  26   8.02];
    
    % for 64x64
    allCycPerLet = [0.5,   0.8,   1.3,   2.0,    3.2,   5.1,   8.1,  13];
    allTh =        [1,     1.5    5.7    11.5   48.7    366.1  116,  11.2 ];    
    betas =         [1      1.79   1.56   1.53   2.01    1.71,  2.2,   ];

    
    % for 144x144, k68
    allCycPerLet = [0.5,   1,       2,      4,       8,          16];
    
    allTh =        [2.09,  5.53,    18.28,  135.3,   333,        20];    
    betas =         [1.66,  1.61,    2.6,    2.06,    1.55,     1.28];    

  

    
%%

%}

