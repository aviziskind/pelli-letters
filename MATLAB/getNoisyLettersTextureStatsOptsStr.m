function [statOptStr, statOptStr_nice] = getNoisyLettersTextureStatsOptsStr(letterOpts, niceStrFields)
    if nargin < 2
        niceStrFields = {};
    end
    makeNiceStr = ~isempty(niceStrFields);
    statOptStr_nice = '';
%%
    imageSize = letterOpts.imageSize;
    Nscl = letterOpts.Nscl_txt;
    Nori = letterOpts.Nori_txt;
    Na = letterOpts.Na_txt;
    
    useSubsetOfA = isfield(letterOpts, 'Na_sub_txt') && ~isempty(letterOpts.Na_sub_txt) && ~strcmpi(letterOpts.Na_sub_txt, 'all');
    if useSubsetOfA
        Na = letterOpts.Na_sub_txt;
        subsetChar = 'S';
    else
        subsetChar = '';
    end
    
    useBlur = isfield(letterOpts, 'blurStd') && ~isempty(letterOpts.blurStd) && letterOpts.blurStd > 0;
    if useBlur
        blur_str = sprintf('_blur%.0f', letterOpts.blurStd*10);
    else
        blur_str = '';
    end

    test_str = iff(isfield(letterOpts, 'tf_test') && isequal(letterOpts.tf_test, 1), '_test', '');

    
    assert(isnumeric(imageSize));
    imageSize_str = sprintf('%dx%d', imageSize(1),imageSize(1));
    switch letterOpts.textureStatsUse
        case {'V2', 'V2r'}
            useReducedV2Stats_str = iff(strcmpi(letterOpts.textureStatsUse,'V2r'), '_r', '');
            statsParams_str = sprintf('%dscl-%dori-%da%s%s', Nscl, Nori, Na, subsetChar, useReducedV2Stats_str);
            
        case {'V1', 'V1s', 'V1c', 'V1x'}
            statsParams_str = sprintf('%dscl-%dori_%s', Nscl, Nori, letterOpts.textureStatsUse);
            
    end
    
    
    [noiseFilter_str, noiseFilter_str_nice] = noiseFilterOptStr(letterOpts, niceStrFields);
    statOptStr_nice = [statOptStr_nice, noiseFilter_str_nice]; 

    
    retrainFromLayer_str = '';
    if isfield(letterOpts, 'retrainFrom') && ~isempty(letterOpts.retrainFrom) && letterOpts.retrainFrom > 0
        retrainFromLayer_str = ['_rt' sprintf('%d', letterOpts.retrainFrom)];
    end
    
%     statOptStr = sprintf('%dscl-%dori-%da %s%s%s', Nscl, Nori, Na, subsetChar );
    
    
%     statOptStr = sprintf('%dx%d_%dscl-%dori-%da %s%s%s',, Nscl, Nori, Na, subsetChar, blur_str, test_str);
    
    statOptStr = [imageSize_str '_' statsParams_str  noiseFilter_str  blur_str  test_str retrainFromLayer_str];
    
    if makeNiceStr && any(strcmpi(niceStrFields, 'Blur'))
        blur_str_nice = iff(~useBlur, 'No Blur', sprintf('Blur = %0.1f', letterOpts.blurStd));
        statOptStr_nice = [statOptStr_nice, blur_str_nice];
    end

end

% 
% function str = getLimitsStr(x)
%     if length(x) > 1
%         str = sprintf('[%d]', round(diff(lims(x))) );
%     else
%         str = '';
%     end
% 
% end
% 
