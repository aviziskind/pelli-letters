% function test_nn_forward
    
    
    
    expTitle = 'NoisyLetters';
    fontName = 'Bookman';
%     sizeStyle = 12;
    sizeStyle = 'k14';
    imageSize = [48, 48];
%     imageSize = [36, 116];
%     snr_train = 1:3;
    snr_train = 6;
%     network_use = 3;
    netType = 'MLP';

    switch netType
        case 'ConvNet',
            networkOpt = struct('netType', 'ConvNet', ...
                                'nStates', [6, -15], ...
                                'filtSizes', [5],...
                                ...
                                'doPooling', 1, ...
                                'poolSizes', 2, ...
                                                ...
                                'poolType', 2, ...
                                'poolStrides', 'auto');

        case 'MLP'
            networkOpt = struct('netType', netType, 'nHiddenUnits', {{}});
                
        
        
        
    end
    
    letterOpt = struct( 'expTitle', expTitle, ...
                        'fontName', fontName, ...
                        'oris', 0, 'xs', 0, 'ys', 0, ...
                        'sizeStyle', sizeStyle, ...
                        'autoImageSize', 0, ...
                        'imageSize', imageSize, ...
                        'snr_train', snr_train);
    
    
    trainedModel_modules = loadTrainedModel(letterOpt, networkOpt);
    
    model = recreateModel(trainedModel_modules);
    model_orig = model;
    %%
    allSNRs = [0, 1, 2, 3, 4];
    pctCorr = loadModelResults(letterOpt, networkOpt, allSNRs);
    %%
        %%
    inputs = 4;
    snr_input = 1;
    [fn, file_path] = getNoisyLetterFileName(fontName, snr_input, letterOpt);
    S_data = load([file_path fn]);
    
    tmplates = S_data.signalData;
    sig = reconstructSignal (S_data.signalData);
    
    bias_orig = model_orig.modules{2}.bias;
    wgts_orig = model_orig.modules{2}.weight;
    
    E1 = [sig.E1];
    new_bias = -E1(:)/2;
    new_bias = new_bias - mean(new_bias);
    new_weights = reshape(tmplates, [size(tmplates,1)*size(tmplates,2), size(tmplates,3)]);
    
    model.modules{2}.bias = new_bias;
    model.modules{2}.weight = new_weights;
    
%     [tmplates, offsets] = get
    
    %%
    
    tic;
    nInputsTest = 10000;
    nCorrect = 0;
    for i = 1:nInputsTest
        input_i = S_data.inputMatrix(:,:,i);
        label_i = S_data.labels(i);

        y = nn_forward(model, input_i);
        if indmax(y) == label_i
            nCorrect = nCorrect +1;
        end

    end
    
    fprintf('SNR = %d. Pct Correct = %.2f%%\n', snr_input, nCorrect/nInputsTest * 100);
%     toc;
    3;
    
    
    
% end

