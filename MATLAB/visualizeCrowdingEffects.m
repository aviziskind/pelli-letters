function visualizeCrowdingEffects
    
    
    expTitle = 'CrowdedLetters';
    fontName = 'HelveticaUB';
    sizeStyle = 'k18';
    imageSize = [32, 64];
    useTextureStats = 1;
    x_range = [15,3,87];
    if useTextureStats
        snr_train = 2:5;
        networkType = 'MLP';
    else
        snr_train = 1:3;
        networkType = 'ConvNet';

    end
    logDNR = [3]; %0.85;
    Nscl_txt = 3;  Nori_txt = 4;  Na_txt = 5; 
%     network_use = 3;
    
    if strcmp(networkType , 'ConvNet')
        networkOpt = struct('netType', 'ConvNet', ...
                            'nStates', [6, -15], ...
                            'filtSizes', [5],...
                            ...
                            'doPooling', 1, ...
                            'poolSizes', 4, ...
                                            ...
                            'poolType', 2, ...
                            'poolStrides', 'auto');
    else
        networkOpt = struct('netType', 'MLP', ...
            'nHiddenUnits', []);
    end
    
    letterOpt_1let = struct( 'expTitle', expTitle, ...
                        'fontName', fontName, ...
                        'oris', 0, 'xs', 0, 'ys', 0, ...
                        'sizeStyle', sizeStyle, ...
                        'autoImageSize', 0, ...
                        'imageSize', imageSize, ...
                        'snr_train', snr_train, ...
                     ...  crowded options
                         'xrange', x_range, ...
                         'trainTargetPosition', [1,9,13], ...
                         'doTextureStats', useTextureStats, ...             
                            'Nscl_txt', Nscl_txt, 'Nori_txt', Nori_txt, 'Na_txt', Na_txt, ...
                            'textureStatsUse', 'V2', ...
                        ...                         
                         'nLetters', 1, ...
                         'logDNR', logDNR ...
                         );

                     
     %%
     nDistractors = 1;
     [~, fontData] = loadLetters(fontName, sizeStyle);
     fontWidth = fontData.size(2);
     allDistractSpacings_pix = getAllDistractorSpacings(x_range, fontWidth, nDistractors);
     
     letterOpt_2let = letterOpt_1let;
     letterOpt_2let.testTargetPosition = 1;
     letterOpt_2let.distractorSpacing = allDistractSpacings_pix(1);
     letterOpt_2let.nLetters = nDistractors + 1;
     
     letterOpt_2let_data = rmfield(letterOpt_2let, 'trainTargetPosition');
     
    %%
     trainedModel_modules = loadTrainedModel(letterOpt_1let, networkOpt);
    
    model = recreateModel(trainedModel_modules);
    %%
    opt.usePctCorrectTargetOnly = 1;
        
    allSNRs = [0, 1, 2, 3, 4, 5, 6];
    pctCorr1 = loadModelResults(letterOpt_1let, networkOpt, allSNRs, opt);
    pctCorr2 = loadModelResults(letterOpt_2let, networkOpt, allSNRs, opt);
    %%
        %%
%     inputs = 4;
    snr = 4;
    [fn, file_path] = getCrowdedLetterFileName(fontName, snr, letterOpt_1let);
    S_data = load([file_path fn]);
%%
    [fn_crowded, file_path] = getCrowdedLetterFileName(fontName, snr, letterOpt_2let_data);
    S_data2 = load([file_path fn_crowded]);
%%
    
    
    inputs = S_data.inputMatrix;
    inputs2 = S_data2.inputMatrix;
    if useTextureStats
        inputs = normalizeInputsByStd( inputs, 3 );
        inputs2 = normalizeInputsByStd( inputs2, 3) ;
        
    end
    nInputs1 = size(inputs,3);
    nInputs2 = size(inputs2, 3);
%%        inputs = bsxfun(@rdivide, bsxfun(@minus, inputs, inputs_mean), inputs_std);

    nModulesMax = 2;
    tic;
    nCorrect = 0;
    
    allY = zeros(nInputs1, 26);    
    
    for i = 1:nInputs1
        input_i = inputs(:,:,i);
        
        y = nn_forward(model, single(input_i), nModulesMax);
%         label_i = S_data.labels(i);
%         indmax_y = indmax(y);
%         if indmax(y) == label_i
%             nCorrect = nCorrect +1;
%         end
        allY(i,:) = y;
    end
    
%%
    allY2 = zeros(nInputs2, 26);    
    for i = 1:nInputs2        
        allY2(i,:) = nn_forward(model, single(inputs2(:,:,i)), nModulesMax);
    end

    
    %%
    meanY = mean(allY, 1);
    
    allY_ms = bsxfun(@minus, allY, meanY);
    %%
    [coeff, score_orig] = pca(allY);
    
    %%
    nCoeffs_use = 2;
    coeff = coeff(:,1:nCoeffs_use);
    
%     allY_recovered = (score * coeff')';
    
    %%
    score = getPcaScore(allY, meanY, coeff );
    
    score2 = getPcaScore(allY2, meanY, coeff);
    
    
%     score2 = allY_ms'/coeff';

    
    
    %%
%     allY2_ms = bsxfun(@minus, allY2, mean(allY2, 2));
    
    
    %%
    figure(1); clf; hold on;
    colrs = jet(26);
    
    
    
    for i = 1:26
        idx = S_data.labels == i;
%         colr_idx = iff(i == 2, 1, 3);
        colr_idx = i; %iff(i == 2, 1, 3);
        plot(score(idx,1), score(idx,2), '.', 'color', colrs(colr_idx,:))
    end
    
    
    xlabel('PCA 1'); ylabel('PCA 2');
    toc;
    3;
    
    %%

%     figure(1); clf; hold on;
    for i = [1:26, 2]
        idx = S_data2.labels == i;
%         colr_idx = iff(i == 2, 2, 4);
        colr = iff(i == 2, 'k', colrs(4,:) );
        plot(score2(idx,1), score2(idx,2), '.', 'color', colr, 'markersize', 12)
    end
%     toc;
    3;

    
    
end



