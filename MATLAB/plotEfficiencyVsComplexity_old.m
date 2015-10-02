function plotEfficiencyVsComplexity_old


%%
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'GeorgiaUpper', 'Yung', 'Kuenstler'};

% 	allFontNames      = {'Braille', 'Checkers4x4', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};
% 	allFontNames      = {'KuenstlerU', 'KuenstlerUB'};%, 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};

    allFontNames_ext = {'Sloan', 'SloanB', ...
                    'Helvetica', 'HelveticaB', 'HelveticaU', 'HelveticaUB',  ...
                    'Courier', 'CourierB', 'CourierU', 'CourierUB', ...
                    'Bookman', 'BookmanB', 'BookmanU', 'BookmanUB', ...
                    'Yung', 'YungB',     'KuenstlerU', 'KuenstlerUB'};

	allFontNames      = {'Bookman'};

    allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};

    
%     allFontNames = allFontNames_ext;
    
    % 	allFontNames      = {'Braille'};
    allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4];
    
%     plotNoisyTextureStatistics = 0;

    plotIndividualLetterResults = false;
    showLayer1Filters = false;
    
    if plotIndividualLetterResults
        allFontNames(strcmp(allFontNames, 'Braille')) = []; %#ok<*UNRCH>
        allFontNames(strcmp(allFontNames, 'Yung')) = [];        
    end

    opt.skipIfDontHaveModelFile = true;
    opt.useTrainingError = false;
    opt.skipIfDontHaveIdealFile = false;
    
    doSizeTuningTest = 0;
    
    allNStates_6_16_X = {   {6,16, 30}, {6,16,60}, {6,16,120}, {6,16,240}, {6,16,480}, {6,16,960} } ;
%     allNStates_6_16_X = { {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };
    allNStates_6_X_120 = {  {6, 4, 120},  {6, 8, 120},  {6, 16, 120},  {6, 32, 120}, {6, 64, 120},  {6, 128, 120}, {6, 256, 120} };
    allNStates_X_16_120 = { {3, 16, 120}, {6, 16, 120},  {12, 16, 120}, {24, 16, 120}, {48, 16, 120}, {96, 16, 120}, {192, 16, 120}  };

    allNStates_6_X = { {6, 15}, {6, 30}, {6,60}, {6,120}, {6, 240} };
    
    allNStates_12_X = { {12, 15}, {12, 30}, {12,60}, {12,120}, {12, 240} };
    
    
    
%     allNStates_use = { [3, 8, 60], [6, 16, 120], [9,24, 180], [12, 32, 240], [30, 80, 600], [60, 160, 1200] };
%     allNStates_use = { [6, 50], [6, 100], [12, 50], [12, 100] };
%     allNStates_use = { [3,8,60], [6, 16, 120]  };
%     allNStates = { [6, 100]  };
    
%     allNStates = { [3, 8, 15], [3, 8, 60], [3, 6, 10]  };
    
%     allNStates = { [3, 8, 60], [6, 16, 120], [6, 16, 30], [12,32,240]};

%     allNStates_all = {  {3, 8, 60}, {6, 16, 120}, {6, 16, 30}, {6,16, 15}, {6,16,8}, {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };

% { {6,15}, {12,15}, {24,15}, {6,30}, {6,60}, {6,120}, }
    allNStates_cmp = {  {6, 15}, {6, 30}, {6,60}, {6,120}, {24, 15}, {12,30}, {12, 60}, {24, 120}, {48, 120} };
    allNStates_cmp = allNStates_cmp(9);
    
    allNStates_cmp = {  {6, 15}, {6, 30}, {6,60}, {6,120} };

    allNStates_6_X = {  {6, 8}, {6, 15}, {6, 30}, {6,60}, {6,120} };
    allNStates_X_15 = {  {3, 15}, {6, 15}, {12, 15}, {24,15}, };


%     allFiltSizes = {10, 15, 20, 25, 30};
  
    nTrials = 4;
    expTitle = 'Complexity';
%     expTitle = 'NoisyLettersTextureStats';
    
%     netType = 'ConvNet';
    netType = 'MLP';
    
    
    switch expTitle 
        case 'Complexity'
            allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4];
        case 'NoisyLettersTextureStats',
            allSNRs_test = [0, 1, 2, 2.5, 3, 4, 5];

    end
    
%     sizeStyle = 'large';
    sizeStyle = 'med';
    
%     sizeStyle_full = switchh(sizeStyle, {'sml', 'med', 'big', 'dflt'}, {'Small', 'Medium', 'Large', 'Default'});
    
    switch netType
        case 'ConvNet',
%             snr_train = [1,2,3,4];
            snr_train = [1,2,3,4];
       
            
%             allNStates = {  {3, 8, 60}, {6, 16, 120}, {6, 16, 30}, {6,16, 15}, {6,16,8}, {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };
%             allNStates = {  {3, 8, 60}, {6, 16, 120}, {6, 16, 30}, {6,16, 15}, {6,16,8}, {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };

            
%             allNStates = { {6, 15}, {6, 30}, {6,60}, {6,120}, {6, 240}, {12, 15}, {12, 30}, {12,60}, {12,120}, {12, 240} };
%             allNStates = { {6, 15}, {6, 30}, {6,60}, {6,120}, {6, 240} };
%             allNStates = { {12, 15}, {12, 30}, {12,60}, {12,120}, {12, 240} };
%             allNStates = { {6, 15}, {6, 30}, {6,60}, {6,120}, {6, 240} }; 
%             allNStates = { {12, 15}, {12, 30}, {12,60}, {12,120}, {12, 240} };
            %     allNStates = { {3,8,60}, {6, 16, 120}, {12,32,240} };
        %     allNStates = {  {6, 16, 120}, {6, 16, 30}, {6,16, 15}, {6,16,8}, };
        %     allNStates = {  {6, 16, 120}, {12,32,240}, 
        % %     allNStates = {  {6, 16, 120}, {12,32,240}, 
        %       allNStates = {  {3,8,3}, {3,8,5}, {3,8,10},  {3,8,30} };
        
%             allNStates = allNStates_6_16_X;
%             allNStates = allNStates_6_X_120;
%             allNStates = allNStates_X_16_120;
%             allNStates = allNStates_6_X;
%             allNStates = allNStates_12_X;

%             allNStates = { {6, 15}, {6,30}  };
%             allNStates = [allNStates_12_X];

%             allNStates = allNStates_6_X;
%             allNStates = allNStates_X_15;
%             allNStates_X_X = [allNStates_6_X, allNStates_X_15];        
%             allNStates = allNStates_X_X; %{ {6,15} };

            allNStates = { {6,15} };

        
            if iscell(allNStates(1))
                allNStates = cellcell2cellarray(allNStates);
            end
           
            filtSizes = [0];
%             filtSizes = [5,4];
            allFiltSizes = {2,4,5,10,20};
            
            doPooling = 1;
            all_doPooling = {0, 1};

%             poolSize = [4 2];
            poolSize = [4];
            allPoolSizes = [0,2,4,6,8];
%             allPoolSizes = [2,4,6,8,10,12];
%              allPoolSizes = [2,4,6];

            allPoolSizes_C = num2cell(allPoolSizes);
            
            poolType = 1;
            allPoolTypes = {1,2,'MAX'};
            
            poolStrides = 'auto';
%             poolStrides = 4;
            
            allConvNetOptions = struct('netType', 'ConvNet', ...
                                        'tbl_nStates', {allNStates}, ...
                                        'filtSizes', filtSizes,...
                                        ...'tbl_filtSizes', {allFiltSizes}, ...
                                        ...
                                        'doPooling', doPooling, ...
                                        ...'tbl_doPooling', {all_doPooling}, ...
                                        ...
                                        ...'poolSizes', poolSize, ...
                                        'tbl_poolSizes', {allPoolSizes_C}, ...
                                        ...
                                        'poolType', poolType, ...
                                        ...'tbl_poolType', {allPoolTypes}, ...
                                        ...
                                        'poolStrides', poolStrides ... 
                                      );
            allNetworks = expandOptionsToList(allConvNetOptions);

%             network_noPooling = struct('netType', 'ConvNet', ...
%                                         'nStates', allNStates{1}, ...
%                                         'filtSizes', filtSizes,...
%                                         'doPooling', false, ...
%                                         'poolType', poolType, ...
%                                         'poolSizes', 0, ...
%                                         'poolStrides', poolStrides ...
%                                         ...'tbl_filtSizes', {allFiltSizes}, ...
%                                       );
%             allNetworks = [network_noPooling, allNetworks];

            
        case 'MLP',
%             snr_train = [2 3 4 5];
            snr_train = [4];

%            allNHiddenUnits = { {6}, {12}, {24}, {48}, {96},   {6, 16}, {6, 32}, {6, 64},   {12, 16}, {12, 32}, {12, 64} };
%            allNHiddenUnits = { {}, {30}, {100} };
           allNHiddenUnits = { {} };
           allMLPoptions = struct('netType', 'MLP', ...
                                        'tbl_nHiddenUnits', {allNHiddenUnits} ...
                                      );
            allNetworks = expandOptionsToList(allMLPoptions);
    end
    nNetworks = length(allNetworks);

    
         
    useOldStim = 0;
    if useOldStim
        allFontNames = {'Braille', 'GeorgiaUpper', 'Yung', 'Kuenstler'};
        allSNRs_test = [1, 2, 3, 4];
    end
    
    nFonts = length(allFontNames);

            
  
    ori_x_y = {[0], [0],  [0]};
%         ori_x_y = {[0], [0,3], [0]};   % 2x1
%         ori_x_y = {[0], [0,3,6], [0]}; % 3x1
%         ori_x_y = {[0], [0:6], [0]};    % 7x1
%         ori_x_y = {[0], [0:6], [0:6]};  % 7x7
%         ori_x_y = {[0], [0:9], [0:9]};  % 10x10
%          ori_x_y = {[-4:2:4], [0], [0]};   % 5 x 1x1
%         ori_x_y = {[-4:2:4], [0:4], [0:4]};   % 5 x 5 x 5
%          ori_x_y = {[-4:2:4], [0:9], [0:9]};   % 5 x 10 x 10
        
        
%         oris = [0]; xs = [0:6]; ys = [0];
    [oris, xs, ys] = ori_x_y{:};

    textureStatOpts_C = {};
    

    switch expTitle
        
        case 'Complexity'
            
             if doSizeTuningTest

%                 all_sizeStyles = [12,16,20,24];
                all_sizeStyles = [8,16,24];
                all_sizeStyles_C = num2cell(all_sizeStyles);

        %         all_imageSizes_C = {[20,20],[50,50], [80,80]};
                all_imageSizes_C = {[50,50]};
        %         all_sizeStyles = [15, 16];
        %         all_imageSizes_C = { [34,38] };


                autoImageSize = 0;
             else
                 
                      
                all_sizeStyles_C = {sizeStyle};
                all_imageSizes_C = {'auto'};
                autoImageSize = 1;
                 
             end
            
            expTitle = 'NoisyLetters';
            opt_str_func = @getNoisyLetterOptsStr;
            textureStatOpts_C = {};
            
        case 'NoisyLettersTextureStats'
            

            Na_sub_txt = 'all';
%             Nscl_txt = 3;  Nori_txt = 2;  Na_txt = 3; 
%             Nscl_txt = 3;  Nori_txt = 2;  Na_txt = 3; 
            Nscl_txt = 3;  Nori_txt = 4;  Na_txt = 9; 
%             Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 7; 
%             Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 9; 
%             Nscl_txt = 2;  Nori_txt = 3;  Na_txt = 9;  Na_sub_txt = 'all';

            imageSize = 32;   sizeStyle = 'med';
%             imageSize = 64;   sizeStyle = 'large';
            textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt, 'Na_sub_txt', Na_sub_txt, 'imageSize', imageSize};

            all_sizeStyles_C = {sizeStyle};

    %         all_imageSizes_C = {[20,20],[50,50], [80,80]};
            all_imageSizes_C = {[imageSize,imageSize]};
            autoImageSize = 0;
            
            expTitle = 'NoisyLettersTextureStats';
            opt_str_func = @getNoisyLettersTextureStatsOptsStr;
   
    end

    
    allBlurStd_C = {0, 1, 2, 3};
%     allBlurStd_C = {0};
%     allBlurStd_C = {0};
    allNoisyLetterOpts = expandOptionsToList (struct( ...
                                'oris', oris, 'xs', xs, 'ys', ys, 'expTitle', expTitle, 'tf_pca', 0, ...
                                'tbl_sizeStyle', {all_sizeStyles_C}, ...
                                'tbl_imageSize', {all_imageSizes_C}, ...
                                'autoImageSize', autoImageSize, ...
                                'tbl_blurStd', {allBlurStd_C}, ...
                                textureStatOpts_C{:} ...
                             ) );

    nOpts = length(allNoisyLetterOpts);
    
    opt_str = opt_str_func(allNoisyLetterOpts(1));

    
    %%%%% Load ideal performance
    for opt_i = 1:nOpts
        for fi = 1:nFonts
            fontName = allFontNames{fi};
            [pctCorr_ideal(opt_i).(fontName), pctCorrEachLetter_ideal(opt_i).(fontName)] = getIdealPerformance(fontName, allSNRs_test, allNoisyLetterOpts(opt_i), opt); %#ok<NASGU,AGROW>

        end
    end
    getIdealPerformance('save');
    
    %%%%% Load model performance 
    for opt_i = 1:nOpts
        [pctCorrectTotal_model_v_snr(opt_i), pctCorrectEachLetter_model_v_snr(opt_i)] = loadModelResults(expTitle, allFontNames, allSNRs_test, snr_train, allNetworks, allNoisyLetterOpts(opt_i), opt, nTrials);    %#ok<NASGU,AGROW>
        if showLayer1Filters
            trainedNetworks = loadTrainedModel(expTitle, allFontNames, snr_train, allNetworks, noisyLetterOpts, opt);
        end
        
%         noisyLetters_str{opt_i} = getNoisyLetterOptsStr(allNoisyLetterOpts(opt_i));

    end
    loadModelResults('save');
%     3;
    
    nClasses = 26;
    
    model_efficiences       = zeros(1,        nFonts, nNetworks, nTrials, nOpts);
    model_efficiences_indiv = zeros(nClasses, nFonts, nNetworks, nTrials, nOpts);

    font_complexities_model       = zeros(1,        nFonts);
    font_complexities_model_indiv = zeros(nClasses, nFonts);
    

    th_model = zeros(1,nFonts,nNetworks, nTrials, nOpts);    
%     th_model_indiv = zeros(nClasses,nFonts,nNetworks, nTrials);    
    
    th_ideal = nan(1,nFonts, nOpts);
%     th_ideal_indiv = zeros(nClasses,nFonts);
    


%%
    fprintf('Calculating Efficiencies ...');
    progressBar('init-',nOpts*nNetworks*nFonts); 
    for opt_i = 1:nOpts
        font_sz = allNoisyLetterOpts(opt_i).sizeStyle;
        
        for fi = 1:nFonts
            fontName = allFontNames{fi};
            [font_complexities_model(fi), font_complexities_model_indiv(:,fi)] = getFontComplexity(fontName, font_sz);

            pctCorrect_model_i = pctCorrectTotal_model_v_snr(opt_i).(fontName);
            pctCorrect_ideal_i = pctCorr_ideal(opt_i).(fontName)(:)';

            if plotIndividualLetterResults
                pctCorrect_model_indiv_i = pctCorrectEachLetter_model_v_snr(opt_i).(fontName);
                pctCorrect_ideal_indiv_i = pctCorrEachLetter_ideal(opt_i).(fontName);
            end

            for net_idx = 1:nNetworks

                for trial_i = 1:nTrials
                    [model_efficiences(1,fi,net_idx, trial_i, opt_i), th_model(1,fi,net_idx,trial_i),  th_ideal(1,fi)] = ...
                        getModelEfficiency(allSNRs_test, pctCorrect_model_i(trial_i,:,:,net_idx), pctCorrect_ideal_i);


                    if plotIndividualLetterResults
                        [model_efficiences_indiv(:,fi,net_idx, trial_i, opt_i)] = ...
                            getModelEfficiency(allSNRs_test, pctCorrect_model_indiv_i(:,:,net_idx, trial_i), pctCorrect_ideal_indiv_i);
                    end

                end
                progressBar;
            end

        end
    
    end
    
     model_efficiences_M = nanmean(  model_efficiences, 4);
     model_efficiences_S = nanstd(model_efficiences, [], 4);   

%%
     niceLegendFields = {'doPooling', 'poolSizes'}; %'doPooling', 'poolSizes', 'poolStrides'}; %'filtSizes', 'doPooling'};
    if nNetworks > 1
        [~, legend_str_nice] = arrayfun(@(n) getNetworkStr(n, niceLegendFields), allNetworks, 'un', 0);
    else
        [~, net_str_nice] = getNetworkStr(allNetworks(1), niceLegendFields);
        
        [~, legend_str_nice] = arrayfun(@(op) getLetterOptsStr(op, 1),  allNoisyLetterOpts(1), 'un', 0);
        legend_str_nice = cellfun(@(s) [net_str_nice '; ' s], legend_str_nice, 'un', 0);
        
    end
  %%   
     
     if doSizeTuningTest
         %%
        figure(39); clf; hold on; box on;

        model_efficiences_M = reshape(model_efficiences_M, nNetworks, length(all_imageSizes_C), length(all_sizeStyles));
         model_efficiences_S = reshape(model_efficiences_S, nNetworks, length(all_imageSizes_C), length(all_sizeStyles));
         
         plotErrorbars = 0;
         
         addHumanData = 0;
         
         x_data = 'fontSize';
         mult_lines = 'poolSize';
         mult_plots = 'filtSize';
         
         
         
         
         
         
         
%          x_deg  =         [0.1,   0.25,  0.5,  1,    2,     4,     8,     16,    30];
%          human_eff_0    = [0.0715, 0.095, 0.14, 0.12, 0.097, 0.075, 0.053, 0.036, 0.0275];
%          human_eff_5deg = [nan     0.04  0.065, 0.111, 0.078, 0.065, 0.049, 0.035, 0.0255];

         x_deg  =        [0.25,  0.5,  1, 2];
         human_eff_5deg = [0.04  0.065, 0.111, 0.078];

         x_scale_human = 1;
         y_scale_human = 1;
%          plot(
        if 0
            %%
             x_deg  =         [0.1,   0.25,  0.5,  1,    2,     4,     8,     16,    30];
             human_eff_0deg = [0.0715, 0.095, 0.14, 0.12, 0.097, 0.075, 0.053, 0.036, 0.0275];
             human_eff_5deg = [nan     0.04  0.065, 0.111, 0.078, 0.065, 0.049, 0.035, 0.0255];
            
            figure(55); clf; hold on; box on;
            plot(x_deg, human_eff_0deg, 'bs:', 'markersize', 8, 'linewidth', 2);
            plot(x_deg, human_eff_5deg, 'ro:', 'markersize', 8, 'linewidth', 2);
            set(gca, 'xscale', 'log', 'yscale', 'log')
            
            idx = 3:9;
            x1 = x_deg(idx);
            y1 = human_eff_0deg(idx);
            
            p = polyfit( log10(x1), log10(y1), 1);
            c = nlinfit(log10(x1), log10(y1), @(beta, x) beta + x, 0);
        
            x_deg_line = lims(x1, .1, [], 1); 
            plot(x_deg_line, 10.^polyval(p, log10(x_deg_line)), 'k-', 'linewidth', 3);
            title(sprintf('Slope of line = %.2f', p(1)));

            
            
        end


        if addHumanData
           errorbar(x_deg, human_eff_5deg, ones(size(human_eff_5deg))*.01, 'ks', 'markersize', 8, 'linewidth', 2);
           
                   
            p = polyfit( log10(x_deg(1:3)), log10(human_eff_5deg(1:3)), 1);
            c = nlinfit(log10(x_deg(:)), log10(human_eff_5deg(:)), @(beta, x) beta + x, 0);

            x_deg_line = lims([x_deg(1), x_deg(3)], .1, [], 1); 
    %         y_line = human_eff_5deg([1, end]);
            plot(x_deg_line, 10.^polyval(p, log10(x_deg_line)), 'k-', 'linewidth', 3);

        end  


        x_scale_model = 1;
        y_scale_model = 1;
% 
%         x_scale_model = .038;
%         y_scale_model = .35;
%%
        line_s = {'--', '-', ':'};
        cols = 'b'; %'rbg';
        for net_i = 1:nNetworks
            xx_model = repmat(all_sizeStyles', 1, length(all_imageSizes_C)) * x_scale_model;
            yy_model = squeeze(model_efficiences_M(net_i,:,:))' * y_scale_model;
            err_model = squeeze(model_efficiences_S(net_i,:,:))' * y_scale_model;
            if plotErrorbars
                h(net_i,:) = errorbar(xx_model, yy_model, err_model, 'o-');
            else
                h(net_i,:) = plot(xx_model, yy_model, 'o-');
            end
            set(h(net_i,:), 'linestyle', line_s{net_i}, 'markersize', 8, 'linewidth', 2)
            for j = 1:length(all_imageSizes_C)
                set(h(net_i,j), 'color', cols(j))
            end
        end
        set(h(1), 'color', 'r')
        
        xlabel('Letter Size (deg)', 'fontsize', 16);
        ylabel('Efficiency', 'fontsize', 16);
%         set(gca, 'xtick', all_sizeStyles, 'yscale', 'linear');
        
        set(gca, 'xscale', 'log', 'yscale', 'log')
        
        
        
        
%         xlims = lims([.1, 2], .1, [], 1);
%         ylims = lims([.01, .5]);
%         
%         xlim( xlims );
%         ylim( ylims );
%         decades_equal;
        
        all_imageSizes_Mtx = [all_imageSizes_C; all_imageSizes_C];
        all_doPooling_Mtx = num2cell( [0;1] * ones(1, length(all_imageSizes_C)) );
            
        
%         legend_strs = cellfun(@(im_sz, doPool) sprintf('Image = %d x %d %s', im_sz, iff(doPool, '(pooling)', '(no pooling)')), all_imageSizes_Mtx', all_doPooling_Mtx', 'un', 0);
%         legend_strs = {'Human Performance', sprintf('Slope = %.2f', p(1)), 'ConvNet: No pooling', 'ConvNet: Pooling = 4x4'};
        legend(legend_strs(:), 'location', 'SE', 'fontsize', 12);
        3; 
         
         
     end
     

     %%
     human_plotAllFonts = true;
    if human_plotAllFonts
%         allFontNames_human = setdiff( fieldnames(getStatsFromPaper), {'Checkers4x4', 'words3', 'words5', 'words5_many'});
        allFontNames_human = setdiff( fieldnames(getStatsFromPaper), {'words3', 'words5', 'words5_many'});
        
    else
        allFontNames_human = allFontNames;
    end
    
%     idx_model_fonts = cellfun(@(fn) find(strcmp(fn, allFontNames_human),1), allFontNames);

    nFonts_human = length(allFontNames_human);
    [human_efficiencies, human_efficiencies_stderr, font_complexities_human] = deal( zeros(1, nFonts_human) );

    
    for fi = 1:nFonts_human
        human_efficiencies(fi) = getStatsFromPaper(allFontNames_human{fi}, 'efficiency');
        human_efficiencies_stderr(fi) = getStatsFromPaper(allFontNames_human{fi}, 'efficiency_stderr_est');
        font_complexities_human(fi) = getStatsFromPaper(allFontNames_human{fi}, 'complexity');
    end
     
     
    %%
    orderByComplexity = false;
    if orderByComplexity
        [font_complexities_model, font_idx_modelC] = sort(font_complexities_model);
        
        model_efficiences_indiv = model_efficiences_indiv(:, font_idx_modelC, :);
        model_efficiences_M = model_efficiences_M(:,font_idx_modelC,:);
        th_model= th_model(:,font_idx_modelC,:);        

%         [font_complexities_human, idx_humanC] = sort(font_complexities_human);
%         human_efficiencies = human_efficiencies(idx_humanC);
%         human_efficiencies_stderr = human_efficiencies_stderr(idx_humanC);    
        
    else
        font_idx_modelC = 1:length(font_complexities_model);
    end
    
    model_efficiences_expected = 9.1./font_complexities_model;
    
    %%
    if showLayer1Filters 
        figure(5); clf; 
    %     m = floor(sqrt(nNetworks));
    %     n = ceil(nNetworks/m);
        i = 1;
        for net_i = 1:nNetworks
            for fi = 1:nFonts
                h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); imagesc(tileImages( trainedNetworks{net_i, fi}, [], [], 2, 0) );
                i = i + 1;
            end

        end
        set(h_axx, 'xtick', [], 'ytick', [])
        colormap('gray');
    end
    3;
    
    
    %%
    figure(6); clf; hold on; box on;
    
%     niceLegendFields = {'filtSizes', 'poolSizes', 'doPooling'};

    
    

%     y = -x + 2
    
    
%     cols = ['bgrk'];
    addSlopesToLegend = false;
    lineSt = {'-', '--'};
%     mkrs = ['os*v'];
    colors_use = 'bgrcm';
    markers_use = 'oxs*dph';
    idx_notBraille = find(~strcmp(allFontNames, 'Braille'));
    letters_charU = 'A':'Z';
    letters_charL = 'a':'z';
    mk_size = 7;
    line_w = 2;
       
%     plotHumanEfficiencyLineFit = true; 
    plotHumanEfficienyPoints = false;
    plotEfficiencyLineFit_human = true; 
    plotEfficiencyConnectingLine_human = false; 

    plotEfficiencyLineFit_model = false; 
    plotEfficiencyConnectingLine_model = true; 
    plotLinesConnectingBoldToNonbold_model = true; 
    showErrorBarsForMultipleTrials_model = true;
    

    if plotHumanEfficienyPoints
        
%         plot(font_complexities_human, human_efficiencies, 'k:^', 'linewidth', 2, 'markersize', 8)
        h_eff_human_pts = errorbar(font_complexities_human, human_efficiencies, human_efficiencies_stderr, 'k:s', 'markersize', mk_size, 'linewidth', line_w);
        if ~plotEfficiencyConnectingLine_human
            set(h_eff_human_pts, 'lineStyle', 'none')
        end
        human_pts_str = {'Human performance'};
        3;
        
    else
        h_eff_human_pts = [];
        human_pts_str = {};
    end
    
    if plotEfficiencyLineFit_human
        font_complexities_human_srt = lims(font_complexities_human);
        human_efficiencies_fit = 9.1./font_complexities_human_srt;
%     plot(font_complexities_human, human_efficiencies, 'k^', 'linewidth', 2, 'markersize', 8)
        h_eff_human_fit = plot(font_complexities_human_srt, human_efficiencies_fit, 'k-', 'linewidth', 2);
        
        human_fit_str = {'Human performance (fit)'};
    else
        human_fit_str = {};
        h_eff_human_fit = [];
    end

    
    
    plotIndivLettersRelativeToMean = false;
    if plotIndivLettersRelativeToMean
        font_complexities_model_indiv_plot = bsxfun(@rdivide, font_complexities_model_indiv, font_complexities_model);
        model_efficiences_indiv_plot = bsxfun(@rdivide, model_efficiences_indiv, model_efficiences_M);
    else
        font_complexities_model_indiv_plot = font_complexities_model_indiv;
        model_efficiences_indiv_plot = model_efficiences_indiv;
    end
    
    


    networks_vary_color = nNetworks > 1;
    color_idx_start = 1;
    marker_idx_start = 1;
    
    if networks_vary_color   % networks are different colors. opts vary by marker
    %%

        all_colors  = repmat( color_s(1:nNetworks + color_idx_start-1, colors_use)', [1, nOpts]);
        all_markers = repmat( marker(1:nOpts + marker_idx_start-1, markers_use), [nNetworks, 1]);

    
%     all_colors = repmat( colors_s(1:nOpts, colors_use), [nNetworks, 1]);        
%         all_markers = repmat( marker(1:nNetworks), [nNetworks, 1]);

    else % networks have different markers. opts vary by color
        %%
        all_colors  = repmat( color_s(1:nOpts + color_idx_start-1, colors_use), [nNetworks, 1]);
        all_markers = repmat( marker(1:nNetworks + marker_idx_start-1, markers_use)', [1, nOpts]);
        
        
    end
    assert(isequal(size(all_colors), [nNetworks, nOpts]))
    assert(isequal(size(all_markers), [nNetworks, nOpts]))
        
    
    for net_i = 1:nNetworks
        for opt_i = 1:nOpts
    %         line_s = lineSt{ floor(net_i/6)+1};

            line_s = iff( plotEfficiencyConnectingLine_model, '--', ''); %linestyle( floor(net_i/6) );
    %         mkr_s = 'o'; marker(net_i, markers_use);   % marker( floor(net_i/6)+2);
    %         mkr_s = marker( net_i+1 );
    %         clr_s = color_s(net_i, colors_use);
            clr_s = all_colors(net_i, opt_i);
            mkr_s = all_markers(net_i, opt_i);

            [log_slope, log_slope_ci, p_fit] = getLogSlope(font_complexities_model, model_efficiences_M(:,:,net_i, 1, opt_i) );
            [log_slope_noB, log_slope_noB_ci, p_fit_noB] = getLogSlope(font_complexities_model(idx_notBraille), model_efficiences_M(:,idx_notBraille, net_i, 1, opt_i));


            if ~plotIndividualLetterResults

    %             font_complexities_model_mtx = repmat(font_complexities_model(:), 1, nFonts);
                if (nTrials > 1) && any(model_efficiences_S(:,:,net_i) > 0)  && showErrorBarsForMultipleTrials_model
    %                 h(net_i) = errorbar(x_vals, all_pCorr1_M(:,line_i), all_pCorr1_S(:,line_i), [mkr_s clr_s '-'], 'markersize', 8);

                    h_eff_model_pts(net_i, opt_i) = errorbar(font_complexities_model, model_efficiences_M(1,:,net_i, 1, opt_i), model_efficiences_S(:,:,net_i, 1, opt_i), [clr_s mkr_s line_s]);
                else
                    h_eff_model_pts(net_i, opt_i) = plot(font_complexities_model, model_efficiences_M(1,:,net_i, 1, opt_i), [clr_s mkr_s line_s]);
                end            
                set(h_eff_model_pts(net_i, opt_i), 'markersize', mk_size, 'linewidth', line_w)

                if plotEfficiencyLineFit_model
                    eff_fit_i = 10.^ polyval(p_fit, log10(font_complexities_model) );
                    h_eff_model_fit(net_i) = plot(font_complexities_model, eff_fit_i, [clr_s '-'], 'linewidth', line_w);
                end

                if plotLinesConnectingBoldToNonbold_model
                    allPlainFonts = allFontNames( cellfun(@(s) any(strcmp(s, allFontNames)) && any(strcmp([s 'B'], allFontNames)), allFontNames) );
                    allBoldFonts = cellfun(@(s) [s 'B'], allPlainFonts, 'un', 0);
                    plain_idxs = find(strCcmp(allFontNames(font_idx_modelC), allPlainFonts));
                    bold_idxs = find(strCcmp(allFontNames(font_idx_modelC), allBoldFonts));
                    allCombos = {'bgrcmk', {'-', '--'}};

                    removeLet = @(s, let) iff(s(end) == let, s(1:end-1), s);

                    allUniqFontNames = uniqueInOrder( cellfun(@(s) removeLet(s, 'U'), allPlainFonts, 'un', 0) );

                    h_bold_lines = [];
                    for j = 1:length(allUniqFontNames)
                        idxs = find(strncmp(allUniqFontNames{j}, allPlainFonts, length(allUniqFontNames{j}) ) );

                        for k = 1:length(idxs)
                            line_s = iff(allPlainFonts{idxs(k)}(end) == 'U', '--', '-');

                            h_bold_lines(end+1) = plot(font_complexities_model([plain_idxs(idxs(k)) bold_idxs(idxs(k))]), model_efficiences_M(1,[plain_idxs(idxs(k)) bold_idxs(idxs(k))], net_i, 1, opt_i), [color_s(j), 'o' line_s], 'linewidth', 2,  'markersize', mk_size); 
                        3;
                        end

                    end
                    3;
                    legend([h_bold_lines], [allPlainFonts], 'interpreter', 'none');
                end


            elseif plotIndividualLetterResults
    %%
                color_s2 = 'bgrkm';
                figure(100+net_i+10); clf; hold on; box on;
    %             h_line(net_i) = plot(font_complexities_model, model_efficiences(:,:,net_i), 'bo-');
                for font_i = 1:nFonts
                    h_tmp(net_i) = plot(1, nan, 'color', color_s2(font_i));
    %                 h_indiv(j) = plot(font_complexities_model_indiv(:,j), model_efficiences_indiv(:,j,net_i), [color_s(j) marker(j)]);

                    if strcmp(allFontNames{font_i}, 'Sloan')
                        letters_char = letters_charU;
                        font_weight = 'normal';
                    else
                        letters_char = letters_charL;
                        font_weight = 'normal';
                    end

                    for let_i = 1:size(model_efficiences_indiv,1)
                        h_txt(let_i,font_i) = text(font_complexities_model_indiv_plot(let_i,font_i), mean(model_efficiences_indiv_plot(let_i,font_i,:),3), letters_char(let_i), 'color', color_s2(font_i), 'fontsize', 15, 'fontweight', font_weight);                    

                    end
                    if any(strcmp(allFontNames{font_i}, {'Bookman', 'Helvetica', 'Courier'}))
                        set(h_txt(:,font_i), 'fontName', allFontNames{font_i})
                    else
                        set(h_txt(:,font_i), 'fontName', 'Arial')
                    end

                end

                Lh = lims(font_complexities_model_indiv_plot, .05);
                Lv = lims(mean(model_efficiences_indiv_plot,3), .05);
                axis([Lh; Lv]);
                fplot(@(x) -x+2, xlim, 'k-')

    %             L = max(abs(lims([font_complexities_model_indiv_plot; model_efficiences_indiv_plot], .1)-1));
    %             axis([-Lh, Lh, -Lv, Lv]+1);
                xlabel('Letter Complexity / Mean Font Complexity', 'fontsize', 14)
                ylabel('Letter Efficiency / Mean Font Efficiency', 'fontsize', 14)
                legend(allFontNames, 'fontsize', 14)

            end

    %         alpha = .05;

            rms_i = rms(log10(model_efficiences_M(:,:,net_i, 1, opt_i)) - log10(model_efficiences_expected) );
            meanDist_i = mean(log10(model_efficiences_M(:,:,net_i, 1, opt_i)) - log10(model_efficiences_expected) );
            abs_i = mean(abs(log10(model_efficiences_M(:,:,net_i, 1, opt_i)) - log10(model_efficiences_expected) ));

            allRMS(net_i) = rms_i;
            allMeanDists(net_i) = meanDist_i;
            allABS(net_i) = abs_i;
            allLogSlope(net_i) = log_slope;
            allLogSlope_ci(:,net_i) = log_slope_ci;
            allLogSlope_noB(net_i) = log_slope_noB;
            allLogSlope_noB_ci(:,net_i) = log_slope_noB_ci;



            fprintf('%s : rms log10 error = %.3f. (%.3f)  log_slope = %.2f.  (without braille: %.2f) \n', legend_str_nice{net_i}, rms_i, abs_i, log_slope, log_slope_noB);
            if ~isnan(log_slope) && addSlopesToLegend
                legend_str_nice{net_i} = sprintf('%s [%.1f]', legend_str_nice{net_i}, log_slope);
            end
            3;
    %         rms(log10(model_efficiences_M(:,:,net_i) - log10(human_efficiencies)) );
    %         fprintf('%s : ', )
        end
    end

    if plotIndividualLetterResults
        %%
        figure(55); clf; hold on; box on;
        
        expectedEffiency = 1./font_complexities_model_indiv_plot;
        idx_sortBy = find(strcmp(allFontNames, 'Bookman'), 1);
        for net_i = 1:nNetworks
            efficiency_gap(:,:,net_i) = model_efficiences_indiv_plot(:,:,net_i) - expectedEffiency;

        end
        efficiency_gap_mean = nanmean(efficiency_gap, 3);
        efficiency_gap_std = nanstderr(efficiency_gap, 3);
        
        [~, idx_order] = sort(efficiency_gap_mean(:,idx_sortBy,1));
%         idx_order = 1:26;
        efficiency_gap_mean_srt = efficiency_gap_mean(idx_order, :,:);
        efficiency_gap_std_srt = efficiency_gap_std(idx_order, :,:);
        
        errorbar(repmat([1:nClasses]', 1, nFonts), efficiency_gap_mean_srt, efficiency_gap_std_srt);
        set(gca, 'xtick', 1:26, 'xticklabel', arrayfun(@(i) char(i+'a'-1), idx_order, 'un', 0))
        xlim([0, 27]);
        legend(allFontNames, 'location', 'best')
        3;
        

        
    end
    
    
    
    
    %set(h_line(1), 'color', 'r', 'linestyle', ':', 'marker', 's', 'linewidth', 2, 'markersize', 8)
%     set(h_line(6), 'color', 'k')


    
    legend_str_nice = [human_pts_str{:}; human_fit_str{:}; legend_str_nice(:) ];

    legend([h_eff_human_pts, h_eff_human_fit, h_eff_model_pts], legend_str_nice, 'location', 'SW', 'interpreter', 'none')
    if ~(plotIndividualLetterResults && plotIndivLettersRelativeToMean)
        set(gca, 'xscale', 'log', 'yscale', 'log');
    %     set(gca, 'ylim', [.02, 1], 'xlim', [20, 100]);
        % set(gca, 'ylim', [.01, 1], 'xlim', [10, 100]);
        allFonts_list = ['[ ' cellstr2csslist(allFontNames(font_idx_modelC)), ']'];
        xlabel({'Complexity', allFonts_list}, 'fontsize', 13)
%         xlabel('Complexity', 'fontsize', 13)
        ylabel('Efficiency', 'fontsize', 13);
%         ylim([.01, 1]);
        xlim([10, 1000]);
    end
    decades_equal;
    trainErrStr = iff(opt.useTrainingError, ' [Using TRAINING error]', '');
    title({[' Efficiency vs Complexity' trainErrStr ], [strrep(opt_str, '_', ', ')  ' (Size = ' sizeStyle ')'] }, 'fontsize', 14, 'interp', 'none')
%     title('Efficiency vs. complexity', 'fontsize', 16, 'interp', 'none')
    
%     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  664.9500  430.0000]);
%     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  670  430.0000]); % too wide, too short
%     set(gca, 'units', 'pixels', 'position', [ 80    84   473   516]); 
%     set(gcf, 'units', 'pixels', 'position', [548   242   610   660])
    set(gcf, 'position',  [650   332   623   546]);
    
    showExampleLetters = false;
    if showExampleLetters
        %%
        if ~exist('allIm', 'var') || isempty(allIm)
            noisyLetterOpts = struct('sizeStyle', sizeStyle, 'oris', 0, 'xs', 0, 'ys', 0, 'tf_pca', 0); 

            allIm = cell(1,nFonts);
            for fi = 1:nFonts
                %%
                folder = [datasetsPath 'NoisyLetters' filesep allFontNames{fi} filesep]; % 'sz32x32' filesep];
                fname = getNoisyLetterFileName(allFontNames{fi}, 4, noisyLetterOpts);

                SS = load([folder fname]);
                allIm{fi} = SS.signalMatrix(:,:,1);
            end
        end
        
        font_complexities_spaced = logspace(log10(font_complexities_model(1)), log10(font_complexities_model(end)), nFonts);

        y_pos = 1;
        
        
        for fi = 1:nFonts
%            h_ax_examp(fi) = axes('position', 
            
            
        end
        font_complexities_model
        
    end
    

    if plotLinesConnectingBoldToNonbold_model
%             legend([h_eff_human_fit, h_bold_lines], [human_fit_str, allPlainFonts], 'interpreter', 'none');

        
    end
    
    2;
    
    
    

    global discrep_idx leg_strs
    showDiscrepancyPlot = 0;
    if showDiscrepancyPlot
        %%
        first = 0;
        
        figure(44); 
        if first == true
            clf;
            discrep_idx = 1;
            leg_strs = {};
            
        else
            discrep_idx = discrep_idx + 1;
            hold on;
        end
        
        niceLegendFields = {'nStates'}; %'doPooling', 'poolSizes', 'poolStrides'}; %'filtSizes', 'doPooling'};
        legend_str_cur = getNetworkStr(allNetworks(1), niceLegendFields);
        
        
        
        mkr = marker(discrep_idx);
        clr = color_s(discrep_idx);
        leg_strs = [leg_strs, legend_str_cur];
        
        plot(-allLogSlope, allMeanDists, [mkr clr '-']);
                
        h = legend(leg_strs, 'interpreter', 'none');
        xlabel('Negative Slope');
        ylabel('RMS error from human');
        drawHorizontalLine(0);
        drawVerticalLine(1);
        3;
        
    end
    
    
    showPoolingPlot = false;
    if showPoolingPlot
        %%
        defaultNetwork_pool = struct('netType', 'ConvNet', 'filtSizes', 5, 'poolSizes', 4, 'poolType', 2, 'poolStrides', 'auto', 'nStates', [6 15], 'doPooling', 1);
        
        nStates1 = [3,6,12,24];
        nStates2 = [8,15,30,60,120];
        poolSizes = [0,2,4,6,8];
        filtSizes = [2,4,5,10,20];
        poolTypes = [1,2,4];
        
        allNetworks_pooling = defaultNetwork_pool;
        
%         curParam = 'nStates1';  curLabel = '# of convolutional filters'; sub_i = 1;
%        curParam = 'nStates2';   curLabel = '# of fully-connected units'; sub_i = 2; 
%         curParam = 'filtSize'; curLabel = 'Size of convolutional filters'; sub_i = 3;
        curParam = 'poolSize'; curLabel = 'Size of pooling window'; sub_i = 4;

%         curParam = 'poolType'; curLabel = 'Pooling P-norm';  sub_i = 1;

        switch curParam
            case 'nStates1',
                %%
                x = nStates1; 
                for i = 1:length(nStates1)
                    allNetworks_pooling(i) = defaultNetwork_pool;       allNetworks_pooling(i).nStates(1) = nStates1(i);
                end
                
            case 'nStates2', 
                x = nStates2;
                for i = 1:length(nStates2)
                    allNetworks_pooling(i) = defaultNetwork_pool;       allNetworks_pooling(i).nStates(2) = nStates2(i);
                end
                
            case 'poolSize',
                x = poolSizes;
                for i = 1:length(poolSizes)
                    allNetworks_pooling(i) = defaultNetwork_pool;       
                    if poolSizes(i) > 0
                        allNetworks_pooling(i).poolSizes = poolSizes(i);
                    else
                        allNetworks_pooling(i).doPooling = 0;
                    end
                end
                
            case 'filtSize',
                x = filtSizes;
                for i = 1:length(filtSizes)
                    allNetworks_pooling(i) = defaultNetwork_pool;       allNetworks_pooling(i).filtSizes = filtSizes(i);
                end
                
            case 'poolType',
                x = poolTypes;
                for i = 1:length(poolTypes)
                    pt = iff(poolTypes(i) == 4, 'MAX', poolTypes(i));
                    allNetworks_pooling(i) = defaultNetwork_pool;       allNetworks_pooling(i).poolType = pt;
                end
            
        end
        
        allNetworks_nopooling = allNetworks_pooling;
        [allNetworks_nopooling.doPooling] = deal(0);
        
        nNets = length(allNetworks_pooling);
        [slopes_pool,slopes_pool_L,slopes_pool_U] = deal(zeros(1, nNets));
        [slopes_nopool,slopes_nopool_L,slopes_nopool_U] = deal(zeros(1, nNets));
        
        for i = 1:nNets
            idx_p = find(arrayfun(@(s) isequal(s, allNetworks_pooling(i)), allNetworks), 1);
            if allNetworks_pooling(i).doPooling 
                allLogSlope_use = allLogSlope;
                allLogSlope_ci_use = allLogSlope_ci;
            else
                allLogSlope_use = allLogSlope_noB;
                allLogSlope_ci_use = allLogSlope_noB_ci;                
            end
            slopes_pool(i) = allLogSlope_use(idx_p);
            slopes_pool_L(i) = allLogSlope_use(idx_p) - allLogSlope_ci_use(2,idx_p);
            slopes_pool_U(i) = allLogSlope_ci_use(1,idx_p) - allLogSlope_use(idx_p);

            idx_no_p = find(arrayfun(@(s) isequal(s, allNetworks_nopooling(i)), allNetworks), 1);
            slopes_nopool(i) = allLogSlope_noB(idx_no_p);
            slopes_nopool_L(i) = allLogSlope_noB(idx_no_p) - allLogSlope_noB_ci(2,idx_no_p);
            slopes_nopool_U(i) = allLogSlope_noB_ci(1,idx_no_p) - allLogSlope_noB_ci(idx_no_p);

            if isequal(allNetworks_pooling(i), defaultNetwork_pool)
                idx_default = i;
            end
            
        end
        
%         showNoPooling = true;
        showNoPooling = ~strcmp(curParam, 'poolSize');
        h = [];
        figure(230); subplot(2,2,sub_i); cla; box on; hold on;
        if ~strcmp(curParam, 'poolSize')
            h(1) = plot(x, slopes_nopool, 'bo-'); 
        end
        
        
        h(2) = plot(x, slopes_pool, 'rs-'); 
        plot(x(idx_default), slopes_pool(idx_default), 'rs', 'markersize', 10, 'markerfacecolor', 'r'); 
%         errorbar(x, slopes_nopool, slopes_nopool_L, slopes_nopool_U, 'bo-');
%         errorbar(x, slopes_pool,   slopes_pool_L, slopes_pool_U,   'rs-');
        
        xlabel(curLabel, 'fontSize', 14);
        ylabel('log-log slope', 'fontSize', 14);
        if any(strcmp(curParam, {'nStates1', 'nStates2', 'filtSize'})) || 1
            set(gca, 'xscale', 'log');
            xlim(lims(x, .05, [], 1))

        else
            xlim(lims(x, .1))
        end
        
        
        h(3) = drawHorizontalLine(-.91, 'linestyle', '--', 'color', 'k');
        
        set(nonzeros( h) , 'markersize', 8);
%         if showNoPooling
        if sub_i == 1
            legend(h, {'No pooling', 'With pooling', 'Human best fit line'}, 'location', 'best', 'fontsize', 12);
        end
%         else
%             legend({'With Pooling'}, 'location', 'best', 'fontsize', 12);
%         end

        if any(strcmp(curParam, {'poolType', 'poolSize'})) || true
            set(gca, 'xtick', x);
        else
            %%
            set(gca, 'xtickMode', 'auto');
        end
        
        if strcmp(curParam, 'poolType')

            xticklabels = arrayfun(@(i) iff(i == 4, 'MAX', num2str(i)), x, 'un', 0);
            set(gca, 'xticklabel', xticklabels)
        elseif strcmp(curParam, 'poolSize')
            xticklabels = arrayfun(@(i) iff(i == 0, '[No Pooling]', num2str(i)), x, 'un', 0);
            set(gca, 'xticklabel', xticklabels)            
            
        end
        
        if strcmp(curParam, 'poolSize')
            ylim([-1.3, .1]);
        else
            ylim([-1.3, .1]);
        end
        3;
        
%         set(
        
        
        
        
        
    end
        3;
    %%


end


function [log_slope, log_slope_ci,p] = getLogSlope(x, y)

    if length(x) <= 1
        [log_slope, log_slope_ci,p] = deal(nan);
        return
    end
%     logy = log10(y);
%%
    logX = log10(x(:)); logY = log10(y(:));
    logX1 = [ones(length(x),1), logX];

    [b,binf] = regress( logY, logX1);

    log_slope = b(2);
    log_slope_ci = binf(2,:);
    
    
    [p,S] = polyfit(logX, logY, 1);
%     assert(log_slope == p(1));  
    

end

