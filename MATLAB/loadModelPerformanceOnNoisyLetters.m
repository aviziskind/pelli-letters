function [pct_correct_vs_snr_total, pct_correct_vs_snr_eachLetter] = loadModelPerformanceOnNoisyLetters(stimType, expSubtitle, allSNRs_test, opt, letterOpts)

    persistent modelPerformance nSaved

    cache_file = [lettersDataPath 'Results' fsep 'ModelPerformance.mat'];
    
    redoFile = 0;
    redoIndivResults = 0;
    allowSubsetOfSNRs_default = true;
%     redoIfBefore = 735656.077176; % sprintf('%.6f', now);
    checkDateOfFile = 1 && 1;
    if isempty(modelPerformance) 
        if ~exist(cache_file, 'file') || redoFile
            modelPerformance = struct;
        else
            modelPerformance = load(cache_file);
        end
        nSaved = 0;
    end
    nSaveSpacing = 500;
    
    
    if strcmp(stimType, 'save') && ~isempty(modelPerformance);
        save(cache_file, '-struct', 'modelPerformance', '-v6');
        nSaved = 0;
        return;
    end

    expName = letterOpts.expName;
        
    if ~isfield(opt, 'allowSubsetOfSNRs')
        opt.allowSubsetOfSNRs = allowSubsetOfSNRs_default;
    end
    
    mainFolder = [lettersDataPath 'Results' fsep expName fsep];
    file_name = [stimType '_' expSubtitle '.mat'];
    preferredSubdir = [stimType '/'];
    
    [haveFile, fileName_full] = fileExistsInSisterSubdirs(mainFolder, preferredSubdir, file_name);
%%
    fld_name = shortenFieldName(file_name);
    fieldDataOld = false;
    
    file_in_dir = dir(fileName_full);
%     haveFile = ~isempty(file_in_dir);
    if ~haveFile 
        if opt.skipIfDontHaveModelFile
            pct_correct_vs_snr_total = nan;
            pct_correct_vs_snr_eachLetter = nan;
            
            if opt.warnIfDontHaveModelFile
                fprintf('[Absent: %s]\n', file_name);
            end
            
            return;
        else
            error('Results file %s not present', file_name)
        end
    end    
    
    fileDate = [];
    if checkDateOfFile && haveFile
        fileDate = file_in_dir.datenum;
        if isfield(modelPerformance, fld_name) 
            fieldDataOld = fileDate > modelPerformance.(fld_name).fileDate;
        end        
    end
        
    if ~isfield(modelPerformance, fld_name) || fieldDataOld || redoIndivResults
        fprintf('Loading model performance for %s\n', file_name);

        S = load(fileName_full);
        S.fileDate = fileDate;
        S.file_name = file_name;
        if ~isfield(S, 'pct_correct_vs_snr_total')
            fprintf('old file, deleting\n');
            error('!')
%             delete([folder file_name]);
%             pct_correct_vs_snr_total = nan;
%             pct_correct_vs_snr_eachLetter = nan;
%             return;
        end
        
        modelPerformance.(fld_name) = S;
        nSaved = nSaved + 1;
        
        if nSaved >= nSaveSpacing
            %%
            save(cache_file, '-struct', 'modelPerformance', '-v6');
            nSaved = 0;
        end
    end
    
    s = modelPerformance.(fld_name);
    assert(strcmp(s.file_name, file_name));
    
    idx_snrs_use = 1 : length(s.allSNRs);
    if ~isequal(allSNRs_test(:), s.allSNRs(:)) 
        if opt.allowSubsetOfSNRs
            if isempty(setdiff(allSNRs_test, s.allSNRs(:)))
                idx_snrs_use = binarySearch(s.allSNRs(:), allSNRs_test);
            else
                error('Don''t have data for SNRs = %s', toOrderedList( setdiff(allSNRs_test, s.allSNRs(:)), [], ', ', 10));
            end
        else
            error('Requested set of SNRs :\n  %s   is not the same as the saved list of SNRs :\n  %s', toOrderedList(allSNRs_test,[],', ',10), toOrderedList(s.allSNRs,[],', ',10))
        end
    end
    
    pct_correct_vs_snr_eachLetter = nan;

    targetOnly_str = '';
    if isfield(opt, 'usePctCorrectTargetOnly') && opt.usePctCorrectTargetOnly && isfield(s, 'pct_correct_vs_snr_total_target')
        targetOnly_str = '_target';
    end
    
    idx_font = [];

    if isfield(letterOpts, 'fullFontSet')  ...
            && ~(isequal(letterOpts.fullFontSet, 'same') || isequal(letterOpts.fullFontSet, letterOpts.fontName) )
        allFonts_C = strsplit( char( s.allFontNames' ), ',');
        idx_font = find(strcmp(allFonts_C,  letterOpts.fontName),1);

    elseif isSnakeLetterOpt(letterOpts) && isfield(letterOpts, 'fullWiggleSet') ...
            && ~(isequal(letterOpts.fullWiggleSet, 'same') || isequal(letterOpts.fullWiggleSet, letterOpts.fontName.wiggles) )
        wiggleList = getWiggleList(letterOpts.fullWiggleSet);
        idx_font = find(  cellfun(@(w) isequal(w, letterOpts.fontName.wiggles), wiggleList) );

    end
    
    trainErr_str = '';
    if isfield(opt, 'useTrainingError') && isequal(opt.useTrainingError, 1)
        trainErr_str = '_train';
    end
    %%
    pct_correctTotal_field = ['pct_correct_vs_snr_total' targetOnly_str trainErr_str];
%     pct_correctEachLetter_field = ['pct_correct_vs_snr_eachLetter' targetOnly_str trainErr_str];
    pct_correctEachLetter_field = ['pct_correct_vs_snr_eachLetter' targetOnly_str];
    
        
    pct_correct_vs_snr_total  = s.(pct_correctTotal_field);
    if isfield(s, pct_correctEachLetter_field)
        pct_correct_vs_snr_eachLetter = s.(pct_correctEachLetter_field);
        pct_correct_vs_snr_eachLetter = pct_correct_vs_snr_eachLetter(:,idx_snrs_use,:);
    end
    
    if ~isempty(idx_font)
        pct_correct_vs_snr_total = pct_correct_vs_snr_total(:,idx_font);
        pct_correct_vs_snr_eachLetter = pct_correct_vs_snr_eachLetter(:,:,idx_font);
    end
    
    pct_correct_vs_snr_total = pct_correct_vs_snr_total(idx_snrs_use);
    
    %%
    3;
    %{
    if isfield(letterOpts, 'trainingFonts') && ~isequal(letterOpts.trainingFonts, letterOpts.fontName)
        allFonts_C = strsplit( char( s.allFontNames' ), ',');
        idx_font = find(strcmp(allFonts_C,  letterOpts.fontName),1);
        
        pct_correct_vs_snr_total      = s.pct_correct_vs_snr_total(idx_snrs_use,idx_font);
        pct_correct_vs_snr_eachLetter = s.pct_correct_vs_snr_eachLetter(:,idx_snrs_use, idx_font);
        
    elseif isfield(opt, 'usePctCorrectTargetOnly') && opt.usePctCorrectTargetOnly && isfield(s, 'pct_correct_vs_snr_total_target')
        pct_correct_vs_snr_total      = s.pct_correct_vs_snr_total_target;
        
    elseif isfield(opt, 'useTrainingError') && isequal(opt.useTrainingError, 1)
        pct_correct_vs_snr_total      = s.pct_correct_vs_snr_total_train;
        
    else
        pct_correct_vs_snr_total      = s.pct_correct_vs_snr_total;
        
    end
    
%     pct_correct_vs_snr_total = pct_correct_vs_snr_total( idx_snrs_use );
    
    if isfield(s, 'pct_correct_vs_snr_eachLetter') && ~exist('pct_correct_vs_snr_eachLetter', 'var')
        pct_correct_vs_snr_eachLetter = s.pct_correct_vs_snr_eachLetter(:, idx_snrs_use);
    end
    %}
    
    %%
    
    
    
    
end



%{

if 0 
        modelPerformance_orig = modelPerformance;
        %%
        allfn = fieldnames(modelPerformance);
        %%
        for i = 1:length(allfn)
            old_fn = allfn{i};
            new_fn = strrep(old_fn, '_nopool', '_0p');
            if ~strcmp(old_fn, new_fn) && isfield(modelPerformance, old_fn)
                modelPerformance.(new_fn) = modelPerformance.(old_fn);
                modelPerformance = rmfield(modelPerformance, old_fn);
            end

        end
    end

%}


%{

%%
s = dir([folder '*.mat']);
%%
n = length(s);
progressBar('init-', n, 30)
for i = 1:n
    name_i = s(i).name;
    S = load([folder name_i]);
    if ~isfield(S, 'pct_correct_vs_snr_total')
        fprintf('old file, deleting \n')
        delete([folder name_i]);
    end
    progressBar(i);
end

%}