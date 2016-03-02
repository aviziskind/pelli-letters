doFigs = 1;

if any(doFigs == 1)  % show stimulus & response for efficiency vs complexity experiments
    %%
    params.signalContrast = 1;
    params.pixPerDeg = 1;
    
    % show figures with noisy letters
%     fontName = 'Braille';
    fontName = 'BookmanU';
    fontName_display = strrep(fontName, 'U', '');
    sizeStyle = 'big';
    
    allLogSNRs = [0, 1, 1.5, 2, 2.5, 3, 4]; nSNRs = length(allLogSNRs);
    allLogSNRs_plot = [0:4]; nSNRs_plot = length(allLogSNRs_plot);
    noisyLetterOpts = struct('expName', 'Complexity', 'sizeStyle', sizeStyle, 'OriXY', struct('oris', 0, 'xs', 0, 'ys', 0), 'tf_pca', 0, 'stimType', 'NoisyLetters', 'autoImageSize', 1); 

    folder = [datasetsPath 'NoisyLetters' filesep fontName filesep]; % 'sz32x32' filesep];
    allIm = cell(1,nSNRs);
    allPCA_coeffs = cell(1,nSNRs);
    noise_images = cell(1,10000);
    for si = 1:nSNRs
        %%
        fname = getNoisyLetterFileName(fontName, allLogSNRs(si), noisyLetterOpts);
        label_idx = 1;
        SS = load([folder fname]);
        idx = find(SS.labels == label_idx, 1);
        allIm{si} = SS.inputMatrix(:,:,idx) / SS.noiseContrast;
        [nH, nW, setSize] = size(SS.inputMatrix);
        %%
        if si == 1
            %%
            [m,n,nLetters] = size(SS.signalMatrix);
%             allImageVecs_C = arrayfun(@(sig) sig.image(:), signal(:), 'un', 0);
%             allImageVecs = [allImageVecs_C{:}]';
            allImageVecs = reshape(SS.signalMatrix, [m*n, nLetters])';
            meanImageVec = mean(allImageVecs,1);
       
            warning('off', 'stats:pca:ColRankDefX')
            fprintf('Doing PCA on original image set...'); tic;        
            [coeff, score] = pca(allImageVecs); % 'NumComponents', nPCAcompsMax);
            
            allRawSignals = zeros(nW*nH, setSize);
            allNoises     = zeros(nW*nH, setSize);
            
            %%
            
            
            allSignals = SS.signalMatrix; 
            for i = 1:size(allSignals,3)
                curImage = allSignals(:,:,i);
                E1(i) = dot(curImage(:),curImage(:))/params.pixPerDeg^2;
            end
            params.logE1=log10(E1);
            %%
            signal_image = SS.signalMatrix(:,:,label_idx);
            noise_image = (SS.inputMatrix(:,:,idx)-signal_image) / SS.noiseContrast;
            %%
            for input_i = 1:setSize
                signal_image_i = SS.signalMatrix(:,:,SS.labels(input_i) );
                allRawSignals(:,input_i) = signal_image_i(:);
                noise_image_i = (SS.inputMatrix(:,:,input_i)-signal_image_i) / SS.noiseContrast;
                allNoises(:,input_i) = noise_image_i(:);
            end
            
            allStimImages_cent = bsxfun(@minus, allRawSignals', meanImageVec);     
            raw_scores = allStimImages_cent / coeff';
            noise_scores = (allNoises') /coeff';
            labels = SS.labels;
            
        end
        
        %{
        %% straightforward method
        allStimImages = reshape( SS.inputMatrix, [nH*nW, setSize]);

        centdata = bsxfun(@minus, allStimImages', meanImageVec);
        stimulusScores = centdata/coeff';
        allPCA_coeffs{si} = stimulusScores(:,1:3);
        %%
        
        %% same as straightforward, using new variables.
        allStimImages2 = allRawSignals * SS.signalContrast + allNoises * SS.noiseContrast;
        centdata2 = bsxfun(@minus, allStimImages2', meanImageVec);
        stimulusScores2 = centdata2/coeff';
        %}
        
        %% subtract mean first, before adding noise
       
        
        
        
        
        %%
        
        
        
        3;
    end
    
   
%         plot
    
%     for stim_i = 1:length(noisySet.stimulus(:))
%         noisySet.stimulus(stim_i).image = getPcaScore(noisySet.stimulus(stim_i).image, meanImageVec, coeff);
%     end

    
            

    
  %%
    allLogSNRs_fine = 0:.1:4;
%     allLogSNRs_fine = 3;
    nSNRs_fine = length(allLogSNRs_fine);
    allIm_fine = cell(1,nSNRs_fine);
    stimulusScores = cell(1,nSNRs_fine);
    params.varyContrast = 'signal';
    params2 = params;
    params2.varyContrast = 'noise';
    for i = 1:nSNRs_fine
        [signalContrast, noiseContrast, logE, logN] = getSignalNoiseContrast(allLogSNRs_fine(i), params);
        allIm_fine{i} = (signal_image * signalContrast + noise_image * noiseContrast);
        
%         for input_i = 1:setSize

        [signalContrast2, noiseContrast2, logE, logN] = getSignalNoiseContrast(allLogSNRs_fine(i), params2);
        stimulusScores{i} = raw_scores(:,1:3) * signalContrast2 + noise_scores(:,1:3) * noiseContrast2;
        
%         allStimImages = reshape( SS.inputMatrix, [nH*nW, setSize]);
        
%         imagesc(allIm_fine{i}); axis equal tight;
%         caxis([-L/2, L]);
%         pause(.1);
    end
    
    %%
    
    
%     noisySet = generateSetOfNoisyLetters(logEOverN, signal, params);
    
    %%
%     figure(33);
    
%     imagesc(tileImages(cat(3, allIm{:})));
    
    
    % use standard (6,15) model

    
%     noisyLetterOpts.tf_pca = tf_pca;
    %%
    [pctCorr_ideal, pctCorr_ideal_indiv] = getIdealPerformance(fontName, allLogSNRs, noisyLetterOpts);
    %%

    plotType = 'forSlides';
    if strcmp(plotType, 'forSlides')
        
%         network_use = struct('netType', 'ConvNet', ...
%                             'nStates', {{6,15}}, ...
%                             'filtSizes', 5,...
%                             'doPooling', true, ...
%                             'poolSizes', 4, ...
%                             'poolType', 2, ...
%                             'poolStrides', 'auto' ... 
%                           );
% 
%         expTitle = 'Complexity';
%         snr_train = [1,2,3];
%         opt.skipIfDontHaveModelFile = 1;
%         pctCorrectTotal_model_v_snr = loadModelResults(expTitle, {fontName}, allLogSNRs, snr_train, network_use, noisyLetterOpts, opt, 10);   
%         pctCorrectTotal_model_v_snr = pctCorrectTotal_model_v_snr.(fontName);
% 
%         pctCorrectTotal_model_v_snr = nanmean(pctCorrectTotal_model_v_snr, 4);

        plotHumanData = 1;
        
        showIdeal = 1 && strcmp(fontName, 'Bookman');
            showIdealOnSamePlot = 0;
        
        fig_a = 45;
        fig_b = 46;
        if showIdeal && showIdealOnSamePlot
            subM = 10; subN = 10;

            psych_subIdxsM = 1:4; psych_subIdxsN = 1:7;
            let_subIdxsM = 1:4;   let_subIdxsN = 7:10;
            ideal_subIdxsM = 5:10; mrgin = 3; ideal_subIdxsN = mrgin:subN-mrgin;
        else
            
            
            subM = 1; subN = 10;
            psych_subIdxsM = 1; psych_subIdxsN = 1:7;
            let_subIdxsM = 1;   let_subIdxsN = 7:10;
                        
        end
        
%         human_log_snr_offset = 0.2; %0.0667;
        if plotHumanData
            pctCorrectTotal_human = [0.468, 0.661, 0.784]*100; 
            allLogSNRs_use_human_init = log10([0.013948, 0.019881, 0.028465]*580);
        %     allLogSNRs_use_human = [0.2, 0.239, 0.286];

        %     pctCorrectTotal_human = [.223, .582, .822, .951]*100; 
        %     allLogSNRs_use_human = log10( [0.00014523, 0.00058092, 0.0013071, 0.0023237]*1500 );

%             allSNRs_use_human_init = 10.^allLogSNRs_use_human_init;    
        end

%%
        allLogSNRs_use = allLogSNRs-1;
        allSNRs_use = 10.^allLogSNRs_use;
                
        [th_ideal, ideal_fit, ideal_th_ci, ideal_beta_fit] = getSNRthreshold(allLogSNRs_use, pctCorr_ideal);    
%         [th_model, model_fit] = getSNRthreshold(allLogSNRs_use, mean(pctCorrectTotal_model_v_snr,1));
        [th_human_init, human_fit_init] = getSNRthreshold(allLogSNRs_use_human_init, pctCorrectTotal_human, 1);

        eff_human = getStatsFromPaper(fontName, 'efficiency');
%         tff_human = getStatsFromPaper(fontName, 'efficiency');
        th_human_shouldBe = th_ideal / eff_human;
        r = th_human_shouldBe / th_human_init;
        
        addPoint = 1;
        
        allLogSNRs_use_human = allLogSNRs_use_human_init + log10(r);
        if addPoint
            allLogSNRs_use_human = [allLogSNRs_use_human, allLogSNRs_use_human(end)+2];
            pctCorrectTotal_human = [pctCorrectTotal_human, 100];
        end
            
        [th_human, human_fit, th_ci, beta_fit] = getSNRthreshold(allLogSNRs_use_human, pctCorrectTotal_human, struct('assumeMax100pct', 0));
        allSNRs_use_human = 10.^allLogSNRs_use_human;    
                
        eff_calc = (th_ideal / th_human);        


        xx = logspace(allLogSNRs_use(1), allLogSNRs_use(end), 100);
        yy_ideal_fit = ideal_fit(xx);
%         yy_model_fit = model_fit(xx);
        yy_human_fit = human_fit(xx);


        plotOnLogAxes = 1;

        xlims = lims(allSNRs_use, .001, [], 1);

        figure(fig_a); clf; 
        subN = 10;
        h_ax_psych = subplotGap(subM,subN, psych_subIdxsM, psych_subIdxsN, [.02, 0, .0]);

%         subplot(10,1,6:9);
        line_w = 2;
        hold on; box on;
        
        fixedMarkerSize = 7;

        plot(allSNRs_use, pctCorr_ideal, 'bo', 'markersize', fixedMarkerSize, 'linewidth', line_w);
        plot(xx, yy_ideal_fit, 'b-', 'linewidth', line_w);

%         plot(allSNRs_use, pctCorrectTotal_model_v_snr, 'rs', 'markersize', 8, 'linewidth', line_w);
%         plot(xx, yy_model_fit, 'r-', 'linewidth', line_w);

        plot(allSNRs_use_human, pctCorrectTotal_human, 'ks', 'markersize', fixedMarkerSize, 'linewidth', line_w);
        plot(xx, yy_human_fit, 'k-', 'linewidth', line_w);

        set(gca, 'xscale', 'log');
        
%         xlim(xlims);
        
        title(sprintf('Font: {\\bf%s}.  Ideal Threshold: %.1f.   Human Threshold: %.1f.   Efficiency: {\\bf%.2f}', fontName_display, th_ideal, th_human, eff_calc), 'fontsize', 10);
        
        h_ideal_cur = plot(xx(1),yy_ideal_fit(1), 'bo', 'markersize', fixedMarkerSize+2, 'linewidth', 2, 'markerfacecolor', 'b');
        h_human_cur = plot(xx(1),yy_human_fit(1), 'ks', 'markersize', fixedMarkerSize+2, 'linewidth', 2, 'markerfacecolor', 'k');

        drawHorizontalLine(64, 'linestyle', ':', 'color', 'k');

        ylim([0, 100.3]);

        %     line(th_ideal * [1,1], [0, 64], 'color', 'b', 'linestyle', '--')
    %     line(th_model * [1,1], [0, 64], 'color', 'r', 'linestyle', '--')
    %     xlabel('Contrast energy / noise energy ({\itE}/{\itN})', 'fontsize', 14);
        xlabel('Signal to Noise Ratio', 'fontsize', 12);
        ylabel('% Correct', 'fontsize', 12);
        legend({'Ideal Observer', 'Ideal Observer (fit)', 'Human Performance', 'Human Performance (fit)' }, 'location', 'SE', 'fontsize', 9)
%         title('Psychometric curves', 'fontsize', 14)


    %     p = getPositionOfPointOnAxes(gca, -1, 0);
%         allIm_fine_v = [allIm_fine{:}]; allIm_fine_v = allIm_fine_v(:);
%         L = max(abs( lims(allIm_fine_v(:)) ));
        L = 15;
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        h_ax_let = subplotGap(subM,subN,let_subIdxsM, let_subIdxsN, [.01, 0, 0]);
%         h_ax_let = gca;

        
        
%         for i = 1:N
%             h_ax_stim(i) = subplotGap(M,N,i);
%             idx = find(allLogSNRs_plot(i) == allLogSNRs, 1);
        h_im = imagesc(allIm_fine{1});
        set(h_ax_let, 'xtick', [], 'ytick', []);
        axis square;

        h_title = title(sprintf('SNR  = 10^{%.0f}', allLogSNRs_fine(1)-1));
            
            
        colormap(gray);
        caxis([-L*.5, L]);
%         end
%         clims = get(h_ax_stim, 'cLim');

        snr_i = 1;
        
        save_folder = [lettersPath fsep 'Figures' fsep 'Slides' fsep 'psych' fsep];
        %%
        
        if showIdeal
            nUse = 1000;
            doIdealIn3D = 1;
%             figure(65); clf; 
            if ~showIdealOnSamePlot
                figure(fig_b); clf;
                ideal_subIdxsM = 1:subM; 
                ideal_subIdxsN = 1:subN;
            end
            h_ideal_ax = subplotGap(subM,subN, ideal_subIdxsM, ideal_subIdxsN, [.0, 0, .0]);
            hold on; box on;
            cols = jet(26);
            h_ideal3 = zeros(1,26);
            for i = 1:26
                idx = labels == i;
                if doIdealIn3D             
                    h_ideal3(i) = plot3(0,0,0, '.');
                else
                    h_ideal3(i) = plot(0,0, '.');
                end
                set(h_ideal3(i), 'color', cols(i,:), 'markersize', 2, 'marker', 'o', 'markerfacecolor',cols(i,:) );
                
%                 coeff
            end
            set(h_ideal3, 'visible', 'off');
            for i = 1:26
                h_text(i) = text(0, 1, i, char(i + 'A' - 1));
                set(h_text(i), 'Position', score(i,1:3), 'horizontalAlignment', 'center', 'verticalAlignment', 'middle', 'fontWeight', 'bold');
            end
%             set(h_text, 'visible', 'off');
            
            ticksOff(h_ideal_ax);
            xlabel('PCA 1', 'fontsize', 12);
            ylabel('PCA 2', 'fontsize', 12);
            if doIdealIn3D
                [az,el] = deal(120, 22);
                view(az, el);
                zlabel('PCA 3', 'fontsize', 12);
            else
                axis equal tight;
            end
            
            ext_frac = 0.1;
            xlims = lims(stimulusScores{end}(:,1), ext_frac);
            ylims = lims(stimulusScores{end}(:,2), ext_frac);
            zlims = lims(stimulusScores{end}(:,3), ext_frac);
            set(h_ideal_ax, 'xlim', xlims, 'ylim', ylims, 'zlim', zlims);
            set(fig_b, 'position', [766   416   603   461]);
            %%
%             set(h_ideal_ax, 'visible', 'off');
%             xlabel(''); ylabel(''); zlabel('');
            
             fname_letters = sprintf('Ideal_%s_letters_frame.png', fontName);
                print(fig_b, [save_folder fname_letters], '-dpng', '-r150');
            
        end
        
        %%
        3;
        nUse = 10000;
        for snr_i = 1:nSNRs_fine
            %%
%             snr_i = snr_i + 1;
            set(h_im, 'cData', allIm_fine{snr_i})
            
            
            idx_xx_closest = indmin(abs(10.^(allLogSNRs_fine(snr_i)-1)-xx));
            set(h_ideal_cur, 'xdata', xx(idx_xx_closest), 'ydata', yy_ideal_fit(idx_xx_closest));
            set(h_human_cur, 'xdata', xx(idx_xx_closest), 'ydata', yy_human_fit(idx_xx_closest));
            
            set(h_title, 'string', sprintf('SNR = 10^{%.1f}', allLogSNRs_fine(snr_i)-1));
            
            if showIdeal
                
                for i = 1:26
                     idx = labels(1:nUse) == i;
                     ideal_xs = stimulusScores{snr_i}(idx,1);
                     ideal_ys = stimulusScores{snr_i}(idx,2);
                     ideal_zs = stimulusScores{snr_i}(idx,3);
                     if doIdealIn3D
                         set(h_ideal3(i), 'xdata', ideal_xs, 'ydata', ideal_ys, 'zdata', ideal_zs, 'markersize', 3);
                     else
                         set(h_ideal3(i), 'xdata', ideal_xs, 'ydata', ideal_ys);                         
                     end
                end
                

                
            end
            
%             pause(.1);
            drawnow;
            
            fname1 = sprintf('Psych_%s_%.2f.emf', fontName, allLogSNRs_fine(snr_i));
%             hgsave(fig_a, [save_folder fname]);
%             print(fig_a, [save_folder fname1], '-dmeta', '-r300');
            
            if showIdeal && ~showIdealOnSamePlot
                fname2 = sprintf('Ideal_%s_%.2f.png', fontName, allLogSNRs_fine(snr_i));
    %             hgsave(fig_a, [save_folder fname]);
                print(fig_b, [save_folder fname2], '-dpng', '-r150');
                
                
            end
            

            
        end
        %%
        h_line = line([th_ideal, th_human], [64, 64], 'parent', h_ax_psych);
        set(h_line, 'color', 'r', 'linewidth', 2);
%         set(fig_a, 'position', [456         440        1082         334]);
        
        fname1 = sprintf('Psych_%s_%.2f_line.emf', fontName, allLogSNRs_fine(end));
        print(fig_a, [save_folder fname1], '-dmeta', '-r300');
        3;
        %%

%         clims_all = cat(1, clims{:});
%         lo = min(clims_all(:,1));
%         hi = max(clims_all(:,2));
%         maxVal = max(abs([lo, hi]));
%         lo = -maxVal/2;
%         hi = maxVal;
% 
%         set(h_ax_stim, 'clim', [lo, hi]);
        3;
        
        
    end
    %{
    elseif strcmp(plotType, 'forGrant')
        
         network_use = struct('netType', 'ConvNet', ...
                            'nStates', {{6,15}}, ...
                            'filtSizes', 5,...
                            'doPooling', true, ...
                            'poolSizes', 4, ...
                            'poolType', 2, ...
                            'poolStrides', 'auto' ... 
                          );

        expTitle = 'Complexity';
        snr_train = [1,2,3];
        opt.skipIfDontHaveModelFile = 1;
        pctCorrectTotal_model_v_snr = loadModelResults(expTitle, {fontName}, allLogSNRs, snr_train, network_use, noisyLetterOpts, opt, 10);   
        pctCorrectTotal_model_v_snr = pctCorrectTotal_model_v_snr.(fontName);

        pctCorrectTotal_model_v_snr = nanmean(pctCorrectTotal_model_v_snr, 4);

        plotHumanData = 1;
        if plotHumanData
            pctCorrectTotal_human = [0.468, 0.661, 0.784]*100; 
            allLogSNRs_use_human = log10([0.013948, 0.019881, 0.028465]*580);
        %     allLogSNRs_use_human = [0.2, 0.239, 0.286];

        %     pctCorrectTotal_human = [.223, .582, .822, .951]*100; 
        %     allLogSNRs_use_human = log10( [0.00014523, 0.00058092, 0.0013071, 0.0023237]*1500 );

            allSNRs_use_human = 10.^allLogSNRs_use_human;    
        end


        allLogSNRs_use = allLogSNRs-1;
        allSNRs_use = 10.^allLogSNRs_use;
        [th_ideal, ideal_fit] = getSNRthreshold(allLogSNRs_use, pctCorr_ideal);    
        [th_model, model_fit] = getSNRthreshold(allLogSNRs_use, mean(pctCorrectTotal_model_v_snr,1));
        [th_human, human_fit] = getSNRthreshold(allLogSNRs_use_human, pctCorrectTotal_human, 1);


        xx = logspace(allLogSNRs_use(1), allLogSNRs_use(end), 100);
        yy_ideal_fit = ideal_fit(xx);
        yy_model_fit = model_fit(xx);
        yy_human_fit = human_fit(xx);


        plotOnLogAxes = 1;

        xlims = lims(allSNRs_use, .001, [], 1);

        figure(45); clf; 
%         subplotGap(10,1,6:9, );
        line_w = 2;
        hold on; box on;
        if plotOnLogAxes
            plot(allSNRs_use, pctCorr_ideal, 'bo', 'markersize', 8, 'linewidth', line_w);
            plot(xx, yy_ideal_fit, 'b-', 'linewidth', line_w);

            plot(allSNRs_use, pctCorrectTotal_model_v_snr, 'rs', 'markersize', 8, 'linewidth', line_w);
            plot(xx, yy_model_fit, 'r-', 'linewidth', line_w);

            plot(allSNRs_use_human, pctCorrectTotal_human, 'ks', 'markersize', 8, 'linewidth', line_w);
            plot(xx, yy_human_fit, 'k-', 'linewidth', line_w);

            set(gca, 'xscale', 'log');
            xlim(xlims);

        else
            plot(allSNRs_use, pctCorr_ideal, 'bo', 'markersize', 8);
            plot(xx_ideal_fit, yy_ideal_fit, 'b-');

            plot(allSNRs_use, pctCorrectTotal_model_v_snr, 'rs', 'markersize', 8);
            plot(xx_ideal_model, yy_model_fit, 'r-');

            ylim([-1, 101]);
            xlim(xlims);
        end
        drawHorizontalLine(64, 'linestyle', '--', 'color', 'k');

        ylim([-1, 101]);

        %     line(th_ideal * [1,1], [0, 64], 'color', 'b', 'linestyle', '--')
    %     line(th_model * [1,1], [0, 64], 'color', 'r', 'linestyle', '--')
    %     xlabel('Contrast energy / noise energy ({\itE}/{\itN})', 'fontsize', 14);
        xlabel('{\itE}/{\itN}', 'fontsize', 14);
        ylabel('% correct', 'fontsize', 14);
        legend({'Ideal Observer', 'Ideal Observer (fit)', 'ConvNet', 'ConvNet (fit)', 'Human Performance', 'Human Performance (fit)' }, 'location', 'SE', 'fontsize', 7)
        title('Psychometric curves', 'fontsize', 14)


    %     p = getPositionOfPointOnAxes(gca, -1, 0);

        M = 2; N = nSNRs_plot;
        for i = 1:N
            h_ax_stim(i) = subplotGap(M,N,i);
            idx = find(allLogSNRs_plot(i) == allLogSNRs, 1);
            imagesc(allIm{idx});
            title(sprintf('{\\itE} / {\\itN} = 10^{%.0f}', allLogSNRs_plot(i)-1));
            colormap(gray);
            set(gca, 'xtick', [], 'ytick', []);
            axis square;
        end
        clims = get(h_ax_stim, 'cLim');

        clims_all = cat(1, clims{:});
        lo = min(clims_all(:,1));
        hi = max(clims_all(:,2));
        maxVal = max(abs([lo, hi]));
        lo = -maxVal/2;
        hi = maxVal;

        set(h_ax_stim, 'clim', [lo, hi]);
        3;
       
    end
      %}  
%     L = max(abs(cat(2, clims{:})));

    
    
end



%{
%%
S = load('sampleImage.mat');
    sampleImage = S.X;
%%
    figure(55); clf;
    im_use = allIm{6};
    n_pad = 3; %size(im_use,2)-size(im_use,1);
    im_use2 = circshift( im_use([1:end,end-2:end], :), [3, 0]);
    
    imagesc(im_use2);
  
    colormap('gray');
    axis equal tight; ticksOff;
    imageToScale([], 2);
    caxis([-3, 4])
%     caxis(c*8);
    
    
    
    %}