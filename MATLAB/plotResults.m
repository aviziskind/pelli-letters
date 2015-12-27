function plotResults

    nTrials = 1;
%     fig_offset = 0;
    fig_offset = 42;

%     expName = 'ChannelTuning';
%     expName = 'Crowding';
%     expName = 'Grouping';
    expName = 'Complexity';
%     expName = 'TrainingWithNoise';
%     expName = 'Uncertainty';

    modelName = 'ConvNet';
%     modelName = 'Texture';
%     modelName = 'OverFeat';


    doLabelsForPaper = 0;
    justShowHumanData = 0;
    
    makeWideAxes = true;

    displayValuesOfPlots = true;
    
    plotIndividualLetterResults = false;
    showConvNetFilters = false && strcmp(modelName, 'ConvNet'); % && strcmp(expName, 'ChannelTuning');  %&& strcmp(netType, 'ConvNet');
        opt.convNetFilterLayer = 1;
        
    
    
    opt.skipIfDontHaveModelFile = true;
    opt.warnIfDontHaveModelFile = true;
    opt.skipIfDontHaveModelNetworkFile = true;
    
    opt.useTrainingError = false;
    opt.skipIfDontHaveIdealFile = false;
    opt.returnFontsInStruct = false;
    opt.allowFewerThanSpecifiedTrials = 1;
    
    
    opt.alsoGetFullModels = true;
    
    opt.usePctCorrectTargetOnly = true;
    opt.ideal_multiplyTemplates = false;
    opt.ideal_useCombinedTemplates = false;
    
    opt.allowSubsetOfSNRs = true;
    
    
    useLargePlotFontSizes = 1;

    opt.ideal_normalized_thresholds  = 1;

    
    noise_selectFrequencies = false;    
%     noise_selectFrequencies = true;    
    
    
    
    doConvNet = strcmp(modelName, 'ConvNet');
    doTextureStatistics = strcmp(modelName, 'Texture');
    doOverFeat = strcmp(modelName, 'OverFeat');
    
    % *** Stimulus Type
    if doConvNet
        stimType = 'NoisyLetters';
    elseif doTextureStatistics
        stimType = 'NoisyLettersTextureStats';
    elseif doOverFeat
        stimType = 'NoisyLettersOverFeat';
    end


    % *** Which Model Architecture
    switch modelName
        case 'ConvNet',
            netType = 'ConvNet';
        case {'Texture', 'OverFeat'},
            netType = 'MLP';
    end
    
    
    
%     sizeStyle = 'large';
%     sizeStyle = 'med';
%     sizeStyle = 'k18';
%     sizeStyle = 'k38';
%     sizeStyle = 'k16';
%     sizeStyle = 'k14';
%     sizeStyle = 'k30';

        
    
    
%         getIdeal = any(strcmp(expName, {'Complexity', 'ChannelTuning'}));


    %% X/Y Variables
    
    switch expName
        case 'ChannelTuning',
            x_name = 'NoiseFreq';   y_name = 'Threshold_model';
%             x_name = 'NoiseFreq';   y_name = 'Channel_Gain';

            channels_trainOn = 'SVHN'; 
%             channels_trainOn = 'pinkNoise'; 

            
        case 'Crowding',
            x_name = 'Spacing'; y_name = 'Threshold_model';

%             crowding_trainOn = 'SVHN';
%             crowding_trainOn = 'whiteNoise';
        case 'Grouping',
            x_name = 'Wiggle'; y_name = 'Efficiency';
%             x_name = 'Uncertainty'; y_name = 'Efficiency';
%             x_name = 'Wiggle'; y_name = 'Threshold_model';
%             x_name = 'Wiggle'; y_name = 'maxPctCorrect';

            grouping_trainOn = 'SVHN';
%             grouping_trainOn = 'noWiggle';
%             grouping_trainOn = 'Sloan';
%             grouping_trainOn = 'sameWiggle';

%             grouping_axes = 'log';
            grouping_axes = 'linear';
            
%             grouping_data = 'paper';
%             grouping_data = 'avi';
            grouping_data = {'paper', 'avi'};
%             grouping_data = 'paper';




        case 'Complexity',
%             x_name = 'Complexity';   y_name = 'Efficiency';
            x_name = 'Complexity';   y_name = 'Threshold_model';
%             x_name = 'Complexity'; y_name = 'maxPctCorrect';
            
            complexity_trainOn = 'SVHN'; 
%             complexity_trainOn = 'pinkNoise'; 
%             complexity_trainOn = 'whiteNoise'; 


            complexity_addAviSlope = true;


         case 'TrainingWithNoise',
            x_name = 'SNR';         y_name = 'pctCorrect';
            
        case 'Uncertainty'
            x_name = 'Uncertainty'; y_name = 'Efficiency';
%             x_name = 'Threshold_model'; y_name = 'Efficiency';
            x_name = 'Uncertainty'; y_name = 'maxPctCorrect';
            
    end
%     x_name = 'Complexity';    y_name = 'Threshold_model'; 

%     x_name = 'Uncertainty';    y_name = 'maxPctCorrect';
%     x_name = 'Uncertainty';    y_name = 'Efficiency'; 
%     x_name = 'Uncertainty';    y_name = 'Threshold_model'; 
%     x_name = 'Uncertainty';    y_name = 'Weibull_slope_model'; 
    
%       x_name = 'Complexity';  y_name = 'Efficiency';
    
%     x_name = 'Complexity';   y_name = 'Threshold';
    
%     x_name = 'FontSize';     y_name = 'Efficiency';
%     x_name = 'FiltSize';    
%     x_name = 'PoolSize';    

%     y_name = 'Efficiency';
%     x_name = 'FontSize_and_FiltSize_and_PoolSize_and_ImageSize';
%     x_name = 'FontSize';     
%     y_name = 'Threshold_model';
    
%     x_name = 'SNR'; y_name = 'pctCorrect';
%     x_name = 'SNR'; y_name = 'pctCorrect';
    


    th_pct_correct = switchh(expName, {{'Crowding'}, {'Grouping'}, {'ChannelTuning', 'Complexity', 'TrainingWithNoise', 'Uncertainty'} }, [82, 64, 64]);

    getIdeal = (any(strcmp(expName, {'Complexity', 'Grouping', 'Uncertainty'})) && any(strncmp(y_name, {'Efficiency', 'Threshold'}, 9))) || ...
                (any(strcmp(expName, {'ChannelTuning'})) && strcmp(y_name, 'Threshold_model'));

    %% Multiple Lines on each plot
    

    
%     multiple_lines = '';
    multiple_lines = 'Networks';
%     multiple_lines = 'Opts';
%     multiple_lines = 'TrainingNoise';
%     multiple_lines = 'PoolSizes';
%     multiple_lines = 'FiltSize';
%     multiple_lines = 'PoolingFactor';
%     multiple_lines = 'FilterFactor';
%     multiple_lines = 'TrainingSNRs';
%     multiple_lines = 'Uncertainty';
%     multiple_lines = 'Networks_and_wiggleType';


    
    yvsx_name = sprintf('%s_vs_%s', y_name, x_name);
    %% Multiple Plots

%     multiple_plots = '';
%     multiple_plots = 'Networks';
%     multiple_plots = 'TrainingNoise';
    multiple_plots = 'TrainingFonts';
%     multiple_plots = 'Opts';
%     multiple_plots = 'Uncertainty';
%     multiple_plots = 'ImageSize';
%     multiple_plots = 'FiltSizes';
%     multiple_plots = 'FontSize_and_ImageSize';

%     multiple_plots = 'NoiseType';
%     multiple_plots = 'WiggleType';


%     multiple_networks = '';
%     multiple_networks = 'nStates';
    multiple_networks = 'poolSizes';
    
    
        
    switch expName
        case 'ChannelTuning',
            multiple_lines = 'Networks';
            if strcmp(channels_trainOn, 'SVHN')
                multiple_plots = 'TrainingFonts'; 
            else
                multiple_plots = 'TrainingNoise';
            end
            
            multiple_plots = 'Uncertainty';
%             multiple_plots = 'TrainingFonts'; 
            
        case 'Crowding',

            multiple_plots = 'CrowdingSettings'; 
        case 'Grouping',
            multiple_lines = 'Networks';
%             multiple_lines = 'Networks_and_wiggleType';
%             multiple_lines = 'WiggleType';
%             multiple_plots = 'TrainingNoise';

            multiple_plots = 'Uncertainty';
%             multiple_plots = 'WiggleType';
%             multiple_plots = 'TrainingFonts'; 
%             multiple_plots = '';

        case 'Complexity',
            multiple_lines = 'Networks';
%             multiple_lines = 'Uncertainty';
%             multiple_plots = 'Uncertainty';

            multiple_plots = 'Uncertainty';
%             multiple_plots = 'TrainingFonts'; 
            
        case 'TrainingWithNoise',
            multiple_lines = 'TrainingSNRs';
            multiple_plots = 'Networks';
             
        case 'Uncertainty'
            multiple_lines = 'Networks';
            
    end
    
    
%%   Select Fonts
    
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'GeorgiaUpper', 'Yung', 'Kuenstler'};

% 	allFontNames      = {'Braille', 'Checkers4x4', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};
% 	allFontNames      = {'KuenstlerU', 'KuenstlerUB'};%, 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};

    allFontNames_ext = {'Sloan', 'SloanB', ...
                    'Helvetica', 'HelveticaB', 'HelveticaU', 'HelveticaUB',  ...
                    'Courier', 'CourierB', 'CourierU', 'CourierUB', ...
                    'Bookman', 'BookmanB', 'BookmanU', 'BookmanUB', ...
                    'Yung', 'YungB',     'KuenstlerU', 'KuenstlerUB'};


%     allFontNames_std      = {'Braille', 'Sloan', 'Helvetica', 'Bookman',  'Courier', 'KuenstlerU'};    
    allFontNames_std      = {'Braille', 'Sloan', 'Helvetica', 'Bookman',  'Yung', 'KuenstlerU'};    
    
    allFontStyles = {'Roman', 'Bold', 'Italic', 'BoldItalic'};
    allFontNames_stdFull      = {'Braille', 'Sloan', 'Helvetica', 'Bookman',  'BookmanU', 'Yung', 'Courier', 'KuenstlerU'};    

    
%     allFontNames_std      = allFontNames_stdFull;    

% 	allFontNames      = {'Bookman'};
% 	allFontNames      = {'KuenstlerU'};
% 	allFontNames      = {'Braille'};
%     allFontNames      = {'BookmanU'};
%     allFontNames      = {'Bookman'};

    switch expName
        case 'ChannelTuning',
            allFontNames      = {'Bookman'};
%             allFontNames      = {'Sloan'};
%             allFontNames      = {'Bookman'};
%             allFontNames      = {'Bookman'};
%             allFontNames      = {'Bookman'};
%             allFontNames      = {'Bookman'};

        case 'Crowding'
        	allFontNames      = {'Bookman'};    
                
        case 'Grouping',
        	allFontNames      = {'Snakes'};    
            
        case 'Complexity',
%             allFontNames = allFontNames_std;
%             allFontNames      = {'Armenian', 'Devanagari', 'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung', 'BookmanB', 'BookmanU', 'Hebraica', 'Devanagari', 'Checkers4x4', 'Courier'};
            allFontNames      = {'Armenian', 'Devanagari', 'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung', 'BookmanB', 'Devanagari', 'Courier'};
            
        case 'TrainingWithNoise',
            allFontNames      = {'Bookman'};
%             allFontNames      = {'KuenstlerU'};
            
        case 'Uncertainty',
            allFontNames      = {'Bookman'};
%         allFontNames = {'HelveticaUB'};

%     elseif any(strcmp(x_name, {'NoiseFreq', 'Uncertainty', 'FontSize', 'FiltSize', 'PoolSize'}))
    end    	
        
%       

    if plotIndividualLetterResults
        allFontNames(strcmp(allFontNames, 'Braille') | strcmp(allFontNames, 'Yung') ) = []; %#ok<*UNRCH>
    end

    nFonts = length(allFontNames);
    
    %% SNRs for testing

    switch expName     
        case {'ChannelTuning'}
                
            switch stimType 
                case 'NoisyLetters'
                    allSNRs_test = [-1 : 0.5 : 5];
%                     allSNRs_test = [-1 : 1 : 5];

                case 'NoisyLettersTextureStats',
%                     allSNRs_test = [0, 1, 2, 2.5, 3, 4];
                    allSNRs_test = [-1 : 0.5 : 5];
            end
            
            
        case 'Crowding',
%             allSNRs_test = [0, 1, 2, 3, 4, 5, 6];
%             allSNRs_test = [0, 1, 2, 3, 4, 5];
            allSNRs_test = [0 : 0.5 : 5];

        case 'Grouping',
%             allSNRs_test = [0, 1, 2, 3, 4, 5, 6];
%             allSNRs_test = [-1 : 0.5 : 5];
            allSNRs_test = [0 : 0.5 : 4];

        case 'Complexity'
            allSNRs_test = [0 : 0.5 : 5];

%             allSNRs_test = [0, 0.5, 1, 1.5, 2, 2.5, 3, 4];
                
        case {'TrainingWithNoise'}
            allSNRs_test = [0 : 0.5 : 4];
            
        case 'Uncertainty',
            allSNRs_test = [0 : 0.5 : 5];
            
    end
    
%     if strcmp(x_name, 'NoiseFreq')
%         allSNRs_test = [-1, 0, 0.5,  1, 1.5,  2,  2.5,  3, 4];
%     end
    
    nSNRs_test = length(allSNRs_test);
        
%     sizeStyle_full = switchh(sizeStyle, {'sml', 'med', 'big', 'dflt'}, {'Small', 'Medium', 'Large', 'Default'});
    

    
    trainOnGPU = strcmp(expName, 'ChannelTuning') && false;
        GPU_batchSize = 128;

    if trainOnGPU
        convFunction = 'SpatialConvolutionCUDA';
    else
        convFunction = 'SpatialConvolution';
%             convFunction = 'SpatialConvolutionMap';    
    end

        
    
    %% Networks 
    trainConfig = struct();
    
    switch netType
        case 'ConvNet',
%             snr_train = [1,2,3,4];
%             snr_train = [1,2,3];
%             snr_train = [4];

            %% Number of states
%             allNStates = { {6,15} };

            switch expName
                case 'Grouping',
                    trainConfig = struct('momentum', 0.95);
%                     trainConfig = struct('adaptiveMethod', 'adadelta');
     
                case {'Complexity', 'Uncertainty'} 
                    trainConfig = struct('momentum', 0.95);
                    
                case 'ChannelTuning', 
                    trainConfig = struct('momentum', 0.95);

                case 'Crowding',
                    trainConfig = struct('momentum', 0.95);

%                     trainConfig = [];

            end


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
            
%             allNStates = {  {3, -15}, {6, -15}, {12, -15},  {24, -15},   {6, -30}, {6, -60}, {6, -120},   {16, -30}, {16, -60}, {16, -120}    };
%             allNStates = {   {16, 32, -120}    };

%             allNStates = { {16, -15} };
%             allNStates = { {16, 32, -120} };
%             allNStates = {  {6, -120}, {6, -15} };
            
%             allNStates = { {24, -120} };
%             allNStates = { {6, -120}, {6, 16, -120} };
%             allNStates = { {6, 16, -120}, {6, 16, 120, -84}  };
%             {  {6, -16},  {6, 16, -120}, {6, 16, -240}  }
%             allNStates = { {6, 16, -120}, {6, 16, 120, -84 } };
%             allNStates = { {6, -120},  };
%             allNStates = { {6, 16, -120}, {16, 64, -120} };
%             allNStates = { {16, 64, -120} };
%             allNStates = { {16, 32, -120}, {16, 64, -120} };

%             allNStates = { {6, 16, -120}, {16, 32, -120}, {16, 64, -120} };
%             allNStates = { {16, 32, -120}, {16, 64, -120} };
            allNStates = { {6, 16, -120}, {16, 32, -120} };
%             allNStates = { {16, 32, -120} };
%             allNStates = { {6, 16, -120} };

%             allNStates = { {6, 16, -120}, {6, 16, 120, -84 } };
%             allNStates = { {6, 16, -120}, {24, 16, -120}, {16, 64, -120},  };
%             allNStates = { {16, 64, -120}, };
%             allNStates = { {6, 16, -120} };
%             allNStates = { {24, 64, -120} };
%             allNStates = { {6, 16, -120}, {16, 32, -120}, {16, 32, -240}, {16, 128, -120} };
%             allNStates = { {6, 16, -120}, {16, 32, -240}, {16, 32, -120}, {16, 128, -120},  };
%             allNStates = { {16, 32, -240}  };

%             allNStates_nFCU =  {  {6}, {6, -15}, {6, -30}, {6, -120}, {6, -240},   };
%             allNStates_nFCU =  {  {6, 16}, {6, 16, -30}, {6, 16, -120}  };
%             allNStates_nFCU =  {  {24}, {24, -15}, {24, -120} };
%             allNStates_nFCU =  {  {6}, {6, -15}, {6, -30}, {6, -120}, {6, -240},  {6, 16}, {6, 16, -30}, {6, 16, -120}  };
%             allNStates_nFCU =  {  {6, -240}, {24, -120}, {6, 16, -120} };
%             allNStates_nFCU =  {  {20, 50, -500} };
%             allNStates_nFCU =  {  {12, -60, -60} };
%             
            %% Size of Convolutional Filters
%             filtSizes = [0];
    
%             filtSizes = [5,4];
%             filtSizes = [5,5];
%             allFiltSizes = {2,4,5,10,20};
%             allFiltSizes = {[5,4]};
%             allFiltSizes = {[5,5,5]};
%             allFiltSizes = {5, 10, 20};
%             allFiltSizes = {2, 3, 5, 10};

%             allFiltSizes = {[5, 4], [5 5]};
%             allFiltSizes = {[5 4]};
            allFiltSizes = {[5 5]};
%             
            %% Pooling: 
            doPooling = 1;
            all_doPooling = {0, 1};

            % Pool Size
%             poolSize = [4 2];            
%             allPoolSizes = {[4, 2], [4, 4], [8, 4]};
%             allPoolSizes = {0, [4 2]};
%             allPoolSizes = {4, 0};
%             allPoolSizes = {[4 0], [2 2], [0 0]};
%             allPoolSizes = {0, 2, 4, 8};
            allPoolSizes = {[2 2], [3 2], [4 2]};
%             allPoolSizes = {[2 2], [3 2]};
%             allPoolSizes = {[2, 2]}; 
%             allPoolSizes = {[4, 2]}; 
%             allPoolSizes = {[2 2 0], [2 2 2], [3 3 0]}; 

            % Pool Stride
%             poolStrides = 2;
            poolStrides = 'auto';

            % Pool Type
%             poolType = 2;
%             poolType = 'MAX';

%             allPoolTypes = {1,2,'MAX'};
%             allPoolTypes = {2, 'MAX'};
            allPoolTypes = {'MAX'};
            
%             allPoolTypes = {2};
            
            switch multiple_networks 
                case '',
...                case 'nStates',  allNStates =  { {6,-15}, {6, -120}, {6}, {6, 16},  {6, 16, -30}, {6, 16, -120}, {6, 16, -240}  };
                case 'nStates',  allNStates =  allNStates; %allNStates_nFCU;
                case 'nStates1',  allNStates =  allNStates_X_15;
                case 'nStates2',  allNStates =  allNStates_6_X;
                case 'filtSizes', allFiltSizes = {3, 5, 10}; %  {2,5,10,20};
                case 'poolSizes', 
%                     allPoolSizes = {0, 2, 4, 6, 8, 12}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {4}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {0, 2, 4, 6, 7, 8, 10, 12, 14}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {0, 3, 4, 6}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {[0 0], [2 2], [3 3], [4 4]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {[6]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {0, 2, 4, 6, 8, 12, 16, 20}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {0,2,4}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = { [0, 0], [2, 2], [4, 0], [4, 2] } ;
%                     allPoolSizes = {0, 2, 3, 4, 6, 8}; 
%                     allPoolSizes = {0, 2, 3, 4}; 
%                     allPoolSizes = {2, 3, 4, 6, 8}; 
%                     allPoolSizes = {2, 3, 4, 6}; 
%                     allPoolSizes = {0, 2, 4, 8}; 
%                     allPoolSizes = {0, 2, 4, 6, 8}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
                    
%                     allPoolSizes = {[4 0], [4 2], [4 4], [4 6]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {[4 2], [3 2], [2 2]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {[4, 2], [2 2]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {[2 2], [3 2], [4 2]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {2, 3, 4, 6, 8}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {[4 2]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allPoolSizes = {[2 2 2], [2 2 0], [3 3, 0]}; %[4 2]}; % [0, 4]; %[0,2,4,6,8]; % [0,2,4,6,8];
%                     allFiltSizes = {[5 5], [7,7]};
%                     allFiltSizes = {[5 5]};
%                     allFiltSizes = {[7 7]};
                    
                case 'poolTypes', allPoolTypes = {1,2,'MAX'};

            end
            
            if ~iscell(allPoolSizes)
                allPoolSizes_C = num2cell(allPoolSizes);
            else
                allPoolSizes_C = allPoolSizes;
            end
            
            if iscell(allNStates(1))
                allNStates = cellcell2cellarray(allNStates);
            end
            
            all_nStates_and_filtSizes_and_poolSizes = {};
            do3LayerFilters = true;
            if do3LayerFilters
%                 all_nStates_and_filtSizes_and_poolSizes = {
%                      {[16, 64, 512, -120], [5, 5, 3], [2,2,3]},
%                      {[6, 16, 64, -120],   [5, 3, 3], [2,2,2]},
%                  };
                allNStates = {[6, 16, 64, -120], [16, 64, 512, -120]};
                allFiltSizes = {[5, 5, 3], [5, 3, 3]};
                allPoolSizes_C = {[2,2,2], [2,2,3]};

            
                
%                 allNStates = {[6, 16, 64, -120],  [16, 64, 256, -120],  [16, 128, 512, -240],   [16, 64, 512, -120]};
%                 allNStates = {[16, -120], [16, 64, -120], [16, 64, 512, -120]};
%                 allNStates = {[16, 64, 512, -120]};

%                 allNStates = {[16, -120], [16, -512], [16, -1024], [16, -2048], ...
%                               [16, 64, -120], [16, 64, -512], [16, 64, -1024], [16, 64, -2048], ...
%                               [16, 64, 512, -120], [16, 64, 512, -512], [16, 64, 512, -1024], [16, 64, 512, -2048]};
  


                allNStates = {[16, 64, 512, -120]};
                allFiltSizes = {[5, 5, 3]};
                allPoolSizes_C = {[2,2,2]};

                
                        allFiltSizes = {[5, 5, 3]};
                        allPoolSizes_C = {[2,2,2]};
                
                switch expName
                        case {'Complexity'}
                            
                        allNStates = {[16, -120], [16, -512], [16, -1024], [16, -2048], ...
                                      [16, 64, -120], [16, 64, -512], [16, 64, -1024], [16, 64, -2048], ...
                                      [16, 64, 512, -120], [16, 64, 512, -512], [16, 64, 512, -1024], [16, 64, 512, -2048]};
%                         allNStates = {[16, 64, 512, -120], [16, 64, 512, -512]};
%                         allNStates = {[16, 64, 512, -120]};
                        allNStates = {[16, 64, 512, -120], [16, 64, 512, -512]};
                        case {'Grouping'}
                            
%                         allNStates = {[16, 64, -120], [16, 64, -512], ...
%                                       [16, 64, 512, -120], [16, 64, 512, -512]};
                        allNStates = {[16, 64, 512, -120], [16, 64, 512, -512]};
%                         allNStates = {[16, 64, 512, -120]};
                            
                        case {'Uncertainty'}
                            allNStates = {[16, -512],          [16, -120], ...
                                          [16, 64, -512],      [16, 64, -120], ... 
                                          [16, 64, 512, -512], [16, 64, 512, -120]};
%                             allNStates = { [16, -120], ...
%                                            [16, 64, -120], ... 
%                                            [16, 64, 512, -120]};
%                         allNStates = {[16, 64, 512, -120]};
                            
                        case {'ChannelTuning'}
                            allNStates = {...
                                          [16, 64, 512, -512], [16, 64, 512, -120], ...
                                          [16, 64, -512],      [16, 64, -120], ... 
                                          [16, -512],      [16, -120], ...
                                          };
                        allNStates = {[16, 64, 512, -120], [16, 64, 512, -512]};

                    case {'Crowding'}
                            
%                         allNStates = {[16, 64, 512, -120, [16, 64, 512, -512]};
                        allNStates = {[16, 64, 512, -120], [16, 64, 512, -512]};
%                         allNStates = {[16, 64, 512, -120], [6, 16, 512, -120], };

%                           allNStates = {[16, 128, 512, -240], [16, 64, 512, -120], [16, 64, 256, -120],   [6, 16, 64, -120]   };
                end

%                 allNStates = {[6, 16, -120]};
%                 allFiltSizes = {[5, 5]};
%                 allPoolSizes_C = {[2,2]};
                
            end
            
            allConvNetOptions = struct('netType', 'ConvNet', ...
                                        'tbl_nStates', {allNStates}, ...
                                        ...
                                        ...'filtSizes', filtSizes,...
                                        'tbl_filtSizes', {allFiltSizes}, ...
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
                                        'poolStrides', poolStrides, ... 
                                        ...
                                        'convFunction', convFunction, ...
                                        'trainOnGPU', trainOnGPU, ...
                                        'GPU_batchSize', GPU_batchSize, ...
                                        'trainConfig', trainConfig, ...
                                        'tbl_nStates_and_filtSizes_and_poolSizes', {all_nStates_and_filtSizes_and_poolSizes} ...
                                      );
            allNetworks = expandOptionsToList(allConvNetOptions, {'poolSizes', 'poolType', 'filtSizes', 'nStates' });

            fprintf('\n ---- Using the following networks ----\n');
            displayOptions(allConvNetOptions);
            
            3;
        case 'MLP',
%             snr_train = [2 3 4 5];
            multiple_networks = 'HiddenUnits';
%             snr_train = [6];
%             snr_train = [1,2,3,4];

%            allNHiddenUnits = { {6}, {12}, {24}, {48}, {96},   {6, 16}, {6, 32}, {6, 64},   {12, 16}, {12, 32}, {12, 64} };
%            allNHiddenUnits = { {120} };
%            allNHiddenUnits = { {}, {120} };
%            allNHiddenUnits = { {512, 512}, {150, 150}, {128, 128}, {120, 120}, {64, 64}, {32, 32}, {120}, {64}, {32}  };
%            allNHiddenUnits = { {120}  };
           allNHiddenUnits = { {120}, {120, 120}  };
%            allNHiddenUnits = { {120}, {120, 120}, {512, 512}  };
%            allNHiddenUnits = { {512, 512}, {150, 150}, {128, 128},{120, 120}, {64, 64}, {32, 32},  {120}, {64}, {32},  };
%            allNHiddenUnits = { {}, {30}, {120}, {240}  };
%            allNHiddenUnits = { {}, {4}, {8}, {15}, {30}, {60}, {120} };
%            allNHiddenUnits = { {5}, {10}, {15}, {30}, {60}, {120}, {} };
           allMLPoptions = struct('netType', 'MLP', ...
                                  'tbl_nHiddenUnits', {allNHiddenUnits} ...
                                  );
            allNetworks = expandOptionsToList(allMLPoptions);
    end

%     allNetworks = [num2cell(allNetworks), struct('netType', 'MLP', 'nHiddenUnits', 240)];
    
    
    nNetworks = length(allNetworks);
    
    %% Options (LetterOpts)

    %% 1. Uncertainty: (multiple xs/ys/oris)
  

    allOriXYSets_1pos = struct('oris', [0], 'xs', [0], 'ys', [0]);
    
    allOriXYSets_1pos_styles = struct('oris', [0], 'xs', [0], 'ys', [0], 'styles', {allFontStyles} );

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

            
    usePositionalUncertainty = 1;
    useFontUncertainty = 1;
    useFontStyleUncertainty = 1;
        
    if usePositionalUncertainty
        USet = struct('oris', [-10:2:10], 'xs', [0:2:10], 'ys', [0:2:16]);
    else
        USet = struct('oris', [0], 'xs', [0], 'ys', [0]);
    end
    
    if useFontUncertainty
        USet.fonts = allFontNames_stdFull;
    end
    
    if useFontStyleUncertainty
        USet.styles = allFontStyles;
    end
    
    mult_oris_large_48_k14 = [-10:2:10];
    mult_xs_large_48_k14 = [0:2:10];
    mult_ys_large_48_k14 = [0:2:16];
    
    allOris = mult_oris_large_48_k14;
    allXs = mult_xs_large_48_k14;
    allYs = mult_ys_large_48_k14;
    
    Uset_no = struct('oris', [0], 'xs', [0], 'ys', [0]);
    
    Uset_pos = struct('oris', allOris, 'xs', allXs, 'ys', allYs);
    Uset_fonts = struct('oris', [0], 'xs', [0], 'ys', [0], 'fonts', {allFontNames_stdFull});
    Uset_styles = struct('oris', [0], 'xs', [0], 'ys', [0], 'styles', {allFontStyles});
    
    Uset_pos_styles = struct('oris', allOris, 'xs', allXs, 'ys', allYs, 'styles', {allFontStyles});
    Uset_pos_fonts  = struct('oris', allOris, 'xs', allXs, 'ys', allYs, 'fonts', {allFontNames_stdFull});
    Uset_styles_fonts = struct('oris', [0], 'xs', [0], 'ys', [0], 'styles', {allFontStyles}, 'fonts', {allFontNames_stdFull});
    
    Uset_pos_styles_fonts = struct('oris', allOris, 'xs', allXs, 'ys', allYs, 'styles', {allFontStyles}, 'fonts', {allFontNames_stdFull});

    allUncertaintySets = { Uset_no, ...
                           Uset_pos, Uset_styles, Uset_fonts, ...
                           Uset_pos_styles, Uset_pos_fonts, Uset_styles_fonts, ...
                           Uset_pos_styles_fonts };
                           
     allUncertaintySets = {Uset_no};
%     allUncertaintySets = { Uset_1pos };
%     allUncertaintySets = { Uset_fonts };

    
    xlabel_suffix = '';
    %%
%     uncertainty = 'span_2Let_mult_n';
%     uncertainty = '4_xpos_mult_spacing';
%     uncertainty = '9_xpos_mult_spacing';
%     uncertainty = '2_xpos_mult_spacing';
    uncertainty = 'font_style_sets';

%     uncertainty = 'fixed_spacing_mult_n';
    if strcmp(x_name, 'Uncertainty') && 0 
        
        fontWidth = 25;
        allSpacings = [1,2,3,4,5,6:2:10,14:4:22];
                allSpacings = setdiff(allSpacings, [5, 8 14]);

%         allSpacings = [1,2,3,4, 8, 16, 24];
        %% span is constant (2 letters wide = 50 pixels): vary spacing
        allSpacings_span_2let_v_spc_func = @(nLet) arrayfun(@(spc) [0 : spc : nLet*fontWidth], allSpacings, 'un', 0);
        
        allSpacings_span_2let_v_spc = allSpacings_span_2let_v_spc_func(2);
        allSpacings_span_2let_v_spc{end} = allSpacings_span_2let_v_spc{end}(1:2);

        %% number of positions is constant (2 or 3): vary spacing:
        maxSpacing = 128;
        allPositions_v_spacing_func = @(nPos) arrayfun(@(d) [0 : d : d*(nPos-1)], allSpacings, 'un', 0);

        allPositions_v_spacing_2pos = allPositions_v_spacing_func(2);
        allPositions_v_spacing_3pos = allPositions_v_spacing_func(3);
        allPositions_v_spacing_4pos = allPositions_v_spacing_func(4);
        allPositions_v_spacing_9pos = allPositions_v_spacing_func(9);  allPositions_v_spacing_9pos = allPositions_v_spacing_9pos(  cellfun(@max, allPositions_v_spacing_9pos) <= maxSpacing);

        %% spacing is constant : vary number of positions
        
        % try this later

        %%
%         allOriXYSets_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', [{0}, allSpacings_span_2let_v_spc, allPositions_v_spacing_2pos]);

        switch uncertainty, 
            case '2_xpos_mult_spacing',   allXs = allPositions_v_spacing_2pos; 
                uncertainty_xlabel_type = 'spacing'; xlabel_suffix = ' (Spacing between 2 Letters)';
            case '3_xpos_mult_spacing',   allXs = allPositions_v_spacing_3pos;
                uncertainty_xlabel_type = 'spacing'; xlabel_suffix = ' (Spacing between 3 Letters)';
            case '4_xpos_mult_spacing',   allXs = allPositions_v_spacing_4pos;
                uncertainty_xlabel_type = 'spacing'; xlabel_suffix = ' (Spacing between 4 Letters)';
            case '9_xpos_mult_spacing',   allXs = allPositions_v_spacing_9pos;
                uncertainty_xlabel_type = 'spacing'; xlabel_suffix = ' (Spacing between 9 Letters)';
            case 'span_2Let_mult_n',      allXs = fliplr(allSpacings_span_2let_v_spc);
                uncertainty_xlabel_type = 'letterOpt'; xlabel_suffix = ' (Number of positions in Fixed Area)';
            case 'fixed_spacing_mult_n',  allXs = {[0, 25], [0, 25, 50], [0, 25, 50, 75]};
                uncertainty_xlabel_type = 'nX'; xlabel_suffix = ' (Number of positions (1 letter Spacing))';
            case 'font_style_sets', 
                uncertainty_xlabel_type = 'sets'; xlabel_suffix = ' Stimulus Set';
        end
        
        %%
        if strcmp(uncertainty, 'font_style_sets')
            allOriXYSets_large = struct('oris', [-10:2:10], 'xs', [0:5], 'ys', [0:11] );
            allOriXYSets_med1 = struct('oris', [0], 'xs', [0:5], 'ys', [0:11] );
            allOriXYSets_med2 = struct('oris', [-10:2:10], 'xs', [0], 'ys', [0] );
            allOriXYSets_test1 = struct('oris', [-2:2:2], 'xs', [-2,2], 'ys', [-2,2] );
            allOriXYSets_1pos = struct('oris', 0, 'xs', 0, 'ys', 0 );



            fontSet_BkmU = struct('fonts', {'BookmanU'});
            fontSet_BkmU_rBIJ = struct('fonts', {'BookmanU'}, 'styles', {allFontStyles});
            fontSet_MRHs_rBIJ = struct('fonts', {{'BookmanU', 'Sloan', 'HelveticaU', 'CourierU'}}, 'styles', {allFontStyles});

            fontNames_use = {fontSet_BkmU, fontSet_BkmU_rBIJ, fontSet_MRHs_rBIJ};


            allUncertaintySets = {  mergeStructs(fontSet_BkmU, allOriXYSets_1pos,      struct('n', 24000, 'name', 'No Uncertainty') ), ...
                                    mergeStructs(fontSet_BkmU, allOriXYSets_med2,        struct('n', 24000, 'name', '11 Orientations') ), ...
                                    mergeStructs(fontSet_BkmU, allOriXYSets_med1,        struct('n', 24000, 'name', '72 X-Y Positions') ), ...
                                    mergeStructs(fontSet_BkmU, allOriXYSets_large,       struct('n', 24000, 'name', '11 Ori & 72 XY') ), ...
                                    mergeStructs(fontSet_BkmU_rBIJ, allOriXYSets_large,  struct('n', 24000, 'name', ' x Bold/Italic') ), ...
                                    mergeStructs(fontSet_MRHs_rBIJ, allOriXYSets_large,  struct('n', 24000, 'name', ' x 4 Fonts') ) ...
                                 };
%             allUncertaintySets = {  mergeStructs(fontSet_MRHs_rBIJ, allOriXYSets_large) };
            
             nXs = length(allUncertaintySets);
             uncertainty_labels = cell(1, nXs);
             uncertainty_x_vals = zeros(1, nXs);
%%
             for xi = 1:nXs
                 %%
                 set_i = allUncertaintySets{xi};
                 uncertainty_x_vals(xi) = xi;
                 font_str = abbrevFontStyleNames(set_i);
                 oxy_str = getOriXYStr(set_i, 1);
                 if isfield(set_i, 'name')
                    uncertainty_labels{xi} = set_i.name; 
                 else
                    uncertainty_labels{xi} = [font_str '_' oxy_str];
                 end
                 3;

             end
            
        else

            
            allXs = [[0], allXs];
            allYs = [0]; allOris = [0];
            allUncertaintySets = num2cell(struct('xs', allXs, 'oris', allOris, 'ys', allYs));




            nXs = length(allXs);
            uncertainty_labels = cell(1, nXs);
            uncertainty_x_vals = zeros(1, nXs);
            switch uncertainty_xlabel_type
                case 'spacing'
                    for xi = 1:nXs
                        if length(allXs{xi}) == 1
                            uncertainty_x_vals(xi) = 0;
                        else
                            uncertainty_x_vals(xi) = diff(allXs{xi}(1:2));
                        end
                        uncertainty_labels{xi} = sprintf('%d', uncertainty_x_vals(xi));
                    end

                case 'nX',
                    for xi = 1:nXs
                        uncertainty_x_vals(xi) = length(allXs{xi});
                        uncertainty_labels{xi} = sprintf('%d', uncertainty_x_vals(xi));
                    end
                case 'letterOpt', 
                    for xi = 1:nXs
                        uncertainty_x_vals(xi) = length(allXs{xi});
                        uncertainty_labels{xi} = sprintf('%d', uncertainty_x_vals(xi));
    %                     uncertainty_labels{xi} = '';
                    end

            end
        end
    end

    
    
    %% Blur
    
%     allBlurStd_C = {0, 1, 2, 3};
    allBlurStd_C = {0};
%     allBlurStd_C = {2};

    %% Size
%     all_sizeStyles_opt_C = all_sizeStyles_C;
%     all_sizeStyles_C = {sizeStyle};
%     if strcmp(x_name, 'FontSize')
%         all_sizeStyles_C = allFontSizes;
        
%     end
    
    
    %% Noise Band
    
%     allNoiseFreqs = [0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13];
%     allNoiseFreqs_ext = [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];
%     allNoiseFreqs = [0.5, 0.71, 1, 1.41, 2, 2.83, 4, 5.66, 8, 11.31, 16];  


    allNoiseFreqs = [0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.44, 16]; % roundToNearest(2.^[-1:.25:4], 0.01)
%     allNoiseFreqs = [0.5, 1, 1.41, 2, 2.83, 4, 8]; % roundToNearest(2.^[-1:.25:4], 0.01)
    if noise_selectFrequencies
        allNoiseFreqs = [1, 2, 4];
    end

%     allfexps = [1, 1.5, 2];
%     allfexps = [1, 1.5, 1.6, 1.7];
%     allfexps = [1, 1.7];
%     allfexps = [1, 1.6, 2.0];
    allfexps = [1, 1.2, 1.4, 1.6, 1.8, 2.0];
%     allfexps = [1.6, 1.7];

%     allfexp_stds = [0, 0.2, 0.3];
    allfexps_stds = ones(size(allfexps))*[0.2];
%     allfexp_std = [0, 0.2, 0.3];
    pinkWhiteRatios = [0, 0.5, 1, 2, inf];

    applyGainFactor_band = true;
    applyGainFactor_hiLo = false;
    applyGainFactor_pink = true;
    

    bandNoiseFilters   = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f, 'applyFourierMaskGainFactor', applyGainFactor_band), allNoiseFreqs, 'un', 0);
    hiPassNoiseFilters = arrayfun(@(f) struct('filterType', 'hi', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyGainFactor_hiLo), allNoiseFreqs, 'un', 0);
    loPassNoiseFilters = arrayfun(@(f) struct('filterType', 'lo', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyGainFactor_hiLo), allNoiseFreqs, 'un', 0);
    
    pinkNoiseFilters          = arrayfun(@(f) struct('filterType', '1/f',       'f_exp', f, 'applyFourierMaskGainFactor', applyGainFactor_pink), allfexps, 'un', 0);
    pinkPlusWhiteNoiseFilters = arrayfun(@(f, r) struct('filterType', '1/fPwhite', 'f_exp', f, 'applyFourierMaskGainFactor', applyGainFactor_pink, 'ratio', r), ones(1, length(pinkWhiteRatios)), pinkWhiteRatios, 'un', 0); %#ok<NASGU>
    pinkOrWhiteNoiseFilters   = arrayfun(@(f, r) struct('filterType', '1/fOwhite', 'f_exp', f, 'applyFourierMaskGainFactor', applyGainFactor_pink, 'ratio', r), ones(1, length(pinkWhiteRatios)), pinkWhiteRatios, 'un', 0); %#ok<NASGU>
    whiteNoiseFilter = {struct('filterType', 'white')};

    pinkStdNoiseFilters          = arrayfun(@(f, f_std) struct('filterType', '1/f',  'f_exp', f, 'f_exp_std', f_std, 'applyFourierMaskGainFactor', applyGainFactor_pink), allfexps, allfexps_stds, 'un', 0);
    
    
    switch expName
        case 'ChannelTuning',
            
%             allTrainingNoise = [whiteNoiseFilter, pinkNoiseFilters];
%             allTrainingNoise = [pinkNoiseFilters, whiteNoiseFilter];
%             allTrainingNoise = [pinkNoiseFilters, whiteNoiseFilter];
            
            allTrainingNoise = pinkNoiseFilters;
%             allTrainingNoise = pinkStdNoiseFilters;
%             allTrainingNoise = pinkPlusWhiteNoiseFilters;
%             allTrainingNoise = [whiteNoiseFilter];
            testNoiseFilter = whiteNoiseFilter{1}; % will change them all during loop
            
            if strcmp(channels_trainOn, 'SVHN')
                allTrainingNoise = {'same'};
            end
          
            
        case 'Crowding',
            allTrainingNoise = [whiteNoiseFilter];
            testNoiseFilter = whiteNoiseFilter{1};
%             testNoiseFilter = pinkNoiseFilters{2};
%             allTrainingNoise = [pinkNoiseFilters(2)];

        case 'Grouping',
            testNoiseFilter = whiteNoiseFilter{1};
%             allTrainingNoise = [whiteNoiseFilter];
            if strcmp(grouping_trainOn, 'SVHN')
                allTrainingNoise = [whiteNoiseFilter];
            elseif strcmp(grouping_trainOn, 'pinkNoise')
                allTrainingNoise = [pinkNoiseFilters, whiteNoiseFilter];
            elseif strcmp(grouping_trainOn, 'sameWiggle')
                allTrainingNoise = [whiteNoiseFilter];
%                 allTrainingNoise = [pinkNoiseFilters];
            end
            
%             allTrainingNoise = [whiteNoiseFilter];
%                 allTrainingNoise = [pinkNoiseFilters, whiteNoiseFilter];
                
            

        case 'Complexity',
            if strcmp(complexity_trainOn, 'SVHN')
                allTrainingNoise = [whiteNoiseFilter];
            elseif strcmp(complexity_trainOn, 'pinkNoise')
                allTrainingNoise = [pinkNoiseFilters, whiteNoiseFilter];
            elseif strcmp(complexity_trainOn, 'whiteNoise')
                allTrainingNoise = [whiteNoiseFilter];
            end
            
%             allTrainingNoise = [whiteNoiseFilter  ];
            testNoiseFilter = whiteNoiseFilter{1};
            
            if strcmp(complexity_trainOn, 'SVHN');
                allTrainingNoise = {'same'};        
            end
            
            
        otherwise,
            allTrainingNoise = [whiteNoiseFilter];
            testNoiseFilter = whiteNoiseFilter{1};
            
    end

    
    %% Wiggle Settings
    
    if strcmp(expName, 'Grouping')
        %%
        switch grouping_axes
            case 'log',    xtick_wiggle0 = 8;
            case 'linear', xtick_wiggle0 = 0;
        end
        
%         wiggleType = 'orientation';
        wiggleType = 'offset';
%         wiggleType = 'phase';

        dWiggle = 45;
%         dWiggle = 10;
        allWiggleTypes = {'orientation', 'offset', 'phase'};
%         allWiggleTypes = {'orientation', 'offset'};

        allOriWiggles = [0, dWiggle:dWiggle:90];
        allOffsetWiggles = [0, dWiggle:dWiggle:60];
        allPhaseWiggles = [0, 1];
        allWiggles_S_ori = struct('orientation', allOriWiggles);
        allWiggles_S_offset = struct('offset', allOffsetWiggles);
        allWiggles_S_phase = struct('phase', allPhaseWiggles);
    
        switch wiggleType
            case 'orientation',     allWiggles_S = allWiggles_S_ori;
            case 'offset',          allWiggles_S = allWiggles_S_offset;
            case 'phase',           allWiggles_S = allWiggles_S_phase;
        end
        allWiggles = getWiggleList(allWiggles_S);
        
        allWiggles_C = {getWiggleList(allWiggles_S_ori), getWiggleList(allWiggles_S_offset), getWiggleList(allWiggles_S_phase)};
%%
%         allWiggleTypes = {'orientation', 'offset'};
%         allWiggles = 
%         
%         allWiggles_S = 
        nWiggleTypes = length(allWiggleTypes);

        
    end    
    

    %% Image Size
    autoImageSize = 0;

    
%     all_imageSizes_C = {[40,80]};

    %% 
%     trainingNoise = 'white';
    
%     all_snr_train = {[4], [1 2 3 4]};
    
    
    
%     multiple_opts = 'statsUse';
%     switch multiple_opts
% %         case 'statsUse', allStatsUse = {'V1', 'V1x', 'V2'};
%         case 'statsUse', 
%         
%     end
%     allRetrainFromLayers = {5, 7};
    allRetrainFromLayers = {''};
    


    nClasses = 26;
    guessRate = 1/nClasses;
    
    fontName_use = allFontNames{1};
    
    all_nLetters_C = {1};
%     all_sizeStyles_C = {sizeStyle};
    all_trainTargetPosition_C = {'all'};
    all_testTargetPosition_C = {1};
    all_snr_train_C = {[1 : 0.5 : 3]};
%     all_snr_train_C = {[1 : 1 : 3]};
%     all_snr_train_C = {[1 2 3]};
    all_XRanges_C = {0};
    all_logDNR_C = {2};
    allDistractSpacings_pix = nan;
    tbl_trainingNoise = allTrainingNoise(1);
    doCrowdedTextureStats = 0;
    trainOnIndividualPositions = false;
    retrainOnCombinedPositions = false;
    crowdingSettings = [];
    fullFontSet = 'same';
    fullStyleSet = 'same';
    fullWiggleSet = 'same';
    trainingFonts = 'same';
    trainingImageSize = 'same';
    trainingOriXY = 'same';

    trainingWiggle = 'same';
    textureStatOpts_C = {};
    overFeatOpts_C = {};
%     niceStrFields = {'trainingNoise', 'testNoise'};
    allTextureStatsUse = {'V2'};
%     niceStrFields = {'nStates', 'poolSizes', 'poolStrides', 'poolType', 'uncertainty'};
%     niceStrFields = {'poolSizes', 'poolStrides', 'poolType', 'filtSize', 'nStates'};
    niceStrFields = {'nStates', 'poolSizes', 'poolType', 'filtSize', 'textureParams'};
%     niceStrFields = {'poolSizes', 'filtSize', 'nStates'};
    all_imageSizes_C = {[32, 32]};
    autoImageSize = 0;
    classifierForEachFont = false;
    
    doTextureStatistics = strcmp(modelName, 'Texture');
    allNoiseTypes = {'band', 'lo', 'hi'};
    
    noiseType = 'band';
%     GPU_batchSize = 128;

    allTrainingFonts = {'Bookman'};

    uncertainty_xpos = 'index';

    % *** image size; texture stats
    switch expName
        case 'ChannelTuning', 
%             sizeStyle = 'k40';
%             sizeStyle = 'k32'; imageSize = [64 64];
%             sizeStyle = 'k15'; imageSize = [32 32];
%             sizeStyle = 'k15'; imageSize = [30 30];
%             sizeStyle = 'k30'; imageSize = [64 64];
%             sizeStyle = 'k24'; imageSize = [64 64];
%             sizeStyle = 'k20'; imageSize = [36 36];
%             sizeStyle = 'k30'; imageSize = [45 45];
%             sizeStyle = 'k15'; imageSize = [45 45];
%             sizeStyle = 'k16';
            sizeStyle = 'k36'; imageSize = [64 64];

            fontName_use = 'Bookman';
%             fontName_use = 'KuenstlerU';
%             fontName_use = 'Braille';
%             fontName_use = 'Sloan';
%             fontName_use = 'Helvetica';
%             fontName_use = 'Yung';
            all_sizeStyles_C = {sizeStyle};            

             if strcmp(channels_trainOn, 'SVHN')
%                  trainingFonts = {'SVHN'};
                 if strcmp(modelName, 'ConvNet')
                     svhn_imageSize = [32 32];
    %                  svhn_imageSize = [64 64];
    %                  svhn_imageSize = imageSize;
                     trainingFonts_no_lcn = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', false));
                     trainingFonts_lcn    = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', true));
                     trainingFonts = trainingFonts_no_lcn;

                     allTrainingFonts = {trainingFonts_no_lcn, trainingFonts_lcn};
                 elseif strcmp(modelName, 'Texture')
                     svhn_imageSize = [64, 64];

                     all_realData_opts = expandOptionsToList(struct('tbl_localContrastNorm', {{false, true}}, ...
                                                                'tbl_scaleMethod', {{'tile', 'pad', 'fourier'}}, ...
                                                                'imageSize', svhn_imageSize, ...
                                                                 'globalNorm', true'));
                     allTrainingFonts = arrayfun(@(svhn_opt) struct('fonts', 'SVHN', 'realData_opts', svhn_opt), all_realData_opts, 'un', 0);
                    trainingFonts = allTrainingFonts{1};
                     
                     
                 end
                     
                     
                 trainingImageSize = svhn_imageSize;
                 if doTextureStatistics
%                      allRetrainFromLayers = {'linear-2'};
                     allRetrainFromLayers = {'classifier'};
                 else
                     allRetrainFromLayers = {'linear'};
                 end
%                  allRetrainFromLayers = {'classifier'};
                 tbl_trainingNoise = {'same'};
             else
%                  allRetrainFromLayers = {'classifier'};
                 allRetrainFromLayers = {''};
             end

%                  all_snr_train_C = {[0 1 2]};
%                  all_snr_train_C = {[-1, 0, 1, 2]};

          

            autoImageSize = 0;
%             switch sizeStyle
%                 case 'k16', imageSize = [32,32];
%                 case 'k32', imageSize = [64,64];
%             end
            

            if doConvNet                
%                 all_snr_train_C = {[1 : 0.5 : 3]}; 
            elseif doTextureStatistics
%                  all_snr_train_C = {[2 3 4 5]};
                 
                 
                 Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 7; 
                 textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt};
                 
                 allTextureStatsUse = {'V2'};
            end
            all_imageSizes_C = {imageSize};
            
            oriXYSet_6x5y21o = struct('oris', [-20:2:20], 'xs', [0:2:10], 'ys', [0:2:8] );  %Nx = 20
            oriXYSet_1pos = struct('oris', 0, 'xs', 0, 'ys', 0 );
            oriXYSet_4x4y7o = struct('oris', [-15:5:15], 'xs', [0:3:9], 'ys', [0:3:9] );  % for complexity
            oriXYSet_6x6y11o = struct('oris', [-15:3:15], 'xs', [0:2:10], 'ys', [0:2:10] );  % for complexity

            oriXYSet_2x2y3o = struct('oris', [-5:5:5], 'xs', [0, 5], 'ys', [0, 5] );  % for complexity


            
            
            
%             allUncertaintySets = {oriXYSet_6x5y21o};
%             allUncertaintySets = {oriXYSet_2x2y3o};
            allUncertaintySets = {oriXYSet_1pos};
            
%             allUncertaintySets = {oriXYSet_4x4y7o};
%             allUncertaintySets = {oriXYSet_6x6y11o};



          oriXYSet_2x4y_d4 = struct('oris', [0], 'xs', [0, 4], 'ys', [0, 4, 8, 12] );  % for complexity
            oriXYSet_2x4y_d2 = struct('oris', [0], 'xs', [0, 2], 'ys', [0, 2, 4, 6] );  % for complexity
            oriXYSet_2x4y_d1 = struct('oris', [0], 'xs', [0, 1], 'ys', [0, 1, 2, 3] );  % for complexity
            oriXYSet_3x7y_d2 = struct('oris', [0], 'xs', [0:2:4], 'ys', [0 : 2 : 12] );  % for complexity
            oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [0:1:4], 'ys', [0 : 1 : 12] );  % for complexity

            oriXYSet_21o_d2 = struct('oris', [-20:2:20], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_21o_d2_2x4y_d4 = struct('oris', [-20:2:20], 'xs', [0, 4], 'ys', [0, 4, 8, 12] );  % for complexity
            oriXYSet_21o_d2_2x4y_d2 = struct('oris', [-20:2:20], 'xs', [0, 2], 'ys', [0, 2, 4, 6] );  % for complexity
            oriXYSet_21o_d2_3x7y_d2 = struct('oris', [-20:2:20], 'xs', [0:2:4], 'ys', [0 : 2 : 12] );  % for complexity
            oriXYSet_21o_d2_5x13y_d1 = struct('oris', [-20:2:20], 'xs', [0:1:4], 'ys', [0 : 1 : 12] );  % for complexity

%                             allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_2x4y_d2, oriXYSet_2x4y_d1, oriXYSet_3x7y_d2, oriXYSet_5x13y_d1, ...
%                             oriXYSet_21o_d2, oriXYSet_21o_d2_2x4y_d4, oriXYSet_21o_d2_2x4y_d2, oriXYSet_21o_d2_3x7y_d2, oriXYSet_21o_d2_5x13y_d1};

            allUncertaintySets = { oriXYSet_1pos, oriXYSet_21o_d2, ...
                                                  oriXYSet_2x4y_d4, oriXYSet_21o_d2_2x4y_d4,    ...
                                                  oriXYSet_2x4y_d2, oriXYSet_21o_d2_2x4y_d2,   ...
                                                  oriXYSet_2x4y_d1, ...
                                                  oriXYSet_3x7y_d2, oriXYSet_21o_d2_3x7y_d2, ...
                                                  oriXYSet_5x13y_d1, oriXYSet_21o_d2_5x13y_d1, ...
                                                  };
                                              
              oriXYSet_2x2y_d1 = struct('oris', [0], 'xs', [0 : 1 ], 'ys', [0 : 1 ] );  % for complexity 2*2 = 4
              oriXYSet_3x3y_d1 = struct('oris', [0], 'xs', [0 : 2 ], 'ys', [0 : 2 ] );  % for complexity 3*3 = 9
              oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for complexity 4*4 = 16
              oriXYSet_5x6y_d1 = struct('oris', [0], 'xs', [0 : 4 ], 'ys', [0 : 5 ] );  % for complexity 5*6 = 32
              oriXYSet_8x8y_d1 = struct('oris', [0], 'xs', [0 : 7 ], 'ys', [0 : 7 ] );  % for complexity 8*8 = 64
              oriXYSet_13x11y_d1 = struct('oris', [0], 'xs', [0 : 1 : 12], 'ys', [0 : 1 : 10] );  % for complexity 13*11 = 143

              allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x2y_d1,    oriXYSet_3x3y_d1, oriXYSet_4x4y_d1, oriXYSet_5x6y_d1, oriXYSet_8x8y_d1, oriXYSet_13x11y_d1};
%               allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x2y_d1,    oriXYSet_4x4y_d1 };


                oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
                oriXYSet_4x4y_d1_3o_d5 = struct('oris', [-5:5:5], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
                oriXYSet_4x4y_d1_7o_d5 = struct('oris', [-15:5:15], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
                oriXYSet_4x4y_d1_11o_d1 = struct('oris', [-5:1:5], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16

%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_4x4y_d1, oriXYSet_4x4y_d1_3o_d5, oriXYSet_4x4y_d1_7o_d5, oriXYSet_4x4y_d1_11o_d1 };
%                 allUncertaintySets = { oriXYSet_4x4y_d1_11o_d1 };
%                   allUncertaintySets = { oriXYSet_1pos };
                allUncertaintySets = {  oriXYSet_4x4y_d1_11o_d1 };


              if doTextureStatistics
                  
                  allUncertaintySets = { oriXYSet_1pos };
              end
            %              imageSize = [45,45];
             
%             allRetrainFromLayers = {'linear'};
%             allRetrainFromLayers = {'classifier'};
%             allRetrainFromLayers = {''};
            
        
        case 'Grouping',
%             sizeStyle = 55; imageSize = [96, 96];
%             sizeStyle = 'k32'; imageSize = [64, 64];
            sizeStyle = 'k32'; imageSize = [96, 96];
            
%             sizeStyle = 'k48'; imageSize = [96, 96];
%             sizeStyle = 'k32'; imageSize = [40 40];
%             sizeStyle = 'k27'; imageSize = [64, 64];
            all_sizeStyles_C = {sizeStyle};

            autoImageSize = 0;
%             imageSize = [64, 64];
%             imageSize = [96, 96];

            all_imageSizes_C = {imageSize};
            
%             allRetrainFromLayers = {''};            
%            
%             if doConvNet
%                                 
%             elseif doTextureStatistics
%                 Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 7; 
%                 textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt};
%                 allTextureStatsUse = {'V2'};
%             end
%             
            oriXYSet_1pos = struct('oris', 0, 'xs', 0, 'ys', 0 );
            oriXYSets_3x3y = struct('oris', 0, 'xs', [-1,0,1], 'ys', [-1,0,1]);
            oriXYSets_5x5y = struct('oris', 0, 'xs', [-2:2], 'ys', [-2:2]);
            
            oriXYSets_9x9y7o = struct('oris', [-15:5:15], 'xs', [0:3:24], 'ys', [0:3:24]);
            oriXYSet_10x10y11o = struct('oris', [-20:4:20], 'xs', [0:2:18], 'ys', [0:2:18]);
            
            oriXYSet_10x10y21o = struct('oris', [-20:2:20], 'xs', [0:2:18], 'ys', [0:2:18]);
            oriXYSet_5x5y11o = struct('oris', [-20:4:20], 'xs', [0:4:16], 'ys', [0:4:16]);
            
            oriXYSet_1x1y21o = struct('oris', [-20:2:20], 'xs', [0], 'ys', [0]);
            oriXYSet_19x19y21o = struct('oris', [-20:2:20], 'xs', [0:1:18], 'ys', [0:1:18]);
            oriXYSet_30x30y21o = struct('oris', [-20:2:20], 'xs', [0:1:29], 'ys', [0:1:29]); % for 96x96        
            
            oriXYSet_5x5y11o_d2 = struct('oris', [-10:2:10], 'xs', [0:2:8], 'ys', [0:2:8]);
            oriXYSet_41o  = struct('oris', [-20:1:20], 'xs', [0], 'ys', [0]);
            oriXYSet_7x7y = struct('oris', [0], 'xs', [0:2:12], 'ys', [0:2:12]);
            
%             allUncertaintySets = { oriXYSets_5x5y };
%             allUncertaintySets = { oriXYSets_3x3y };
%             allUncertaintySets = { oriXYSets_9x9y7o };
%             allUncertaintySets = { oriXYSet_10x10y11o };
%             allUncertaintySets = { oriXYSet_10x10y21o };

%             allUncertaintySets = { oriXYSets_1pos };
%             allUncertaintySets = { oriXYSet_5x5y11o };
%             allUncertaintySets = { oriXYSet_10x10y21o };
%             allUncertaintySets = { oriXYSet_1x1y21o };

            allUncertaintySets = { oriXYSet_1pos,  oriXYSet_5x5y11o_d2, oriXYSet_5x5y11o};
%             allUncertaintySets = { oriXYSet_41o };
%             allUncertaintySets = { oriXYSet_7x7y };
            
            
%             allUncertaintySets = { oriXYSet_30x30y21o };
%             allUncertaintySets = { oriXYSet_19x19y21o };
            

           
            oriXYSet_3o_d5 = struct('oris', [-5,0,5], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_21o_d2 = struct('oris', [-20:2:20], 'xs', [0], 'ys', [0] );  % for complexity            
            oriXYSet_13o_d5 = struct('oris', [-30:5:30], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_25o_d5 = struct('oris', [-60:5:60], 'xs', [0], 'ys', [0] );  % for complexity
          

            allUncertaintySets = {oriXYSet_1pos,  oriXYSet_3o_d5, oriXYSet_13o_d5, oriXYSet_21o_d2,   oriXYSet_25o_d5 }; % for texture

            
            
                   oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_3o_d5       = struct('oris', [-5:5:5], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_7o_d5       = struct('oris', [-15:5:15], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_21o_d2       = struct('oris', [-20:2:20], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_11o_d1       = struct('oris', [-5:1:5], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_31o_d1       = struct('oris', [-15:1:15], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484

                   
                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_15x19y_d1_3o_d5, oriXYSet_15x19y_d1_7o_d5, ...
                                           oriXYSet_15x19y_d1_21o_d2, oriXYSet_15x19y_d1_11o_d1, oriXYSet_15x19y_d1_31o_d1};
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_15x19y_d1_3o_d5, oriXYSet_15x19y_d1_7o_d5, ...
%                                            oriXYSet_15x19y_d1_21o_d2, oriXYSet_15x19y_d1_11o_d1, oriXYSet_15x19y_d1_31o_d1};
%             
% 
%                    oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
%                    oriXYSet_22x26y_d1             = struct('oris', [0], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
%                    oriXYSet_22x26y_d1_21o_d1      = struct('oris', [-10:1:10], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
%                    oriXYSet_22x26y_d1_41o_d1      = struct('oris', [-20:1:20], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
%                    
%                     allUncertaintySets = { oriXYSet_15x19y_d1  oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, ...
%                                             oriXYSet_22x26y_d1_21o_d1, ...oriXYSet_22x26y_d1_41o_d1, ...
%                                            };
           
%             oriXYSet_2x2y_d1 = struct('oris', [0], 'xs', [0 : 1 ], 'ys', [0 : 1 ] );  % for complexity 2*2 = 4
%            oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for complexity 4*4 = 16
%            oriXYSet_8x8y_d1 = struct('oris', [0], 'xs', [0 : 7 ], 'ys', [0 : 7 ] );  % for complexity 8*8 = 64
%            oriXYSet_16x16y_d1 = struct('oris', [0], 'xs', [0 : 15 ], 'ys', [0 : 15 ] );  % for complexity 16*16 = 256
%            oriXYSet_22x22y_d1 = struct('oris', [0], 'xs', [0 : 21 ], 'ys', [0 : 21 ] );  % for complexity 22*22 = 484
% 
%            allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x2y_d1,    oriXYSet_4x4y_d1, oriXYSet_8x8y_d1, oriXYSet_16x16y_d1, oriXYSet_22x22y_d1};

           
%              oriXYSet_2x_d1 = struct('oris', [0], 'xs', [0 : 1 : 1], 'ys', [0] );  
%              oriXYSet_2x_d2 = struct('oris', [0], 'xs', [0 : 2 : 2], 'ys', [0] );  
%              oriXYSet_2x_d3 = struct('oris', [0], 'xs', [0 : 3 : 3], 'ys', [0] );  
%              oriXYSet_2x_d4 = struct('oris', [0], 'xs', [0 : 4 : 4], 'ys', [0] );  
%              oriXYSet_2x_d6 = struct('oris', [0], 'xs', [0 : 6 : 6], 'ys', [0] );  
%              oriXYSet_2x_d8 = struct('oris', [0], 'xs', [0 : 8 : 8], 'ys', [0] );  
%              oriXYSet_2x_d16= struct('oris', [0], 'xs', [0 : 16 : 16], 'ys', [0] );  
% 
%              allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x_d1, oriXYSet_2x_d2, oriXYSet_2x_d3, oriXYSet_2x_d4, oriXYSet_2x_d6, oriXYSet_2x_d8, oriXYSet_2x_d16};
                    
%                      oriXYSet_24x24y_d1             = struct('oris', [0], 'xs', [1 : 24], 'ys', [1 : 24]);
%                      oriXYSet_26x26y_d1             = struct('oris', [0], 'xs', [1 : 26], 'ys', [1 : 26]);
%                      oriXYSet_28x28y_d1             = struct('oris', [0], 'xs', [1 : 28], 'ys', [1 : 28]);
% 
%                      oriXYSet_12x12y_d2             = struct('oris', [0], 'xs', [1 : 2 : 24], 'ys', [1 : 2 : 24]);
%                      oriXYSet_6x6y_d4               = struct('oris', [0], 'xs', [1 : 4 : 24], 'ys', [1 : 4 : 24]);
%                      oriXYSet_4x4y_d6               = struct('oris', [0], 'xs', [1 : 6 : 24], 'ys', [1 : 6 : 24]);
%                      allUncertaintySets = {oriXYSet_24x24y_d1, oriXYSet_26x26y_d1, oriXYSet_28x28y_d1, oriXYSet_12x12y_d2, oriXYSet_6x6y_d4, oriXYSet_4x4y_d6};
%            
                   oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
                   oriXYSet_22x26y_d1             = struct('oris', [0], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
                   oriXYSet_31x36y_d1             = struct('oris', [0], 'xs', [1 : 31 ], 'ys', [1 : 36 ] ); 
                   oriXYSet_45x47y_d1             = struct('oris', [0], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
%                    oriXYSet_45x47y_d1_21o_d1      = struct('oris', [-10:1:10], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
%                    oriXYSet_45x47y_d1_41o_d1      = struct('oris', [-20:1:20], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
                   
                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, oriXYSet_31x36y_d1, ...
                                           oriXYSet_45x47y_d1 }; ..., oriXYSet_45x47y_d1_21o_d1, oriXYSet_45x47y_d1_41o_d1};

%             allRetrainFromLayers = {'classifier'};
%             allRetrainFromLayers = {''};            

            fullWiggleSet = {'same'};
            svhn_trainingSize = [32, 32];
%             svhn_trainingSize = [64, 64];
%             fullWiggleSet = allWiggles_S;

%             fontName_use = struct('fonts', 'Snakes', 'wiggles', struct('none', 1));
            fontName_use = struct('fonts', 'Snakes', 'wiggles', struct('orientation', 50));
            switch grouping_trainOn
                case 'SVHN',       
                    
                    if strcmp(modelName, 'ConvNet')
                        svhn_imageSize = [32 32];
                        %                  svhn_imageSize = [64 64];
                        %                  svhn_imageSize = imageSize;
                        trainingFonts_no_lcn = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', false));
                        trainingFonts_lcn    = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', true));
                        trainingFonts = trainingFonts_no_lcn;
                        
                        allTrainingFonts = {trainingFonts_no_lcn, trainingFonts_lcn};
                        allRetrainFromLayers = {'linear'};
                                    
                    elseif strcmp(modelName, 'Texture')
                        svhn_imageSize = [64, 64];
                        
                        all_realData_opts = expandOptionsToList(struct('tbl_localContrastNorm', {{false}}, ...
                            'tbl_scaleMethod', {{'tile'}}, ...
                            'imageSize', svhn_imageSize, ...
                            'globalNorm', true'));
                        allTrainingFonts = arrayfun(@(svhn_opt) struct('fonts', 'SVHN', 'realData_opts', svhn_opt), all_realData_opts, 'un', 0);
                        trainingFonts = allTrainingFonts{1};
                        
                        allRetrainFromLayers = {'linear1'};
%                         allRetrainFromLayers = {'linear-2'};
                        
                    end
                    
                    
%                     trainingFonts = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_trainingSize, 'globalNorm', true, 'localContrastNorm', 0));
                    
                    trainingImageSize = svhn_trainingSize;
                    trainingOriXY = 'same';
%                                     trainingNoise = 'same';
                    tbl_trainingNoise = {'same'};
                                    
                case 'noWiggle',    
                    trainingWiggle = struct('none', 1);
                    trainingOriXY = { allUncertaintySets{1} };

                case 'allWiggles',
                    
                case 'Sloan',       
                    trainingFonts = ('SloanT3');
                    trainingOriXY = { oriXYSet_10x10y21o };
                                   
                case 'sameWiggle'
                    trainingWiggle = 'same';
                    
            end

%             trainingNoise = 
            
            if doTextureStatistics

                Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 7; 
                textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt};
                allTextureStatsUse = {'V2'};
                
            end
            
        case 'Complexity',
%             sizeStyle = 'k16';  imageSize = [32, 32];
%             sizeStyle = 'k15';  imageSize = [32, 32];
%             sizeStyle = 'k15';  imageSize = [56, 56];

%             allFontNames      = {'Armenian', 'Devanagari', 'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung', 'BookmanB', 'BookmanU', 'Hebraica', 'Devanagari', 'Checkers4x4', 'Courier'};
%             allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};

            sizeStyle = 'k15';  imageSize = [64, 64];
            
%             sizeStyle = 'k24'; imageSize = [64, 64];
%             sizeStyle = 'k30'; imageSize = [64, 64];
%             sizeStyle = 'k30'; imageSize = [80, 80];
            
            autoImageSize = 0;
%                 imageSize = [32, 32];
            all_imageSizes_C = {imageSize};
            
            %                 fullStyleSet = {allFontStyles};
            
             if strcmp(complexity_trainOn, 'SVHN')

                 if strcmp(modelName, 'ConvNet')
                     svhn_imageSize = [32 32];
    %                  svhn_imageSize = [64 64];

                     trainingFonts_no_lcn = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', false));
                     trainingFonts_lcn = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', true));
                     trainingFonts = trainingFonts_no_lcn;
    %                  trainingFonts = trainingFonts_lcn;
                     allTrainingFonts = {trainingFonts_no_lcn, trainingFonts_lcn, };
                     allRetrainFromLayers = {'linear'};

                 elseif strcmp(modelName, 'Texture')
                     svhn_imageSize = [64, 64];

                     all_realData_opts = expandOptionsToList(struct('tbl_localContrastNorm', {{false, true}}, ...
                                                                'tbl_scaleMethod', {{'tile', 'pad', 'fourier'}}, ...
                                                                'imageSize', svhn_imageSize, ...
                                                                 'globalNorm', true'));
                     allTrainingFonts = arrayfun(@(svhn_opt) struct('fonts', 'SVHN', 'realData_opts', svhn_opt), all_realData_opts, 'un', 0);
                     trainingFonts = allTrainingFonts{1};
                      allRetrainFromLayers = {'linear-2'};

                 end

                 
%                  allRetrainFromLayers = {'classifier'};
             else
                 
%                  allRetrainFromLayers = {'linear'};
                    allRetrainFromLayers = {'classifier'};
%             allRetrainFromLayers = {''};            
                 
             end
%                 trainingFonts = {'SVHN'};
            
            
%             trainingFonts = {allFontNames_std};
%             fullFontSet = {allFontNames_std};
            classifierForEachFont = true;
            
            oriXYSet_1pos = struct('oris', 0, 'xs', 0, 'ys', 0 );
            oriXYSet_6x9y21o = struct('oris', [-20:2:20], 'xs', [0:2:10], 'ys', [0:2:16] );  %Nx = 20
            oriXYSet_4x4y7o = struct('oris', [-15:5:15], 'xs', [0:3:9], 'ys', [0:3:9] );  % for complexity
            oriXYSet_6x6y11o = struct('oris', [-15:3:15], 'xs', [0:2:10], 'ys', [0:2:10] );  % for complexity

            oriXYSet_2x2y3o = struct('oris', [-5:5:5], 'xs', [0, 5], 'ys', [0, 5] );  % for complexity
            oriXYSet_3x6y7o = struct('oris', [-15:5:15], 'xs', [0, 4,8], 'ys', [0 : 4 : 20] );  % for complexity : 1

%             allUncertaintySets = {oriXYSet_2x2y3o, oriXYSet_3x6y7o_d2, oriXYSet_3x6y7o, oriXYSet_1pos}; % [k30, 64x64] ;

            oriXYSet_3x6y7o = struct('oris', [-15:5:15], 'xs', [0, 4,8], 'ys', [0 : 4 : 20] );  % for complexity : 1
            oriXYSet_3x6y7o_d2 = struct('oris', [-15:5:15], 'xs', [0,2,4], 'ys', [0 : 2 : 10] );  % for complexity : 1

            
            oriXYSet_2x_d4 = struct('oris', [0], 'xs', [0, 4], 'ys', [0] );  % for complexity
            oriXYSet_2x2y_d4 = struct('oris', [0], 'xs', [0, 4], 'ys', [0, 4] );  % for complexity
            oriXYSet_2x4y_d4 = struct('oris', [0], 'xs', [0, 4], 'ys', [0, 4, 8, 12] );  % for complexity

            oriXYSet_3o_d5 = struct('oris', [-5,0,5], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_7o_d5 = struct('oris', [-15:5:15], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_11o_d4 = struct('oris', [-20:4:20], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_21o_d2 = struct('oris', [-20:2:20], 'xs', [0], 'ys', [0] );  % for complexity
            
            oriXYSet_13o_d5 = struct('oris', [-30:5:30], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_19o_d5 = struct('oris', [-45:5:45], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_25o_d5 = struct('oris', [-60:5:60], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_37o_d5 = struct('oris', [-90:5:90], 'xs', [0], 'ys', [0] );  % for complexity
          
%             allUncertaintySets = { oriXYSets_1pos };
%             allUncertaintySets = { oriXYSet_6x9y21o };            
%             allUncertaintySets = { oriXYSet_4x4y7o };
%             allUncertaintySets = { oriXYSet_6x6y11o };

%             allUncertaintySets = { oriXYSet_2x2y3o };
%             allUncertaintySets = { oriXYSet_3x6y7o };
%             allUncertaintySets = { oriXYSet_3x6y7o_d2 };

%             allUncertaintySets = { oriXYSet_2x_d4 };
%             allUncertaintySets = { oriXYSet_2x2y_d4 };
%             allUncertaintySets = { oriXYSet_2x4y_d4 };
%             allUncertaintySets = { oriXYSet_3o_d5 };
%             allUncertaintySets = { oriXYSet_7o_d5 };
%             allUncertaintySets = { oriXYSet_11o_d4 };
%             allUncertaintySets = { oriXYSet_21o_d2 };
%             allUncertaintySets = { oriXYSets_1pos, oriXYSet_2x_d4, oriXYSet_2x2y_d4, oriXYSet_2x2y3o, oriXYSet_2x4y_d4, oriXYSet_3x6y7o, oriXYSet_3x6y7o_d2  };
%             allUncertaintySets = { oriXYSets_1pos, oriXYSet_2x2y3o, oriXYSet_3x6y7o, };
% 
%             allUncertaintySets = { oriXYSets_1pos, oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2,     oriXYSet_13o_d5, oriXYSet_19o_d5, oriXYSet_25o_d5, oriXYSet_37o_d5  };

%             allUncertaintySets = { oriXYSets_1pos, oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2,     oriXYSet_13o_d5, oriXYSet_19o_d5, oriXYSet_25o_d5, oriXYSet_37o_d5  };
%             allUncertaintySets = { oriXYSet_21o_d2 };
%             allUncertaintySets = { oriXYSet_21o_d2 };
%             allUncertaintySets = { oriXYSet_21o_d2 };

            oriXYSet_2x4y_d4 = struct('oris', [0], 'xs', [0, 4], 'ys', [0, 4, 8, 12] );  % for complexity
            oriXYSet_2x4y_d2 = struct('oris', [0], 'xs', [0, 2], 'ys', [0, 2, 4, 6] );  % for complexity
            oriXYSet_2x4y_d1 = struct('oris', [0], 'xs', [0, 1], 'ys', [0, 1, 2, 3] );  % for complexity
            oriXYSet_3x7y_d2 = struct('oris', [0], 'xs', [0:2:4], 'ys', [0 : 2 : 12] );  % for complexity
            oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [0:1:4], 'ys', [0 : 1 : 12] );  % for complexity

            oriXYSet_21o_d2 = struct('oris', [-20:2:20], 'xs', [0], 'ys', [0] );  % for complexity
            oriXYSet_21o_d2_2x4y_d4 = struct('oris', [-20:2:20], 'xs', [0, 4], 'ys', [0, 4, 8, 12] );  % for complexity
            oriXYSet_21o_d2_2x4y_d2 = struct('oris', [-20:2:20], 'xs', [0, 2], 'ys', [0, 2, 4, 6] );  % for complexity
            oriXYSet_21o_d2_3x7y_d2 = struct('oris', [-20:2:20], 'xs', [0:2:4], 'ys', [0 : 2 : 12] );  % for complexity
            oriXYSet_21o_d2_5x13y_d1 = struct('oris', [-20:2:20], 'xs', [0:1:4], 'ys', [0 : 1 : 12] );  % for complexity

%                             allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_2x4y_d2, oriXYSet_2x4y_d1, oriXYSet_3x7y_d2, oriXYSet_5x13y_d1, ...
%                             oriXYSet_21o_d2, oriXYSet_21o_d2_2x4y_d4, oriXYSet_21o_d2_2x4y_d2, oriXYSet_21o_d2_3x7y_d2, oriXYSet_21o_d2_5x13y_d1};


            allUncertaintySets = { oriXYSet_1pos, oriXYSet_21o_d2, ...
                                                  oriXYSet_2x4y_d4, oriXYSet_21o_d2_2x4y_d4,    ...
                                                  oriXYSet_2x4y_d2, oriXYSet_21o_d2_2x4y_d2,   ...
                                                  oriXYSet_2x4y_d1, ...
                                                  oriXYSet_3x7y_d2, oriXYSet_21o_d2_3x7y_d2, ...
                                                  oriXYSet_5x13y_d1, oriXYSet_21o_d2_5x13y_d1, ...
                                                  };
            oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [0 : 1 : 4], 'ys', [0 : 1 : 12] );  % for complexity  5*13   = 65
            oriXYSet_7x18y_d1 = struct('oris', [0], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18    = 126
            oriXYSet_10x26y_d1 = struct('oris', [0], 'xs', [0 : 1 : 9], 'ys', [0 : 1 : 25] );  % for complexity 10*26  = 260
            oriXYSet_14x37y_d1 = struct('oris', [0], 'xs', [0 : 1 : 13], 'ys', [0 : 1 : 36] );  % for complexity 14*37  = 518
            oriXYSet_30x39y_d1 = struct('oris', [0], 'xs', [0 : 1 : 29], 'ys', [0 : 1 : 38] );  % for complexity 31*39 = 1209

                                                                                
            allUncertaintySets = { oriXYSet_1pos, oriXYSet_5x13y_d1,    oriXYSet_7x18y_d1, oriXYSet_10x26y_d1, oriXYSet_14x37y_d1, oriXYSet_30x39y_d1};

            
%             
%             
%             oriXYSet_7x18y_d1 = struct('oris', [0], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18    = 126
%             oriXYSet_7x18y_d1_3o_d5 = struct('oris', [-5 : 5 : 5], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
%             oriXYSet_7x18y_d1_7o_d5 = struct('oris', [-15 : 5 : 15], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
%             oriXYSet_7x18y_d1_11o_d3 = struct('oris', [-15 : 3 : 15], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
% %             
%             allUncertaintySets = { oriXYSet_1pos, oriXYSet_7x18y_d1, oriXYSet_7x18y_d1_3o_d5, oriXYSet_7x18y_d1_7o_d5, oriXYSet_7x18y_d1_11o_d3};

            
            
%                 oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
%                 oriXYSet_5x13y_d1_3ori_d5 = struct('oris', [-5:5:5], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
%                 oriXYSet_5x13y_d1_3ori_d10 = struct('oris', [-10:10:10], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
%                 oriXYSet_5x13y_d1_3ori_d15 = struct('oris', [-15:15:15], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
%                 oriXYSet_5x13y_d1_3ori_d30 = struct('oris', [-30:30:30], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
%                 
%                 allUncertaintySets = {oriXYSet_1pos, oriXYSet_5x13y_d1, oriXYSet_5x13y_d1_3ori_d5, oriXYSet_5x13y_d1_3ori_d10, oriXYSet_5x13y_d1_3ori_d15, oriXYSet_5x13y_d1_3ori_d30};

                
                % with all 13 fonts
                oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_6x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 6], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_5x14y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 14] );  % for complexity  5*13   = 65                
                
%                 allUncertaintySets = {oriXYSet_1pos, oriXYSet_5x13y_d1, oriXYSet_6x13y_d1, oriXYSet_5x14y_d1};
                allUncertaintySets = {oriXYSet_6x13y_d1};

%             allUncertaintySets = { oriXYSet_1pos, oriXYSet_5x13y_d1,    oriXYSet_7x18y_d1, oriXYSet_10x26y_d1, oriXYSet_14x37y_d1, oriXYSet_30x39y_d1};

            if doConvNet
                
                
            elseif doTextureStatistics

                Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 7; 
                textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt};
                allTextureStatsUse = {'V2'};

%                 trainingFonts = 'same';
%                 allTrainingFonts = {'same'};
                allUncertaintySets = { oriXYSet_1pos, oriXYSet_3o_d5 };
            end
                  
            all_sizeStyles_C = {sizeStyle};
            
        case 'Uncertainty', 
             fontName_use = 'Bookman';
%              fontName_use = 'Sloan';
            
             autoImageSize = 0;
%                 imageSize = [65, 65];
%                 imageSize = [36, 88];
%                 imageSize = [36, 116];
%                 imageSize = [36, 164];
%                 imageSize = [40, 40];
%                 sizeStyle = 'k15';  imageSize = [64, 64];
                sizeStyle = 'k15';  imageSize = [32, 160];

%                 uncertainty_trainOn = 'same';
                uncertainty_trainOn = 'SVHN';
                
                switch uncertainty_trainOn
                    case 'same',
                        trainingFonts = 'same';
                        allTrainingFonts = {fontName_use};
                        
                    case 'SVHN',
                        svhn_imageSize  = [32, 32];
                        trainingFonts_no_lcn = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', false));
%                         trainingFonts_lcn    = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', true));
                        trainingFonts = trainingFonts_no_lcn;
%                         
                        allTrainingFonts = {trainingFonts_no_lcn};
                        allRetrainFromLayers = {'linear'};
                        
                end
                
                all_sizeStyles_C = {sizeStyle};
                all_imageSizes_C = {imageSize};
                
                trainOnIndividualPositions = false;
                retrainOnCombinedPositions = false;
%                 fullFontSet = {'BookmanU'};
%                 fullFontSet = {'Bookman'};
            
                if strcmp(multiple_plots, 'Uncertainty');
                    multiple_plots = '';
                end
  
%                 uncertainty_xpos = 'index';
%                 uncertainty_xpos = 'nPositions';
                uncertainty_xpos = 'lognPositions';
%         case {'NoisyLetters', 'NoisyLettersTextureStats'},
            
%                 imageSize = [48, 48];
%                 imageSize = [64, 64];
%                 imageSize = [32, 32];
%                 all_imageSizes_C = {imageSize};

%              all_snr_train_C = {[2 3 4]};
%              all_snr_train_C = {[1 2 3]};
             
%              autoImageSize = 1;
             if strcmp(netType, 'ConvNet')
%                  all_snr_train_C = {[1 2 3]};
                 all_snr_train_C = {[1 : .5 : 3]};
%                  all_snr_train_C = {[0 1 2]};
             end

             
             if doTextureStatistics
                 Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 7; 
                 textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt};
                 
                 allTextureStatsUse = {'V2'};
                 
                 all_snr_train_C = {[1, 2, 3, 4]};
             end

             if doOverFeat
                 networkId = 0;
                 layerId = 19;
                 overFeatOpts_C = {'networkId', networkId, 'layerId', layerId, 'overFeatImageFile', false};
             end
           
             
             oriXYSet_1pos = struct('oris', 0, 'xs', 0, 'ys', 0 );
             oriXYSet_3x1y_d1 = struct('oris', [0], 'xs', [1 : 3], 'ys', [0] );
             oriXYSet_5x1y_d1 = struct('oris', [0], 'xs', [1 : 5], 'ys', [0] );
             oriXYSet_15x1y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [0] );
             oriXYSet_30x1y_d1 = struct('oris', [0], 'xs', [1 : 30], 'ys', [0] );
             oriXYSet_15x2y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [1:2] );
             oriXYSet_3x5y_d1 = struct('oris', [0], 'xs',  [1:3], 'ys', [1:5] );
             oriXYSet_5x3y_d1 = struct('oris', [0], 'xs',  [1 : 5], 'ys', [1:3] );
             oriXYSet_2x15y_d1 = struct('oris', [0], 'xs', [1 : 2], 'ys', [1:15] );
             oriXYSet_1x30y_d1 = struct('oris', [0], 'xs', [1], 'ys', [1:30] );
             
             allUncertaintySets = {oriXYSet_1pos, oriXYSet_3x1y_d1, oriXYSet_5x1y_d1, oriXYSet_15x1y_d1, oriXYSet_30x1y_d1, oriXYSet_15x2y_d1, oriXYSet_3x5y_d1, oriXYSet_5x3y_d1, oriXYSet_2x15y_d1, oriXYSet_1x30y_d1 };

           oriXYSet_3x_d3 = struct('oris', [0], 'xs', [1  : 3 : 3*3], 'ys', [0] );  
           oriXYSet_7x_d3 = struct('oris', [0], 'xs', [1  : 3 : 7*3], 'ys', [0] );  
           oriXYSet_15x_d3 = struct('oris', [0], 'xs', [1 : 3 : 15*3], 'ys', [0] );  
           oriXYSet_20x_d3 = struct('oris', [0], 'xs', [1 : 3 : 20*3], 'ys', [0] );  
           oriXYSet_30x_d3 = struct('oris', [0], 'xs', [1 : 3 : 30*3], 'ys', [0] );  
           oriXYSet_45x_d3 = struct('oris', [0], 'xs', [1 : 3 : 45*3], 'ys', [0] );  

           allUncertaintySets = {oriXYSet_1pos, oriXYSet_3x_d3, oriXYSet_7x_d3, oriXYSet_15x_d3, oriXYSet_20x_d3, oriXYSet_30x_d3, oriXYSet_45x_d3};
             

           
    
        case 'Crowding',
            switch modelName
                case {'ConvNet', 'Texture'},
%                     sizeStyle = 'k16';
                    sizeStyle = 'k15';
                case { 'OverFeat'},
                    sizeStyle = 'k23';
            end

            fontName_use = 'Sloan';
%             fontName_use = 'Bookman';
            
            imageSize = [32, 160];
            all_sizeStyles_C = {sizeStyle};
            all_imageSizes_C = {imageSize}; 
            
            crowding_trainOn = 'whiteNoise';
%             crowding_trainOn = 'SVHN';
            

            if strcmp(crowding_trainOn, 'SVHN')
                
                if strcmp(modelName, 'ConvNet')
                    svhn_imageSize = [32 32];
                    %                  svhn_imageSize = [64 64];
                    
                    trainingFonts_no_lcn = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', false));
                    trainingFonts_lcn = struct('fonts', 'SVHN', 'realData_opts', struct('imageSize', svhn_imageSize, 'globalNorm', true, 'localContrastNorm', true));
                    trainingFonts = trainingFonts_no_lcn;
                    %                  trainingFonts = trainingFonts_lcn;
                    allTrainingFonts = {trainingFonts_no_lcn, trainingFonts_lcn, };
                    allRetrainFromLayers = {'linear'};
                    
                elseif strcmp(modelName, 'Texture')
                    svhn_imageSize = [64, 64];
                    
                    all_realData_opts = expandOptionsToList(struct('tbl_localContrastNorm', {{false, true}}, ...
                        'tbl_scaleMethod', {{'tile', 'pad', 'fourier'}}, ...
                        'imageSize', svhn_imageSize, ...
                        'globalNorm', true'));
                    allTrainingFonts = arrayfun(@(svhn_opt) struct('fonts', 'SVHN', 'realData_opts', svhn_opt), all_realData_opts, 'un', 0);
                    trainingFonts = allTrainingFonts{1};
                    allRetrainFromLayers = {'linear-2'};
                    
                end
                
                
                %                  allRetrainFromLayers = {'classifier'};
            else
                
                
                %                  allRetrainFromLayers = {'linear'};
%                 allRetrainFromLayers = {'classifier'};
                            allRetrainFromLayers = {''};
                
            end
            
            
            if doConvNet
                
                
            elseif doTextureStatistics

                Nscl_txt = 3;  Nori_txt = 4;  Na_txt = 7; 
                textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt};
                allTextureStatsUse = {'V2'};
                
            end
            all_snr_train_C = {[1 : .5 : 3]};
           
%             all_imageSizes_C = {[32, 64]};
            autoImageSize = 0;
                        
%             all_XRanges_C = { {15,5,60}, {15,30,45},  {12,25,62} };
            
%             all_XRanges_C = { [15,5,55]  };  all_trainTargetPosition_C = {'all'};
%             all_XRanges_C = { [15,5,85]  };  all_trainTargetPosition_C = {[1:9]};

%             all_XRanges_C = { [15,12,87]  };  all_trainTargetPosition_C = {[1,3,4]};
%             all_XRanges_C = { [15,3,87]  };  all_trainTargetPosition_C = {[1,9,13]};
%             all_XRanges_C = { [-16,12,176]  };  all_trainTargetPosition_C = {[3:15]};

            

            
            all_XRanges_C = {[-16, 12, 176]};  all_trainPositions = {[3:15]};  all_testPositions = {9};
%             all_XRanges_C = {[-16, 8, 176]};  all_trainPositions = {[3:23]};  all_testPositions = {13};
            
            allNDistractors = {2, 1};
            allLogDNRs = {2.5, 2.9};
            
            allCrowdingOpts = (struct('tbl_trainPositions', {all_trainPositions}, ...
                'tbl_testPositions', {all_testPositions}, ...
                'tbl_xrange', {all_XRanges_C}, ... 
                'tbl_nDistractors',   {allNDistractors}, ...
                'tbl_logDNR',        {allLogDNRs}, ...
                'absHorizPosition',  true, ...
                'distractorSpacing', nan ...
                ) );
            allCrowdingSettings = num2cell(  expandOptionsToList (allCrowdingOpts)  );

            crowdingSettings = allCrowdingSettings{1};
            
            
            targetTestPosition = 9;
%             all_trainTargetPosition_C = {'all'};
            all_testTargetPosition_C = {[targetTestPosition]};
            
            all_logDNR_C = {2.9};
            
            
            xrange = all_XRanges_C{1}; %[crowdedLetterOpts.xrange{:}];
%             allSpacings_pix =  (xrange(1) : xrange(2) : xrange(3))-xrange(1); 
            
            [~, fontData] = loadLetters(allFontNames{1}, sizeStyle);
            nDistractors = 2;
            
            allSpacings_pix = getAllDistractorSpacings(xrange, fontData.size(2), nDistractors, targetTestPosition);
            
%             switch sizeStyle
%                 case 'sml', allSpacings_pix = allSpacings_pix(allSpacings_pix >= 15);
%                 case 'med', allSpacings_pix = allSpacings_pix(allSpacings_pix >= 25);
%                 case 'big', allSpacings_pix = allSpacings_pix(allSpacings_pix >= 25);
%             end
                  
            allSpacings_C = arrayfun(@(npix) sprintf('%dpix', npix), allSpacings_pix, 'un', 0);
            
            doCrowdedTextureStats = 1;
            if doCrowdedTextureStats
%                 all_snr_train_C = {[1 2 3]};
%                 all_snr_train_C = {[2 3 4 5]};
            end
               
            
%             getIdeal = 1;
            all_nLetters_C = {nDistractors+1};
            guessRate = (1/nClasses) * (1/nClasses) + (nClasses-1)/nClasses * (2 / nClasses);
            
            
        case 'TrainingWithNoise',
            sizeStyle = 'k16';  imageSize = [32, 32];

            all_imageSizes_C = {[32, 32]};
            
            
        case 'FontSize'  %strcmp(yvsx_name, 'Efficiency_vs_FontSize')

%                 all_sizeStyles = [12,16,20,24];
%                 all_sizeStyles = [8,16,24];
                all_sizeStyles = [8,12,16,20,24];
                all_sizeStyles_C = num2cell(all_sizeStyles);

        %         all_imageSizes_C = {[20,20],[50,50], [80,80]};
                all_imageSizes_C = {[50,50], [80, 80]};
        %         all_sizeStyles = [15, 16];
        %         all_imageSizes_C = { [34,38] };

                autoImageSize = 0;
            
             

            
            
    end
    
    allLetterOpts_struct = struct( 'expName', expName, 'stimType', stimType, ...
                             'fontName', fontName_use, ...
                             'fullFontSet', fullFontSet, ...
                             'fullStyleSet', fullStyleSet, ...
                             'fullWiggleSet', fullWiggleSet, ...
                             'tbl_OriXY', {allUncertaintySets}, ...
                             'autoImageSize', autoImageSize, ...
                             'tbl_sizeStyle', {all_sizeStyles_C}, ...
                             'tbl_imageSize', {all_imageSizes_C}, ...
                             'tbl_blurStd', {allBlurStd_C}, ...
                             ...
                             'noiseFilter', testNoiseFilter, ...
                             'tbl_trainingNoise', {tbl_trainingNoise}, ...
                             'tbl_retrainFromLayer', {allRetrainFromLayers}, ...
                             ...
                             'trainOnIndividualPositions', trainOnIndividualPositions, ...
                             'retrainOnCombinedPositions', retrainOnCombinedPositions, ...
                             ...
                             'tbl_snr_train', {all_snr_train_C}, ...
                             ...
                             'trainingFonts', trainingFonts, ...
                             'classifierForEachFont', classifierForEachFont, ...
                             ...
                             'trainingWiggle', trainingWiggle, ...
                             ...
                             'trainingImageSize', trainingImageSize, ...
                             'trainingOriXY', trainingOriXY, ...
                             ...  texture options
                             'doTextureStatistics', doTextureStatistics, ...
                             textureStatOpts_C{:}, ...
                             'tbl_textureStatsUse', {allTextureStatsUse}, ...
                             ...
                             ... overfeat options
                             'doOverFeat', doOverFeat, ...
                             overFeatOpts_C{:}, ...
                             ...  crowded options
                             ...'tbl_xrange', {all_XRanges_C}, ...
                             ...'tbl_trainTargetPosition', {all_trainTargetPosition_C}, ...
                             ...'tbl_testTargetPosition', {all_testTargetPosition_C}, ...
                             ...'distractorSpacing', allDistractSpacings_pix(1), ...
                             'crowdingSettings', crowdingSettings, ...
                             ...
                             'tbl_nLetters', {all_nLetters_C}, ...
                             'tbl_logDNR', {all_logDNR_C}, ...
                             ...
                             'tf_pca', 0, ...
                             'GPU_batchSize', GPU_batchSize ...
                       );
     allLetterOpts = expandOptionsToList(allLetterOpts_struct);

                   
     for i = 1:length(allLetterOpts)
         
        allLetterOpts(i) = fixNoisyLetterOpts(allLetterOpts(i));
         
     end

     multiple_opts = 'nLetters';
    letterOpt_std = allLetterOpts(1);
    
    
     fprintf('\n ---- Using the following options ----\n');
    displayOptions(allLetterOpts_struct);

    

    
    nOpts = length(allLetterOpts);
%%    
%     opt_str = getLetterOptsStr(nNoisyLetterOpt_std);
    letterOpt_std2 = letterOpt_std;
%     letterOpt_std2.noiseFilter = '';
    opt_str = getLetterOptsStr(letterOpt_std2);
% opt_str = '!!!';
%%
    

       
    allFiltSizes_C = {3, 5, 10, 20};
%     allPoolSizes_C = {0, 2, 4, 8, 16};
    allPoolSizes_C = {0, 2, 4, 8, 16};
%     allPoolSizes_C = {0,2,4};
%     allFontSizes = {8, 12, 16, 20, 24};
    allFontSize_and_ImageSize = { {'k9', [35 35]}, {'k18', [49 49]}, {'k36', [99 99]}, {'k72', [147 147]} };
    
    allFontSize_and_FiltSize_and_PoolSize_and_ImageSize = { ...
        {'k9', [ 3 3], [2 2], [35 35]}, ...
        {'k18', [5 5], [4 4], [49 49]}, ...
        {'k36', [10 10], [8 8], [99 99]}, ...
        {'k72', [20 20], [16 16], [147 147]} };
    
    all_filtSizes_range = {[3 3], [5 5], [10 10], [20 20]};
    all_poolSizes_range = {[2 2], [4 4], [8 8], [16 16]};
    allPoolingFactors = [.25, 0.5, 1, 2, 4];
    allFilterFactors = [.25, 0.5, 1, 2, 4];
%     allPoolingFactors = [1];
    curPoolingFactor = 1;
    curFilterFactor = 1;
%     allFontSize_and_ImageSize = {  {'k72', [147 147]} };

%     allTrainingSNRs = {1, 2, 3, 4, 5};
%     allTrainingSNRs = { 1, 2, 3, 4, 5, [1 2], [2 3], [3 4], [1, 2, 3], [1, 2, 3 4], [2 3 4]};
%     allTrainingSNRs = { 1, 2, 3, 4, [1, 2, 3], [1, 2, 3 4]};
%%

    allTrainingSNRs = { [1, 2, 3]};

    if strcmp(expName, 'TrainingWithNoise')

        allTrainingSNRs = { ... {0}, {1}, {2}, {3}, {4},   {0, 1}, {1, 2}, {2, 3}, {3, 4},     ...
                                     ... {0, 1, 2}, 
                                     {.5, 1.5, 2.5}, {1, 2, 3}, {1.5, 2.5, 3.5}, ...{2, 3, 4}, ...
                                    ...{1, 1.5, 2, 2.5},  
                                    {1.5, 2, 2.5, 3}, ...{2, 2.5, 3, 3.5} ,...
                                    {1, 1.5, 2, 2.5, 3},  {1, 1.5, 2, 2.5, 3, 3.5}, {1, 2, 3, 4}  };
        allTrainingSNRs = cellfun(@(x) [x{:}], allTrainingSNRs, 'un', 0);

    end
  %%  
    %     allFiltSizes = [2, 4, 8];
%     allFiltSizes = [2, 4, 8, 16, 20, 24];
%     allPoolSizes = [0, 2, 4, 6, 8, 12];

    
    
    x_name_nice = x_name;
    switch x_name
        case 'Complexity', nX = length(allFontNames); % x_vals = fontComplexities;   
        case 'FontSize',   nX = length(all_sizeStyles);
        case 'FiltSize',   nX = length(allFiltSizes_C);
        case 'NoiseFreq',  nX = length(allNoiseFreqs);
        case 'Uncertainty', nX = length(allUncertaintySets);
        case 'Wiggle', nX = length(allWiggles);
            if strcmp(multiple_plots, 'WiggleType')
               nX = max(cellfun(@length, allWiggles_C));
            end
            
        case 'PoolSize', nX = length(allPoolSizes_C);
            x_name_nice = 'Size of Pooling Window';
        case 'Spacing',  nX = length(allSpacings_pix);
%             x_name_nice = 'Spacing Between Letters (pixels)';
            x_name_nice = 'Spacing re critical spacing';
        case 'FontSize_and_FiltSize_and_PoolSize_and_ImageSize',
            nX = length( allFontSize_and_FiltSize_and_PoolSize_and_ImageSize );
            x_name_nice = 'FontSize (& ImageSize) & FiltSize & PoolSize';
        case 'SNR', nX = 1; % length(allSNRs_test);      
        otherwise, error('Unknown "x_name" option');
    end


    switch multiple_lines
        case 'Networks',      nLines = nNetworks;  
        case 'Opts',          nLines = nOpts;
        case 'TrainingNoise', nLines = length(allTrainingNoise);
        case 'FiltSize',     nLines = length(allFiltSizes_C);
        case 'PoolSize',     nLines = length(allPoolSizes_C);
        case 'PoolingFactor', nLines = length(allPoolingFactors);
        case 'FilterFactor', nLines = length(allFilterFactors);
        case 'TrainingSNRs', nLines = length(allTrainingSNRs);
        case 'Uncertainty', nLines = length(allUncertaintySets);
        case 'Networks_and_wiggleType', nLines = nNetworks * nWiggleTypes;
        case '',              nLines = 1;
        otherwise, error('Unknown "multiple_lines" option');
            
    end
        
        
    switch multiple_plots
        case 'Networks',      nPlots = nNetworks;  
        case 'TrainingNoise', nPlots = length(allTrainingNoise);
        case 'TrainingFonts', nPlots = length(allTrainingFonts);
        case 'Opts',      nPlots = nOpts;
        case 'ImageSize', nPlots = length(all_imageSizes_C);
        case 'FiltSizes', nPlots = length(allFiltSizes);
        case 'PoolSizes', nPlots = length(allPoolSizes);
        case 'FontSize_and_ImageSize', nPlots = length(allFontSize_and_ImageSize);
        case 'NoiseType', nPlots = length(allNoiseTypes);
        case 'WiggleType', nPlots = length(allWiggleTypes);
        case 'Uncertainty', nPlots = length(allUncertaintySets);
        case 'CrowdingSettings', nPlots= length(allCrowdingSettings);
        case '',          nPlots = 1;
        otherwise, error('Unknown "multiple_plots" option');
    end
    
    
    
    %%%%%% Collect all pct correct
    fprintf('Gathering pct correct for all conditions...');

%     x_vals_C = cell(1, nPlots);
    x_vals_C(1:nPlots) = {nan(1, nX)}; %cell(1, nPlots);
    xticklabels_C = cell(1,nX); manualXtickLabels = 0;
      
    
    nClassesMax = 26;
    
    font_complexities_model         = zeros(nFonts, 1);    
    pctCorr_ideal                   = zeros(nX, nLines, nPlots, 1,       nSNRs_test, 1);
    pctCorr_model                   = zeros(nX, nLines, nPlots, nTrials, nSNRs_test, 1);
    convFilters = cell(nX, nLines, nPlots, 1);
    fullModels = cell(nX, nLines, nPlots, 1);

    font_complexities_model_indiv   = zeros(nFonts, nClassesMax);       
    pctCorr_ideal_indiv             = zeros(nX, nLines, nPlots, 1,       nSNRs_test, nClassesMax);
    pctCorr_model_indiv             = zeros(nX, nLines, nPlots, nTrials, nSNRs_test, nClassesMax);
    
    plotTitle = cell(1,nPlots);
    allPlotLegends_C = cell(1,nPlots); 
    allPlotLegends_full_C = cell(1,nPlots);
    allPlotLegends_common_C = cell(1,nPlots); 
    legends_common_exclude = {'ConvNet', 'PoolSize', 'Texture + MLP'};

    network_use = allNetworks(1);
    letterOpt_use = letterOpt_std;
    fontSize_use = all_sizeStyles_C{1};    
    fontSizeSpec = 'minSize';
    
    orderFontsByComplexity = strcmp(expName, 'Complexity') && true;
    if orderFontsByComplexity
        font_complexities_model_tmp = cellfun(@(fntName) getFontComplexity(fntName, fontSize_use, fontSizeSpec), allFontNames);
        new_idx = ord(font_complexities_model_tmp);
        allFontNames = allFontNames(new_idx);
    
        fontName_use = allFontNames{1};
    end
    
    
    useProgressBarWhenLoading = false;
    
    if useProgressBarWhenLoading
        progressBar('init-',nPlots * nLines * nX);
    end
    
    for plot_i = 1:nPlots

        
        switch multiple_plots
            case 'Networks', network_use = sub(allNetworks, plot_i);
                [~, plotTitle{plot_i}] = getNetworkStr(network_use, [niceStrFields, multiple_plots]);
            case 'Opts',     letterOpt_use = allLetterOpts(plot_i);
                [~, plotTitle{plot_i}] = getNoisyLetterOptsStr(letterOpt_use, [niceStrFields, multiple_plots]);
            case 'ImageSize',letterOpt_use.imageSize = all_imageSizes_C{plot_i};
                [~, plotTitle{plot_i}] = getNoisyLetterOptsStr(letterOpt_use, [niceStrFields, multiple_plots]);
            case 'FiltSizes',
                network_use.filtSizes = allFiltSizes(plot_i);
                plotTitle{plot_i} = sprintf('FiltSize = %d x %d', allFiltSizes_C{plot_i}, allFiltSizes_C{plot_i});
            case 'PoolSizes',
                network_use.poolSizes = allPoolSizes(plot_i);
                plotTitle{plot_i} = sprintf('PoolSize = %d x %d', allPoolSizes_C{plot_i}, allPoolSizes_C{plot_i});
            case 'FontSize_and_ImageSize',
                letterOpt_use.sizeStyle = allFontSize_and_ImageSize{plot_i}{1};
                letterOpt_use.imageSize = allFontSize_and_ImageSize{plot_i}{2};
                plotTitle{plot_i} = sprintf('Size = %s. ImageSize = %d x %d', num2str(letterOpt_use.sizeStyle), letterOpt_use.imageSize);
            case 'TrainingNoise',
                letterOpt_use.trainingNoise = allTrainingNoise{plot_i};
                [~, noiseFilter_str_nice] = filterStr( letterOpt_use.trainingNoise ); %, {'trainingNoise'});
%                 [~, str] = getLetterOptsStr(letterOpt_use, r);
                if ~strcmp(noiseFilter_str_nice, 'same')
                    plotTitle{plot_i} = ['Trained on: ' noiseFilter_str_nice]; %sprintf('Training Noise = %s ', num2str(letterOpt_use.sizeStyle), letterOpt_use.imageSize);
                end
            case 'TrainingFonts'
                
                letterOpt_use.trainingFonts = allTrainingFonts{plot_i};
                [~, trainingFont_str_nice] = abbrevFontStyleNames( letterOpt_use.trainingFonts ); %, {'trainingNoise'});
                plotTitle{plot_i} = ['Trained on: ' trainingFont_str_nice]; %sprintf('Training Noise = %s ', num2str(letterOpt_use.sizeStyle), letterOpt_use.imageSize);                
                
            case 'NoiseType',
                noiseType = allNoiseTypes{plot_i};
                plotTitle{plot_i} = noiseType;
            case 'WiggleType',
                wiggleType = allWiggleTypes{plot_i};
                plotTitle{plot_i} = [titleCase( wiggleType ) ' wiggle'];
                
                allWiggles = allWiggles_C{plot_i};
            case 'Uncertainty',
                UncertaintySet = allUncertaintySets{plot_i};
                letterOpt_use = addUncertaintyToLetterOpts(letterOpt_use, UncertaintySet);
                if isfield(letterOpt_use, 'oris')
                    [oxy_str, oxy_str_nice] = getOriXYStr(UncertaintySet);
                end
                plotTitle{plot_i} = oxy_str_nice;
            case 'CrowdingSettings',
                letterOpt_use.crowdingSettings = allCrowdingSettings{plot_i};

                plotTitle{plot_i} = getCrowdedLetterOptsStr(letterOpt_use);
            case '', 
                plotTitle{plot_i} = '';
            otherwise
                error('Unknown plot option');
        end
                    
        line_legends = cell(1,nLines);
        for set_i = 1:nLines   

    %             niceNetworkStrFields = {'doPooling', 'poolSizes'};
%             niceNetworkStrFields = {};
%             niceNetworkStrFields = {'doPooling'};
            OriXY = letterOpt_use.OriXY;
            niceNetworkStrFields = {multiple_lines, niceStrFields{:}}; % 'filtSizes'
            niceOptStrFields = {multiple_lines, 'IndivPos', 'trainingFonts', 'trainingWiggle', 'retrainFromLayer', 'classifierForEachFont'}; % 'SNR_train', 
            
%             'trainingImageSize', 
            if strcmp(multiple_plots, 'TrainingFonts')
                niceOptStrFields = setdiff(niceOptStrFields, 'trainingFonts');
            end
            
            if isfield(OriXY, 'oris') && (~strcmp(expName, 'Uncertainty') && ~strcmp(x_name, 'Uncertainty'));
                niceOptStrFields = [niceOptStrFields, 'Uncertainty']; %#ok<AGROW>
            end
            if isfield(OriXY, 'fonts')
                niceOptStrFields = [niceOptStrFields, 'fontNames']; %#ok<AGROW>
            end
            if isfield(OriXY, 'styles')
                niceOptStrFields = [niceOptStrFields, 'fontStyles']; %#ok<AGROW>
            end
            if strcmp(stimType, 'Crowding')
                niceOptStrFields = [niceOptStrFields, 'nLetters', 'DNR'];
            end
            if strcmp(expName, 'ChannelTuning')
                niceOptStrFields = [niceOptStrFields, 'TrainingNoise'];
            end
            if strcmp(modelName, 'Texture')
                niceOptStrFields = [niceOptStrFields, 'textureParams'];
            end
            
            
            
            leg_str = '';
%             net_str_nice = strrep(net_str_nice, ': ', '');
%             net_str_short
%             lineLeg_useNetStr = 0;
%             lineLeg_useOptStr = 0;
            
            switch multiple_lines
                case 'Networks',
                    network_use = sub(allNetworks, set_i);
                    
%                     niceLegendFields = {'filtSizes', 'poolSizes'}; %'doPooling', 'poolSizes', 'poolStrides'}; %'filtSizes', 'doPooling'};
%                     niceNetworkStrFields = [niceNetworkStrFields, multiple_networks]; %#ok<AGROW>
                    
                    lineLeg_useNetStr = 1;  lineLeg_useOptStr = 1;
                case 'Networks_and_wiggleType',
                    [net_i, wiggle_i] = ind2sub([nNetworks, nWiggleTypes], set_i);
                    network_use = sub(allNetworks, net_i);
                    wiggleType = allWiggleTypes{wiggle_i};
                    leg_str = ['[' wiggleType ']'];
                    
                case 'Opts',    
                    letterOpt_use = allLetterOpts(set_i);
                    
%                     leg_str = [net_str_nice '; ' line_str];
                    lineLeg_useNetStr = 0;  lineLeg_useOptStr = 1;
                    
                case 'TrainingNoise', 
                    letterOpt_use.trainingNoise = allTrainingNoise{set_i};
                    
                    niceOptStrFields = [niceOptStrFields, {'TrainingNoise'}];   %#ok<AGROW>
                    lineLeg_useNetStr = 1;  lineLeg_useOptStr = 1;
                   
                case 'FiltSize',
                    network_use.filtSizes = allFiltSizes_C{set_i};
                    
                    lineLeg_useNetStr = 1;  lineLeg_useOptStr = 0;
                     
                case 'PoolSize',
                    network_use.poolSizes = allPoolSizes_C{set_i};
                    lineLeg_useNetStr = 1;  lineLeg_useOptStr = 0;
                    
                case 'PoolingFactor',
                    curPoolingFactor = allPoolingFactors(set_i);
                    lineLeg_useNetStr = 0;  lineLeg_useOptStr = 0;
                    leg_str = sprintf('pooling factor = %.2f', curPoolingFactor);
                    
                case 'FilterFactor',
                    curFilterFactor = allFilterFactors(set_i);
                    lineLeg_useNetStr = 0;  lineLeg_useOptStr = 0;
                    
                    leg_str = sprintf('filter factor = %.2f', curFilterFactor);
                case 'TrainingSNRs', 
                    letterOpt_use.snr_train = allTrainingSNRs{set_i};
                    niceOptStrFields = [niceOptStrFields, {'SNR_train'}];   %#ok<AGROW>
                    lineLeg_useNetStr = 1;  lineLeg_useOptStr = 1;
                case 'Uncertainty',
                    
                    USet = allUncertaintySets{set_i}; 
                     assert(~iscell(USet));
                     if isfield(USet, 'oris')
                         [letterOpt_use.oris, letterOpt_use.xs, letterOpt_use.ys] = deal(USet.oris, USet.xs, USet.ys);
                     end                    
                     
                     if isfield(USet, 'styles')
                         letterOpt_use.fullStyleSet = USet.styles;
                         niceOptStrFields = [niceOptStrFields, {'fontStyles'}]; %#ok<AGROW>
                     else
                         letterOpt_use.fullStyleSet = 'same';
                     end
                     
                     
                     if isfield(USet, 'fonts')
                         letterOpt_use.fullFontSet = USet.fonts;
                     else
                         letterOpt_use.fullFontSet = 'same';
                     end
                    lineLeg_useNetStr = 1;  lineLeg_useOptStr = 1;
                     
                case '',
                    
                    lineLeg_useNetStr = 1;  lineLeg_useOptStr = 0;
                    
                    
                    
            end
            
            

                
            
            for xi = 1:nX
                
                switch x_name
                    case 'Complexity', fontName_use = allFontNames{xi};
                                      
%                         [font_complexities_model(xi), font_complexities_model_indiv(xi,:)] = getFontComplexity(fontName_use, fontSize_use, fontSizeSpec);
                        [font_complexities_model(xi)] = getFontComplexity(fontName_use, fontSize_use, fontSizeSpec);
                        x_vals_C{plot_i}(xi) = font_complexities_model(xi);
                        
                    case 'FontSize', 
                         letterOpt_use.sizeStyle = all_sizeStyles_C{xi};
                         x_vals_C{plot_i}(xi) = all_sizeStyles_C{xi};
                
                    case 'NoiseFreq',
                        switch noiseType
                            case 'band', letterOpt_use.noiseFilter = bandNoiseFilters{xi};
                            case 'lo',   letterOpt_use.noiseFilter = loPassNoiseFilters{xi};
                            case 'hi',   letterOpt_use.noiseFilter = hiPassNoiseFilters{xi};
                        end
                        x_vals_C{plot_i}(xi) = allNoiseFreqs(xi);
                         
                    case 'Uncertainty',
                         USet = allUncertaintySets{xi}; 
                         assert(~iscell(USet));
                         nPos = 1;
                         if isfield(USet, 'oris')
%                              [letterOpt_use.OriXY oris, letterOpt_use.xs, letterOpt_use.ys] = deal(USet.oris, USet.xs, USet.ys);
                            letterOpt_use.OriXY = USet;
%                             xticklabels_C{plot_i}{xi} = getOriXYStr(USet);
                            nPos = nPos * length(USet.oris)*length(USet.xs)*length(USet.ys);
                            xticklabels_C{plot_i}{xi} = num2str(nPos);
                            
                         end                         
                         if isfield(USet, 'fonts')
                             letterOpt_use.fullFontSet = USet;
                         else
                             letterOpt_use.fullFontSet = 'same';
                         end
                         

%                          if strcmp(uncertainty_xlabel_type, 'letterOpt')                     
%                              [~, xticklabels_C{plot_i}{xi}] = getLetterOptsStr(letterOpt_use, 'Uncertainty');
%                          else
%                              xticklabels_C{plot_i}{xi} = uncertainty_labels{xi};
%                          end
%                          x_vals_C{plot_i}(xi) = uncertainty_x_vals(xi);
%                          xticklabels_C{plot_i}{xi} = uncertainty_labels{xi};
                         manualXtickLabels = 1;
                         
                         switch lower(uncertainty_xpos)
                             case 'index',          x_vals_C{plot_i}(xi) = xi; %uncertainty_x_vals(xi);
                                                         xticklabels_C{plot_i}{xi} = getOriXYStr(USet);
                             case 'npositions',     x_vals_C{plot_i}(xi) = nPos;
                             case 'lognpositions',  x_vals_C{plot_i}(xi) = log10(nPos);
                         end

                         
                    case 'FiltSize',
                        network_use.filtSizes = allFiltSizes_C{xi};
                        x_vals_C{plot_i}(xi) = allFiltSizes_C{xi};
                         
                    case 'PoolSize',
                        network_use.poolSizes = allPoolSizes_C{xi};
                        x_vals_C{plot_i}(xi) = allPoolSizes_C{xi};
                        
                    case 'Spacing',  
                        letterOpt_use.crowdingSettings.distractorSpacing = allSpacings_pix(xi);
                        x_vals_C{plot_i}(xi) = allSpacings_pix(xi);
                        
                    case 'Wiggle',
                        if xi > length(allWiggles)  % for multiple plots with different wiggle types, have different number of wiggles in different plots
                            continue;
                        end
                        fontName_use.wiggles = allWiggles{xi};
                        wiggleAngle = getWiggleAngle( allWiggles{xi} );
                        if wiggleAngle == 0
                            wiggleAngle = xtick_wiggle0;
                        end
                        x_vals_C{plot_i}(xi) = wiggleAngle;
                        manualXtickLabels = 1;
                        
                    case 'FontSize_and_FiltSize_and_PoolSize_and_ImageSize',
                        s = allFontSize_and_FiltSize_and_PoolSize_and_ImageSize{xi};
                        letterOpt_use.sizeStyle = s{1};
                        fSize = s{2};
                        pSize = s{3};
                        if curFilterFactor ~= 1
                            if isequal(fSize, [3, 3])
                                fSize = [2.5, 2.5];
                            end
                        end
                        
                        network_use.filtSizes = ceil(fSize * curFilterFactor);
                        network_use.poolSizes = pSize * curPoolingFactor;                        
                        letterOpt_use.imageSize = s{4};
                        x_vals_C{plot_i}(xi) = 2.^(xi-1);
                        xticklabels_C{plot_i}{xi} = sprintf('%s. filt=%d. pool=%d', s{1}, s{2}(1), s{3}(1));
                        
                        manualXtickLabels = 1;
%                             allFontSize_and_FiltSize_and_PoolSize_and_ImageSize

                    case 'SNR',
                        x_vals_C{plot_i}(xi) = 1; % = allSNRs_test;
                        
                    otherwise, error('Invalid x parameter')
                end
                letterOpt_use.fontName     = fontName_use;
                
                letterOpt_use_ideal = letterOpt_use;
%                 if ~strcmp(expName, 'ChannelTuning')
%                     letterOpt_use_ideal.trainingNoise = 'same';
%                 end

                if strcmp(expName, 'Complexity') || strcmp(expName, 'Grouping')
                    letterOpt_use_ideal.trainingNoise = whiteNoiseFilter{1};
                end

                letterOpt_use_ideal.fullFontSet = 'same';  %%% remove this when ideal observer is done calculating.
                letterOpt_use_ideal.trainingFonts = 'same';  
                letterOpt_use_ideal.trainingWiggle = 'same';  
                letterOpt_use_ideal.trainingImageSize = 'same';  
                letterOpt_use_ideal.trainingOriXY = 'same';  

                if strcmp(expName, 'Grouping')
%                 letterOpt_use_ideal.fontName.wiggles = struct('none', 1);
                    if doTextureStatistics && isequal(letterOpt_use_ideal.OriXY, oriXYSet_1x1y21o)
                        letterOpt_use_ideal.OriXY = oriXYSet_10x10y21o;
                    end

                end
%                 letterOpt_use_ideal.OriXY = oriXYSets_1pos;
                
                if letterOpt_use_ideal.doTextureStatistics 
                    letterOpt_use_ideal.doTextureStatistics = false;
                    letterOpt_use_ideal.stimType = 'NoisyLetters'; % get ideal from noisy letters.
                end
                letterOpt_use_ideal.retrainFromLayer = '';  
                letterOpt_use_ideal.trainOnIndividualPositions = false;
%                 letterOpt_use_ideal.classifierForEachFont = false;  %%%% fix this : repeat ideal observer  where classifiers are separate for each font (currently, all A's of diff fonts map to the same output)
                letterOpt_use_ideal.GPU_batchSize = 0;
                letterOpt_use_ideal.blurStd = 0;
                
                if strcmp(expName, 'ChannelTuning')
                    letterOpt_use_ideal.trainingNoise = whiteNoiseFilter{1};
                end
                                
                
%     pctCorr_ideal                   = zeros(nX, nLines, nPlots, 1,       nSNRs_test, 1);
%     pctCorr_model                   = zeros(nX, nLines, nPlots, nTrials, nSNRs_test, 1);
                if getIdeal 
                    [pCorr_ideal_i, pCorr_ideal_i_indiv] = getIdealPerformance(letterOpt_use_ideal, allSNRs_test, opt); 
                    if any(isnan(pCorr_ideal_i))
                        3;
                    end

                    pctCorr_ideal(      xi, set_i, plot_i, 1,         1:nSNRs_test) = pCorr_ideal_i;
%                     pctCorr_ideal_indiv(xi, set_i, plot_i, 1,         1:nSNRs_test, 1:nClassesMax) = pCorr_ideal_i_indiv;
                end
                
%                 loadModelResults(letterOpts, network, allSNRs_test, opt, nTrials
                
                allLetterOpt_use(xi, set_i, plot_i) = letterOpt_use; %#ok<AGROW>

                if any(strcmp(stimType, {'NoisyLetters', 'NoisyLettersTextureStats', 'CrowdedLetters'}))
%                     [pctCorr_model_i, pctCorr_model_indiv_i] = loadModelResults(stimType, fontName_use, allSNRs_test, snr_train, network_use, letterOpt_use, opt, nTrials);
                    [pctCorr_model_i, pctCorr_model_indiv_i] = loadModelResults(letterOpt_use, network_use, allSNRs_test, opt, nTrials);
                   if any(isnan(pctCorr_model_i(1,:)))
                        3;
                    end
                    pctCorr_model(xi, set_i, plot_i, 1:nTrials, 1:nSNRs_test) = pctCorr_model_i;
%                     pctCorr_model_indiv(xi, set_i, plot_i, 1:nTrials, 1:nSNRs_test, 1:nClassesMax) = pctCorr_model_indiv_i;
%                 elseif strcmp(stimType, 'CrowdedLetters')
%                       [pCorr1, pCorr2_v_nDist_spacing_tdr] = loadCrowdingResults(stimType, fontName, all_nDistractors, allSpacings_pix, allTDRs, network_i, crowdedLetterOpts, opt, nTrials);
%                     
                end
                
                if showConvNetFilters 
                    doAllTrials = 0;
                    trial_idxs = iff(doAllTrials, 1:nTrials, 1);
                    
                    for trial_i = trial_idxs

                        trainedModel = loadTrainedModel(letterOpt_use, network_use, trial_i, opt);
                        if ~isempty(trainedModel)
                            convFilters{xi, set_i, plot_i, trial_i} = trainedModel;
                            
                            if opt.alsoGetFullModels 
                                opt_copy = opt; opt_copy.convNetFilterLayer = [];
                                allModules = loadTrainedModel(letterOpt_use, network_use, trial_i, opt_copy);
                                fullModel = recreateModel(allModules);
                                fullModels{xi, set_i, plot_i, trial_i}  = fullModel;
                            end
                            
                            
                        end
                        
                        
                        
                        
                    end
                    
                end
%                                 [pctCorr_ideal(xi, line_i, plot_i, 1,         1:nSNRs_test), pctCorr_ideal_indiv(xi, line_i, plot_i, 1,         1:nSNRs_test, 1:nClassesMax)] = ...
%                     getIdealPerformance(fontName_use, allSNRs_test, noisyLetterOpt_use, opt); 

%                 [pctCorr_model(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test), pctCorr_model_indiv(xi, line_i, plot_i, 1:nTrials, 1:nSNRs_test, 1:nClassesMax)] = ...
%                     loadModelResults(stimType, fontName_use, allSNRs_test, snr_train, network_use, noisyLetterOpt_use, opt, nTrials);
                
                if useProgressBarWhenLoading
                    progressBar;
                end
            end % for all x
            
            
            
            line_legends{set_i} = leg_str;
            if lineLeg_useNetStr 
                [~, net_str] = getNetworkStr(network_use, niceNetworkStrFields); 
                if  strcmp(network_use.netType, 'MLP') && strcmp(modelName, 'Texture')
                    net_str = ['Texture + ', net_str]; %#ok<AGROW>
                end
                
                line_legends{set_i} = appendToStr(line_legends{set_i}, net_str);
            end
            if lineLeg_useOptStr
                [~, opt_str] = getLetterOptsStr(letterOpt_use, niceOptStrFields);
                
                line_legends{set_i} = appendToStr(line_legends{set_i}, opt_str);
            end
            
            
        end % for all lines
        
        % if stuff is common to all lines, put in plot title
        
        line_legends_orig = line_legends;
        [line_legends, line_legends_common] = extractCommonStrings(line_legends, ';.', legends_common_exclude);
        
        allPlotLegends_full_C{plot_i} = line_legends_orig;
        allPlotLegends_C{plot_i} = line_legends;

        if ~isempty(line_legends_common)
            if length(line_legends_common) > 60
                line_legends_common_split = splitDelimStr(line_legends_common, 2, ';');
                allPlotLegends_common_C{plot_i} = line_legends_common_split;
            else
                allPlotLegends_common_C{plot_i} = {line_legends_common};
            end
        else
            allPlotLegends_common_C{plot_i} = {};
        end
        

        
    end % for all plots 
    
    if useProgressBarWhenLoading
        progressBar('done');    
    end
%     fprintf(' done.\n');                
    
    getIdealPerformance('save');
    loadModelResults('save');

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if any(strcmp(y_name, {'Efficiency', 'Threshold_model', 'Threshold_ideal', 'Weibull_slope_model', 'Weibull_slope_ideal', 'Channel_Gain'}))
        fprintf('Calculating Thresholds (& Efficiencies) ...');    
        
        th_model            = zeros(nX, nLines, nPlots, nTrials);
        th_ideal            = zeros(nX, nLines, nPlots, nTrials);
        weibull_slope_model = zeros(nX, nLines, nPlots, nTrials);
        model_efficiences   = zeros(nX, nLines, nPlots, nTrials);
        
        th_model_indiv          = zeros(nX, nLines, nPlots, nTrials, nClassesMax);
        th_ideal_indiv          = zeros(nX, nLines, nPlots, nTrials, nClassesMax);
        model_efficiences_indiv = zeros(nX, nLines, nPlots, nTrials, nClassesMax);
        
        
        %%
        progressBar('init-',nPlots * nLines * nX);
        
        threshold_opts.guessRate = guessRate;
        threshold_opts.th_pct_correct = th_pct_correct;
        for plot_i = 1:nPlots
            for set_i = 1:nLines
                for xi = 1:nX
                                     ...[eff, th_model, th_ideal, weibull_slope_model, weibull_slope_ideal]  
                    pCorr_model_i = reshape( pctCorr_model(xi, set_i, plot_i, 1:nTrials, 1:nSNRs_test), [nTrials, nSNRs_test]);
                    pCorr_ideal_i = reshape( pctCorr_ideal(xi, set_i, plot_i, 1,         1:nSNRs_test), [1, nSNRs_test]);
                    [model_efficiences(xi, set_i, plot_i, 1:nTrials), th_model(xi, set_i, plot_i, 1:nTrials),  ...
                        th_ideal(xi, set_i, plot_i, 1:nTrials), weibull_slope_model(xi, set_i, plot_i, 1:nTrials)] = ...
                        getModelEfficiency(allSNRs_test, pCorr_model_i, pCorr_ideal_i, threshold_opts);

                    
                    if plotIndividualLetterResults
                        for class_i = 1:nClassesMax
                            pCorr_model_indiv_i = reshape( pctCorr_model_indiv(xi, set_i, plot_i, 1:nTrials, 1:nSNRs_test, class_i), [nTrials, nSNRs_test])';
                            pCorr_ideal_indiv_i = reshape( pctCorr_ideal_indiv(xi, set_i, plot_i, 1,         1:nSNRs_test, class_i), [nSNRs_test, 1]);
                            
                            [model_efficiences_indiv(xi, set_i, plot_i, 1:nTrials, class_i), th_model_indiv(xi, set_i, plot_i, 1:nTrials, class_i),  th_ideal_indiv(xi, set_i, plot_i, 1:nTrials, class_i)] = ...
                                getModelEfficiency(allSNRs_test, pCorr_model_indiv_i, pCorr_ideal_indiv_i);
                        end

                    end
                    progressBar;
                                            
                end % for all X
            end % for all lines
        end % for all Plots
        
        progressBar('done');
        
        
        
        
        
        if strcmp(expName, 'Complexity') && strcmp(y_name, 'Threshold_model') && opt.ideal_normalized_thresholds
            for plot_i = 1:nPlots
                for set_i = 1:nLines
                    th_ideal_i = th_ideal(:, set_i, plot_i );
                    th_model_i = th_model(:, set_i, plot_i );
                    
                    gm_ideal = geomean(th_ideal_i);
                    gm_model = geomean(th_model_i);
                    
                    ideal_ratios_i = th_ideal_i / gm_ideal;
                    model_ratios_i = th_model_i / gm_model;
                    %                 th_ideal(:, set_i, plot_i ) = th_ideal(:, set_i, plot_i ) / ideal_ratios_i;
                    
                    th_model(:, set_i, plot_i ) = th_model_i ./ th_ideal_i * gm_ideal;                    
                end
            end
        end
        
        
        switch y_name
            case 'Efficiency',       Y_vals = model_efficiences;
                model_efficiences_M = nanmean(model_efficiences, 4);
            case {'Threshold_model', 'Channel_Gain'},  Y_vals = th_model;  Y_vals_ideal = th_ideal;
            case 'Threshold_ideal',  Y_vals = th_ideal;
            case 'Weibull_slope_model',  Y_vals = weibull_slope_model; 
%             case 'Channel_Gain', 
%                 permuteReshapeData
                                
                
            otherwise,  error('Unknown yname');
                
                
        end
        
        
    elseif strcmp(y_name, 'maxPctCorrect')
        
        
        %%
        
        maxPctCorrect = max( pctCorr_model, [], 5 ); % take max over SNRs tested
                
        Y_vals = maxPctCorrect;        
                
    elseif strcmp(y_name, 'pctCorrect')
        
        Y_vals = pctCorr_model;
        
    else
        error('Unknown y value name');
    end
    
    
    

     Y_vals_M = nanmean(  Y_vals, 4    ); % average over trials
     Y_vals_S = nanstd(   Y_vals, [], 4); % average over trials 

     if strcmp(x_name, 'NoiseFreq') && size(Y_vals_M, 2) == 1
%          idx_rm = (Y_vals_M == 0.01) & [Y_vals_M(2:end); nan] == 0.01;
%          Y_vals_M(idx_rm) = nan;
     end
     
     rescaleXAxesByCriticalSpacing = 1;
     rescaleYAxesByThresholdForOneLetter = 1;
     extendSpacingBeyondLastPoint = true;
     if strcmp(expName, 'Crowding') 

         
         for plot_i = 1:nPlots
             
            if extendSpacingBeyondLastPoint
                %%
                extendSpacingN = 4;
    %             szYVals = size(Y_vals_M); szYVals(1) = 
                Y_vals_M(nX+1:nX+extendSpacingN, :, plot_i, :, :) = repmat(Y_vals_M(nX, :, plot_i, :, :), [extendSpacingN, 1, 1, 1, 1, 1]);
                dx = diff(x_vals_C{plot_i}(1:2));
                %%
                x_vals_C{plot_i} = [vector(x_vals_C{plot_i}); vector(x_vals_C{plot_i}(end) + dx*[1:extendSpacingN]')];

             end
             
             if rescaleYAxesByThresholdForOneLetter
                Y_vals_M(:,:,plot_i) = bsxfun(@rdivide, Y_vals_M(:,:,plot_i), Y_vals_M(end,:,plot_i) );                 
             end
        

             if rescaleXAxesByCriticalSpacing
                 % select a line to use:
                 line_ok = all( ~isnan(Y_vals_M(:,:,plot_i)), 1);
                 idx_line = find(line_ok, 1);
                 if ~isempty(idx_line)
                 
                     Y_vals_use = Y_vals_M(:,idx_line, plot_i);
                     y_cs = min( Y_vals_use ) + (max(Y_vals_use) - min( Y_vals_use ))*.2;

                     idx_x_criticalSpacing = find( Y_vals_use <= y_cs, 1);
        %              x_vals = x_vals / (all_imageSizes_C{1}(2)/2);
        %               x_vals = x_vals / ((all_imageSizes_C{1}(2)/2) + diff(x_vals(1:2)));
                    x_vals_C{plot_i} = x_vals_C{plot_i} / x_vals_C{plot_i}(idx_x_criticalSpacing);
                 end
                 
             end

           

         end
%          Y_vals_M = rescaleBetween0and1(Y_vals_M)*13 + 1;
         3;
         
        
     end
     
     smoothChannels = false;
     
     if strcmp(expName, 'ChannelTuning')  && smoothChannels
         if strcmp(modelName, 'ConvNet')
                smoothChannels_w = .7;
         elseif strcmp(modelName, 'Texture')
                smoothChannels_w = 1;
         end
         fprintf('SMOOTHING CHANNELS ... ');
         logYvals = log10(Y_vals_M);
         logYvals_sm = gaussSmooth(logYvals, smoothChannels_w, 1);
         
         Y_vals_M = 10.^ (logYvals_sm);
     end

     
%       smoothGroupingEfficiency = true;
      smoothGroupingEfficiency = false;
     
     if strcmp(expName, 'Grouping')  && smoothGroupingEfficiency
         if strcmp(modelName, 'ConvNet')
                smoothChannels_w = .0;
         elseif strcmp(modelName, 'Texture')
                smoothChannels_w = .8;
         end
         fprintf('SMOOTHING GROUPING EFFICIENCY... ');
%          logYvals = log10(Y_vals_M);
         Y_vals_M_sm = gaussSmooth(Y_vals_M, smoothChannels_w, 1);
         
         Y_vals_M = (Y_vals_M_sm);
%          Y_vals_M = 10.^ (logYvals_sm);
     end

     
%%
     if strcmp(x_name, 'SNR')
        Y_vals_M = permute(Y_vals_M, [5, 2, 3, 4, 1]);
        Y_vals_S = permute(Y_vals_S, [5, 2, 3, 4, 1]);
        x_vals_C{plot_i} = allSNRs_test;
     end
     3;

  
     if strcmp(expName, 'Efficiency_vs_FontSize') && 0
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
    orderFontsByComplexityNow = false;
    if orderFontsByComplexityNow
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
    
    
    if strcmp(expName, 'Complexity')
        %%
        fprintf('=== Fonts &  Complexities === \n');
        for i = 1:length(allFontNames)
            fprintf('(%d) %12s : %.1f\n', i, allFontNames{i}, font_complexities_model(i)); 
            
        end
        
        
        
    end
%     model_efficiences_expected_avi = 0.97./(font_complexities_model .^ -0.51);
%     
%                     eff_cmp_slope_paper = -1;
%                 eff_cmp_coeff_paper = 9.1;
% 
%                     eff_cmp_slope_avi = -0.51;
%                     eff_cmp_coeff_avi = 0.97;

    
    %%
    
    3;
    
    
    %%
    switch expName
        case 'ChannelTuning', fig_base = 500;
        case 'Crowding',      fig_base = 600;
        case 'Grouping',      fig_base = 700;
        case 'Complexity',    fig_base = 800;
        otherwise,  fig_base = 50;
    end
    
%     niceLegendFields = {'filtSizes', 'poolSizes', 'doPooling'};

    
%     cols = ['bgrk'];
    addSlopesToLegend = true;
        minValidPointsForSlope = 5;
    lineSt = {'-', '--'};
%     mkrs = ['os*v'];
%     colors_use = 'brgbmc';
    colors_use = 'brgmc';
%     colors_use = 'rbgmc';
%     colors_use = 'mkgbrgmc';
    markers_use = 'oxs*dph';
    lineStyles_use = {'-', ':'};
    idx_notBraille = find(~strcmp(allFontNames, 'Braille'));
    letters_charU = 'A':'Z';
    letters_charL = 'a':'z';
    mk_size = 7;
    line_w = 2;
    
    if useLargePlotFontSizes
        mk_size = 10;
        line_w = 3;
    end
        
    
    
    switch expName
        
        case 'Crowding',
            switch modelName
                case 'ConvNet',
                case 'Texture',  colors_use = 'brgmc';
                    
            end
            
            
            
    end
    
       
%     plotHumanEfficiencyLineFit = true; 
    plotHumanDataPoints = justShowHumanData;
    plotLineFit_human = true; % && any(strcmp(yvsx_name, {'Efficiency_vs_Complexity', 'Threshold_model_vs_NoiseBand', 'Threshold_model_vs_Spacing'}));
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
    color_idx_start = 1;    nColors_use = 4;
    marker_idx_start = 1;   nMarkers_use = 1;
    line_idx_start = 1;     nLineStyles_use = 3;
    
%     all_colors_idx = mod([1:nLines] + color_idx_start-2, length(colors_use))+1;
%     all_markers_idx = mod( ceil([1:nLines]/length(colors_use)) + marker_idx_start-2, length(markers_use))+1;
    colorsFirst = false;

    if colorsFirst
        [color_idxs, marker_idxs, line_idxs] = ind2sub([nColors_use, nMarkers_use, nLineStyles_use], 1:nLines);
    else
        [marker_idxs, color_idxs, line_idxs] = ind2sub([nMarkers_use, nColors_use, nLineStyles_use], 1:nLines);
    end
    
    color_idxs_use = color_idxs + color_idx_start -1;
    marker_idxs_use = marker_idxs + marker_idx_start -1;
    line_idxs_use = line_idxs + line_idx_start - 1;
    
    all_colors = color_s(color_idxs_use, colors_use);
    
    all_markers = marker(marker_idxs_use, markers_use);
    all_lines = linestyle(line_idxs_use, lineStyles_use);
    if ~iscell(all_lines)
        all_lines = {all_lines};
    end
    
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
    if useLargePlotFontSizes
%         label_fontSize = 18;
%         legend_fontSize = 14;
        label_fontSize = 14;
%         legend_fontSize = 11;
        legend_fontSize = 9;
        title_fsize = 10;
%         title_fsize = 14;
    else
        label_fontSize = 10;
        legend_fontSize = 8.5;
        title_fsize = 10;
    end        
    
    
    for plot_i = 1:nPlots
        
        figure(fig_base + plot_i + fig_offset); 
        clf; 
        if ~makeWideAxes
            subplotGap(1,2,1,1); 
        end
        hold on; box on;
        h_ax(plot_i) = gca;

        if strcmp(expName, 'ChannelTuning')
              [x_noiseFreq_fit, y_threshold_fit, x_noiseFreq_pts, y_threshold_pts] = getHumanChannelData(fontName_use);
        elseif strcmp(expName, 'Grouping')
              [x_wiggle_fit_human, y_efficiency_fit_human, x_wiggle_human_pts, y_efficiency_human_pts] = getHumanSnakeWiggleData(grouping_axes, grouping_data);
        elseif strcmp(expName, 'Complexity')
            
            human_useAviPts = true;
            
            if human_useAviPts
                
            else
                human_plotAllFonts = true;
                if human_plotAllFonts
                    allFontNames_human = setdiff( fieldnames(getStatsFromPaper), {'Checkers4x4', 'words3', 'words5', 'words5_many'});
                else
                    allFontNames_human = allFontNames_std;
                end
                %     idx_model_fonts = cellfun(@(fn) find(strcmp(fn, allFontNames_human),1), allFontNames);
                nFonts_human = length(allFontNames_human);
                [human_efficiencies, human_thresholds, human_efficiencies_stderr, font_complexities_human] = deal( zeros(1, nFonts_human) );
                for fi = 1:nFonts_human
                    human_thresholds(fi) = getStatsFromPaper(allFontNames_human{fi}, 'threshold');
                    human_efficiencies(fi) = getStatsFromPaper(allFontNames_human{fi}, 'efficiency');
                    human_efficiencies_stderr(fi) = getStatsFromPaper(allFontNames_human{fi}, 'efficiency_stderr_est');
                    font_complexities_human(fi) = getStatsFromPaper(allFontNames_human{fi}, 'complexity');
                end

            end
            

            
            
            
            

   
        elseif strcmp(x_name, 'FontSize')
            [x_deg, human_eff_0, human_eff_5deg] = getHumanSizeData();
            human_x = x_deg;
            human_y = human_eff_0;
            human_s = nan(size(human_eff_0));
        
        elseif strcmp(x_name, 'Spacing')
            [x_spacing_fit, y_threshold_fit, x_spacing_pts, y_spacing_pts] = getHumanCrowdingVsEccentricity();
%             human_x = x_spacing;
%             human_y = y_threshold;
%             human_s = nan(size(human_y)); 
        end
        

        human_line_str = {};
        h_human_line = [];
        
        if plotLineFit_human 
            if strcmp(expName, 'Complexity') % straight line
                
                eff_cmp_slope_paper = -1;
                eff_cmp_coeff_paper = 9.1;
                
                eff_cmp_slope_avi = -0.51;
                eff_cmp_coeff_avi = 0.97;

                
%                 font_complexities_human_srt = lims(font_complexities_human);
%                 font_complexities_human_srt = [10, 1000];
                font_complexities_human_srt = logspace(1, 3, 10); %[10, 1000];
                human_efficiencies_fit = eff_cmp_coeff_paper .* (font_complexities_human_srt .^ (eff_cmp_slope_paper));
        %     plot(font_complexities_human, human_efficiencies, 'k^', 'linewidth', 2, 'markersize', 8)
                h_human_line = plot(font_complexities_human_srt, human_efficiencies_fit, 'k-', 'linewidth', 3);
                
                human_line_str = {'Human performance (fit)'};
                
                if complexity_addAviSlope
                    
                    human_efficiencies_fit_avi = eff_cmp_coeff_avi .* (font_complexities_human_srt.^(eff_cmp_slope_avi));
                    h_human_line(2) = plot(font_complexities_human_srt, human_efficiencies_fit_avi, 'r-', 'linewidth', 3);

                    human_line_str{2} = 'Human performance [Avi] (fit)';
                end
                
            elseif strcmp(expName, 'ChannelTuning') % curve
                %%
%                 clf; hold on;
%                 h_human_line = plot(x_noiseFreq, y_threshold, 'ro-', 'linewidth', 6, 'markersize', 12);
%                 y_threshold_sm = gaussSmooth(y_threshold, .6);
%                 y_threshold_sm(end) = y_threshold(end);
%                 y_threshold_sm(1) = y_threshold(1);
                
                h_human_line = plot(x_noiseFreq_fit, y_threshold_fit, 'k-', 'linewidth', 6, 'markersize', 1);
                human_line_str = {'Human performance (fit){\color{white}xxxxxxxxxxxxxx}'};
                set(h_ax(plot_i), 'yscale', 'log', 'xscale', 'log')
            elseif strcmp(expName, 'Grouping') && strcmp(y_name, 'Efficiency') % curve
                human_line_w = 3;
                if useLargePlotFontSizes
                    human_line_w = 6;
                end
                h_human_line = plot(x_wiggle_fit_human, y_efficiency_fit_human, 'k-', 'linewidth', human_line_w, 'markersize', 1);
                if length(h_human_line) == 2
                    set(h_human_line(2), 'color', 'r');
                end
                human_line_str = cellfun(@(s) ['Human performance (fit) (' s ')'], grouping_data, 'un', 0);

            elseif strcmp(expName, 'Crowding')
                h_human_line = plot(x_spacing_fit, y_threshold_fit, 'k-', 'linewidth', 6);
                human_line_str = {'Human performance (fit)'};
                
                
            end
                
        end

        
        
        if plotHumanDataPoints
%%

            if strcmp(expName, 'Crowding')
                h_human_pts = plot(x_spacing_pts, y_spacing_pts, 'o', 'color', .6*[1, 1, 1], 'markersize', 12, 'linewidth', 2);
                human_pts_str = {'Human performance'};
                
            elseif strcmp(expName, 'ChannelTuning')

        %         plot(font_complexities_human, human_efficiencies, 'k:^', 'linewidth', 2, 'markersize', 8)
                h_human_pts = plot(x_noiseFreq_pts, y_threshold_pts, 'o', 'color', [0 .6, 0], 'markersize', 12, 'linewidth', 2);
                if ~plotEfficiencyConnectingLine_human
                    set(h_human_pts, 'lineStyle', 'none')
                end
                human_pts_str = {'Human performance'};
                3;

            elseif strcmp(expName, 'Complexity')
               
                h_human_pts = plot(font_complexities_human, human_efficiencies, 'o', 'color', [0 .6, 0], 'markersize', 12, 'linewidth', 2);
                human_pts_str = {'Human performance'};
                
            elseif strcmp(expName, 'Grouping')
                h_human_pts = plot(x_wiggle_human_pts, y_efficiency_human_pts, 'o', 'color', [0 .6, 0], 'markersize', 12, 'linewidth', 2);
                human_pts_str = {'Human performance'};    
                
            end
            
            
            
            
        else
            h_human_pts = [];
            human_pts_str = {};
        end
        3;
        
        
        if displayValuesOfPlots
            fprintf('\n ========= \n Plot %d : %s\n', plot_i, plotTitle{plot_i});
        end
        
        for set_i = 1:nLines

%         line_s = lineSt{ floor(net_i/6)+1};

%             line_s = iff( plotEfficiencyConnectingLine_model, '-', ''); %linestyle( floor(net_i/6) );
    %         mkr_s = 'o'; marker(net_i, markers_use);   % marker( floor(net_i/6)+2);
    %         mkr_s = marker( net_i+1 );
    %         clr_s = color_s(net_i, colors_use);
            clr_s = all_colors(set_i);
            mkr_s = all_markers(set_i);
            line_s = all_lines{set_i};

            
            nValidPoints = nnz( ~isnan(Y_vals_M(:, set_i, plot_i)));
            
            [log_slope, log_slope_ci, p_fit] = getLogSlope(font_complexities_model, Y_vals_M(:, set_i, plot_i) );
            [log_slope_noB, log_slope_noB_ci, p_fit_noB] = getLogSlope(font_complexities_model(idx_notBraille), Y_vals_M(idx_notBraille, set_i, plot_i) );

% model_efficiences = zeros(nX, nLines, nPlots, nTrials, 1);
            if ~plotIndividualLetterResults

                x_vals_use = x_vals_C{plot_i};
                y_M = Y_vals_M(:, set_i, plot_i);
                y_S = Y_vals_S(:,set_i, plot_i);
                
                if strcmp(y_name, 'Channel_Gain')
                    filtType = allLetterOpt_use(xi, set_i, plot_i).noiseFilter.filterType;
                    if any(strcmp(filtType, {'hi', 'lo'}))
                        [x_vals_use, y_M] = getChannelFromThresholds(x_vals_use, y_M, filtType);
                    end
                    3;
                    
                end
                
                
    %             font_complexities_model_mtx = repmat(font_complexities_model(:), 1_S, nFonts);
                if (nTrials > 1) && any(Y_vals_S(:,set_i, plot_i) > 0)  && showErrorBarsForMultipleTrials_model
    %                 h(net_i) = errorbar(x_vals, all_pCorr1_M(:,line_i), all_pCorr1_S(:,line_i), [mkr_s clr_s '-'], 'markersize', 8);

                    h_model_pts(plot_i, set_i) = errorbar(x_vals_use, y_M, y_S, [clr_s mkr_s line_s]);
                else
                    h_model_pts(plot_i, set_i) = plot(x_vals_use, y_M, [clr_s mkr_s line_s]);
                end            
                set(h_model_pts(plot_i, set_i), 'markersize', mk_size, 'linewidth', line_w)

                if plotEfficiencyLineFit_model
                    eff_fit_i = 10.^ polyval(p_fit, log10(font_complexities_model) );
                    h_model_fit(plot_i) = plot(font_complexities_model, eff_fit_i, [clr_s '-'], 'linewidth', line_w);
                end
                
                if displayValuesOfPlots
                    %%
                    fprintf('    line %d : %s  [ %s ] \n', set_i, allPlotLegends_C{plot_i}{set_i}, allPlotLegends_common_C{plot_i}{1} );
                    fprintf('       X : %s\n', sprintf('%12.7f,  ', x_vals_use));
                    fprintf('       Y : %s\n', sprintf('%12.7f,  ', y_M));
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
                xlabel('Letter Complexity / Mean Font Complexity', 'fontsize', label_fontSize)
                ylabel('Letter Efficiency / Mean Font Efficiency', 'fontsize', label_fontSize)
                legend(allFontNames, 'fontsize', legend_fontSize)

            end

    %         alpha = .05;

            if strcmp(expName, 'Complexity') && (strcmp(y_name, 'Efficiency') || strncmp(y_name, 'Threshold', 9))
%                 rms_i = rms(log10(model_efficiences_M(:,set_i, plot_i)) - log10(model_efficiences_expected) );
%                 meanDist_i = mean(log10( model_efficiences_M(:,set_i, plot_i)) - log10(model_efficiences_expected) );
%                 abs_i = mean(abs(log10(model_efficiences_M(:,set_i, plot_i)) - log10(model_efficiences_expected) ));
% 
%                 allRMS(set_i) = rms_i;
%                 allMeanDists(set_i) = meanDist_i;
%                 allABS(set_i) = abs_i;
%                 allLogSlope(set_i) = log_slope;
%                 allLogSlope_ci(:,set_i) = log_slope_ci;
%                 allLogSlope_noB(set_i) = log_slope_noB;
%                 allLogSlope_noB_ci(:,set_i) = log_slope_noB_ci;


                line_legend = allPlotLegends_C{plot_i}{set_i};
%                 fprintf('%s : rms log10 error = %.3f. (%.3f)  log_slope = %.2f.  (without braille: %.2f) \n', line_legend, rms_i, abs_i, log_slope, log_slope_noB);
%                 fprintf('%s : rms log10 error = %.3f. (%.3f)  log_slope = %.2f.  (without braille: %.2f) \n', line_legend, rms_i, abs_i, log_slope, log_slope_noB);
                if ~isnan(log_slope) && addSlopesToLegend && nValidPoints >= minValidPointsForSlope

                    allPlotLegends_C{plot_i}{set_i} = sprintf('%s [%.2f]', line_legend, log_slope);
                end
            end
            3;
    %         rms(log10(model_efficiences_M(:,:,plot_i) - log10(human_efficiencies)) );
    %         fprintf('%s : ', )
        end
        
        
        
        alsoPlotIdeal = strcmp(expName, 'ChannelTuning') ||  strcmp(expName, 'Crowding') ...
             || strcmp(y_name, 'Threshold_model');
%         alsoPlotIdeal = 0;
        alsoPlotIdeal= 1;
        h_ideal = [];
        leg_ideal_C = {};
            
        if alsoPlotIdeal
            %%
            th_ideal_M = nanmean(nanmean(th_ideal, 2), 4);
            th_ideal_use = th_ideal_M(:,1,plot_i); %take data for this plot, 1st set, 1st trial
             
            if strcmp(y_name, 'Efficiency')
                vals_ideal = ones(size(th_ideal_M));
            elseif strncmp(y_name, 'Threshold', 9)
                vals_ideal = th_ideal_M;                
            end
            
            
            switch expName
                case 'ChannelTuning',
%                     th_ideal            = zeros(nX, nLines, nPlots, nTrials);
                   
                    h_ideal = plot(x_vals_C{plot_i}, vals_ideal, 'o:', 'linewidth', 3, 'color', .6*[ 1,1,1]);

                    set(h_ideal, 'lineWidth', 3, 'linestyle', '-')
                
                case {'Crowding'}
                    vals_ideal = ones(1, length(x_vals_C{plot_i}));
                    h_ideal = plot(x_vals_C{plot_i}, vals_ideal, 'ko-', 'linewidth', 2, 'color', .2*[1,1,1]);
                    
                case {'Grouping'}
                 
    %                 th_ideal_M = th_ideal_M / mean(th_ideal_M);
                    if strcmp(y_name, 'Efficiency')
%                         th_ideal_use  = th_ideal_use/th_ideal_use(1)*.25;
                    end
                    h_ideal = plot(x_vals_C{plot_i}, th_ideal_use, 'ko-', 'linewidth', 2, 'color', .2*[1,1,1]);
             
                case 'Complexity',
    %             leg_ideal_C = {'Ideal (White Noise)'};

%                     th_ideal_M = ones(1, nFonts);
%                     th_ideal_use = th_ideal_M;
                    h_ideal = plot(x_vals_C{plot_i}, vals_ideal, 'ko-', 'linewidth', 3, 'color', .6*[1,1,1]);

                
            end
            
            
            if displayValuesOfPlots
                fprintf('    IDEAL OBSERVER :\n');
                fprintf('       X : %s\n', sprintf('%12.7f,  ', x_vals_C{plot_i}));
                fprintf('       Y : %s\n', sprintf('%12.7f,  ', th_ideal_use));
            end

            combined_tmp_str = iff(opt.ideal_useCombinedTemplates, ' (Combined Templates)', '');
            leg_ideal_C = {['Template Matcher' combined_tmp_str]};
            
        end
        
%%
        legend_strs_plot_i = [allPlotLegends_C{plot_i}(:); human_pts_str{:}; human_line_str(:); leg_ideal_C(:) ];
%         leg_location = 'best';
        leg_location = 'bestOutside';
%         leg_location = 'southOutside';
%         leg_location = 'NE';
        3;
%         leg_location = 'SW';
        %%
        
%         h_legend = legend([h_human_pts, h_human_fit, h_model_pts(plot_i,:) h_ideal], legend_strs_plot_i, ...
%             'location', leg_location, 'fontsize', 10, 'edgecolor', 'w');
        
%         legend_strs_plot_i = flipud(legend_strs_plot_i);
        
        %%
        if doLabelsForPaper && ~justShowHumanData

            
            switch expName
                
                case 'Crowding',
                    switch modelName
                        case 'ConvNet'
                            legend_strs_plot_i{1} = 'ConvNet';
                        case 'Texture'
                            legend_strs_plot_i{1} = 'Texture model';
                    end
            
                case 'ChannelTuning',
                    switch modelName
                        case 'ConvNet'
                            legend_strs_plot_i{1} = 'ConvNet (trained on 1/f noise)';
                            legend_strs_plot_i{2} = 'ConvNet (trained on white noise)';
                        case 'Texture',
                            legend_strs_plot_i{1} = 'Texture model (trained on 1/f noise)';
                            legend_strs_plot_i{2} = 'Texture model (trained on white noise)';
                    end
                case 'Complexity',
                    
                    switch modelName,
                        case 'ConvNet',
                            legend_strs_plot_i{2} = 'ConvNet: pooling = 8x8';
                            legend_strs_plot_i{1} = 'ConvNet: no pooling';
                        case 'Texture',
                            legend_strs_plot_i{1} = 'Texture model';
                    end
                       
                        
                case 'Grouping',
                    
                    switch modelName,
                        case 'ConvNet',
                            legend_strs_plot_i{1} = 'ConvNet';
                        case 'Texture',
                            legend_strs_plot_i{1} = 'Texture model';
                    end
                       
                    
                    
            end
            
     
            
%             for i = 1:length(legend_strs_plot_i)
%                 legend_strs_plot_i{i} = strrep(legend_strs_plot_i{i}, 'ConvNet. Tr', 'ConvNet tr');
%             end
%             
            
            
            
            if strcmp(x_name, 'Complexity') && strcmp(netType, 'ConvNet')
    %             legend_strs_plot_i{1} = 'ConvNet: pooling = 4x4';
    %             legend_strs_plot_i{2} = 'ConvNet: no pooling';
            elseif strcmp(x_name, 'NoiseFreq') && strcmp(netType, 'ConvNet')
    %             legend_strs_plot_i{1} = 'ConvNet trained on 1/f noise';
    %             legend_strs_plot_i{2} = 'ConvNet trained on white noise';
            elseif strcmp(x_name, 'Spacing')
    %             legend_strs_plot_i{1} = 'ConvNet';
            end
            
        end
        %%  
        
        preserveAxesLocation = 1 && ~makeWideAxes; %strcmp(expName, 'Grouping');
        if preserveAxesLocation
            ax_pos = get(h_ax(plot_i), 'position');
        end
        
%         h_human_line(1:min(end,1)),
        h_legend = legend([h_model_pts(plot_i,:), h_human_pts(1:min(end,1)), h_human_line(:)', h_ideal], legend_strs_plot_i, ...
            'location', leg_location, 'interpreter', 'none', 'fontsize', legend_fontSize, 'edgecolor', 'w', 'interpreter', 'tex');
        
        
        if justShowHumanData
            %%
            h_legend = legend([h_human_pts, h_human_line, h_ideal], legend_strs_plot_i(2:end), 'location', leg_location, 'interpreter', 'none', 'fontsize', legend_fontSize, 'edgecolor', 'w', 'interpreter', 'tex');
            set(h_model_pts, 'visible', 'off')
        end
        
        
        if preserveAxesLocation
            x_offset = 0;
            if strcmp(expName, 'Grouping') && strcmp(grouping_axes, 'offset'),
                x_offset = .2;
            elseif strcmp(expName, 'Complexity')
                x_offset = -.03;
            end
            leg_pos = get(h_legend, 'position');
            leg_new_L = ax_pos(1) + ax_pos(3) + .02 + x_offset;
            leg_new_B = ax_pos(2) + ax_pos(4) - leg_pos(4);
            set(h_legend, 'position', [leg_new_L,  leg_new_B, leg_pos(3:4)]);
%             set(h_ax(plot_i), 'position', ax_pos);
        end

%%
%         h_legend = legend([h_ideal h_human_line], {'Template matcher', 'Human performance'}, ...
%             'location', leg_location, 'interpreter', 'none', 'fontsize', legend_fontSize, 'edgecolor', 'w');
        
        %%
        if 0
            %%
            set(h_model_pts(1), 'lineWidth', 3)
            set(h_model_pts(2), 'lineWidth', 2, 'linestyle', '--')
            
        end
        
        if ~(plotIndividualLetterResults && plotIndivLettersRelativeToMean)
            %%
            x_log_scale = any(strcmp(x_name, {'NoiseFreq', 'Complexity', 'FontSize_and_FiltSize_and_PoolSize_and_ImageSize', 'Wiggle'})) && ...
                (~strcmp(expName, 'Grouping') || strcmp(grouping_axes, 'log') );
            
            y_log_scale = any(strcmp(y_name, {'Efficiency', 'Threshold', 'Threshold_model', 'Threshold_ideal', 'Channel_Gain'})) && ...
                (~strcmp(expName, 'Grouping') || strcmp(grouping_axes, 'log') );
            
            if x_log_scale
                set(h_ax(plot_i), 'xscale', 'log');
            end            
            if y_log_scale
                set(h_ax(plot_i), 'yscale', 'log');
            end
            
        %     set(h_ax(plot_i), 'ylim', [.02, 1], 'xlim', [20, 100]);
            % set(h_ax(plot_i), 'ylim', [.01, 1], 'xlim', [10, 100]);
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
            
            xlims = [];
            ylims = [];

            
            if strcmp(expName, 'ChannelTuning')
%                 xlims = [.1, 100];
%                 ylims = [.01, 1000]; 
%                 ylims = [.1, 10000];

                xlims = [.5/sqrt(2), 16*sqrt(2)];
%                 xlims = [.1, 100];
%                 ylims = [.1, 2000]; 
%                 ylims = [1, 3000]; 
                ylims = [1, 10000]; 
                
                if strcmp(modelName, 'Texture')
                   ylims = [.01, 5e4]; 
                end

            elseif strcmp(expName, 'Complexity')
                xlims = [10, 1000];
%                 ylims = [.01, 1];              
                if strcmp(y_name, 'Efficiency')
                    ylims = [0.001, .21];

                elseif strncmp(y_name, 'Threshold', 9)
                    ylims = [1, 1000];
                end
                    
%                 ylims = [.001, 1]; 
                
                
%                 ylims = [.005, 1];              
            elseif strcmp(expName, 'Grouping')
                
                if strcmp(grouping_axes, 'log')
                    xlims = [7.9, 100.5];
                    if strcmp(y_name, 'Efficiency')
                        ylims = [0.008, .21];
                    elseif strncmp(y_name, 'Threshold', 9)
                        ylims = [1, 1000];
                    end
                elseif strcmp(grouping_axes, 'linear')
                    xlims = [-2, 92];
                    if strcmp(y_name, 'Efficiency')
                        ylims = [0.008, .21];
                        ylims = [0.01, .085];
                        ylims = [0.00, 0.12];
                        ylims = [0.00, 0.18];
                        if strcmp(modelName, 'Texture')
                            ylims = [0.00, 0.05];
                        end
                        
                    elseif strncmp(y_name, 'Threshold', 9)
                        ylims = [1, 1000];
                    end
                end
%                 ylims = [.01, 1];              
%                 ylims = [.01, 1];              
%                 ylims = [.005, 1];              

            elseif strcmp(x_name, 'Uncertainty')
%                 xlims = [min(x_vals_C{plot_i})-1, max(x_vals_C{plot_i})+1];  
                xlims = [-.1, 1.8];
%                 ylims = 
            
            elseif strcmp(expName, 'Crowding')
                xlims = [0, 2];
%                 ylims = [10, 1e6];
                ylims = [.1, 100];
            elseif any(strcmp(x_name, {'FontSize', 'FontSize_and_FiltSize_and_PoolSize_and_ImageSize'}) )
                xlims = lims(x_vals_C{plot_i}, .1, [], x_log_scale);
                ylims = [.01, 1];
                
                
            end
            
            expandXLimitsForData = 0;
            expandYLimitsForData = 1;
            
            if expandXLimitsForData
                xlims = lims(xlims, x_vals_C{plot_i});
            end
            if expandYLimitsForData
%                 ylims = lims([ylims(:); nonnans( Y_vals_M(:))]);
                
            end
            
            
            if ~isempty(xlims)
                set(h_ax(plot_i), 'xlim', xlims)
            end
            if ~isempty(ylims)
                set(h_ax(plot_i), 'ylim', ylims);
            end
            setLogAxesDecimal;
            
            %%

            xticks = x_vals_C{plot_i};
%             set(h_ax(plot_i), 'position', [0.1300    0.1211    0.4503    0.8039]); %*************
            y_label_str = y_name;
            switch y_name
                case 'Threshold_model', 
                    if strcmp(x_name, 'NoiseFreq')
                        y_label_str = 'Threshold';
                    elseif strcmp(x_name, 'Spacing')
                        y_label_str = 'Threshold re that for 1 letter';
                    end
%                 otherwise, y_label_str = y_name;
            end
            ylabel(y_label_str, 'fontsize', label_fontSize, 'interpreter', 'none');
            
            
            xlabel_str = x_name_nice;
            switch x_name,
                case 'Complexity', xlim([10, 1000]);
                case 'FontSize', xlim( lims(all_sizeStyles, .5, [], 1) )
                case 'NoiseFreq', xlabel_str = 'Noise frequency (c/letter)';
                case 'Wiggle', 
                    %%
                    if strcmp(grouping_axes, 'log')
                        
%                         xticks = [xtick_wig0, 5, 10, 15, 25, 40, 60, 90];
%                         xticks_show = xticks; xticks_show(xticks_show == xtick_wig0) = 0;
                        
%                         xticklabels = arrayfun(@num2str, xticks_show, 'un', 0);
%                         wiggle_lims = lims(xticks, .05, [], 1);

                        xticks =      [1:10, 20:10:100, 200:100:1000];
                        xticks_show = [8, 10, 20, 30, 40, 50, 60, 70, 90];

                        ticks_show = arrayfun(@(tk) any(tk == xticks_show), xticks);
                        xticklabels_C{plot_i} = arrayfun(@num2str, xticks, 'un', 0);
                        %%
                        xticklabels_C{plot_i}(~ticks_show) = {''};
                        xticklabels_C{plot_i}{ find(xticks == xtick_wiggle0, 1) } = '0';


                    elseif strcmp(grouping_axes, 'linear')
                        
                        xticks =      [0:10:90];
                        xticklabels_C{plot_i} = arrayfun(@num2str, xticks, 'un', 0);                        
                    end
                    
                    if strcmp(multiple_plots, 'WiggleType')
                        xlabel_str = [xlabel_str ' (' allWiggleTypes{plot_i} ')'];
                    else
                        xlabel_str = [xlabel_str ' (' wiggleType ')'];
                    end
%                     set(h_ax(plot_i), 'xtick', xticks, 'xticklabel', xticklabels)
            end
            xlabel({[xlabel_str xlabel_suffix], allFonts_list_C{:}}, 'fontsize', label_fontSize)
            
            if manualXtickLabels
                set(h_ax(plot_i), 'xtick', xticks, 'xticklabel', xticklabels_C{plot_i});
            end
            
            switch y_name
%                 case 'Efficiency', ylim([.01, 1]);
%                 case ''
            end
    %         

%     ylim([.01 5e4]); decades_equal([], 3.5)
    
        end
        
        
        %%
        if x_log_scale && y_log_scale
            if strcmp(expName, 'Complexity')        
                decades_equal([], 1.3);
            elseif strcmp(expName, 'ChannelTuning')        
                decades_equal([], 2);
            end

        end
        trainErrStr = iff(opt.useTrainingError, ' [Using TRAINING error]. ', '');
        addOptsAndSize = 0;
        
        optSizeStr_C = iff(addOptsAndSize, {[strrep(opt_str, '_', ', ')  ' (Size = ' sizeStyle ')'] }, {});
        
%         optSizeStr_C = {};
        title_str = [expName ': ' strrep(yvsx_name, '_', ' ') ];
        if strcmp(x_name, 'NoiseFreq') && strcmp(y_name, 'Threshold_model')
            title_str = ['Filter Gain : ' fontName_use ' : ' sizeStyle ' : ' sprintf('[%dx%d]', imageSize)];
            
        elseif strcmp(x_name, 'Complexity') && strcmp(y_name, 'Efficiency')
%             title_str = 'Efficiency vs Complexity';
            title_str = ['Efficiency vs Complexity '];
            
        elseif strcmp(expName, 'Grouping')
%            title_str = [title_str '. Trained on: ' grouping_trainOn]; 
%            title_str = [title_str ' : ' sizeStyle ' : ' sprintf('[%dx%d]', imageSize)]; 
        elseif strcmp(expName, 'Crowding')
           title_str = [title_str ' : ' fontName_use];
            
        elseif strcmp(expName, 'Uncertainty') 
            title_str = [title_str ' : ' fontName_use]; 
            
        end
        title_str = [title_str ' : ' sizeStyle ' : ' sprintf('[%dx%d]', imageSize)];
%         decades_equal;
           
        drawnow;
        if ~doLabelsForPaper
%             if strcmp(plotTitle{plot_i}, 'Trained on: White noise')
%                 plotTitle{plot_i} = 'Trained on: White noise^{ }';
%             end
            pTitle = iff(isempty(plotTitle{plot_i}), {}, plotTitle(plot_i));
            title({[ title_str trainErrStr ], pTitle{:}, allPlotLegends_common_C{plot_i}{:}, optSizeStr_C{:}}, 'fontsize', title_fsize);
            
            
            
            if preserveAxesLocation
                ax_pos = get(h_ax(plot_i), 'position');
                leg_pos = get(h_legend, 'position');
                leg_new_L = ax_pos(1) + ax_pos(3) + .02 + x_offset;
                leg_new_B = ax_pos(2) + ax_pos(4) - leg_pos(4);
                set(h_legend, 'position', [leg_new_L,  leg_new_B, leg_pos(3:4)]);
                %             set(h_ax(plot_i), 'position', ax_pos);
            end

        end
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
        drawnow;
        if ~isFigureDocked(gcf)
%             set(gcf, 'position', [338         336        1116         572]);
            set(gcf, 'position', [338         336        950, 390]); % for grouping figures for denis
        3;
%             set(gcf, 'position', [381, 477, ])
            
%                 pos_legend = get(h_legend, 'position');  %             0.5496    0.6225    0.3537    0.3022
%             pos_legend(1) = 0.54;
%             set(h_legend, 'position', pos_legend);
        end
        
%         set(gcf, 'position', [814   329   730   412]);

%         set(gca, 'units', 'pixels', 'position', [101    55   348   327]);


%         set(gca, 'units', 'pixels', 'position', [101    55   348   357]); % *****
        
        %%
%         if strcmp(x_name, 'NoiseFreq') && length(h_model_pts) == 3
%             set(h_model_pts, 'linewidth', 1)
%             set(h_model_pts(3), 'linewidth', 2)
%             
%         end
        %%
% %         set(gca, 'units', 'pixels', 'position', [135    44   585   300]);
%         set(gcf, 'position', [366         414        1234         404]);
        
%         237     4   731   487
        3;

    3;
        if showConvNetFilters 
            %%
%             letterSizeUse = letterOpt_use.sizeStyle;
            letterSizeUse = 'k30';

%             fontNameUse = letterOpt_use.fontName;
            fontNameUse = 'Bookman';
            
            clf; 
            [fontPointSize, fontXheight, fontKheight] = getFontSize(fontNameUse, letterSizeUse);
            fontHeight = fontXheight;
            h_axx3 = [];
        %     m = floor(sqrt(nNetworks));

            
            filterFigOffset = 100;
            curFilterFigId = filterFigOffset + plot_i;
            figure( curFilterFigId ); 
            clf; 
        %     m = floor(sqrt(nNetworks));
        %     n = ceil(nNetworks/m);
            tileSquare = 1;

%             plotFiltersFrom = 'x';
            plotFiltersFrom = 'lines';
            switch plotFiltersFrom
                case 'lines', 
                    nFiltSets = nLines;
                    xi = 1;
                case 'x',    
                    nFiltSets = nX;
                    line_i = 1;
            end

            addPlotTitles = nPlots > 1;


%             i = 1;
            for set_i = 1:nFiltSets
    %             for fi = 1:nFonts
    %                 h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); 

                line_legends_common_split = splitDelimStr(line_legends_common, 2, ';');

                switch plotFiltersFrom
                    case 'lines', line_i = set_i;
                        
                        line_leg = strsplit( line_legends{set_i}, '; ');
                        line_leg = strsplit( line_leg{1},  '. ' );
%                         setTitles{set_i} = line_leg{2}; %#ok<AGROW>
                        
                        setTitles{set_i} = line_legends{set_i}; %#ok<AGROW>
                        
                        
                        
                    case 'x',     xi     = set_i;
                        setTitles{set_i} = tostring(x_vals_C{plot_i}(xi)); % allFontNames{xi}; %#ok<AGROW>
                        
                end
                if addPlotTitles
                    setTitles_withSize{set_i} = {[plotTitle{plot_i} ' : ' letterSizeUse], line_legends_common_split{1}, setTitles{set_i}};
                    setTitles_withoutSize{set_i} = {plotTitle{plot_i} , line_legends_common_split{1}, setTitles{set_i}};
                else
                    setTitles_withSize{set_i} = [plotTitle{plot_i} ' : ' fontNames_use ', ' letterSizeUse];
                    setTitles_withoutSize{set_i} = [plotTitle{plot_i}];
                end
                

                subM = 2; subN = ceil(nFiltSets/subM);
                
                h_axx(set_i) = subplotGap(subM, subN, set_i); 
                nFilters = size(convFilters{xi, line_i, plot_i}, 3);
                if tileSquare 
                    nFilt_m = ceil(sqrt(nFilters));
                    nFilt_n = ceil(nFilters/nFilt_m);
                else
                    nFilt_m = nFilters;
                    nFilt_n = 1;
                end

                filterStack = convFilters{xi, line_i, plot_i};
                if isempty(filterStack)
                    continue
                end
                imagesc(tileImages( filterStack, nFilt_m, nFilt_n, 1, 0.2));
                L = max(abs(filterStack(:)));

%                 plot_i = 2;            

                s = allPlotLegends_C{plot_i};


                switch plotFiltersFrom
                    case 'lines', 

                        title(setTitles_withoutSize{set_i}, 'fontsize', title_fsize);
                    case 'x',    
                        title(setTitles_withoutSize{set_i}, 'fontsize', title_fsize);
                end

    %             leg_str_i = line_legends{set_i};
    %             if strcmp(multiple_lines, 'TrainingNoise')
    %                 idx_Tr = strfind(leg_str_i, 'Train: ') + length('Train:');
    %             elseif strcmp(multiple_lines, 'Networks')
    %                 idx_Tr = strfind(leg_str_i, 'ConvNet: ') + length('ConvNet: ')+1;
    %             elseif strcmp(multiple_lines, 'TrainingSNRs')
    %                 idx_Tr = strfind(leg_str_i, 'Train') + length('Train')+1;
    %             end
    %             filtTitles{set_i} = leg_str_i(idx_Tr:end);
    %             title(filtTitles{set_i}, 'interpreter', 'none', 'fontsize', 15);


                caxis([-L, L]);
                axis equal tight;


    %                 i = i + 1;
    %             end

            end
            set(h_axx, 'xtick', [], 'ytick', [])
            colormap('gray');
            set(gcf, 'position', [624   521   636   457]);



                    %%
            filterGainFigOffset = 200;
            curFilterGainFigID = filterGainFigOffset + plot_i;
            figure(curFilterGainFigID); clf;




        %     n = ceil(nNetworks/m);
            all_filterGains = cell(1, nFiltSets);
    %         log_ylims = cell(1,nFiltSets);
            for set_i = 1:nFiltSets
    %             for fi = 1:nFonts
    %                 h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); 
%                 figure(curFilterGainFigID);
                h_axx2(set_i) = subplotGap(subM, subN, set_i); 
                [subm, subn] = ind2sub([subM, subN], set_i);


                switch plotFiltersFrom
                    case 'lines', line_i = set_i;
                    case 'x',     xi     = set_i;
                end
                
                filterStack = convFilters{xi, line_i, plot_i};
                nFilters = size(filterStack, 3);
                for filt_idx = 1:nFilters
                    filt_i = filterStack(:,:,filt_idx);
                    [freq_cycPerPix, gain_j] = filterGain(filt_i, 50);
                    all_filterGains{set_i}(filt_idx,:) = gain_j / 1; %mean(gain_j);
                    freq_cycPerLet = freq_cycPerPix * (fontHeight);
                    freq_cycPerLet(1) = mean(freq_cycPerLet([1:2]));

    %                 rps_i(filt_i,:) = radialPowerSpectrum();
                end

                plot(freq_cycPerLet, all_filterGains{set_i}', '.-', 'linewidth', 2);
    %             log_ylims{set_i} = ylim;

    %             title(filtTitles{set_i}, 'fontsize', 13);

                labelfontSize = 17;
                if set_i == 1                
                    ylabel('Power', 'fontsize', labelfontSize);
                else
                    ylabel('  ');
                end
                if (subm == subM) && subn == ceil(subN/2)  %  set_i == ceil(nFiltSets/2)
%                     xlabel('Cycles Per Letter', 'fontsize', labelfontSize);
                else
%                     xlabel(' ');
                end

                switch plotFiltersFrom
                    case 'lines', 

                        title(setTitles_withSize{set_i}, 'fontsize', title_fsize);
                    case 'x',    
                end


    %             figure(

    %             errorbar(freq_cycPerLet, mean(all_filterGains, 1), std(all_filterGains, [], 1), 'o-');
    %                 i = i + 1;
    %             end
    %             xlim(lims([1, 4], .02))
            end
            set(h_axx2, 'xscale', 'log', 'yscale', 'log');

            log_ylims = get(h_axx2, 'ylim');
            if ~iscell(log_ylims)
                log_ylims = {log_ylims};
            end
            logy_lims_all = log10(lims([log_ylims{:}])); 
            
            all_filterGains_show_C = cellfun(@(x) x(:,2:end), all_filterGains, 'un', 0);
            all_filterGains_show_C = cellfun(@(x) x(:)', all_filterGains_show_C, 'un', 0);
            all_filterGains_show = [all_filterGains_show_C{:}];
            
%             logy_lims_all = log10(lims(all_filterGains_show));
            logy_lims_all = log10( [prctile(all_filterGains_show(:), 2), max(all_filterGains_show(:))] );
            
%             logy_lims_all = log10(lims([all_filterGains_show{:}]));
%             logy_lims_all = [floor(logy_lims_all(1)), ceil(logy_lims_all(2))];
%             logy_lims_all = [-6 -1];
            
            
            logy_lims_all_tick = [ceil(logy_lims_all(1)), floor(logy_lims_all(2))];
%             logy_lims_all = [-5, -1];
            set(h_axx2, 'ylim', 10.^[logy_lims_all], 'xlim', lims(freq_cycPerLet(3:end), .01, [], 1) );
            set(h_axx2, 'ytick', 10.^(logy_lims_all_tick(1) : logy_lims_all_tick(2)));
            set(h_axx2, 'fontsize', 13);
    %         setLogAxesDecimal;
            for set_i = 1:nFiltSets
                decades_equal(h_axx2(set_i), 2.5);
            end

%             set(curFilterGainOffsetFig, 'position', [899   454   821   284])

            %%
            showAngularFilters = 0;
            if showAngularFilters
                figure(7); clf; 
            %     m = floor(sqrt(nNetworks));
            %     n = ceil(nNetworks/m);
                all_filterAngularPS = cell(1, nLines);
                for set_i = 1:nLines
        %             for fi = 1:nFonts
        %                 h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); 
                    figure(7);
                    h_axx3(set_i) = subplot(1, nLines, set_i);  hold on;


                    for filt_idx = 1:6
                        filt_i = convFilters{1, set_i, plot_i}(:,:,filt_idx);

                        [aps_rho, aps_theta] = filterAngularGain(filt_i, 50);
                        all_filterAngularPS{set_i}(filt_idx,:) = aps_rho;

        %                 rps_i(filt_i,:) = radialPowerSpectrum();
                        [aps_x, aps_y] = pol2cart(aps_theta, log10(aps_rho) );

                        plot(aps_theta, log10(aps_rho), color_s(filt_idx));
        %                 plot(aps_x, aps_y, color_s(filt_idx));
                    end


                    title(filtTitles{set_i});


                    if set_i == 1                
                        ylabel('Power');
                    else
                        ylabel('  ');
                    end
                    if set_i == ceil(nLines/2)
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

    %             set(7, 'position', [899   454   821   284])

            end        
    %         set(h_axx, 'xtick', [], 'ytick', [])
    %         colormap('gray');

            showSimulatedChannels = true && strcmp(expName, 'ChannelTuning');
            if showSimulatedChannels
                
                %%
                            nStimUse = 100;
                figure(curFilterGainFigID+100); clf;
    
                 for set_i = 1:nFiltSets
    %             for fi = 1:nFonts
    %                 h_axx(net_i, fi) = subplot(nNetworks, nFonts,i); 
                    
                    h_axx4(set_i) = subplotGap(subM, subN, set_i); 


                    switch plotFiltersFrom
                        case 'lines', line_i = set_i;
                        case 'x',     xi     = set_i;
                    end

                    fullModel = fullModels{xi, line_i, plot_i};

                
                    nModulesTops = 1;
                    nnTop = length(nModulesTops);
                    
                    letterOpts = letterOpt_use;
                    letterOpts.trainingFonts = 'same';
                    noisyLettersPath = [datasetsPath stimType filesep letterOpts.fontName filesep ];
                    nFreqs = length(allNoiseFreqs);
                    pow_means = zeros(nFreqs, nnTop);
                    for freq_i = 1:nFreqs
    %                     S = 

                        letterOpts.noiseFilter = struct('filterType', 'band',   'cycPerLet_centFreq', allNoiseFreqs(freq_i), 'applyFourierMaskGainFactor', 1);

                    %     opt_str = getNoisyLetterOptsStr(noisy_letter_opts_image);
                        file_name_base_str = getFileName(letterOpts.fontName, 0, letterOpts);
    %                     fprintf(' - FileName (base) : %s,  SNRs = %s \n', file_name_base_str, toOrderedList(all_SNRs, [], ', ', inf));        
                        %%


                        stimFile = [noisyLettersPath file_name_base_str ];
    %                     imageFileExists = exist(v, 'file') ;
                        S_stim = load(stimFile);

%%
%                         nModulesMax = find(strcmp(fullModel.moduleNames, 
                        for mmi = 1:nnTop
                            powInResult = zeros(1, nStimUse);
                            nModulesMax = nModulesTops(mmi);
                            for im_i = 1:nStimUse
                                noise_filtered = nn_forward(fullModel, S_stim.inputMatrix(:,:,im_i), nModulesMax );
                                powInResult(im_i) = rms(noise_filtered(:))^2;
                            end
                            pow_means(freq_i, mmi) = mean(powInResult);
                        end
                        
                        
                        
                        
                    end
  
  
                    plot(allNoiseFreqs, pow_means, '.-');
                    set(gca, 'xscale', 'log', 'yscale', 'log', 'xlim', [0.5, 16])
                        3;
  
                    
                end
                
                
                
            end
    
            3;


        end
        
        
    end % of all plots
    
    
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
        
        niceLegendFields = {'nStates', 'SNR_train'}; %'doPooling', 'poolSizes', 'poolStrides'}; %'filtSizes', 'doPooling'};
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

    if all(isnan(logY))
        log_slope = nan;
        log_slope_ci = [nan, nan];    
    else
    
        [b,binf] = regress( logY, logX1);

        log_slope = b(2);
        log_slope_ci = binf(2,:);
    end    
    
    [p,S] = polyfit(logX, logY, 1);
%     assert(log_slope == p(1));  
    

end


 function [x_deg, human_eff_0, human_eff_5deg] = getHumanSizeData()

     x_deg  =         [0.1,   0.25,  0.5,  1,    2,     4,     8,     16,    30];
     human_eff_0    = [0.0715, 0.095, 0.14, 0.12, 0.097, 0.075, 0.053, 0.036, 0.0275];
     human_eff_5deg = [nan     0.04  0.065, 0.111, 0.078, 0.065, 0.049, 0.035, 0.0255];
 end
 
 function [x_noiseFreq_fit, y_threshold_fit, x_noiseFreq_pts, y_threshold_pts] = getHumanChannelData(fontName)

% 45x45, k18 x 2
%      x_noiseFreq = [0.5, 0.8, 1.3, 2.0,  3.2, 5.1, 8.1, 13];
%      y_threshold = [.21,  .43,   2.03,   12.3,   96.5,  120,  26   8.02];
     
% 64x64, k38
%%
%     x_noiseFreq= [0.5,   0.8,   1.3,   2.0,    3.2,   5.1,   8.1,  13];
%     y_threshold= [1,     1.5    5.7    11.5   48.7    366.1  116,  11.2 ]; % actual values



        S.Braille.cycPerLet = [0.5000    0.7100    1.0000    1.4100    2.0000    2.8300    3.3600    4.0000    5.6600    8.0000   ];
        S.Braille.thresholds = [6.5616    9.2849   15.0025   27.6775   55.1916  216.7931  230.3661  150.0584   30.7078   15.1621  ];

        S.Sloan.cycPerLet = [0.5000    0.7100    1.0000    1.4100    2.0000    2.3800    2.8300    3.3600    4.0000    5.6600    8.0000   ];
        S.Sloan.thresholds = [5.6245   14.6141   20.5912   40.1828  120.6456  300.4263  409.0894  343.4588  285.1249   66.3436    8.5418  ];

        S.Bookman.cycPerLet = [0.5,   0.71,    1,          1.41,    2,        2.38,      2.83,      3.36,  4,   4.76,     5.66,     8,     11.31,     16];
        S.Bookman.thresholds = [2.7812    3.4633    9.7016   18.8326   44.2199  155.1633  155.1633  323.3074  250.0650  118.4970   61.4418   11.2803    8.6847    5.1478];

        S.KuenstlerU.cycPerLet = [0.5000    0.7100    1.0000    1.4100    2.0000    2.8300    3.3600    4.0000    4.7600    5.6600    8.0000   11.3100   16.0000];
        S.KuenstlerU.thresholds = [3.4424    4.3661    6.7984   10.8180   19.9354   70.9974  143.5656  390.5711  325.8387  158.1933   43.7129   18.5641    7.7647];

        useOld = true;
        if useOld
            S.Bookman.cycPerLet = [0.5 0.59  0.71  0.84  1 1.19  1.41  1.68  2 2.38  2.83  3.36  4  4.76  5.66  6.73  8 9.51 11.31 13.45 16];

%     y_log10Threshold = [0.7740    0.8309    0.8693    0.8998    1.0395    1.1654    1.3178    1.3617    1.5622    1.6144    1.8388    2.0220    2.2508 ...
%                         2.5046    2.6564    2.6315    2.4420    2.2201    1.9270    1.6117    1.4342];
    
            y_log10Threshold = [0.5104    0.5609    0.5899    0.7764    0.9043    1.1112    1.4049    1.5753    1.8275    2.0660    2.3871 ...
                                2.5311    2.4442    2.1303    1.6726    1.2616    0.9938    0.8076    0.8995    0.8924    0.6338];
            S.Bookman.thresholds = 10.^y_log10Threshold;
        end

        if ~isfield(S, fontName)
            warning('Don''t have human data for font "%s". Using Bookman instead', fontName);
            fontName = 'Bookman';
        end
        x_noiseFreq_pts = S.(fontName).cycPerLet;
        y_threshold_pts = S.(fontName).thresholds;
        
        
        
%         y_threshold_pts = 10.^y_log10Threshold;
%     y_threshold= [1.0000    2.14    6.06   17.58   95.14  270.34  139.6084   11.2 ]; % slightly smoothed
    
    itp_factor = 10;
    if itp_factor > 1
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
        
        x_noiseFreq_fit = x_itp;
        y_threshold_fit = y_th_itp;
        
    end
    
    
    
    %%
    
    
     
%      x_noiseFreq  = [ 0.41, 0.82, 1.65, 3.3, 6.7, 13];
%      y_threshold  = [nan, 0.1000   52.5000  124.5000   97.5000    0.1000];
 end
 
 function [x_spacing_fit, y_threshold_fit, x_spacing_pts, y_spacing_pts] = getHumanCrowdingVsEccentricity()
 %%
    useDataDeg = 8;
    normalizePoints = true;

    if useDataDeg == 8
        % 8 degree data
        th_1letter = .048;
        crit_spacing = 2.7;

        x_factor = 1/crit_spacing;
        y_factor = 1/th_1letter;

        cf_top_x = [0, 2.1] * x_factor;
        cf_top_y = [1, 1]*1 * y_factor;
        cf_bot_x = [crit_spacing, 25] * x_factor;
        cf_bot_y = [1, 1]*th_1letter * y_factor;

        
        x_spacing_pts = [1    1    1    1.2    1.5    2    2    2    2.25    2.5    2.5    2.5    3     3    3    3    3.5    3.5    3.5    4    4    4    4.5    5    7.5   25  25   25];
        y_spacing_pts = 10.^[0.01    0.06    0.03    0.04    0.03   -0.03   -0.94    0.02   -1.24   -1.25   -0.94   -1.14   -1.28   -1.17   -1.19   -1.36   -1.27   -1.47   -1.26   -1.3   -1.26   -0.97   -1.3   -1.28   -1.33   -1.39  -1.29   -1.35 ];

        if normalizePoints
            x_spacing_pts = x_spacing_pts / crit_spacing;
            y_spacing_pts = y_spacing_pts / th_1letter;
            
        end
        
        
    elseif useDataDeg == 20 
         %20 degree data

        th_1letter = .176;
        crit_spacing = 11.6;

        x_factor = 1/crit_spacing;
        y_factor = 1/th_1letter;

        cf_top_x = [0, 6.6] * x_factor;
        cf_top_y = [1, 1]*1.68 * y_factor;
        cf_bot_x = [crit_spacing, 25] * x_factor;
        cf_bot_y = [1, 1]*th_1letter * y_factor;
    end    
    
    x_spacing_fit = [cf_top_x, cf_bot_x];
    y_threshold_fit = [cf_top_y, cf_bot_y];
    human_s = nan(size(x_spacing_pts)); 
            
 end

 function [x_wiggle_fit, y_efficiency_fit, x_wiggle_pts, y_efficiency_pts] = getHumanSnakeWiggleData(axisScale, dataToUse)
     
     %%         
     
     x_wiggle_ori_CJC = [ 5.2,    15,  30,  35,   40,  45,  60, 90 ];
     y_eff_ori_CJC = [ .075, .08, .045,.035, .039, .0207, .0203, .0166 ];
     
     x_wiggle_ori_AS = [ 5.2,    15,  30,     62,];
     y_eff_ori_AS = [ .065, .065, .034,  .018];
     
     x_wiggle_offset_CJC = [ 20.5, 29, 43];
     y_eff_offset_CJC = [ .05, .03, .0265];
     
     x_wiggle_offset_AS = [ 10.5, 25, 43];
     y_eff_offset_AS = [ .07, .03, .0165];
     
     x_wiggle_phase_CJC = [ 5.5, 29];
     y_eff_phase_CJC = [ .073, .034 ];
     

     x_wiggle_ori = [x_wiggle_ori_CJC, x_wiggle_ori_AS];
     y_eff_ori = [y_eff_ori_CJC, y_eff_ori_AS];
     
     x_wiggle_offset = [x_wiggle_offset_CJC, x_wiggle_offset_AS];
     y_eff_offset   = [y_eff_offset_CJC, y_eff_offset_AS];
     
     x_wiggle_phase = [x_wiggle_phase_CJC];
     y_eff_phase = [y_eff_phase_CJC];
     
     
     
     x_wiggle_paper = [x_wiggle_ori, x_wiggle_offset, x_wiggle_phase];
     y_eff_paper = [y_eff_ori,     y_eff_offset , y_eff_phase];
                     
                     
                     %%
    y_eff_avi = [0.0324 0.0318 0.0296 0.0274 0.0242 0.0238 0.0187 0.0167 0.0130 0.0128 0.0128 0.0107 0.0127 0.0113 0.0109 0.0099 0.0092 0.0092 ...
     0.0090 0.0351 0.0323 0.0281 0.0239 0.0185 0.0211 0.0137 0.0124 0.0138 0.0100 0.0130];
 
    x_wiggle_avi = [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 5 10 15 20 25 30 35 40 45 50 40.8];
    
%     idx_curves = {[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19],  [20 21 22 23 24 25 26 27 28 29], 30};
%     x_wiggle_ori_avi = x_wiggle_avi(idx_curves{1});
%     x_wiggle_offset_avi = x_wiggle_avi(idx_curves{2});
%     x_wiggle_phase_avi = x_wiggle_avi(idx_curves{3});
%     
%     y_eff_ori_avi = y_eff_avi(idx_curves{1});
%     y_eff_offset_avi = y_eff_avi(idx_curves{2});
%     y_eff_phase_avi = y_eff_avi(idx_curves{3});
                     
                  %%
                  
     if ~iscell(dataToUse)
         dataToUse = {dataToUse};
     end
     
     for j = 1:length(dataToUse)
                  
         switch dataToUse{j}
             case 'paper', x_wiggle_pts = x_wiggle_paper; y_efficiency_pts = y_eff_paper; 
                    if strcmp(axisScale, 'linear')
                        x_wiggle_pts(x_wiggle_pts < 8) = 0;
                    end
                 n0_paper = 0.074;   w0_paper = 15;  % parameters from paper
                 beta_bentLine = [n0_paper, w0_paper];
             case 'avi',   x_wiggle_pts = x_wiggle_avi;   y_efficiency_pts = y_eff_avi;
                 n0_avi = 0.0409;  w0_avi = 14.1067;  % parameters from my experiments
                 beta_bentLine = [n0_avi, w0_avi];


         end


         
         switch axisScale, 
             case 'log',    
                x_wiggle_fit = 1:1:100;
                bentLine_func = @(b, x) b(1) ./ max(1, x./b(2)); 
                y_efficiency_fit(:,j) = bentLine_func(beta_bentLine, x_wiggle_fit); %#ok<AGROW>

             case 'linear', 
                 x_wiggle_fit = 0:1:90;
                 clippedLine_func = @(c, x) clippedLine(c, x); 
    %              clippedLine90 = @(c, x) clippedLine([c(1), 90, c(2), c(3)], x); 

                 beta_clipped0 = [5, 45, .07, .02];
                 beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
                     clippedLine_func, beta_clipped0);

                 y_efficiency_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>

         end

         
     end
     
     x_wiggle_fit = repmat(x_wiggle_fit(:), 1, length(dataToUse));
%      y_func = @(w) max(1, n0 ./ (w/w0) ); 
          
                     
     show = 0;
     if show
         %%
         figure(84); clf;
         plot(x_wiggle_pts, y_efficiency_pts, 'o'); hold on;
         plot(x_wiggle_fit, y_efficiency_fit, '-'); 
%          xlim([-1, 91])
         if strcmp(axisScale, 'log')
%              set(gca, 'xlim', [8, 100], 'yscale', 'log', 'xscale', 'log', 'xtick', [1, 10:10:90], 'ylim', [.01, .1])
         end
     end

 end
     
%      x_wiggle_fit = 8:1:100;
%      n0_paper = 0.074;   w0_paper = 15;  % parameters from paper
%      n0_avi   = 0.0409;  w0_avi   = 14.1067;  % parameters from my experiments
%      
% %      y_func = @(w) max(1, n0 ./ (w/w0) ); 
%      bentLine_func = @(w) n0 ./ max(1, w/w0); 
% %      y_func = @(w) min(1, w/w0); 
%      
%      y_efficiceny_fit = bentLine_func(x_wiggle_fit);
%      
%      
%           
%      %%     
     
 
function xi = sub(X, i)
    if iscell(X)
        xi = X{i};
    else
        xi = X(i);
    end
end
 

function letterOpts = addUncertaintyToLetterOpts(letterOpts, uncertainty_opt)
    
    assert(~iscell(uncertainty_opt));
    if isfield(uncertainty_opt, 'oris')
        [letterOpts.oris, letterOpts.xs, letterOpts.ys] = deal(uncertainty_opt.oris, uncertainty_opt.xs, uncertainty_opt.ys);
        letterOpts.OriXY = uncertainty_opt;
    end

    if isfield(uncertainty_opt, 'styles')
        letterOpts.fullStyleSet = uncertainty_opt.styles;
%         niceOptStrFields = [niceOptStrFields, {'fontStyles'}]; %#ok<AGROW>
    else
        letterOpts.fullStyleSet = 'same';
    end


    if isfield(uncertainty_opt, 'fonts')
        letterOpts.fullFontSet = uncertainty_opt.fonts;
    else
        letterOpts.fullFontSet = 'same';
    end
end

%{ 
     ori_x_y = {[0], [0],  [0]};
%         ori_x_y = {[0], [0,3], [0]};   % 2x1
%         ori_x_y = {[0], [0,3,6], [0]}; % 3x1
%         ori_x_y = {[0], [0:6], [0]};    % 7x1
%         ori_x_y = {[0], [0:6], [0:6]};  % 7x7
%         ori_x_y = {[0], [0:9], [0:9]};  % 10x10
%          ori_x_y = {[-4:2:4], [0], [0]};   % 5 x 1x1
%         ori_x_y = {[-4:2:4], [0:4], [0:4]};   % 5 x 5 x 5
%          ori_x_y = {[-4:2:4], [0:9], [0:9]};   % 5 x 10 x 10
                    

 %}
 
 %{
     letterOpt_std = struct( ...
        'oris', oris, 'xs', xs, 'ys', ys, 'stimType', stimType, 'tf_pca', 0, ...
        'sizeStyle',  sizeStyle, ...
        'imageSize', all_imageSizes_C{1}, ...
        'autoImageSize', autoImageSize, ...
        'blurStd', allBlurStd_C(1), ...
        'noiseFilter', whiteNoiseFilter, ...
        'trainingNoise', allTrainingNoise(1),  ...
        textureStatOpts_C{:} ...
     ) ;
%}
 
 %{
                         switch curPoolingFactor
                            case 0.5, network_use.poolSizes = pSize * curPoolingFactor;
                            case 1,
                            case 2,
                            
                            3;
                        end
%}

%{

        case 'NoisyLettersTextureStats_old'
            
%             all_snr_train_C = {[2 3 4 5]};
%             all_snr_train_C = {[1 2 3 4]};

            all_snr_train_C = {[4]};
            
            Na_sub_txt = 'all';
%             Nscl_txt = 3;  Nori_txt = 2;  Na_txt = 3; 
%             Nscl_txt = 3;  Nori_txt = 2;  Na_txt = 3; 
            if strcmp(x_name, 'NoiseFreq')
                Nscl_txt = 3;  Nori_txt = 4;  Na_txt = 5; 
            elseif strcmp(x_name, 'Complexity')
                Nscl_txt = 3;  Nori_txt = 4;  Na_txt = 5; 
            end
%             Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 9; 
%             Nscl_txt = 4;  Nori_txt = 4;  Na_txt = 9; 
%             Nscl_txt = 2;  Nori_txt = 3;  Na_txt = 9;  Na_sub_txt = 'all';
            allTextureStatsUse = {'V2'};

%             statsUse = 'V2';
%             imageSize = [32, 32];   all_sizeStyles_C = {'med'};
            imageSize = [64, 64];   
%             imageSize = 64;   sizeStyle = 'large';
            textureStatOpts_C = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt, 'Na_sub_txt', Na_sub_txt};
            

    %         all_imageSizes_C = {[20,20],[50,50], [80,80]};
            autoImageSize = 0;
            all_imageSizes_C = {imageSize};
            
               
    end

%}


        %             allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4];
        %             allSNRs_test = [0, 1, 2, 2.5, 3, 4];
        %             allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4, 5];
        %             allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4, 5];
%                     allSNRs_test = [0, 1, 2, 3, 4];
%                     if any(strcmp(x_name, {'Uncertainty', 'FontSize', 'FiltSize', 'PoolSize'})) 
%         %                 allSNRs_test = [0, 1, 2, 2.5, 3, 4];
% %                         allSNRs_test = [0, 1, 2, 2.5, 3, 4];
%                          allFontNames      = {'BookmanU'};
% 
%                     elseif strcmp(x_name, 'NoiseFreq')
%                         allSNRs_test = [-1, 0, 1, 2, 3, 4];
%         %                 allSNRs_test = [-1, 0, 0.5, 1, 1.5, 2, 2.5, 3, 4];
% 
%                     end



% othello, cassio, rose6, humair, crunchy5,