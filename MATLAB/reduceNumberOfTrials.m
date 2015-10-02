function reduceNumberOfTrials(fileName)
    %%
    matlab_datasets_folder = '/media/Storage/Users/Avi/Code/MATLAB/nyu/letters/datasets/';
    torch_datasets_folder = '/media/Storage/Users/Avi/Code/torch/letters/datasets/';
    sub_folder = 'NoisyLetters/Bookman/';
    
    if nargin < 1
        
        mat_folder = [matlab_datasets_folder sub_folder];
        torch_folder = [torch_datasets_folder sub_folder];
        
%         folder_name = '/media/Storage/Users/Avi/Code/MATLAB/nyu/letters/datasets/NoisyLetters/Bookman/';
%         
%         
%         folder_name = '/media/Storage/Users/Avi/Code/MATLAB/nyu/letters/datasets/NoisyLetters/Bookman/';
%         

        ss = dir([mat_folder '*.mat']);

        for i = 1:length(ss)
            fn = ss(i).name;
            fn_t7 = strrep(fn, '.mat', '.t7');
            if isempty(strfind(fn, 'sample')) &&  exist([torch_folder fn_t7], 'file')
    
                filename = [mat_folder fn];

                reduceNumberOfTrials(filename)

            end
        end
        return
    end
    %%
    
    maxNTrials = 100;
    S = load(fileName);
    [fldr_name, f_name, ext] = fileparts(fileName);
    nTrialsCur = length(S.labels);
    nTrialsKeep = min(nTrialsCur, maxNTrials);
    if nTrialsCur > nTrialsKeep
        fprintf('%s\n', f_name);
        S.inputMatrix = S.inputMatrix(:,:,1:nTrialsKeep);
        S.labels = S.labels(1:nTrialsKeep);

        fileName_new = [fldr_name filesep f_name '_sample', ext];
        save(fileName_new, '-struct', 'S', '-v6');
        delete(fileName);
    end    
    
    
    
end