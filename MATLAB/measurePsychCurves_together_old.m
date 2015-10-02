function measurePsychCurves_together(redoFlag)

%{
    c/let    th
    0.5,     .21
    0.8,     .43
    1.3,     2.03
    2.0,     12.3
    3.2,     96.5
    5.1,     120
    8.1,     26
    13];     8.02
%}
%%
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
%}%%
    expName = 'Channels';
%     expName = 'Grouping';

    keepAbsContrastFixed = true;

    contrast_pct = 100;
    nPixelRep = 1;
    
    useMyQuestForNextTrial = 0;
    useMyQuestForThresholdEst = 0;
    
    applyFourierMaskGainFactor_band = 1;
    applyFourierMaskGainFactor_hiLo = 0;
    applyFourierMaskGainFactor_pink = 1;

    switch expName
        case 'Channels',
            %  fontName = 'KuenstlerU';
            fontName = 'Bookman';
            
            fontSize = 'k68';
            imageSize = [144, 144];
            nClasses = 26;

            %       noiseMode = 'bandpass';
                noiseMode = 'hi&lopass';
%             noiseMode = 'white';
            %     noiseMode = '1/f';

                allCycPerLet = [0.5,   1,       2,      4,       8,          16];
    
        %     allCycPerLet = [0.5,   0.71,    1,      1.41,    2,        2.83,    4,      5.66,     8,     11.31,     16];

%             allCycPerLet = [0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.45, 16];
        %     allCycPerLet = [2,  2.83,   4,    5.66,     8,     11.31,     16];
        %     allCycPerLet = [1, 2,  2.83,   4,    5.66,     8];
        %     allCycPerLet = [2];

        case 'Grouping',
            fontName = 'SnakesN';

            fontSize = 'k32';
            imageSize = [64, 64];
            nClasses = 10;

            noiseMode = 'white';
            
            allWiggles_ori    = [0, 10:5:90];
            allWiggles_offset = [0, 10:5:60];

            allWiggleTypes = {'orientation', 'offset'};
            allWiggleAngles = {allWiggles_ori, allWiggles_offset};
            allWiggles = getWiggleList('orientation', allWiggles_ori, 'offset', allWiggles_offset);
            nWiggleTypes = length(allWiggleTypes);
            nWiggles = length(allWiggles);
            
            noiseFilter = struct('filterType', 'white');
    end
            
%     userName = 'az_6';  % for hi/lopass
    userName = 'az_5'; % for bandpass
%     userName = 'az_4'; % for 1/f
    userName = 'az_6'; % for bandpass_norm
%     userName = 'dz_1'; % for bandpass_norm
%     userName = 'az_9'; % for bandpass_norm
    userName = 'az_7'; % for bandpass_norm

        
    if contrast_pct ~= 100
        contrast_str = sprintf('_c%d', contrast_pct);
        userName = [userName contrast_str];
    end
    if ~isempty(nPixelRep) && nPixelRep ~= 1
        pixelRep_str = sprintf('_pixRep%.1f', nPixelRep); 
        userName = [userName pixelRep_str];
    end
    
%     applyFourierMaskGainFactor = switchh(noiseMode, {'bandpass', 'hi&lopass', 'white', '1/f'}, [...
%         applyFourierMaskGainFactor_band, applyFourierMaskGainFactor_hiLo, 0, applyFourierMaskGainFactor_pink]);

    
%     norm_str = iff(applyFourierMaskGainFactor, '_NORM', '');
%     userName = [userName];

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

    logSNR_load = 0;

    
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
    [fontPointSize, fontXHeight, fontKheight] = getFontSize(fontName, fontSize); %#ok<NASGU,ASGLU>

    pixPerLet = fontXHeight;

    degPerScreen = degPerPix * screen_width_pix;    
    degPerIm = degPerPix * imageSize(1);
    degPerLetter = degPerPix * fontXHeight;

    targetDegPerLetter = 1;

    imageScaleRep = roundToNearest( targetDegPerLetter/degPerLetter, 1);
    if ~isempty(nPixelRep)
        imageScaleRep = nPixelRep;
    end
    
%     channel_opt.whiteNoiseTh = 149.62;
    channel_opt.whiteNoiseTh = 138;
    
    f_exp = 1;
    
 
    switch noiseMode
        case {'white', '1/f'}
            if strcmp(noiseMode, 'white')
%             allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor), allCycPerLet, 'un', 0);
                allFilters = struct('filterType', noiseMode, 'applyFourierMaskGainFactor', 0);
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
                
            elseif strcmp(expName, 'Grouping')
                nCurves = nWiggleTypes;
                
                allWiggles_ori    = [0, 10:5:90];
                allWiggles_offset = [0, 10:5:60];
                
                nX = nWiggles;
                idx_ori = 1:length(allWiggles_ori); 
                idx_offset = length(allWiggles_ori)-1 + [1:length(allWiggles_offset)];
                curve_idxs = {idx_ori, idx_offset};
%                 allX = [allWiggles_ori, 
            end
%             end
            
        case 'bandpass',
            allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_band), allCycPerLet, 'un', 0);
            allFilters = allBandNoiseFilters;
            nX = length(allCycPerLet);
            nCurves = 1;
            curve_idxs = {1:nX};
            allCycPerLet_full = [allCycPerLet];
            
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
    end
    

    [S, allSignals, allNoiseImages, allLabels, q, Q, h_txt_top, h_txt_bot] = deal( cell(1, nX) );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    nMaxNoiseSamples = 50;
    for xi = 1:nX
    
%         if strcmp(expName, 'Channels')
%         
%         elseif strcmp(expName, 'Grouping')
%             
%         end
                
        if strcmp(expName, 'Channels')
            noiseFilter = allFilters(xi);
        
        elseif strcmp(expName, 'Grouping')
            fontName = allFontNames(xi);
            
        end
        

        noisyLettersPath = [datasetsPath 'NoisyLetters' filesep]; % 'sz32x32' filesep];
        noisyLettersPath_thisFont = [noisyLettersPath fontName filesep];

        noisyLetterOpts_stim = struct( ...
            'oris', 0, 'xs', 0, 'ys', 0, 'stimType', 'NoisyLetters', 'tf_pca', 0, ...
            'sizeStyle', fontSize, ...
            'imageSize', imageSize, ...
            'autoImageSize', 0, ...
            'noiseFilter', noiseFilter ...
        ) ;

        noisyOpts_save = noisyLetterOpts_stim;
        noisyOpts_save.userName = userName;
        fn_save = getNoisyLetterFileName(fontName, [], noisyOpts_save);
        fn_save_full{xi} = [noisyLettersPath_thisFont fn_save];
    %%

        fn = getNoisyLetterFileName(fontName, logSNR_load, noisyLetterOpts_stim);

        Si = load([noisyLettersPath_thisFont fn]);

        params = struct('signalContrast', 1, 'logE1', Si.logE1);
        [~, noiseContrast, logE, logN] = getSignalNoiseContrast(logSNR_load, params);
        
        
        assert(Si.logE == logE);
        assert(Si.logN == logN);

        nStim = min(length(Si.labels), nMaxNoiseSamples);

        allNoiseImages{xi} = zeros([imageSize, nStim], 'single'); %  size(Si.inputMatrix)
        allLabels{xi} = Si.labels; 


        if isfield(Si, 'signalMatrix') && ~isempty(Si.signalMatrix)
            signalMatrix = Si.signalMatrix;
        else
            signalMatrix = Si.signalData;
        end
        allSignals{xi} = signalMatrix; 

        for stim_i = 1:nStim
            input_i = Si.inputMatrix(:,:,stim_i);
    %         signalMatrix = reg


            signal_i = signalMatrix(:,:, allLabels{xi}(stim_i));
            noiseImage = (input_i-signal_i)/noiseContrast;  
    %         noiseImage = noiseImage/std(noiseImage(:));
            allNoiseImages{xi}(:,:,stim_i) = noiseImage;
            %%
    %         figure(58); clf; 
    %         subplot(3,1,1);
    %         imagesc(input_i); axis image; ticksOff;
    %         caxis(max(abs(caxis))*[-1,1])
    %         colormap('gray');
    % 
    %         subplot(3,1,2);
    %         imagesc(noiseImage); axis image; ticksOff;
    %         caxis(max(abs(caxis))*[-1,1])
    %         
    %         subplot(3,1,3);
    %         imagesc(abs(fftshift(fft2(noiseImage)))); 
    %         axis image; ticksOff;
    % 
    %         colormap('gray');
    %         imageToScale([], 2);
            3;
            %%
            3;
    %             allMeans(stim_i) = mean(noiseImage(:));
    %             allVars(stim_i) = var(noiseImage(:));
    %             allStds(stim_i) = std(noiseImage(:));
    %             allMax(stim_i) = max(noiseImage(:));
    %             allMin(stim_i) = min(noiseImage(:));
    %             allRange(stim_i) = diff(lims(noiseImage(:)));
    %             allMax_norm(stim_i) = max(noiseImage(:)/allStds(stim_i));
    %             allMin_norm(stim_i) = min(noiseImage(:)/allStds(stim_i));
    %             allRange_norm(stim_i) = diff(lims(noiseImage(:)/allStds(stim_i)));
    %             allRMS(stim_i) = rms(noiseImage(:));
    %             allRMS_norm(stim_i) = rms(noiseImage(:)/allStds(stim_i));

    %             imagesc(noiseImage);
    %             drawnow;
        end
        %%
   
        
        logTh_initGuess = 1;
        logStd_initGuess = 2.5;

        Q0 = log10(gaussian(allLogSNRs, logTh_initGuess, logStd_initGuess) ); 
        

        nClasses = Si.nClasses;
        gamma = 1/nClasses;
        delta = 0.01;
        weibull = @(params, c) ((1-delta) - ((1-delta)-gamma).* exp (- (( (c) ./params(1)).^(params(2)) ) ) );
        psi0 = @(x) weibull([1 1], 10.^(x));    


        
%         imageScaleRep = 1;

        redoAll = exist('redoFlag', 'var') && isequal(redoFlag, 1);

        haveData = exist(fn_save_full{xi}, 'file') && ~redoAll;
        havePartialData = 0;

        fprintf('Using file : %s\n', fn_save)
        if haveData
            S_loaded = load(fn_save_full{xi});
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
    
    figure(stim_fig); clf;
    h_im = imagesc(zeros(5));
    h_ax_image = gca;
    cmap = gray(256);
    
    colormap(cmap); ticksOff;
    set(stim_fig, 'color', 'k');
    
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
        [~, fontXheight, ~] = getFontSize(fontName, fontSize);
                
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
    subN = ceil(sqrt(nX)/2);
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
    colors_quest = [0 0 .7; .7 0 0];  markersize_quest = 12; %'br'; 
    colors_fit   = [0 .3 1; 1 .3 0];  markersize_fit = 6;
    colors_human = [.4 .3 1; 1 .3 .4];  markersize_fit = 6;
    
    powerInHumanChannels_m = mean(powerInHumanChannels,1);
    human_scale_factor = channel_opt.whiteNoiseTh / max(powerInHumanChannels_m);
    for curve_i = 1:nCurves
        idx = curve_idxs{curve_i};
        h_threshold_curve_quest(curve_i) =  errorbar(allCycPerLet, allThresholds_quest(idx), allThresholds_quest_ci(1,idx), allThresholds_quest_ci(2,idx), ...
            's:', 'markersize', markersize_quest, 'color', colors_quest(curve_i,:), 'linewidth', 2 ); %#ok<AGROW>
        h_threshold_curve_fit(curve_i) = errorbar(allCycPerLet, allThresholds(idx), allThresholds_ci(idx,1), allThresholds_ci(idx,2), ...
            'o-', 'markersize', markersize_fit,   'color', colors_fit(curve_i,:), 'linewidth', 1  );  %#ok<AGROW>
        h_threshold_ax = gca;
    
        if doSimulatedHuman
            h_sim_human(curve_i) = plot(allCycPerLet, powerInHumanChannels_m(idx)*human_scale_factor, '*-', 'markersize', 7, 'color', colors_human(curve_i,:), 'linewidth', 1);  %#ok<NASGU,AGROW>
        end    
        
        3;
%         legend([h_threshold_curve_quest, h_sim_human], {'My Thresholds [Lo]', 'My Thresholds [Hi]', 'Sim. thresholds (2 oct) [Lo]', 'Sim. thresholds (2 oct) [Hi]'}, 'location', 'NW')

    end
    
    
    if nCurves > 1 && doSimulatedHuman
%         h_sim_human(3) = plot(allCycPerLet, (powerInHumanChannels_m(curve_idxs{1}) + powerInHumanChannels_m(curve_idxs{2}) )*human_scale_factor, 'v-', 'markersize', 7, 'color', 'k', 'linewidth', 1);  %#ok<NASGU,AGROW>

    end
        
    ch_f  = zeros(1, length(allCycPerLet)-1);
    
%     f = allCycPerLet;
%     E_lo = allThresholds_quest(idx_lo);
%     E_hi = allThresholds_quest(idx_hi);
%     Eall = 1;
    
    
   
    
    %%
    
    logCycPerLet_lims = lims( log2( allCycPerLet) );
    
    dxtick = 1;
    xticks =  2 .^ [floor(logCycPerLet_lims(1)) : dxtick : ceil(logCycPerLet_lims(2) )];
    
    set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(allCycPerLet(:), .05, 1, 1), 'xtick', xticks, 'xticklabel', arrayfun(@(x) sprintf('%.1f', x), xticks, 'un', 0));
    xlabel('cycles per letter'); ylabel('Threshold');
    title(sprintf('%s (%s)', userName,fontName), 'interp', 'none');
    
    if strcmp(noiseMode, 'hi&lopass')
        legend(h_threshold_curve_quest, {'lo', 'hi'}, 'location', 'SE')
    end
    3;
    %%
    showTextNumbers = 1;
    if ~showTextNumbers
        set([h_txt_top{xi}, h_txt_bot{xi}], 'visible', 'off')
    end
    let_offset = 'a' - 1;
    
    
    rescale_factors = 540 ./(allCycPerLet.^2);    
    
    
     doChannelFig = strcmp(noiseMode, 'hi&lopass') || strcmp(noiseMode, 'bandpass');
    cols = 'br';
    if doChannelFig
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
    stayOnSameNoiseForNTrials = 20;
    
    all_trial_idxs = cellfun(@(c) c.trial_idx, S);
    global_trial_idx = sum( all_trial_idxs);
    noise_order = 1:nX; %randperm(nNoises);
    noise_order_idx = 1;
    noise_idx = noise_order(1);

    firstTime = true;
    
    global noise_order_idx_manual
    global cheatMode
    
    while true %nTrials
        
        
        if ~firstTime

            all_trial_idxs = cellfun(@(c) c.trial_idx, S);            
            noise_order_idx = indmin ( floor( all_trial_idxs/stayOnSameNoiseForNTrials ) );
            
            if ~isempty(noise_order_idx_manual)
                noise_order_idx = noise_order_idx_manual;
            else
%                 noise_order_idx = 1;
            end
            
            
            noise_idx = noise_order(noise_order_idx);
 
            
            global_trial_idx = sum( all_trial_idxs);
    
%            noise_order_idx = mod( ceil(global_trial_idx / stayOnSameNoiseForNTrials), nNoises);
%            
%            if mod(global_trial_idx, stayOnSameNoiseForNTrials) == 0 % adjust noise band               
%                noise_order_idx =   noise_order_idx + 1;
%                if noise_order_idx > nNoises
%                    noise_order_idx = 1;
%                end
% %                all_trial_idxs = cellfun(@(c) c.trial_idx, S);        
% %                 wgts = 5 + max(all_trial_idxs) - all_trial_idxs;
% %                 noise_idx = randsample(1:nNoises, 1, true, wgts);
%            end

%             global_band_eachTrial(global_trial_idx) = noise_idx;
    %         noise_idx = randi(nNoises);
            

%             if ~any(S{noise_idx}.pCorrectOK & S{noise_idx}.pCorrect_snr == 1)
%                 cur_snr_idx = nSNRs;
%             else
            if useMyQuestForNextTrial
                cur_snr_idx = quest(q{noise_idx}, 'next_trial');
            else
                cur_logsnr_guess = QuestMean(Q{noise_idx});
                cur_snr_idx = indmin( abs(cur_logsnr_guess - allLogSNRs));
            end
                
                
                
%             end
%             cur_snr_idx_guess = cur_snr_idx;
            
            % after 15 trials, have a good estimate of threshold, add some
            % variation so we can estimate beta, too.

            if S{noise_idx}.trial_idx > offset_after_NTrials
                doEvenly = 1;
                if doEvenly
                    %%
                    allNTrials_near_th =  S{noise_idx}.nTrials_snr(cur_snr_idx + [-offset_max:offset_max]);
                    [minNTrial, rel_offset] = min(allNTrials_near_th) ;
                    offset = -offset_max + rel_offset - 1;
                    assert(S{noise_idx}.nTrials_snr(cur_snr_idx + offset) == minNTrial)
                else
                
                    offset = randi(2*offset_max+1)-offset_max-1;
                end
                cur_snr_idx = cur_snr_idx + offset;
            end
    %         offset = 0;
        
            snr_trial_idx = S{noise_idx}.nTrials_snr(cur_snr_idx)+1;

    %         cur_snr_idx = cur_snr_idx + offset;
            cur_logsnr = allLogSNRs(cur_snr_idx);


            params.varyContrast = 'signal';
            
            
            [signalContrast, noiseContrast] = getSignalNoiseContrast(cur_logsnr, params);
            
%             [signalContrasts, noiseContrasts] = arrayfun(@(logsnr) getSignalNoiseContrast(logsnr, params), allLogSNRs);
            
            belowMin = signalContrast < minPossibleContrast;
%             minPossibleContrast
            
            3;
            curLabel = randi(nClasses);
            
%             noiseImage = allNoiseImages{noise_idx}(:,:,S{noise_idx}.trial_idx);
            noiseIdx_use = randi( size(allNoiseImages{noise_idx}, 3) );
            noiseImage = allNoiseImages{noise_idx}(:,:,noiseIdx_use);

            randShift_x = randi(imageSize(1));
            randShift_y = randi(imageSize(2));
            noiseImage = circshift(noiseImage, [randShift_x, randShift_y]);
            
            curStim = allSignals{noise_idx}(:,:,curLabel) * signalContrast + noiseImage * noiseContrast;

            
            blankChar = char(1);

            if keepAbsContrastFixed
                curLims = globalCLims;
            else  
                curLims = max(abs(curStim(:))) * [-1, 1];
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
            fprintf('Which letter?%s%s ', cheat_str, iff (belowMin, '[!]', ''));

            allowBackspace = 0;
            didBackspace = false;

            
            while isempty(response_label) || ~(ibetween(response_label, 1, nClasses) || didBackspace)
            
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

            fprintf('[%s]\n', response_char);
            set(h_im, 'cdata', curStim*0);

            if enforceTimeout
                
            end
            set(h_im, 'cdata', curStim*nan);
            pause(0.3);

            if didBackspace
                
                
            end
            %%
            S{noise_idx}.responses_snr{cur_snr_idx}(snr_trial_idx) = response_label;
            S{noise_idx}.true_labels{cur_snr_idx}(snr_trial_idx) = curLabel;

            tf_success = response_label == curLabel;
            if tf_success
                S{noise_idx}.nCorrect_snr(cur_snr_idx) = S{noise_idx}.nCorrect_snr(cur_snr_idx)+1;        
            else

            end

            S{noise_idx}.nTrials_snr(cur_snr_idx) = S{noise_idx}.nTrials_snr(cur_snr_idx)+1;
            %%
            q{noise_idx} = quest(q{noise_idx}, 'add_trial', cur_logsnr, tf_success);
            Q{noise_idx} = QuestUpdate(Q{noise_idx}, cur_logsnr, tf_success );

    %         if S{noise_idx}.nTrials_snr(cur_snr_idx) < minNtrials 
    %             continue;
    %         end
            %%
            
       

            nCorr_i = S{noise_idx}.nCorrect_snr(cur_snr_idx);
            nT = S{noise_idx}.nTrials_snr(cur_snr_idx);

            pCorr_i = nCorr_i / nT;
            stderr_pcorrect = sqrt( pCorr_i * (1 - nCorr_i) / nT );

            S{noise_idx}.pCorrect_snr(cur_snr_idx) = pCorr_i;
            S{noise_idx}.stderr_snr(cur_snr_idx)  = stderr_pcorrect;

            S{noise_idx}.pCorrectOK = S{noise_idx}.nTrials_snr >= minNtrials ;% & S{noise_idx}.stderr_snr < 0.1;
            noise_idxs_update = noise_idx;
            
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
                    set(h_psych_tit(xi), 'string', sprintf('c/l=%.1f, n= %d. Th:%.2f', allCycPerLet_full(xi), S{xi}.trial_idx, log10(th_use) ));
                    set(h_psych_axes(xi), 'xlim', log10(snr_quest)+0.5*[-1, 1])
                    
                    set(h_psych_line(xi), 'xdata', log10(snr_quest)*[1,1]);
                    

                else
                    set(h_psych_tit(xi), 'string', sprintf('c/l=%.1f. nTrials = %d', allCycPerLet_full(xi), S{xi}.trial_idx ));
                end
                
            end

            structToSave = S{xi};
            %%
%             save(fn_save_full{xi}, '-struct', 'structToSave');

            saveAll = 0;
            if saveAll
                %%
                for bnd_i = 1:nX
                        save(fn_save_full{bnd_i}, '-struct', 'S{bnd_i}');
                end

            end


        end
    
        firstTime = false;
%         global_trial_idx = global_trial_idx + 1;
        3;

        
        
%         if ~S{noise_idx}.pCorrectOK(cur_snr_idx)
%             continue;
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