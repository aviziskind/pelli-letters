function plotEfficiencyVsComplexity

    nTrials = 1;
    expTitle = 'Complexity';
%     expTitle = 'NoisyLettersTextureStats';
    
    netType = 'ConvNet';
%     netType = 'MLP';
    
    
%     sizeStyle = 'large';
%     sizeStyle = 'med';
    sizeStyle = 'k18';
    doSizeTuningTest = 0;
    
    plotIndividualLetterResults = false;
    showLayer1Filters = false && strcmp(netType, 'ConvNet');
    
    
    opt.skipIfDontHaveModelFile = true;
    opt.useTrainingError = false;
    opt.skipIfDontHaveIdealFile = false;
    opt.returnFontsInStruct = false;

    %% X/Y Variables
%     x_name = 'Complexity';   y_name = 'Efficiency';
    x_name = 'Uncertainty';   
    y_name = 'maxPctCorrect';
%     y_name = 'Efficiency';
    
%     x_name = 'Complexity';   y_name = 'Threshold';
    
%     x_name = 'FontSize';     y_name = 'Efficiency';
    
%     x_name = 'SNR'; y_name = 'pctCorrect';
%     x_name = 'NoiseBand';   y_name = 'Threshold_model';

    %% Multiple Lines on each plot
%     multiple_lines = '';
    multiple_lines = 'Networks';
%     multiple_lines = 'Opts';
%     multiple_lines = 'TrainingNoise';

%     multiple_networks = '';
    multiple_networks = 'nStates';
%     multiple_networks = 'poolSizes';
    
    yvsx_name = sprintf('%s_vs_%s', y_name, x_name);
    %% Multiple Plots

    multiple_plots = '';
%     multiple_plots = 'Opts';

    
    
%%   Select Fonts
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'GeorgiaUpper', 'Yung', 'Kuenstler'};

% 	allFontNames      = {'Braille', 'Checkers4x4', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};
% 	allFontNames      = {'KuenstlerU', 'KuenstlerUB'};%, 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};

    allFontNames_ext = {'Sloan', 'SloanB', ...
                    'Helvetica', 'HelveticaB', 'HelveticaU', 'HelveticaUB',  ...
                    'Courier', 'CourierB', 'CourierU', 'CourierUB', ...
                    'Bookman', 'BookmanB', 'BookmanU', 'BookmanUB', ...
                    'Yung', 'YungB',     'KuenstlerU', 'KuenstlerUB'};


    allFontNames_std      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};    

% 	allFontNames      = {'Bookman'};
% 	allFontNames      = {'KuenstlerU'};
% 	allFontNames      = {'Braille'};
    if any(strcmp(x_name, {'NoiseBand', 'Uncertainty'}))
    	allFontNames      = {'Bookman'};
        
    elseif strcmp(x_name, 'Complexity')

    	allFontNames = allFontNames_std;
    end
%     allFontNames = allFontNames_ext;


    if plotIndividualLetterResults
        allFontNames(strcmp(allFontNames, 'Braille')) = []; %#ok<*UNRCH>
        allFontNames(strcmp(allFontNames, 'Yung')) = [];        
    end

    nFonts = length(allFontNames);
    
    %% SNRs for testing
    % 	allFontNames      = {'Braille'};
   
   

%     allFiltSizes = {10, 15, 20, 25, 30};
     
    switch expTitle 
        case 'Complexity'
%             allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4];
            allSNRs_test = [0, 1, 2, 2.5, 3, 4];
        case 'NoisyLettersTextureStats',
            allSNRs_test = [0, 1, 2, 2.5, 3, 4, 5];

    end
    
    if strcmp(x_name, 'NoiseBand')
        allSNRs_test = [-1, 0, 0.5,  1, 1.5,  2,  2.5,  3, 4];
    end
    
    nSNRs_test = length(allSNRs_test);
    
    
%     sizeStyle_full = switchh(sizeStyle, {'sml', 'med', 'big', 'dflt'}, {'Small', 'Medium', 'Large', 'Default'});
    
    switch netType
        case 'ConvNet',
%             snr_train = [1,2,3,4];
            snr_train = [1,2,3];
%             snr_train = [4];

            %% Number of states
%             allNStates = { {6,15} };
       
             
    %%{
            allNStates_6_16_X   = {   {6,16, -30}, {6,16,-60}, {6,16,-120}, {6,16,-240}, {6,16,-480}, {6,16,-960} } ;
            allNStates_6_X_120  = {  {6, 4, -120},  {6, 8, -120},  {6, 16, -120},  {6, 32, -120}, {6, 64, -120},  {6, 128, -120}, {6, 256, -120} };
            allNStates_X_16_120 = { {3, 16, -120}, {6, 16, -120},  {12, 16, -120}, {24, 16, -120}, {48, 16, -120}, {96, 16, -120}, {192, 16, -120}  };

            allNStates_6_X = { {6, -15}, {6, -30}, {6, -60}, {6, -120}, {6, -240} };    
            allNStates_12_X = { {12, -15}, {12, -30}, {12, -60}, {12, -120}, {12, -240} };

            allNStates_6_X = {  {6, -8}, {6, -15}, {6, -30}, {6, -60}, {6, -120} };
            allNStates_X_15 = {  {3, -15}, {6, -15}, {12, -15}, {24, -15}, };


        %     allNStates_use = { [3, 8, 60], [6, 16, 120], [9,24, 180], [12, 32, 240], [30, 80, 600], [60, 160, 1200] };
        %     allNStates_use = { [6, 50], [6, 100], [12, 50], [12, 100] };
        %     allNStates_use = { [3,8,60], [6, 16, 120]  };
        %     allNStates = { [6, 100]  };

        %     allNStates = { [3, 8, 15], [3, 8, 60], [3, 6, 10]  };

        %     allNStates = { [3, 8, 60], [6, 16, 120], [6, 16, 30], [12,32,240]};

        %     allNStates_all = {  {3, 8, 60}, {6, 16, 120}, {6, 16, 30}, {6,16, 15}, {6,16,8}, {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };

        % { {6,15}, {12,15}, {24,15}, {6,30}, {6,60}, {6,120}, }
            allNStates_cmp = {  {6, -15}, {6, -30}, {6, -60}, {6, -120}, {24, -15}, {12, -30}, {12, -60}, {24, -120}, {48, -120} };    
            allNStates_cmp = {  {6, -15}, {6, -30}, {6, -60}, {6, -120} };
            
            
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
        


%             allNStates = [allNStates_12_X];

%             allNStates = allNStates_6_X;
%             allNStates = allNStates_X_15;
%             allNStates_X_X = [allNStates_6_X, allNStates_X_15];        
%             allNStates = allNStates_X_X; %{ {6,15} };

%}

            %%
%             multiple_networks = '';
%             multiple_networks = 'nStates1';
%             multiple_networks = 'nStates2';
%             multiple_networks = 'filtSizes';
%             multiple_networks = 'poolSizes';
%             multiple_networks = 'poolTypes';
            
            allNStates = { {6, -15} };
%             allNStates = { {6, 16, 120} };


            %% Size of Convolutional Filters
%             filtSizes = [0];
    
            filtSizes = [5,4];
%             allFiltSizes = {2,4,5,10,20};
            allFiltSizes = {[5,4]};
            
            %% Pooling: 
            doPooling = 1;
            all_doPooling = {0, 1};

            % Pool Size
            poolSize = [4 2];            
            allPoolSizes = {[4, 2], [4, 4], [8, 4]};
%             allPoolSizes = {[4]};

            % Pool Stride
            poolStrides = 'auto';

            % Pool Type
            poolType = 2;
%             allPoolTypes = {1,2,'MAX'};
            allPoolTypes = {2};
            
            switch multiple_networks 
                case '',
...                case 'nStates',  allNStates =  { {6,-15}, {6, -120}, {6}, {6, 16},  {6, 16, -30}, {6, 16, -120}, {6, 16, -240}  };
                case 'nStates',  allNStates =  {  {6, 16},  {6, 16, -120}, {6, 16, -240}  };
                case 'nStates1',  allNStates =  allNStates_X_15;
                case 'nStates2',  allNStates =  allNStates_6_X;
                case 'filtSizes', allFiltSizes = {3, 5,10};%  {2,5,10,20};
                case 'poolSizes', allPoolSizes = [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
                case 'poolTypes', allPoolTypes = {1,2,'MAX'};

            end
            
            allPoolSizes_C = num2cell(allPoolSizes);
            
            
            if iscell(allNStates(1))
                allNStates = cellcell2cellarray(allNStates);
            end
            
            allConvNetOptions = struct('netType', 'ConvNet', ...
                                        'tbl_nStates', {allNStates}, ...
                                        ...
                                        'filtSizes', filtSizes,...
                                        ...'tbl_filtSizes', {allFiltSizes}, ...
                                        ...
                                        'doPooling', doPooling, ...
                                        ...'tbl_doPooling', {all_doPooling}, ...
                                        ...
                                        ...'poolSizes', poolSize, ...
                                        'tbl_poolSizes', {allPoolSizes_C}, ...
                                        ...
                                        ...'poolType', poolType, ...
                                        'tbl_poolType', {allPoolTypes}, ...
                                        ...
                                        'poolStrides', poolStrides ... 
                                      );
            allNetworks = expandOptionsToList(allConvNetOptions);

            3;
        case 'MLP',
%             snr_train = [2 3 4 5];
            multiple_networks = 'HiddenUnits';
            snr_train = [4];
%             snr_train = [1,2,3,4];

%            allNHiddenUnits = { {6}, {12}, {24}, {48}, {96},   {6, 16}, {6, 32}, {6, 64},   {12, 16}, {12, 32}, {12, 64} };
%            allNHiddenUnits = { {}, {30}  };
           allNHiddenUnits = { {}  };
%            allNHiddenUnits = { {}, {4}, {8}, {15}, {30}, {60}, {120} };
%            allNHiddenUnits = { {5}, {10}, {15}, {30}, {60}, {120}, {} };
           allMLPoptions = struct('netType', 'MLP', ...
                                  'tbl_nHiddenUnits', {allNHiddenUnits} ...
                                  );
            allNetworks = expandOptionsToList(allMLPoptions);
    end
    nNetworks = length(allNetworks);

    
    %% Uncertainty: (multiple xs/ys/oris)
  
    ori_x_y = {[0], [0],  [0]};
%         ori_x_y = {[0], [0,3], [0]};   % 2x1
%         ori_x_y = {[0], [0,3,6], [0]}; % 3x1
%         ori_x_y = {[0], [0:6], [0]};    % 7x1
%         ori_x_y = {[0], [0:6], [0:6]};  % 7x7
%         ori_x_y = {[0], [0:9], [0:9]};  % 10x10
%          ori_x_y = {[-4:2:4], [0], [0]};   % 5 x 1x1
%         ori_x_y = {[-4:2:4], [0:4], [0:4]};   % 5 x 5 x 5
%          ori_x_y = {[-4:2:4], [0:9], [0:9]};   % 5 x 10 x 10
                    
    

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
            
%              imageSize = [45,45];
             imageSize = [65,65];
            expTitle = 'NoisyLetters';

            
        case 'NoisyLettersTextureStats'
            
            snr_train = [2 3 4 5];

            Na_sub_txt = 'all';
%             Nscl_txt = 3;  Nori_txt = 2;  Na_txt = 3; 
%             Nscl_txt = 3;  Nori_txt = 2;  Na_txt = 3; 
            if strcmp(x_name, 'NoiseBand')
                Nscl_txt = 1;  Nori_txt = 4;  Na_txt = 5; 
            elseif strcmp(x_name, 'Complexity')
                Nscl_txt = 3;  Nori_txt = 4;  Na_txt = 5; 
            end
%             Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 9; 
%             Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 9; 
%             Nscl_txt = 2;  Nori_txt = 3;  Na_txt = 9;  Na_sub_txt = 'all';

            statsUse = 'V2';
            imageSize = 32;   sizeStyle = 'med';
%             imageSize = 64;   sizeStyle = 'large';
            textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt, 'Na_sub_txt', Na_sub_txt, 'statsUse', statsUse};

            all_sizeStyles_C = {sizeStyle};

    %         all_imageSizes_C = {[20,20],[50,50], [80,80]};
            all_imageSizes_C = {[imageSize,imageSize]};
            autoImageSize = 0;
            
            expTitle = 'NoisyLettersTextureStats';
   
    end

    
%     allBlurStd_C = {0, 1, 2, 3};
    allBlurStd_C = {0};
%     allBlurStd_C = {2};

%     all_sizeStyles_opt_C = all_sizeStyles_C;
    all_sizeStyles_opt_C = {sizeStyle};
    
%     allNoiseFreqBands = nan;
    allNoiseFreqBands = [0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13];
%     allNoiseFreqBands = [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];
    allNoiseFreqBands_C = num2cell(allNoiseFreqBands);    
    
    if any(strcmp(x_name, {'NoiseBand', 'Uncertainty'}))
        autoImageSize = 0;
    elseif strcmp(x_name, 'Complexity')
%         autoImageSize = 1;
        autoImageSize = 0;
    end
    all_imageSizes_C = {imageSize};
%     all_imageSizes_C = {[40,80]};

%     niceStrFields = {'trainNoise', 'testNoise'};
    niceStrFields = {'nStates', 'poolSizes', 'uncertainty'};
    
%     trainingNoise = 'white';
    allfexps = [1.5];
    bandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f), allNoiseFreqBands, 'un', 0);
    pinkNoiseFilters = arrayfun(@(f) struct('filterType', '1/f', 'f_exp', f), allfexps, 'un', 0);
    pinkPlusWhiteNoiseFilters = arrayfun(@(f) struct('filterType', '1/fPwhite', 'f_exp', f), allfexps, 'un', 0);
    pinkOrWhiteNoiseFilters = arrayfun(@(f) struct('filterType',   '1/fOwhite', 'f_exp', f), allfexps, 'un', 0);
    whiteNoiseFilter = struct('filterType', 'white');
    
%     all_snr_train = {[4], [1 2 3 4]};
    all_snr_train = {[1 2 3 4]};
    
%     allTrainingNoise = [pinkNoiseFilters, bandNoiseFilters([1,5,8])]; %allNoiseFreqBands_C([1,3,5,8]);
%     allTrainingNoise = [bandNoiseFilters([1,5,8])]; %allNoiseFreqBands_C([1,3,5,8]);
%     allTrainingNoise = [pinkNoiseFilters, bandNoiseFilters([1])]; %allNoiseFreqBands_C([1,3,5,8]);
    allTrainingNoise = [{whiteNoiseFilter}, pinkNoiseFilters, pinkOrWhiteNoiseFilters];
%     allTrainingNoise = [{whiteNoiseFilter}, pinkNoiseFilters];
%     allTrainingNoise = [pinkOrWhiteNoiseFilters];
%     allTrainingNoise = {whiteNoiseFilter, 'same'};
%     allTrainingNoise = {'same'};
    
    
    allStatsUse = {'V2'};
    
    multiple_opts = 'statsUse';
    switch multiple_opts
%         case 'statsUse', allStatsUse = {'V1', 'V1x', 'V2'};
        case 'statsUse', 
        
    end
%     allRetrainFromLayers = {5, 7};
    allRetrainFromLayers = {0};
    
    allOriXYSets_mult = { ...
                    {[0], [0], [0]  };
                    {[0], [0,2,4], [0]};   % 3x1 [2] -->span=4
                    {[0], [0,1,2,3,4], [0]};   % 5x1 [1] -->span=4
                    {[0], [0,4], [0]};   % 2x1  [4] -->span=4
                   ... {[0], [0,4,8], [0]  }; % 3x1
                    {[0], [0,4,8,12], [0] };    % 4x1
                    {[0], [0,4,8,12], [0,4,8,12]};  % 4x4
                    {[0], [0:4:20], [0:4:20]};  % 6x6
                    ...{[0], [0:2:20], [0:2:20]};  % 11x11
                    };

    allOriXYSets_one = { {[0], [0], [0]  } };

    allOriXYSets = allOriXYSets_mult;
%     allOriXYSets_C = allOriXYSets_one;
    
    allNoisyLetterOpts = expandOptionsToList (struct( 'expTitle', expTitle, ...
                                'tbl_OriXY', {allOriXYSets}, ... 'oris', oris, 'xs', xs, 'ys', ys,  ...
                                 'tf_pca', 0, ...
                                'tbl_sizeStyle', {all_sizeStyles_opt_C}, ...
                                'tbl_imageSize', {all_imageSizes_C}, ...
                                'autoImageSize', autoImageSize, ...
                                'tbl_blurStd', {allBlurStd_C}, ...
                                ...'tbl_noiseFilter', {bandNoiseFilters}, ...
                                'noiseFilter', whiteNoiseFilter, ...
                                'tbl_statsUse', {allStatsUse}, ...
                                ...'tbl_trainingNoise', {allTrainingNoise}, ...
                                'tbl_retrainFrom', {allRetrainFromLayers}, ...
                                ...'trainingNoise', trainingNoise, ...
                                ...'trainingNoise', whiteNoiseFilter, ...
                                'tbl_snr_train', {all_snr_train}, ...
                                textureStatOpts_C{:} ...
                             ) );
                         
%      xs = [-25, 0, 25];
%      xs = [0];
     
     for i = 1:length(allNoisyLetterOpts)
         OriXY = allNoisyLetterOpts(i).OriXY;
         [allNoisyLetterOpts(i).oris, allNoisyLetterOpts(i).xs, allNoisyLetterOpts(i).ys]  = deal( ...
             OriXY{1}, OriXY{2}, OriXY{3} );
         
     end



     nNoisyLetterOpt_std = struct( ...
        'oris', oris, 'xs', xs, 'ys', ys, 'expTitle', expTitle, 'tf_pca', 0, ...
        'sizeStyle',  sizeStyle, ...
        'imageSize', all_imageSizes_C{1}, ...
        'autoImageSize', autoImageSize, ...
        'blurStd', allBlurStd_C(1), ...
        'noiseFilter', whiteNoiseFilter, ...
        'targetPosition', 'all', 'nLetters', 1, ...
        'trainingNoise', allTrainingNoise(1),  ...
        textureStatOpts_C{:} ...
     ) ;
 
%     nNoisyLetterOpts(1) = nNoisyLetterOpt_std;
%     nNoisyLetterOpts(2) = nNoisyLetterOpt_std;  nNoisyLetterOpts(2).xs = [-25, 0, 25];


    
    nOpts = length(allNoisyLetterOpts);
%%    
%     opt_str = getLetterOptsStr(nNoisyLetterOpt_std);
    nNoisyLetterOpt_std2 = nNoisyLetterOpt_std;
    nNoisyLetterOpt_std2.noiseFilter = '';
    opt_str = getLetterOptsStr(nNoisyLetterOpt_std2);
% opt_str = '!!!';
%%
    
        
    
    
    
    switch x_name
        case 'Complexity', nX = length(allFontNames); % x_vals = fontComplexities;
        case 'FontSize',  nX = length(all_sizeStyles);
        case 'NoiseBand', nX = length(allNoiseFreqBands);
        case 'Uncertainty', nX = length(allOriXYSets);
    end
%     nX = length(x_vals);

    
    switch multiple_lines
        case 'Networks', 
            nLines = nNetworks;  
        case 'Opts',
            nLines = nOpts;
        case 'TrainingNoise',
            nLines = length(allTrainingNoise);
        case '',
            nLines = 1;
            
    end
        
        
    switch multiple_plots
        case 'Networks',  nPlots = nNetworks;  
        case 'Opts',      nPlots = nOpts;
        case '',          nPlots = 1;
    end
    
    
    
    %%%%%% Collect all pct correct
    fprintf('Gathering pct correct for all conditions...');

    x_vals = zeros(nX, 1);
    xticklabels = cell(1,nX); useXticklabels = 0;
  
    nClassesMax = 26;
    
    font_complexities_model         = zeros(nFonts, 1);    
    pctCorr_ideal                   = zeros(nX, nLines, nPlots, 1,       nSNRs_test, 1);
    pctCorr_model                   = zeros(nX, nLines, nPlots, nTrials, nSNRs_test, 1);
    convFilters = cell(nX, nLines, nPlots);

    font_complexities_model_indiv   = zeros(nFonts, nClassesMax);       
    pctCorr_ideal_indiv             = zeros(nX, nLines, nPlots, 1,       nSNRs_test, nClassesMax);
    pctCorr_model_indiv             = zeros(nX, nLines, nPlots, nTrials, nSNRs_test, nClassesMax);
    
    plotTitle = cell(1,nPlots);
    allPlotLegends_C = cell(1,nPlots); 

    network_use = allNetworks(1);
    noisyLetterOpt_use = nNoisyLetterOpt_std;
    fontName_use = allFontNames{1};
    fontSize_use = all_sizeStyles_C{1};
    
    for plot_i = 1:nPlots

        
        switch multiple_plots
            case 'Networks', network_use = allNetworks(plot_i);
                [~, plotTitle{plot_i}] = getNetworkStr(network_use, niceStrFields);
            case 'Opts',     noisyLetterOpt_use = allNoisyLetterOpts(plot_i);
                [~, plotTitle{plot_i}] = getNoisyLetterOptsStr(noisyLetterOpt_use, niceStrFields);
            case '', 
                plotTitle{plot_i} = '';
        end
                    
        line_legends = cell(1,nLines);
        for line_i = 1:nLines   
%             niceNetworkStrFields = {'doPooling', 'poolSizes'};
%             niceNetworkStrFields = {};
%             niceNetworkStrFields = {'doPooling'};
            niceNetworkStrFields = {'poolSizes'};
            [~, net_str_nice] = getNetworkStr(network_use, niceNetworkStrFields);
            net_str_nice = strrep(net_str_nice, ': ', '');
            switch multiple_lines
                case 'Networks', network_use = allNetworks(line_i);
                    
%                     niceLegendFields = {'filtSizes', 'poolSizes'}; %'doPooling', 'poolSizes', 'poolStrides'}; %'filtSizes', 'doPooling'};
                    niceLegendFields = [multiple_networks, niceNetworkStrFields];

                    [~, leg_str] = getNetworkStr(network_use, niceLegendFields);
                case 'Opts',     noisyLetterOpt_use = allNoisyLetterOpts(line_i);
                    [l_str, leg_str] = getLetterOptsStr(noisyLetterOpt_use, multiple_opts);
%                     leg_str = [net_str_nice '; ' leg_str];
                    leg_str = [net_str_nice '; ' l_str];
                    
                case 'TrainingNoise', 
                    noisyLetterOpt_use.trainingNoise = allTrainingNoise{line_i};
                    [~, leg_str] = getLetterOptsStr(noisyLetterOpt_use, {'trainNoise'});
                    leg_str = [net_str_nice '. ' leg_str];
                   
                case '',
                    leg_str = net_str_nice;
            end
            line_legends{line_i} = leg_str;
            
                
            
            for xi = 1:nX

                
                switch x_name
                    case 'Complexity', fontName_use = allFontNames{xi};
                                      
                        [font_complexities_model(xi), font_complexities_model_indiv(xi,:)] = getFontComplexity(fontName_use, fontSize_use);
                        x_vals(xi) = font_complexities_model(xi);
                        
                    case 'FontSize', 
                         noisyLetterOpt_use.sizeStyle = all_sizeStyles_C{xi};
                         x_vals(xi) = all_sizeStyles_C{xi};
                
                    case 'NoiseBand',
                        noisyLetterOpt_use.noiseFilter = bandNoiseFilters{xi};
                        x_vals(xi) = allNoiseFreqBands(xi);
                         
                    case 'Uncertainty',
                         OriXY = allOriXYSets{xi};
                         [noisyLetterOpt_use.oris, noisyLetterOpt_use.xs, noisyLetterOpt_use.ys]  = deal( ...
                             OriXY{1}, OriXY{2}, OriXY{3} );
                         x_vals(xi) = xi;
                         
                         [~, xticklabels{xi}] = getLetterOptsStr(noisyLetterOpt_use, 'Uncertainty');
                         useXticklabels = 1;
                end
                noisyLetterOpt_use_ideal = noisyLetterOpt_use;
                noisyLetterOpt_use_ideal.trainingNoise = 'same';
                
                
%     pctCorr_ideal                   = zeros(nX, nLines, nPlots, 1,       nSNRs_test, 1);
%     pctCorr_model                   = zeros(nX, nLines, nPlots, nTrials, nSNRs_test, 1);
                [pCorr_ideal_i, pCorr_ideal_i_indiv] = getIdealPerformance(fontName_use, allSNRs_test, noisyLetterOpt_use_ideal, opt); 

                pctCorr_ideal(      xi, line_i, plot_i, 1,         1:nSNRs_test) = pCorr_ideal_i;
                pctCorr_ideal_indiv(xi, line_i, plot_i, 1,         1:nSNRs_test, 1:nClassesMax) = pCorr_ideal_i_indiv;

                
                [pctCorr_model_i, pctCorr_model_indiv_i] = loadModelResults(expTitle, fontName_use, allSNRs_test, snr_train, network_use, noisyLetterOpt_use, opt, nTrials);

                pctCorr_model(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test) = pctCorr_model_i;
                pctCorr_model_indiv(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test, 1:nClassesMax) = pctCorr_model_indiv_i;

                if pctCorr_model_i(end) - pCorr_ideal_i(end) > 20
                    3;
                end
                    
                if showLayer1Filters 
                    trial_id = 1;
                    trainedModel = loadTrainedModel(expTitle, fontName_use, snr_train, network_use, noisyLetterOpt_use, opt, trial_id);
                    convFilters(xi, line_i, plot_i) = trainedModel;
                    
                    3;
                end
%                                 [pctCorr_ideal(xi, line_i, plot_i, 1,         1:nSNRs_test), pctCorr_ideal_indiv(xi, line_i, plot_i, 1,         1:nSNRs_test, 1:nClassesMax)] = ...
%                     getIdealPerformance(fontName_use, allSNRs_test, noisyLetterOpt_use, opt); 

%                 [pctCorr_model(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test), pctCorr_model_indiv(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test, 1:nClassesMax)] = ...
%                     loadModelResults(expTitle, fontName_use, allSNRs_test, snr_train, network_use, noisyLetterOpt_use, opt, nTrials);
                
            end % for all x
        end % for all lines
        
        
        
        
        allPlotLegends_C{plot_i} = line_legends;
        
    end % for all plots 
    fprintf(' done.\n');                
    
    getIdealPerformance('save');
    loadModelResults('save');

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if any(strcmp(y_name, {'Efficiency', 'Threshold_model', 'Threshold_ideal'}))
        fprintf('Calculating Efficiencies ...');
        
        th_model            = zeros(nX, nLines, nPlots, nTrials);
        th_ideal            = zeros(nX, nLines, nPlots, nTrials);
        model_efficiences   = zeros(nX, nLines, nPlots, nTrials);
        
        th_model_indiv          = zeros(nX, nLines, nPlots, nTrials, nClassesMax);
        th_ideal_indiv          = zeros(nX, nLines, nPlots, nTrials, nClassesMax);
        model_efficiences_indiv = zeros(nX, nLines, nPlots, nTrials, nClassesMax);
        
        
        %%
        progressBar('init-',nPlots * nLines * nX);
        
        for plot_i = 1:nPlots
            for line_i = 1:nLines
                for xi = 1:nX
                                      
                    pCorr_model_i = reshape( pctCorr_model(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test), [nTrials, nSNRs_test]);
                    pCorr_ideal_i = reshape( pctCorr_ideal(xi, line_i, plot_i, 1,         1:nSNRs_test), [1, nSNRs_test]);
                    [model_efficiences(xi, line_i, plot_i, 1:nTrials), th_model(xi, line_i, plot_i, 1:nTrials),  th_ideal(xi, line_i, plot_i, 1:nTrials)] = ...
                        getModelEfficiency(allSNRs_test, pCorr_model_i, pCorr_ideal_i);

                    
                    if plotIndividualLetterResults
                        for class_i = 1:nClassesMax
                            pCorr_model_indiv_i = reshape( pctCorr_model_indiv(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test, class_i), [nTrials, nSNRs_test])';
                            pCorr_ideal_indiv_i = reshape( pctCorr_ideal_indiv(xi, line_i, plot_i, 1,         1:nSNRs_test, class_i), [nSNRs_test, 1]);
                            
                            [model_efficiences_indiv(xi, line_i, plot_i, 1:nTrials, class_i), th_model_indiv(xi, line_i, plot_i, 1:nTrials, class_i),  th_ideal_indiv(xi, line_i, plot_i, 1:nTrials, class_i)] = ...
                                getModelEfficiency(allSNRs_test, pCorr_model_indiv_i, pCorr_ideal_indiv_i);
                        end

                    end
                    progressBar;
                                            
                end % for all X
            end % for all lines
        end % for all Plots
        
        
        switch y_name
            case 'Efficiency',       Y_vals = model_efficiences;
                model_efficiences_M = nanmean(model_efficiences, 4);
            case 'Threshold_model',  Y_vals = th_model;
            case 'Threshold_ideal',  Y_vals = th_ideal;
            otherwise,  error('Unknown yname');
        end
        
        
    elseif strcmp(y_name, 'maxPctCorrect')
        
        
        %%
        
        maxPctCorrect = max( pctCorr_model, [], 5 ); % take max over SNRs tested
                
        Y_vals = maxPctCorrect;        
                
    elseif strcmp(y_name, 'pctCorrect')
        
        Y_vals = pctCorr_model;
        
    end
    
    

     Y_vals_M = nanmean(  Y_vals, 4    ); % average over trials
     Y_vals_S = nanstd(   Y_vals, [], 4); % average over trials 

     if strcmp(x_name, 'NoiseBand') && size(Y_vals_M, 2) == 1
%          idx_rm = (Y_vals_M == 0.1) & [Y_vals_M(2:end); nan] == 0.1;
%          Y_vals_M(idx_rm) = nan;
     end
     
%%
     

  
     if doSizeTuningTest && 0
         %%
         figure(39); clf; hold on; box on;

         
         plotErrorbars = 0;
         
         addHumanData = 0;

         [x_deg, human_eff_0, human_eff_5deg] = getHumanSizeData();
     
     
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
%         legend(legend_strs(:), 'location', 'SE', 'fontsize', 12);
        3; 
         
         
     end
     

     %%
     human_plotAllFonts = true;
    if human_plotAllFonts
        allFontNames_human = setdiff( fieldnames(getStatsFromPaper), {'Checkers4x4', 'words3', 'words5', 'words5_many'});
%         allFontNames_human = setdiff( fieldnames(getStatsFromPaper), {'words3', 'words5', 'words5_many'});
        
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
    
    3;
    
    
    %%
    fig_base = 50;
    
%     niceLegendFields = {'filtSizes', 'poolSizes', 'doPooling'};

    
    

%     y = -x + 2
    
    
%     cols = ['bgrk'];
    addSlopesToLegend = false;
    lineSt = {'-', '--'};
%     mkrs = ['os*v'];
%     colors_use = 'brgbmc';
    colors_use = 'brg';
%     colors_use = 'mkgbrgmc';
    markers_use = 'oxs*dph';
    idx_notBraille = find(~strcmp(allFontNames, 'Braille'));
    letters_charU = 'A':'Z';
    letters_charL = 'a':'z';
    mk_size = 7;
    line_w = 2;
       
%     plotHumanEfficiencyLineFit = true; 
    plotHumanEfficienyPoints = false;
    plotEfficiencyLineFit_human = true && any(strcmp(yvsx_name, {'Efficiency_vs_Complexity', 'Threshold_vs_NoiseBand'}));
    plotEfficiencyConnectingLine_human = false; 

    plotEfficiencyLineFit_model = false; 
    plotEfficiencyConnectingLine_model = true; 
    plotLinesConnectingBoldToNonbold_model = true; 
    showErrorBarsForMultipleTrials_model = true;
    

    
    
    if plotIndividualLetterResults
        plotIndivLettersRelativeToMean = false;

        if plotIndivLettersRelativeToMean
            font_complexities_model_indiv_plot = bsxfun(@rdivide, font_complexities_model_indiv, font_complexities_model);
            model_efficiences_indiv_plot = bsxfun(@rdivide, model_efficiences_indiv, model_efficiences_M);
        else
            font_complexities_model_indiv_plot = font_complexities_model_indiv;
            model_efficiences_indiv_plot = model_efficiences_indiv;
        end
    end    
    %%
    color_idx_start = 1;
    marker_idx_start = 1;
    all_colors_idx = mod([1:nLines] + color_idx_start-2, length(colors_use))+1;
    all_colors = color_s(all_colors_idx, colors_use);
    
    all_markers_idx = mod( ceil([1:nLines]/length(colors_use)) + marker_idx_start-2, length(markers_use))+1;
    all_markers = marker(all_markers_idx, markers_use);
%%
%     if networks_vary_color   % networks are different colors. opts vary by marker
%     %%
% 
%         all_colors  = repmat( color_s(1:nNetworks + color_idx_start-1, colors_use)', [1, nOpts]);
%         all_markers = repmat( marker(1:nOpts + marker_idx_start-1, markers_use), [nNetworks, 1]);
% 
%     
% %     all_colors = repmat( colors_s(1:nOpts, colors_use), [nNetworks, 1]);        
% %         all_markers = repmat( marker(1:nNetworks), [nNetworks, 1]);
% 
%     else % networks have different markers. opts vary by color
%         %%
%         all_colors  = repmat( color_s(1:nOpts + color_idx_start-1, colors_use), [nNetworks, 1]);
%         all_markers = repmat( marker(1:nNetworks + marker_idx_start-1, markers_use)', [1, nOpts]);
%         
%         
%     end
%     assert(isequal(size(all_colors), [nNetworks, nOpts]))
%     assert(isequal(size(all_markers), [nNetworks, nOpts]))
        
    
    
    for plot_i = 1:nPlots
        
        figure(fig_base + plot_i); 
        clf; 
%         subplot(1,2,1); hold on; box on;
        hold on; box on;
        h_ax(plot_i) = gca;

        
        if strcmp(x_name, 'Complexity')
            human_x = font_complexities_human;
            human_y = human_efficiencies;
            human_s = human_efficiencies_stderr;
        elseif strcmp(x_name, 'FontSize')
            [x_deg, human_eff_0, human_eff_5deg] = getHumanSizeData();
            human_x = x_deg;
            human_y = human_eff_0;
            human_s = nan(size(human_eff_0));
        elseif strcmp(x_name, 'NoiseBand')
            [x_noiseFreq, y_threshold] = getHumanChannelData();
            human_x = x_noiseFreq;
            human_y = y_threshold;
            human_s = nan(size(human_y));
            
        end
        
        if plotHumanEfficienyPoints
%%

    %         plot(font_complexities_human, human_efficiencies, 'k:^', 'linewidth', 2, 'markersize', 8)
            h_human_pts = errorbar(human_x, human_y, human_s, 'k:s', 'markersize', mk_size, 'linewidth', line_w);
            if ~plotEfficiencyConnectingLine_human
                set(h_human_pts, 'lineStyle', 'none')
            end
            human_pts_str = {'Human performance'};
            3;

        else
            h_human_pts = [];
            human_pts_str = {};
        end

        if plotEfficiencyLineFit_human 
            if strcmp(x_name, 'Complexity') % straight line
%                 font_complexities_human_srt = lims(font_complexities_human);
                font_complexities_human_srt = [10, 1000];
                human_efficiencies_fit = 9.1./font_complexities_human_srt;
        %     plot(font_complexities_human, human_efficiencies, 'k^', 'linewidth', 2, 'markersize', 8)
                h_human_line = plot(font_complexities_human_srt, human_efficiencies_fit, 'k-', 'linewidth', 6);

                human_line_str = {'Human performance (fit)'};
            elseif strcmp(x_name, 'NoiseBand') % curve
                h_human_line = plot(x_noiseFreq, y_threshold, 'k-', 'linewidth', 6);
                human_line_str = {'Human performance'};
            end
            
        else
            human_line_str = {};
            h_human_line = [];
        end

        3;
        
        for line_i = 1:nLines

%         line_s = lineSt{ floor(net_i/6)+1};

            line_s = iff( plotEfficiencyConnectingLine_model, '-', ''); %linestyle( floor(net_i/6) );
    %         mkr_s = 'o'; marker(net_i, markers_use);   % marker( floor(net_i/6)+2);
    %         mkr_s = marker( net_i+1 );
    %         clr_s = color_s(net_i, colors_use);
            clr_s = all_colors(line_i);
            mkr_s = all_markers(line_i);

            [log_slope, log_slope_ci, p_fit] = getLogSlope(font_complexities_model, Y_vals_M(:, line_i, plot_i) );
            [log_slope_noB, log_slope_noB_ci, p_fit_noB] = getLogSlope(font_complexities_model(idx_notBraille), Y_vals_M(idx_notBraille, line_i, plot_i) );

% model_efficiences = zeros(nX, nLines, nPlots, nTrials, 1);
            if ~plotIndividualLetterResults

    %             font_complexities_model_mtx = repmat(font_complexities_model(:), 1, nFonts);
                if (nTrials > 1) && any(Y_vals_S(:,line_i, plot_i) > 0)  && showErrorBarsForMultipleTrials_model
    %                 h(net_i) = errorbar(x_vals, all_pCorr1_M(:,line_i), all_pCorr1_S(:,line_i), [mkr_s clr_s '-'], 'markersize', 8);

                    h_model_pts(plot_i, line_i) = errorbar(x_vals, Y_vals_M(:, line_i, plot_i), Y_vals_S(:,line_i, plot_i), [clr_s mkr_s line_s]);
                else
                    h_model_pts(plot_i, line_i) = plot(x_vals, Y_vals_M(:, line_i, plot_i), [clr_s mkr_s line_s]);
                end            
                set(h_model_pts(plot_i, line_i), 'markersize', mk_size, 'linewidth', line_w)

                if plotEfficiencyLineFit_model
                    eff_fit_i = 10.^ polyval(p_fit, log10(font_complexities_model) );
                    h_model_fit(plot_i) = plot(font_complexities_model, eff_fit_i, [clr_s '-'], 'linewidth', line_w);
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

%                             h_bold_lines(end+1) = plot(font_complexities_model([plain_idxs(idxs(k)) bold_idxs(idxs(k))]), Y_vals_M(1,[plain_idxs(idxs(k)) bold_idxs(idxs(k))], net_i, 1, opt_i), [color_s(j), 'o' line_s], 'linewidth', 2,  'markersize', mk_size); 
                        3;
                        end

                    end
                    3;
                    legend([h_bold_lines], [allPlainFonts], 'interpreter', 'none');
                end


            elseif plotIndividualLetterResults
    %%
                color_s2 = 'bgrkm';
                figure(fig_base+100 + plot_i); clf; hold on; box on;
    %             h_line(net_i) = plot(font_complexities_model, model_efficiences(:,:,net_i), 'bo-');
                for font_i = 1:nFonts
                    h_tmp(plot_i) = plot(1, nan, 'color', color_s2(font_i));
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

            if strcmp(y_name, 'Efficiency')
                rms_i = rms(log10(model_efficiences_M(:,line_i, plot_i)) - log10(model_efficiences_expected) );
                meanDist_i = mean(log10( model_efficiences_M(:,line_i, plot_i)) - log10(model_efficiences_expected) );
                abs_i = mean(abs(log10(model_efficiences_M(:,line_i, plot_i)) - log10(model_efficiences_expected) ));

                allRMS(line_i) = rms_i;
                allMeanDists(line_i) = meanDist_i;
                allABS(line_i) = abs_i;
                allLogSlope(line_i) = log_slope;
                allLogSlope_ci(:,line_i) = log_slope_ci;
                allLogSlope_noB(line_i) = log_slope_noB;
                allLogSlope_noB_ci(:,line_i) = log_slope_noB_ci;


                line_legends = allPlotLegends_C{plot_i};
                fprintf('%s : rms log10 error = %.3f. (%.3f)  log_slope = %.2f.  (without braille: %.2f) \n', line_legends{line_i}, rms_i, abs_i, log_slope, log_slope_noB);
                if ~isnan(log_slope) && addSlopesToLegend

                    line_legends{line_i} = sprintf('%s [%.1f]', line_legends{line_i}, log_slope);
                end
            end
            3;
    %         rms(log10(model_efficiences_M(:,:,plot_i) - log10(human_efficiencies)) );
    %         fprintf('%s : ', )
        end
        
        
        
        alsoPlotIdeal = strcmp(x_name, 'NoiseBand') && 0;
        if alsoPlotIdeal
            %%
            th_ideal_M = nanmean(th_ideal, 4);
            h_ideal = plot(x_vals, th_ideal_M(:,1), 'o:', 'linewidth', 1, 'color', .6*[1,1,1]);
            
%             leg_ideal_C = {'Ideal (White Noise)'};
            leg_ideal_C = {'Template Matcher'};
        else
            h_ideal = [];
            leg_ideal_C = {};
        end
        
%%
        legend_strs_plot_i = [line_legends(:); human_pts_str{:}; human_line_str{:}; leg_ideal_C(:) ];
        leg_location = 'bestOutside';
%         leg_location = 'NE';
        3;
%         leg_location = 'SW';
        %%
        
%         h_legend = legend([h_human_pts, h_human_fit, h_model_pts(plot_i,:) h_ideal], legend_strs_plot_i, ...
%             'location', leg_location, 'fontsize', 10, 'edgecolor', 'w');
        
%         legend_strs_plot_i = flipud(legend_strs_plot_i);
        
        %%
        if strcmp(expTitle, 'NoisyLettersTextureStats');
            legend_strs_plot_i{1} = 'Texture model';
        end

        for i = 1:length(legend_strs_plot_i)
            legend_strs_plot_i{i} = strrep(legend_strs_plot_i{i}, 'ConvNet. Tr', 'ConvNet tr');
        end
        if strcmp(x_name, 'Complexity') && strcmp(netType, 'ConvNet')
%             legend_strs_plot_i{1} = 'ConvNet: no pooling';
%             legend_strs_plot_i{2} = 'ConvNet: pooling = 4x4';
        end
        
        h_legend = legend([h_model_pts(plot_i,:), h_human_pts, h_human_line, h_ideal], legend_strs_plot_i, ...
            'location', leg_location, 'interpreter', 'none', 'fontsize', 10, 'edgecolor', 'w');

        
        %%
        if ~(plotIndividualLetterResults && plotIndivLettersRelativeToMean)
            %%
            if any(strcmp(x_name, {'NoiseBand', 'Complexity'}))
                set(gca, 'xscale', 'log');
            end
            if any(strcmp(y_name, {'Efficiency', 'Threshold'}))
                set(gca, 'yscale', 'log');
            end
            
            
        %     set(gca, 'ylim', [.02, 1], 'xlim', [20, 100]);
            % set(gca, 'ylim', [.01, 1], 'xlim', [10, 100]);
            addFontNamesToXlabel = 0;
            if addFontNamesToXlabel
                allFonts_list_C = {['[ ' cellstr2csslist(allFontNames(font_idx_modelC)), ']']};
            else
                allFonts_list_C = {};
            end
            
    %         xlabel('Complexity', 'fontsize', 13)
            %%
%             xlim([.1, 1e2])
%             ylim([.1, 1e4])
            
            if strcmp(x_name, 'NoiseBand')
                xlims = [.1, 100];
                ylims = [.1, 1000];
            elseif strcmp(x_name, 'Complexity')
                xlims = [10, 1000];
                ylims = [.01, 1];              
            elseif strcmp(x_name, 'Uncertainty')
                xlims = [min(x_vals)-1, max(x_vals)+1];
                ylims = [];
            end
           
            if ~isempty(xlims)
                set(gca, 'xlim', xlims)
            end
            if ~isempty(ylims)
                set(gca, 'ylim', ylims);
            end
            setLogAxesDecimal;
            
            %%
            label_fontSize = 18;
%             set(gca, 'position', [0.1300    0.1211    0.4503    0.8039]); %*************
            switch y_name
                case 'Threshold_model', y_label_str = 'Threshold';
                otherwise, y_label_str = y_name;
            end
            ylabel(y_label_str, 'fontsize', label_fontSize, 'interpreter', 'none');
            
            xlabel_str = x_name;
            switch x_name,
                case 'Complexity', xlim([10, 1000]);
                case 'FontSize', xlim( lims(all_sizeStyles, .5, [], 1) )
                case 'NoiseBand', xlabel_str = 'Noise frequency (c/letter)';
            end
            xlabel({xlabel_str, allFonts_list_C{:}}, 'fontsize', label_fontSize)
            
            if useXticklabels
                set(gca, 'xtick', x_vals, 'xticklabel', xticklabels);
            end
            
            switch y_name
                case 'Efficiency', ylim([.01, 1]);
%                 case ''
            end
    %         

        end
        
        
          %%
%         decades_equal;
        trainErrStr = iff(opt.useTrainingError, ' [Using TRAINING error]. ', '');
        addOptsAndSize = 0;
        
        optSizeStr_C = iff(addOptsAndSize, {[strrep(opt_str, '_', ', ')  ' (Size = ' sizeStyle ')'] }, {});
        
%         optSizeStr_C = {};
        title_str = yvsx_name;
        if strcmp(x_name, 'NoiseBand') && strcmp(y_name, 'Threshold_model')
            title_str = 'Filter Gain';
        elseif strcmp(x_name, 'Complexity') && strcmp(y_name, 'Efficiency')
            title_str = 'Efficiency vs Complexity';
        end
            
            
        title({[ title_str trainErrStr ], plotTitle{plot_i}, optSizeStr_C{:}}, 'fontsize', 14, 'interp', 'none');
        3;
%         title('');
    %     title('Efficiency vs. complexity', 'fontsize', 16, 'interp', 'none')

    %     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  664.9500  430.0000]);
    %     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  670  430.0000]); % too wide, too short
    %     set(gca, 'units', 'pixels', 'position', [ 80    84   473   516]); 
    %     set(gcf, 'units', 'pixels', 'position', [548   242   610   660])
%         set(gcf, 'position',  [650   332   623   546]);
%         set(gcf, 'position', [509   330   828   499]);
%         set(gcf, 'position', [509  369  1003  460]);
        %%
%         set(gca, 'units', 'pixels', 'position', [ 101    55   348   327]);
%         set(gcf, 'position', [1197         338         536         412]);
        if ~isFigureDocked(gcf)
            set(gcf, 'position', [1197         338         536         442]);
        end
        
%         set(gcf, 'position', [814   329   730   412]);
%         set(gca, 'units', 'pixels', 'position', [101    55   348   327]);


%         set(gca, 'units', 'pixels', 'position', [101    55   348   357]); % *****
        
        %%
        if strcmp(x_name, 'NoiseBand') && length(h_model_pts) == 3
            set(h_model_pts, 'linewidth', 1)
            set(h_model_pts(3), 'linewidth', 2)
            
        end
        
        
        
%         237     4   731   487
        3;
    end

    3;
    if showLayer1Filters 
        %%
        figure(5); clf; 
    %     m = floor(sqrt(nNetworks));
    %     n = ceil(nNetworks/m);
        i = 1;
        for line_i = 1:nLines
%             for fi = 1:nFonts
%                 h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); 
            h_axx(line_i) = subplot(1, nLines, line_i); 

            imagesc(tileImages( convFilters{1, line_i}, 6, 1, 1, 0.5));
            L = max(abs(convFilters{1, line_i}(:)));
            
            
            leg_str_i = line_legends{line_i};
            if strcmp(multiple_lines, 'TrainingNoise')
                idx_Tr = strfind(leg_str_i, 'Train: ') + length('Train:');
            elseif strcmp(multiple_lines, 'Networks')
                idx_Tr = strfind(leg_str_i, 'ConvNet: ') + length('ConvNet: ')+1;
            end
            filtTitles{line_i} = leg_str_i(idx_Tr:end);
            title(filtTitles{line_i});
            
            
            caxis([-L, L]);
            axis equal tight;
%                 i = i + 1;
%             end

        end
        set(h_axx, 'xtick', [], 'ytick', [])
        colormap('gray');
        set(gcf, 'position', [624   521   636   457]);
        
        
        
                %%
        figure(6); clf; 
        fontHeight = 18;
    %     m = floor(sqrt(nNetworks));
    %     n = ceil(nNetworks/m);
        all_filterGains = cell(1, nLines);
        for line_i = 1:nLines
%             for fi = 1:nFonts
%                 h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); 
            figure(6);
            h_axx2(line_i) = subplot(1, nLines, line_i); 


            for filt_idx = 1:6
                filt_i = convFilters{1, line_i}(:,:,filt_idx);
                [freq_cycPerPix, all_filterGains{line_i}(filt_idx,:)] = filterGain(filt_i, 50);
                freq_cycPerLet = freq_cycPerPix * (fontHeight);
                
%                 rps_i(filt_i,:) = radialPowerSpectrum();
            end
            
            plot(freq_cycPerLet, all_filterGains{line_i}');
            log_ylims{line_i} = ylim;
            
            title(filtTitles{line_i});
            
            
            if line_i == 1                
                ylabel('Power');
            else
                ylabel('  ');
            end
            if line_i == ceil(nLines/2)
                    xlabel('Cycles Per Letter');
            end

%             figure(
            
%             errorbar(freq_cycPerLet, mean(all_filterGains, 1), std(all_filterGains, [], 1), 'o-');
%                 i = i + 1;
%             end
%             xlim(lims([1, 4], .02))
        end
        set(h_axx2, 'xscale', 'log', 'yscale', 'log');
        
        log_ylims = get(h_axx2, 'ylim');
        logy_lims_all = log10(lims([log_ylims{:}])); 
        logy_lims_all = [-8, -2];
        set(h_axx2, 'ylim', 10.^[logy_lims_all]);
        set(h_axx2, 'ytick', 10.^(logy_lims_all(1) : logy_lims_all(2)));
        
        set(6, 'position', [899   454   821   284])
        
        %%
        showAngularFilters = 0;
        if showAngularFilters
            figure(7); clf; 
        %     m = floor(sqrt(nNetworks));
        %     n = ceil(nNetworks/m);
            all_filterAngularPS = cell(1, nLines);
            for line_i = 1:nLines
    %             for fi = 1:nFonts
    %                 h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); 
                figure(7);
                h_axx3(line_i) = subplot(1, nLines, line_i);  hold on;


                for filt_idx = 1:6
                    filt_i = convFilters{1, line_i}(:,:,filt_idx);

                    [aps_rho, aps_theta] = filterAngularGain(filt_i, 50);
                    all_filterAngularPS{line_i}(filt_idx,:) = aps_rho;

    %                 rps_i(filt_i,:) = radialPowerSpectrum();
                    [aps_x, aps_y] = pol2cart(aps_theta, log10(aps_rho) );

                    plot(aps_theta, log10(aps_rho), color_s(filt_idx));
    %                 plot(aps_x, aps_y, color_s(filt_idx));
                end


                title(filtTitles{line_i});


                if line_i == 1                
                    ylabel('Power');
                else
                    ylabel('  ');
                end
                if line_i == ceil(nLines/2)
                        xlabel('Cycles Per Letter');
                end

    %             figure(

    %             errorbar(freq_cycPerLet, mean(all_filterGains, 1), std(all_filterGains, [], 1), 'o-');
    %                 i = i + 1;
    %             end
    %             xlim(lims([1, 4], .02))
            end
    %         set(h_axx3, 'xscale', 'log', 'yscale', 'log');

            aps_xlims = get(h_axx3, 'xlim');
            aps_ylims = get(h_axx3, 'ylim');

            L = max(abs(lims([aps_xlims{:}, aps_ylims{:}])));
    %         set(h_axx3, 'xlim', [-L, L], 'ylim', [-L, L]);

            set(7, 'position', [899   454   821   284])

        end        
%         set(h_axx, 'xtick', [], 'ytick', [])
%         colormap('gray');
        
        
        3;
        

    end
    
    3;
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
        
        errorbar(repmat([1:nClassesMax]', 1, nFonts), efficiency_gap_mean_srt, efficiency_gap_std_srt);
        set(gca, 'xtick', 1:26, 'xticklabel', arrayfun(@(i) char(i+'a'-1), idx_order, 'un', 0))
        xlim([0, 27]);
        legend(allFontNames, 'location', 'best')
        3;
        

        
    end
    
    2;
    
    
    %set(h_line(1), 'color', 'r', 'linestyle', ':', 'marker', 's', 'linewidth', 2, 'markersize', 8)
%     set(h_line(6), 'color', 'k')


 
    
    showExampleLetters = false;
    if showExampleLetters 
        %%
            S_ex = load('exampleLetters.mat');
            allIm = S_ex.allIm;
%             tic;
%             allIm = cell(1,nFonts);
%             for fi = 1:nFonts
%                 allLetters = loadLetters(allFontNames{fi}, 'big');
%                 if strcmp(allFontNames{fi}, 'Braille')
%                     let_idx = 4;
%                 else
%                     let_idx = 1;
%                 end
%                 allIm{fi} = allLetters(:,:,let_idx);
%             end
%             %%
%             maxH = max(cellfun(@(x) size(x,1), allIm));
%             maxW = max(cellfun(@(x) size(x,2), allIm));
%             for i = 1:length(allIm)
%                 allIm{i} = symmetricPad(allIm{i}, [maxH, maxW]);
%             end
            
                %%
                [example_imH, example_imW] = size(allIm{1});

            ax_pos = getModifiedLogAxPosition(h_ax);
            fig_pos = get(gcf, 'position');
            fig_ar = fig_pos(4)/fig_pos(3);
            
            ax_log_xlim = log10(get(h_ax, 'xlim'));
%             ax_log_ylim = log10(get(h_ax, 'ylim'));
                                    
            log_cmp = log10(font_complexities_model);
            
            %%
            
            log_lims = lims(log10(font_complexities_model), .25, [], 1);
            font_complexities_spaced = logspace(log_lims(1), log_lims(2), nFonts);            
            log_cmp_spaced = log10(font_complexities_spaced);
            
            %%
            for fi = 1:nFonts
                pos_i_cent = (log_cmp_spaced(fi)-ax_log_xlim(1))/diff(ax_log_xlim);
                w = .07;
                h = w * example_imH/example_imW / fig_ar;
                pos_i_cent_fig = ax_pos(1) + ax_pos(3)*pos_i_cent;
%                 pos_i = [(pos_i_cent_fig - w/2), ax_pos(2)+ax_pos(4)-h*1.5, w, h];
                pos_i = [(pos_i_cent_fig - w/2), ax_pos(2)+ h*.6, w, h];
                
                h_ax_let(fi) = axes('position', pos_i);
                image_fi = 1-allIm{fi};
                smooth_w = 0.5;
%                 image_fi = gaussSmooth( gaussSmooth(image_fi, smooth_w, 1), smooth_w, 2);
                
                h_im_let(fi) = imagesc(image_fi);
                ticksOff(h_ax_let(fi))
                colormap(h_ax_let(fi), 'gray');
                set(h_ax_let(fi), 'visible', 'off')
                
            end
%             toc;
            
%%            
        3;
        
%%
       
    end
    

    if plotLinesConnectingBoldToNonbold_model
%             legend([h_human_fit, h_bold_lines], [human_fit_str, allPlainFonts], 'interpreter', 'none');

        
    end
    
    2;
    %%
    saveFigToFile = 0;
    set(h_model_pts, 'linewidth', 2)
    if saveFigToFile
        save_folder = [lettersPath fsep 'Figures' fsep 'Slides' fsep 'slope_v_params' fsep];
    
        for i = 1:length(h_model_pts)
            
            fname1 = sprintf('slope_v_%s_%d.emf', multiple_networks, i);

            set(h_model_pts, 'linewidth', 1); set(h_model_pts(i), 'linewidth', 2)
%             print(fig_base + 1, [save_folder fname1], '-dmeta', '-r300');
            3;
        end
    end    
    3;
    %%

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
        filtSizes = [2,5,10,20];
        poolTypes = [1,2,4];
        
        allNetworks_pooling = defaultNetwork_pool;
        
        doInSeparateWindows = 1;
        
        curParam = multiple_networks;
        switch curParam
            case 'nStates1',  curLabel = '# of convolutional filters';   sub_i = 1;
            case 'nStates2',  curLabel = '# of fully-connected units';   sub_i = 2;
            case 'filtSizes',  curLabel = 'Size of convolutional filters'; sub_i = 3;
            case 'poolSizes',  curLabel = 'Size of pooling window'; sub_i = 4;
            case 'poolTypes', curLabel = 'Pnorm of pooling operation'; sub_i = 5;

        end
                
%         curParam = 'nStates1';   sub_i = 1;
%        curParam = 'nStates2';   sub_i = 2; 
%         curParam = 'filtSize'; sub_i = 3;
%         curParam = 'poolSize'; sub_i = 4;

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
                
            case 'poolSizes',
                x = poolSizes;
                for i = 1:length(poolSizes)
                    allNetworks_pooling(i) = defaultNetwork_pool;       
                    if poolSizes(i) > 0
                        allNetworks_pooling(i).poolSizes = poolSizes(i);
                    else
                        allNetworks_pooling(i).doPooling = 0;
                    end
                end
                
            case 'filtSizes',
                x = filtSizes;
                for i = 1:length(filtSizes)
                    allNetworks_pooling(i) = defaultNetwork_pool;       allNetworks_pooling(i).filtSizes = filtSizes(i);
                end
                
            case 'poolTypes',
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
        
        if doInSeparateWindows
            fig_id = 240 + sub_i;
            figure(fig_id); clf(fig_id); box on; hold on;
%             set(fig_id, 'position', 
        else
            fig_id = 242;
            figure(fig_id); clf; subplot(2,2,sub_i); cla; box on; hold on;
        end
        
        
        
        if ~strcmp(curParam, 'poolSizes')
            h(1) = plot(x, slopes_nopool, 'bo-'); 
        end
        
        mk_size = 8;
        h(2) = plot(x, slopes_pool, 'ro-', 'markersize', mk_size); 
%         plot(x(idx_default), slopes_pool(idx_default), 'rs', 'markersize', 10, 'markerfacecolor', 'r'); 
        plot(x(idx_default), slopes_pool(idx_default), 'rs', 'markersize', 15, 'linewidth', 2); 
        h_cur = plot(x(1), slopes_pool(1), 'ro', 'markerfacecolor', 'r', 'markersize', mk_size); 


%         errorbar(x, slopes_nopool, slopes_nopool_L, slopes_nopool_U, 'bo-');
%         errorbar(x, slopes_pool,   slopes_pool_L, slopes_pool_U,   'rs-');
        
        xlabel(curLabel, 'FontSize', 12);
        ylabel('log-log slope', 'FontSize', 12);
        if any(strcmp(curParam, {'nStates1', 'nStates2', 'filtSizes'}))
            set(gca, 'xscale', 'log');
            xlim(lims(x, .05, [], 1))

        else
            xlim(lims(x, .1))
        end
        
        
        h(3) = drawHorizontalLine(-.91, 'linestyle', ':', 'color', 'k');
        
        set(nonzeros( h) , 'markersize', mk_size);
%         if showNoPooling
        if sub_i == 1
            legend(h, {'No pooling', 'With pooling', 'Human best fit line'}, 'location', 'bestOutside', 'fontsize', 12);
        end
%         else
%             legend({'With Pooling'}, 'location', 'best', 'fontsize', 12);
%         end

        if any(strcmp(curParam, {'poolTypes', 'poolSize'})) || true
            set(gca, 'xtick', x);
        else
            %%
            set(gca, 'xtickMode', 'auto');
        end
        
        if strcmp(curParam, 'poolTypes')

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
        %%
        if doInSeparateWindows
            set(gcf, 'position', [1141         490         358         228]);
            3;
            %%
            for cur_i = 3; %1:length(slopes_pool)
                set(h_cur, 'xdata', x(cur_i), 'ydata', slopes_pool(cur_i));

                3;
            end
        end        
        
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


 function [x_deg, human_eff_0, human_eff_5deg] = getHumanSizeData()

     x_deg  =         [0.1,   0.25,  0.5,  1,    2,     4,     8,     16,    30];
     human_eff_0    = [0.0715, 0.095, 0.14, 0.12, 0.097, 0.075, 0.053, 0.036, 0.0275];
     human_eff_5deg = [nan     0.04  0.065, 0.111, 0.078, 0.065, 0.049, 0.035, 0.0255];
 end
 
 function [x_noiseFreq, y_threshold] = getHumanChannelData()

     x_noiseFreq = [0.5, 0.8, 1.3, 2.0,  3.2, 5.1, 8.1, 13];
     y_threshold = [.21,  .43,   2.03,   12.3,   96.5,  120,  26   8.02];

%      x_noiseFreq  = [ 0.41, 0.82, 1.65, 3.3, 6.7, 13];
%      y_threshold  = [nan, 0.1000   52.5000  124.5000   97.5000    0.1000];
 end
 

