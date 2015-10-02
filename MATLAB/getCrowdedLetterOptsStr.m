function [crowdedOpts_str, crowdedOpts_str_nice] = getCrowdedLetterOptsStr(crowdedLetterOpts, niceStrFields)
    if nargin < 2
        niceStrFields = {};
    end
    makeNiceStr = ~isempty(niceStrFields);
    crowdedOpts_str_nice = '';
    
    xrange = crowdedLetterOpts.xrange;
    if iscell(xrange)
        xrange = [xrange{:}];
    end
    assert(length(xrange) == 3);
    x_range_str = sprintf('x%d-%d-%d',  xrange);
    
    blur_str = '';
    useBlur = isfield(crowdedLetterOpts, 'blurStd') && ~isempty(crowdedLetterOpts.blurStd) && crowdedLetterOpts.blurStd > 0;
    if useBlur
        blur_str = sprintf('_blur%.0f', crowdedLetterOpts.blurStd*10);
    end
    
    
    imageSizeStr = '';
    if isfield(crowdedLetterOpts, 'imageSize')
        sz = crowdedLetterOpts.imageSize;
        if length(sz) == 1
            sz = [sz, sz];
        end
        imageSizeStr = sprintf('-[%dx%d]', sz);                
    end
    
    snr_str = '';
    addNoise = isfield(crowdedLetterOpts, 'logSNR') && ~isnan(crowdedLetterOpts.logSNR);
    if addNoise
        snr_str = strrep( sprintf('_SNR%02.0f',  crowdedLetterOpts.logSNR*10), '-', 'n') ;            
    end
    
    
    [noiseFilter_str, noiseFilter_str_nice] = noiseFilterOptStr(crowdedLetterOpts, niceStrFields);
    if makeNiceStr && any(strcmpi(niceStrFields, 'NoiseFilter'))
        crowdedOpts_str_nice = appendToStr(crowdedOpts_str_nice, noiseFilter_str_nice);
    end

        
    dnr_str = '';
    distractorSpacing_str = '';
    testTargetPosition_str = '';

    nLetters = crowdedLetterOpts.nLetters;
    nLetters_str = sprintf('%dlet', nLetters);
    
    if makeNiceStr && any(strcmpi(niceStrFields, 'nLetters'))
        crowdedOpts_str_nice = appendToStr(crowdedOpts_str_nice, sprintf('nLet = %d', nLetters));
    end
    
    
    if nLetters == 1 %  Training data (train on 1 letter)
        
%         train_test_str = sprintf('Train_%s', targetPos_str);

        curTargetPosition_str = ['_' targetPositionStr( crowdedLetterOpts.trainTargetPosition) ];
%         train_test_str = sprintf('Train_%s', targetPos_str);

    elseif nLetters > 1 % Test on multiple letters

        curTargetPosition_str = ['_' targetPositionStr( crowdedLetterOpts.testTargetPosition) ];

        dnr_str = sprintf('_DNR%02.0f', crowdedLetterOpts.logDNR*10); % distractor-to-noise ratio
        if makeNiceStr && any(strcmpi(niceStrFields, 'DNR'))
            crowdedOpts_str_nice = appendToStr(crowdedOpts_str_nice, sprintf('DNR = %.1f', crowdedLetterOpts.logDNR));
        end
        distractorSpacing_str = sprintf('_d%d', crowdedLetterOpts.distractorSpacing); % ie: all positions differences in X pixels

        if isfield(crowdedLetterOpts, 'testTargetPosition') && isfield(crowdedLetterOpts, 'trainTargetPosition')  && ~isempty(crowdedLetterOpts.trainTargetPosition) && ...
                ~isequal(crowdedLetterOpts.trainTargetPosition, crowdedLetterOpts.testTargetPosition)
            testTargetPosition_str = ['_tr' targetPositionStr( crowdedLetterOpts.trainTargetPosition )];
        end

    end
        
    details_str = sprintf('__%s%s%s%s', nLetters_str, distractorSpacing_str, dnr_str, testTargetPosition_str);
    
    textureStats_str = '';
    if crowdedLetterOpts.doTextureStatistics
        textureStats_str = getTextureStatsStr(crowdedLetterOpts);        
    end

    overFeat_str = '';
    if crowdedLetterOpts.doOverFeat
        overFeat_str = getOverFeatStr(crowdedLetterOpts);        
    end

    
    crowdedOpts_str = [x_range_str, curTargetPosition_str, imageSizeStr, snr_str, blur_str, noiseFilter_str, textureStats_str, overFeat_str, details_str ];    
%     crowdedOpts_str = sprintf('x%d-%d-%d_T%s%s%s%s%s%s',  xrange, curTargetPosition_str, imageSizeStr, snr_str, blur_str,   details_str, textureStats_str);    
end


function targetStr = targetPositionStr(targetPosition)
    if ischar(targetPosition)
        assert(strcmpi(targetPosition, 'all'))
        posStr = targetPosition;
    else
        posStr = toOrderedList(targetPosition);
    end
    targetStr = ['T' posStr];
end

%{


function [x_y_str, testStyle] = getCrowdedLetterOptsStr(crowdedLetterOpts, addTestStyle_flag)
%     nOri = length(oris);
%     ori_lims_str = getLimitsStr(oris);        
    
    addTestStyle = exist('addTestStyle_flag', 'var') && isequal(addTestStyle_flag, 1);

    xs = crowdedLetterOpts.xs;
    ys = crowdedLetterOpts.ys;

    nX = length(xs);
    x_lims_str = getLimitsStr(xs);    
    
    nY = length(ys);
    y_lims_str = getLimitsStr(ys);

    x_y_str = sprintf('%dx%s_%dy%s',  nX,x_lims_str, nY,y_lims_str);
    
    testStyle = sprintf('%s%d', crowdedLetterOpts.targetPosition, crowdedLetterOpts.nDistractors);

    if addTestStyle 
        x_y_str = [x_y_str '_' testStyle];
    end
    
    
end
%}