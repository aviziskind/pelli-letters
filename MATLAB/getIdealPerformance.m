function [pCorr_v_snr, pCorr_eachLetter_v_snr] = getIdealPerformance(letterOpts, snrs, opt)
        
    if nargin < 3
        opt = struct;
    end        
     
    if strcmp(letterOpts, 'save')
        loadIdealPerformance('save')
        return
    end
        
    nSNRs = length(snrs);

%     pCorr_v_snr = zeros(nSNRs,1);
%     pCorr_eachLetter_v_snr = zeros(nSNRs, 1);
%     logE_allSNRs = zeros(1, nSNRs);
    
    if isfield(letterOpts, 'fullFontSet') && ~isequal(letterOpts.fullFontSet, 'same')
        file_fontName = letterOpts.fullFontSet;
    else
        file_fontName = letterOpts.fontName;
    end
    
%     if isfield(letterOpts, 'trainingStyles') && ~(ischar(letterOpts.trainingStyles) && strcmp(letterOpts.trainingStyles, 'same'))
%         file_fontName = struct('fonts', file_fontName, 'styles', {letterOpts.trainingStyles});
%     end
    
    for si = 1:nSNRs
%         [pCorr_total_allSNRs(si), pCorr_eachLetter_allSNRs(si,:), logE_allSNRs(si)] = loadIdealPerformance(fontName{fi}, snr(si), noisyLetterOpts, opt);
        [pCorr_v_snr(si), pCorr_eachLetter_v_snr(si,:)] = loadIdealPerformance(file_fontName, snrs(si), letterOpts, opt); %#ok<AGROW>
    end

end



%     for fi = 1:nFonts
%     nFontSets = 1;
%     idealP_total      = zeros(nSNRs, 1,          nFontSets);
%     idealP_eachLetter = zeros(nSNRs, nClassesMax,nFontSets);
