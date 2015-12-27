function [crowdedOpts_str, crowdedOpts_str_nice] = getCrowdedLetterOptsStr(letterOpts, niceStrFields)
    if nargin < 2
        niceStrFields = {};
    end
    makeNiceStr = ~isempty(niceStrFields);
    crowdedOpts_str_nice = '';
    
    if isfield(letterOpts, 'crowdingSettings')
        letterOpts = letterOpts.crowdingSettings;
    end
    
    xrange = letterOpts.xrange;
    if iscell(xrange)
        xrange = [xrange{:}];
    end
    assert(length(xrange) == 3);
    x_range_str = sprintf('x%d-%d-%d',  xrange);
    

        
    dnr_str = '';
    distractorSpacing_str = '';
    testPositions_str = '';

    nLetters = letterOpts.nDistractors + 1; % nLetters;
    nLetters_str = sprintf('%dlet', nLetters);
    
    if makeNiceStr && any(strcmpi(niceStrFields, 'nLetters'))
        crowdedOpts_str_nice = appendToStr(crowdedOpts_str_nice, sprintf('nLet = %d', nLetters));
    end
    
    
    
    
    if nLetters == 1 %  Training data (train on 1 letter)
        
%         train_test_str = sprintf('Train_%s', targetPos_str);

        curTargetPosition_str = ['_' targetPositionStr( letterOpts.trainPositions) ];
%         train_test_str = sprintf('Train_%s', targetPos_str);

    elseif nLetters > 1 % Test on multiple letters

        curTargetPosition_str = ['_' targetPositionStr( letterOpts.testPositions) ];

        dnr_str = sprintf('_DNR%02.0f', letterOpts.logDNR*10); % distractor-to-noise ratio
        if makeNiceStr && any(strcmpi(niceStrFields, 'DNR'))
            crowdedOpts_str_nice = appendToStr(crowdedOpts_str_nice, sprintf('DNR = %.1f', letterOpts.logDNR));
        end
        if ~isnan(letterOpts.distractorSpacing)
            distractorSpacing_str = sprintf('_d%d', letterOpts.distractorSpacing); % ie: all positions differences in X pixels
        end

        if isfield(letterOpts, 'testPositions') && isfield(letterOpts, 'trainPositions')  && ~isempty(letterOpts.trainPositions) && ...
                ~isequal(letterOpts.trainPositions, letterOpts.testPositions)
            testPositions_str = ['_tr' targetPositionStr( letterOpts.trainPositions )];
        end

    end
        
    details_str = sprintf('__%s%s%s%s', nLetters_str, distractorSpacing_str, dnr_str, testPositions_str);

    crowdedOpts_str = ['__' x_range_str, curTargetPosition_str, details_str ];    
    
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


%     targetPosition_str = '';
%     if isfield(noisyLetterOpts, 'targetPosition') &&  ~strcmpi(noisyLetterOpts.targetPosition, 'all') 
%         targetPosition_str = sprintf('_T%d', noisyLetterOpts.targetPosition);
%     end
% 
%     nLetters_str = '';
%     if  isfield(noisyLetterOpts, 'nLetters') && noisyLetterOpts.nLetters > 1
%         nLetters_str = sprintf('_L%d', noisyLetterOpts.nLetters);
%     end
% 
%     
%     
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