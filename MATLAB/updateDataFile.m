

function updateDataFile
    datafile = '/home/avi/Code/MATLAB/nyu/letters/modelPerformance.mat';
%     allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};
    allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};
%     allFontNames = {'Braille', 'Sloan', 'Yung', 'Kuenstler'};
    allSNRs = [0,1,2,3,4];
    %allFontComplexities = [25.4652, 26.2828, 29.5557, 58.8625];
    nSNRs = length(allSNRs); %#ok<*NASGU,*STRNU>
    nFonts = length(allFontNames);
%     all_nHUnits = [1,2,3,4,5,6,7,8,9,10,20,50,100];
    
    convNet = 1;
%     convNet_state_str = '30_80__';
%     convNet_state_str = '6_16__';
%     convNet_state_str = '12_32__';
    exp_name = iff(convNet, 'ConvNet', 'HiddenUnits');

    Nori = 1;
    Nx = 1;
    Ny = 1;
    letters_str = sprintf('_%dori%dx%dy', Nori, Nx, Ny);
    
%     torch_dir = [torchPath 'Results' filesep 'HiddenUnits' filesep 'copy_2013_11_19' filesep];
    
    torch_dir = [torchPath 'Results' filesep exp_name filesep];
    
    for fi = 1:length(allFontNames)
        fontName = allFontNames{fi};
        
        S = getIdealPerformance(fontName);
        assert(isequal(allSNRs, S.SNRs));
        
        fontComplexities.(fontName) = S.complexity_grey; 
        pctCorrect_vs_snr_ideal.(fontName) = S.pctCorr;
        
%         name_prefix = iff(convNet, ['ConvNet_' convNet_state_str], 'HiddenUnits_');
        filenm = [torch_dir exp_name '_' fontName letters_str '.mat'];
        S_model = load(filenm);
    
        pctCorrect_v_nHiddenUnits_snr.(fontName) = S_model.pct_correct_vs_snr';
        if convNet
            %%
            all_nStates_mat = S_model.allNStates';
            nNets = size(all_nStates_mat,1);
            all_nStates = cell(nNets, 1);
            for i = 1:nNets
                all_nStates{i} = nonzeros(all_nStates_mat(i,:));
            end
             
        else
            all_nStates = S_model.allNHiddenUnits(:);            
        end
%         assert(isequal(all_nHUnits(:), S_model.allNHiddenUnits(:)));
        
    end
        
    save(datafile, 'allFontNames', 'allSNRs', 'all_nStates', 'nFonts', 'nSNRs', ...
                    'fontComplexities', 'pctCorrect_vs_snr_ideal', 'pctCorrect_v_nHiddenUnits_snr', 'convNet');
end