function [fn, f_path] = getNoisyLetterFileName(fontName, logSNR, noisyLetterOpts)
    
    if iscell(fontName) || isstruct(fontName)
        fontName = abbrevFontStyleNames(fontName);
    end
    
    fontSizeStr = getFontSizeStr( noisyLetterOpts.sizeStyle );

    tf_pca = isfield(noisyLetterOpts, 'tf_pca') && noisyLetterOpts.tf_pca == true;
    pca_str = iff(tf_pca, '_PCA', '');
    
    noisyOpt_str = getNoisyLetterOptsStr(noisyLetterOpts);
    
    userName_str = '';
    if isfield(noisyLetterOpts, 'userName')
        userName_str = ['_' noisyLetterOpts.userName];
    end
    
    snr_str = '';
    addNoise = ~isempty(logSNR) && ~isnan(logSNR);
    if addNoise
        snr_str = ['-' strrep( sprintf('%02.0fSNR', logSNR*10), '-', 'n')];
    end
    
    fn = sprintf('%s_%s%s-%s%s%s.mat',fontName,fontSizeStr, pca_str, ...
        noisyOpt_str, snr_str, userName_str);
    
    if nargout > 1
        f_path = [datasetsPath noisyLetterOpts.stimType filesep fontName filesep];
    end
    
end

