function [tf, fileName, foldersChecked] = fileExistsInSisterSubdirs(mainExperimentDir, subdir, filename, checkAllSisterSubdirs_flag)
    
    preferredFileName = [mainExperimentDir subdir filename];
    alsoCheckNYU_folder = true;
    checkAllSisterSubdirs = ~exist('checkAllSisterSubdirs_flag', 'var') || ~isequal(checkAllSisterSubdirs_flag, 1);
    foldersChecked = {[mainExperimentDir subdir]};
    
    
    if doesFileExist(preferredFileName)
        tf = true;
        fileName = preferredFileName;
        return
        
    elseif alsoCheckNYU_folder && isempty(strfind(mainExperimentDir, 'NYU'))
        mainExperimentDir_NYU = [mainExperimentDir(1:end-1) '_NYU/'];
        preferredFileName_NYU = [mainExperimentDir_NYU subdir filename];
        foldersChecked{end+1} = [mainExperimentDir_NYU subdir];
        
        if doesFileExist(preferredFileName_NYU)
            tf = true;
            fileName = preferredFileName_NYU;
            return
        end
    end
    
    if checkAllSisterSubdirs
        
        resultsMainDir = parentdir(mainExperimentDir);
        subfolder_names = subfolders(resultsMainDir);
        for i = 1:length(subfolder_names)

            subfolder_name = subfolder_names{i};
            checkedAlready = strcmp(subfolder_name, mainExperimentDir) || ...
                 (alsoCheckNYU_folder && strcmp(subfolder_name, mainExperimentDir_NYU));
            
            if ~checkedAlready 
                fullFileName = [resultsMainDir  subfolder_name filesep subdir filename];
                foldersChecked{end+1} = [resultsMainDir  subfolder_name filesep subdir];
                if doesFileExist(fullFileName) 
                    tf = true;
                    fileName = fullFileName;
                    return
                end
            end
            
        end
    end
    
    
%     if ~isempty(preferredSubdir)
%         altFileName = [mainDir filename];
%         if exist(altFileName, 'file')
%             tf = true;
%             fileName = altFileName;
%             return
%         end
%     end
    
% 
%     
%     subdirs = subfolders(mainExperimentDir);    
%     if alsoCheckNYU_folder && isempty(strfind(mainExperimentDir, 'NYU')) && exist(mainDir_NYU, 'dir')
%         subdirs = [subdirs, subfolders(mainDir_NYU)];
% 
%     end
%     
%         %%
%     for i = 1:length(subdirs)
%         
%         file_name_i = [mainExperimentDir subdirs{i} filesep filename];
%         
%         fileExists = doesFileExist(file_name_i);  
%         if fileExists
%             tf = true;
%             fileName = file_name_i;
%             return
%         end
%     end
        
    tf = false;
    fileName = preferredFileName;
    
end

function tf = doesFileExist(file_name)
    
%         tf = exist(filename, 'file');
        tf = ~isempty(dir(file_name));  % this is about 20 times faster
    
end