function makePlots
%%
%     expName = 'ChannelTuning';
%     expName = 'Crowding';
    expName = 'Grouping';
%     expName = 'Complexity';
%     expName = 'TrainingWithNoise';
%     expName = 'Uncertainty';

%     modelNames = {'ConvNet', 'Texture'};   modelColors = {'b', 'g'}; modelMarkers = {'o', 'o'};
    
%     modelNames = {'ConvNet'}; modelColors = {'b'}; modelMarkers = {'o'};
            modelNames = {'ConvNet', 'Texture', 'IdealObserver'};   modelColors = {'b', 'g', 'r'}; modelMarkers = {'o', 'o', 's'};
    
    
    yticks = [];
    xticks = [];
    doHuman = true;
    opt = struct;
    log_xyratio = [];
    switch expName
        
        case 'ChannelTuning',
             fig_id = 3;
            xlab = 'Noise Center Frequency'; ylab = 'Threshold';
            xlims = [0.5 /sqrt(2) ,16*sqrt(2)];
            ylims = [10 1000];
            xscale = 'log';
            yscale = 'log';

            yticks = [];
            xticks = [];
            
            log_xyratio = 1.3;
            
            modelNames = {'ConvNet', 'Texture', 'IdealObserver'};   modelColors = {'b', 'g', 'r'}; modelMarkers = {'o', 'o', 's'};

%             x_label = 'Noise 
        case 'Crowding';
            fig_id = 4;
            xlab = 'Spacing re critical spacing'; ylab = 'Threshold re that for 1 letter';
            xlims = [0, 2];
            ylims = [.1 100];
            xscale = 'linear';
            yscale = 'log';

            modelNames = {'ConvNet', 'Texture', 'IdealObserver'};   modelColors = {'b', 'g', 'r'}; modelMarkers = {'o', 'o', 's'};

           
        case 'Grouping';
            fig_id = 2;
            xlab = 'Wiggle'; ylab = 'Efficiency';
            xlims = [0, 90];
            ylims = [0. 0.052   ];
            xscale = 'linear';
            yscale = 'linear';
            
            xticks = [0 : 15 : 90];
            yticks = [0: .01 : 0.05];
            
            log_xyratio = 1;
            opt.IdealObserverValue = 0.05;
            
        case 'Complexity';
            fig_id = 1;
            xlab = 'Complexity'; ylab = 'Efficiency';
            xlims = [10, 1000];
            ylims = [0.01 1];
            xscale = 'log';
            yscale = 'log';

            yticks = [];
            xticks = [];
  
            log_xyratio = 1;
        %     plot(font_complexities_human, human_efficiencies, 'k^', 'linewidth', 2, 'markersize', 8)
                

        case 'Uncertainty';
            fig_id = 4;
            xlab = 'Number of Positions'; 
%             ylab = 'Efficiency';
            ylab = 'pctCorrect';
            
            modelNames = {'ConvNet: 1 layer', 'ConvNet: 2 layers', 'ConvNet: 3 layers', 'Texture'};   modelColors = {'b', 'b', 'b', 'g'};
            modelMarkers = {'o', 's', '^', 'o'};
            opt.y_name = ylab;
            
            switch ylab
                case 'Efficiency'
                    ylims = [0.01 1];
                    yscale = 'log';
                case 'pctCorrect'
                    ylims = [85 101];
                    yscale = 'linear';
                    
            end
            xlims = lims([1, 45], .05, [], 1);
            xscale = 'log';
            
            yticks = [];
            xticks = [1, 3, 7, 15, 20, 30, 45];
            
  
            log_xyratio = 1;
            
            doHuman = true; 
            
    end

    nModels = length(modelNames);
    
    [x_model, y_model] = deal(cell(1, nModels));
    for i = 1:nModels
        [x_model{i}, y_model{i}] = getData(expName, modelNames{i}, opt);
    end

    if doHuman
        [x_human, y_human] = getData(expName, 'Human', opt);            
        [x_human_fit, y_human_fit] = getData(expName, 'HumanFit', opt);            

        y_err_human = 0.2 * y_human;
    end

    
    figure(fig_id); clf;
    hold on; box on;

    
    
    if doHuman
        h_human_line_fit = plot(x_human_fit, y_human_fit, 'k-', 'linewidth', 6);

        mkSize = 8;
        h_human_pts = plot(x_human, y_human,                  'ks', 'color', .5*[1,1,1], 'markersize', mkSize, 'linewidth', 3);
        h_human_pts_err = errorbar(x_human, y_human, y_err_human, 'ks', 'color', .5*[1,1,1], 'markersize', mkSize, 'linewidth', 3);
    end
    
    for i = 1:nModels
        h_model_pts(i) = plot(x_model{i}, y_model{i}, [modelColors{i} modelMarkers{i} '-'],  'markersize', 10, 'linewidth', 3); 
    end
    xlabel(xlab);
    ylabel(ylab);
    set(gca, 'xlim', xlims, 'ylim', ylims);
    set(gca, 'xscale', xscale, 'yscale', yscale);
    setLogAxesDecimal;
    
    if ~isempty(xticks)
        set(gca, 'xtick', xticks, 'xticklabel', xticks)
    end
    if ~isempty(yticks)
        set(gca, 'ytick', yticks);
        
        if strcmp(expName, 'Grouping')
            %%
            ytickslabels = arrayfun(@num2str, yticks, 'un', 0);
            ytickslabels{end} = '1';
           set(gca, 'ytickLabel', ytickslabels);
            
        end
        
        
    end
%     set(gca,r
    
    modelNames_leg = cellfun(@getModelName_long, modelNames, 'un', 0);
    if ~isempty(log_xyratio)
        decades_equal([], log_xyratio);
    end
    
    h_legends = h_model_pts;
    if doHuman
        h_legends = [h_legends, h_human_pts, h_human_line_fit];
        modelNames_leg = [modelNames_leg, {'Human observer', 'Human observer (fit)'}];
    end
    legend(h_legends, modelNames_leg);

    

3;












end

function s= getModelName_long(modelName)
    switch modelName
        case 'ConvNet', s = 'ConvNet';
        case 'Texture', s = 'Texture + MLP';
        case 'IdealObserver', s = 'Template Matcher';
        otherwise s = modelName;
    end


end

function [x,y] = getData(expName, modelName, opt)

    switch expName
        
        case 'ChannelTuning',
            x_allBands = [0.5, 0.59, 0.71, 0.84, 1, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.44, 16];
            
            switch modelName
                case 'ConvNet',                    
                    x = x_allBands;
                    % Bookman: k36, [64, 64] 11 oris[1], 4x[1], 4y[1]
                    %   line 1 : ConvNet; nFilt=16,64,512.nFC=120  ; FilterSize=5x5, 5x5, 3x3; PoolSize=2x2, 2x2, 2x2; Pnorm=MAX. 
                    y = [3.9313972, 6.2141994, 5.3730343, 15.0766175, 26.7607659, 43.0091351, 78.7617608, 160.2941297, 274.3708230, 269.1936750, 209.5145820, 158.9356344, 93.1074949, 52.9956637, 25.8199187, 13.7222657, 7.4724385, 5.8945609, 3.1761948, 6.6739161, 2.8522763];
       
                case 'Texture',
                    x = x_allBands;
%                     y = [0.1179743, 0.0316228, 0.0316228, 0.0316228, 0.0870019, 2.3594352, 1.2850301, 1.2578177, 1.1082555, 8.0015512, 532.3055131, 212.3211556, 15.1471410, 0.0316228, 0.0316228, 0.0658719, 0.0722048, 0.0316228, 0.0316228, 0.0316228, 0.0316228]*.6;      
                    y = [0.0829822, 0.0316228, 0.0316228, 0.0316228, 0.0316228, 2.0474187, 0.6277587, 0.6421075, 0.8189695, 6.5864020, 181.5342929, 61.0063658, 8.8668198, 0.0316228, 0.0316228, 0.0653444, 0.0811476, 0.0316228, 0.0316228, 0.0316228, 0.0316228]*2;

                    
                case 'Human',
                       x = x_allBands;

%     y_log10Threshold = [0.7740    0.8309    0.8693    0.8998    1.0395    1.1654    1.3178    1.3617    1.5622    1.6144    1.8388    2.0220    2.2508 ...
%                         2.5046    2.6564    2.6315    2.4420    2.2201    1.9270    1.6117    1.4342];
    
                    log10_y = [0.5104    0.5609    0.5899    0.7764    0.9043    1.1112    1.4049    1.5753    1.8275    2.0660    2.3871 ...
                                2.5311    2.4442    2.1303    1.6726    1.2616    0.9938    0.8076    0.8995    0.8924    0.6338];
                    y = 10.^log10_y;
                   

                case 'HumanFit',
                     x_noiseFreq_pts = [0.5 0.59  0.71  0.84  1 1.19  1.41  1.68  2 2.38  2.83  3.36  4  4.76  5.66  6.73  8 9.51 11.31 13.45 16];

%     y_log10Threshold = [0.7740    0.8309    0.8693    0.8998    1.0395    1.1654    1.3178    1.3617    1.5622    1.6144    1.8388    2.0220    2.2508 ...
%                         2.5046    2.6564    2.6315    2.4420    2.2201    1.9270    1.6117    1.4342];
    
                    log10_y = [0.5104    0.5609    0.5899    0.7764    0.9043    1.1112    1.4049    1.5753    1.8275    2.0660    2.3871 ...
                                2.5311    2.4442    2.1303    1.6726    1.2616    0.9938    0.8076    0.8995    0.8924    0.6338];
                    y_threshold_pts = 10.^log10_y;


                    itp_factor = 10;
                        %%
                        %     x_noiseFreq = interp1(x_noiseFreq, y_threshold,
                        log_x_itp = linspace(log10(x_noiseFreq_pts(1)), log10(x_noiseFreq_pts(end)), length(x_noiseFreq_pts)*itp_factor);
                        log_y_th_itp = interp1(log10(x_noiseFreq_pts), log10(y_threshold_pts), log_x_itp, 'pchip');
                        
                        %         [log_x_itp, log_y_th_itp] = fourierInterp(log10(x_noiseFreq_pts), log10(y_threshold_pts), itp_factor);
                        %     [log_x_itp, log_y_th_itp] = fourierInterp(log10(x_noiseFreq), log10(y_threshold), itp_factor, lims(log10(x_noiseFreq)));
                        
                        log_y_th_itp_sm = gaussSmooth(log_y_th_itp, 3);
                        
                        x_itp = 10.^log_x_itp;
                        %         y_th_itp = 10.^log_y_th_itp;
                        y_th_itp = 10.^log_y_th_itp_sm;
                        show = 0;
                        if show
                            %%
                            figure(1); clf; hold on;
                            plot(x_noiseFreq_pts, y_threshold_pts, 'ro')
                            plot(x_itp, y_th_itp, 'k.-');
                            set(gca, 'xscale', 'log', 'yscale', 'log')
                            
                        end
        
                    x = x_itp;
                    y = y_th_itp;
                    
                    
                case 'IdealObserver',
                       x = x_allBands;
%                     y = [154.9886956,   159.2416922,   197.1861520,   212.6511694,   242.6761243,   228.4640728,   217.1338422,   171.1265558,   135.4047975,    92.5047879,    62.2110196,    38.6057810,    20.8809252,    12.7278104,     8.1219828,     5.0298394,     2.9866994,     1.7286199,     0.8088051,     0.3895855,     0.1555146];
                    % 
%                     line 1 : ConvNet; nFilt=16,64,512.nFC=120  ; FilterSize=5x5, 5x5, 3x3; PoolSize=2x2, 2x2, 2x2; Pnorm=MAX. 
                    y = [296.0023717,   293.8031626,   354.0164262,   376.9704421,   430.7506126,   394.7553862,   382.6032066,   298.1423297,   246.3822602,   161.8558730,   111.0614521,    65.2219913,    34.6996096,    18.3140310,     9.7175721,     5.0744794,     2.6591056,     1.4122554,     0.6579247,     0.3044470,     0.1247812];

            end
            
%             x_label = 'Noise 
        case 'Crowding';
                    th_1letter = .048;
                    crit_spacing = 2.7;
              x_factor = 1/crit_spacing;
            y_factor = 1/th_1letter;
                    
            switch modelName
                case 'ConvNet', x= linspace(0.3, 1.6, 11); y = [11, 11.2, 10.9, 11, 11,  1   1 1 1 1 1];
                case 'Texture', x= linspace(0.3, 1.6, 11); y = [8   8     8     8   8,   1.2 1 1 1 1 1];
                case 'Human',
                    
                  
                    x_spacing_pts = [1    1    1    1.2    1.5    2    2    2    2.25    2.5    2.5    2.5    3     3    3    3    3.5    3.5    3.5    4    4    4    4.5    5    7.5   25  25   25];
                    y_spacing_pts = 10.^[0.01    0.06    0.03    0.04    0.03   -0.03   -0.94    0.02   -1.24   -1.25   -0.94   -1.14   -1.28   -1.17   -1.19   -1.36   -1.27   -1.47   -1.26   -1.3   -1.26   -0.97   -1.3   -1.28   -1.33   -1.39  -1.29   -1.35 ];
                    
                    normalizePoints = true;
                    if normalizePoints
                        x_spacing_pts = x_spacing_pts / crit_spacing;
                        y_spacing_pts = y_spacing_pts / th_1letter;   
                    end
                    x = x_spacing_pts;
                    y = y_spacing_pts;

                    
                case 'HumanFit',
                    cf_top_x = [0, 2.1] * x_factor;
                    cf_top_y = [1, 1]*1 * y_factor;
                    cf_bot_x = [crit_spacing, 25] * x_factor;
                    cf_bot_y = [1, 1]*th_1letter * y_factor;

                    x = [cf_top_x, cf_bot_x];
                    y = [cf_top_y, cf_bot_y];
                case 'IdealObserver', x= linspace(0.3, 1.6, 11); y = ones(1, 11);
            end
            
        case 'Grouping';
            
            switch modelName
                case 'ConvNet',
                    x = [0:5:90];
                    y = [0.0397106, 0.0346932, 0.0350908, 0.0344410, 0.0308619, 0.0264131, 0.0212453, 0.0181708, 0.0146538, 0.0145528, 0.0120550, 0.0119481, 0.0115966, 0.0115888, 0.0115631, 0.0113335, 0.0106043, 0.0109837, 0.0105500];

                case 'Texture',
                    x = [0:5:90];
%                     y = [0.0269239, 0.0277810, 0.0270239, 0.0247751, 0.0227786, 0.0196221, 0.0202919, 0.0185245, 0.0174195, 0.0168405, 0.0166217, 0.0157142, 0.0149550, 0.0168706, 0.0157278, 0.0170287, 0.0176601, 0.0171792, 0.0169288];
%                     y = [0.0286246, 0.0293450, 0.0259602, 0.0234760, 0.0231900, 0.0186093, 0.0180543, 0.0174104, 0.0168725, 0.0145868, 0.0156587, 0.0169352, 0.0158384, 0.0184689, 0.0180578, 0.0173409, 0.0179907, 0.0162720, 0.0169833];
                    y = [0.0269239, 0.0277810, 0.0270239, 0.0247751, 0.0227786, 0.0196221, 0.0202919, 0.0185245, 0.0174195, 0.0168405, 0.0166217, 0.0157142, 0.0149550, 0.0168706, 0.0157278, 0.0170287, 0.0176601, 0.0171792, 0.0169288];      

                case 'Human',
                    y_avi_ori = [0.0324 0.0318 0.0296 0.0274 0.0242 0.0238 0.0187 0.0167 0.0130 0.0128 0.0128 0.0107 0.0127 0.0113 0.0109 0.0099 0.0092 0.0092 0.0090 ];
                    y_avi_off = [0.0351 0.0323 0.0281 0.0239 0.0185 0.0211 0.0137 0.0124 0.0138 0.0100];
                    y_avi_phase = [0.0130];
                    
                    x_avi_ori = [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 ];
                    x_avi_offset = [5 10 15 20 25 30 35 40 45 50];
                    x_avi_phase = [40.8];
                    
                    x = x_avi_ori;
                    y = y_avi_ori;
    
                case 'HumanFit',
                    %%
                     x = 0:1:90;
                     clippedLine_func = @(c, x) clippedLine(c, x);  
                     beta_clipped = [5, 45.912441,   0.032921,   0.010572];

                     y = clippedLine_func(beta_clipped, x);
                case 'IdealObserver',
                     x = [0:5:90];
                     y = opt.IdealObserverValue * ones(1,length(x));
                    
                    
            end
         
    
        case 'Complexity';
            x_complexity6Fonts_model = [19.5371795,    43.6293627,    49.8394251,    66.1862040,    86.0165225,   270.1357811];
            switch modelName
                case 'ConvNet',
                     x = x_complexity6Fonts_model;
                     y = [ 0.2095296,     0.1955160,     0.1297625,     0.1276246,     0.1058844,     0.0699974];
                    
                case 'Texture',
                    
                    x = x_complexity6Fonts_model;  
                    y = [0.1629675,     0.1225434,     0.1164400,     0.0779718,     0.0684416,     0.0514848];

                case 'Human',
                    y = [0.19185538, 0.16349223, 0.11256300, 0.12913145, 0.04144148];
                    x = [19.53717949, 38.54455739, 70.46841748, 54.34218943, 440.36322492];
                    
                case 'HumanFit',
                    eff_cmp_slope_avi = -0.51;
                    eff_cmp_coeff_avi = 0.97;
                    
                    x = logspace(1, 3, 10); %[10, 1000];
                    y = eff_cmp_coeff_avi .* (x .^ (eff_cmp_slope_avi));
                    
                case 'IdealObserver',
                     x = x_complexity6Fonts_model;
                     y = ones(1, 6);
            end
            
    
            
        case 'Uncertainty'
            
            x = [1, 3, 7, 15, 20, 30, 45];
            switch modelName
                
                case 'ConvNet: 1 layer',
                     if strcmp(opt.y_name, 'pctCorrect') 
                           y = [100.0000000,   100.0000000,   100.0000000,    99.9000015,    99.8499985,    99.1999969,    90.9000015]; % 1 layer
                     elseif strcmp(opt.y_name, 'Efficiency') 
                            y = [0.4557718,     0.1960564,     0.1206492,     0.0673899,     0.0640190,     0.0439210,     0.0327603]; % 1 layer
                     end
                case 'ConvNet: 2 layers',
                     if strcmp(opt.y_name, 'pctCorrect') 
                           y = [100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000]; % 2 layers
                     elseif strcmp(opt.y_name, 'Efficiency') 
                           y = [0.3973418,     0.2925842,     0.2361833,     0.1895894,     0.1646396,     0.1406080,     0.1186297]; % 2 layers
                     end
                    
                    
                case 'ConvNet: 3 layers',
                    if strcmp(opt.y_name, 'pctCorrect') 
                            y = [100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000]; % 3 layers
                     elseif strcmp(opt.y_name, 'Efficiency') 
                            y = [0.4521954,     0.4098388,     0.3568460,     0.2893636,     0.2872577,     0.2701378,     0.2628508]; % 3 layers
                    end
                     
                    
                 case 'Human',
                    if strcmp(opt.y_name, 'pctCorrect') 
%                             y = [100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000]; % 3 layers
                            y = 1 * ones(1, 7); % 3 layers
                     elseif strcmp(opt.y_name, 'Efficiency') 
                            y = .3 * ones(1, 7); % 3 layers
                    end
                 case 'HumanFit',
                    if strcmp(opt.y_name, 'pctCorrect') 
%                             y = [100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000]; % 3 layers
                            y = 100 * ones(1, 7); % 3 layers
                     elseif strcmp(opt.y_name, 'Efficiency') 
                            y = .3 * ones(1, 7); % 3 layers
                    end
                     
                 case 'Texture',
                    if strcmp(opt.y_name, 'pctCorrect') 
%                             y = [100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000,   100.0000000]; % 3 layers
                            y = 100 * ones(1, 7); % 3 layers
                     elseif strcmp(opt.y_name, 'Efficiency') 
                            y = .2 * ones(1, 7); % 3 layers
                    end
                    
            end
              
                    
    end
   
    
    

end