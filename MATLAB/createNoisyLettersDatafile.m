function createNoisyLettersDatafile(fontName, fontSizeStyle, orientations, xs, ys, imageSize, blurStd, noiseFilter, textureSettings, crowdingSettings, set_idx)

%     global CPU_id allPCorrNoPool allPCorrPool
%     allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'BookmanB', 'BookmanU', 'Georgia', 'Yung', 'Kuenstler'};
    % pelli complexity:    28,            65         67          100,       107         57          139                        199       451  
    
    
%     global host
    global ID
    if isempty(ID)
        startup;
    end
    showAnyFigures = onLaptop; 
    lock_removeMyLocks
    
    applyFourierMaskGainFactor_band = 1;
    applyFourierMaskGainFactor_pink = 1;
    applyFourierMaskGainFactor_hiLo = 0;
%     stimMode = 'textureStat';
    stimMode = 'image';
    actionIfImageToSmall = 'abort';

    skipSave = false;

%     allFontNames      = {'Braille', 'Checkers4x4', 'Sloan', 'SloanB', 'Helvetica', 'HelveticaB', 'HelveticaU', 'HelveticaUB', 'Courier', 'CourierB', 'CourierU', 'CourierUB', 'Bookman', 'BookmanB', 'BookmanU', 'BookmanUB', 'Yung', 'YungB', 'KuenstlerU', 'KuenstlerUB'};
%     allFontNames_toDo = allFontNames;

    createImageFiles = 1;
    createPcaFiles = 0 && 1;
    pca_method = 'PCA';
    nPcaScoresToTest = [1,2,4,10,20,40,100,200,400,1000];

    doCalculateIdealPerformance_withFile = 0;
        doCalculateIdealPerformance_atEnd = 0;

    precision = 'single'; precision_func = @single;


    expName = 'ChannelTuning';
%     expName = 'Complexity';
%     expName = 'Grouping';
%     expName = 'TestConvNet';
%     expName = 'Uncertainty';
%     expName = 'Crowding';

    if nargin == 1
        expName = fontName;
    end

%     allExpNames = {'ChannelTuning', 'Complexity', 'Uncertainty', 'Grouping'};
    allExpNames = {'Complexity', 'Uncertainty', 'Grouping'};
    if strcmp(expName, 'all')
        expName = allExpNames;
    end
    
    if iscellstr(expName)
        for i = 1:length(expName)
            createNoisyLettersDatafile(expName{i});
        end
        return;
    end
    
    
    doOverFeat          = 0 && 1;
    doTextureStatistics = 0 && 1;

    
    loopKeysOrder = {};

    redoFilesIfExist = 0;
%         redoFilesIfOlderThan = 736210.540042; % 9/3/2015 %735768.686739; %735767.913364; % sprintf('%.6f', now)
%         redoFilesIfOlderThan = 736252.049851; % 9/3/2015 %735768.686739; %735767.913364; % sprintf('%.6f', now)
%         redoFilesIfOlderThan = 736275.929786; % 11/7/2015     
%         redoFilesIfOlderThan = 736288.165278; % 11/20/2015 
        
        
%         redoFilesIfOlderThan = 736291.993269; % 11/23/2015 
        
        redoFilesIfOlderThan = 736366.943890; % 2/6/2016
        
        
        
    if doTextureStatistics
%         redoFilesIfOlderThan = 736252.422052;
    end
        
        checkContentsOfFile = 0;
    
%     fontSizeStyle = 'dflt';     marginPixels = 1;
%     fontSizeStyle = 'sml';   ch

    viewSampleLettersOnLaptop = true && onLaptop;
    saveSampleLettersOnLaptop = true;

    showLetters = 0             && showAnyFigures;        
    showSamplesWithNoise = 1    && showAnyFigures;

    
    %%%%%%%%%% FONTS %%%%%%%%%%%%%%%%

%     allFontNames      = {'KuenstlerU', 'Bookman', 'Braille', 'Sloan', 'Helvetica', 'Courier', 'Yung', };
    
%     allFontNames      = {'Bookman', 'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'BookmanU', 'BookmanU', 'Yung', 'KuenstlerU'};
%     allFontNames      = {'Bookman', 'BookmanB', 'KuenstlerU', 'KuenstlerUB'};
%     allFontNames      = {'Bookman',  'Braille', 'KuenstlerU'};


%     allFontNames      = {'Bookman', 'Courier', 'Helvetica'};
%     allFontNames      = {'Sloan'};
%     allFontNames      = {'KuenstlerU'};
    allowLettersToFallOffImage = strcmp(expName, 'Crowding');
    
    
    
% (16)
% add: BookmanB, BookmanU, Hebrew, Devanagari, Armenian, 4x Checkers, Courier, (7)  
% have: 2x3 Check, Helvetica,  Sloan, Bookman, Kustler, Yung (6)
% skip: Arabic, 3letter, 5-letter (3)
    
    switch expName
        case 'Complexity',
%             allFontNames      = {'Bookman', 'BookmanU', 'Sloan', 'Helvetica', 'Courier', 'KuenstlerU', 'Braille', 'Yung'};              

%             allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};
            allFontNames      = {'Armenian', 'Devanagari', 'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung', 'BookmanB', 'BookmanU', 'Hebraica', 'Checkers4x4', 'Courier'};
%             allFontNames      = {'Braille', 'BookmanB', 'Courier', 'KuenstlerU'};
%             allFontNames      = {'Bookman', 'KuenstlerU'};
%             allFontNames      = {'Bookman', 'Courier'};   
%             allFontNames      = {'Bookman'};   
            if ~doTextureStatistics 
%                 allFontNames      = expandFontsToTheseStyles(allFontNames, {'', 'B', 'I', 'BI'});
            end
            
        case 'ChannelTuning', 
            allFontNames      = {'Bookman'};
%             allFontNames      = {'Bookman',  'Braille', 'Sloan', 'Helvetica', 'Yung', 'KuenstlerU'};            
            
        case 'Grouping',
            allFontNames = {'Snakes'};
%             allFontNames = {'Sloan'};
            
        case 'TestConvNet',
            allFontNames = {'Bookman'};

        case 'Uncertainty',
            allFontNames      = {'Bookman'};
            
        case 'Crowding', 
            allFontNames      = {'Sloan'};

    end
%     allFontNames      = {'Bookman', 'BookmanU', 'Courier'};
%     allFontNames      = {'KuenstlerU'};
    
%     allFontNames      = expandToStyles(allFontNames, {'', 'B'});
    3;



    switch expName
        case 'Complexity',
            all_SNRs = [0 : 0.5 : 5 ];
            
%             all_SNRs = [1, 2, 3, 4];
            if onLaptop
%                 all_SNRs = all_SNRs(1) : .5 : all_SNRs(end);
                all_SNRs = [1 2 3 4 5];
            end

        case 'ChannelTuning',
            
            if onLaptop
                dSNR = 0.5;
            else
                dSNR = 0.5;
            end
            
            all_SNRs_norm   = [-1 : dSNR : 5 ];
            all_SNRs_noNorm = [-3 : dSNR : 5 ];

%             all_SNRs_norm = [0];

        %     all_SNRs = [-3, -2, -1, 0, 1, 2, 3, 4, 5];
        %     all_SNRs = [4];
%             all_SNRs = [-1, 0, 1, 2, 3, 4, 5, 6];
            all_SNRs = all_SNRs_norm;
        case 'Grouping',
            all_SNRs = [-1 : 0.5 : 5];
%             all_SNRs = [0 : 0.5 : 5];
            
            if onLaptop && 0
%                 all_SNRs = all_SNRs(1) : 1 : all_SNRs(end);
                all_SNRs = [0, 1, 2, 3, 3.5, 4, 5];
                all_SNRs = [0 : 0.5 : 5];
                all_SNRs = [0];
            end
        case 'TestConvNet',
            all_SNRs = [0 : 1 : 5];
%             all_SNRs = [4];

        case 'Uncertainty',
            all_SNRs = [0 : 0.5 : 5 ];

        case 'Crowding',
%             all_SNRs = [0 : 0.5 : 5 ];
            all_SNRs = [ 4 ];
    end
              

    %%%%%%%%%% SNRs %%%%%%%%%%%%%%%%%%%
%     all_SNRs = [-2, -1];
    
    %% span, spacing, nLetters
    
    if (nargin < 2) || strcmp(fontName, 'all')


         lock_removeMyLocks;

         fprintf(' ==== Creating Noisy Letters datafiles for "%s" experiment... ==== \n', expName);

         
        
%         allFontNames      = {'Bookman'};
        allXrange = {[0]};
        allXrange = {[15,25,65]};
        
        allOriXYSets_one = { {[0], [0], [0]} };
        
        allOriXYSets_mult = { ...
                            {[0], [0], [0]  };
                            {[0], [0,2,4], [0]};   % 3x1 [2] -->span=4
                            {[0], [0,1,2,3,4], [0]};   % 5x1 [1] -->span=4
                            {[0], [0,4], [0]};   % 2x1  [4] -->span=4
                            {[0], [0,4,8], [0]  }; % 3x1
                            {[0], [0,4,8,12], [0] };    % 4x1
                            {[0], [0,4,8,12], [0,4,8,12]};  % 4x4
                            {[0], [0:4:20], [0:4:20]};  % 6x6
                            {[0], [0:2:20], [0:2:20]};  % 11x11
                            };

                        
        
%         allOriXYSets_for_nLet = @(nLet) arrayfun(@(d) {[0], [0 : d : d* d*(nLet-1)], [0]  }, allSpacings(allSpacings < d*nLet), 'un', 0);
%         
%         allOriXYSets_for_nPos = @(nPos) arrayfun(@(d) [0 : d : d*(nPos-1)], allSpacings, 'un', 0);
%         
%         allOriXYSets_2_v_spac = arrayfun(@(d) {[0], [0, d], [0]   }, [1,2,3,4,5,6:2:10,14:4:22], 'un', 0);
%         allOriXYSets_4_v_spac = arrayfun(@(d) {[0], [0, d, d*2, d*3], [0]  }, [1,2,3,4,5,6:2:10,14:4:22], 'un', 0);
%         
%         allOriXYSets_8_v_spac = arrayfun(@(d, nLet) {[0], [0 : d : d*(nLet-1)], [0]  }, allSpacings(allSpacings < d*nLet), 'un', 0);
        fontWidth = 25;
%        allSpacings = [1,2,3,4, 6, 8, 16, 24];
       allSpacings = [22];
        %% span is constant (2 letters wide = 50 pixels): vary spacing
        allSpacings_span_2let_v_spc_func = @(nLet) arrayfun(@(spc) [0 : spc : nLet*fontWidth], allSpacings, 'un', 0);
        
        allSpacings_span_2let_v_spc = allSpacings_span_2let_v_spc_func(2);
        allSpacings_span_2let_v_spc{1} = allSpacings_span_2let_v_spc{1}(1:2);

        %% number of positions is constant (2 or 3): vary spacing:
        maxSpacing = 128;
        allPositions_v_spacing_func = @(nPos) arrayfun(@(d) [0 : d : d*(nPos-1)], allSpacings, 'un', 0);

        allPositions_v_spacing_2pos = allPositions_v_spacing_func(2);
        allPositions_v_spacing_3pos = allPositions_v_spacing_func(3);
        allPositions_v_spacing_4pos = allPositions_v_spacing_func(4);
        allPositions_v_spacing_9pos = allPositions_v_spacing_func(9);  allPositions_v_spacing_9pos = allPositions_v_spacing_9pos(  cellfun(@max, allPositions_v_spacing_9pos) <= maxSpacing);
%         maxSpacing = 

        %% spacing is constant : vary number of positions
        
        % try this later
        allXs = {[0, 25, 50], [0, 25, 50, 75], [0], [0, 25]};
%         oriXYSet_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', allXs);
        %%
        oriXYSet_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', [{0}, allSpacings_span_2let_v_spc]);
%         oriXYSet_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', [{0}, allSpacings_span_2let_v_spc, allPositions_v_spacing_2pos]);
%         oriXYSet_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', [{0}, allPositions_v_spacing_9pos]);
%         oriXYSet_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', [{0}, allPositions_v_spacing_9pos]);
%         oriXYSet_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', [{0}]);
        oriXYSet_nLet_spc = struct('oris', [0], 'ys', [0], 'xs', [0]);
        
        oriXYSet_large = struct('oris', [-10:2:10], 'xs', [0:5], 'ys', [0:11] );
        oriXYSet_med1 = struct('oris', [0], 'xs', [0:5], 'ys', [0:11] );
        oriXYSet_med2 = struct('oris', [-10:2:10], 'xs', [0], 'ys', [0] );
        oriXYSet_test1 = struct('oris', [-2:2:2], 'xs', [-2,2], 'ys', [-2,2] );
        oriXYSet_1pos = struct('oris', 0, 'xs', 0, 'ys', 0 );
        oriXYSet_3x3y = struct('oris', 0, 'xs', [-1,0,1], 'ys', [-1,0,1]);
        oriXYSet_5x5y = struct('oris', 0, 'xs', [-2:2], 'ys', [-2:2]);

        oriXYSet_large_fill = struct('oris', [-10:2:10], 'xs', [-1], 'ys', [-1] );
        oriXYSet_large_48 = struct('oris', [-10:2:10], 'xs', [0:2:8], 'ys', [0:2:16]);
        oriXYSet_large_48_k14 = struct('oris', [-10:2:10], 'xs', [0:2:10], 'ys', [0:2:16]);
%         
        oriXYSet_long = struct('oris', [-10:2:10], 'xs', [0:2:46], 'ys', [0:4] );
        
        oriXYSet_long_32_128_dx2_ori = struct('oris', [-10:2:10], 'xs', [14:2:110], 'ys', [0] );
        
        oriXYSet_long_32_128_dx5 = struct('oris', [0], 'xs', [14:5:110], 'ys', [0] );  %Nx = 20
        oriXYSet_long_32_128_dx10 = struct('oris', [0], 'xs', [14:10:110], 'ys', [0] );
        oriXYSet_long_32_128_dx5_ori = struct('oris', [-10:2:10], 'xs', [14:5:110], 'ys', [0] ); % Nx = 10
        oriXYSet_long_32_128_dx10_ori = struct('oris', [-10:2:10], 'xs', [14:10:110], 'ys', [0] );
        
        
        
        oriXYSet_9x9y7o = struct('oris', [-15:5:15], 'xs', [0:3:24], 'ys', [0:3:24]);

        oriXYSet_10x10y11o = struct('oris', [-20:4:20], 'xs', [0:2:18], 'ys', [0:2:18]);
        oriXYSet_10x10y21o = struct('oris', [-20:2:20], 'xs', [0:2:18], 'ys', [0:2:18]);
        
        oriXYSet_5x5y11o = struct('oris', [-20:4:20], 'xs', [0:4:16], 'ys', [0:4:16]);
        
        oriXYSet_5x5y11o_d2 = struct('oris', [-10:2:10], 'xs', [0:2:8], 'ys', [0:2:8]);
        oriXYSet_41o  = struct('oris', [-20:1:20], 'xs', [0], 'ys', [0]);
        oriXYSet_7x7y = struct('oris', [0], 'xs', [0:2:12], 'ys', [0:2:12]);

        
        oriXYSet_1x1y21o = struct('oris', [-20:2:20], 'xs', [0], 'ys', [0]);
        
        oriXYSet_19x19y21o = struct('oris', [-20:2:20], 'xs', [0:1:18], 'ys', [0:1:18]);
        oriXYSet_30x30y21o = struct('oris', [-20:2:20], 'xs', [0:1:29], 'ys', [0:1:29]); % for 96x96
        
        
        oriXYSet_6x9y21o = struct('oris', [-20:2:20], 'xs', [0:2:10], 'ys', [0:2:16] );  % for complexity
        
        oriXYSet_4x4y7o = struct('oris', [-15:5:15], 'xs', [0:3:9], 'ys', [0:3:9] );  % for complexity
        oriXYSet_6x6y11o = struct('oris', [-15:3:15], 'xs', [0:2:10], 'ys', [0:2:10] );  % for complexity
        
        oriXYSet_6x5y21o = struct('oris', [-20:2:20], 'xs', [0:2:10], 'ys', [0:2:8] );  %Nx = 20

        oriXYSet_2x2y3o = struct('oris', [-5:5:5], 'xs', [0, 5], 'ys', [0, 5] );  % for complexity
        oriXYSet_3x6y7o = struct('oris', [-15:5:15], 'xs', [0, 4,8], 'ys', [0 : 4 : 20] );  % for complexity : 1
        oriXYSet_3x6y7o_d2 = struct('oris', [-15:5:15], 'xs', [0,2,4], 'ys', [0 : 2 : 10] );  % for complexity : 1
        
        
        
        oriXYSet_2x_d4 = struct('oris', [0], 'xs', [0, 4], 'ys', [0] );  % for complexity
        oriXYSet_2x2y_d4 = struct('oris', [0], 'xs', [0, 4], 'ys', [0, 4] );  % for complexity
        
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
        
        allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_2x4y_d2, oriXYSet_2x4y_d1, oriXYSet_3x7y_d2, oriXYSet_5x13y_d1, ...
                        oriXYSet_21o_d2, oriXYSet_21o_d2_2x4y_d4, oriXYSet_21o_d2_2x4y_d2, oriXYSet_21o_d2_3x7y_d2, oriXYSet_21o_d2_5x13y_d1};
%         oriXYSet_7o_d5 = struct('oris', [-20:2:20], 'xs', [0], 'ys', [0] );  % for complexity
%         oriXYSet_7o_d5_2x4y_d4 = struct('oris', [-20:2:20], 'xs', [0, 4], 'ys', [0, 4, 8, 12] );  % for complexity
%         oriXYSet_7o_d5_2x4y_d2 = struct('oris', [-20:2:20], 'xs', [0, 2], 'ys', [0, 2, 4, 6] );  % for complexity
%         oriXYSet_7o_d5_3x7y_d2 = struct('oris', [-20:2:20], 'xs', [0:2:4], 'ys', [0 : 2 : 12] );  % for complexity
%         oriXYSet_7o_d5_5x13y_d1 = struct('oris', [-20:2:20], 'xs', [0:1:4], 'ys', [0 : 1 : 12] );  % for complexity
        
        
        oriXYSet_3o_d5 = struct('oris', [-5,0,5], 'xs', [0], 'ys', [0] );  % for complexity
        oriXYSet_7o_d5 = struct('oris', [-15:5:15], 'xs', [0], 'ys', [0] );  % for complexity
        oriXYSet_11o_d4 = struct('oris', [-20:4:20], 'xs', [0], 'ys', [0] );  % for complexity
        
        oriXYSet_13o_d5 = struct('oris', [-30:5:30], 'xs', [0], 'ys', [0] );  % for complexity        
        oriXYSet_19o_d5 = struct('oris', [-45:5:45], 'xs', [0], 'ys', [0] );  % for complexity
        oriXYSet_25o_d5 = struct('oris', [-60:5:60], 'xs', [0], 'ys', [0] );  % for complexity
        oriXYSet_37o_d5 = struct('oris', [-90:5:90], 'xs', [0], 'ys', [0] );  % for complexity
        
        

 
        
        oriXYSet_7x18y_d1_3o_d5 = struct('oris', [-5 : 5 : 5], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
        oriXYSet_7x18y_d1_7o_d5 = struct('oris', [-15 : 5 : 15], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
        oriXYSet_7x18y_d1_11o_d3 = struct('oris', [-15 : 3 : 15], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
%         oriXYSet_7x18y_d1_11o_d4 = struct('oris', [-20 : 4 : 20], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126

        
       oriXYSet_2x2y_d1 = struct('oris', [0], 'xs', [0 : 1 ], 'ys', [0 : 1 ] );  % for channels 2*2 = 4
       oriXYSet_3x3y_d1 = struct('oris', [0], 'xs', [0 : 2 ], 'ys', [0 : 2 ] );  % for channels 3*3 = 9
       oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
       oriXYSet_5x6y_d1 = struct('oris', [0], 'xs', [0 : 4 ], 'ys', [0 : 5 ] );  % for channels 5*6 = 32
       oriXYSet_8x8y_d1 = struct('oris', [0], 'xs', [0 : 7 ], 'ys', [0 : 7 ] );  % for channels 8*8 = 64
       oriXYSet_13x11y_d1 = struct('oris', [0], 'xs', [0 : 1 : 12], 'ys', [0 : 1 : 10] );  % for channels 13*11 = 143
         

       oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
       oriXYSet_4x4y_d1_3o_d5 = struct('oris', [-5:5:5], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
       oriXYSet_4x4y_d1_7o_d5 = struct('oris', [-15:5:15], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
       oriXYSet_4x4y_d1_11o_d1 = struct('oris', [-5:1:5], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
       
%        oriXYSet_5x6y_d1 = struct('oris', [0], 'xs', [0 : 4 ], 'ys', [0 : 5 ] );  % for channels 5*6 = 32
       
               oriXYSet_3x1y_d1 = struct('oris', [0], 'xs', [1 : 3], 'ys', [0] );   % for uncertainty
               oriXYSet_5x1y_d1 = struct('oris', [0], 'xs', [1 : 5], 'ys', [0] );  
               oriXYSet_15x1y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [0] );  
               oriXYSet_30x1y_d1 = struct('oris', [0], 'xs', [1 : 30], 'ys', [0] );  
               oriXYSet_15x2y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [1:2] ); 
               oriXYSet_3x5y_d1 = struct('oris', [0], 'xs', [1:3], 'ys', [1:5] );  
               oriXYSet_5x3y_d1 = struct('oris', [0], 'xs', [1 : 5], 'ys', [1:3] );  
               oriXYSet_2x15y_d1 = struct('oris', [0], 'xs', [1 : 2], 'ys', [1:15] ); 
               oriXYSet_1x30y_d1 = struct('oris', [0], 'xs', [1], 'ys', [1:30] );  
       3;
        %%
               
                                                   
        oriXYSet_3x = { {[0], [-25, 0, 25], [0]} };
        
        oriXYSet_many={ {[0],  [0], [0], };
                           {[0], [0,3], [0]};   % 2x1
                           {[0], [0,3,6], [0]}; % 3x1
                           {[0], [0:6], [0]};    % 7x1
                           {[0], [0:6], [0:6]};  % 7x7
                           {[0], [0:9], [0:9]};  % 10x10
                           {[-4:2:4], [0], [0]};   % 5 x 1x1
                           {[-4:2:4], [0:4], [0:4]};   % 5 x 5 x 5
                           {[-4:2:4], [0:9], [0:9]};   % 5 x 10 x 10
                           %{[-8:2:8], [0:9], [0:9]};  % 10 x 10 x 10 
                           ...{[-20:2:20], [-4:5], [-4:5]};
                           ...{[-30:5:30], [-4:5], [-4:5]}
                       };

       oriXYSet_some = { {[0], [0],  [0]};
                            {[-4:2:4], [0:9], [0:9]};   
                            {[-10:2:10], [0], [0]};   
                            {[-10:2:10], [0:9], [0:9]};   
                            {[-20:2:20], [0:9], [0:9]} ...
                            };
        
                        
%         allSizeStyles = {'med'};
%         allSizeStyles = {'k14'};
        allSizeStyles = {'k16'};
%         allSizeStyles = {'k18'};
%         allSizeStyles = {'k30'};
%           allSizeStyles = {'k32'};
%           allSizeStyles = {'k68'};
%           allSizeStyles = {'k40'};

%         allSizeStyles = {'k9'};
%         allSizeStyles = {'k38'};
%         allSizeStyles = {'k60'};
%         allSizeStyles = {'big'};
%         allSizeStyles = {'large'};
%         allSizeStyles = {'sml', 'med', 'big'};
%         allSizeStyles = {8, 12, 16, 20, 24};
%         allSizeStyles = {[24 8], [16 8], [8 8], 16, 24};
%         allSizeStyles = {15, 16};
        
%         allImageSizes = {'auto'};
%         allImageSizes = {[20, 20], [34 38], [50, 50], [80, 80]};
%         allImageSizes = {[40 80]};

%         allImageSizes = {[45 45]};
%         allImageSizes = {[65 65]};
%         allImageSizes = {[72 72]};
%         allImageSizes = {[128 128]};

        allImageSizes = {[32 32]};
%         allImageSizes = {[32 80]};
%         allImageSizes = {[48 48]};
%         allImageSizes = {[64 64]};
%         allImageSizes = {[144 144]};

%         allImageSizes = {[36 88]};
%         allImageSizes = {[36 116]};
%         allImageSizes = {[36 164]};
%         allImageSizes = {[32 128]};

        if doOverFeat
            allSizeStyles = {'k68'};
%             allSizeStyles = {[128 64]};
%             allSizeStyles = {'k60'};
            allImageSizes = {[231, 231]};
            
        end


%         allSizeStyle_imageSizes = { {'k9', [35 35]}, {'k18', [49 49]}, {'k36', [99 99]}, {'k72', [147 147]} };
%         allSizeStyle_imageSizes = { {'k16', [32 32]} };
        if doTextureStatistics
%             allSizeStyle_imageSizes = { {'k32', [64, 64]}, {'k16', [32 32]} };
%             allSizeStyle_imageSizes = { {'k16', [32 32]} };
        end
%         allSizeStyle_imageSizes = { {'k32', [64, 64]}, {'k16', [32 32]} };
%         allSizeStyle_imageSizes = { {'k32', [64, 64]} };

%         allSizeStyle_imageSizes = { {'k30', [64, 64]}, {'k15', [32, 32]} };
%         allSizeStyle_imageSizes = { {'k15', [32, 32]} };
        allSizeStyle_imageSizes = { {'k24', [64, 64]} };

%         allBlurStd = {1,1.5,2,3};
%         allBlurStd = {0, 1, 2};
        allBlurStd = {0};
%         allNoise

        if strcmp(expName, 'Grouping')
%             allSizeStyle_imageSizes = { {55, [64, 64]} };
%             allSizeStyle_imageSizes = { {55, [96, 96]} };
%             allSizeStyle_imageSizes = { {'k32', [64, 64]} };
%             allSizeStyle_imageSizes = { {'k64', [128, 128]} };
            
        end

%         allCycPerLet_prev = [0.5,   0.8,   1.3,   2.0,    3.2,   5.1,   8.1,  13];

        
%         allCycPerLet = [0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13, 20.7];  % , 20.7
%         allCycPerLet = [0.8, 20.7];
        
%         allCycPerLet = [0.5, 0.71, 1, 1.41, 2, 2.83, 4, 5.66, 8, 11.31, 16];  
%         allCycPerLet = [0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.45, 16]; % roundToNearest(2.^[-1:.25:4], 0.01)
        allCycPerLet = [0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.45, 16]; % roundToNearest(2.^[-1:.25:4], 0.01)
%         allCycPerLet = fliplr(allCycPerLet);
%         allCycPerLet = [8];
%         allCycPerLet = [0.5, 0.71, 1, 1.41, 2, 2.83, 4, 5.66, 8, 10];  
%         allCycPerLet = [0.5, 1, 2, 4, 8];
        
%         allCycPerLet = [0.5, 0.71, 1, 1.41, 2, 2.83, 4, 5.66, 8];
%         allCycPerLet = [4, 5.66, 8, 11.31, 16];
        
%         [0.5, 0.7, 1, 1.4, 2, 2.8, 4, 5.7, 8.0000   11.3000   16.0000
            
        
%         allCycPerLet = [0.5, 1, 2, 4, 8];
%             allCycPerLet= [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];

%         f_exps = [0.5, 1, 1.5, 2];
%         allF_exps = [1, 1.5, 2];
%         allF_exps = {[1, 0], [1.5, 0], [1.6, 0], [1.7, 0], [1.7, 0.2],  2};

%         allF_exps = {[1, 0], [1.5, 0], [1.7, 0], [2 0]};
%         allF_exps_pink = {[1, 0], [1.7, 0],  [1.6, 0]};
        allF_exps_pink_1_2 = {[1.0, 0], [1.2, 0], [1.4, 0], [1.6, 0], [1.8, 0], [2.0, 0]};
%         allF_exps_pink = {[1.0, 0], [1.6, 0]};
        allF_exps_pink = {[1.0, 0], [1.6, 0], [2.0, 0]};
        allF_exps_pink_wide = {[1.0, 0.3], [1.0, 0.2],   [1.0, 0.0], ...
                               [1.6, 0.3], [1.6, 0.2],   [1.6, 0.0], ...
                               [2.0, 0.3], [2.0, 0.2],   [2.0, 0.0]};
        
        allF_exps_pinkOrWhite = {[1, 0]};
        F_exp_pink = 1;
        F_exp_pink_std = 0;
%         allPinkWhiteRatios = {0.25, 0.5, 1, 2, 4};
        allPinkWhiteRatios = {0.00001, 0.5, 1, 2, 10000};
%         allF_exps = [1];
%         cyc_per_let
%         bandPass
%         cyc_per_pix = cyc_per_let*18;

        allPinkNoiseFilters_1_2       = cellfun(@(f) struct('filterType', '1/f',       'f_exp', f(1), 'f_exp_std', f(2), 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allF_exps_pink_1_2, 'un', 0);
        allPinkNoiseFilters          = cellfun(@(f) struct('filterType', '1/f',       'f_exp', f(1), 'f_exp_std', f(2), 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allF_exps_pink, 'un', 0);
        allPinkPlusWhiteNoiseFilters = cellfun(@(r) struct('filterType', '1/fPwhite', 'f_exp', F_exp_pink, 'f_exp_std', F_exp_pink_std,  'ratio', r, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allPinkWhiteRatios, 'un', 0);
        allPinkOrWhiteNoiseFilters   = cellfun(@(r) struct('filterType', '1/fOwhite', 'f_exp', F_exp_pink, 'f_exp_std', F_exp_pink_std,  'ratio', r, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allPinkWhiteRatios, 'un', 0);
        allPinkWideNoiseFilters      = cellfun(@(f) struct('filterType', '1/f',       'f_exp', f(1), 'f_exp_std', f(2), 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allF_exps_pink_wide, 'un', 0);
        
        allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_band), allCycPerLet, 'un', 0);
        allHighPassNoiseFilters = arrayfun(@(f) struct('filterType', 'hi', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_hiLo), allCycPerLet, 'un', 0);
        allLowPassNoiseFilters = arrayfun(@(f) struct('filterType', 'lo', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_hiLo), allCycPerLet, 'un', 0);
        
        whiteNoiseFilter = {struct('filterType', 'white', 'applyFourierMaskGainFactor', false)};

        
%         NoiseFilters = [allBandNoiseFilters, allPinkNoiseFilters, whiteNoiseFilter];
%         NoiseFilters = [allPinkNoiseFilters, allPinkOrWhiteNoiseFilters, allPinkPlusWhiteNoiseFilters,whiteNoiseFilter ];

%         NoiseFilters = [whiteNoiseFilter];
        NoiseFilters = [allPinkNoiseFilters, whiteNoiseFilter];


                
%         all_trainPositions = {'all'};
%         all_testPositions = {'all'};
%         allNDistractors = [0];
%         allLogDNRs = [0];
        allCrowdingSettings = { [] };

%         allXranges = {[]};  allTrainPositions = {[]}; allTestPositions = {[]}; % = binarySearch(15:4:87, [15, 39, 51])  
%         allNDistractors = [0];
        
%         NoiseFilters = allBandNoiseFilters;
%         NoiseFilters = allHighPassNoiseFilters;
        switch expName
            case 'ChannelTuning'
%                 if applyFourierMaskGainFactor
%                  NoiseFilters = [allPinkNoiseFilters, whiteNoiseFilter, allBandNoiseFilters, allLowPassNoiseFilters, allHighPassNoiseFilters];
%                 NoiseFilters = [allPinkOrWhiteNoiseFilters, allPinkPlusWhiteNoiseFilters, whiteNoiseFilter, allPinkNoiseFilters ];

%                 NoiseFilters = allPinkWideNoiseFilters;
%                 NoiseFilters = [allBandNoiseFilters, whiteNoiseFilter, allPinkNoiseFilters_1_2];
%                 NoiseFilters = [allPinkNoiseFilters, whiteNoiseFilter, allBandNoiseFilters];
%                 NoiseFilters = [whiteNoiseFilter, allBandNoiseFilters];
                NoiseFilters = [allBandNoiseFilters];
% %                    NoiseFilters = allPinkPlusWhiteNoiseFilters;
%                    NoiseFilters = [allPinkNoiseFilters(1), whiteNoiseFilter];
%                 NoiseFilters = [allPinkNoiseFilters_1_2, whiteNoiseFilter]; 
                
                
                
%                 NoiseFilters = [whiteNoiseFilter, allPinkNoiseFilters, allBandNoiseFilters];
%                     NoiseFilters = [whiteNoiseFilter, allPinkNoiseFilters];
%                     NoiseFilters = [allBandNoiseFilters(allCycPerLet == 8)];
%                     NoiseFilters = [allPinkNoiseFilters];

%                 allSizeStyle_imageSizes = { {'k32', [64, 64]} };
%                 allSizeStyle_imageSizes = { {'k15', [32, 32]} };
%                 allSizeStyle_imageSizes = { {'k30', [64, 64]} };
%                 allSizeStyle_imageSizes = {  {'k20', [32, 32]}, {'k20', [36, 36]} };
%                 allSizeStyle_imageSizes = {  {'k15', [30, 30]}  };
%                 allSizeStyle_imageSizes = {  {'k15', [45, 45]}  };
%                 allSizeStyle_imageSizes = {  {'k30', [45, 45]}  };
%                 allSizeStyle_imageSizes = {  {'k30', [64, 64]}  };
                allSizeStyle_imageSizes = {  {'k36', [64, 64]}  };
%                 allSizeStyle_imageSizes = {  {'k15', [64, 64]}  };
         
%                 allUncertaintySets = {oriXYSet_4x4y7o, oriXYSet_6x6y11o,  oriXYSet_6x5y21o, oriXYSet_1pos};
%                 allUncertaintySets = {oriXYSet_1pos, oriXYSet_3o_d5};
                
%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_2x4y_d2, oriXYSet_2x4y_d1, oriXYSet_3x7y_d2, oriXYSet_5x13y_d1, ...
%                         oriXYSet_21o_d2, oriXYSet_21o_d2_2x4y_d4, oriXYSet_21o_d2_2x4y_d2, oriXYSet_21o_d2_3x7y_d2, oriXYSet_21o_d2_5x13y_d1};
                oriXYSet_30x39y_d1 = struct('oris', [0], 'xs', [1 : 1 : 30], 'ys', [1 : 1 : 39] );  % for complexity 31*39 = 1209
                
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x2y_d1,    oriXYSet_3x3y_d1, oriXYSet_4x4y_d1, oriXYSet_5x6y_d1, oriXYSet_8x8y_d1, oriXYSet_13x11y_d1};
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_4x4y_d1, oriXYSet_4x4y_d1_3o_d5, oriXYSet_4x4y_d1_7o_d5, oriXYSet_4x4y_d1_11o_d1 };
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_4x4y_d1, oriXYSet_4x4y_d1_3o_d5, oriXYSet_4x4y_d1_7o_d5, oriXYSet_4x4y_d1_11o_d1 };
%                     allUncertaintySets = { oriXYSet_13x11y_d1, oriXYSet_8x8y_d1, oriXYSet_4x4y_d1};

                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_30x39y_d1, oriXYSet_4x4y_d1, };
                    if doTextureStatistics
                        allUncertaintySets = { oriXYSet_1pos };
                    end
                    

                
%                 allUncertaintySets = {oriXYSet_2x2y3o, oriXYSet_4x4y7o, oriXYSet_1pos};
                                
                  loopKeysOrder = {'noiseFilter'};   % { 'textureSettings', 'OriXY',  'fontName',  ,} 
           
            
            case 'Complexity',     
%                 allSizeStyle_imageSizes = {  {'k30', [64, 64]}  };
%                 allSizeStyle_imageSizes = {  {'k15', [56, 56]}  };
%                 allSizeStyle_imageSizes = {  {'k15', [64, 64]}, {'k24', [64, 64]} };
%                 allSizeStyle_imageSizes = {  {'k30', [80, 80]}  };
%                 NoiseFilters = [whiteNoiseFilter, allPinkNoiseFilters];
%                 NoiseFilters = [allPinkNoiseFilters, whiteNoiseFilter];
                NoiseFilters = [whiteNoiseFilter];


                
%                 allUncertaintySets = {oriXYSet_4x4y7o, oriXYSet_6x6y11o, oriXYSet_6x9y21o, oriXYSet_1pos};
%                 allUncertaintySets = {oriXYSet_2x2y3o, oriXYSet_4x4y7o, oriXYSet_1pos};

%                 allUncertaintySets = {oriXYSet_2x2y3o, oriXYSet_3x6y7o_d2, oriXYSet_3x6y7o, oriXYSet_1pos}; % [k30, 64x64] ;

%                 allUncertaintySets = {oriXYSet_1pos};

%                 allUncertaintySets = { oriXYSet_2x_d4, oriXYSet_2x2y_d4, oriXYSet_2x4y_d4, oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2, oriXYSet_1pos};
                
%                 allUncertaintySets = { oriXYSet_13o_d5, oriXYSet_19o_d5, oriXYSet_25o_d5, oriXYSet_37o_d5, oriXYSet_1pos};
                
                
%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_13o_d5, oriXYSet_19o_d5, oriXYSet_25o_d5, oriXYSet_37o_d5, oriXYSet_1pos};
                             
        
%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_2x4y_d2, oriXYSet_2x4y_d1, oriXYSet_3x7y_d2, oriXYSet_5x13y_d1, ...
%                         oriXYSet_21o_d2, oriXYSet_21o_d2_2x4y_d4, oriXYSet_21o_d2_2x4y_d2, oriXYSet_21o_d2_3x7y_d2, oriXYSet_21o_d2_5x13y_d1};

%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_7x18y_d1, oriXYSet_7x18y_d1_3o_d5, oriXYSet_7x18y_d1_7o_d5, oriXYSet_7x18y_d1_11o_d3};

                allSizeStyle_imageSizes = {  {'k15', [64, 64]}  };
%                 allUncertaintySets = { oriXYSet_1pos };

                oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_5x13y_d1_3ori_d5 = struct('oris', [-5:5:5], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                oriXYSet_5x13y_d1_3ori_d10 = struct('oris', [-10:10:10], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                oriXYSet_5x13y_d1_3ori_d15 = struct('oris', [-15:15:15], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                oriXYSet_5x13y_d1_3ori_d30 = struct('oris', [-30:30:30], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                
                allUncertaintySets = {oriXYSet_1pos, oriXYSet_5x13y_d1, oriXYSet_5x13y_d1_3ori_d5, oriXYSet_5x13y_d1_3ori_d10, oriXYSet_5x13y_d1_3ori_d15, oriXYSet_5x13y_d1_3ori_d30};

                
                oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_6x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 6], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_5x14y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 14] );  % for complexity  5*13   = 65                
                
                allUncertaintySets = {oriXYSet_1pos, oriXYSet_5x13y_d1, oriXYSet_6x13y_d1, oriXYSet_5x14y_d1};
                
                
                oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity 5*13   = 65
                oriXYSet_7x18y_d1 = struct('oris', [0], 'xs', [1 : 1 : 7], 'ys', [1 : 1 : 18] );  % for complexity 7*18   = 126
                oriXYSet_10x26y_d1 = struct('oris', [0], 'xs', [1 : 1 : 10], 'ys', [1 : 1 : 26] );  % for complexity 10*26  = 260
                oriXYSet_14x37y_d1 = struct('oris', [0], 'xs', [1 : 1 : 14], 'ys', [1 : 1 : 37] );  % for complexity 14*37  = 518
                oriXYSet_30x39y_d1 = struct('oris', [0], 'xs', [1 : 1 : 30], 'ys', [1 : 1 : 39] );  % for complexity 31*39 = 1209
                oriXYSet_15x20y_d1 = struct('oris', [0], 'xs', [1 : 1 : 15], 'ys', [1 : 1 : 20] );  % for complexity 31*39 = 1209
                oriXYSet_15x20y_d2 = struct('oris', [0], 'xs', [1 : 2 : 30], 'ys', [1 : 2 : 39] );  % for complexity 31*39 = 1209
                
                allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x20y_d1, oriXYSet_15x20y_d2, oriXYSet_30x39y_d1};
%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_5x13y_d1,    oriXYSet_7x18y_d1, oriXYSet_10x26y_d1, oriXYSet_14x37y_d1, oriXYSet_30x39y_d1};

                allUncertaintySets = { oriXYSet_15x20y_d2, oriXYSet_30x39y_d1};
                
                
                
                 if doTextureStatistics
%                      allUncertaintySets = { oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2, oriXYSet_1pos};
                     allUncertaintySets = { oriXYSet_1pos,   oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2,      oriXYSet_13o_d5, oriXYSet_19o_d5, oriXYSet_25o_d5, oriXYSet_37o_d5 };
                       allSizeStyle_imageSizes = {  {'k15', [64, 64]}  };
                 end

                 loopKeysOrder = {'fontName'}; 
            case 'Grouping', 
%                 NoiseFilters = [whiteNoiseFilter, allPinkNoiseFilters];
                NoiseFilters = [whiteNoiseFilter];
            
                allSizeStyle_imageSizes = { {'k55', [64, 64]} };
                
%                 allSizeStyle_imageSizes = { {'k48', [96, 96]} };
%                 allSizeStyle_imageSizes = { {'k32', [64, 64]} };
%                 allSizeStyle_imageSizes = { {'k32', [80, 80]} };
%                 allSizeStyle_imageSizes = { {'k27', [64, 64]} };
%                 allSizeStyle_imageSizes = { {'k48', [64, 64]} };
%                 allSizeStyle_imageSizes = { {'k32', [40, 40]} };
%                 allSizeStyle_imageSizes = { {'k32', [96, 96]} };
                
%                 allUncertaintySets = { oriXYSet_30x30y21o  };
%                 allUncertaintySets = {  oriXYSet_10x10y21o };
                if doTextureStatistics
                    allUncertaintySets = {oriXYSet_1pos,  oriXYSet_3o_d5, oriXYSet_13o_d5, oriXYSet_21o_d2,   oriXYSet_25o_d5 }; % for texture
                else
%                     allUncertaintySets = {  oriXYSet_10x10y21o,  oriXYSet_5x5y11o, oriXYSet_1pos };
                    
%                     allUncertaintySets = {oriXYSet_5x5y11o_d2, oriXYSet_41o, oriXYSet_7x7y};
            
                   oriXYSet_2x2y_d1 = struct('oris', [0], 'xs', [0 : 1 ], 'ys', [0 : 1 ] );  % for complexity 2*2 = 4
                   oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for complexity 4*4 = 16
                   oriXYSet_8x8y_d1 = struct('oris', [0], 'xs', [0 : 7 ], 'ys', [0 : 7 ] );  % for complexity 8*8 = 64
                   oriXYSet_16x16y_d1 = struct('oris', [0], 'xs', [0 : 15 ], 'ys', [0 : 15 ] );  % for complexity 16*16 = 256
                   
                   
                   
                   
                   %                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x2y_d1,    oriXYSet_4x4y_d1, oriXYSet_8x8y_d1, oriXYSet_16x16y_d1, oriXYSet_22x22y_d1};


                   oriXYSet_15x15y_d1 = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 15 ] );  % for complexity 15*15 = 225
                   oriXYSet_7x7y_d2 = struct('oris', [0], 'xs', [1 : 2: 15 ], 'ys', [1 : 2 : 15 ] );  % for complexity 7*7 = 49

                   oriXYSet_21x21y_d1 = struct('oris', [0], 'xs', [1 :    21 ], 'ys', [1 : 21 ] );  % for complexity 21*21 = 225
                   oriXYSet_10x10y_d2 = struct('oris', [0], 'xs', [1 : 2: 21 ], 'ys', [1 : 2 : 21 ] );  % for complexity 15*15 = 225

                   oriXYSet_11o_15x15y_d1 = struct('oris', [-10:2:10], 'xs', [1 : 1: 15 ], 'ys', [1 : 15 ] );  % for complexity 15*15 = 225
                   oriXYSet_11o_7x7y_d2   = struct('oris', [-10:2:10], 'xs', [1 : 2: 15 ], 'ys', [1 : 2 : 15 ] );  % for complexity 15*15 = 225

                   oriXYSet_11o_21x21y_d1 = struct('oris', [-10:2:10], 'xs', [1 : 1:  21 ], 'ys', [1 : 21 ] );     % for complexity 15*15 = 225
                   oriXYSet_11o_10x10y_d2 = struct('oris', [-10:2:10], 'xs', [1 : 2: 21 ], 'ys', [1 : 2 : 21 ] );  % for complexity 15*15 = 225

                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x15y_d1,    oriXYSet_7x7y_d2, oriXYSet_21x21y_d1, oriXYSet_10x10y_d2, ...
                       oriXYSet_11o_15x15y_d1, oriXYSet_11o_7x7y_d2,  oriXYSet_11o_21x21y_d1, oriXYSet_11o_10x10y_d2 };


                   
                   oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
                   oriXYSet_15x19y_d1_3o_d5       = struct('oris', [-5:5:5], 'xs', [1 : 15 ], 'ys', [1 : 19 ] ); 
                   oriXYSet_15x19y_d1_7o_d5       = struct('oris', [-15:5:15], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
                   oriXYSet_15x19y_d1_21o_d2       = struct('oris', [-20:2:20], 'xs', [1 : 15 ], 'ys', [1 : 19 ] ); 
                   oriXYSet_15x19y_d1_11o_d1       = struct('oris', [-5:1:5], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
                   oriXYSet_15x19y_d1_31o_d1       = struct('oris', [-15:1:15], 'xs', [1 : 15 ], 'ys', [1 : 19 ] ); 

                   
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_15x19y_d1_3o_d5, oriXYSet_15x19y_d1_7o_d5, ...
%                                            oriXYSet_15x19y_d1_21o_d2, oriXYSet_15x19y_d1_11o_d1, oriXYSet_15x19y_d1_31o_d1};
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_15x19y_d1_3o_d5, oriXYSet_15x19y_d1_7o_d5, ...
%                                            oriXYSet_15x19y_d1_21o_d2, oriXYSet_15x19y_d1_11o_d1, oriXYSet_15x19y_d1_31o_d1};
                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1};
                    
%                     allUncertaintySets = {  oriXYSet_1pos  };
        
                   oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
                   oriXYSet_22x26y_d1             = struct('oris', [0], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
                   oriXYSet_22x26y_d1_21o_d1      = struct('oris', [-10:1:10], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
                   oriXYSet_22x26y_d1_41o_d1      = struct('oris', [-20:1:20], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
                   
                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, oriXYSet_22x26y_d1_21o_d1, ...
                                           oriXYSet_22x26y_d1_41o_d1};

                                       
                                       
                   oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
                   oriXYSet_22x26y_d1             = struct('oris', [0], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
                   oriXYSet_31x36y_d1             = struct('oris', [0], 'xs', [1 : 31 ], 'ys', [1 : 36 ] ); 
                   oriXYSet_45x47y_d1             = struct('oris', [0], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
                   oriXYSet_45x47y_d1_21o_d1      = struct('oris', [-10:1:10], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
                   oriXYSet_45x47y_d1_41o_d1      = struct('oris', [-20:1:20], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
                   
                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, oriXYSet_31x36y_d1, ...
                                           oriXYSet_45x47y_d1, oriXYSet_45x47y_d1_21o_d1, oriXYSet_45x47y_d1_41o_d1};

                    allUncertaintySets = { oriXYSet_1pos };

                     oriXYSet_2x_d1 = struct('oris', [0], 'xs', [0 : 1 : 1], 'ys', [0] );  
                     oriXYSet_2x_d2 = struct('oris', [0], 'xs', [0 : 2 : 2], 'ys', [0] );  
                     oriXYSet_2x_d3 = struct('oris', [0], 'xs', [0 : 3 : 3], 'ys', [0] );  
                     oriXYSet_2x_d4 = struct('oris', [0], 'xs', [0 : 4 : 4], 'ys', [0] );  
                     oriXYSet_2x_d6 = struct('oris', [0], 'xs', [0 : 6 : 6], 'ys', [0] );  
                     oriXYSet_2x_d8 = struct('oris', [0], 'xs', [0 : 8 : 8], 'ys', [0] );  
                     oriXYSet_2x_d16= struct('oris', [0], 'xs', [0 : 16 : 16], 'ys', [0] );  

                     allUncertaintySets = {oriXYSet_2x_d1, oriXYSet_2x_d2, oriXYSet_2x_d3, oriXYSet_2x_d4, oriXYSet_2x_d6, oriXYSet_2x_d8, oriXYSet_2x_d16};
                    
                     oriXYSet_24x24y_d1_3ori_d5             = struct('oris', [-5, 0, 5], 'xs', [1 : 24], 'ys', [1 : 24]);
                     oriXYSet_24x24y_d1             = struct('oris', [0], 'xs', [1 : 24], 'ys', [1 : 24]);
                     oriXYSet_26x26y_d1             = struct('oris', [0], 'xs', [1 : 26], 'ys', [1 : 26]);
                     oriXYSet_28x28y_d1             = struct('oris', [0], 'xs', [1 : 28], 'ys', [1 : 28]);

                     oriXYSet_12x12y_d2             = struct('oris', [0], 'xs', [1 : 2 : 24], 'ys', [1 : 2 : 24]);
                     oriXYSet_6x6y_d4               = struct('oris', [0], 'xs', [1 : 4 : 24], 'ys', [1 : 4 : 24]);
                     oriXYSet_4x4y_d6               = struct('oris', [0], 'xs', [1 : 6 : 24], 'ys', [1 : 6 : 24]);

                     allUncertaintySets = {oriXYSet_24x24y_d1_3ori_d5, oriXYSet_24x24y_d1, oriXYSet_26x26y_d1, oriXYSet_28x28y_d1, oriXYSet_12x12y_d2}; % oriXYSet_6x6y_d4, oriXYSet_4x4y_d6};
                     
                     
%                      allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1};
                     
                    oriXYSet_7x7y_d1 = struct('oris', [0], 'xs', [1:7], 'ys', [1:7]);
                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_7x7y_d1};
                     
                     
%                      allUncertaintySets = {oriXYSet_24x24y_d1, oriXYSet_26x26y_d1, oriXYSet_28x28y_d1, oriXYSet_12x12y_d2, oriXYSet_6x6y_d4, oriXYSet_4x4y_d6};

% %                      allUncertaintySets = {oriXYSet_26x26y_d1};
%       
% %                    oriXYSet_38x38y_d1             = struct('oris', [0], 'xs', [1 : 38 ], 'ys', [1 : 38 ] ); 
% %                    oriXYSet_39x39y_d1             = struct('oris', [0], 'xs', [1 : 39 ], 'ys', [1 : 39 ] ); 
%                    oriXYSet_40x40y_d1             = struct('oris', [0], 'xs', [1 : 40 ], 'ys', [1 : 40 ] ); 
%                    oriXYSet_41x41y_d1             = struct('oris', [0], 'xs', [1 : 41 ], 'ys', [1 : 41 ] ); 
%                    oriXYSet_42x42y_d1             = struct('oris', [0], 'xs', [1 : 42 ], 'ys', [1 : 42 ] ); 
%                    oriXYSet_43x43y_d1             = struct('oris', [0], 'xs', [1 : 43 ], 'ys', [1 : 43 ] ); 
%                    oriXYSet_44x44y_d1             = struct('oris', [0], 'xs', [1 : 44 ], 'ys', [1 : 44 ] ); 
%                    
%                    oriXYSet_40x40y_d1_3ori_d5             = struct('oris', [-5, 0, 5], 'xs', [1 : 40 ], 'ys', [1 : 40 ] ); 
%                    oriXYSet_41x41y_d1_3ori_d5             = struct('oris', [-5, 0, 5], 'xs', [1 : 41 ], 'ys', [1 : 41 ] ); 
%                    oriXYSet_42x42y_d1_3ori_d5             = struct('oris', [-5, 0, 5], 'xs', [1 : 42 ], 'ys', [1 : 42 ] ); 
%                    oriXYSet_43x43y_d1_3ori_d5             = struct('oris', [-5, 0, 5], 'xs', [1 : 43 ], 'ys', [1 : 43 ] ); 
%                    oriXYSet_44x44y_d1_3ori_d5             = struct('oris', [-5, 0, 5], 'xs', [1 : 44 ], 'ys', [1 : 44 ] ); 
% 
%                    oriXYSet_40x40y_d1_11ori_d1             = struct('oris', [-5 : 1 : 5], 'xs', [1 : 40 ], 'ys', [1 : 40 ] ); 
%                    oriXYSet_41x41y_d1_11ori_d1             = struct('oris', [-5 : 1 : 5], 'xs', [1 : 41 ], 'ys', [1 : 41 ] ); 
%                    oriXYSet_42x42y_d1_11ori_d1             = struct('oris', [-5 : 1 : 5], 'xs', [1 : 42 ], 'ys', [1 : 42 ] ); 
%                    oriXYSet_43x43y_d1_11ori_d1             = struct('oris', [-5 : 1 : 5], 'xs', [1 : 43 ], 'ys', [1 : 43 ] ); 
%                    oriXYSet_44x44y_d1_11ori_d1             = struct('oris', [-5 : 1 : 5], 'xs', [1 : 44 ], 'ys', [1 : 44 ] ); 
% %                     allUncertaintySets = { oriXYSet_38x38y_d1, oriXYSet_40x40y_d1,  oriXYSet_42x42y_d1};
%                     
% %                     allUncertaintySets = { oriXYSet_38x38y_d1, oriXYSet_40x40y_d1,  oriXYSet_41x41y_d1, oriXYSet_42x42y_d1, ...
% %                         oriXYSet_39x39y_d1, oriXYSet_41x41y_d1, oriXYSet_43x43y_d1};
% %                     allUncertaintySets = { oriXYSet_40x40y_d1,  oriXYSet_41x41y_d1, oriXYSet_42x42y_d1, ...
% %                         oriXYSet_43x43y_d1, oriXYSet_44x44y_d1};
% 
%                     allUncertaintySets = { oriXYSet_40x40y_d1,  oriXYSet_41x41y_d1, oriXYSet_42x42y_d1, oriXYSet_43x43y_d1, oriXYSet_44x44y_d1, ...
%                         oriXYSet_40x40y_d1_3ori_d5,  oriXYSet_41x41y_d1_3ori_d5, oriXYSet_42x42y_d1_3ori_d5, oriXYSet_43x43y_d1_3ori_d5, oriXYSet_44x44y_d1_3ori_d5, ...
%                         oriXYSet_40x40y_d1_11ori_d1,  oriXYSet_41x41y_d1_11ori_d1, oriXYSet_42x42y_d1_11ori_d1, oriXYSet_43x43y_d1_11ori_d1, oriXYSet_44x44y_d1_11ori_d1};                    
                                         
                end
                
                 loopKeysOrder = {'OriXY', 'fontName'}; 
                
            case 'Uncertainty',
                allFontNames = {'Bookman', 'Sloan'};
                
%                 allSizeStyle_imageSizes = {  {'k15', [64, 64]} };
                 allSizeStyle_imageSizes = {  {'k15', [32, 160]} };
               NoiseFilters = [whiteNoiseFilter];
               
               oriXYSet_3x1y_d1 = struct('oris', [0], 'xs', [1 : 3], 'ys', [0] );  
               oriXYSet_5x1y_d1 = struct('oris', [0], 'xs', [1 : 5], 'ys', [0] );  
               oriXYSet_15x1y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [0] );  
               oriXYSet_30x1y_d1 = struct('oris', [0], 'xs', [1 : 30], 'ys', [0] );  
               oriXYSet_15x2y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [1:2] ); 
               oriXYSet_3x5y_d1 = struct('oris', [0], 'xs', [1:3], 'ys', [1:5] );  
               oriXYSet_5x3y_d1 = struct('oris', [0], 'xs', [1 : 5], 'ys', [1:3] );  
               oriXYSet_2x15y_d1 = struct('oris', [0], 'xs', [1 : 2], 'ys', [1:15] ); 
               oriXYSet_1x30y_d1 = struct('oris', [0], 'xs', [1], 'ys', [1:30] );  
               
%                allUncertaintySets = {oriXYSet_1pos, oriXYSet_3x1y_d1, oriXYSet_5x1y_d1, oriXYSet_15x1y_d1, oriXYSet_30x1y_d1, oriXYSet_15x2y_d1, oriXYSet_3x5y_d1, oriXYSet_5x3y_d1, oriXYSet_2x15y_d1, oriXYSet_1x30y_d1 };

               
               oriXYSet_3x_d3 = struct('oris', [0], 'xs', [1  : 3 : 3*3], 'ys', [0] );  
               oriXYSet_7x_d3 = struct('oris', [0], 'xs', [1  : 3 : 7*3], 'ys', [0] );  
               oriXYSet_15x_d3 = struct('oris', [0], 'xs', [1 : 3 : 15*3], 'ys', [0] );  
               oriXYSet_20x_d3 = struct('oris', [0], 'xs', [1 : 3 : 20*3], 'ys', [0] );  
               oriXYSet_30x_d3 = struct('oris', [0], 'xs', [1 : 3 : 30*3], 'ys', [0] );  
               oriXYSet_45x_d3 = struct('oris', [0], 'xs', [1 : 3 : 45*3], 'ys', [0] );  
               
               allUncertaintySets = {oriXYSet_1pos, oriXYSet_3x_d3, oriXYSet_7x_d3, oriXYSet_15x_d3, oriXYSet_20x_d3, oriXYSet_30x_d3, oriXYSet_45x_d3};
               
                loopKeysOrder = {'OriXY', 'fontName'}; 
            case 'TestConvNet',
                NoiseFilters = [whiteNoiseFilter];
                
                
            case 'Crowding',
%                 NoiseFilters = [allPinkNoiseFilters, whiteNoiseFilter];
                allUncertaintySets = {oriXYSet_1pos};
                NoiseFilters = [whiteNoiseFilter];
                
%                 allSizeStyle_imageSizes = {  {'k16', [32, 160]} };
                allSizeStyle_imageSizes = {  {'k15', [32, 160]} };

                if doOverFeat
                    allImageSizes = {[231, 231]};
                end
                
                
%                 oriXYSet_xrange = struct('oris', [0], 'xs', [-16 : 12 : 176], 'ys', [0] );  
%                 allTrainPositions = {}; allTestPositions = {9}; % = binarySearch(15:4:87, [15, 39, 51])  
%                 allXranges = {[-16, 12, 176]};  
%                 allNDistractors = [2, 1];

                
                all_xrange_and_trainPositions_and_testPositions = {...
                    {[-16, 12, 176], [3:15], 9}, ...    (-16 -4) 8 20 32 44 56 68 [[80]] 92 104 116 128 140 152 (164 176)
                    {[-16, 8, 176],  [3:23], 13} ...      (-16 -8) 0 8 16 24 32 40 48 56 64 72 [80] 88 96 104 112 120 128 136 144 152 160 (168 176)
                 };

             
%  {[-16, 8, 176], [3:15], 9} ...   
%                 all_trainPositions = {[3:15]};
%                 all_testPositions = {9};
                allNDistractors = [2, 1];
%                 allLogDNRs = [2.5, 2.9]; 
                allLogDNRs = [3.5]; 
                
%                 allCrowdingOpts = (struct('tbl_trainPositions', {all_trainPositions}, ...
%                                           'tbl_testPositions', {all_testPositions}, ...
%                                           'xrange', [-16, 12, 176], ...
%                                           'allNDistractors',   allNDistractors, ...
%                                           'allLogDNRs',        allLogDNRs, ...
%                                           'absHorizPosition',  true ...
%                                           ) );
                allCrowdingOpts = (struct('tbl_xrange_and_trainPositions_and_testPositions', {all_xrange_and_trainPositions_and_testPositions}, ...
                                          'allNDistractors',   allNDistractors, ...
                                          'allLogDNRs',        allLogDNRs, ...
                                          'absHorizPosition',  true ...
                                          ) );
                allCrowdingSettings = num2cell(  expandOptionsToList (allCrowdingOpts)  );
                
                
                loopKeysOrder = {'textureSettings'};   % { 'textureSettings', 'OriXY',  'fontName',  ,}       
        end

        
        
%         NoiseFilters = [allHighPassNoiseFilters, allLowPassNoiseFilters];
%         NoiseFilters = [allPinkNoiseFilters, whiteNoiseFilter, allBandNoiseFilters];
%         NoiseFilters = [allPinkOrWhiteNoiseFilters];
%         num2cell( };
         if strcmp(expName, 'Grouping')
             
      
%             oriXYSet_21x21y21o = struct('oris', [-20:2:20], 'xs', [0:2:40], 'ys', [0:2:40]); % for 128x128
            
            
%             allUncertaintySets = { oriXYSet_10x10y21o, oriXYSet_10x10y11o, oriXYSet_1pos };
%             allUncertaintySets = { oriXYSet_10x10y21o };

%             allUncertaintySets = {  oriXYSet_19x19y21o, oriXYSet_10x10y21o  };
%             
%             allUncertaintySets = { oriXYSet_1pos };

%             NoiseFilters = [whiteNoiseFilter];
     
            %%
            dWiggle = 5;
            no_wiggle = [1];
            ori_wiggles = [dWiggle:dWiggle:90];
            offset_wiggles = [dWiggle:dWiggle:60];
            phase_wiggles = [1];
            doNoWiggles = false;
            doOriWiggles = true;
            doOffsetWiggles = false;
            doPhaseWiggles = false;
            if ~doNoWiggles, no_wiggle = []; end
            if ~doOriWiggles, ori_wiggles = []; end
            if ~doOffsetWiggles, offset_wiggles = []; end
            if ~doPhaseWiggles, phase_wiggles = []; end
                
            
            allWiggleSettings = [{struct('none', no_wiggle)}, ...
                                 num2cell( struct('orientation', num2cell(ori_wiggles))    ), ...
                                 num2cell( struct('offset',      num2cell(offset_wiggles)) ), ...
                                 num2cell( struct('phase',       num2cell(phase_wiggles))  ) ];
            
            allFontNames  = cellfun(@(w) struct('fonts', {'Snakes'}, 'wiggles', w), allWiggleSettings);
            allFontNames = num2cell(allFontNames);
            
%             allFontNames = {'Snakes'};
%             allFontNames = {'SloanO2'};

            
         end
         
         
         if doTextureStatistics
            
            allNScales = {3};
%             allNScales = {4, 3};
            allNOrientations = {4}; %3,4};
            allNa = {7}; %5};
            %         allNa_sub = {0,1,3,5,7,9};
            
            %         allStatsUse = {'V1', 'V1x', 'V2', 'V2r'};
            allTextureStatsUse = {'V2'};

            
            %%
            allTextureOpts = (struct('tbl_Nscl_txt', {allNScales}, ...
                                    'tbl_Nori_txt', {allNOrientations}, ...
                                    'tbl_Na_txt',   {allNa}, ...
                                    'tbl_statsUse', {allTextureStatsUse} ) );
            allTextureSettings = num2cell(  expandOptionsToList (allTextureOpts)  );
            allTextureSettings = [allTextureSettings, {[]}];
            
            %%
        else
            allTextureSettings = { [] };
            
        end

%         all_nLettersEachImage = {1};
        
        
        if strcmp(expName, 'TestConvNet')
            
            oriXYSet_8x8y21o = struct('oris', [-20:2:20], 'xs', [0:2:14], 'ys', [0:2:14]);
            
            allUncertaintySets = { oriXYSet_8x8y21o, oriXYSet_1pos };
            allSizeStyle_imageSizes = { {'k14', [40, 40]} };
        end
        
        
%         all_targetPosition = {1};
               %%
       allSetOptions = struct(...
                           'tbl_fontName', {allFontNames}, ...
                           ...
                           ...
                           'autoImageSize', 0, ...
                           ...'tbl_imageSize', {allImageSizes}, ...
                           ...'tbl_sizeStyle', {allSizeStyles}, ...
                           'tbl_sizeStyle_and_imageSize', {allSizeStyle_imageSizes}, ...
                           ...
                           'tbl_OriXY', { allUncertaintySets }, ...
                           ...'tbl_OriXY', { {oriXYSet_long_32_128_dx10} }, ...
                           ...'tbl_OriXY', {num2cell(oriXYSet_nLet_spc)}, ...
                           ...'tbl_OriXY',  { { oriXYSet_long_32_128_dx5, oriXYSet_long_32_128_dx5_ori, oriXYSet_long_32_128_dx10, oriXYSet_long_32_128_dx10_ori } }, .... oriXYSet_large_48_k14,... oriXYSet_long, ... oriXYSet_large, ... oriXYSet_large, ...oriXYSet_large1, ... oriXYSet_test1, ...oriXYSet_large1, ...
                           'tbl_blurStd', {allBlurStd}, ...
                           'tbl_noiseFilter', {NoiseFilters}, ...
                           'tbl_textureSettings', { allTextureSettings}, ...
                           ...
                           ...'tbl_nLettersEachImage', {all_nLettersEachImage}, ...
                           ...'tbl_targetPosition', {all_targetPosition}, ...;
                           ...'tbl_wiggleSettings', {allWiggleSettings} ...
                           ...'tbl_xrange', {allXranges}, ...
                           'tbl_crowdingSettings', { allCrowdingSettings } ...
                        );
                    
                        
                    
%                             allSetsToDo = expandOptionsToList( struct( 'tbl_fontName', {allFontNames}, ... 
%                                                    'tbl_sizeStyle', {allSizeStyles}, ...
%                                                    'tbl_imageSize', {allImageSizes}, ...
%                                                    'tbl_xrange', {allXranges}, ...
%                                                    'tbl_trainPosition', {allTrainPositions}, ...
%                                                    'tbl_testPosition', {allTestPositions}, ...
%                                                    'allNDistractors', allNDistractors, ...    
%                                                    'allLogDNRs', all_logDNRs, ...
%                                                    'tbl_blurStd', {allBlurStds}, ...
%                                                    'tbl_noiseFilter', {NoiseFilters}, ...
%                                                    'tbl_textureSettings', {allTextureSettings} ...
% 
                    
                    
                    
            
        totalSize_MB = 0;
        setSize = 10000;
        nSNRs = 12;
        allSetsToDo = expandOptionsToList( allSetOptions, loopKeysOrder );
        for i = 1:length(allSetsToDo)
            totalSize_MB = totalSize_MB + (nSNRs*prod(allSetsToDo(i).imageSize)*setSize)/(1024^2);    
        end
        
        
        displayOptions(allSetOptions);
%%
        fprintf('Uncertainty Sets : \n');
        for i = 1:length(allUncertaintySets)
            fprintf(' (%d)  %s\n', i, getOriXYStr(allUncertaintySets{i}));
        end
  %%      
        fprintf('\n=== Total Size for all %d sets (assuming 13 SNR levels, and 10,000 samples in each file) : %.1f MB (%.2f GB) ===\n', length(allSetsToDo), totalSize_MB, totalSize_MB/1024);
        if onLaptop
            keyboard
        end
        3;
        

%                          {[0], [-3, 3], [0]};
%                          {[0], [-3, 0, 3], [0]};
%                          {[0], [-3, 0, 3], [-3, 0, 3]};
%                          {[0], [-3, -1, 1, 3], [-3, -1, 1, 3]};
%                          {[0], [-3:3], [-3:3]} };

  %%

%         oriXYSet = oriXYSet_PCA;
%         oriXYSet = oriXYSet_one;
        idxs_setsToDo = 1:length(allSetsToDo);
        
%         idxs_setsToDo = fliplr(idxs_setsToDo);

        
        for set_i = idxs_setsToDo
            S = allSetsToDo(set_i);
            OriXY = S.OriXY;
            if iscell(OriXY)
                [oris_i, xs_i, ys_i] = OriXY{:};
            elseif isstruct(OriXY)
                oris_i = OriXY.oris;
                xs_i = OriXY.xs;
                ys_i = OriXY.ys;
            end
                               
            blur_str = iff(S.blurStd == 0, 'No Blur', sprintf('Blur = %.1f', S.blurStd));
            Cr = S.crowdingSettings;
            crowding_str = '';
            if ~isempty(Cr) 
                crowding_str = sprintf('%s letter(s), train pos = %s; test pos = %s', num2str(Cr.allNDistractors), num2str(Cr.trainPositions), num2str(Cr.testPositions) ); 
            end
            fprintf('\n\n======== %s === Set %d / %d === %s, %s  %s ===== %s ========= \n', expName, set_i, length(allSetsToDo), abbrevFontStyleNames( S.fontName), getFontSizeStr( S.sizeStyle ), blur_str, crowding_str);
            createNoisyLettersDatafile(S.fontName, S.sizeStyle, oris_i, xs_i, ys_i, S.imageSize, S.blurStd, S.noiseFilter, S.textureSettings,  S.crowdingSettings, [set_i, length(allSetsToDo)]);
        
            3;
        end
        
        if doCalculateIdealPerformance_atEnd
%             getIdealPerformance     c

            for set_i = idxs_setsToDo

                letterOpt = allSetsToDo(set_i);
                OriXY = letterOpt.OriXY;
                if iscell(OriXY)
                    [letterOpt.oris, letterOpt.xs, letterOpt.ys] = OriXY{:};
                elseif isstruct(OriXY)
                    [letterOpt.oris, letterOpt.xs, letterOpt.ys] = deal(OriXY.oris, OriXY.xs, OriXY.ys);
                end

                for si = 1:length(all_SNRs)
                    fprintf('[SNR = %.1f] ', all_SNRs(si));
                    testIdealObserver(letterOpt.fontName, all_SNRs(si), letterOpt);
                end

                %                 calculateIdealPerformance(S.fontName, S.sizeStyle, oris_i, xs_i, ys_i, S.imageSize, S.blurStd, S.noiseFilter, S.nLettersEachImage, S.targetPosition, set_i);
            end

        end
        
        return;
    end
    
    tryGetLocks = ~onLaptop; % strcmp(host, 'XPS'); % && (doTextureStatistics_now || doOverFeat || true);
                     
    if isempty(crowdingSettings)
          crowdingSettings = struct('xrange', [],  'trainPositions', 'all', 'testPositions', 'all', ...
                                    'allNDistractors', [0], 'allLogDNRs', [0], 'absHorizPosition', false);
    end
    
    trainPositions = crowdingSettings.trainPositions;
    testPositions = crowdingSettings.testPositions;
    allNDistractors = crowdingSettings.allNDistractors;
    allLogDNRs = crowdingSettings.allLogDNRs;
    absHorizPosition = crowdingSettings.absHorizPosition;
    xrange = crowdingSettings.xrange;
        
    if ~isempty(xrange)
        xs = xrange(1) : xrange(2): xrange(3);
    end


                                      
    if strcmp(fontSizeStyle, 'dflt')
        marginPixels = 1;
    else
        marginPixels = 5;
    end


    

    if strcmp(expName, 'ChannelTuning')
        3;
        if noiseFilter.applyFourierMaskGainFactor || strcmp(noiseFilter.filterType, 'white')
            all_SNRs = all_SNRs_norm;
        else
            all_SNRs = all_SNRs_noNorm;
        end
        
    end

    
    nSNRs = length(all_SNRs);

    if viewSampleLettersOnLaptop
%         all_SNRs = [3];
    end
    
    isSnakesFont = isstruct(fontName) && strcmp(fontName.fonts, 'Snakes');
        
    if isSnakesFont
        fontNameStr = ['Snakes' getSnakeWiggleStr(fontName.wiggles)];
    else
        fontNameStr = fontName;
    end
    
%     isSnakesFont = strncmp(fontNameStr, 'Snakes', 6);
%     if ~isempty(strfind(fontNameFull, 'Snakes'))
%         fontName = 'Snakes';        
%     end
    

    font_loc_idx = find(strcmp(fontNameStr, allFontNames),1);
%     nLettersUse = 10;
    
    sizeSpec = 'minSize'; % use the first font size at least as large as specified.
    [fontSize, fontXheight, fontKheight] = getFontSize(fontNameStr, fontSizeStyle, sizeSpec);  %#ok<NASGU>
    [allLetters, fontData] = loadLetters(fontName, fontSizeStyle, sizeSpec);
    
    
    if any(strcmp (noiseFilter.filterType, {'band', 'lo', 'hi'}))
        noiseFilter.cycPerLet_range = getCycPerLet_range(noiseFilter);
        noiseFilter.cycPerPix_range = noiseFilter.cycPerLet_range / fontXheight;
    end
%     noiseFilter.applyFourierMaskGainFactor = applyFourierMaskGainFactor;
    
%     [~, noiseFilter_str] = filterStr(noiseFilter);
    
%     connectToNYU crunchy3 matlab createNoisyLettersDatafile
%     fprintf('Noise filter : %s', noiseFilter_str)
    
    
    autoImageSize = ~exist('imageSize', 'var') || strcmp(imageSize, 'auto');
    
    xs_orig = xs;
    ys_orig = ys;
    
    variableNx = length(xs) == 1 && xs(1) < 0;
    variableNy = length(ys) == 1 && ys(1) < 0;

    idx_ori = find ( fontData.orientations >= max(abs(orientations)), 1, 'first' );
    fontBoundingBox = fontData.size_rotated(idx_ori, :)';
    
    if isSnakesFont
        margin_pixels = 0;
    else
        margin_pixels = 2;
    end
    
    if variableNx
        assert(~autoImageSize);
        dx = abs(xs);
    
        x_space_avail = imageSize(2) - fontBoundingBox(2) - margin_pixels * 2;  % need margin on left and right
        if x_space_avail < 0
            error('Not enough horizontal space for font');
        end
        xs = [0 : dx : x_space_avail];
        
    else
        xs = round( xs-xs(1) );
    end
    if variableNy
        assert(~autoImageSize);
        dy = abs(ys);
        
        y_space_avail = imageSize(1) - fontBoundingBox(1) - margin_pixels * 2;
        if y_space_avail < 0
            error('Not enough vertical space for font');
        end

        ys = [0 : dy : y_space_avail];
    else
        ys = round( ys-ys(1) );
    end

    
    
    Dx = xs(end)-xs(1);
    Dy = ys(end)-ys(1);
    nOris = length(orientations);
    nX = length(xs);
    nY = length(ys);
    
    
    fontWidth = fontData.size(2);
    halfLetterWidth = ceil(fontWidth / 2);
    
    if absHorizPosition && ~allowLettersToFallOffImage
        assert(xs(1)   > halfLetterWidth );
        assert(xs(end) <  ceil(fontWidth / 2) );
    end    

    
    
    
    
    marginPixels = 2;
    if autoImageSize
        [imageHeight, imageWidth] = getBestImageSize(orientations, xs, ys, allFontNames, fontSizeStyle, marginPixels);
    else
        [imageHeight, imageWidth] = deal(imageSize(1), imageSize(2));        
    end

    
        
%     fprintf(' - Calculating Noisy letter Sets for %s, size %d\n', fontName, fontSize);
%     fprintf(' - Using %d Orientations [%d:%d], %d X positions [%d:%d], and %d Y positions [%d:%d]\n', nOris, lims(orientations,0), nX, lims(xs,0), nY, lims(ys,0));
    
    textureFields = {};
    doTextureStatistics_now = ~isempty(textureSettings);
    
    if doTextureStatistics_now
        [Nscl_txt, Nori_txt, Na_txt, textureStatsUse] = deal(...
            textureSettings.Nscl_txt, textureSettings.Nori_txt, textureSettings.Na_txt, textureSettings.statsUse);
        
         maxNScales_w = floor(log2(imageWidth)) - 2;
         maxNScales_h = floor(log2(imageHeight)) - 2;
         maxNScales = min(maxNScales_w, maxNScales_h);
         
         if (Nscl_txt > maxNScales)
             fprintf('Number of scales (%d) is too large for this image size [%dx%d] (max = %d)\n', Nscl_txt, imageHeight, imageWidth, maxNScales)
             return;
         end
         
         assert(Nscl_txt <= maxNScales_h && Nscl_txt <= maxNScales_w)

         textureFields = {'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt, 'textureStatsUse', textureStatsUse};

%          fprintf(' - Using texture statistics: N = %d. K = %d. M = %d. (stats = %s)\n', Nscl_txt, Nori_txt, Na_txt, textureStatsUse);
%         textureStatsParams_subA = textureStatsParams_allA;
%         textureStatsParams_subA.Na_sub_txt = Na_sub;
        
    end
    
    
    

%     fprintf(' - Using an image size %d x %d\n', imageHeight, imageWidth);
  
    if doTextureStatistics_now
        stimType = 'NoisyLettersTextureStats';
    elseif doOverFeat
        stimType = 'NoisyLettersOverFeat';
    else
        stimType = 'NoisyLetters';
    end

    
    dataSets_subfolder = stimType;    
    if strcmp(expName, 'Crowding')
        datasets_subpath = ['Crowding' filesep];
    else
        datasets_subpath = '';
    end
    
    
    noisyLettersPath = [datasetsPath datasets_subpath  dataSets_subfolder filesep]; % 'sz32x32' filesep];
    noisyLettersPath_thisFont = [noisyLettersPath fontNameStr filesep];
    if ~exist(noisyLettersPath_thisFont, 'dir')
        mkdir(noisyLettersPath_thisFont)
    end
    
    

    % % %     defaultFontSize.Georgia = 10;   % 17 x 21. C0 = 42. C2 = 86
    
    
%     useTorchTensorSizes = 1;
    
%     overflowCheck = 0;
  
    noiseType = 'gaussian';
    nNoiseSamples = 1e5;

    if onLaptop
        setSize = 1000;
%         setSize = 200;
        if doOverFeat 
            setSize = 250;
        elseif doTextureStatistics_now
            setSize = 500;
        end
    else
%     setSize = 10000; % normally 10,000.
%         setSize = 10000; % normally 10,000.
        setSize = 10000; % normally 10,000.
        if doOverFeat
            setSize = 1000;
        elseif doTextureStatistics_now 
            
            if strcmp(textureSettings.statsUse, 'V1') && strncmp(textureStatsUse, 'V1', 2)
                setSize = 2000;
            end
            setSize = 2000;
    
        end
            
            
    end
    
    crowdingTrainSetFrac = 0.9;
    
    if strcmp(expName, 'ChannelTuning')
        ns_filter_seed = any(strcmpi(noiseFilter.filterType, {'white', '1/f'}))+1; % have different seed for (1) white/pink noise [train] (2) band/hi/lo pass noise [test]
    else
        ns_filter_seed = noiseFilter;
    end
    
    if strcmp(expName, 'Grouping')
        fontName_seed = strcmp(fontNameStr, 'SnakesN')+1; % have different seed for (1) no wiggle and (2) any other kind of wiggle
        ns_filter_seed = any(strcmpi(noiseFilter.filterType, {'white'}))+1; % have different seed for (1) white noise [test] (2) pink any other kind of noise [train]
    else
        fontName_seed = fontNameStr;
    end
    
    rand_seed = hashvariable({fontName_seed, fontSizeStyle, (nOris+1), (Dx+1),  (Dy+1), imageSize, blurStd, ns_filter_seed, crowdingSettings} );
    
%     fprintf('[Seed=%.1f]', rand_seed);
    

    
    signalContrast=1;
    background = 0;

    all_SNRs_done_im  = false(size(all_SNRs));
    all_SNRs_done_pca = false(size(all_SNRs));
    
    logEstimatedEOverNIdealThreshold=-2.6- -3.60; % We could use a fancier formula from my 2006 paper that takes rho into account. But this is fine for typical fonts.
    OriXY = struct('oris', orientations, 'xs', xs_orig, 'ys', ys_orig);
    
    nPositions = length(orientations) * length(xs_orig) * length( ys_orig );
%     logEOverNs = all_SNRs;
   %%
   crowdingSettings.nDistractors = 0;
    noisy_letter_opts_image = struct('expName', expName, 'stimType', stimType, 'sizeStyle', fontSizeStyle, 'OriXY', OriXY, 'tf_pca', 0, ... 'nLetters', 1, ...
        'autoImageSize', autoImageSize, 'imageSize', [imageHeight imageWidth], 'blurStd', blurStd, ...
        'noiseFilter', noiseFilter, 'crowdingSettings', crowdingSettings, 'doOverFeat', doOverFeat, 'overFeatImageFile', doOverFeat, ...
        'doTextureStatistics', doTextureStatistics_now, textureFields{:}); 
    %%
    
%      crowdedLetterOpts_1let = struct('expName', 'Crowding',   'stimType', stimType, 'sizeStyle', sizeStyle, 'imageSize', imageSize, ...
%         'nLetters', 1, 'trainTargetPosition', trainTargetPosition,  'testTargetPosition', testTargetPosition, 'blurStd', blurStd, 'noiseFilter', noiseFilter, ...
%         'doTextureStatistics', doTextureStatistics, 'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt, 'textureStatsUse', textureStatsUse, ...
%         'doOverFeat', doOverFeat); % , 'distSpacing', distractorSpacing
%     fprintf('\n=========== font = %s. Size = %s.  Opts = %s. =================\n', fontName, sizeStyle, getCrowdedLetterOptsStr(crowdedLetterOpts_1let));
    
%     [~, crowdedLettersPath] = getFileName(fontName, 0, crowdedLetterOpts_1let);
    
    
    
    noisy_letter_opts_pca = noisy_letter_opts_image;
    noisy_letter_opts_pca.tf_pca = 1;
        
%     opt_str = getNoisyLetterOptsStr(noisy_letter_opts_image);
    file_name_base_str = getFileName(fontNameStr, nan, noisy_letter_opts_image);
    fprintf(' - FileName (base) : %s,  SNRs = %s \n', file_name_base_str, toOrderedList(all_SNRs, [], ', ', inf));        
    %%
    
    if ~redoFilesIfExist && ~showLetters
        for i = 1:nSNRs
            fn_i_im  = [noisyLettersPath_thisFont getFileName(fontNameStr, all_SNRs(i), noisy_letter_opts_image) ];
            imageFileExists = exist(fn_i_im, 'file') && ~fileOlderThan(fn_i_im, redoFilesIfOlderThan);
            fn_i_pca = [noisyLettersPath_thisFont getFileName(fontNameStr, all_SNRs(i), noisy_letter_opts_pca) ];
            pcaFileExists = exist(fn_i_pca, 'file') && ~fileOlderThan(fn_i_pca, redoFilesIfOlderThan);


            if ~checkContentsOfFile
                all_SNRs_done_im(i) = (imageFileExists || ~createImageFiles);
                all_SNRs_done_pca(i) = (pcaFileExists || ~createPcaFiles);
            else
                if createImageFiles && imageFileExists
                    SS_im = load(fn_i_im);
                    same_params_im = isequal(SS_im.orientations, orientations) && isequal(SS_im.xs, xs) && isequal(SS_im.ys, ys) && ...
                        isequal(SS_im.imageSize, [imageHeight, imageWidth]);
                    all_SNRs_done_im(i) = same_params_im;
                end

                if createImageFiles && imageFileExists
                    SS_pca = load(fn_i_im);
                    same_params_pca = isequal(SS_pca.orientations, orientations) && isequal(SS_pca.xs, xs) && isequal(SS_pca.ys, ys) && ...
                        isequal(SS_pca.imageSize, [imageHeight, imageWidth]);
                    all_SNRs_done_pca(i) = same_params_pca;                    
                end

            end
            
        end
        
    end
        
    
    all_SNRs_toDo_im  = ~all_SNRs_done_im;
    all_SNRs_toDo_pca = ~all_SNRs_done_pca;

    all_SNRs_toDo = all_SNRs_toDo_im | all_SNRs_toDo_pca;
    
    
    
    if ~any(all_SNRs_toDo)
        fprintf('[Already Completed (in %s)]\n', noisyLettersPath_thisFont);
        if ~strcmp(expName, 'Crowding')
            return;
        end
    else
        fprintf('   => SNRs still to do: %s\n', toOrderedList( all_SNRs( all_SNRs_toDo), [], ', ', 100 ) );
                
        if tryGetLocks
            
            gotLock = false;
            for snr_i = find( all_SNRs_toDo )
                logSNR = all_SNRs(snr_i);
                if nPositions > 1000
                    logSNR = 0; % lock all of them 
                end
                filename_image_base = getFileName(fontNameStr, logSNR, noisy_letter_opts_image);        
                lock_name = ['create_' filename_image_base];

                [gotLock, otherPID] = lock_createLock(lock_name);

                if gotLock 
                    fprintf('We got a lock!!\n');
                    break;
                end

            end
            
            if ~gotLock 
                fprintf('All files to be created have been locked by other processes....\n')
                return;
            end
            
        end        
        
    end
        
    
%     tryGetLocks = true;

    

    
%     complexity_bool_mean = fontData.complexity_0;  
%     complexity_bool_all  = fontData.complexity_0_all; 
%     complexity_grey_mean = fontData.complexity_2;  
%     complexity_grey_all  = fontData.complexity_2_all;
        
    if ~autoImageSize  
        if size(allLetters,1) > imageHeight  ||  size(allLetters,2) > imageWidth
        
            fprintf('Letters (%d x %d) are too big for image (%d x %d)', size(allLetters,1), size(allLetters,2), imageHeight, imageWidth);

            switch actionIfImageToSmall
                case 'error', 
                    error('Image too small for this font');
                case 'abort',        
                    return;
                case 'crop',
                    
            end
            
        end
    end
    
    nLetters = size(allLetters, 3);
    

    allLetters_rotated = cell(1,nOris);
    for ori_i = 1:nOris
        margin = 0;
        let_rotated = rotateLetters(allLetters, orientations(ori_i));
        [idxT, idxB, idxL, idxR] = findLetterBounds(let_rotated, margin);
        allLetters_rotated{ori_i} = let_rotated(idxT:idxB, idxL:idxR, :);
    end
     
%%
    pixPerDeg = 1;
    
    letter_params = struct('pixPerDeg', pixPerDeg, 'imageHeight', imageHeight, 'imageWidth', imageWidth, ...
        'horizPosition', 'centered', 'vertPosition', 'centered', 'allowLettersToFallOffImage', allowLettersToFallOffImage);
    signal = generateLetterSignals(allLetters_rotated, xs, ys, orientations, letter_params);
    
    if doTextureStatistics_now
%         [signal, idx_textureStats_use] = addTextureStatisticsToSignal(signal, Nscl_txt, Nori_txt, Na_txt, textureStatsUse);
        [~, idx_textureStats_use] = addTextureStatisticsToSignal(signal(1), Nscl_txt, Nori_txt, Na_txt, textureStatsUse);
    end
    
     
    
    %%
    
    %%
    3;
    if 0
        %%
        allSignalImages= cat(3, signal.image);
        4;
        figure(11); clf;
%     	subplotGap(1,1,1,1); imagesc(tileImages(allSignalImages, 7, 4, 1, 0.5)); colormap('gray'); axis equal tight; ticksOff; 
        subplotGap(1,1,1,1); 
        colormap('gray');
        for i = 1:100
            imagesc( mean( (allSignalImages(:,:,randi(size(allSignalImages,3)  ))), 3) ); colormap('gray'); axis equal tight; 
            drawnow;
            pause(.1);
            
        end
%         imageToScale
        3;
    end
    3;
    
    
     logE1=log10([signal(:).E1]);
%     fprintf('signal log E1 : %.2f +- %.2f\n',mean(logE1),std(logE1));
%     fprintf('cross-correlation of signal(1,1) and signal(:,:)\n');
    [set_idx, nSets] = deal(set_idx(1), set_idx(2));
 
    if showLetters
%         if nOris > 1 || nX > 1 || nY > 1
            %%
%             signalImages = cat(3, signal(1:5,:,:,:).image);
%             signalImages_tiled = tileImages(signalImages);
%             figure(34); clf;
%             imagesc(signalImages_tiled); axis equal tight;
%             colormap('gray');
%             imageToScale;

            %%
            [set_idx, nSets] = deal(set_idx(1), set_idx(2));
            
            if length(signal(:)) <= 30
                %%
                figure(135 + set_idx);
                if set_idx == 1
                    clf;
                end
                
                signalImages = cat(3, signal(:).image);
                signalImages_tiled = tileImages(signalImages, 1);
                subplotGap(8,1,font_loc_idx, 1)
                imagesc(signalImages_tiled); axis equal tight;
                set(gca, 'xtick', [], 'ytick', []);
                colormap('gray');
%                 imageToScale;
                3;
                if set_idx == nSets
                    imageToScale
                    3;
                end
            end
            
            %%
            subM = floor(sqrt(nSets/2));
            subN = ceil(nSets/subM);
            figure(135);
            signalImages_all = cat(3, signal(:,:,:,:).image);
            subplot(subM,subN,set_idx);    imagesc( log1p( sum(signalImages_all, 3) ) ); axis square;
            title(sprintf('%s [%d]', fontNameStr, fontSize));
%             if font_loc_idx == 3
%                 xlabel(sprintf('Noxy = %d,%d,%d', nOris, nX, nY));
%             end
            colormap('gray');
%%
            figure(235);
            all_used = sum(signalImages_all, 3);
            subplot(subM,subN,set_idx);  imagesc(log10(all_used)); axis square;
            [idx_t, idx_b, idx_l, idx_r] = findLetterBounds(all_used);
            gap_t = idx_t-1;
            gap_b = imageHeight-idx_b;
            gap_l = idx_l-1;
            gap_r = imageWidth-idx_r;
            title(sprintf('%s [%d]', fontNameStr, fontSize));
            xlabel(sprintf('[%d, %d, %d, %d]', gap_t, gap_b, gap_l, gap_r), 'fontsize', 9)
            colormap('gray');
            
            %%
            3;
            
%         end
       
        return
    end
    
    [idxT, idxB, idxL, idxR] = findLetterBounds(cat(3, signal(:).image));
    signalBounds = [idxL, idxT, idxR, idxB];
    
    3;
    
    %%%%%%
                     %        fontName, fontSizeStyle,orientations, xs, ys,        imageSize, blurStd, noiseFilter, nLettersEachImage, targetPosition, set_idx
    if strcmp(expName, 'ChannelTuning')
        ns_filter_seed = any(strcmpi(noiseFilter.filterType, {'white', '1/f'}))+1; % have different seed for (1) white/pink noise [train] (2) band/hi/lo pass noise [test]
    else
        ns_filter_seed = noiseFilter;
    end
    
    if strcmp(expName, 'Grouping')
        fontName_seed = strcmp(fontNameStr, 'SnakesN')+1; % have different seed for (1) no wiggle and (2) any other kind of wiggle
        ns_filter_seed = any(strcmpi(noiseFilter.filterType, {'white'}))+1; % have different seed for (1) white noise [test] (2) pink any other kind of noise [train]
    else
        fontName_seed = fontNameStr;
    end
    
    rand_seed = hashvariable({fontName_seed, fontSizeStyle, (nOris+1), (Dx+1),  (Dy+1), imageSize, blurStd, ns_filter_seed, crowdingSettings} );
%     fprintf('%.1f', rand_seed);
    rand_seed = randi(10000);

    
    noiseSamples = generateNoiseSamples(nNoiseSamples, noiseType, rand_seed);
    noiseSamples.noiseSize=[imageHeight,imageWidth];
    
    
    
    if createPcaFiles
        %%
        allImageVecs_C = arrayfun(@(sig) sig.image(:), signal(:), 'un', 0);
        allImageVecs = [allImageVecs_C{:}]';
        meanImageVec = mean(allImageVecs,1);
       
        warning('off', 'stats:pca:ColRankDefX')
        fprintf('Doing PCA on original image set...'); tic;        
        switch pca_method
%             case 'PCA', [coeff, score, latent, ~,explained] = pca(allImageVecs); % 'NumComponents', nPCAcompsMax);
            case 'PCA', [coeff, score] = pca(allImageVecs); % 'NumComponents', nPCAcompsMax);
            case 'GLF',
        end
        fprintf(' done'); toc;
%        centdata = score*coeff';
%        allImageVecs_ms = bsxfun(@minus, allImageVecs, meanImageVec);
        
 
        showPCA = 0;
        if showPCA && showAnyFigures
            %%
            nUseful = nnz(explained > .1);
            coeff_stack = zeros(imageHeight, imageWidth, nUseful);
            for let_i = 1:nUseful
                coeff_stack(:,:,let_i) = reshape(coeff(:,let_i), imageHeight, imageWidth);
            end
            coeff_tiled = tileImages(coeff_stack);
            figure(101); clf;
            imagesc(coeff_tiled);
        end
        
        for sig_i = 1:length(signal(:))
            signal(sig_i).imageScore = score(sig_i,:)';
            % score_i = getPcaScore(signal(sig_i).image, meanImageVec, coeff);
            % assert(isequal(score_i, score(sig_i,:)'));
        end
        
    end
    
%     all_SNRs = [3];
    nRows = length(all_SNRs);
    
    curSetSizeFrac = 1;
    if strcmp(expName, 'Crowding')
        curSetSizeFrac = crowdingTrainSetFrac;
    end

    params.logE1 = logE1;
    params.signalContrast = signalContrast;
    params.logEstimatedEOverNIdealThreshold = logEstimatedEOverNIdealThreshold;
    params.background = background;
    params.pixPerDeg = pixPerDeg;
    params.setSize = round(setSize * curSetSizeFrac);
    params.noiseSamples = noiseSamples;
    
    params.orientations = orientations;
    params.xs = xs;
    params.ys = ys;
    params.fontSize = fontSize;
    params.fontName = fontNameStr;
    params.blurStd = blurStd;
%     params.bandNoise = bandNoise;
    params.noiseFilter = noiseFilter;
    params.targetPositions = trainPositions;
    params.nDistractors = 0;
    params.distractorSpacing = 1;
    params.logTDR = 0;
    params.applyFourierMaskGainFactor = noiseFilter.applyFourierMaskGainFactor;
    
    if doTextureStatistics_now
        params.textureStatsParams = textureSettings;
        params.idx_textureStats_use = idx_textureStats_use;
        params.doTextureStatistics = doTextureStatistics_now;
        params.textureStatsUse = textureStatsUse;
    end
    
    
    justShowLettersSum = 0  && showAnyFigures;
    if justShowLettersSum
        fig_id = 1000 + set_idx*100 + font_loc_idx;
        figure(fig_id);
        hh = subplotGap(7,9,1,1); 
        imagesc(log10(sum(allSignalImages,3)));
        ticksOff;
        axis image;
        3;
        return;
        3;
%         allLetterSi
        
        
    end
    
%     allSignalImages= cat(3, signal.image);
%     sizeOfSignalData_MB = numel(allSignalImages)*4/(1024^2);
    sizeOfSignalData_MB = numel(signal(1).image)*numel(signal) *4/(1024^2);
    if sizeOfSignalData_MB < 25
        signalData = concatSignalImages(signal, 'single');
    else
        signalData = struct('allLetters_rotated', {allLetters_rotated}, ...
                            'xs', xs, 'ys', ys', 'orientations', orientations, 'letter_params', letter_params);        
    end
        
        
    
%     computeMiniSets = ~isempty(CPU_id);
    firstTime = 1;

    for snr_i = find( all_SNRs_toDo )
        logSNR = all_SNRs(snr_i);
        
        fprintf('\n -------- Now computing set #%d / %d (SNR = %.1f) -------- \n', snr_i, nSNRs, logSNR);

        logSNR_lock = logSNR;
        if nPositions > 1000
            logSNR_lock = 0; % lock all of them 
        end

        filename_image_base = getFileName(fontNameStr, logSNR, noisy_letter_opts_image);        
        filename_image_base_lock = getFileName(fontNameStr, logSNR_lock, noisy_letter_opts_image);        
        filename_image = [noisyLettersPath_thisFont filename_image_base];
        
        
        stillNeedToDoFile =  ~exist(filename_image, 'file') || (fileOlderThan(filename_image, redoFilesIfOlderThan)) || redoFilesIfExist;
        if ~stillNeedToDoFile
            fprintf('[This file (%s) has already been created. No need to create it.]\n', filename_image_base);
            continue;
        end
         
        
        lock_name = ['create_' filename_image_base_lock];
        if tryGetLocks
            [gotLock, otherPID] = lock_createLock(lock_name);
        else
            gotLock = true;
        end

        if ~gotLock
            fprintf('[Another process (%s) already has a lock on %s]\n', otherPID, lock_name);
            continue
        end

        
        
        
        if ~all_SNRs_done_im(snr_i)  
            params.logSNR = logSNR;
%             noisySet = generateSetOfNoisyLetters(signal, params);
            noisySet = generateSetOfLetters(signal, params);
            3;
            
            
            
            
        else
            noisySet_loaded = load( filename_image );
            noisySet_loaded.signal = signal;
        end
        3; 
        assert( isequalToPrecision(logSNR, noisySet.logEOverN, 1e-5) );
             
        if createPcaFiles && all_SNRs_done_pca(snr_i)           
            noisySet = addPCAscoresToSet(noisySet, meanImageVec, coeff);

            show = 1 && showAnyFigures;
            if show
%%
                nLettersPlot = 12;
                 let_colrs = jet(nLettersPlot);
                figure(102); clf; hold on; box on;
                for let_i = 1:nLettersPlot 
                    for xi = 1:nX
                        idx_i = find([noisySet.labels] == let_i & [noisySet.targetX_idx] == xi);
                        plot(noisySet.stimulusScores(idx_i,1), noisySet.stimulusScores(idx_i,2), '.', 'color', let_colrs(let_i,:) ); 
                    end
                    
                end
                for let_i = 1:nLettersPlot
                    for xi = 1:nX
                        text(score(let_i,1), score(let_i,2), upper(char('a'-1+let_i)), 'color', 'black');
                        xy = signal(let_i).imageScore;
                        hhh(let_i) = text(xy(1), xy(2), upper(char('a'-1+let_i)), 'color', 'black', 'fontweight', 'bold', 'fontsize', 12);
                    end
                    plot_xs = zeros(1,nX);
                    plot_ys = zeros(1,nY);
                    if nX > 1
                        for xi = 1:nX
                            plot_xs(xi) = signal(let_i, 1, xi).imageScore(1);
                            plot_ys(xi) = signal(let_i, 1, xi).imageScore(2);
                        end
                    elseif nOris > 1
                        for ori_i = 1:nOris
                            plot_xs(ori_i) = signal(let_i, ori_i, 1).imageScore(1);
                            plot_ys(ori_i) = signal(let_i, ori_i, 1).imageScore(2);
                        end
                        
                    end
                    plot(plot_xs, plot_ys, 'k-')
                end
                    3;
            end
            
        end
%         drawnow;
        3;
        fprintf('Set %d. logSNR %5.2f, logEOverN (logSNR) %5.2f, signalContrast %.2f, noiseContrast %.3f\n', ...
            snr_i, logSNR, noisySet.logEOverN, noisySet.signalContrast,noisySet.noiseContrast);

        ideal_fields = {};
        ideal_combinedFields = {};
        ideal_multFields = {};
        if createImageFiles && all_SNRs_toDo_im(snr_i) && doCalculateIdealPerformance_withFile
            %%
            noisySet.trainPositions    = trainPositions; 
            noisySet.testPositions     = testPositions; 
            noisySet.nLettersEachImage = nLettersEachImage;
            [propLetterCorrect_ideal, propEachLetterCorrect_ideal, propOrientationCorrect_ideal, propXYCorrect_ideal] = ...
                calcIdealPerformanceForNoisySet(noisySet); %#ok<ASGLU,NASGU>
            
            ideal_fields = {'propLetterCorrect_ideal', propLetterCorrect_ideal, 'propEachLetterCorrect_ideal', propEachLetterCorrect_ideal};
            
            compareWithCombinedTemplates = 0;
            if compareWithCombinedTemplates && any([length(noisySet.xs), length(noisySet.ys), length(noisySet.orientations)] > 1 )
                [propLetterCorrect_ideal_combined, propEachLetterCorrect_ideal_combined, propOrientationCorrect_ideal_combined, ...
                    propXYCorrect_ideal_combined] = calcIdealPerformanceForNoisySet(noisySet, struct('combinedTemplates', true) );                %#ok<ASGLU,NASGU>
                
                ideal_combinedFields = {'propLetterCorrect_ideal_combined', propLetterCorrect_ideal_combined, ...
                                    'propEachLetterCorrect_ideal_combined', propEachLetterCorrect_ideal_combined};
            end
            
            doTemplateMultiply = 0;
            if doTemplateMultiply 
                [propLetterCorrect_ideal_mult, propEachLetterCorrect_ideal_mult, propOrientationCorrect_ideal_mult, ...
                    propXYCorrect_ideal_mult] = calcIdealPerformanceForNoisySet(noisySet, struct('calcMethod', 'innerProduct') );
                
                ideal_multFields = {'propLetterCorrect_ideal_mult', propLetterCorrect_ideal_mult, ...
                                'propEachLetterCorrect_ideal_mult', propEachLetterCorrect_ideal_mult};
            end
            
            
%             fprintf('On Full Image: correctLetter %.3f, correctOrientation %.3f, correctXY %.3f\n', ...
%                 noisySet.propLetterCorrect_ideal,noisySet.propOrientationCorrect_ideal,noisySet.propXYCorrect_ideal);
        end
%         allPCorrNoPool.(fontName)(snr_i) = propLetterCorrect_ideal;
        3;
        
        addIdealOfPooledImages = 0;
        if addIdealOfPooledImages
            poolSizes = [2,4,6,8];
        
            for p_i = 1:length(poolSizes)
                pCorr = calcIdealPerformanceForNoisySet(noisySet, struct('test', 'pooledImage', 'poolSize', poolSizes(p_i)));
                ss.(['propLetterCorrect_ideal_pool' num2str(poolSizes(p_i))]) = pCorr;
                allPCorrPool.(fontNameStr)(p_i,snr_i) = pCorr;
            end
        
        end
        
    
        

%         if createPcaFiles && all_SNRs_toDo_pca(snr_i)
%             [propLetterCorrect_ideal_PCA, propEachLetterCorrect_ideal_PCA, propOrientationCorrect_ideal_PCA, propXYCorrect_ideal_PCA] = ...
%                 calcIdealPerformanceForNoisySet(noisySet, struct('test', 'PCA')); %#ok<NASGU,ASGLU>
%         end

        %%
 %%
%         labels = [noisySet.labels];
        if doTextureStatistics_now
            inputMatrix = noisySet.textureStats;
        else
            inputMatrix = noisySet.inputMatrix;
        end

        
        if doOverFeat
%              maxAbsValue = max(abs(lims(inputMatrix) ));
%              maxRGBvalue = 255;
%              inputMatrix_rescaled = (inputMatrix) * (maxRGBvalue/2) / (maxAbsValue) + (maxRGBvalue /2);
%              lims2 = lims(inputMatrix_rescaled);
%              assert( all(ibetween(lims2, [0, 255])) );
        end
         3;

        

        setToSave = struct('fontName', fontNameStr, 'fontSize', fontSize, 'fontSizeStyle', fontSizeStyle, 'date', datestr(now), ...
            'inputMatrix', inputMatrix, 'labels', noisySet.labels, 'signalMatrix', [], ...
            'signalBounds', signalBounds, ...
            'orientations', orientations, 'xs', xs, 'ys', ys, 'imageSize', [imageHeight, imageWidth], 'nClasses', nLetters, ...
            ...'complexity_bool_mean', complexity_bool_mean, 'complexity_bool_all', complexity_bool_all, ...
            ...'complexity_grey_mean', complexity_grey_mean, 'complexity_grey_all', complexity_grey_all, ...
            'doOverFeat', doOverFeat, ...
            ideal_fields{:}, ideal_combinedFields{:}, ideal_multFields{:});  
    
        
        
        showSomeExamplesNow = 0 || (viewSampleLettersOnLaptop);
        if showSomeExamplesNow && showAnyFigures
            3;
            %% tmp
%             pctils = [10,25, 50, 75, 90];
%             allSame = isempty(noisySet.all_f_exp);
%             if allSame
%                 noisySet.all_f_exp = noiseFilter.f_exp*ones(1, length(noisySet.labels));
%             end
%             f_pctls = prctile(noisySet.all_f_exp, pctils);
%             nSamp = 2;
%             used_already = [];
%             for p = 1:length(pctils)
%                 [~, idx_srt] = sort(abs(noisySet.all_f_exp - f_pctls(p)), 'ascend');
%                 if allSame
%                     idx_srt = setdiff(idx_srt, used_already);
%                 end
%                 
%                 for j = 1:nSamp
%                     idx(:,p) = idx_srt(1:nSamp);
%                 end
%                 if allSame
%                     used_already = [used_already, idx_srt(1:nSamp)];
%                 end
% 
%             end
            %%
            figure(159+set_idx); clf; 
%             show_m = nSamp; show_n = length(pctils);  idx_inputs = idx';
            show_m = 7; show_n = 11;  idx_inputs = 1:show_m*show_n;
%             show_m = 1; show_n = 4;  idx_inputs = [1:show_m*show_n]+15;
%             strs = arrayfun(@(p, f_p) sprintf('p%d=%.1f', p, f_p), pctils, f_pctls, 'un', 0);
            
%             idx = getPctleIdx(
            imagesc( tileImages(inputMatrix(:,:,idx_inputs(:)), show_m, show_n, 4, 0.5) );
            
%             title(strjoin(strs, ';  '));
            title(file_name_base_str, 'interpreter', 'none');
            colormap('gray');
            imageToScale;
            ticksOff;
%             continue;
            3;
        end
        
        if createImageFiles && all_SNRs_toDo_im(snr_i) && saveSampleLettersOnLaptop
%             setToSave.inputMatrix = noisySet.inputMatrix;
%             setToSave.propLetterCorrect_ideal     = propLetterCorrect_ideal;        
%             setToSave.propEachLetterCorrect_ideal = propEachLetterCorrect_ideal;        
            
            setToSave.signalData = signalData; %concatSignalImages(signal, precision);
            setToSave.logEOverNReIdeal = noisySet.logEOverN - logEstimatedEOverNIdealThreshold;
            setToSave.logEOverN = noisySet.logEOverN;
            setToSave.logE = noisySet.logE;
            setToSave.logN = noisySet.logN;
            setToSave.logE1 = params.logE1;
            setToSave.signalContrast = noisySet.signalContrast; 
            setToSave.noiseContrast = noisySet.noiseContrast;
            setToSave.randSeed = rand_seed;
            
            if length(xs) > 1
                setToSave.x_idxs = noisySet.targetX_idx;
            end
            if length(ys) > 1
                setToSave.y_idxs = noisySet.targetY_idx;
            end
            if length(ys) > 1
                setToSave.ori_idxs = noisySet.targetOri_idx;
            end

%%
            
            sz = size(setToSave.inputMatrix);
            fprintf('   => Saving Noisy Image data to : %s (%d inputs of size %dx%d) ... ', filename_image_base, sz(3), sz(1), sz(2) )
            save(filename_image, '-struct', 'setToSave', '-v6');
            file_s = dir(filename_image);
            fprintf(' done (%.1f MB)\n ', file_s.bytes / (1024^2));
            
        end
                
        
        
        if createPcaFiles && all_SNRs_toDo_pca(snr_i)
 
            scoreSize = size(noisySet.stimulusScores,2);
            setToSave_PCA = setToSave;
            setToSave_PCA.nPcaScoresToTest = nPcaScoresToTest;
            setToSave_PCA.inputMatrix = reshape(noisySet.stimulusScores, [scoreSize, 1, setSize]);
            setToSave_PCA.signalMatrix = concatSignalImages(signal, precision, 1);
            setToSave_PCA.propLetterCorrect_ideal = noisySet.propLetterCorrect_ideal_PCA;            
            
            filename_PCA = getFileName(fontNameStr, noisySet.logEOverN, noisy_letter_opts_pca);
            fprintf('   => Saving Noisy PCA data to file %s \n', filename_PCA)
            save([noisyLettersPath_thisFont filename_PCA], '-struct', 'setToSave_PCA', '-v6');
        end
        
        
        
        if showSamplesWithNoise && createImageFiles && 0 %%&& all_SNRs_done_im(snr_i)
            %%
            % Show the stimulus, signal, and stimulus minus signal, which should be just noise. One for each noisySet. 
            if ~isempty(font_loc_idx)
                fig_id = set_idx(1)*100 + font_loc_idx;
            else
                if firstTime
                    fig_id = figure;
                end
            end
            
            if firstTime
                figure(fig_id);
                clf;
                firstTime = 0;
            end
            
%             sample_idx = find(noisySet.labels == double(lower(fontName(1)))-96, 1 ); % take the very first image in the set.
            sample_idx = 1;
            row_start=3*(snr_i-1);
            rows=nRows;
            snImage=noisySet.inputMatrix(:,:,sample_idx);
            
            tmp = 0;
            if tmp;
                %%
                imagesc(snImage); colormap(gray(256));
                imageToScale;
                ticksOff;

                
            end
            3;
            %%
            h_ax(snr_i,1) = subplot(rows,3,row_start+1,'align'); imagesc(snImage); xlabel(filename_image_base, 'interp', 'none'); axis equal tight; %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
            let_idx=noisySet.labels(sample_idx); % stimulus(1).whichSignal;
            ori_idx=noisySet.targetOri_idx(sample_idx);
            x_idx=noisySet.targetX_idx(sample_idx);
            y_idx=noisySet.targetY_idx(sample_idx);
            %%
            sImage=noisySet.signal(let_idx,x_idx,y_idx,ori_idx).image;
            
            h_ax(snr_i,2) = subplot(rows,3,row_start+2,'align'); imagesc(sImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
            nImage=snImage-sImage;
            h_ax(snr_i,3) = subplot(rows,3,row_start+3,'align'); imagesc(nImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
%             energy=sum(sum((sImage-1).^2));
%             noiseLevel=var(nImage(:));
            caxis auto
            set(h_ax(snr_i,:), 'xtick', [], 'ytick', []);
            colormap('gray')
            
            
            3;
%         fprintf('cond %d, log E/N nominal %.2f, actual %.2f\n',cond,set.logEOverN,log10(energy/noiseLevel));
        end

        all_sets(snr_i) = setToSave;
        
        
        showExampleNoise = 0;
        if showExampleNoise
            %%
%             fig_id_example = set_idx(1)*100 + font_loc_idx + 10000;
            fig_id_example = 10000; %set_idx(1)*100 + font_loc_idx + 10000;
            
            [signalContrast, noiseContrast, logE, logN] = getSignalNoiseContrast(logSNR, params);
            
            figure(fig_id_example); 
            if set_idx == 1 
                clf;
            end
            sample_idx = 1; % take the very first image in the set.
            snImage=noisySet.inputMatrix(:,:,sample_idx);
            %                 h_ax(snr_i,1) = subplot(rows,3,row_start+1,'align'); imagesc(snImage); xlabel(filename_image, 'interp', 'none'); axis equal tight; %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
            let_idx=noisySet.labels(sample_idx); % stimulus(1).whichSignal;
            ori_idx=noisySet.targetOri_idx(sample_idx);
            x_idx=noisySet.targetX_idx(sample_idx);
            y_idx=noisySet.targetY_idx(sample_idx);
            sImage=noisySet.signal(let_idx,x_idx,y_idx,ori_idx).image;
            nImage= (snImage-sImage) / noiseContrast;
            [~, filt_str] = filterStr( noiseFilter);
            %                 h_ax(snr_i,3) = subplot(rows,3,row_start+3,'align');
            subplotGap(2,nSets, 1, set_idx);
            if isfield(noisySet, 'fourierMask')
                imagesc(noisySet.fourierMask);
            else
                imagesc(ones(imageSize)); caxis([0 1]);
            end
            axis equal tight;
            ticksOff;
            title(filt_str, 'fontsize', 12);
            
            subplotGap(2,nSets, 2, set_idx);
            
            imagesc(nImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
            ticksOff;
            %             energy=sum(sum((sImage-1).^2));
            %             noiseLevel=var(nImage(:));
            caxis([-2.5, 2.5]);
            %                 set(h_ax(snr_i,:), 'xtick', [], 'ytick', []);
            colormap('gray');
%             imageToScale;
%             h = colorbar('EastOutside');
            refresh;
            pause(.1);
            %                 colorbar;
            %                 colorbar;
            3;
        end
%%

        if tryGetLocks
            lock_removeLock(lock_name);
        end

        
%         return
        firstTime = 0;
    end
    
      
     if showSamplesWithNoise && createImageFiles && any(all_SNRs_done_im)
         imageToScale
     end
  
     
     
    
    if strcmp(expName, 'Crowding')        
       
        params.setSize = round( setSize * (1-curSetSizeFrac) );
    %     testTargetPosition = 'all';
        params.targetPosition = testPositions;

        nDNRs = length(allLogDNRs);

        fprintf('======= Now computing all multiple-letter sets \n');

        nnDistractors = length(allNDistractors);

        crowdingSettings_i = noisy_letter_opts_image.crowdingSettings;

        for ndist_i = 1:nnDistractors
            nDistractors = allNDistractors(ndist_i);
            nLettersTest = nDistractors + 1;


            [allDistractSpacings_pix, allDistractSpacings] = getAllDistractorSpacings(xrange, fontWidth, nDistractors, testPositions);
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

                    crowdingSettings_i.logDNR = logDNR;
                    crowdingSettings_i.nDistractors = nDistractors;
                    crowdingSettings_i.testPositions = testPositions;
                    crowdingSettings_i.trainPositions = testPositions;  % so don't label file with 'TrainedWithX'
                    crowdingSettings_i.distractorSpacing = distractorSpacing_pix;

                    params.logDNR = logDNR;
                    params.nDistractors = nDistractors;
                    params.distractorSpacing = distractorSpacing;
                    
                    noisy_letter_opts_image.crowdingSettings = crowdingSettings_i;
                    
                    all_SNRs_toDo = false(size(all_SNRs));
                    if ~redoFilesIfExist 
                        for i = 1:nSNRs

                            fn_i_im  = [noisyLettersPath_thisFont getFileName(fontNameStr, all_SNRs(i), noisy_letter_opts_image) ];
                            imageFileExists = exist(fn_i_im, 'file') && ~fileOlderThan(fn_i_im, redoFilesIfOlderThan);
                                          
                            all_SNRs_toDo (i) = ~imageFileExists;                            
                        end

                    else
                        all_SNRs_toDo  = true(size(all_SNRs));
                    end
%                     all_SNRs_toDo  = true(size(all_SNRs));
                    
                    
                    
                    
                    
                    for snr_i = find( all_SNRs_toDo )
                        logSNR = all_SNRs(snr_i);
                        params.logSNR = logSNR;

                        
%                         testing_filename = getCrowdedLetterFileName(fontName, logSNR, noisy_letter_opts_image);
                        testing_filename = getFileName(fontNameStr, logSNR, noisy_letter_opts_image);
                        
                        fprintf('\n nDistract %d/%d.  DNR %d/%d.   Spacing %d/%d. SNR: %d/%d [ logSNR = %.2f] \n   === FileName = %s === : ', ...
                            ndist_i, nnDistractors,   dnr_i, nDNRs,  ds_i, nSpacings, snr_i, nSNRs, logSNR, testing_filename)

                        haveFileAlready = exist([noisyLettersPath_thisFont testing_filename], 'file') && ~redoFilesIfExist && ...
                            ~fileOlderThan([noisyLettersPath_thisFont testing_filename], redoFilesIfOlderThan);
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

                                crowdedSet.targetPosition = testPositions;
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
                                    save([noisyLettersPath_thisFont testing_filename], '-struct', 'S_test', '-v6')
                                end

%                                 all_S_test(ds_i) = S_test;

                                if tryGetLocks
                                    lock_removeLock(testing_filename);
                                end

                            end


                        else

                            fprintf('Already completed \n');
                        end

                        showTestingSet = 1 && ~haveFileAlready;
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
        clf;
%                             h_ax = subplotGap(nSNRs, nSpacings, find(logSNR == sort(all_SNRs)), ds_i);
    %                         [subM, subN] = deal(14,10);
                
                            h_ax = axes;
                            [subM, subN] = deal(1,1);
                            nTot = subM*subN;

                            idx_rand = randperm(length(crowdedSet.labels));
                            idx_use = idx_rand(1);

%                             imagesc(tileImages(crowdedSet.inputMatrix(:,:,idx_use), subM, subN, 3, 1));
                            imagesc(crowdedSet.inputMatrix(:,:,idx_use));
                            %         imagesc(tileImages(trainingSetSamples(:,:,1)))
                            axis equal tight;
                            colormap('gray');
    %                         set(gca, 'xtick', [], 'ytick', [], 'position', [0.01 0.01 .8 .8]);
                            ticksOff;
                            imageToScale([], 1)
%                             xlabel(sprintf('ds = %d, snr = %.1f', distractorSpacing, logSNR)); %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
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


        
    end
    
    

    
    fprintf('Done.\n');
    

        
    
end









function signalMatrix = concatSignalImages(signal, precision, useScoreFlag)
    useScore = nargin > 2 && isequal(useScoreFlag, 1);
    if ~useScore
        [height, width] = size(signal(1).image);
    else
        [height, width] = size(signal(1).imageScore);
    end
    if nargin < 2
        precision = class(signal);
    end

    [nLetters, nOris, nX, nY] = size(signal);
    signalMatrix = zeros(height, width, nLetters, nOris, nX, nY, precision);

    for let_i=1:size(signal,1)
        for ori_i=1:size(signal,2)
            for xi=1:size(signal,3)
                for yi=1:size(signal,4)
                    if ~useScore
                        signalMatrix(:,:,let_i,ori_i,xi,yi)=signal(let_i,ori_i,xi,yi).image;
                    else
                        signalMatrix(:,:,let_i,ori_i,xi,yi)=signal(let_i,ori_i,xi,yi).imageScore;
                    end
                end
            end
        end
    end

end


function noisySet = addPCAscoresToSet(noisySet, meanImageVec, coeff)
    [nH, nW] = size(noisySet.stimulus(1).image);
    setSize = length(noisySet.stimulus);
    allStimImages = reshape(cat(3, noisySet.stimulus(:).image), [nH*nW, setSize]);

    noisySet.stimulusScores = getPcaScore(allStimImages', meanImageVec, coeff);
    
%     for stim_i = 1:length(noisySet.stimulus(:))
%         noisySet.stimulus(stim_i).image = getPcaScore(noisySet.stimulus(stim_i).image, meanImageVec, coeff);
%     end

end

            

function score = getPcaScore(imageMtx, meanImageVec, coeff)
    if numel(imageMtx) == length(meanImageVec)
        centdata = imageMtx(:)' - meanImageVec;
    else % assume multiple rows
        centdata = bsxfun(@minus, imageMtx, meanImageVec);
    end
    score = centdata/coeff';

end



function [signal, idx_textureStats_use] = addTextureStatisticsToSignal(signal, Nscl, Nori, Na, textureStatsUse)

    idx_textureStats_use = [];
    for i = 1:numel(signal)
        %%
        image_i = double(signal(i).image);
        switch textureStatsUse
            case {'V2', 'V2r'}
                useAllStats = strcmp(textureStatsUse, 'V2');

                signal(i).textureStats_S = textureAnalysis(image_i, Nscl, Nori, Na, 0); 

                [textureStats_vec, idx_textureStats_use_i] = textureStruct2vec( signal(i).textureStats_S, [], useAllStats);

                if isempty(idx_textureStats_use)
                    idx_textureStats_use = idx_textureStats_use_i;
                else
                    assert(isequal(idx_textureStats_use_i, idx_textureStats_use_i));
                end

            case {'V1', 'V1s', 'V1c', 'V1x'}

                [V1s, V1c, V1hp, V1lp] = getSteerDecomp_V1(image_i, Nscl, Nori);
                switch textureStatsUse
                    case 'V1s', textureStats_vec = V1c;
                    case 'V1c', textureStats_vec = V1s;
                    case 'V1',  textureStats_vec = [V1s; V1c];
                    case 'V1x',  textureStats_vec = [V1s; V1c; V1hp; V1lp];
                end
        end
        signal(i).textureStats = single(textureStats_vec);

        if any(isnan(signal(i).textureStats))
            error('NaN!')
        end
    end
end
    
   
   
%{
        for s=noisySet.stimulus
            err = zeros(1, nSignals);
            for i=1:length(noisySet.signal(:))
                err(i)=sum(sum((s.image-noisySet.background-noisySet.signal(i).image).^2));
            end
            [~,i]=min(err);
            [i,ori_i,xi,yi]=ind2sub(size(noisySet.signal),i);
            if i==s.whichSignal
                correctLetter=correctLetter+1;
            end
            if ori_i==s.whichOrientation
                correctOrientation=correctOrientation+1;
            end
            if xi==s.whichX && yi==s.whichY
                correctXY=correctXY+1;
            end
            %            fprintf('signal(%d,%d,%d,%d) classified as %d,%d,%d,%d\n',s.whichSignal,s.whichOrientation,whichX,whichY,i,ori_i,xi,yi);
            trials=trials+1;
        end
%}


%{
switch fixedParameter 
        case 'imageSize', % reduce font size until it fits in the image
            
            w_max = imageWidth - Dx;
            h_max = imageHeight - Dy;
                        
            if nOris == 1
                relevant_w = fontSizeData.fontBoxW;
                relevant_h = fontSizeData.fontBoxH;
            elseif nOris > 1
                relevant_w = fontSizeData.fontBoxW_rot;
                relevant_h = fontSizeData.fontBoxH_rot;
            end
            idx_largest = find( relevant_w  <= w_max & relevant_h  <= h_max, 1, 'last');
            if isempty(idx_largest)
                error('No fonts are small enough for this image')
            end
            fontSize = fontSizeData.fontSizes(idx_largest);      
            fprintf('Selecting fontSize = %d (with box size %dx%d < %dx%d) for font %s\n', ...
                fontSize, relevant_h(idx_largest), relevant_w(idx_largest), h_max, w_max);
            
        case {'fontSize', 'manual'}, % choose image size to fit the selected font size
            cur_size_idx = find(fontSizeData.fontSizes == fontSize,1);
            if nOris == 1
                w_needed = fontSizeData.fontBoxW(cur_size_idx);
                h_needed = fontSizeData.fontBoxH(cur_size_idx);
            elseif nOris > 1
                w_needed = fontSizeData.fontBoxW_rot(cur_size_idx);
                h_needed = fontSizeData.fontBoxH_rot(cur_size_idx);
            end
            
            w_needed = w_needed + Dx;
            h_needed = h_needed + Dy;
            
            if strcmp(fixedParameter, 'fontsize')
                if requireSquareImage
                    [imageHeight, imageWidth] = deal(max(w_needed, h_needed));
                else
                    [imageHeight, imageWidth] = deal(h_needed, w_needed);
                end
                fprintf('Selecting imageSize = %dx%d (to accomodate box size (%dx%d) for font %s, size %d\n', ...
                    imageHeight, imageWidth, h_needed, w_needed, fontName, fontSize);
            elseif strcmp(fixedParameter, 'manual') 
                if (w_needed > imageWidth) || (h_needed > imageHeight) 
                    error('Font size %d (requiring box size %d x %d) is too large for image (%d x %d)', fontSize, h_needed, w_needed, imageHeight, imageWidth)
                else
                    fprintf(' [Using font size %d (requiring box size %d x %d) will fit in image (%d x %d)]\n', fontSize, h_needed, w_needed, imageHeight, imageWidth)
                end
            end

        otherwise
            error('Unknown option')

    end

%}


%{

%     multipleOris = nOris > 1;
%     multiplePositions = nX > 1  ||  nY > 1;
%     if ~multipleOris && ~multiplePositions
%         uncertainty = 'none';
%     elseif multipleOris && multiplePositions
%         uncertainty = 'spatial&rotational';
%     elseif multipleOris 
%         uncertainty = 'rotational';
%     elseif multiplePositions
%         uncertainty = 'spatial';
%     end

%     switch uncertainty
%         case 'none',
%             imageHeight_min = 36;
%             imageWidth_min  = 36;
%             
%         case 'spatial',
%             imageHeight_min = 46;
%             imageWidth_min  = 46;
% 
%         case 'rotational',
%             imageHeight_min = 40;
%             imageWidth_min  = 40;
%             
%         case 'spatial&rotational',
%             imageHeight_min = 51;
%             imageWidth_min  = 51;
%     end

%}

%{
        %%
        if useTorchTensorSizes  % ** are already in correct order for torch **
%             signal_permute_dims = 1:ndims(signalMatrix);
%             signal_permute_dims(1:2) = [2,1];  
%             signalMatrix = permute(signalMatrix,  signal_permute_dims);
%             inputMatrix = permute(inputMatrix, [2 1 3]);
%             inputMatrix = reshape(inputMatrix, [imageWidth, imageHeight, 1, setSize]);            
        end
%}


%{

                
        readme=sprintf([...
            'MATLAB save file "%s.mat" \n' ...
            'has %d target images at SNR log E/N %.2f,\n'...
            '%d possible letters, %s font, size %d, %d orientations, %d xs, %d ys\n'...
            'signalContrast %.3f, noiseContrast %.3f, background %.1f \n'...
            'The optimal classifier correctly identifies %.3f of these targets.\n'...
             'The file contains several arrays and a text string:\n\n' ...
            '"readme" contains this explanatory text.\n' ...
            '"signalMatrix" is a %dx%dx%dx%dx%dx%d matrix, the indices (x,y,i,io,xi,yi) represent\n'...
            '     horizontal, vertical, which letter, which orientation, which x offset, which y offset.\n' ...
            '"inputMatrix" is a %dx%dx%d matrix containing %d %dx%d images to be classified.\n' ...
            '     Each target image is a signal plus noise.\n' ...
            '"labels" contains the letter index (1 to %d) for each target. \n' ...
            '     This is the correct classification to be learned or tested.\n'...
            '"propLetterCorrect_ideal" is the performance %.3f of the ideal classifier on these targets.\n'...
            '"signalBounds" is a rect, a 4-element array [xmin,ymin,xmax,ymax]=[%d,%d,%d,%d], indicating\n' ...
            '     the zero-based min and max of the x and y coordinates of letter\n'...
            '     ink among all the signal images.\n' ...
            '"signal" is a %dx%dx%dx%d-element struct array, with one struct per letter and condition. The struct \n' ...
            '     includes the name ("string") and "image".\n' ...
            '\nNote that the optimal classifier''s threshold is roughly 1.0 log E/N, \n' ...
            'and the human threshold is roughly 2.0 log E/N.\n'...
            ],filename,length(noisySet.stimulus),noisySet.logEOverN,...
            length(signal),fontName,fontSize,length(noisySet.orientations),length(noisySet.xs),length(noisySet.ys),...
            noisySet.signalContrast,noisySet.noiseContrast,noisySet.background,noisySet.propLetterCorrect_ideal,...
            size(signalMatrix,1),size(signalMatrix,2),size(signalMatrix,3),size(signalMatrix,4),size(signalMatrix,5),size(signalMatrix,6),...
            size(inputMatrix),size(inputMatrix,3),size(inputMatrix,1),size(inputMatrix,2), ...
            size(signal,1),...
            propLetterCorrect_ideal,...
            signalBounds,...
            size(signal,1),size(signal,2),size(signal,3),size(signal,4));
%}


%{

nFonts = 6; allFonts =  {'Bookman', 'Courier', 'Kuenstler', 'Sloan', 'Helvetica'};

nBold= 2;
nItalics = 2;

24
nOrientations = -10:10; % 21
nXPositions = [-10:10];
nYPositions = [-10:10]:
nSizes = 5;
%}

% complexity: k16: allfonts make 28x35. + 4 for margin (2, 2): 32x39.
% Then, to fill up to 48 (mulitple of 16), have positions: 