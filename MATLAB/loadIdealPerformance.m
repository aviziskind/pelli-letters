function [idealP_total, idealP_eachLetter, logE] = loadIdealPerformance(fontName, snr, letterOpts, opt)

    persistent idealPerformance nSaved
    cache_file = [lettersDataPath 'IdealObserver' fsep 'IdealObserver.mat'];
        
    nSaveSpacing = 100;    
    
    redoAll = 0;
    redoIndiv = 0;
    checkDateOfFile = 1;
    if isempty(idealPerformance) 
        if ~exist(cache_file, 'file') || redoAll
            idealPerformance = struct;
        else
            idealPerformance = load(cache_file);
        end
        
    end


    if isequal(fontName, 'save') && ~isempty(idealPerformance)
        save(cache_file, '-struct', 'idealPerformance', '-v6');
        nSaved = 0;
        return
    end
    
    stimType = letterOpts.stimType;
    expName = letterOpts.expName;
    
    
    % 1. check for a template matcher results file.
    [ideal_file_name, ideal_folder] = getIdealObserverFileName(fontName, snr, letterOpts);
    ideal_file_name_full = [ideal_folder ideal_file_name];    
    haveIdealFile = exist(ideal_file_name_full, 'file');

    % find data file.
    fld_name = shortenFieldName(ideal_file_name);    
    haveInStruct = isfield(idealPerformance, fld_name);
    
%     folder = [datasetsPath fldr_name filesep fontName filesep];

    fieldDataOld = false;
    fileDate = [];
%     file_name_sample = strrep(file_name, '.mat', '_sample.mat');
%     if ~exist([folder file_name], 'file') && exist([folder file_name_sample], 'file')
%         file_name = file_name_sample;
%     end
    
    if ~haveIdealFile
        if opt.skipIfDontHaveIdealFile
            [idealP_total, idealP_eachLetter, logE] = deal(nan);
            return
        else
            error('File does not exist: %s\n ', ideal_file_name_full)
        end
    end
    
    % check if there is a newer, updated version of the data file.
    if haveIdealFile && checkDateOfFile
        fileDate = filedate(ideal_file_name_full);
        
        if isfield(idealPerformance, fld_name) 
            fieldDataOld = fileDate > idealPerformance.(fld_name).fileDate;
        end
        
    end
       
    
    
    % (re)load from datafile if check if not in cache, or if newer version available.
    
    if ~haveInStruct || fieldDataOld || redoIndiv
        %%
        if haveIdealFile
            fprintf('Loading ideal performance file %s\n', ideal_file_name)
            S = load(ideal_file_name_full);
        else
            fprintf('Calculating ideal performance for %s\n', ideal_file_name);
            S = testIdealObserver(fontName, snr, letterOpts, 1);
        end
       
%         struct2fieldarray(S)
        
%         S = load([folder file_name]);
        switch expName
            case {'Complexity', 'ChannelTuning', 'Grouping'},
                
                switch stimType

                    case 'NoisyLetters',
                        %%
        %                 logE = S.logEOverN + S.logN;
                        ss = struct('propLetterCorrect', S.propCorrectLetter, 'propEachLetterCorrect', S.propCorrectEachLetter, ...'logE', logE, ...
                            'fileDate', fileDate);
                        if isfield(S, 'propLetterCorrect_ideal_combined')
                            ss.propLetterCorrect_combined     = S.propLetterCorrect_ideal_combined;
                            ss.propEachLetterCorrect_combined = S.propEachLetterCorrect_ideal_combined;
                        end
                        if isfield(S, 'propLetterCorrect_ideal_mult')
                            ss.propLetterCorrect_mult = S.propLetterCorrect_ideal_mult;
                            ss.propEachLetterCorrect_mult = S.propEachLetterCorrect_ideal_mult;
                        end
                        if isfield(S, 'propLetterCorrect_eachFont') % && isfield(S, 'fontNames') 
                            ss.fontNames = S.fontNames;
                            propLetterCorrect_eachFont = S.propLetterCorrect_eachFont;
                            propEachLetterCorrect_eachFont = S.propEachLetterCorrect_eachFont;
                            if iscell(propLetterCorrect_eachFont) && iscell(propLetterCorrect_eachFont{1})
                                propLetterCorrect_eachFont = propLetterCorrect_eachFont{1};
                                propEachLetterCorrect_eachFont = propEachLetterCorrect_eachFont{1};
                            end
                            if iscell(propLetterCorrect_eachFont)
                                propLetterCorrect_eachFont = cat(1, propLetterCorrect_eachFont{:});
                                propEachLetterCorrect_eachFont = cat(1, propEachLetterCorrect_eachFont{:});
                            end

                            ss.propLetterCorrect_eachFont     = propLetterCorrect_eachFont;
                            ss.propEachLetterCorrect_eachFont = propEachLetterCorrect_eachFont;
                        end

                    case 'NoisyLettersTextureStats',
        %                 logE = S.logEOverN + S.logN;
                        ss = struct('propLetterCorrect', S.propLetterCorrect_ideal_image, 'propEachLetterCorrect', nan, ... 'logE', logE, ...
                            'fileDate', fileDate);    
                end
            
            case 'CrowdedLetters',
                if ~isfield(S, 'propLetterCorrect_ideal_target')
                    S.propLetterCorrect_ideal_target = nan;
                    S.propEachLetterCorrect_ideal_target = nan;
                end
                ss = struct('propLetterCorrect', S.propLetterCorrect_ideal, 'propEachLetterCorrect', S.propEachLetterCorrect_ideal, ...
                            'propLetterCorrect_target', S.propLetterCorrect_ideal_target, 'propEachLetterCorrect_target', S.propEachLetterCorrect_ideal_target, ...
                    'fileDate', fileDate, 'logE', nan);
        end
            
        idealPerformance.(fld_name) = ss;
        nSaved = nSaved + 1;
        if nSaved >= nSaveSpacing
            save(cache_file, '-struct', 'idealPerformance', '-v6');
            nSaved = 0;
        end
    end
        %%
    ss = idealPerformance.(fld_name);
    if isfield(ss, 'propLetterCorrect_target') && opt.usePctCorrectTargetOnly
        idealP_total = ss.propLetterCorrect_target * 100;
        idealP_eachLetter = ss.propEachLetterCorrect_target * 100;

    elseif isfield(ss, 'propLetterCorrect_mult') && opt.ideal_multiplyTemplates
        idealP_total = ss.propLetterCorrect_mult * 100;
        idealP_eachLetter = ss.propEachLetterCorrect_mult * 100;
        
    elseif isfield(ss, 'propLetterCorrect_combined') && opt.ideal_useCombinedTemplates
        idealP_total = ss.propLetterCorrect_combined * 100;
        idealP_eachLetter = ss.propLetterCorrect_combined * 100;
    
    else
        if isfield(letterOpts, 'fontName') && ~strcmp( abbrevFontStyleNames(letterOpts.fontName), abbrevFontStyleNames( fontName ) )
            
%             if isfield(ss, 'propLetterCorrect_eachFont') && iscell(ss.propLetterCorrect_eachFont)
%                 ss.propLetterCorrect_eachFont = [ss.propLetterCorrect_eachFont{1}{:}];
%                 ss.propEachLetterCorrect_eachFont = cat(1, ss.propEachLetterCorrect_eachFont{1}{:});
%             end
            
            font_idx = find(strcmp(ss.fontNames, letterOpts.fontName), 1);
            if isempty(font_idx)
                error('Font %s is not one of the fonts tested in this set', letterOpts.fontName)
            end
            idealP_total = ss.propLetterCorrect_eachFont(font_idx) * 100;
            idealP_eachLetter = ss.propEachLetterCorrect_eachFont(font_idx, :) * 100;
            
        else
        
            idealP_total = ss.propLetterCorrect * 100;
            idealP_eachLetter = ss.propEachLetterCorrect * 100;
        end
    end
    
    logE = []; %ss.logE;
    3;
    
end


%{


    
    
    
    [data_file_name, data_folder] = getDataFileName(fontName, snr, letterOpts);
    
        switch letterOpts.stimType
            case 'NoisyLetters',       
                file_name = getNoisyLetterFileName(fontName, snr, letterOpts);
            case 'NoisyLettersTextureStats',  
                file_name = getNoisyLettersTextureStatsFileName(fontName, snr, letterOpts);

            case 'CrowdedLetters',     
                letterOpts.trainTargetPosition = letterOpts.testTargetPosition;
                file_name = getCrowdedLetterFileName(fontName, snr, letterOpts);
        end
        
        
%}