function [pCorr1, pCorr2] = loadCrowdingResults(expTitle, fontName, nDistractors, allSpacings, allTDRs, curNetwork, crowdedLetterOpts, opt, nTrials)
% (expTitle, allFontNames, allSNRs_test, allSNRs_train, allNetworks, noisyLetterOpts)

%     pctCorrect_model_v_snr = loadModelResults(expTitle, allFontNames, allSNRs_test, allSNR_train, allNetworks, noisyLetterOpts); 

%     nFonts = length(allFontNames);
%     nNetworks = length(allNetworks);

    nSpacings = length(allSpacings);
    nTDRs = length(allTDRs);
%     all_nHUnits = [1,2,3,4,5,6,7,8,9,10,20,50,100];

    pCorr1 = nan(1, nTrials);
    pCorr2 = nan(nNDistractors, nSpacings, nTDRs, nTrials);

%     for net_i = 1:nNetworks
    for trial_i = 1:nTrials

        expSubtitle = getExpSubtitle(fontName, [], curNetwork, crowdedLetterOpts, trial_i);

        [pCorr_1_i, pCorr_2_v_spacing_tdr_i, allNDistractors_data, allSpacings_data, allTDRs_data] = loadModelPerformanceOnCrowdedLetters(expTitle, expSubtitle, opt);
        nDist_use_idx = binarySearch(allNDistractors_data, nDistractors);
        spacings_use_idx = binarySearch(allSpacings_data, allSpacings);
        tdrs_use_idx = binarySearch(allTDRs_data, allTDRs);

        if ~any(isnan(pCorr_2_v_spacing_tdr_i)) && (haveRepeatsIn(nDist_use_idx) || haveRepeatsIn(spacings_use_idx) || haveRepeatsIn(tdrs_use_idx));
            error('Clashing');
        end

        if isnan(pCorr_1_i)
            break;
        end
        
        pCorr1(trial_i) = pCorr_1_i;
        pCorr2(:,:,:, trial_i) = pCorr_2_v_spacing_tdr_i(nDist_use_idx, spacings_use_idx, tdrs_use_idx);
        
    end
    3;
    
end

function tf = haveRepeatsIn(x)
    tf = length(unique(x)) < length(x);
end
