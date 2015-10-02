function [pct_correct_1_letter, pct_correct_2_letters_v_nDist_spc_tdr, allNDistractors, allSpacings, allTDRs] = loadModelPerformanceOnCrowdedLetters(expTitle, expSubtitle, opt)

    persistent modelPerformance nSaved

    cache_file = [datasetsPath 'CrowdedLetters' fsep 'ModelPerformance.mat'];
    
    redo = 0;
    checkDateOfFile = 1 && 1;
    if isempty(modelPerformance) 
        if ~exist(cache_file, 'file') || redo
            modelPerformance = struct;
        else
            modelPerformance = load(cache_file);
        end
        
    end

    nSaveSpacing = 100;
    
    if strcmp(expTitle, 'save') && ~isempty(modelPerformance);
        save(cache_file, '-struct', 'modelPerformance', '-v6');
        nSaved = 0;
        return;
    end

    
    folder = [torchPath 'Results' fsep expTitle fsep];
    file_name = [expTitle '_' expSubtitle '.mat'];

    fld_name = strrep(file_name, '-', '_');
    fld_name = strrep(fld_name, '.mat', '');
    fld_name = strrep(fld_name, '[', '_');
    fld_name = strrep(fld_name, ']', '_');
    fld_name = strrep(fld_name, '.', 'p');
    
    fld_name = strrep(fld_name, 'TrainingWithNoise', 'TWN');
    fld_name = strrep(fld_name, 'Complexity', 'C');    
    fld_name = strrep(fld_name, 'CrowdedLetters', 'CL');
    
    if length(fld_name) > 63
        error('name too long')
    end
    fieldDataOld = false;
    
    s = dir([folder file_name]);
    haveFile = ~isempty(s);
    if ~haveFile 
        if opt.skipIfDontHaveFile
            pct_correct_1_letter = nan;
            pct_correct_2_letters_v_nDist_spc_tdr = nan;
            allNDistractors = nan;
            allSpacings = nan;
            allTDRs = nan;
            
            return;
        else
            error('Results file %s not present', file_name)
        end
    end    
    
    fileDate = [];
    if checkDateOfFile && haveFile
        fileDate = s.datenum;
        if isfield(modelPerformance, fld_name) 
            fieldDataOld = fileDate > modelPerformance.(fld_name).fileDate;
        end        
    end
        
    if ~isfield(modelPerformance, fld_name) || fieldDataOld
        fprintf('Loading model performance for %s\n', file_name);

        S = load([folder file_name]);
        S.fileDate = fileDate;
%         ss = struct('pct_correct_1letter', S.pct_correct_1letter, ...
%                     'pct_correct_2letter_vs_spacing_tdr', S.pct_correct_2letter_vs_spacing_tdr', ...
%                     'fileDate', fileDate);
        modelPerformance.(fld_name) = S;
        nSaved = nSaved + 1;
        
        if nSaved >= nSaveSpacing
            %%
            save(cache_file, '-struct', 'modelPerformance', '-v6');
            nSaved = 0;
        end
    end
        
    ss = modelPerformance.(fld_name);
    pct_correct_1_letter = ss.pct_correct_1letter;
    if isfield(ss, 'pct_correct_2letter_vs_spacing_tdr') 
        pct_correct_2_letters_v_nDist_spc_tdr = reshape(ss.pct_correct_2letter_vs_spacing_tdr, [1, length(ss.allDistractorSpacings), length(ss.allTDRs)]);
        allNDistractors = 1;
    elseif isfield(ss, 'pct_correct_2letter_vs_nDist_spacing_tdr') 
        pct_correct_2_letters_v_nDist_spc_tdr = ss.pct_correct_2letter_vs_nDist_spacing_tdr;
        pct_correct_2_letters_v_nDist_spc_tdr = permute(pct_correct_2_letters_v_nDist_spc_tdr, [3 1 2]);
        allNDistractors = ss.allNDistractors;
    end
    allSpacings = ss.allDistractorSpacings;
    allTDRs = ss.allTDRs;
    
%     pct_correct_2_letters_v_nDist_spc_tdr = permute(pct_correct_2_letters_v_nDist_spc_tdr, [2 1]);
    
    %%
    assert(size(pct_correct_2_letters_v_nDist_spc_tdr, 1) == length(allNDistractors))
    assert(size(pct_correct_2_letters_v_nDist_spc_tdr, 2) == length(allSpacings))
    assert(size(pct_correct_2_letters_v_nDist_spc_tdr, 3) == length(allTDRs))
    
    

end
