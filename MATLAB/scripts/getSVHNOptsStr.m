function [let_opt_str, let_opt_str_nice] = getSVHNOptsStr(svhn_opts, niceStrFields) 
    
    
    let_opt_str_nice = '';
    if nargin < 2
        niceStrFields = {};
    end
     
    useExtra_str = '';
    if isfield(svhn_opts, 'useExtraSamples') && isequal( svhn_opts.useExtraSamples, 1)
        useExtra_str = 'x';
    end
    
    globalNorm_str = '';
    if isfield(svhn_opts, 'globalNorm') && svhn_opts.globalNorm ~= 1 
        globalNorm_str = 'u'; % ="unnnormalized" (no global normalization) (default: global normalized)
    end
    
    localContrastNorm_str = '';
    if isfield(svhn_opts, 'localContrastNorm') && (svhn_opts.localContrastNorm == 1)
        localContrastNorm_str = 'c'; % ="contrast" normalization (default: not contrast normalized)
    end
    
    imageSize_str = '';
    imageSize_default = [32 32];
    imageSize = imageSize_default;
    if isfield(svhn_opts, 'imageSize')
        imageSize = svhn_opts.imageSize;
    end
    if length(imageSize) == 1
        imageSize = [imageSize, imageSize];
    end
    if any(imageSize ~= imageSize_default)
        imageSize_str = sprintf('_%dx%d', imageSize);
    end
    
    if any(strcmpi(niceStrFields, 'imageSize')) || any(strcmpi(niceStrFields, 'svhn_imageSize'))
        let_opt_str_nice = appendToStr(let_opt_str_nice, sprintf('%dx%d', imageSize));
    end

    
    let_opt_str = [globalNorm_str  localContrastNorm_str useExtra_str imageSize_str];
    
%     let_opt_str_nice = ['(' let_opt_str ')'];
%     let_opt_str_nice = strrep(let_opt_str, '_', ' ');
    let_opt_str_nice = appendToStr(let_opt_str_nice, let_opt_str, '-');
   
    if ~isempty(let_opt_str_nice)
        let_opt_str_nice = [' ('   strrep(let_opt_str_nice, '_', '')   ')'];
    end
        
    
%     let_opt_str = ['SVHN' useExtra_str];
    
end
