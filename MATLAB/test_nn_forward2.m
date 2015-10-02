% function test_nn_forward
    
    
    
    expTitle = 'NoisyLetters';
    fontName = 'Bookman';
    sizeStyle = 'k72';
    imageSize = [147, 147];
    snr_train = 1:3;
%     network_use = 3;
    
    networkOpt = struct('netType', 'ConvNet', ...
                        'nStates', [6, -15], ...
                        'filtSizes', [5],...
                        ...
                        'doPooling', 1, ...
                        'poolSizes', 16, ...
                                        ...
                        'poolType', 2, ...
                        'poolStrides', 'auto');

    
    letterOpt = struct( 'expTitle', expTitle, ...
                        'fontName', fontName, ...
                        'oris', 0, 'xs', 0, 'ys', 0, ...
                        'sizeStyle', sizeStyle, ...
                        'autoImageSize', 0, ...
                        'imageSize', imageSize, ...
                        'snr_train', snr_train);
    
    
    trainedModel_modules = loadTrainedModel(letterOpt, networkOpt);
    
    model = recreateModel(trainedModel_modules);
    %%
    allSNRs = [0, 1, 2, 2.5, 3, 4];
    pctCorr = loadModelResults(letterOpt, networkOpt, allSNRs);
    %%
        %%
    inputs = 4;
    [fn, file_path] = getNoisyLetterFileName(fontName, 4, letterOpt);
    S_data = load([file_path fn]);
    %%
    tic;
    nCorrect = 0;
    for i = 1:1000
        input_i = S_data.inputMatrix(:,:,i);
        label_i = S_data.labels(i);

        y = nn_forward(model, input_i);
        if indmax(y) == label_i
            nCorrect = nCorrect +1;
        end

    end
    toc;
    3;
    
    
    
% end

