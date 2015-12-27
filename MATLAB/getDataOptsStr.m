function [opt_str, opt_str_nice] = getDataOptsStr(dataOpts, niceStrFields)
    if nargin < 2
        niceStrFields = {};
    end
    
    if isRealDataFont(dataOpts.fontName) 
%         realDataName_str = abbrevFontStyleNames(dataOpts.fontName);
        realDataName_str = dataOpts.fontName.fonts;
        [real_opt_str, real_opt_str_nice] = getRealDataOptsStr(dataOpts.fontName.realData_opts, niceStrFields);
        opt_str = [realDataName_str real_opt_str ];
        opt_str_nice = [realDataName_str ': ' real_opt_str_nice];
        
    else
        [opt_str, opt_str_nice] = getLetterOptsStr(dataOpts, niceStrFields);
    end 
    
    
    
end
