function [noisyOpt_str, noisyOpt_str_nice] = getNoisyLetterOptsStr(noisyLetterOpts, niceStrFields)
    if nargin < 2
        niceStrFields = {};
    end
    makeNiceStr = ~isempty(niceStrFields);
    noisyOpt_str_nice = '';
     
    
    oxy_str = '';
    if ~strcmp(noisyLetterOpts.expName, 'Crowding')
        [oxy_str, oxy_str_nice] = getOriXYStr(noisyLetterOpts.OriXY);
        oxy_str = [oxy_str '-'];
        if makeNiceStr && any(strcmpi(niceStrFields, 'Uncertainty'))
    %             noisyOpt_str_nice = [noisyOpt_str_nice, 'No uncertainty; '];
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, oxy_str_nice);
        end
    end
    
    
        
    imageSizeStr = '';
    if ~noisyLetterOpts.autoImageSize
        sz = noisyLetterOpts.imageSize;
        if length(sz) == 1
            sz = [sz, sz];
        end
        imageSizeStr = sprintf('[%dx%d]', sz);        
        
        if makeNiceStr && any(strcmpi(niceStrFields, 'ImageSize'))
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, sprintf('[%dx%d]', sz));
        end
        
    end
            
    differentTrainTestImageSize = isfield(noisyLetterOpts, 'trainingImageSize') && ~isequal(noisyLetterOpts.trainingImageSize, 'same') ...
            && ~ isequal(noisyLetterOpts.trainingImageSize, noisyLetterOpts.imageSize);
   
    trainingImageSizeStr = '';
    if differentTrainTestImageSize 
        trainingImageSizeStr = sprintf('_tr%dx%d', noisyLetterOpts.trainingImageSize);        
        
        if makeNiceStr && any(strcmpi(niceStrFields, 'trainingImageSize')) 
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, sprintf('Trained on %dx%d', noisyLetterOpts.trainingImageSize));
        end

    end
        
    
    useBlur = isfield(noisyLetterOpts, 'blurStd') && ~isempty(noisyLetterOpts.blurStd) && noisyLetterOpts.blurStd > 0;
    blur_str = '';
    if useBlur
        blur_str = sprintf('_blur%.0f', noisyLetterOpts.blurStd*10);
        
        if makeNiceStr && any(strcmpi(niceStrFields, 'Blur'))
            blur_str_nice = iff(~useBlur, 'No Blur. ', sprintf('Blur = %0.1f. ', noisyLetterOpts.blurStd));
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, blur_str_nice);
        end
    end
    
    
    differentTrainTestFonts = isfield(noisyLetterOpts, 'trainingFonts') && ~strcmp(noisyLetterOpts.trainingFonts, 'same') && ...
                              ~strcmp(abbrevFontStyleNames(noisyLetterOpts.trainingFonts), abbrevFontStyleNames(noisyLetterOpts.fontName) );
    trainingFonts_str = '';
    if differentTrainTestFonts
        [trFonts_abbrev, trFonts_abbrev_med] = abbrevFontStyleNames(noisyLetterOpts.trainingFonts, [], struct('niceStrFields', {niceStrFields}));
        trainingFonts_str = ['_trf' trFonts_abbrev];
        if makeNiceStr && any(strcmpi(niceStrFields, 'trainingFonts'))
            trainingFonts_str_nice = sprintf('Trained on %s', trFonts_abbrev_med);
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, trainingFonts_str_nice);
        end
    end
    
    
    differentTrainTestWiggle = isfield(noisyLetterOpts, 'trainingWiggle') && ~isequal(noisyLetterOpts.trainingWiggle, 'same') ...
                               && ~isequal(noisyLetterOpts.trainingWiggle, noisyLetterOpts.fontName.wiggles);
    
    trainingWiggle_str = '';
    if differentTrainTestWiggle
        [trainWiggleStr, trainWiggleStr_nice] = getSnakeWiggleStr(noisyLetterOpts.trainingWiggle);
        
        trainingWiggle_str = ['_trW' trainWiggleStr];
        if makeNiceStr && any(strcmpi(niceStrFields, 'trainingWiggle'))
            trainingWiggle_str_nice = sprintf('Trained on %s', trainWiggleStr_nice);
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, trainingWiggle_str_nice);
        end
    end
    
    
    differentTrainTestUncertainty = isfield(noisyLetterOpts, 'trainingOriXY') && ~isequal(noisyLetterOpts.trainingOriXY, 'same') ...
                                    && ~isequal(noisyLetterOpts.trainingOriXY, noisyLetterOpts.OriXY);
    trainingOriXY_str = '';
    if differentTrainTestUncertainty
        trainingOriXY_str = ['_trU' getOriXYStr(noisyLetterOpts.trainingOriXY)];
        
        if makeNiceStr && any(strcmpi(niceStrFields, 'trainingUncertainty'))
            trainingWiggle_str_nice = sprintf('Tr: %s', trainingOriXY_str);
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, trainingWiggle_str_nice);
        end
        
    end
    
    
    
    [noiseFilter_str, noiseFilter_str_nice] = noiseFilterOptStr(noisyLetterOpts, niceStrFields);
    if makeNiceStr && any(strcmpi(niceStrFields, 'noiseFilter'))
        noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, noiseFilter_str_nice);
    end
    
    differentTrainTestNoise = isfield(noisyLetterOpts, 'trainingNoise') && ~isempty(noisyLetterOpts.trainingNoise) && ~strcmp(noisyLetterOpts.trainingNoise, 'same') && ...
                              isfield(noisyLetterOpts, 'noiseFilter') && ~isequal( getFilterStr(noisyLetterOpts.noiseFilter, 1), getFilterStr(noisyLetterOpts.trainingNoise, 1) );

    trainNoise_str = '';
    if differentTrainTestNoise
        
        [trainingNoise_str, trainingNoise_str_nice] = getFilterStr(noisyLetterOpts.trainingNoise, 1);
        trainNoise_str = ['_tr' trainingNoise_str];
        
        if makeNiceStr && any(strcmpi(niceStrFields, 'trainingNoise'))
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, sprintf('Tr: %s', trainingNoise_str_nice));
        end
    end
    
    
    textureStats_str = '';
    if isfield(noisyLetterOpts, 'doTextureStatistics') && noisyLetterOpts.doTextureStatistics
        textureStats_str = getTextureStatsStr(noisyLetterOpts);
        if makeNiceStr && any(strcmpi(niceStrFields, 'textureParams'))
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, sprintf('Texture: %s', strrep(textureStats_str(2:end), '_', '-') ));
        end
    end

    overFeat_str = '';
    if isfield(noisyLetterOpts, 'doOverFeat') && noisyLetterOpts.doOverFeat
        overFeat_str = getOverFeatStr(noisyLetterOpts);        
    end
                              
    if ~any([differentTrainTestNoise differentTrainTestFonts differentTrainTestWiggle, ...
                differentTrainTestUncertainty differentTrainTestImageSize])
        noisyLetterOpts.retrainFromLayer = '';
    end
    
    retrainFromLayer_str = '';
    if isfield(noisyLetterOpts, 'retrainFromLayer') && ~isempty(noisyLetterOpts.retrainFromLayer)
        retrain_str = networkLayerStrAbbrev(noisyLetterOpts.retrainFromLayer);
        retrainFromLayer_str = ['_rt' retrain_str];
        if makeNiceStr && any(strcmpi(niceStrFields, 'retrainFromLayer'))
            retrainFromLayer_str_nice = sprintf('Retrained from %s', retrain_str);
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, retrainFromLayer_str_nice);
        end
    end
    
    nPositions = 1;
    if isfield(noisyLetterOpts, 'oris')
        nPositions = length(noisyLetterOpts.oris) * length(noisyLetterOpts.xs) * length(noisyLetterOpts.ys);
    end
    
    indiv_pos_str = '';
    if isfield(noisyLetterOpts, 'trainOnIndividualPositions') && noisyLetterOpts.trainOnIndividualPositions 
        
        if (nPositions > 1)
            indiv_pos_str = '_trIP';
    
            if isfield(noisyLetterOpts, 'retrainOnCombinedPositions') && noisyLetterOpts.retrainOnCombinedPositions 
                indiv_pos_str = [indiv_pos_str '_rtCP'];
            end
        end
        
        if makeNiceStr && any(strcmpi(niceStrFields, 'IndivPos'))
            indiv_pos_str = '(Indiv. Positions). ';
            noisyOpt_str_nice = [noisyOpt_str_nice indiv_pos_str];
        end

        
    end
       
    
    crowdedOpts_str = '';
    if strcmp(noisyLetterOpts.expName, 'Crowding')
       [crowdedOpts_str, crowdedOpts_str_nice] = getCrowdedLetterOptsStr(noisyLetterOpts, niceStrFields);
        
         if makeNiceStr
             noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, crowdedOpts_str_nice);
         end
        
    end
    

    %%
    
    nFontShapes = 1;
    if isfield(noisyLetterOpts, 'fontName')
        %%
        fontName = noisyLetterOpts.fontName;
        if isfield(noisyLetterOpts, 'fullFontSet') && ~isequal(noisyLetterOpts.fullFontSet, 'same')
            fontName = noisyLetterOpts.fullFontSet;
        end

        isSnakeLetter = isstruct(noisyLetterOpts.fontName) && isfield(noisyLetterOpts.fontName, 'fonts') && all(strcmp(noisyLetterOpts.fontName.fonts, 'Snakes'));
        if isSnakeLetter && isfield(noisyLetterOpts, 'fullWiggleSet') && ~isequal(noisyLetterOpts.fullWiggleSet, 'same')
            fontName.wiggles = noisyLetterOpts.fullWiggleSet;
        end
        
        nFontShapes = get_nFontShapes(fontName);
    end   
    
    
    
    classifierForEachFont_str = '';
    if isfield(noisyLetterOpts, 'classifierForEachFont') && isequal(noisyLetterOpts.classifierForEachFont, true) && (nFontShapes > 1)
        classifierForEachFont_str = '_clsFnt';
        if makeNiceStr && any(strcmpi(niceStrFields, 'classifierForEachFont'))
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, '(ClsFnt)');
        end
    end   
    

    loadOpts_str = '';
    if isfield(noisyLetterOpts, 'loadOpts')
        loadOpts_str = getLoadOptsStr(noisyLetterOpts.loadOpts);
    end

    %%
    noisyOpt_str = [oxy_str imageSizeStr blur_str ...     used to be : oxy_str [>nLetters_str targetPosition_str<] imageSizeStr blur_str 
        trainingOriXY_str,  trainingImageSizeStr trainingFonts_str  trainingWiggle_str ...
        noiseFilter_str,  trainNoise_str, ...
        textureStats_str, overFeat_str, ...
        retrainFromLayer_str indiv_pos_str   crowdedOpts_str  classifierForEachFont_str, loadOpts_str];
    


end


function n = get_nFontShapes(fonts)
    % we consider uppercase and lowercase versions of fonts to be different
    % 'shapes', but bold and italic versions to be the same 'shape'. This
    % function counts the number of unique font 'shapes' in a list of
    % fonts.
    attribsToIgnore = {'bold_tf', 'italic_tf'};
    fontList = getFontList(fonts);
    for fi = 1:length(fontList)
        [rawFontName{fi}, attribs(fi)] = getRawFontName(fontList{fi}); %#ok<AGROW>
        for ai = 1:length(attribsToIgnore)
            attribs(fi).(attribsToIgnore{ai}) = 0; %#ok<AGROW>
        end
        fontListU{fi} = getFullFontName(rawFontName{fi}, attribs(fi)); %#ok<AGROW> % ignore bold/italic
    end
    uFonts = unique(fontListU);
    n = length(uFonts);
end






%{
  trainingFonts_str = '';
    if isfield(noisyLetterOpts, 'trainingFonts') && ~isequal(noisyLetterOpts.trainingFonts, 'same') && ~isequal(noisyLetterOpts.trainingFonts, noisyLetterOpts.fontName) 
        
        [trFonts_abbrev, trFonts_abbrev_med] = abbrevFontStyleNames(noisyLetterOpts.trainingFonts);
        
        if iscellstr(noisyLetterOpts.trainingFonts) && ischar(noisyLetterOpts.fontName) && any(strcmp(noisyLetterOpts.trainingFonts, noisyLetterOpts.fontName))
            noisyLetterOpts.fontName = noisyLetterOpts.trainingFonts;  %ie. the test font was one of the training fonts (so don't add trfX tag to filename)
        else        
            trainingFonts_str = ['_trf' trFonts_abbrev];
        end        
        
        if makeNiceStr && any(strcmpi(niceStrFields, 'trainingFonts'))
            trainingFonts_str_nice = sprintf('Trained on %s', trFonts_abbrev_med);
            noisyOpt_str_nice = appendToStr(noisyOpt_str_nice, trainingFonts_str_nice);
        end
    end
    
    
        differentTrainTestFonts = isfield(noisyLetterOpts, 'trainingFonts') && ~(ischar(noisyLetterOpts.trainingFonts) && strcmp(noisyLetterOpts.trainingFonts, 'same')) && ...
                              ~strcmp(abbrevFontStyleNames(noisyLetterOpts.trainingFonts), abbrevFontStyleNames(noisyLetterOpts.fontName) );
%}