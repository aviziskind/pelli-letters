function [propCorrectLetter, propCorrectEachLetter, S_ideal] = testIdealObserver(fontNameSet, snr, letterOpts, structOutFlag, redoFlag)
    
     redo = exist('redoFlag', 'var') && isequal(redoFlag, 1);
     redoIfOld = true;
     redoIfBefore = 735812.656680;

     checkIfLowerSNRsGot100pct = 1;
     lockAllSNRs = true;

% %       fontNames_orig = fontNameSet;
%      if iscell(fontNames) || isstruct(fontNames)
%          fontNames_orig = fontNames;
%      end
     if ischar(fontNameSet)
         fontNameSet = {fontNameSet};
     end
     
     fontNames_list = getFontList(fontNameSet);
     fontNames_list = sort(fontNames_list);

     
     idealFileFields = {'fontNames', 'propCorrectLetter', 'propCorrectEachLetter'};

     
     classifierForEachFont = iscell(fontNameSet) && length(fontNameSet)>1  && letterOpts.classifierForEachFont ;
     if classifierForEachFont
         fontClassTable = getFontClassTable(fontNameSet);
     end
    
     [ideal_file_name, ideal_folder] = getIdealObserverFileName(fontNameSet, snr, letterOpts);
     
     ideal_file_name_full = [ideal_folder, ideal_file_name];
     if ~exist(ideal_folder, 'dir')
         status = mkdir(ideal_folder);
         if not (status == 1)
             error('Could not create folder %s\n Please create manually and try again', ideal_folder);
         end
     end
     
     
     ideal_file_name_noSNR = getIdealObserverFileName(fontNameSet, nan, letterOpts);

     
         
     nDataFiles = length(fontNames_list);
     data_file_name_full = cell(1, nDataFiles);
     data_file_name = cell(1, nDataFiles);
     haveDataFiles = zeros(1, nDataFiles);
     letterOpts_dataFiles = letterOpts;
     letterOpts_dataFiles.classifierForEachFont = false;
     letterOpts_dataFiles.trainingNoise = 'same';
     for di = 1:nDataFiles
        [data_file_name{di}, data_folder] = getDataFileName(fontNames_list{di}, snr, letterOpts_dataFiles);
        data_file_name_full{di} = [data_folder data_file_name{di}];
        haveDataFiles(di) = exist(data_file_name_full{di}, 'file');
     end
     if nDataFiles > 1
         fprintf('\n');
     end
     
     haveIdealFile = exist(ideal_file_name_full, 'file');
     %%
     fileIsOutOfDate = fileOlderThan(ideal_file_name_full, redoIfBefore);
     if redoIfOld  && haveIdealFile 
        for di = 1:nDataFiles
            fileIsOutOfDate = fileIsOutOfDate || fileOlderThan(ideal_file_name_full, data_file_name_full{di}) ...
                                              || fileOlderThan(data_file_name_full{di}, redoIfBefore);
        end
     end
     %%
      if nDataFiles > 1
         idealSubFiles      = cellfun(@(fname) strrep(ideal_file_name, '.mat', ['_' fname '.mat']), fontNames_list, 'un', 0);
     else
         idealSubFiles      = {ideal_file_name};  % just the one file
     end
     idealSubFiles_full = cellfun(@(fname) [ideal_folder fname], idealSubFiles, 'un', 0);
         %%
     for sub_idx = 1:nDataFiles

         idealSubFile_full = idealSubFiles_full{sub_idx};
         haveIdealSubFile  = exist(idealSubFile_full, 'file');
         subFilesOutOfDate(sub_idx) = ~haveIdealSubFile || fileOlderThan(idealSubFile_full, redoIfBefore) ...
                                                || fileOlderThan(ideal_file_name_full, data_file_name_full{sub_idx}); %#ok<AGROW>
         
     end
     fileIsOutOfDate = fileIsOutOfDate || any(subFilesOutOfDate);
     
     
     [noisySets, propCorrectLetter_C, propCorrectEachLetter_C] = deal( cell(1, nDataFiles) );
          
     if ~haveIdealFile || fileIsOutOfDate || redo
         if length(fontNames_list) > 1
             fprintf('\n============');
         end
         fprintf('\n[%s] ', strrep(ideal_file_name, '_ideal.mat', ''))

         % if is a multi-font test, first check to see if have all the
         % sub-files from each font:
         
         if checkIfLowerSNRsGot100pct && length(fontNameSet)==1
             lowest_snr = -1;
             all_lower_snrs = snr-0.5 : -.5 : lowest_snr;
             for snr_chk = all_lower_snrs
                 %%
                 [ideal_file_name_lower, ideal_folder_lower] = getIdealObserverFileName(fontNameSet, snr_chk, letterOpts);
                 if exist([ideal_folder_lower ideal_file_name_lower], 'file')
                    s_chk = tryLoad([ideal_folder_lower ideal_file_name_lower], [], idealFileFields);
                                        
                    if s_chk.propCorrectLetter == 1
                        fprintf('[Ideal for snr = %.1f had 100%% correct --> assuming ideal is 100%% correct also for snr = %.1f]\n', snr_chk, snr);
                        save([ideal_folder, ideal_file_name], '-struct', 's_chk');
                        return
                    else
                        fprintf('[Ideal for snr = %.1f was %.1f%%]\n', snr_chk, s_chk.propCorrectLetter*100);
                        break;
                    end
                    
                 end

             end


         end
         
         
         
         if length(fontNames_list) > 1
             fprintf('\n');
         end
%%         
         combinedSignal = [];
         if nDataFiles > 1
             idealSubFiles      = cellfun(@(fname) strrep(ideal_file_name, '.mat', ['_' fname '.mat']), fontNames_list, 'un', 0);
         else
             idealSubFiles      = {ideal_file_name};  % just the one file
         end
         idealSubFiles_full = cellfun(@(fname) [ideal_folder fname], idealSubFiles, 'un', 0);
             %%
         for sub_idx = 1:nDataFiles
             
             idealSubFile      = idealSubFiles{sub_idx};
             idealSubFile_full = idealSubFiles_full{sub_idx};
             haveIdealSubFile  = exist(idealSubFile_full, 'file');
             subFileIsOutOfDate = ~haveIdealSubFile || fileOlderThan(idealSubFile_full, redoIfBefore) ...
                                                    || fileOlderThan(ideal_file_name_full, data_file_name_full{sub_idx});

             if ~haveIdealSubFile || subFileIsOutOfDate || redo
             
                 if lockAllSNRs
                     lock_name = ideal_file_name_noSNR;
%                      lock_name = ['calcIdeal__' ideal_file_name_noSNR];
                 else
                     lock_name = idealSubFile;
                 end
                 
                 [gotLock, otherID] = lock_createLock(lock_name);
                 if ~gotLock
                     fprintf('\n        [Another matlab session (%s) is doing %s...]\n', otherID, lock_name);
                     continue
                 end
                 
                 if isempty(combinedSignal)   % calculate combined signal (if don't have already)
                      
                     for di = 1:nDataFiles
                         class_offset = 0;
                         if classifierForEachFont
                             fontNameU = getRawFontName(fontNames_list{di}, 'keepU');
                             class_offset = fontClassTable.(fontNameU);
                         end
                         
                         
                        fprintf('    => Loading %s ... ', data_file_name{di})
                        S_data = load(data_file_name_full{di});
                        

                        if ~isempty(S_data.signalMatrix)
                            signal_data = S_data.signalMatrix;
                        else
                            signal_data = S_data.signalData;
                        end

                        if isstruct(signal_data)
                            signals = generateLetterSignals(signal_data.allLetters_rotated, ...
                                signal_data.xs, signal_data.ys, signal_data.orientations, signal_data.letter_params);
                        else
                            signals = reconstructSignal(signal_data);
                            fprintf('[reconstructed signals]');
                        end
                        if classifierForEachFont
                            fprintf('[class offset for %s is = %d]', fontNameU, class_offset);
                        end

                        noisySets{di}.signal = signals;
                        noisySets{di}.inputMatrix = S_data.inputMatrix;
                        noisySets{di}.labels = S_data.labels + class_offset;
                        if isfield(S_data, 'ori_idxs')
                            noisySets{di}.targetOri_idx = S_data.ori_idxs;
                        end
                        if isfield(S_data, 'x_idxs')
                            noisySets{di}.targetX_idx = S_data.x_idxs;
                        end
                        if isfield(S_data, 'y_idxs')
                            noisySets{di}.targetY_idx = S_data.y_idxs;
                        end
                        fprintf('\n')
                     end

                     allNoisySets = [noisySets{:}];
                     if classifierForEachFont
                         combinedSignal = cat(1, allNoisySets.signal); % assemble signals sequentially next to each other: each font is a separate signal.
                         assert(size(combinedSignal, 1) == fontClassTable.nClassesTot);
                     else
                         assert(size(allNoisySets(1).signal, 5) == 1);
                         combinedSignal = cat(5, allNoisySets.signal);  % make font index the last index (dims = let,ori,x,y,[*font*])
                     end
                 end
            
             
             
                 %%
                 canUseGPU = false;
                 tryGPU = false;
                 if tryGPU
                     mem_needed_MB = (numel(combinedSignal) * numel(combinedSignal(1).image) * 4 * 2) / 1024^2;
                     gpu_dev = gpuDevice(1);
                     total_mem_MB = gpu_dev.TotalMemory / 1024^2;
                     canUseGPU = total_mem_MB > mem_needed_MB;
                 end
%%
         
        
                if nDataFiles > 1
                    noisySets{sub_idx}.signal = combinedSignal;
                    fprintf('       (%d/%d:%s)', sub_idx, nDataFiles, fontNames_list{sub_idx})
                end

                useParPool = false; % default

                tryParPool = false;
                tryParPool = tryParPool && ~onLaptop; % strncmp(getHostname, 'XPS', 3); % && false;

                if tryParPool
                    useParPool = lock_createLock('ParPool');
                end

                if useParPool
                    gcp;
    %                 parpool;
                    parMethod = 'parpool';
                elseif canUseGPU
                    parMethod = 'GPU';
                else
                    parMethod = [];
                end
    %             parMethod = 'GPU';
    %             parMethod = 'parpool';
    %             parMethod = 'parpool';
    %             parMethod = [];
                calcMethod = 'innerProduct';
    %               calcMethod = [];
    
                opts.calcMethod = calcMethod;
                opts.parMethod = parMethod;
                
                if isfield(letterOpts, 'trainingNoise') && ~isempty(letterOpts.trainingNoise)
                    trainingNoise = letterOpts.trainingNoise;
                    if ischar(trainingNoise) && strcmp(trainingNoise, 'same')
                        trainingNoise = letterOpts.noiseFilter;
                    end
                    opts.trainingNoise = trainingNoise;
                    noisySets{sub_idx}.fontName = letterOpts.fontName;
                    noisySets{sub_idx}.sizeStyle = letterOpts.sizeStyle;
                end


    %             [propCorrectLetter_C{di}, propCorrectEachLetter_C{di}] = calcIdealPerformanceForNoisySet(noisySets{di}, opts);
                [propCorrectLetter_C{sub_idx}, propCorrectEachLetter_C{sub_idx}] = calcIdealPerformanceForNoisySet(noisySets{sub_idx}, opts);

                
                S_ideal = struct('fontNames',  fontNames_list{sub_idx}, ...
                                 'propCorrectLetter', propCorrectLetter_C{sub_idx}, ...
                                 'propCorrectEachLetter', propCorrectEachLetter_C{sub_idx}, ...
                                 'calcMethod', calcMethod, 'parMethod', parMethod); 
                     
               
                save(idealSubFile_full, '-struct', 'S_ideal')
                
                
                lock_removeLock(lock_name);
             else
                
                 fprintf('   Already have (sub)file %s\n', idealSubFile);
             end
        end

        
         % now that have all the sub-files, create the main file (check
         % first to see if still don't have it, and if all subfiles have been created)
         
         if nDataFiles > 1
             haveIdealFile = exist(ideal_file_name_full, 'file');
             fileIsOutOfDate = fileOlderThan(ideal_file_name_full, redoIfBefore);

             haveIdealSubFiles  = cellfun(@(fn) exist(fn, 'file'), idealSubFiles_full);
             idealSubFilesOutOfDate = cellfun(@(fn) fileOlderThan(fn, redoIfBefore), idealSubFiles_full);
             
             if (~haveIdealFile || fileIsOutOfDate || redo) && all(haveIdealSubFiles) && ~any(idealSubFilesOutOfDate)

                 [gotLock, otherID] = lock_createLock(ideal_file_name);
                 if ~gotLock
                     fprintf('    [Another matlab session (%s) is doing %s...]\n', otherID, ideal_file_name);
                     return
                 end

                 fprintf('   Combining the results from all the subfiles ==> %s : ', ideal_file_name)
                 for fi = 1:nDataFiles
                     Si = tryLoad(idealSubFiles_full{fi}, [], idealFileFields);
                     [propCorrectLetter_C{fi}, propCorrectEachLetter_C{fi}] = deal(Si.propCorrectLetter, Si.propCorrectEachLetter);
                 end
                 propCorrectLetter_eachFont = [propCorrectLetter_C{:}];
                 propCorrectEachLetter_eachFont = cat(1, propCorrectEachLetter_C{:});

                propCorrectLetter_av = mean(propCorrectLetter_eachFont);
                propCorrectEachLetter_av = mean(propCorrectEachLetter_eachFont, 1);

                %%     
                S_ideal = struct('fontNames', {fontNames_list}, ...
                                 'propCorrectLetter', propCorrectLetter_av, ...
                                 'propCorrectEachLetter', propCorrectEachLetter_av); 
                if nDataFiles > 1
                    S_ideal.propLetterCorrect_eachFont = propCorrectLetter_eachFont;
                    S_ideal.propEachLetterCorrect_eachFont = propCorrectEachLetter_eachFont; 
                end

                fprintf('done: %.2f%%\n', propCorrectLetter_av*100);

            %%
                save(ideal_file_name_full, '-struct', 'S_ideal');

                lock_removeLock(ideal_file_name);
             end 
         end
     else
        
        
         S_ideal = tryLoad(ideal_file_name_full, [], idealFileFields);
         [propCorrectLetter, propCorrectEachLetter] = deal(S_ideal.propCorrectLetter, S_ideal.propCorrectEachLetter);
         
         fprintf('[%s : Already computed : %.2f%%]\n', ideal_file_name, propCorrectLetter*100);
     end
     
     
     if exist('structOutFlag', 'var') && ~isempty(structOutFlag)
         propCorrectLetter = S_ideal;
     end
     

end



%              useGPU = 1;
%              tic;
%              [propCorrectLetter_C{di}, propCorrectEachLetter_C{di}] = calcIdealPerformanceForNoisySet(noisySets{di}, [], [], useGPU);
% %              t_mex = toc;
%              
%              tic;
%              [propCorrectLetter_C{di}, propCorrectEachLetter_C{di}] = calcIdealPerformanceForNoisySet(noisySets{di}, [], [], 1);
%              t_gpu = toc;
%              fprintf('t_gpu : %.2f. t_mex: %.2f. ratio = %.1f\n', t_gpu, t_mex, t_gpu/t_mex);



% 
%    tic;
%              [propCorrectLetter_C{di}, propCorrectEachLetter_C{di}] = calcIdealPerformanceForNoisySet(noisySets{di}, [], [], 'parpool');
%              t_par = toc;
% 
% 3;
%              tic;
%              [propCorrectLetter_C{di}, propCorrectEachLetter_C{di}] = calcIdealPerformanceForNoisySet(noisySets{di}, [], [], []);
%              t_mex = toc;
% 
% %              delete(gcp)
% %              p = parpo
%              tic;
%              [propCorrectLetter_C{di}, propCorrectEachLetter_C{di}] = calcIdealPerformanceForNoisySet(noisySets{di}, [], [], 'GPU');
%              t_gpu = toc;
%              
%              assert(isequal(propCorrectLetter_C{di}, propCorrectLetter_C2{di}))
%              assert(isequal(propCorrectLetter_C{di}, propCorrectLetter_C3{di}))
%              
%              assert(isequal(propCorrectEachLetter_C{di}, propCorrectEachLetter_C2{di}))
%              assert(isequal(propCorrectEachLetter_C{di}, propCorrectEachLetter_C3{di}))


%{

    %                 pclust = parcluster;
    %                 host_base = strtok(getenv('hostname'), '.');
    %                 newJobLoc = [pclust.JobStorageLocation filesep host_base];
    %                 if ~exist(newJobLoc, 'dir')
    %                     mkdir(newJobLoc)
    %                 end
    %                 pclust.JobStorageLocation = newJobLoc;
    %                 

%}