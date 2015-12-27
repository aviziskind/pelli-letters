function runIdealObserverTests(expName)
    
    if nargin < 1
        expName = 'Grouping';
%         expName = 'Complexity';
    %     expName = 'Uncertainty';
%         expName = 'ChannelTuning';
    end    
    
    allExpNames = {'Complexity', 'Uncertainty', 'Grouping'};
    if strcmp(expName, 'all')
        expName = allExpNames;
    end
    
    if iscellstr(expName)
        for i = 1:length(expName)
            runIdealObserverTests(expName{i})
        end
        return;
    end
    
    fprintf(' ==== Running ideal observer tests for "%s" experiment... ==== \n', expName);
    
    
    lock_removeMyLocks;

%     fontName = 'BookmanU';
%     sizeStyle = 'k16';
%     sizeStyle = 'k38';
    autoImageSize = 0;
%     imageSize = [48 48];
%     imageSize = [32 80];
%     imageSize = [64 64];    
%     imageSize = [32 32];
    
    oriXYSet_large = struct('oris', [-10:2:10], 'xs', [0:5], 'ys', [0:11] );
    oriXYSet_med1 = struct('oris', [0], 'xs', [0:5], 'ys', [0:11] );
    oriXYSet_med2 = struct('oris', [-10:2:10], 'xs', [0], 'ys', [0] );
%     oriXYSet_test1 = struct('oris', [-2:2:2], 'xs', [-2,2], 'ys', [-2,2] );
    oriXYSet_1pos = struct('oris', 0, 'xs', 0, 'ys', 0 );
    oriXYSet_long = struct('oris', [-10:2:10], 'xs', [0:2:46], 'ys', [0:4] );
    oriXYSet_large_48_k14 = struct('oris', [-10:2:10], 'xs', [0:2:10], 'ys', [0:2:16]);
    
    oriXYSet_3x3y = struct('oris', 0, 'xs', [-1,0,1], 'ys', [-1,0,1]);
    oriXYSet_5x5y = struct('oris', 0, 'xs', [-2:2], 'ys', [-2:2]);
    oriXYSet_5x5y = struct('oris', 0, 'xs', [-2:2], 'ys', [-2:2]);
    oriXYSet_9x9y7o = struct('oris', [-15:5:15], 'xs', [0:3:24], 'ys', [0:3:24]);
    oriXYSet_10x10y11o = struct('oris', [-20:4:20], 'xs', [0:2:18], 'ys', [0:2:18]);
    oriXYSet_10x10y21o = struct('oris', [-20:2:20], 'xs', [0:2:18], 'ys', [0:2:18]);
    oriXYSet_5x5y11o = struct('oris', [-20:4:20], 'xs', [0:4:16], 'ys', [0:4:16]);
    oriXYSet_19x19y21o = struct('oris', [-20:2:20], 'xs', [0:1:18], 'ys', [0:1:18]);
    oriXYSet_30x30y21o = struct('oris', [-20:2:20], 'xs', [0:1:29], 'ys', [0:1:29]); % for 96x96

    oriXYSet_5x5y11o_d2 = struct('oris', [-10:2:10], 'xs', [0:2:8], 'ys', [0:2:8]);
    oriXYSet_41o  = struct('oris', [-20:1:20], 'xs', [0], 'ys', [0]);
    oriXYSet_7x7y = struct('oris', [0], 'xs', [0:2:12], 'ys', [0:2:12]);
    
    
    oriXYSet_6x9y21o = struct('oris', [-20:2:20], 'xs', [0:2:10], 'ys', [0:2:16] );
    oriXYSet_4x4y7o = struct('oris', [-15:5:15], 'xs', [0:3:9], 'ys', [0:3:9] );  % for complexity
    oriXYSet_6x6y11o = struct('oris', [-15:3:15], 'xs', [0:2:10], 'ys', [0:2:10] );  % for complexity

    oriXYSet_2x2y3o = struct('oris', [-5:5:5], 'xs', [0, 5], 'ys', [0, 5] );  % for complexity
    oriXYSet_3x6y7o = struct('oris', [-15:5:15], 'xs', [0, 4,8], 'ys', [0 : 4 : 20] );  % for complexity : 1

    
   
    oriXYSet_2x2y3o = struct('oris', [-5:5:5], 'xs', [0, 5], 'ys', [0, 5] );  % for complexity
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

    oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [0 : 1 : 4], 'ys', [0 : 1 : 12] );  % for complexity  5*13   = 65
    oriXYSet_7x18y_d1 = struct('oris', [0], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18    = 126
    oriXYSet_10x26y_d1 = struct('oris', [0], 'xs', [0 : 1 : 9], 'ys', [0 : 1 : 25] );  % for complexity 10*26  = 260
    oriXYSet_14x37y_d1 = struct('oris', [0], 'xs', [0 : 1 : 13], 'ys', [0 : 1 : 36] );  % for complexity 14*37  = 518
    oriXYSet_30x39y_d1 = struct('oris', [0], 'xs', [0 : 1 : 29], 'ys', [0 : 1 : 38] );  % for complexity 31*39 = 1209
                    
           oriXYSet_2x2y_d1 = struct('oris', [0], 'xs', [0 : 1 ], 'ys', [0 : 1 ] );  % for complexity 2*2 = 4
           oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for complexity 4*4 = 16
           oriXYSet_8x8y_d1 = struct('oris', [0], 'xs', [0 : 7 ], 'ys', [0 : 7 ] );  % for complexity 8*8 = 64
           oriXYSet_16x16y_d1 = struct('oris', [0], 'xs', [0 : 15 ], 'ys', [0 : 15 ] );  % for complexity 16*16 = 256
           oriXYSet_22x22y_d1 = struct('oris', [0], 'xs', [0 : 21 ], 'ys', [0 : 21 ] );  % for complexity 22*22 = 484


               oriXYSet_3x1y_d1 = struct('oris', [0], 'xs', [1 : 3], 'ys', [0] );  
               oriXYSet_5x1y_d1 = struct('oris', [0], 'xs', [1 : 5], 'ys', [0] );  
               oriXYSet_15x1y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [0] );  
               oriXYSet_30x1y_d1 = struct('oris', [0], 'xs', [1 : 30], 'ys', [0] );  
               oriXYSet_15x2y_d1 = struct('oris', [0], 'xs', [1 : 15], 'ys', [1:2] ); 
               oriXYSet_3x5y_d1 = struct('oris', [0], 'xs', [1:3], 'ys', [1:5] );  
               oriXYSet_5x3y_d1 = struct('oris', [0], 'xs', [1 : 5], 'ys', [1:3] );  
               oriXYSet_2x15y_d1 = struct('oris', [0], 'xs', [1 : 2], 'ys', [1:15] ); 
               oriXYSet_1x30y_d1 = struct('oris', [0], 'xs', [1], 'ys', [1:30] );  
    
        oriXYSet_7x18y_d1 = struct('oris', [0], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18    = 126
        oriXYSet_7x18y_d1_3o_d5 = struct('oris', [-5 : 5 : 5], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
        oriXYSet_7x18y_d1_7o_d5 = struct('oris', [-15 : 5 : 15], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
        oriXYSet_7x18y_d1_11o_d3 = struct('oris', [-15 : 3 : 15], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 17] );  % for complexity 7*18*3    = 126
        oriXYSet_7x17y_d1_11o_d4 = struct('oris', [-20 : 4 : 20], 'xs', [0 : 1 : 6], 'ys', [0 : 1 : 16] );  % for complexity 7*18*3    = 126


%     oriXYSet = [oriXYSet_test_no, oriXYSet_med1, oriXYSet_med2, oriXYSet_large];
%     oriXYSet = [oriXYSet_test_no, oriXYSet_med2];
%     oriXYSet = [oriXYSet_long];
%     oriXYSet = {oriXYSet_large_48_k14, oriXYSet_1pos};

%     allFontNames_std = {'Bookman', 'BookmanU', 'Sloan', 'Helvetica', 'Courier', 'KuenstlerU', 'Braille', 'Yung'};
    allFontNames_std = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};
    allFontNames_ext = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung', 'BookmanB', 'BookmanU', 'Hebraica', 'Devanagari', 'Armenian', 'Checkers4x4', 'Courier'};
    
    fontSet1 = {'BookmanU'};
    allStyles = {'Roman', 'Bold', 'Italic', 'BoldItalic'};
    fontSet2 = struct('fonts', {'BookmanU'}, 'styles', {allStyles});
    fontSet3 = struct('fonts', {{'BookmanU', 'Sloan', 'HelveticaU', 'CourierU'}}, 'styles', {allStyles});
    
%     allFontNames      = {'Bookman', 'BookmanU', 'Courier'};
%     allFontNames      = {'KuenstlerU'};
    fontSet_allFonts_allStyles_indiv      = expandFontsToTheseStyles(allFontNames_std, {'', 'B', 'I', 'BI'});
    fontSet5      = {'Bookman', 'BookmanU', 'Sloan', 'Helvetica', 'Courier', 'KuenstlerU', 'Braille', 'Yung'};
    
    fontSets_allFonts_multStyles = num2cell( expandOptionsToList(struct('tbl_fonts', {num2cell(allFontNames_std)}, ...
                                                              'styles', {allStyles}) ) );
    fontSets_allFonts_allStyles = struct('fonts', {allFontNames_std}, 'styles', {allStyles});

    
    applyFourierMaskGainFactor_pink = 1;
    applyFourierMaskGainFactor_hiLo = 0;
    applyFourierMaskGainFactor_band = 1;
    

%         allCycPerLet = [0.5, 0.71, 1, 1.41, 2, 2.83, 4, 5.66, 8, 11.31, 16];  
    allCycPerLet = [0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.45, 16]; % roundToNearest(2.^[-1:.25:4], 0.01)
        
    allBandNoiseFilters = arrayfun(@(f) struct('filterType', 'band', 'cycPerLet_centFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_band), allCycPerLet, 'un', 0);
    allHighPassNoiseFilters = arrayfun(@(f) struct('filterType', 'hi', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_hiLo), allCycPerLet, 'un', 0);
    allLowPassNoiseFilters = arrayfun(@(f) struct('filterType', 'lo', 'cycPerLet_cutOffFreq', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_hiLo), allCycPerLet, 'un', 0);
    
    allF_exps = [1, 1.5, 2];
    
    
    allPinkPlusWhiteNoiseFilters = arrayfun(@(f) struct('filterType', '1/fPwhite', 'f_exp', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allF_exps, 'un', 0);
    allPinkOrWhiteNoiseFilters = arrayfun(@(f) struct('filterType',   '1/fOwhite', 'f_exp', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allF_exps, 'un', 0);
    allPinkNoiseFilters = arrayfun(@(f) struct('filterType', '1/f', 'f_exp', f, 'applyFourierMaskGainFactor', applyFourierMaskGainFactor_pink), allF_exps, 'un', 0);
    whiteNoiseFilter = {struct('filterType', 'white')};

    
    tbl_trainingNoise = [allPinkNoiseFilters, whiteNoiseFilter];
    
%     fontNames_use = {fontSet1, fontSet2};
%     fontNames_use = {fontSet1, fontSet2, fontSet3};
    
    if onLaptop; %  strncmp(getHostname, 'XPS', 3)
%         fontNames_use = fontSet4;
%         fontNames_use = {fontSet1};
        redo = 0;
    else
%         fontNames_use = fontSet4;
%         fontNames_use = {fontSet1, fontSet2, fontSet3};
        redo = 0;
    end
    
%     redo = 0;
    redo = 0;
%     fontNames_use = num2cell(allFontNames_std);
%     fontNames_use = {allFontNames_std};
%     fontNames_use = {allFontNames_std, fontSets_allFonts_allStyles};
%     fontNames_use = {{'Bookman'}}; %num2cell(allFontNames_std);
%     fontNames_use = fontSets_allFonts_multStyles;

%%
    dWiggle = 15;
    doMult = 0 && 1;
    noWiggle = [1];
    if doMult
        oriWiggles    = [[0:10:60], num2cell(0:10:90)];
        offsetWiggles = [[0:10:60], num2cell(0:10:60)];
        phaseWiggles  = [num2cell([0, 1]), [0:1]];
    else
        oriWiggles = [dWiggle:dWiggle:90];
        offsetWiggles = [dWiggle:dWiggle:60];
        phaseWiggles = [1];
    end

    doNoWiggle = true;
    doOriWiggles = true;
    doOffsetWiggles = false;
    doPhaseWiggles = false;
        
    [allWiggleSettings_none, allWiggleSettings_ori, allWiggleSettings_offset, allWiggleSettings_phase] = deal({}); %#ok<NASGU,ASGLU>
    if doNoWiggle
        allWiggleSettings_none = {struct('none', num2cell(noWiggle))};
    end
    if doOriWiggles
        allWiggleSettings_ori = num2cell( struct('orientation', num2cell(oriWiggles) ) );
    end
    if doOffsetWiggles
        allWiggleSettings_offset = num2cell( struct('offset', num2cell(offsetWiggles)) );
    end
    if doPhaseWiggles
        allWiggleSettings_phase = num2cell( struct('phase', num2cell(phaseWiggles))  );
    end
    

%     allWiggleSettings_ori    = expandOptionsToList(struct('tbl_orientation', { oriWiggles }) );
%     allWiggleSettings_offset = expandOptionsToList(struct('tbl_offset',   { offsetWiggles }) );
%     allWiggleSettings_phase  = expandOptionsToList(struct('tbl_phase',   { phaseWiggles }) );
  
    allWiggleSettings_all = [allWiggleSettings_none, allWiggleSettings_ori, allWiggleSettings_offset, allWiggleSettings_phase];
%%    
    %%
   
    %%
    
%     allUncertaintySets = {oriXYSet_large_48_k14, oriXYSet_1pos};
    allUncertaintySets = {oriXYSet_1pos, oriXYSet_3x3y, oriXYSet_5x5y};
    allUncertaintySets = {oriXYSet_10x10y21o, oriXYSet_1pos };
    allUncertaintySets = {oriXYSet_10x10y21o, oriXYSet_19x19y21o};
    allUncertaintySets = {oriXYSet_30x30y21o};
    allUncertaintySets = {oriXYSet_6x9y21o, oriXYSet_1pos, oriXYSet_4x4y7o, oriXYSet_6x6y11o};
    allUncertaintySets = {oriXYSet_1pos, oriXYSet_10x10y21o, oriXYSet_5x5y11o};
    allUncertaintySets = {oriXYSet_5x5y11o_d2, oriXYSet_41o, oriXYSet_7x7y, oriXYSet_1pos, oriXYSet_10x10y21o, oriXYSet_5x5y11o};
    
    allUncertaintySets = {oriXYSet_2x2y3o, oriXYSet_3x6y7o, oriXYSet_1pos};
    

%     allUncertaintySets = {oriXYSet_1pos, oriXYSet_large_48_k14};
        
%     allSizeStyle_imageSizes = { {'k32', [64, 64]}, {'k16', [32 32]} };
%     allSizeStyle_imageSizes = { {'55', [64, 64]} };
%     allSizeStyle_imageSizes = { {'55', [96, 96]} };
%     allSizeStyle_imageSizes = { {'32', [64, 64]} };
%     allSizeStyle_imageSizes = { {'k32', [64, 64]}  };
%     allSizeStyle_imageSizes = { {'k48', [96, 96]} };
%     allSizeStyle_imageSizes = { {'k24', [64, 64]}  };
%     allSizeStyle_imageSizes = { {'k32', [40, 40]}  };

%     allClassifierForEachFont = {false, true};
    allClassifierForEachFont = {false};
    
    
%     tbl_noiseFilter = allBandNoiseFilters(allCycPerLet == 8);
%     tbl_noiseFilter = allBandNoiseFilters;
%     tbl_trainingNoise = [allPinkNoiseFilters, whiteNoiseFilter];
%     tbl_trainingNoise = [{'same'}, allPinkNoiseFilters, whiteNoiseFilter];
    tbl_trainingNoise = {'same'};
    
    tbl_noiseFilter = whiteNoiseFilter;

    %     allSNRs = [0, 1, 2, 3, 4];
%     allSNRs = [4];
%     allSNRs = [-1 : 0.5 : 5];
%     allSNRs = [-2];
%     allSNRs = [-1 : 0.5 : 5];
    allSNRs = [0 : 0.5 : 5];
   
    
    loopKeysOrder = {}; 
     switch expName
        case 'Complexity',
            fontNames_use = num2cell(allFontNames_std);

%             allSizeStyle_imageSizes = { {'k24', [64, 64]}  };
%             allSizeStyle_imageSizes = { {'k15', [32, 32]}  };
%             allSizeStyle_imageSizes = { {'k30', [80, 80]}  };
%             allSizeStyle_imageSizes = { {'k30', [64, 64]}  };
            
%             allUncertaintySets = {oriXYSet_1pos};

%             allSizeStyle_imageSizes = { {'k15', [56, 56]}, {'k15', [64, 64]}   };
%             allSizeStyle_imageSizes = { {'k15', [56, 56]}  };
%             allSizeStyle_imageSizes = { {'k15', [64, 64]}  };
            allSizeStyle_imageSizes = { {'k15', [64, 64]}, {'k24', [64, 64]}  };
%              allUncertaintySets = {oriXYSet_2x2y3o, oriXYSet_3x6y7o_d2, oriXYSet_3x6y7o, oriXYSet_1pos};
%              allUncertaintySets = { oriXYSet_2x_d4, oriXYSet_2x2y_d4, oriXYSet_2x4y_d4, oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2, oriXYSet_1pos};
    
%              allUncertaintySets = { oriXYSet_1pos, oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2,    oriXYSet_13o_d5, oriXYSet_19o_d5, oriXYSet_25o_d5, oriXYSet_37o_d5};        
             
%                allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_2x4y_d2, oriXYSet_2x4y_d1, oriXYSet_3x7y_d2, oriXYSet_5x13y_d1, ...
%                         oriXYSet_21o_d2, oriXYSet_21o_d2_2x4y_d4, oriXYSet_21o_d2_2x4y_d2, oriXYSet_21o_d2_3x7y_d2, oriXYSet_21o_d2_5x13y_d1};
             
                
%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x4y_d4,    oriXYSet_2x4y_d2, oriXYSet_2x4y_d1, oriXYSet_3x7y_d2, oriXYSet_5x13y_d1, ...
%                     oriXYSet_21o_d2, oriXYSet_21o_d2_2x4y_d4, oriXYSet_21o_d2_2x4y_d2, oriXYSet_21o_d2_3x7y_d2, oriXYSet_21o_d2_5x13y_d1};
%         
%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_5x13y_d1,    oriXYSet_7x18y_d1, oriXYSet_10x26y_d1, oriXYSet_14x37y_d1, oriXYSet_30x39y_d1};

                loopKeysOrder = {'fontName'};
                
                    allUncertaintySets = {oriXYSet_7x18y_d1, oriXYSet_7x18y_d1_3o_d5, oriXYSet_7x18y_d1_7o_d5, oriXYSet_7x18y_d1_11o_d3};

                    
%                     fontNames_use = {'Braille', 'BookmanB', 'Courier', 'KuenstlerU'};

                    
                    
%                     allSizeStyle_imageSizes = { {'k32', [64, 64]}  };
%                 allSizeStyle_imageSizes = { {'k15', [64, 64]}, {'k24', [64, 64]}  };
%                 allUncertaintySets = { oriXYSet_1pos };
                
                allSizeStyle_imageSizes = { {'k15', [64, 64]} };

                oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_5x13y_d1_3ori_d5 = struct('oris', [-5:5:5], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                oriXYSet_5x13y_d1_3ori_d10 = struct('oris', [-10:10:10], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                oriXYSet_5x13y_d1_3ori_d15 = struct('oris', [-15:15:15], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                oriXYSet_5x13y_d1_3ori_d30 = struct('oris', [-30:30:30], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65
                
                allUncertaintySets = {oriXYSet_1pos, oriXYSet_5x13y_d1, oriXYSet_5x13y_d1_3ori_d5, oriXYSet_5x13y_d1_3ori_d10, oriXYSet_5x13y_d1_3ori_d15, oriXYSet_5x13y_d1_3ori_d30};

                
                fontNames_use = num2cell(allFontNames_ext);
                
                oriXYSet_5x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_6x13y_d1 = struct('oris', [0], 'xs', [1 : 1 : 6], 'ys', [1 : 1 : 13] );  % for complexity  5*13   = 65                
                oriXYSet_5x14y_d1 = struct('oris', [0], 'xs', [1 : 1 : 5], 'ys', [1 : 1 : 14] );  % for complexity  5*13   = 65                
                
                allUncertaintySets = {oriXYSet_1pos, oriXYSet_5x13y_d1, oriXYSet_6x13y_d1, oriXYSet_5x14y_d1};
                
                
        case 'Grouping',
            
            all_SNRs = [-1 : 0.5 : 5];
            fontNames_use = {{'Snakes'}}; %num2cell(allFontNames_std);
            fontNames_use = num2cell( struct('fonts', 'Snakes', 'wiggles', allWiggleSettings_all) );

%                 allSizeStyle_imageSizes = { {'k27', [64, 64]}  };
            
            allUncertaintySets = { oriXYSet_1pos, oriXYSet_2x2y_d1,    oriXYSet_4x4y_d1, oriXYSet_8x8y_d1, oriXYSet_16x16y_d1, oriXYSet_22x22y_d1};
                        

               oriXYSet_15x15y_d1 = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 15 ] );  % for complexity 15*15 = 225
               oriXYSet_7x7y_d2 = struct('oris', [0], 'xs', [1 : 2: 15 ], 'ys', [1 : 2 : 15 ] );  % for complexity 7*7 = 49

               oriXYSet_21x21y_d1 = struct('oris', [0], 'xs', [1 :    21 ], 'ys', [1 : 21 ] );  % for complexity 21*21 = 225
               oriXYSet_10x10y_d2 = struct('oris', [0], 'xs', [1 : 2: 21 ], 'ys', [1 : 2 : 21 ] );  % for complexity 15*15 = 225
               
               oriXYSet_11o_15x15y_d1 = struct('oris', [-10:2:10], 'xs', [1 : 1: 15 ], 'ys', [1 : 15 ] );  % for complexity 15*15 = 225
               oriXYSet_11o_7x7y_d2   = struct('oris', [-10:2:10], 'xs', [1 : 2: 15 ], 'ys', [1 : 2 : 15 ] );  % for complexity 15*15 = 225

               oriXYSet_11o_21x21y_d1 = struct('oris', [-10:2:10], 'xs', [1 : 1:  21 ], 'ys', [1 : 21 ] );     % for complexity 15*15 = 225
               oriXYSet_11o_10x10y_d2 = struct('oris', [-10:2:10], 'xs', [1 : 2: 21 ], 'ys', [1 : 2 : 21 ] );  % for complexity 15*15 = 225
               
%                 allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x15y_d1,    oriXYSet_7x7y_d2, oriXYSet_21x21y_d1, oriXYSet_10x10y_d2, ...
%                    oriXYSet_11o_15x15y_d1, oriXYSet_11o_7x7y_d2,  oriXYSet_11o_21x21y_d1, oriXYSet_11o_10x10y_d2 };
               
               allUncertaintySets = {oriXYSet_3o_d5, oriXYSet_13o_d5, oriXYSet_21o_d2,   oriXYSet_25o_d5, oriXYSet_1pos,   }; % for texture

                   
                   oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_3o_d5       = struct('oris', [-5:5:5], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_7o_d5       = struct('oris', [-15:5:15], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_21o_d2       = struct('oris', [-20:2:20], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_11o_d1       = struct('oris', [-5:1:5], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484
                   oriXYSet_15x19y_d1_31o_d1       = struct('oris', [-15:1:15], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  % for complexity 22*22 = 484

                   
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_15x19y_d1_3o_d5, oriXYSet_15x19y_d1_7o_d5, ...
%                                            oriXYSet_15x19y_d1_21o_d2, oriXYSet_15x19y_d1_11o_d1, oriXYSet_15x19y_d1_31o_d1};
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_15x19y_d1_3o_d5, oriXYSet_15x19y_d1_7o_d5, ...
%                                            oriXYSet_15x19y_d1_21o_d2, oriXYSet_15x19y_d1_11o_d1, oriXYSet_15x19y_d1_31o_d1};

%                     allSizeStyle_imageSizes = { {'k27', [64, 64]}  };
%                                        
%                    oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
%                    oriXYSet_22x26y_d1             = struct('oris', [0], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
%                    oriXYSet_22x26y_d1_21o_d1      = struct('oris', [-10:1:10], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
%                    oriXYSet_22x26y_d1_41o_d1      = struct('oris', [-20:1:20], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
%                    
%                     allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, oriXYSet_22x26y_d1_21o_d1, ...
%                                            oriXYSet_22x26y_d1_41o_d1};
%                                        
   
                    allSizeStyle_imageSizes = { {'k32', [96, 96]}  };

                    oriXYSet_15x19y_d1             = struct('oris', [0], 'xs', [1 : 15 ], 'ys', [1 : 19 ] );  
                   oriXYSet_22x26y_d1             = struct('oris', [0], 'xs', [1 : 22 ], 'ys', [1 : 26 ] ); 
                   oriXYSet_31x36y_d1             = struct('oris', [0], 'xs', [1 : 31 ], 'ys', [1 : 36 ] ); 
                   oriXYSet_45x47y_d1             = struct('oris', [0], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
                   oriXYSet_45x47y_d1_21o_d1      = struct('oris', [-10:1:10], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
                   oriXYSet_45x47y_d1_41o_d1      = struct('oris', [-20:1:20], 'xs', [1 : 45 ], 'ys', [1 : 47 ] ); 
                   
                    allUncertaintySets = { oriXYSet_1pos, oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, oriXYSet_31x36y_d1, ...
                                           oriXYSet_45x47y_d1, oriXYSet_45x47y_d1_21o_d1, oriXYSet_45x47y_d1_41o_d1};
                                       
%                 allSizeStyle_imageSizes = { {'k48', [64, 64]}  };
%                 allUncertaintySets = { oriXYSet_1pos };


                    allSizeStyle_imageSizes = { {'k32', [64, 64]}  };

                     oriXYSet_2x_d1 = struct('oris', [0], 'xs', [0 : 1 : 1], 'ys', [0] );  
                     oriXYSet_2x_d2 = struct('oris', [0], 'xs', [0 : 2 : 2], 'ys', [0] );  
                     oriXYSet_2x_d3 = struct('oris', [0], 'xs', [0 : 3 : 3], 'ys', [0] );  
                     oriXYSet_2x_d4 = struct('oris', [0], 'xs', [0 : 4 : 4], 'ys', [0] );  
                     oriXYSet_2x_d6 = struct('oris', [0], 'xs', [0 : 6 : 6], 'ys', [0] );  
                     oriXYSet_2x_d8 = struct('oris', [0], 'xs', [0 : 8 : 8], 'ys', [0] );  
                     oriXYSet_2x_d16= struct('oris', [0], 'xs', [0 : 16 : 16], 'ys', [0] );  

                     allUncertaintySets = {oriXYSet_2x_d1, oriXYSet_2x_d2, oriXYSet_2x_d3, oriXYSet_2x_d4, oriXYSet_2x_d6, oriXYSet_2x_d8, oriXYSet_2x_d16};
                                                           

                     oriXYSet_24x24y_d1             = struct('oris', [0], 'xs', [1 : 24], 'ys', [1 : 24]);
                     oriXYSet_26x26y_d1             = struct('oris', [0], 'xs', [1 : 26], 'ys', [1 : 26]);
                     oriXYSet_28x28y_d1             = struct('oris', [0], 'xs', [1 : 28], 'ys', [1 : 28]);

                     oriXYSet_12x12y_d2             = struct('oris', [0], 'xs', [1 : 2 : 24], 'ys', [1 : 2 : 24]);
                     oriXYSet_6x6y_d4               = struct('oris', [0], 'xs', [1 : 4 : 24], 'ys', [1 : 4 : 24]);
                     oriXYSet_4x4y_d6               = struct('oris', [0], 'xs', [1 : 6 : 24], 'ys', [1 : 6 : 24]);

                     allUncertaintySets = {oriXYSet_24x24y_d1, oriXYSet_26x26y_d1, oriXYSet_28x28y_d1, oriXYSet_12x12y_d2, oriXYSet_6x6y_d4, oriXYSet_4x4y_d6};
                     
 
                     allSizeStyle_imageSizes = { {'k32', [80, 80]}  };
                     
                   oriXYSet_38x38y_d1             = struct('oris', [0], 'xs', [1 : 38 ], 'ys', [1 : 38 ] ); 
                   oriXYSet_39x39y_d1             = struct('oris', [0], 'xs', [1 : 39 ], 'ys', [1 : 39 ] ); 
                   oriXYSet_40x40y_d1             = struct('oris', [0], 'xs', [1 : 40 ], 'ys', [1 : 40 ] ); 
                   oriXYSet_41x41y_d1             = struct('oris', [0], 'xs', [1 : 41 ], 'ys', [1 : 41 ] ); 
                   oriXYSet_42x42y_d1             = struct('oris', [0], 'xs', [1 : 42 ], 'ys', [1 : 42 ] ); 
                   oriXYSet_43x43y_d1             = struct('oris', [0], 'xs', [1 : 43 ], 'ys', [1 : 43 ] ); 
                   
%                     allUncertaintySets = { oriXYSet_38x38y_d1, oriXYSet_40x40y_d1,  oriXYSet_42x42y_d1};
                    
                    allUncertaintySets = { oriXYSet_38x38y_d1, oriXYSet_40x40y_d1,  oriXYSet_41x41y_d1, oriXYSet_42x42y_d1, ...
                        oriXYSet_39x39y_d1, oriXYSet_41x41y_d1, oriXYSet_43x43y_d1};
                    
                
                     loopKeysOrder = {'fontName'};
         case 'Uncertainty',
%              fontNames_use = {{'Bookman'}};
             fontNames_use = {{'Bookman'}, {'Sloan'} };
%              allSizeStyle_imageSizes = { {'k15', [64, 64]}  };
             allSizeStyle_imageSizes = { {'k15', [32, 160]}  };


               allUncertaintySets = {oriXYSet_1pos, oriXYSet_3x1y_d1, oriXYSet_5x1y_d1, oriXYSet_15x1y_d1, oriXYSet_30x1y_d1, oriXYSet_15x2y_d1, oriXYSet_3x5y_d1, oriXYSet_5x3y_d1, oriXYSet_2x15y_d1, oriXYSet_1x30y_d1 };
               
               
               oriXYSet_3x_d3 = struct('oris', [0], 'xs', [1  : 3 : 3*3], 'ys', [0] );  
               oriXYSet_7x_d3 = struct('oris', [0], 'xs', [1  : 3 : 7*3], 'ys', [0] );  
               oriXYSet_15x_d3 = struct('oris', [0], 'xs', [1 : 3 : 15*3], 'ys', [0] );  
               oriXYSet_20x_d3 = struct('oris', [0], 'xs', [1 : 3 : 20*3], 'ys', [0] );  
               oriXYSet_30x_d3 = struct('oris', [0], 'xs', [1 : 3 : 30*3], 'ys', [0] );  
               oriXYSet_45x_d3 = struct('oris', [0], 'xs', [1 : 3 : 45*3], 'ys', [0] );  
               
               allUncertaintySets = {oriXYSet_1pos, oriXYSet_3x_d3, oriXYSet_7x_d3, oriXYSet_15x_d3, oriXYSet_20x_d3, oriXYSet_30x_d3, oriXYSet_45x_d3};
               
               
            loopKeysOrder = {'OriXY', 'fontName'};

        case 'ChannelTuning',
            
            fontNames_use = {'Bookman'};
             allSizeStyle_imageSizes = { {'k36', [64, 64]} };
%             trainingNoise = {'white'};
            tbl_trainingNoise = whiteNoiseFilter ;
            
            tbl_noiseFilter = allBandNoiseFilters;
            
            oriXYSet_4x4y_d1 = struct('oris', [0], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
            oriXYSet_4x4y_d1_3o_d5 = struct('oris', [-5:5:5], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
            oriXYSet_4x4y_d1_7o_d5 = struct('oris', [-15:5:15], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
            oriXYSet_4x4y_d1_11o_d1 = struct('oris', [-5:1:5], 'xs', [0 : 3 ], 'ys', [0 : 3 ] );  % for channels 4*4 = 16
            
%             allUncertaintySets = { oriXYSet_1pos }; %, oriXYSet_4x4y_d1, oriXYSet_4x4y_d1_3o_d5, oriXYSet_4x4y_d1_7o_d5, oriXYSet_4x4y_d1_11o_d1 };
            allUncertaintySets = { oriXYSet_1pos, oriXYSet_4x4y_d1, oriXYSet_4x4y_d1_3o_d5, oriXYSet_4x4y_d1_7o_d5, oriXYSet_4x4y_d1_11o_d1 };
%             allUncertaintySets = { oriXYSet_4x4y_d1_11o_d1 };

                     loopKeysOrder = {'noiseFilter', 'OriXY'};    
                     allSNRs = [-1 : 0.5 : 5];
    end
    
    
    allLetterOpts_S = struct('expName', expName, ...
                          'stimType', 'NoisyLetters', ...
                          'tbl_fontName', {fontNames_use}, ...
                          'autoImageSize', autoImageSize, ...
                          ...'sizeStyle', sizeStyle, ...
                          ...'tbl_imageSize', {[32, 32], [64, 64]}, ...
                          'tbl_sizeStyle_and_imageSize', { allSizeStyle_imageSizes }, ...
                          'tbl_OriXY', {allUncertaintySets}, ...            
                          'blurStd', 0, ...            
                          'tbl_classifierForEachFont', {allClassifierForEachFont}, ...    
                          ...
                          'tbl_noiseFilter', {tbl_noiseFilter}, ...
                          'tbl_trainingNoise', {tbl_trainingNoise}, ...
                          ...
                          'nLettersEachImage', 1, ...
                          'targetPosition', 'all');

    allLetterOpts = expandOptionsToList( allLetterOpts_S, loopKeysOrder ); % put fontName & noise filter at the end
    displayOptions(allLetterOpts_S );
                      

    if onLaptop
        keyboard;
    end
    for opt_i = 1:length(allLetterOpts)
        letterOpt = allLetterOpts(opt_i);
        OriXY = letterOpt.OriXY;
        [letterOpt.oris, letterOpt.xs, letterOpt.ys] = deal(OriXY.oris, OriXY.xs, OriXY.ys);
        fontNames = letterOpt.fontName;
        %%
        fprintf('\n == %s === Opt %d/%d : %s\n', expName, opt_i, length(allLetterOpts), getIdealObserverFileName(letterOpt.fontName, nan, letterOpt));
        for si = 1:length(allSNRs)    
            snr = allSNRs(si);
            
            testIdealObserver(fontNames, snr, letterOpt, [], redo);
            
        end
    end


end