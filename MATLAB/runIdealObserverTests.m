function runIdealObserverTests
    

%     expName = 'Grouping';
    expName = 'Complexity';
    
    
%     fontName = 'BookmanU';
%     sizeStyle = 'k16';
%     sizeStyle = 'k38';
    autoImageSize = 0;
%     imageSize = [48 48];
%     imageSize = [32 80];
%     imageSize = [64 64];    
%     imageSize = [32 32];
    
    allOriXYSets_large = struct('oris', [-10:2:10], 'xs', [0:5], 'ys', [0:11] );
    allOriXYSets_med1 = struct('oris', [0], 'xs', [0:5], 'ys', [0:11] );
    allOriXYSets_med2 = struct('oris', [-10:2:10], 'xs', [0], 'ys', [0] );
%     allOriXYSets_test1 = struct('oris', [-2:2:2], 'xs', [-2,2], 'ys', [-2,2] );
    allOriXYSets_no_uncertainty = struct('oris', 0, 'xs', 0, 'ys', 0 );
    allOriXYSets_long = struct('oris', [-10:2:10], 'xs', [0:2:46], 'ys', [0:4] );
    allOriXYSets_large_48_k14 = struct('oris', [-10:2:10], 'xs', [0:2:10], 'ys', [0:2:16]);
    
    oriXYSets_3x3y = struct('oris', 0, 'xs', [-1,0,1], 'ys', [-1,0,1]);
    oriXYSets_5x5y = struct('oris', 0, 'xs', [-2:2], 'ys', [-2:2]);
    oriXYSets_5x5y = struct('oris', 0, 'xs', [-2:2], 'ys', [-2:2]);
    oriXYSets_9x9y7o = struct('oris', [-15:5:15], 'xs', [0:3:24], 'ys', [0:3:24]);
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
    
    
%     allOriXYSets = [allOriXYSets_test_no, allOriXYSets_med1, allOriXYSets_med2, allOriXYSets_large];
%     allOriXYSets = [allOriXYSets_test_no, allOriXYSets_med2];
%     allOriXYSets = [allOriXYSets_long];
%     allOriXYSets = {allOriXYSets_large_48_k14, allOriXYSets_no_uncertainty};

%     allFontNames_std = {'Bookman', 'BookmanU', 'Sloan', 'Helvetica', 'Courier', 'KuenstlerU', 'Braille', 'Yung'};
    allFontNames_std = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};
    
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
    
    if strncmp(getHostname, 'XPS', 3)
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
    doMult = 0 && 1;
    noWiggle = [1];
    if doMult
        oriWiggles    = [[0:10:60], num2cell(0:10:90)];
        offsetWiggles = [[0:10:60], num2cell(0:10:60)];
        phaseWiggles  = [num2cell([0, 1]), [0:1]];
    else
        oriWiggles = [5:5:90];
        offsetWiggles = [5:5:60];
        phaseWiggles = [1];
    end

    doNoWiggle = true;
    doOriWiggles = true;
    doOffsetWiggles = true;
    doPhaseWiggles = true;
        
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
    
%     oriXY_use = {allOriXYSets_large_48_k14, allOriXYSets_no_uncertainty};
    oriXY_use = {allOriXYSets_no_uncertainty, oriXYSets_3x3y, oriXYSets_5x5y};
    oriXY_use = {oriXYSet_10x10y21o, allOriXYSets_no_uncertainty };
    oriXY_use = {oriXYSet_10x10y21o, oriXYSet_19x19y21o};
    oriXY_use = {oriXYSet_30x30y21o};
    oriXY_use = {oriXYSet_6x9y21o, allOriXYSets_no_uncertainty, oriXYSet_4x4y7o, oriXYSet_6x6y11o};
    oriXY_use = {allOriXYSets_no_uncertainty, oriXYSet_10x10y21o, oriXYSet_5x5y11o};
    oriXY_use = {oriXYSet_5x5y11o_d2, oriXYSet_41o, oriXYSet_7x7y, allOriXYSets_no_uncertainty, oriXYSet_10x10y21o, oriXYSet_5x5y11o};
    
    oriXY_use = {oriXYSet_2x2y3o, oriXYSet_3x6y7o, allOriXYSets_no_uncertainty};
    

%     oriXY_use = {allOriXYSets_no_uncertainty, allOriXYSets_large_48_k14};
        
%     allSizeStyle_imageSizes = { {'k32', [64, 64]}, {'k16', [32 32]} };
%     allSizeStyle_imageSizes = { {'55', [64, 64]} };
%     allSizeStyle_imageSizes = { {'55', [96, 96]} };
%     allSizeStyle_imageSizes = { {'32', [64, 64]} };
    allSizeStyle_imageSizes = { {'k32', [64, 64]}  };
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

     switch expName
        case 'Complexity',
            fontNames_use = num2cell(allFontNames_std);

%             allSizeStyle_imageSizes = { {'k24', [64, 64]}  };
%             allSizeStyle_imageSizes = { {'k15', [32, 32]}  };
%             allSizeStyle_imageSizes = { {'k30', [80, 80]}  };
%             allSizeStyle_imageSizes = { {'k30', [64, 64]}  };
            
%             oriXY_use = {allOriXYSets_no_uncertainty};

            allSizeStyle_imageSizes = { {'k15', [56, 56]}, {'k15', [64, 64]}   };
%              oriXY_use = {oriXYSet_2x2y3o, oriXYSet_3x6y7o_d2, oriXYSet_3x6y7o, allOriXYSets_no_uncertainty};
%              oriXY_use = { oriXYSet_2x_d4, oriXYSet_2x2y_d4, oriXYSet_2x4y_d4, oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2, allOriXYSets_no_uncertainty};
    
             oriXY_use = { allOriXYSets_no_uncertainty, oriXYSet_3o_d5, oriXYSet_7o_d5, oriXYSet_11o_d4, oriXYSet_21o_d2,    oriXYSet_13o_d5, oriXYSet_19o_d5, oriXYSet_25o_d5, oriXYSet_37o_d5};        
        case 'Grouping',
            fontNames_use = {{'Snakes'}}; %num2cell(allFontNames_std);
            fontNames_use = num2cell( struct('fonts', 'Snakes', 'wiggles', allWiggleSettings_all) );
                        
    end
    
    
    allLetterOpts_S = struct('expName', expName, ...
                          'stimType', 'NoisyLetters', ...
                          'tbl_fontName', {fontNames_use}, ...
                          'autoImageSize', autoImageSize, ...
                          ...'sizeStyle', sizeStyle, ...
                          ...'tbl_imageSize', {[32, 32], [64, 64]}, ...
                          'tbl_sizeStyle_and_imageSize', { allSizeStyle_imageSizes }, ...
                          'tbl_OriXY', {oriXY_use}, ...            
                          'blurStd', 0, ...            
                          'tbl_classifierForEachFont', {allClassifierForEachFont}, ...    
                          ...
                          'tbl_noiseFilter', {tbl_noiseFilter}, ...
                          'tbl_trainingNoise', {tbl_trainingNoise}, ...
                          ...
                          'nLettersEachImage', 1, ...
                          'targetPosition', 'all');

    allLetterOpts = expandOptionsToList( allLetterOpts_S );
    displayOptions(allLetterOpts_S );
                      
%     allSNRs = [0, 1, 2, 3, 4];
%     allSNRs = [4];
%     allSNRs = [-1 : 0.5 : 5];
%     allSNRs = [-2];
%     allSNRs = [-1 : 0.5 : 5];
    allSNRs = [0 : 0.5 : 5];
    
    for opt_i = 1:length(allLetterOpts)
        letterOpt = allLetterOpts(opt_i);
        OriXY = letterOpt.OriXY;
        [letterOpt.oris, letterOpt.xs, letterOpt.ys] = deal(OriXY.oris, OriXY.xs, OriXY.ys);
        fontNames = letterOpt.fontName;
        %%
        fprintf('\n == Opt %d/%d : %s\n', opt_i, length(allLetterOpts), getIdealObserverFileName(letterOpt.fontName, nan, letterOpt));
        for si = 1:length(allSNRs)    
            snr = allSNRs(si);
            
            testIdealObserver(fontNames, snr, letterOpt, [], redo);
            
        end
    end


end