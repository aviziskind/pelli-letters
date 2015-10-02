function measurePsychCurve(redoFlag)

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
    beta =         [1      1.79   1.56   1.53   2.01    1.71,  2.2,   ];

    
    % for 144x144, k68
    allCycPerLet = [0.5,   1,       2,      4,       8,          16];
    allTh =        [2.09,  5.53,    18.28,  135.3,   333,        20];    
    beta =         [1.66,  1.61,    2.6,    2.06,    1.55,     1.28];    

    
%%
%}%%


    fontName = 'Bookman';
    userName = 'az';
    
%     fontSize = 'k18';
%     imageSize = [45, 45];

%     fontSize = 'k38';
%     imageSize = [64, 64];

    fontSize = 'k68';
    imageSize = [144, 144];

    allLogSNRs = -2:.2:5; %linspace(-1,4,nSNRs);
        allSNRs = 10.^allLogSNRs;
        nSNRs = length(allLogSNRs);

%     allCycPerLet = [0.5, 0.8, 1.3, 2.0,  3.2, 5.1, 8.1, 13];
    allCycPerLet = [0.5,   1,     2,     4,     8,      16];
%     allTh =        [.21            12.3                   ];

    idx_use = 6;
    
    
    
%     allLogSNRs = [0, 1, 1.5, 2, 2.5, 3, 4];
%     allLogSNRs = [-1, 0, 0.5, 1, 1.5, 2, 2.5, 3, 4];


    logSNR_load = 2;

    
    allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f), allCycPerLet, 'un', 0);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    noiseFilter = allBandNoiseFilters(idx_use);
    
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
    fn_save_full = [noisyLettersPath_thisFont fn_save];
%%
    
   
      
    fn = getNoisyLetterFileName(fontName, logSNR_load, noisyLetterOpts_stim);

    Si = load([noisyLettersPath_thisFont fn]);

    params = struct('signalContrast', 1, 'logE1', Si.logE1);
    [~, noiseContrast, logE, logN] = getSignalNoiseContrast(logSNR_load, params);
    assert(Si.logE == logE);
    assert(Si.logN == logN);

    allNoiseImages = zeros(size(Si.inputMatrix));

    nStim = length(Si.labels);
    
    if isfield(Si, 'signalMatrix') && ~isempty(Si.signalMatrix)
        signalMatrix = Si.signalMatrix;
    else
        signalMatrix = Si.signalData;
    end
    allSignals = signalMatrix;
    
    for stim_i = 1:nStim
        input_i = Si.inputMatrix(:,:,stim_i);
%         signalMatrix = reg
        
        
        signal_i = signalMatrix(:,:, Si.labels(stim_i));
        noiseImage = (input_i-signal_i)/noiseContrast;  
%         noiseImage = noiseImage/std(noiseImage(:));
        allNoiseImages(:,:,stim_i) = noiseImage;
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
        
    
    th0 = 200;
    Q0 = log10(gaussian(allLogSNRs, log10(th0), log10(50)) ); 

    nClasses = Si.nClasses;
    gamma = 1/nClasses;
    delta = 0.01;
    weibull = @(beta, c) ((1-delta) - ((1-delta)-gamma).* exp (- (( (c) ./beta(1)).^(beta(2)) ) ) );
    psi0 = @(x) weibull([1 1], 10.^(x));    
    
   
    

    %%
    screen_height_mm = 194;  screen_width_mm = 344;
    
    screenSize = get(0, 'ScreenSize');
    screen_width_pix = screenSize(3); screen_height_pix = screenSize(4);
    
    pix_per_mm = screen_width_pix / screen_width_mm;
    
    viewingDistance_mm = 500;  % 50cm = 20 inches
    
    radPerMM = 1 / (viewingDistance_mm);
    degPerMM  = radPerMM * (180/pi);
    degPerPix = degPerMM / pix_per_mm;
    
%     radPerPix = 1 / (viewingDistance_mm * pix_per_mm);
%     degPerPix = radPerPix * (180/pi);
    [fontPointSize, fontXHeight, fontKheight] = getFontSize(fontName, fontSize);


    degPerScreen = degPerPix * screen_width_pix;    
    degPerIm = degPerPix * size(Si.inputMatrix,1);
    degPerLetter = degPerPix * fontXHeight;
    imageScaleRep = 1;

    redoAll = exist('redoFlag', 'var') && isequal(redoFlag, 1);

    haveData = exist(fn_save_full, 'file') && ~redoAll;
   
    fprintf('Using file : %s\n', fn_save)
    if haveData
        S = load(fn_save_full);
  
        if ~isequal(S.allLogSNRs, allLogSNRs)
            haveData = 0;
            beep;
            fprintf('Saved data has different set of SNRs - restarting ...\n')
        end
    end

    q = quest([], 'init', allLogSNRs, Q0, psi0);

    if ~haveData        
        S.true_labels = cell(1,nSNRs);
        S.responses_snr = cell(1,nSNRs);
        
        S.nCorrect_snr = zeros(1,nSNRs);
        S.nTrials_snr = zeros(1,nSNRs);

        S.pCorrect_snr = nan(1,nSNRs);
        S.stderr_snr = zeros(1,nSNRs);
        S.pCorrectOK = false(1,nSNRs);
        S.trial_idx = 0;
        S.allLogSNRs = allLogSNRs;

    end
    
    % Re-establish quest function (if have saved data)
    for snr_i = 1:nSNRs
        for tr_i = 1: S.nCorrect_snr(snr_i)  % successes
            q = quest(q, 'add_trial', allLogSNRs(snr_i), 1);
        end
        for tr_i = 1: (S.nTrials_snr(snr_i) - S.nCorrect_snr(snr_i))  % failures
            q = quest(q, 'add_trial', allLogSNRs(snr_i), 0);
        end        
    end
    
   
    
    %%
    stim_fig = 123;
    psych_fig = 124;
    figure(stim_fig); clf;
    h_im = imagesc(zeros(5));
    h_ax_image = gca;
    colormap('gray'); ticksOff;
    
    set(stim_fig, 'color', 'k');
    
    %%
    psych_fig = 124;
    figure(psych_fig); clf; hold on;
    h_psych_curve = errorbar(allLogSNRs, S.pCorrect_snr, S.stderr_snr, 'bo-');
    h_weibull_fit = plot(0, 0, 'r-');
    h_ax_psych_curve = gca;
    h_psych_tit = title(' ');
    set(h_ax_psych_curve, 'ylim', lims([0, 1], .02), 'xlim', lims(allLogSNRs, .02)); %, 'xtick', allLogSNRs );
    
    

    %%
    for i = 1:nSNRs
        if S.nTrials_snr(i) == 0
            str_top = ' '; 
            str_bot = ' ';
        else
            str_top = sprintf('%d', S.nCorrect_snr(i));
            str_bot = sprintf('%d', S.nTrials_snr(i));
        end
        h_txt_top(i) = text(allLogSNRs(i), 0.05, str_top, 'horiz', 'cent', 'vert', 'bot', 'parent', h_ax_psych_curve, 'fontsize', 7);
        h_txt_bot(i) = text(allLogSNRs(i), 0, str_bot, 'horiz', 'cent', 'vert', 'bot', 'parent', h_ax_psych_curve, 'fontsize', 7);
    end
    3;
    %%
    
    let_offset = 'a' - 1;
    
        
    
    threshold = 0.64;
    dTh = nan;
    
    min_pCorrectToStop = 0.2; 
    dTh_threshold = 0.01;
    minNtrials = 5;
      
    
    requireEnter = 0;
    
    
   
    
    offset_max = 2;
    
    
    while true %nTrials
        S.trial_idx = S.trial_idx + 1;
        
        cur_snr_idx = quest(q, 'next_trial');
        if ~any(S.pCorrectOK & S.pCorrect_snr == 1)
            cur_snr_idx = nSNRs;
        end
        
        if S.trial_idx > 15
            offset = randi(2*offset_max+1)-offset_max-1;
            cur_snr_idx = cur_snr_idx + offset;
        end
%         offset = 0;
        
        snr_trial_idx = S.nTrials_snr(cur_snr_idx)+1;

%         cur_snr_idx = cur_snr_idx + offset;
        cur_logsnr = allLogSNRs(cur_snr_idx);
        
        
        [signalContrast, noiseContrast] = getSignalNoiseContrast(cur_logsnr, params);
        
        curLabel = randi(nClasses);
        curStim = allSignals(:,:,curLabel) * signalContrast + allNoiseImages(:,:,S.trial_idx) * noiseContrast;

            
        
        L = max(abs(curStim(:)));
        set(h_im, 'cdata', curStim);
        xlims = [0, size(curStim,2)]+.5;
        ylims = [0, size(curStim,1)]+.5;
        set(h_ax_image, 'xLim', xlims, 'ylim', ylims, 'cLim', [-L, L]);
        imageToScale(h_ax_image, imageScaleRep);
        
        figure(stim_fig);
        response_label = 0;
        while ~ibetween(response_label, 1, nClasses)
            if requireEnter           
                response_str = input('Which letter? ', 's');            
            else
                fprintf('Which letter? ');
                while ~waitforbuttonpress
                    % wait for keyboard press
                end
                fprintf('\n');
                response_str = get(stim_fig, 'CurrentCharacter');             
            end
            response_str = lower(response_str);
            response_label = response_str - let_offset;
        
            if strcmp(response_str, '1')
                keyboard;
            end
            
        end
        
        
            
        %%
        S.responses_snr{cur_snr_idx}(snr_trial_idx) = response_label;
        S.true_labels{cur_snr_idx}(snr_trial_idx) = curLabel;
        
        tf_success = response_label == curLabel;
        if tf_success
            S.nCorrect_snr(cur_snr_idx) = S.nCorrect_snr(cur_snr_idx)+1;        
%             fprintf('yes!');
        else
%             beep;
        end
        S.nTrials_snr(cur_snr_idx) = S.nTrials_snr(cur_snr_idx)+1;
        %%
        q = quest(q, 'add_trial', cur_logsnr, tf_success);
        
%         if S.nTrials_snr(cur_snr_idx) < minNtrials 
%             continue;
%         end
        %%
        nCorr = S.nCorrect_snr(cur_snr_idx);
        nT = S.nTrials_snr(cur_snr_idx);

        pCorr = nCorr / nT;
        stderr_pcorrect = sqrt( pCorr * (1 - pCorr) / nT );
       
        S.pCorrect_snr(cur_snr_idx) = pCorr;
        S.stderr_snr(cur_snr_idx)  = stderr_pcorrect;
        
        S.pCorrectOK = S.nTrials_snr >= minNtrials ;% & S.stderr_snr < 0.1;
        
        idx_use = ~isnan(S.pCorrect_snr) & (S.nTrials_snr >= minNtrials);
        if any(S.pCorrect_snr < threshold) && nnz(idx_use) >= 4
            %%
%             opt.assumeMax100pct = 1;
            [snr_th, bestFitFunc, snr_th_ci, beta_fit] = getSNRthreshold(allLogSNRs(idx_use), S.pCorrect_snr(idx_use));
            weibull_slope = beta_fit(3);
%             idx_use = log10(allSNRs) > 
            if ~isempty(bestFitFunc)
                pCorr =  bestFitFunc(allSNRs)/100;
            
                dTh = diff(snr_th_ci) / snr_th;
            else
                pCorr = nan(size(allSNRs));
                dTh = nan;
            end
        else
            snr_th = nan;
        end
        %%
        save(fn_save_full, '-struct', 'S');
        
        updatePsychCurve = 1;
        if updatePsychCurve
            %%
            pCorr_use = S.pCorrect_snr(:);
            pCorr_use(~S.pCorrectOK) = nan;
            set(h_psych_curve, 'xdata', allLogSNRs(:), 'ydata', pCorr_use(:), 'udata', S.stderr_snr(:), 'ldata', S.stderr_snr(:));
            
            set(h_txt_top(cur_snr_idx), 'string', sprintf('%d', nCorr));
            set(h_txt_bot(cur_snr_idx), 'string', sprintf('%d', nT));
          
            if ~isnan(snr_th)
                set(h_psych_tit, 'string', sprintf('nTrials = %d.  Th: %.2f [%.2f - %.2f] (%.2f %%). beta = %.2f', S.trial_idx, snr_th, snr_th_ci, dTh*100, weibull_slope))
                set(h_weibull_fit, 'xdata', allLogSNRs, 'ydata', pCorr);
                3;
            end
            
            
            
            
        end
        3;
        
        if ~S.pCorrectOK(cur_snr_idx)
            continue;
        end
        
        
        if ~isnan(dTh) && dTh < dTh_threshold
%             keyboard;
%             break;
        end
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