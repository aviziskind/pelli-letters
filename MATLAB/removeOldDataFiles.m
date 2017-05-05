function removeOldDataFiles


    doMatlab = false;
    doTorch = true;

%     datasets_dir = '~/lettersData/datasets/';
    datasets_dir =  [lettersDataPath 'datasets' filesep]; % ~/lettersData/datasets/';
    basedir_matlab = [datasets_dir 'MATLAB' filesep];
    basedir_torch = [datasets_dir 'torch' filesep];


     printFileNames = true;
     doDelete = true;

    date_cutoff_matlab = datenum('2016/1/01');
    date_cutoff_torch = datenum('2016/1/01');

    if doMatlab
        removeOldFiles(basedir_matlab, date_cutoff_matlab, printFileNames, ...
                       doDelete);
    end

    if doTorch
        removeOldFiles(basedir_torch, date_cutoff_torch, printFileNames, ...
                       doDelete);

    end
    if ~doDelete
        fprintf('\n (DRY RUN)\n');
    end


end


function [nGB_removed, nGB_total] = removeOldFiles(dirname, date_cutoff, printFileNames, ...
                              doDelete)

    pause_amount = 0.01;
    s = dir(dirname);
    files = s(~[s.isdir]);

    %   showAllFiles = true;

    nGB_total = sum([files.bytes])/(1024^3);
    %   fprintf('       %s  : %.1f GB\n', dirname, nGB_total);

    nGB_removed = 0;

    %    if showAllFiles

    for fi = 1:length(files)
        file_name = files(fi).name;
        file_size_MB = files(fi).bytes / 1024^2;
        if (files(fi).datenum < date_cutoff) && ...
                isempty(strfind(file_name, 'SVHN')) && isempty(strfind(file_name, 'Performance'))

            nGB_removed = nGB_removed + file_size_MB /(1024);

            if printFileNames
%                 if file_size_MB < 1
                    fprintf('           (%s) [%5.1f MB] %s ', files(fi).date, files(fi).bytes/(1024^2), files(fi).name ...
                            );
                    if ~doDelete
%                         pause(pause_amount);
                    end
%                 end
            end
            if doDelete
                fprintf(' [!] ')
                       delete([dirname filesep files(fi).name]);

            end
            if printFileNames || doDelete
                fprintf('\n')
            end
        end


    end
    %end



    subs = subfolders(dirname);

    nGB_total_sub = [];
    nGB_removed_sub = [];
    for i = 1 : length(subs)
        sub_full_name = [dirname subs{i} filesep];

        if ~isempty(strfind(sub_full_name, 'NoisyLettersTexture')) ...
                || ~isempty(strfind(sub_full_name, ...
                                    'NoisyLettersOverFeat')) ...
                || ~isempty(strfind(sub_full_name, 'SVHN')) ...
                || ~isempty(strfind(sub_full_name, 'natText')) ...
                || ~isempty(strfind(sub_full_name, 'CIFAR')) ...
                || ~isempty(strfind(sub_full_name, 'MNIST')) ... 
                || ~isempty(strfind(sub_full_name, 'Metamer'))
            continue;
        end

        %       fprintf('  -- %s \n', subs{i})

        [nGB_removed_sub(i), nGB_total_sub(i)] = ...
        removeOldFiles(sub_full_name, date_cutoff, ...
                                    printFileNames, doDelete);

    end

    nGB_total = sum(nGB_total_sub) + nGB_total;
    nGB_removed = sum(nGB_removed_sub) + nGB_removed;

    fprintf('  -->> %s Started with : %.1f GB. Removed %.1f GB\n', ...
            dirname, nGB_total, nGB_removed);

end




function subs = subfolders(dirname)

    s = dir(dirname);
    idx_dir = [s.isdir];

    s = s(idx_dir);

    %     idx_remove = strcmp(  {s.name}, '.') | strcmp(  {s.name},
    %     '..');
    idx_remove = strncmp(  {s.name}, '.', 1);
    s(idx_remove) = [];

    subs = {s.name};


end
