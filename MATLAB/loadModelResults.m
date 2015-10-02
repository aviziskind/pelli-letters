% function [pctCorrectTotal_v_snr, pctCorrectEachLetter_v_snr] = loadModelResults(stimType, allFontNames, allSNRs_test, allSNRs_train, network, noisyLetterOpts, opt, nTrials)
function [pctCorrectTotal_v_snr, pctCorrectEachLetter_v_snr] = loadModelResults(letterOpts, network, allSNRs_test, opt, nTrials)

    if ischar(letterOpts) && strcmp(letterOpts, 'save')
        loadModelPerformanceOnNoisyLetters('save')
        return;
    end
    stimType = letterOpts.stimType;
        
    nSNRs = length(allSNRs_test); 
    nClassesMax = getNumClassesForFont( abbrevFontStyleNames( letterOpts.fontName) );
    
    if ~exist('nTrials','var') || isempty(nTrials)
        nTrials = 1;
    end
    
    if ~exist('opt', 'var') || isempty(opt)
         opt.skipIfDontHaveModelFile = 0;
    end
    opt_use = opt;
    
    pctCorrectTotal_v_snr      = nan(nTrials,  nSNRs,  1);
    pctCorrectEachLetter_v_snr = nan(nTrials,  nSNRs,  nClassesMax);

    for trial_i = 1:nTrials
        
        expSubtitle = getExpSubtitle(letterOpts, network, trial_i);

        if trial_i == 1
            opt_use = opt;
        end
        if trial_i > 1 && opt.allowFewerThanSpecifiedTrials
            opt_use.skipIfDontHaveModelFile = 1;
        end
            
        [pctCorr_tot_i, pctCorr_eachLetter_i] = loadModelPerformanceOnNoisyLetters(stimType, expSubtitle, allSNRs_test, opt_use, letterOpts);
        
        pctCorrectTotal_v_snr(     trial_i, 1:nSNRs) = pctCorr_tot_i;
        pctCorrectEachLetter_v_snr(trial_i, 1:nSNRs, 1:nClassesMax) = pctCorr_eachLetter_i';

        if length(pctCorr_tot_i) == 1 && isnan(pctCorr_tot_i(1)) 
            break; % no more trials available for this experiment (skip checking the rest).
        end


    end
            
             
end
