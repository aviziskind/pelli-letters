function [realData_opt_str, realData_opt_str_nice, realData_opt_fileStr] = getRealDataOptsStr(opts, niceStrFields) 
    
    
    realData_opt_str_nice = '';
    if nargin < 2
        niceStrFields = {};
    end
         
    orig_rgb = isfield(opts, 'orig') && isequal(opts.orig, true);

    gray_suffix_fileStr = '_gray';
    if orig_rgb
        gray_suffix_fileStr = '';
    end  
        
    
    useExtra_str = '';
    if isfield(opts, 'useExtraSamples') && isequal( opts.useExtraSamples, 1)
        useExtra_str = 'x';
    end
    
    globalNorm_str = '';
    globalNorm_fileStr = '_gnorm';
    if isfield(opts, 'globalNorm') && opts.globalNorm ~= 1 
        globalNorm_str = 'u'; % ="unnnormalized" (no global normalization) (default: global normalized)
        globalNorm_fileStr = '';
    end

    
    localContrastNorm_str = '';
    localContrastNorm_fileStr = '';
    if isfield(opts, 'localContrastNorm') && (opts.localContrastNorm == 1)
        localContrastNorm_str = 'c'; % ="contrast" normalization (default: not contrast normalized)
        localContrastNorm_fileStr = '_lcnorm';
    end
    
    imageSize_str = '';
    imageSize_default = [32 32];
    imageSize = imageSize_default;
    if isfield(opts, 'imageSize')
        imageSize = opts.imageSize;
    end
    if length(imageSize) == 1
        imageSize = [imageSize, imageSize];
    end
    
    if any(imageSize ~= imageSize_default) 
        imageSize_str = sprintf('_%dx%d', imageSize);
    end
    imageSize_fileStr = sprintf('_%dx%d', imageSize);
    
    
    scaleMethod_str = '';
    scaleMethod_fileStr = '';
    if any(imageSize ~= imageSize_default) && isfield(opts, 'scaleMethod')
        switch lower(opts.scaleMethod)
            case 'fourier', scaleMethod_str = ''; scaleMethod_fileStr = '';
            case 'pad', scaleMethod_str = 'p'; scaleMethod_fileStr = '_pad';
            case 'tile',    scaleMethod_str = 't'; scaleMethod_fileStr = '_tile';
            otherwise, error('Unknown scaling method');
        end
    end
    
    if any(strcmpi(niceStrFields, 'imageSize'))  || any(strcmpi(niceStrFields, 'realData_imageSize'))
        realData_opt_str_nice = appendToStr(realData_opt_str_nice, sprintf('%dx%d', imageSize));
    end

    textureStats_str = '';
    if isfield(opts, 'doTextureStatistics') && opts.doTextureStatistics
        textureStats_str = getTextureStatsStr(opts);        
    end

    loadOpts_str = '';
    if isfield(opts, 'loadOpts')
        loadOpts_str = getLoadOptsStr(opts.loadOpts);
    end
    
    realData_opt_str = [globalNorm_str  localContrastNorm_str useExtra_str imageSize_str scaleMethod_str textureStats_str loadOpts_str];
    
    realData_opt_fileStr = [imageSize_fileStr scaleMethod_fileStr gray_suffix_fileStr  globalNorm_fileStr localContrastNorm_fileStr    textureStats_str];
    
%     let_opt_str_nice = ['(' let_opt_str ')'];
%     let_opt_str_nice = strrep(let_opt_str, '_', ' ');
    realData_opt_str_nice = appendToStr(realData_opt_str_nice, realData_opt_str, '-');
   
    if ~isempty(realData_opt_str_nice)
        realData_opt_str_nice = [' ('   strrep(realData_opt_str_nice, '_', '')   ')'];
    end
        
    
%     let_opt_str = ['SVHN' useExtra_str];
    
end


%         isSVHN = @(fontName) ~isempty(strfind(abbrevFontStyleNames(fontName, 'font'), 'SVHN'));
%     if isSVHN(letterOpts.trainingFonts)
%         niceStrFields = setdiff(niceStrFields, 'trainingImageSize');
%         niceStrFields = [niceStrFields, 'realData_imageSize'];
%     end


%{
    let_opt_str = [globalNorm_str  localContrastNorm_str useExtra_str       imageSize_str textureStats_str];
                    [''/'u'             'c'/''            'x'/''             32x32          N3_M4_K7
                     '_gnorm'/''        'lcnorm'/''       fileType='extra' 
    
                       SVHNc_32x32_N3_M4_K7     SVHN_train_32x32_gray_gnorm_lcnorm_N3_M4_K7
                           ----------------                ---------------------------      
                     
%}