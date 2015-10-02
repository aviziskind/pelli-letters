function fn = getNoisyLettersTextureStatsFileName(fontName, snr, letterOpts) %, metamerLetterOpts)
    
    opts_str = getNoisyLettersTextureStatsOptsStr(letterOpts);
    
    if isfield(letterOpts, 'fontSize')
        sizeStyle = letterOpts.fontSize;
    elseif isfield(letterOpts, 'sizeStyle')
        sizeStyle = letterOpts.sizeStyle;
    end
    
    fn = sprintf('%sStats-%s_%s-%02.0fSNR.mat',fontName, num2str(sizeStyle), opts_str, snr*10);
        
end