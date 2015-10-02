function createMetamerLettersDatafile(fontName, fontSize, imageHeight, maxNIter, Nscl, Nori, Na, set_idx)

%     allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'BookmanB', 'BookmanU', 'Georgia', 'Yung', 'Kuenstler'};
    % pelli complexity:    28,            65         67          100,       107         57          139                        199       451  

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   unrotated   rot 5,     rot 10    rot 15   rot 20 
%     defaultFontSize.Braille      =  9; % 20 x 29.  29 x 21,  31 x 23,  31 x 25,  33 x 27.   C0 = 27  C2 = 28
%     defaultFontSize.Sloan        = 16; % 28 x 29.  29 x 31,  31 x 31,  33 x 33,  35 x 35.   C0 = 42  C2 = 43
%     defaultFontSize.Helvetica    = 20; % 33 x 25.  33 x 25,  35 x 27,  35 x 29,  35 x 29.   C0 = 49  C2 = 55
%     defaultFontSize.Bookman      = 18; % 32 x 30.  31 x 31,  32 x 31,  33 x 31,  33 x 33.   C0 = 55  C2 = 63
%     defaultFontSize.GeorgiaU = 16; % 26 x 31.  27 x 33,  28 x 33,  30 x 35,  32 x 37.   C0 = 59  C2 = 85
%     defaultFontSize.Courier      = 21; % 32 x 24.  32 x 25,  32 x 25,  34 x 29,  34 x 31.   C0 = 78  C2 = 121
%     defaultFontSize.Yung         = 21; % 32 x 32.  32 x 32,  33 x 32,  34 x 34,  34 x 34.   C0 = 78  C2 = 114
%     defaultFontSize.Kuenstler    = 14; % 24 x 33.  25 x 33,  27 x 35,  30 x 36,  32 x 37.   C0 = 83  C2 = 286
    testMode = 0 && 1;
    

    skipIfFilesAlreadyPresent = 0;
    skipIfFilesNotPresent = 0;
    redoFiles = 0;
%         redoFilesBefore = 735663.747353;
    
    if (nargin < 1) 
% %         fontName = 'BookmanU';
        allFontNames = {'HelveticaUB', 'KuenstlerU'};
        allFontSizes = {'med'};
%         allNScales = {2,3}; %4
%         allNOrientations = {2,3,4};
%         allNa = {3,5,7,9};
        allImageSizes = {32}; %{64};
        maxNIter = 200;

        allNScales = {2};
        allNOrientations = {3,4};
        allNa = {3,5};
        
        allSetsToDo = expandOptionsToList( struct( 'tbl_fontName', {allFontNames}, ...
                                                   'tbl_fontSize', {allFontSizes}, ...
                                                   'tbl_Nscl', {allNScales}, ...
                                                   'tbl_Nori', {allNOrientations}, ...
                                                   'tbl_Na', {allNa}, ...
                                                   'tbl_imageSize', {allImageSizes} ...
                                                ) );
                   
%         allSetsToDo = struct('imageSize', 64, 'Nscl', 2, 'Nori', 3, 'Na', 5,  'maxNIter', maxNIter);
                   
%         allSetsToDo = fliplr(allSetsToDo);

        for set_idx = 1:length(allSetsToDo)
            set_i = allSetsToDo(set_idx);
            
%             fprintf('=============== Set %d/%d ============== \n', set_idx, length(allSetsToDo) )
            
            fprintf('\n\n======= Set %d/%d === [font = %s, size %s, image %dx%d. Nscl = %d, Nor = %d, Na = %d] ======= \n', ...
                set_idx, length(allSetsToDo),  set_i.fontName, set_i.fontSize, set_i.imageSize, set_i.imageSize, set_i.Nscl, set_i.Nori, set_i.Na )
            
            createMetamerLettersDatafile(      set_i.fontName, set_i.fontSize, set_i.imageSize, maxNIter, set_i.Nscl, set_i.Nori, set_i.Na, set_idx);
            3;
        end
        return;
    end
    
    %% Make sure we can do with current # of scales.
    maxNScales_analysis = floor(log2(imageHeight)) - 2;

    ori_bands_dims = imageHeight ./ 2.^[1:Nscl];        
    maxNScales_synth = find( round(ori_bands_dims / 4) == ori_bands_dims / 4, 1, 'last' );
    
    if (Nscl > maxNScales_analysis) || (Nscl > maxNScales_synth)
        fprintf('Invalid # of scales for this image size');
        return
    end
    
    assert(Nscl <= maxNScales_analysis);
    assert(Nscl <= maxNScales_synth);

    
    
%     log_max = floor( log2(maxNIter/nIter0) );
    all_nIter = maxNIter; % 25 * 2.^[0 : log_max] ;
     
    %1. Get Correct Path          
    letterMetamersPath = [datasetsPath 'MetamerLetters' filesep]; % 'sz32x32' filesep];
    letterMetamersPath_thisFont = [letterMetamersPath fontName filesep];
    if ~exist(letterMetamersPath_thisFont, 'dir')
        mkdir(letterMetamersPath_thisFont)
    end
    
    
    
    if ischar(fontSize)
        sizeStyle = fontSize;
        fontSize = getFontSize(fontName, sizeStyle);
    else
        sizeStyle = fontSize;
    end
    
    %% Load Letters (of appropriate size) from fonts file
    sizeSpec = 'minSize';
    allLetters = loadLetters(fontName, fontSize, sizeSpec);
        
    %% Decide how many of each letter we will be using
    nLettersUse_test = 26;
    nSamplesEach_test = 10;
    
    if testMode
        nSamplesTot = nLettersUse_test * nSamplesEach_test;
        
        let_idxs_use = [1:nLettersUse_test];
               
    else
        let_idxs_use = 1:size(allLetters,3);
        nSamplesTot = 5000;
        
    end
    allLetters = allLetters(:,:,let_idxs_use);
    allMetamers = zeros(imageHeight, imageHeight, nSamplesTot);

    
    %% Letter Images --> (correct size) 32x32  
    allLetters_orig = allLetters;
    allLetters = addMarginToPow2(allLetters, 0);
    assert(size(allLetters,1) == imageHeight);
    
    nLetters = size(allLetters, 3);

    
    %%  Get Texture statistics
   
    
    filePresent = true; %#ok<NASGU> %(1, nnIter);

    if skipIfFilesAlreadyPresent
%         for iter_i = 1:nnIter
        metamerFileParams = struct('imageSize', imageHeight, 'fontSize', sizeStyle, 'nIter', maxNIter, 'Nscl', Nscl, 'Nori', Nori, 'Na', Na, 'tf_test', testMode);

        filename = getLetterMetamerFileName(fontName, metamerFileParams);
        filePresent = exist([letterMetamersPath_thisFont filename], 'file');
%         end
    end
    
        
    %%
    for let_i = 1:nLetters
        allTextureStatistics(let_i) = textureAnalysis(allLetters(:,:,let_i), Nscl, Nori, Na, 0); %#ok<AGROW>        
        nTextureStats = length(struct2vec(allTextureStatistics(let_i)));
    end
    for let_i = 1:nLetters
        allTextureStatistics(let_i).origImage = allLetters(:,:,let_i);  %#ok<AGROW>
    end
    3;
    %%
    
    rng(0, 'twister');
        
    seedOffset = 200;    
    allSeeds = seedOffset + (1:nSamplesTot);% zeros(nLetters, nSamplesEach);
    
    %%
    
    
    if filePresent && ~redoFiles
        fprintf('[already completed]\n');
        
%         for iter_i = 1:nnIter
        metamerFileParams = struct('imageSize', imageHeight, 'fontSize', sizeStyle, 'nIter', maxNIter, 'Nscl', Nscl, 'Nori', Nori, 'Na', Na, 'tf_test', testMode);

        filename = getLetterMetamerFileName(fontName, metamerFileParams);
        S = load([letterMetamersPath_thisFont filename]);

        allMetamers = S.inputMatrix;
        labels = S.labels;
        nSamplesTot = length(labels);
        
    else
    
        if skipIfFilesNotPresent
            return
        end

        % 1. Generate Labels
        if testMode
            %%
            labels = repmat([1:nLettersUse_test]', [1, nSamplesEach_test]);
            labels = labels(:);
        else
            %%
            % randomly selects nSamplesTot random labels, but more evenly than just with "randi(nLetters, nSamplesTot, 1);"
            labels_withExtra = repmat([1:nLetters], 1, ceil(nSamplesTot/nLetters));
            labels = labels_withExtra( randperm(length(labels_withExtra)) );
            labels = labels(1:nSamplesTot); 
            
%             labels = 
        end
            
    
        % 2. Generate Metamers
        progressBar('init-', nSamplesTot, 60);
%         synthStats = [];
        seeds_used = zeros(size(allSeeds));
        for sample_i = 1:nSamplesTot

            label_i = labels(sample_i);
            initSeed = allSeeds(sample_i);
            imSize = [imageHeight, imageHeight];
            seedStep = 10000;

            [metamer_i, seeds_used(sample_i), synthStat] = createMetamer(allTextureStatistics(label_i), imSize, initSeed, seedStep, maxNIter);

            if sample_i == 1
                synthStats(nSamplesTot) =  blankStruct(synthStat); %#ok<AGROW>
            end
            synthStats(sample_i) = synthStat; %#ok<AGROW>
            
            allMetamers(:,:,sample_i) = metamer_i;

            progressBar;
        end
        progressBar('done');
            
        
    end
    
    %%
    if ~exist('set_idx', 'var')
        set_idx = 50;
    end
    
    showSamples = 1;
    if showSamples 
        %%
        nStat_calc     = nTextureStatisticsForParams( Nscl, Nori, Na );
        nStat_calc_str = iff(nStat_calc == nTextureStats, '', sprintf(' (%d)', nStat_calc));
        stat_n_str = sprintf('\\fontsize{10}{Nscl = %d, Nori = %d, Na = %d [Nstat = %d%s]}', Nscl, Nori, Na, nTextureStats, nStat_calc_str);
        
        nShow_default = nLettersUse_test * nSamplesEach_test;

        [uLabels, labelsList, labelsCount] = uniqueList(labels);
        nLetHave = length(uLabels);
        nSampEachHave = min(min(labelsCount), nSamplesEach_test);
        nLetShow      = min(nLettersUse_test, nLetHave);
        nSampEachShow = min(nSamplesEach_test, nSampEachHave);
        nSamplesToShow = nLetShow * nSampEachShow;
        
        
        nShow = min([nShow_default, nSamplesTot, nSamplesToShow]);

        idxs_use = cellfun(@(idxs) idxs(1:nSampEachShow), labelsList, 'un', 0);
        idxs_use = [idxs_use{:}];
        idxs_use = idxs_use(:);
        
        allMetamers_show = reshape(allMetamers(:,:,idxs_use), [size(allMetamers,1), size(allMetamers,2), nSampEachShow, nLetShow]);
        
        
        A_offset = 'A' - 1;
                    
        nShow_h = nSampEachShow;
        nShow_w = nLetShow;

        figure(200+ set_idx); clf;
            
        tileMetamers = 0;
        centerMetamers = 1;
        
        for idx = 1:nShow
            [s_idx,l_idx] = ind2sub([nShow_h, nShow_w], idx);
            subplotGap(nShow_h, nShow_w, s_idx,l_idx, [.08, 0, 0], [.0, 0, 0]);

            met_i = allMetamers_show(:,:,s_idx, l_idx);
            if tileMetamers
                met_i = [met_i, met_i; met_i, met_i];
            end
            if centerMetamers
                met_i = centerMetamer(met_i);
            end
            
            imagesc(met_i);
            set(gca, 'xtick', [], 'ytick', []);
            axis equal tight;
            if s_idx == 1 
                title_str = char(  let_idxs_use(l_idx) + A_offset);
                if l_idx == ceil(nShow_w/2)
                    title_str = {stat_n_str, ['\fontsize{10}{' title_str '}']}; 
                end
                title(title_str); 
            end
        end
        colormap('gray');
        drawnow;
        imageToScale;
        
        3;
            
%         
    end
    3;
    %%
    
    
    
    if ~all(filePresent) || redoFiles
        %%
        randomizeOrder = false;
        allSeeds_v = allSeeds(:);
        allSeeds_used_v = seeds_used(:);
        if randomizeOrder
            rand_order = randperm(nLetters*nSamplesEach_test);

            labels_orig = repmat(1:nSamplesEach_test, [nLetters, 1]); labels_orig = labels_orig(:);
            labels = labels_orig(rand_order);
            labels = labels(:)';
        %
            
            seeds = allSeeds_v(rand_order);
        end
        
        %%
        metamerFileParams = struct('imageSize', imageHeight, 'fontSize', sizeStyle, 'nIter', maxNIter, 'Nscl', Nscl, 'Nori', Nori, 'Na', Na, 'tf_test', testMode);

%         allMetamers_i = allMetamers(:,:,:);
%         inputMatrix = allMetamers; %reshape(allMetamers_i, [imageHeight, imageHeight, nLetters*nSamplesEach_test]);
%         if randomizeOrder
%             inputMatrix = inputMatrix(:,:,rand_order);
%         end

        setToSave = struct('fontName', fontName, 'fontSize', fontSize, 'date', datestr(now), ...
            'inputMatrix', allMetamers, 'labels', labels, 'imageSize', [imageHeight, imageHeight], 'nClasses', nLetters, ...
            'textureStats', allTextureStatistics, 'seeds', allSeeds_v, 'seeds_used', allSeeds_used_v, 'synthStats', synthStats, ...
            'nIter', maxNIter, 'Nscl', Nscl, 'Nori', Nori, 'Na', Na);   %#ok<NASGU>

        filename = getLetterMetamerFileName(fontName, metamerFileParams);

        fprintf('   => Saving Letter Metamers to file %s \n', filename)
%         keyboard;
            save([letterMetamersPath_thisFont filename], '-struct', 'setToSave', '-v6');
    3;
    end
    3;
    %%
    
     


end




%{


%}