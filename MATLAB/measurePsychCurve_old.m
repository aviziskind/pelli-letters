function measurePsychCurve(redoFromSNR)

    randomizeOrder = 1;

    fontName = 'Bookman';
    userName = 'az';
    
    fontSize = 'k18';
    imageSize = [45, 45];
    
    allCycPerLet = [0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13];

%     allLogSNRs = [0, 1, 1.5, 2, 2.5, 3, 4];
    allLogSNRs = [-1, 0, 0.5, 1, 1.5, 2, 2.5, 3, 4];


    
    allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f), allCycPerLet, 'un', 0);

    
    noiseFilter = allBandNoiseFilters(4);
    
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

    
    nSNRs = length(allLogSNRs);

    allStims = cell(1,nSNRs);
    allLabels = cell(1,nSNRs);
    for i = 1:1
        
        idx = 1;
        fn = getNoisyLetterFileName(fontName, allLogSNRs(idx), noisyLetterOpts_stim);

        Si = load([noisyLettersPath_thisFont fn]);
        
        params = struct('signalContrast', 1, 'logE1', Si.logE1);
        [signalContrast, noiseContrast, logE, logN] = getSignalNoiseContrast(allLogSNRs(idx), params);
        assert(Si.logE == logE);
        assert(Si.logN == logN);
        
        allStims{i} = Si.inputMatrix;
        allNoiseImages = zeros(size(Si.inputMatrix));
        allLabels{i} = Si.labels;
        
        nStim = length(Si.labels);
        for stim_i = 1:nStim
            input_i = Si.inputMatrix(:,:,stim_i);
            signal_i = Si.signalMatrix(:,:, Si.labels(stim_i));
            noiseImage = (input_i-signal_i)/noiseContrast;  
            allNoiseImages(:,:,stim_i) = noiseImage;
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
        
        if randomizeOrder
            idx = randperm( length(Si.labels) );
            allStims{i} = allStims{i}(:,:,idx);
            allLabels{i} = allLabels{i}(idx);
        end
        
    end
%%    
        

    
    %%
    nClasses = Si.nClasses;
    
    allLogSNRs_fine = linspace(allLogSNRs(1), allLogSNRs(end), 30);
    allSNRs_fine = 10.^allLogSNRs_fine;
    %%
    screen_height_mm = 194;  screen_width_mm = 344;
    
    screenSize = get(0, 'ScreenSize');
    screen_width_pix = screenSize(3); screen_height_pix = screenSize(4);
    
    pix_per_mm = screen_width_pix / screen_width_mm;
    
    viewingDistance_mm = 500; 
    
    radPerMM = 1 / (viewingDistance_mm);
    degPerMM  = radPerMM * (180/pi);
    degPerPix = degPerMM / pix_per_mm;
    
%     radPerPix = 1 / (viewingDistance_mm * pix_per_mm);
%     degPerPix = radPerPix * (180/pi);
    
    degPerScreen = degPerPix * screen_width_pix;    
    
    degPerIm = degPerPix * size(Si.inputMatrix,1);

    redoAll = 0;
    if nargin < 1
        redoFromSNR = [];
    end
    haveData = exist(fn_save_full, 'file') && ~redoAll;
   
    fprintf('Using file : %s\n', fn_save)
    if haveData
        S = load(fn_save_full);
  
        if ~isfield(S, 'allLogSNRs')
            keyboard;
            S.allLogSNRs = [0, 1, 1.5, 2, 2.5, 3, 4];
        end
        if ~isequal(S.allLogSNRs, allLogSNRs)
            %%
            assert(isempty(setdiff( S.allLogSNRs, allLogSNRs )))
            idx_orig = binarySearch(allLogSNRs, S.allLogSNRs);
            
            S_new.responses_snr = cell(1,nSNRs);  S_new.responses_snr(idx_orig) = S.responses_snr;
            S_new.pCorrect_snr = nan(1,nSNRs);    S_new.pCorrect_snr(idx_orig) = S.pCorrect_snr;
            S_new.nCorrect_snr = zeros(1,nSNRs);  S_new.nCorrect_snr(idx_orig) = S.nCorrect_snr;
            S_new.nTrials_snr = zeros(1,nSNRs);   S_new.nTrials_snr(idx_orig) = S.nTrials_snr;
            S_new.stderr_snr = zeros(1,nSNRs);    S_new.stderr_snr(idx_orig) = S.stderr_snr;
            S_new.pCorrectOK = false(1,nSNRs);    S_new.pCorrectOK(idx_orig) = S.pCorrectOK;
            S_new.allLogSNRs = allLogSNRs;       
            S = S_new;
            3;
            
        end
        
    else
        
        S.responses_snr = cell(1,nSNRs);
        S.pCorrect_snr = nan(1,nSNRs);
        S.nCorrect_snr = zeros(1,nSNRs);
        S.nTrials_snr = zeros(1,nSNRs);
        S.stderr_snr = zeros(1,nSNRs);
        S.pCorrectOK = false(1,nSNRs);
        S.trial_idx = 0;
        S.allLogSNRs = allLogSNRs;
    end
    
    if ~isempty(redoFromSNR)
        redoFromSNR_idxs = 1 : indmin(abs(allLogSNRs - redoFromSNR));
        for i = redoFromSNR_idxs
            S.responses_snr{i} = [];
            S.nTrials_snr(i) = 0;
            S.nCorrect_snr(i) = 0;
            S.pCorrect_snr(i) = nan;
            S.stderr_snr(i) = 0;
            S.pCorrectOK(i) = false;
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
    set(h_ax_psych_curve, 'ylim', lims([0, 1], .02), 'xlim', lims(allLogSNRs, .02), 'xtick', allLogSNRs );
    
    

    %%
    for i = 1:nSNRs
        if S.nTrials_snr(i) == 0
            str_i = '-';
        else
            str_i = fracWithBrac(S.nCorrect_snr(i), S.nTrials_snr(i), ~S.pCorrectOK(i));
        end
        h_txt(i) = text(allLogSNRs(i), 0, str_i, 'horiz', 'cent', 'vert', 'bot', 'parent', h_ax_psych_curve);
    end
    
    %%
    
    let_offset = 'a' - 1;
    
    if ~any(S.pCorrectOK)
%         cur_snr = allLog;
        cur_snr_idx = nSNRs; %find(allLogSNRs == cur_snr, 1); 
    else
        cur_snr_idx = find(diff(S.pCorrectOK) == 1, 1, 'first');
        
    end
        
    
    threshold = 0.64;
    
    th_stderrs = [.3, .2, .1, .05]; 
    min_pCorrectToStop = 0.2; 
    minNtrials = 10;
    
  
    
    requireEnter = 0;
    
    S.trial_idx = 0;
    while true %nTrials
        S.trial_idx = S.trial_idx + 1;
        
        stim_idx = S.nTrials_snr(cur_snr_idx)+1;
        
        curStim = allStims{cur_snr_idx}(:,:,stim_idx);
        curLabel = allLabels{cur_snr_idx}(stim_idx);
        
        L = max(abs(curStim(:)));
        set(h_im, 'cdata', curStim);
        xlims = [0, size(curStim,2)]+.5;
        ylims = [0, size(curStim,1)]+.5;
        set(h_ax_image, 'xLim', xlims, 'ylim', ylims, 'cLim', [-L, L]);
%         set(h_psych_curve, );
        imageToScale(h_ax_image, 2);
        
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
        S.responses_snr{cur_snr_idx}(stim_idx) = response_label;
        
        if response_label == curLabel
            S.nCorrect_snr(cur_snr_idx) = S.nCorrect_snr(cur_snr_idx)+1;        
%             fprintf('yes!');
        else
%             beep;
        end
        S.nTrials_snr(cur_snr_idx) = S.nTrials_snr(cur_snr_idx)+1;
        
        
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
        
        S.pCorrectOK(cur_snr_idx) = (nT >= minNtrials) && stderr_pcorrect < 0.1;
        
        if any(S.pCorrect_snr < threshold) && nnz(~isnan(S.pCorrect_snr)) > 3
            %%
            idx_use = ~isnan(S.pCorrect_snr) & (S.nTrials_snr > 3);
            [snr_th, bestFitFunc, snr_th_ci] = getSNRthreshold(allLogSNRs(idx_use), S.pCorrect_snr(idx_use));
%             idx_fine_use = log10(allSNRs_fine) > 
            if ~isempty(bestFitFunc)
                pCorr_fine =  bestFitFunc(allSNRs_fine)/100;
            
                dTh = diff(snr_th_ci) / snr_th;
            else
                pCorr_fine = nan(size(allSNRs_fine));
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
            set(h_psych_curve, 'xdata', allLogSNRs(:), 'ydata', S.pCorrect_snr(:), 'udata', S.stderr_snr(:), 'ldata', S.stderr_snr(:));
            
            str_i = fracWithBrac(nCorr, nT, ~S.pCorrectOK(i));
            set(h_txt(cur_snr_idx), 'string', str_i)
          
            if ~isnan(snr_th)
                set(h_psych_tit, 'string', sprintf('Th: %.2f [%.2f - %.2f] (%.2f %%)', snr_th, snr_th_ci, dTh*100))
                set(h_weibull_fit, 'xdata', allLogSNRs_fine, 'ydata', pCorr_fine);
                3;
            end
            
            
            
            
            
        end
        3;
        
        if ~S.pCorrectOK(cur_snr_idx)
            continue;
        end
        
        
        if (pCorr > min_pCorrectToStop) && (cur_snr_idx > 1)
            cur_snr_idx = cur_snr_idx - 1;
        else
            break;
        end
        
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