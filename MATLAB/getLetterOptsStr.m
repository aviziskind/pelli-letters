function [let_opt_str, let_opt_str_nice] = getLetterOptsStr(letterOpts, niceStrFields)
    
    
    if nargin < 2
        niceStrFields = {};
    end
    if ~iscell(niceStrFields)
        niceStrFields = {niceStrFields};
    end
    makeNiceStr = nargout >= 2;
    let_opt_str_nice = '';
    
    [fontName_str, fontName_str_nice] = abbrevFontStyleNames(letterOpts.fontName);
    if any(strcmp( letterOpts.fontName, 'SVHN')) || ~isempty(strfind(fontName_str, 'SVHN'))
        [let_opt_str, let_opt_str_nice] = deal(fontName_str, fontName_str_nice);
        return
    end
        
    isSVHN = @(fontName) ~isempty(strfind(abbrevFontStyleNames(fontName, 'font'), 'SVHN'));
    if isSVHN(letterOpts.trainingFonts)
        niceStrFields = setdiff(niceStrFields, 'trainingImageSize');
        niceStrFields = [niceStrFields, 'svhn_imageSize'];
    end
        
    
    fontName = letterOpts.fontName;
    if isfield(letterOpts, 'fullFontSet') && ~isequal(letterOpts.fullFontSet, 'same') && ~isequal(letterOpts.fullFontSet, letterOpts.fontName)    
        fontName = letterOpts.fullFontSet;
        if makeNiceStr && any(strcmpi(niceStrFields, 'fontNames'))
            let_opt_str_nice = appendToStr(let_opt_str_nice, ['Fonts= ', abbrevFontStyleNames(fontName)]);
        end
    end
    if isfield(letterOpts, 'fullStyleSet') && ~isequal(letterOpts.fullStyleSet, 'same')
        fontName = struct('fonts', {fontName}, 'styles', {letterOpts.fullStyleSet});
        if makeNiceStr && any(strcmpi(niceStrFields, 'fontStyles'))
            let_opt_str_nice = appendToStr(let_opt_str_nice, ['Styles = ', abbrevFontStyleNames(letterOpts.fullStyleSet)]);
        end
%         expandFontsToTheseStyles(fontName, letterOpts.fullStyleSet);
    end
    
    if isSnakeLetterOpt(letterOpts) && isfield(letterOpts, 'fullWiggleSet') && ~isequal(letterOpts.fullWiggleSet, 'same')
        fontName.wiggles = letterOpts.fullWiggleSet;
    end
    
    [fontName_str, fontName_str_med] = abbrevFontStyleNames(fontName, 'font');
    
    if makeNiceStr && any(strcmp(niceStrFields, 'fontName'))
        let_opt_str_nice = appendToStr(let_opt_str_nice, ['Font= ' fontName_str_med]); 
    end

    
    sizeStyle_str = ['-' getFontSizeStr(letterOpts.sizeStyle)];
    if makeNiceStr && any(strcmp(niceStrFields, 'fontSize'))
        let_opt_str_nice = appendToStr(let_opt_str_nice, ['Size= ' getFontSizeStr(letterOpts.sizeStyle)]);
    end

 
    snr_train_str = ['_SNR' toOrderedList(letterOpts.snr_train)];
    if makeNiceStr && any(strcmp(niceStrFields, 'SNR_train'))
        SNR_train_str_nice = sprintf('Train SNR = %s', toOrderedList(letterOpts.snr_train, [], ',', [], '-'));
        let_opt_str_nice = appendToStr(let_opt_str_nice, SNR_train_str_nice);
    end
          
    
    if any(strcmp(letterOpts.expName, {'Complexity', 'Grouping', 'ChannelTuning', 'TrainingWithNoise'}))
        [opt_str, opt_str_nice] = getNoisyLetterOptsStr(letterOpts, niceStrFields);
    elseif strcmp(letterOpts.expName, 'Crowding') 
        [opt_str, opt_str_nice] = getCrowdedLetterOptsStr(letterOpts, niceStrFields);
%     elseif strcmp(letterOpts.expTitl, 'NoisyLettersTextureStats')
%         [opt_str, opt_str_nice] = getNoisyLettersTextureStatsOptsStr(letterOpts, niceStrFields);
    elseif strcmp(letterOpts.expName, 'MetamerLetters')
        [opt_str, opt_str_nice] = getMetamerLetterOptsStr(letterOpts, niceStrFields);
    end
    
    
    let_opt_str = [fontName_str  sizeStyle_str  snr_train_str '__' opt_str];
    let_opt_str_nice = appendToStr(let_opt_str_nice, opt_str_nice);
    
    
end

function s = getFontSizeStr(fontSize)
   
    if ischar(fontSize)
        s = fontSize;
    elseif isnumeric(fontSize)
        assert(length(fontSize) <= 2)
        if length(fontSize) == 1
            s = sprintf('%d', fontSize);
        elseif length(fontSize) == 2
            s = sprintf('%d(%d)', fontSize);
        end
    end
        
end
 