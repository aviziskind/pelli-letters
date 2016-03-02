function viewUncertaintyProjections

    
    net_file = [codePath 'sri' filesep 'CSSN' filesep 'SVHN__Conv_f6_16_F120_fs5_5_psz2_2_ptMAX__SGD_m95'];
    S_loaded = load(net_file);
    S_network = recreateModel(S_loaded);
%%

%     SVHN_file = [lettersDataPath 'datasets' filesep 'MATLAB' filesep  'SVHN' filesep  'SVHN_train_32x32_gray_gnorm.mat'];
%     letters_data = load(SVHN_file);
    letters_file = [lettersDataPath 'datasets' filesep 'MATLAB' filesep  'NoisyLetters' filesep  'Bookman' filesep 'Bookman_k15-30x[1]_39y[1]-[64x64]-50SNR.mat'];
    letters_data = load(letters_file);

    
    %%
    
    
    %%
    nMaxUse = 10000;
    inputMatrix = letters_data.inputMatrix;
    labels = letters_data.labels;
    if size(inputMatrix,3) > nMaxUse
        inputMatrix = inputMatrix(:,:,1:nMaxUse);
        labels = labels(1:nMaxUse);
    end

    
    nSamples = length(labels);
    [uLabels, labelsIdx] = uniqueList( labels );
    nUniqueLabels = length(uLabels);
    
    
    %%
%     for i = 1:    
    idx = 1;
    input_1 = inputMatrix(:,:,idx);
    figure(1); clf;
    imagesc(input_1); imageToScale([], 2);
    
    %%
    x = nn_forward(S_network, single(input_1), 7);
    
    nX = length(x);
    
    %%
    tic;
    progressBar('init-', nSamples)
    allX = zeros(nSamples,nX);
    for i = 1:nSamples
        allX(i,:) = nn_forward(S_network, inputMatrix(:,:,i), 7 );
        progressBar(i);
    end
    toc;
    %%
%     nPerImage = numel(inputMatrix(:,:,1));
%     allIm = reshape(inputMatrix, [nPerImage, nSamples])';
    %%
%     [coeff,score,latent,tsquared,explained,mu] = pca(allIm);
    [coeff,score,latent,tsquared,explained,mu] = pca(allX);
    
%% 
    [coeff2,score2,latent2,tsquared2,explained2,mu2] = pca(allX');
    
    %%
    [coeff3, PCA_comps, x_mean, x_cov, eig_vals] = doPCA(allX, 8);
    
    %%
    x = score(:,1);
    y = score(:,2);
    %%
    figure(1); clf ; hold on;
    cols = jet(nUniqueLabels);
    for i = 1:nUniqueLabels 
        plot(x(labelsIdx{i}), y(labelsIdx{i}), '.', 'color', cols(i,:));
    end
    
    
    %%
    
    title( num2str( labels(idx) ) );
    colormap(gray);
    colorbar;
    
    %%
    x = nn_forward(S_network, single(input_1));
    
    %%
    label_network = indmax(x);
    
    xlabel(sprintf(' network : %d', label_network));


















end