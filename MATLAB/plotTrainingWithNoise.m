function plotTrainingWithNoise

    fontName = 'Bookman';
%     allSNRs = [0, 1, 2, 2.5, 3, 4];

    expTitle = 'TrainingWithNoise';

    netType = 'MLP';
    
        ori_x_y = {[0], [0],  [0]};
%         ori_x_y = {[0], [0,3], [0]};   % 2x1
%         ori_x_y = {[0], [0,3,6], [0]}; % 3x1
%         ori_x_y = {[0], [0:6], [0]};    % 7x1
%         ori_x_y = {[0], [0:6], [0:6]};  % 7x7
%         ori_x_y = {[0], [0:9], [0:9]};  % 10x10
%          ori_x_y = {[-4:2:4], [0], [0]};   % 5 x 1x1
%         ori_x_y = {[-4:2:4], [0:4], [0:4]};   % 5 x 5 x 5
%          ori_x_y = {[-4:2:4], [0:9], [0:9]};   % 5 x 10 x 10
        
        
%         oris = [0]; xs = [0:6]; ys = [0];
        [oris, xs, ys] = ori_x_y{:};
        
	allSNRs_train = { {0}, {1}, {2}, {3}, {4}, ...
                      {2, 3}, {3, 4}, ...
                      {0, 1, 2},  {1, 2, 3}, {2, 3, 4}, {1, 2, 3, 4},...
                      {0, 1, 2, 3, 4},  ...
                      {0, 1, 1.5, 2, 2.5, 3, 4} }; 

    allSNRs_train = cellcell2cellarray(allSNRs_train);
    
    allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4];

    nSNRsets_train = length(allSNRs_train);
    nSNRs_test = length(allSNRs_test);
    
    orixy_str = getNoisyLetterOptsStr(oris, xs, ys);
    
    sizeStyle = 'sml';
    
    switch netType
        case 'ConvNet',
            poolStrides = 2;
            doPooling = true;
            filtSizes = [5,4];
            network = struct('netType', 'ConvNet', ...
                               'poolStrides', poolStrides, ...
                                'doPooling', doPooling, ...
                                'filtSizes', filtSizes,...
                                'nStates', [6, 16, 120] ...
                              );
            
        case 'MLP',
                                      
            network = struct('netType', 'MLP', ...
                             'nHiddenUnits', [10, 10]);
    end
  
    
         [oris, xs, ys] = ori_x_y{:};

    noisyLetterOpts.oris = oris;
    noisyLetterOpts.xs = xs;
    noisyLetterOpts.ys = ys;
    noisyLetterOpts.expTitle = 'Noisy';
    noisyLetterOpts.sizeStyle = sizeStyle;
    noisyLetterOpts.useOldStim = 0;
    noisyLetterOpts.tf_pca = 0;
    
    
    pctCorrect = zeros(nSNRs_test, nSNRsets_train);
    
    for snr_train_i = 1:nSNRsets_train
        pCorr_i_S = loadModelResults(expTitle, {fontName}, allSNRs_test, allSNRs_train{snr_train_i}, network, noisyLetterOpts);   
        pctCorrect(:,snr_train_i) = pCorr_i_S.(fontName);
        
    end
        
   
        
%     pctCorrect_model_v_snr = 
    
    %%
%     S = loadModelResults(expTitle, oris, xs, ys, fontName, useConvNet);   
%     allSNRsets = S.allSNRsets;
    allSNRsets_str = cellnum2cellstr(allSNRs_train);
%     nSets = length(allSNRsets);
%%
%     allNHiddenUnits = S.allNHiddenUnits;
%     pctCorr_v_snr = permute(S.pctCorr_v_snr, [3, 2, 1]);
    pctCorr_v_snr_M = mean(pctCorrect, 3)';
    pctCorr_v_snr_S = std(pctCorrect, [], 3)';
%     pctCorrect_model_v_snr = S_model.pctCorrect_v_snr;
    %%
    figure(55); clf; hold on; box on;
    idx_use = [5, 7, 9, 10,11,12,13]; %:nSets; % [5, 13, 14];
%     idx_use = [6, 9, 10, 11,12];%nSets;
%      idx_use = 1:nSNRsets_train;
    nSets_use = length(idx_use);
    allSNRs_rep = repmat(allSNRs_test, [length(idx_use), 1]);
    for si = 1:nSets_use
        plot(allSNRs_test, pctCorr_v_snr_M(idx_use,:)', 'o-');
%         errorbar(allSNRs_rep, pctCorr_v_snr_M(idx_use(si),:)', pctCorr_v_snr_S(idx_use(si),:)', [color_s(si) marker(si) '-'])
        
        
    end
%      allLegendStrs = arrayfun(@(n) getNetworkStr(n), allNetworks, 'un', 0);        

    legend(allSNRsets_str(idx_use), 'location', 'NW', 'fontsize', 12)
    title({'2 Layer Network', strrep(orixy_str, '_', ', ')}, 'fontsize', 17);
    ylabel('% Correct', 'fontsize', 14);
    xlabel('Log SNR', 'fontsize', 14);
    drawHorizontalLine(64, 'linestyle', ':', 'color', 'k')
    3;





end




function S = aloadModelResults(expTitle, oris, xs, ys, fontName, useConvNet)
%     datafile = '/home/avi/Code/MATLAB/nyu/letters/modelPerformance.mat';

%     nFonts = length(allFontNames);
%     all_nHUnits = [1,2,3,4,5,6,7,8,9,10,20,50,100];
    
%     convNet_state_str = '30_80__';
%     convNet_state_str = '6_16__';
%     convNet_state_str = '12_32__';
%     expTitle = iff(convNet, 'ConvNet', 'HiddenUnits');

%     torch_dir = [torchPath 'Results' filesep 'HiddenUnits' filesep 'copy_2013_11_19' filesep];
    network_type = iff(useConvNet, '_ConvNet', '_HU');
    torch_dir = [torchPath 'Results' filesep expTitle filesep];
    
%     isConvNet = strcmp(expTitle, 'ConvNet');
    
    pca_flag = 0;
        
        
        
            %%
%             results_file = getNoisyLetterOptsStr FileName(fontName, oris, xs, ys, allSNRs(si), pca_flag);
    ori_x_y_str = getNoisyLetterOptsStr(oris, xs, ys);
            
    results_filenm = [torch_dir expTitle network_type '_' fontName '__' ori_x_y_str '.mat'];
    S_save = load(results_filenm);
    S = S_save;
    S.allSNRsets = nzrows2cell( S.allSNRsets', -1 );
%     S.nHiddenUnits = S_save.allNHiddenUnits;
            
    %         assert(isequal(all_nHUnits(:), S_model.allNHiddenUnits(:)));
      
        
%     save(datafile, 'pctCorrect_v_nHiddenUnits_snr');
end

