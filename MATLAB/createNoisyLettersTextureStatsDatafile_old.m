function createNoisyLettersStatsDatafile(fontName, fontSizeStyle, orientations, xs, ys, set_idx)

%     allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'BookmanB', 'BookmanU', 'Georgia', 'Yung', 'Kuenstler'};
    % pelli complexity:    28,            65         67          100,       107         57          139                        199       451  

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   unrotated   rot 5,     rot 10    rot 15   rot 20 
%     defaultFontSize.Braille      =  9; % 20 x 29.  29 x 21,  31 x 23,  31 x 25,  33 x 27.   C0 = 27  C2 = 28
%     defaultFontSize.Sloan        = 16; % 28 x 29.  29 x 31,  31 x 31,  33 x 33,  35 x 35.   C0 = 42  C2 = 43
%     defaultFontSize.Helvetica    = 20; % 33 x 25.  33 x 25,  35 x 27,  35 x 29,  35 x 29.   C0 = 49  C2 = 55
%     defaultFontSize.Bookman      = 18; % 32 x 30.  31 x 31,  32 x 31,  33 x 31,  33 x 33.   C0 = 55  C2 = 63
%     defaultFontSize.GeorgiaU     = 16; % 26 x 31.  27 x 33,  28 x 33,  30 x 35,  32 x 37.   C0 = 59  C2 = 85
%     defaultFontSize.Courier      = 21; % 32 x 24.  32 x 25,  32 x 25,  34 x 29,  34 x 31.   C0 = 78  C2 = 121
%     defaultFontSize.Yung         = 21; % 32 x 32.  32 x 32,  33 x 32,  34 x 34,  34 x 34.   C0 = 78  C2 = 114
%     defaultFontSize.Kuenstler    = 14; % 24 x 33.  25 x 33,  27 x 35,  30 x 36,  32 x 37.   C0 = 83  C2 = 286

    allFontNames = {'HelveticaUB'};
            
    
%     precision = 'double'; precision_func = @double;
    precision = 'single'; precision_func = @single;        

    

    redoFilesIfExist = 1;
        checkContentsOfFile = 0;
        redoIdealObserver = 1;
    
%     fontSizeStyle = 'dflt';     marginPixels = 1;
%     fontSizeStyle = 'sml';   

    showLetters = 0;
    showSamplesWithNoise = 1;
    
    
    if (nargin < 1) || strcmp(fontName, 'all')

%         allOriXYSets = allOriXYSets_PCA;
        allOriXYSets = allOriXYSets_one;
        
        for set_i = 1:length(allOriXYSets)
            orixyset = allOriXYSets{set_i};
            [sizeStyle_i, oris_i, xs_i, ys_i] = orixyset{:};
            for fi = 1:length(allFontNames_toDo)
                fprintf('=============== %s ============== \n', allFontNames_toDo{fi})
                createNoisyLettersDatafile(allFontNames_toDo{fi}, sizeStyle_i, oris_i, xs_i, ys_i, set_i);
            end
            3;
        end
        return;
    end
    
    if strcmp(fontSizeStyle, 'dflt')
        marginPixels = 1;
    else
        marginPixels = 5;
    end
    

    font_loc_idx = find(strcmp(fontName, allFontNames),1);
%     nLettersUse = 10;
    

        
    fontSize = getFontSize(fontName, fontSizeStyle);
    
    
    xs = xs-xs(1);
    ys = ys-ys(1);
    
    xs=round(xs);
    ys=round(ys);
    Dx = xs(end)-xs(1);
    Dy = ys(end)-ys(1);
    nOris = length(orientations);
    nX = length(xs);
    nY = length(ys);
    
        
    fprintf(' - Calculating Noisy letter Sets for %s, size %d\n', fontName, fontSize);
    fprintf(' - Using %d Orientations [%d:%d], %d X positions [%d:%d], and %d Y positions [%d:%d]\n', nOris, lims(orientations,0), nX, lims(xs,0), nY, lims(ys,0));
    
    [imageHeight, imageWidth] = getBestImageSize(orientations, xs, ys, allFontNames, fontSizeStyle, marginPixels);

    fprintf(' - Using an image size %d x %d\n', imageHeight, imageWidth);
  
    
    noiseType = 'gaussian';
    nNoiseSamples = 1e5;
    
    noisyLettersPath = [lettersPath 'NoisyLetters' filesep]; % 'sz32x32' filesep];
    noisyLettersPath_thisFont = [noisyLettersPath fontName filesep];
    if ~exist(noisyLettersPath_thisFont, 'dir')
        mkdir(noisyLettersPath_thisFont)
    end
    
  

    % % %     defaultFontSize.Georgia = 10;   % 17 x 21. C0 = 42. C2 = 86
    
    
%     useTorchTensorSizes = 1;
    
%     overflowCheck = 0;
  
    
%     bold_tf = 0;
    setSize=10000; % normally 10,000.
    signalContrast=1;
    background = 0;

    
    S_fonts = loadLetters;
    

    all_SNRs = [-1,  0, 0.5,  1,  1.5,  2, 3];
%     all_SNRs = [0];
    all_SNRs_done_im  = false(size(all_SNRs));
    all_SNRs_done_pca = false(size(all_SNRs));
    
    logEstimatedEOverNIdealThreshold=-2.6- -3.60; % We could use a fancier formula from my 2006 paper that takes rho into account. But this is fine for typical fonts.

    logEOverNs = all_SNRs + 1;
   
    noisy_letter_opts_image = struct('sizeStyle', fontSizeStyle, 'oris', orientations, 'xs', xs, 'ys', ys, 'tf_pca', 0); 
    noisy_letter_opts_pca = struct('sizeStyle', fontSizeStyle, 'oris', orientations, 'xs', xs, 'ys', ys, 'tf_pca', 1); 

    
    if ~redoFilesIfExist && ~showLetters
        for i = 1:length(logEOverNs)
            fn_i_im  = [noisyLettersPath_thisFont getNoisyLetterFileName(fontName, logEOverNs(i), noisy_letter_opts_image) ];
            imageFileExists = exist(fn_i_im, 'file');
            fn_i_pca = [noisyLettersPath_thisFont getNoisyLetterFileName(fontName, logEOverNs(i), noisy_letter_opts_pca) ];
            pcaFileExists = exist(fn_i_pca, 'file');


            if ~checkContentsOfFile
                all_SNRs_done_im(i) = (imageFileExists || ~createImageFiles);
                all_SNRs_done_pca(i) = (pcaFileExists || ~createPcaFiles);
            else
                if createImageFiles && imageFileExists
                    SS_im = load(fn_i_im);
                    same_params_im = isequal(SS_im.orientations, orientations) && isequal(SS_im.xs, xs) && isequal(SS_im.ys, ys) && ...
                        isequal(SS_im.imageSize, [imageHeight, imageWidth]);
                    all_SNRs_done_im(i) = same_params_im;
                end

                if createImageFiles && imageFileExists
                    SS_pca = load(fn_i_im);
                    same_params_pca = isequal(SS_pca.orientations, orientations) && isequal(SS_pca.xs, xs) && isequal(SS_pca.ys, ys) && ...
                        isequal(SS_pca.imageSize, [imageHeight, imageWidth]);
                    all_SNRs_done_pca(i) = same_params_pca;                    
                end

            end
            
        end
        
    end
        
    
    all_SNRs_toDo_im  = ~all_SNRs_done_im  | redoIdealObserver;
    all_SNRs_toDo_pca = ~all_SNRs_done_pca | redoIdealObserver;

    all_SNRs_toDo = all_SNRs_toDo_im | all_SNRs_toDo_pca;
    
    if ~any(all_SNRs_toDo)
        fprintf('[Already Completed]\n');
        return;
    end
        
    
    font_fld_curFontSize = sprintf('%s_%02d', fontName, fontSize);
    fontData_curSize = S_fonts.(font_fld_curFontSize);
    
    allLetters = single( rescaleBetween0and1(fontData_curSize.letters) );    
    
    complexity_bool_mean = fontData_curSize.complexity_0;  
    complexity_bool_all  = fontData_curSize.complexity_0_all; 
    complexity_grey_mean = fontData_curSize.complexity_2;  
    complexity_grey_all  = fontData_curSize.complexity_2_all;
        
    
    nLetters = size(allLetters, 3);
    

    allLetters_rotated = cell(1,nOris);
    for ori_i = 1:nOris
        margin = 0;
        let_rotated = rotateLetters(allLetters, orientations(ori_i));
        [idxT, idxB, idxL, idxR] = findLetterBounds(let_rotated, margin);
        allLetters_rotated{ori_i} = let_rotated(idxT:idxB, idxL:idxR, :);
    end
     
%%

    pixPerDeg = 1;
    signal(nLetters, nOris, nX, nY) = struct;
    
    fprintf('Calculating Signals...');
%     progressBar('init-', nLetters * nOris * nX * nY)
    for let_i=1:nLetters
%         letter_i = allLetters(:,:,let_i);
        for ori_i=1:nOris
            letter_rotated = allLetters_rotated{ori_i}(:,:,let_i); %imrotate(letter_i, orientations(ori_i), 'bilinear');
            [let_h, let_w] = size(letter_rotated);
            h_offset = floor((imageWidth - (let_w+Dx) )/2);
            v_offset = floor((imageHeight- (let_h+Dy) )/2);
            idx_horiz0 = [1:let_w]+h_offset;
            idx_vert0  = [1:let_h]+v_offset;
    
            for xi=1:nX
                idx_horiz = idx_horiz0 + xs(xi);
                assert(all(ibetween(idx_horiz, [1, imageWidth])))
                
                for yi=1:nY
                    idx_vert = idx_vert0 + ys(yi);
                    
                    assert(all(ibetween(idx_vert, [1, imageHeight])))
                    
                    signal(let_i,ori_i,xi,yi).image = zeros(imageHeight, imageWidth, precision);
                    signal(let_i,ori_i,xi,yi).image(idx_vert, idx_horiz) = letter_rotated;
                    
                    signal(let_i,ori_i,xi,yi).E1=dot(signal(let_i,ori_i,xi,yi).image(:),signal(let_i,ori_i,xi,yi).image(:))/pixPerDeg^2;
                    signal(let_i,ori_i,xi,yi).rho=dot(signal(1,1,1,1).image(:),signal(let_i,ori_i,xi,yi).image(:))/pixPerDeg^2/sqrt(signal(1,1,1,1).E1.*signal(let_i,ori_i,xi,yi).E1);
                    signal(let_i,ori_i,xi,yi).pixArea=pixPerDeg^-2;
                end
            end
        end
    end
    fprintf(' done\n\n');
    
    logE1=log10([signal(:).E1]);
%     fprintf('signal log E1 : %.2f +- %.2f\n',mean(logE1),std(logE1));
%     fprintf('cross-correlation of signal(1,1) and signal(:,:)\n');

    if showLetters
%         if nOris > 1 || nX > 1 || nY > 1
            %%
%             signalImages = cat(3, signal(1:5,:,:,:).image);
%             signalImages_tiled = tileImages(signalImages);
%             figure(34); clf;
%             imagesc(signalImages_tiled); axis equal tight;
%             colormap('gray');
%             imageToScale;

            %%
            if length(signal(:)) <= 30
                %%
                figure(135 + set_idx);
                if font_loc_idx == 1
                    clf;
                end
                
                signalImages = cat(3, signal(:).image);
                signalImages_tiled = tileImages(signalImages, 1);
                subplotGap(8,1,font_loc_idx, 1)
                imagesc(signalImages_tiled); axis equal tight;
                set(gca, 'xtick', [], 'ytick', []);
                colormap('gray');
%                 imageToScale;
                3;
                if font_loc_idx == length(allFontNames)
                    imageToScale
                    3;
                end
            end
            
            
            figure(35 + set_idx);
            signalImages_all = cat(3, signal(:,:,:,:).image);
            subplot(2,8,font_loc_idx);    imagesc( log1p( sum(signalImages_all, 3) ) ); axis square;
            title(sprintf('%s [%d]', fontName, fontSize));
            if font_loc_idx == 3
                xlabel(sprintf('nOri = %d, nX = %d, nY = %d. Im = [%d x %d]', nOris, nX, nY, imageHeight, imageWidth));
            end

            all_used = sum(signalImages_all, 3) > 0;
            subplot(2,8,8+font_loc_idx);  imagesc(all_used); axis square;
            [idx_t, idx_b, idx_l, idx_r] = findLetterBounds(all_used);
            gap_t = idx_t-1;
            gap_b = imageHeight-idx_b;
            gap_l = idx_l-1;
            gap_r = imageWidth-idx_r;
            xlabel(sprintf('[%d, %d, %d, %d]', gap_t, gap_b, gap_l, gap_r), 'fontsize', 9)
            colormap('gray');
            
            3;
            
%         end
       
        return
    end
    
    [idxT, idxB, idxL, idxR] = findLetterBounds(cat(3, signal(:).image));
    signalBounds = [idxL, idxT, idxR, idxB];
    
    3;
    
    %%%%%%
    

    rand_seed = mod(fontSize * sum(fontName) * (imageHeight*imageWidth) * (Dx+1) *(Dy+1) * (nOris+1), 2^32);
        
    n = generateNoiseSamples(nNoiseSamples, noiseType, rand_seed);
    n.noiseSize=[imageHeight,imageWidth];
    
    
    
    if createPcaFiles
        %%
        allImageVecs_C = arrayfun(@(sig) sig.image(:), signal(:), 'un', 0);
        allImageVecs = [allImageVecs_C{:}]';
        meanImageVec = mean(allImageVecs,1);
       
        warning('off', 'stats:pca:ColRankDefX')
        fprintf('Doing PCA on original image set...'); tic;        
        switch pca_method
%             case 'PCA', [coeff, score, latent, ~,explained] = pca(allImageVecs); % 'NumComponents', nPCAcompsMax);
            case 'PCA', [coeff, score] = pca(allImageVecs); % 'NumComponents', nPCAcompsMax);
            case 'GLF',
        end
        fprintf(' done'); toc;
%        centdata = score*coeff';
%        allImageVecs_ms = bsxfun(@minus, allImageVecs, meanImageVec);
        
 
        showPCA = 0;
        if showPCA
            %%
            nUseful = nnz(explained > .1);
            coeff_stack = zeros(imageHeight, imageWidth, nUseful);
            for let_i = 1:nUseful
                coeff_stack(:,:,let_i) = reshape(coeff(:,let_i), imageHeight, imageWidth);
            end
            coeff_tiled = tileImages(coeff_stack);
            figure(101); clf;
            imagesc(coeff_tiled);
        end
        
        for sig_i = 1:length(signal(:))
            signal(sig_i).imageScore = score(sig_i,:)';
            % score_i = getPcaScore(signal(sig_i).image, meanImageVec, coeff);
            % assert(isequal(score_i, score(sig_i,:)'));
        end
        
    end
    
%     all_SNRs = [3];
    nRows = length(all_SNRs);

    params.logE1 = logE1;
    params.signalContrast = signalContrast;
    params.logEstimatedEOverNIdealThreshold = logEstimatedEOverNIdealThreshold;
    params.background = background;
    params.pixPerDeg = pixPerDeg;
    params.setSize = setSize;
    params.noise = n;
    
    params.orientations = orientations;
    params.xs = xs;
    params.ys = ys;
    params.fontSize = fontSize;
    params.fontName = fontName;
    
    
    
%     computeMiniSets = ~isempty(CPU_id);
    
    for cond_i = find( all_SNRs_toDo )
        fprintf('======= Now computing set #%d ==\n', cond_i);

        logSNR = all_SNRs(cond_i);

        
        logEOverN = logSNR+params.logEstimatedEOverNIdealThreshold;
        
        filename_image = getNoisyLetterFileName(fontName, logEOverN, noisy_letter_opts_image);
        
%         profile on;
        if ~all_SNRs_done_im(cond_i)  || true
            noisySet = generateNoisySamples(logSNR, signal, params);
            
        else
            noisySet_loaded = load( [noisyLettersPath_thisFont filename_image] );
            noisySet_loaded.signal = signal;
        end
        3; 
     
%         profile viewer;
        3;
        
        if createPcaFiles && all_SNRs_done_pca(cond_i)           
            noisySet = addPCAscoresToSet(noisySet, meanImageVec, coeff);

            show = 0;
            if show
%%
                nLettersPlot = 12;
                 let_colrs = jet(nLettersPlot);
                figure(102); clf; hold on; box on;
                for let_i = 1:nLettersPlot 
                    for xi = 1:nX
                        idx_i = find([noisySet.stimulus.whichSignal] == let_i & [noisySet.stimulus.whichX] == xi);
                        plot(noisySet.stimulusScores(idx_i,1), noisySet.stimulusScores(idx_i,2), '.', 'color', let_colrs(let_i,:) ); 
                    end
                    
                end
                for let_i = 1:nLettersPlot
                    for xi = 1:nX
                        text(score(let_i,1), score(let_i,2), upper(char('a'-1+let_i)), 'color', 'black');
                        xy = signal(let_i).imageScore;
                        hhh(let_i) = text(xy(1), xy(2), upper(char('a'-1+let_i)), 'color', 'black', 'fontweight', 'bold', 'fontsize', 12);
                    end
                    plot_xs = zeros(1,nX);
                    plot_ys = zeros(1,nY);
                    if nX > 1
                        for xi = 1:nX
                            plot_xs(xi) = signal(let_i, 1, xi).imageScore(1);
                            plot_ys(xi) = signal(let_i, 1, xi).imageScore(2);
                        end
                    elseif nOris > 1
                        for ori_i = 1:nOris
                            plot_xs(ori_i) = signal(let_i, ori_i, 1).imageScore(1);
                            plot_ys(ori_i) = signal(let_i, ori_i, 1).imageScore(2);
                        end
                        
                    end
                    plot(plot_xs, plot_ys, 'k-')
                end
                    3;
            end
            
        end
        drawnow;
        3;
        fprintf('Set %d. logSNR %5.2f, logEOverN %5.2f, signalContrast %.2f, noiseContrast %.3f\n', ...
            cond_i, logSNR, noisySet.logEOverN, noisySet.signalContrast,noisySet.noiseContrast);

        if createImageFiles && all_SNRs_toDo_im(cond_i)
            [noisySet.propLetterCorrect_ideal, noisySet.propEachLetterCorrect_ideal, noisySet.propOrientationCorrect_ideal, noisySet.propXYCorrect_ideal] = calcIdealPerformanceForSet(noisySet);
%             fprintf('On Full Image: correctLetter %.3f, correctOrientation %.3f, correctXY %.3f\n', ...
%                 noisySet.propLetterCorrect_ideal,noisySet.propOrientationCorrect_ideal,noisySet.propXYCorrect_ideal);
        end
        3;

        if createPcaFiles && all_SNRs_toDo_pca(cond_i)
            [noisySet.propLetterCorrect_ideal_PCA, noisySet.propEachLetterCorrect_ideal_PCA, noisySet.propOrientationCorrect_ideal_PCA, noisySet.propXYCorrect_ideal_PCA] = calcIdealPerformanceForSet(noisySet, nPcaScoresToTest);
        end

        %%
 %%
        labels = [noisySet.labels];

        setToSave = struct('fontName', fontName, 'fontSize', fontSize, 'fontSizeStyle', fontSizeStyle, 'date', datestr(now), ...
            'inputMatrix', [], 'labels', labels, 'signalMatrix', [], 'propLetterCorrect_ideal', [], ...
            'signalBounds', signalBounds, ...
            'orientations', orientations, 'xs', xs, 'ys', ys, 'imageSize', [imageHeight, imageWidth], ...
            'complexity_bool_mean', complexity_bool_mean, 'complexity_bool_all', complexity_bool_all, ...
            'complexity_grey_mean', complexity_grey_mean, 'complexity_grey_all', complexity_grey_all);  
    
        
        if createImageFiles && all_SNRs_toDo_im(cond_i)
            setToSave.inputMatrix = noisySet.inputMatrix;
            setToSave.propLetterCorrect_ideal=noisySet.propLetterCorrect_ideal;        
            setToSave.propEachLetterCorrect_ideal=noisySet.propEachLetterCorrect_ideal;        
            setToSave.signalMatrix = concatSignalImages(signal, precision);
            setToSave.logEOverNReIdeal = logSNR;
            setToSave.logEOverN = noisySet.logEOverN;
            setToSave.logE = noisySet.logE;
            setToSave.logN = noisySet.logN;
            setToSave.logE1 = params.logE1;
            setToSave.signalContrast = noisySet.signalContrast; 
            setToSave.noiseContrast = noisySet.noiseContrast;
            

%%
            filename_image = getNoisyLetterFileName(fontName, noisySet.logEOverN, noisy_letter_opts_image);
            
            fprintf('   => Saving Noisy Image data to file %s \n', filename_image)
            save([noisyLettersPath_thisFont filename_image], '-struct', 'setToSave', '-v6');
        end
                
        
        
        if createPcaFiles && all_SNRs_toDo_pca(cond_i)
 
            scoreSize = size(noisySet.stimulusScores,2);
            setToSave_PCA = setToSave;
            setToSave_PCA.nPcaScoresToTest = nPcaScoresToTest;
            setToSave_PCA.inputMatrix = reshape(noisySet.stimulusScores, [scoreSize, 1, setSize]);
            setToSave_PCA.signalMatrix = concatSignalImages(signal, precision, 1);
            setToSave_PCA.propLetterCorrect_ideal = noisySet.propLetterCorrect_ideal_PCA;            
            
            filename_PCA = getNoisyLetterFileName(fontName, noisySet.logEOverN, noisy_letter_opts_pca);
            fprintf('   => Saving Noisy PCA data to file %s \n', filename_PCA)
            save([noisyLettersPath_thisFont filename_PCA], '-struct', 'setToSave_PCA', '-v6');
        end
        
        
        
        if showSamplesWithNoise && createImageFiles && all_SNRs_done_im(cond_i)
            % Show the stimulus, signal, and stimulus minus signal, which should be just noise. One for each noisySet. 
            fig_id = set_idx*100 + font_loc_idx;
            
            figure(fig_id);
            if cond_i == 1
                clf
            end
            fig=1+3*(cond_i-1);
            rows=nRows;
            snImage=noisySet.stimulus(1).image;
            h_ax(cond_i) = subplot(rows,3,fig,'align'); imagesc(snImage); xlabel(filename_image, 'interp', 'none'); axis equal tight; %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
            which=noisySet.stimulus(1).whichSignal;
            whichOrientation=noisySet.stimulus(1).whichOrientation;
            whichX=noisySet.stimulus(1).whichX;
            whichY=noisySet.stimulus(1).whichY;
            sImage=noisySet.signal(which,whichOrientation,whichX,whichY).image;
            subplot(rows,3,fig+1,'align'); imagesc(sImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
            nImage=snImage-sImage;
            subplot(rows,3,fig+2,'align'); imagesc(nImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
%             energy=sum(sum((sImage-1).^2));
%             noiseLevel=var(nImage(:));
            caxis auto
            colormap('gray')
%         fprintf('cond %d, log E/N nominal %.2f, actual %.2f\n',cond,set.logEOverN,log10(energy/noiseLevel));
        end


%%
%         return
 
    end
     if showSamplesWithNoise && createImageFiles && any(all_SNRs_done_im)
         imageToScale
     end
    
%     fprintf('%s',readme);  
    fprintf('Done.\n');
    
end




function noisySet = generateNoisySamples(logEOverNReIdeal, signal, params)
  
%     noisySet.logSNR=logSNR;
%     
%     logN=logE-(logEOverNReIdeal+params.logEstimatedEOverNIdealThreshold);
%     noiseContrast=sqrt((10^logN)*(params.pixPerDeg)^2);
%     noisySet.logEOverN=logE-logN;
    
    [signalContrast, noiseContrast, logE, logN] = getSignalNoiseContrast(logEOverNReIdeal, params);
    noisySet.logE = logE;
    noisySet.logN = logN;
    noisySet.logEOverN = logE - logN;
    noisySet.signalContrast=params.signalContrast;
    noisySet.noiseContrast=noiseContrast;

    noisySet.background=params.background;

    %         fprintf('Set %d. logEOverNReIdeal %5.2f, logEOverN %5.2f, signalContrast %.2f, noiseContrast %.3f\n', background %.0f, cond, logEOverNReIdeal, logE-logN, signalContrast,noiseContrast);
    noisySet.signal=signal;
%     noisySet.signalBounds=signalBounds;
    for s=1:length(signal(:))
        noisySet.signal(s).image=signalContrast*signal(s).image;
    end

    [nLetters, nOris, nX, nY] = size(signal);
    
    n = params.noise;
    xs = params.xs;
    ys = params.ys;
    orientations = params.orientations;
    
%     flds = 'whichSginal', 'whichOrientation', 'whichX', 'whichY', 
    
    allStims = struct;
    
    for sample_i=1:params.setSize
        noise=RandSample(n.noiseList,n.noiseSize);
        %                 noise=Magnify2DMatrix(noise,checkPix);
        noiseImage=noiseContrast*noise;
%         if overflowCheck
%             fprintf('noise mean %.1f, sd %.1f, min %.1f, max %.1f\n',mean(noiseImage(:)),std(noiseImage(:)),min(noiseImage(:)),max(noiseImage(:)));
%         end
        whichSignal=randi(nLetters);
        whichOrientation=randi(nOris);
        whichX=randi(nX);
        whichY=randi(nY);
        s=noisySet.signal(whichSignal,whichOrientation,whichX,whichY).image;
        allStims(sample_i).image=noisySet.background+noiseImage+s;
        allStims(sample_i).whichSignal=whichSignal;
%         noisySet.stimulus(sample_i).text=textSignals(whichSignal);
        allStims(sample_i).orientation=orientations(whichOrientation);
        allStims(sample_i).whichOrientation=whichOrientation;
        allStims(sample_i).x=xs(whichX);
        allStims(sample_i).whichX=whichX;
        allStims(sample_i).y=ys(whichY);
        allStims(sample_i).whichY=whichY;
    end

    %         fprintf('%d ',cond);
    noisySet.fontSize=params.fontSize;
    noisySet.fontName=params.fontName;
    %         noisySet.bold=bold_tf;
    noisySet.orientations=orientations;
    noisySet.xs=xs;
    noisySet.ys=ys;
    noisySet.nLetters=nLetters;

    %%

    noisySet.inputMatrix  = single( cat(3, allStims.image) );
    noisySet.labels       = single( [allStims.whichSignal] );
    noisySet.inputOri_idx = single( [allStims.whichOrientation] );
    noisySet.inputX_idx   = single( [allStims.whichX] );
    noisySet.inputY_idx   = single( [allStims.whichY] );
    %%
    3;
    
end


function [propCorrectLetter, propCorrectEachLetter, propCorrectOrientation, propCorrectXY] = calcIdealPerformanceForSet(noisySet, nPcaScoresToTest)


    signalSize = size(noisySet.signal);
    nSignals = numel(noisySet.signal);
    [imageH, imageW] = size(noisySet.signal(1).image);
    
    [let_idxMtx, ori_idxMtx, x_idxMtx, y_idxMtx] = deal( zeros(signalSize) );
    for i = 1:nSignals
        [let_idxMtx(i), ori_idxMtx(i), x_idxMtx(i), y_idxMtx(i)] = ind2sub(signalSize, i);
    end
    
    testPCAuntilMatchesFullImage = 0;
        fracMatch = 0.99;
        alsoRequireOriandXY = 0;

    testOnPCA = nargin > 1;
        
    if ~testOnPCA
        %%
        signalTemplates = cat(3, noisySet.signal(:).image);
        signalTemplates = reshape( signalTemplates, [imageH*imageW, nSignals]);
        
%         signalTemplates_GPU = gpuArray(signalTemplates);
    else
        %%
        scoreSize = numel(noisySet.signal(1).imageScore);
        signalTemplates = cat(3, noisySet.signal(:).imageScore);
        signalTemplates = reshape( signalTemplates, [scoreSize, nSignals]);
%         signalTemplates_stk = reshape( signalTemplates_3D, [scoreSize, 1, nSignals]);
        allImageScores = noisySet.stimulusScores';
            

        if testPCAuntilMatchesFullImage
            propCorrectLetter_fullImage = noisySet.propLetterCorrect_ideal;
            propCorrectOrientation_fullImage = noisySet.propOrientationCorrect_ideal;
            propCorrectXY_fullImage = noisySet.propXYCorrect_ideal;
            doNExtra = 5;
        end
    end
    setSize = length(noisySet.labels);
%     allImages = cat(3, noisySet.stimulus.image);
%     allImages = reshape(allImages, [imageH*imageW, setSize]);
%     allImages_GPU = gpuArray(allImages);
    
%     allStimuli = [noisySet.stimulus];
    tic;
    if testOnPCA
        nPcaScoresToTest(nPcaScoresToTest > scoreSize) = [];
    else
        nPcaScoresToTest = nan;  % just need length to be 1, but won't use value.
    end
    nnPcaComps = length(nPcaScoresToTest);
    
    [nCorrectLetters, nCorrectOrientations, nCorrectXYs] = deal(  zeros(1, nnPcaComps) );

    %%
%     t1 = 0;
    assert(noisySet.background == 0);

    nCorrectEachLetter = zeros(nnPcaComps, nSignals);
    nEachLetter = zeros(nnPcaComps, nSignals);
    
    for n_comp_i = 1:nnPcaComps
        n_comp = nPcaScoresToTest(n_comp_i);

        test_str = iff(testOnPCA, sprintf(' (with %2d PCA components)', n_comp), '');
        fprintf('Testing ideal%s: ', test_str)

%         progressBar('init-', setSize, 30);
        nPBars = 25; step = setSize/nPBars;
        for stim_i = 1:setSize
%             s = allStimuli(stim_i);
            inputMtx_i = noisySet.inputMatrix(:,:,stim_i);

            if ~testOnPCA
                sumSqrErrs = sumSqrErrors(signalTemplates, inputMtx_i);
            else
                sumSqrErrs = sumSqrErrors(signalTemplates, allImageScores(:,stim_i), n_comp);
            end
%             if ~testOnPCA
%                 sqrErrors2 = bsxfun(@minus, signalTemplates, allImages(:,stim_i)).^2;    % templates: [nPix x nTemplates] - [1 x nPix] 
%                 sumSqrErrs2 = sum(sqrErrors2, 1);
%             else
%                 sqrErrors2 = bsxfun(@minus, signalTemplates(1:n_comp,:), allImageScores(1:n_comp,stim_i)).^2;  % templates: [nPCA x nTemplates] - [1 x nPCA] 
%                 sumSqrErrs2 = sum(sqrErrors2(1:n_comp,:), 1);
%             end
            
%             if ~testOnPCA
%                 errors3 = bsxfun(@minus, signalTemplates_GPU, allImages_GPU(:,stim_i));    % templates: [nPix x nTemplates] - [1 x nPix] 
%                 sqrErrors3 = errors3 .* errors3;
% %                 sumSqrErrs3a = sum(gather(sqrErrors3), 1);
%                 sumSqrErrs3 = sum(sqrErrors3, 1);
% 
%                 [~,idx_lowest_err2]=min(sumSqrErrs3);
%                 idx_lowest_err2 = gather(idx_lowest_err2);
% %                 assert(isequal(sumSqrErrs3a, sumSqrErrs3));
%             else
%                 sqrErrors3 = bsxfun(@minus, signalTemplates_GPU(1:n_comp,:), allImageScores(1:n_comp,stim_i)).^2;  % templates: [nPCA x nTemplates] - [1 x nPCA] 
%                 sumSqrErrs3 = sum(sqrErrors3(1:n_comp,:), 1);
%             end

            [~,idx_lowest_err]=min(sumSqrErrs);

%             mx = max(sumSqrErrs3(:));
%             assert(isequal(sumSqrErrs(:), sumSqrErrs2(:)))
%             assert( gather( max(abs( (sumSqrErrs(:) - sumSqrErrs3(:))/mx  ))) < 1e-4 )
%             assert(isequal(idx_lowest_err, idx_lowest_err2));
            
            let_i = let_idxMtx(idx_lowest_err);
            ori_i = ori_idxMtx(idx_lowest_err);
            xi    = x_idxMtx(idx_lowest_err);
            yi    = y_idxMtx(idx_lowest_err);

    %             [let_i2,ori_i2,xi2,yi2]=ind2sub(signalSize,idx_lowest_err);  % much slower
    %             assert(isequal([let_i, ori_i, xi, yi], [let_i2,ori_i2,xi2,yi2]))
            correctLabel_idx = noisySet.labels(stim_i);
    
            if let_i== correctLabel_idx
                nCorrectLetters(n_comp_i) = nCorrectLetters(n_comp_i)+1;
                nCorrectEachLetter(n_comp_i, correctLabel_idx) = nCorrectEachLetter(n_comp_i, correctLabel_idx)+1;
            end
            nEachLetter(n_comp_i, correctLabel_idx) = nEachLetter(n_comp_i, correctLabel_idx) + 1;
            
            if ori_i== noisySet.inputOri_idx(stim_i)  
                nCorrectOrientations(n_comp_i) = nCorrectOrientations(n_comp_i)+1;
            end
            if xi== noisySet.inputX_idx(stim_i) && yi==noisySet.inputY_idx(stim_i)
                nCorrectXYs(n_comp_i) = nCorrectXYs(n_comp_i) + 1;
            end

            if mod(stim_i, step) == 0
                fprintf('.');
            end
        end
        
%         fprintf('t1 = %.1f.   t2 = %.1f\n', t1, t2);

        prop_correct_letter_i = nCorrectLetters(n_comp_i)/setSize;
        prop_correct_ori_i = nCorrectOrientations(n_comp_i)/setSize;
        prop_correct_xy_i = nCorrectXYs(n_comp_i)/setSize;

        fprintf(' --> %.2f %% correct [oris: %.1f %%, xy: %.1f %%] ', prop_correct_letter_i*100, prop_correct_ori_i*100, prop_correct_xy_i*100);

        if testOnPCA && testPCAuntilMatchesFullImage

            matchedFullImagePerformance = (prop_correct_letter_i >= propCorrectLetter_fullImage * fracMatch);
            if alsoRequireOriandXY
                
                 matchedFullImagePerformance = matchedFullImagePerformance && ...
                     (prop_correct_ori_i >= propCorrectOrientation_fullImage * fracMatch) && ...
                     (prop_correct_xy_i >= propCorrectXY_fullImage * fracMatch);
            end
                
            if matchedFullImagePerformance
                if (doNExtra == 0) || (n_comp_i == nnPcaComps)
                    nCorrectLetters(n_comp_i+1:end) = [];
                    nCorrectOrientations(n_comp_i+1:end) = [];
                    nCorrectXYs(n_comp_i+1:end) = [];
                    break;
                else
                    doNExtra = doNExtra-1;
                end 
            end
        end
        
    end
    
        %            fprintf('signal(%d,%d,%d,%d) classified as %d,%d,%d,%d\n',s.whichSignal,s.whichOrientation,whichX,whichY,i,ori_i,xi,yi);
    
    
    
    %%
    t_elapsed = toc;
    fprintf('(took %s)\n', sec2hms(t_elapsed))
    propCorrectLetter = nCorrectLetters / setSize;
    propCorrectEachLetter = nCorrectEachLetter ./ nEachLetter;
    assert(sum(nCorrectEachLetter) == nCorrectLetters);
    assert(sum(nEachLetter) == setSize);

    propCorrectOrientation = nCorrectOrientations / setSize;
    propCorrectXY = nCorrectXYs / setSize;
    

        3;

end



function signalMatrix = concatSignalImages(signal, precision, useScoreFlag)
    useScore = nargin > 2 && isequal(useScoreFlag, 1);
    if ~useScore
        [height, width] = size(signal(1).image);
    else
        [height, width] = size(signal(1).imageScore);
    end

    [nLetters, nOris, nX, nY] = size(signal);
    signalMatrix = zeros(height, width, nLetters, nOris, nX, nY, precision);

    for let_i=1:size(signal,1)
        for ori_i=1:size(signal,2)
            for xi=1:size(signal,3)
                for yi=1:size(signal,4)
                    if ~useScore
                        signalMatrix(:,:,let_i,ori_i,xi,yi)=signal(let_i,ori_i,xi,yi).image;
                    else
                        signalMatrix(:,:,let_i,ori_i,xi,yi)=signal(let_i,ori_i,xi,yi).imageScore;
                    end
                end
            end
        end
    end

end


function noisySet = addPCAscoresToSet(noisySet, meanImageVec, coeff)
    [nH, nW] = size(noisySet.stimulus(1).image);
    setSize = length(noisySet.stimulus);
    allStimImages = reshape(cat(3, noisySet.stimulus(:).image), [nH*nW, setSize]);

    noisySet.stimulusScores = getPcaScore(allStimImages', meanImageVec, coeff);
    
%     for stim_i = 1:length(noisySet.stimulus(:))
%         noisySet.stimulus(stim_i).image = getPcaScore(noisySet.stimulus(stim_i).image, meanImageVec, coeff);
%     end

end

            

function score = getPcaScore(imageMtx, meanImageVec, coeff)
    if numel(imageMtx) == length(meanImageVec)
        centdata = imageMtx(:)' - meanImageVec;
    else % assume multiple rows
        centdata = bsxfun(@minus, imageMtx, meanImageVec);
    end
    score = centdata/coeff';

end
%{
        for s=noisySet.stimulus
            err = zeros(1, nSignals);
            for i=1:length(noisySet.signal(:))
                err(i)=sum(sum((s.image-noisySet.background-noisySet.signal(i).image).^2));
            end
            [~,i]=min(err);
            [i,ori_i,xi,yi]=ind2sub(size(noisySet.signal),i);
            if i==s.whichSignal
                correctLetter=correctLetter+1;
            end
            if ori_i==s.whichOrientation
                correctOrientation=correctOrientation+1;
            end
            if xi==s.whichX && yi==s.whichY
                correctXY=correctXY+1;
            end
            %            fprintf('signal(%d,%d,%d,%d) classified as %d,%d,%d,%d\n',s.whichSignal,s.whichOrientation,whichX,whichY,i,ori_i,xi,yi);
            trials=trials+1;
        end
%}


%{
switch fixedParameter 
        case 'imageSize', % reduce font size until it fits in the image
            
            w_max = imageWidth - Dx;
            h_max = imageHeight - Dy;
                        
            if nOris == 1
                relevant_w = fontSizeData.fontBoxW;
                relevant_h = fontSizeData.fontBoxH;
            elseif nOris > 1
                relevant_w = fontSizeData.fontBoxW_rot;
                relevant_h = fontSizeData.fontBoxH_rot;
            end
            idx_largest = find( relevant_w  <= w_max & relevant_h  <= h_max, 1, 'last');
            if isempty(idx_largest)
                error('No fonts are small enough for this image')
            end
            fontSize = fontSizeData.fontSizes(idx_largest);      
            fprintf('Selecting fontSize = %d (with box size %dx%d < %dx%d) for font %s\n', ...
                fontSize, relevant_h(idx_largest), relevant_w(idx_largest), h_max, w_max);
            
        case {'fontSize', 'manual'}, % choose image size to fit the selected font size
            cur_size_idx = find(fontSizeData.fontSizes == fontSize,1);
            if nOris == 1
                w_needed = fontSizeData.fontBoxW(cur_size_idx);
                h_needed = fontSizeData.fontBoxH(cur_size_idx);
            elseif nOris > 1
                w_needed = fontSizeData.fontBoxW_rot(cur_size_idx);
                h_needed = fontSizeData.fontBoxH_rot(cur_size_idx);
            end
            
            w_needed = w_needed + Dx;
            h_needed = h_needed + Dy;
            
            if strcmp(fixedParameter, 'fontsize')
                if requireSquareImage
                    [imageHeight, imageWidth] = deal(max(w_needed, h_needed));
                else
                    [imageHeight, imageWidth] = deal(h_needed, w_needed);
                end
                fprintf('Selecting imageSize = %dx%d (to accomodate box size (%dx%d) for font %s, size %d\n', ...
                    imageHeight, imageWidth, h_needed, w_needed, fontName, fontSize);
            elseif strcmp(fixedParameter, 'manual') 
                if (w_needed > imageWidth) || (h_needed > imageHeight) 
                    error('Font size %d (requiring box size %d x %d) is too large for image (%d x %d)', fontSize, h_needed, w_needed, imageHeight, imageWidth)
                else
                    fprintf(' [Using font size %d (requiring box size %d x %d) will fit in image (%d x %d)]\n', fontSize, h_needed, w_needed, imageHeight, imageWidth)
                end
            end

        otherwise
            error('Unknown option')

    end

%}


%{

%     multipleOris = nOris > 1;
%     multiplePositions = nX > 1  ||  nY > 1;
%     if ~multipleOris && ~multiplePositions
%         uncertainty = 'none';
%     elseif multipleOris && multiplePositions
%         uncertainty = 'spatial&rotational';
%     elseif multipleOris 
%         uncertainty = 'rotational';
%     elseif multiplePositions
%         uncertainty = 'spatial';
%     end

%     switch uncertainty
%         case 'none',
%             imageHeight_min = 36;
%             imageWidth_min  = 36;
%             
%         case 'spatial',
%             imageHeight_min = 46;
%             imageWidth_min  = 46;
% 
%         case 'rotational',
%             imageHeight_min = 40;
%             imageWidth_min  = 40;
%             
%         case 'spatial&rotational',
%             imageHeight_min = 51;
%             imageWidth_min  = 51;
%     end

%}

%{
        %%
        if useTorchTensorSizes  % ** are already in correct order for torch **
%             signal_permute_dims = 1:ndims(signalMatrix);
%             signal_permute_dims(1:2) = [2,1];  
%             signalMatrix = permute(signalMatrix,  signal_permute_dims);
%             inputMatrix = permute(inputMatrix, [2 1 3]);
%             inputMatrix = reshape(inputMatrix, [imageWidth, imageHeight, 1, setSize]);            
        end
%}


%{

                
        readme=sprintf([...
            'MATLAB save file "%s.mat" \n' ...
            'has %d target images at SNR log E/N %.2f,\n'...
            '%d possible letters, %s font, size %d, %d orientations, %d xs, %d ys\n'...
            'signalContrast %.3f, noiseContrast %.3f, background %.1f \n'...
            'The optimal classifier correctly identifies %.3f of these targets.\n'...
             'The file contains several arrays and a text string:\n\n' ...
            '"readme" contains this explanatory text.\n' ...
            '"signalMatrix" is a %dx%dx%dx%dx%dx%d matrix, the indices (x,y,i,io,xi,yi) represent\n'...
            '     horizontal, vertical, which letter, which orientation, which x offset, which y offset.\n' ...
            '"inputMatrix" is a %dx%dx%d matrix containing %d %dx%d images to be classified.\n' ...
            '     Each target image is a signal plus noise.\n' ...
            '"labels" contains the letter index (1 to %d) for each target. \n' ...
            '     This is the correct classification to be learned or tested.\n'...
            '"propLetterCorrect_ideal" is the performance %.3f of the ideal classifier on these targets.\n'...
            '"signalBounds" is a rect, a 4-element array [xmin,ymin,xmax,ymax]=[%d,%d,%d,%d], indicating\n' ...
            '     the zero-based min and max of the x and y coordinates of letter\n'...
            '     ink among all the signal images.\n' ...
            '"signal" is a %dx%dx%dx%d-element struct array, with one struct per letter and condition. The struct \n' ...
            '     includes the name ("string") and "image".\n' ...
            '\nNote that the optimal classifier''s threshold is roughly 1.0 log E/N, \n' ...
            'and the human threshold is roughly 2.0 log E/N.\n'...
            ],filename,length(noisySet.stimulus),noisySet.logEOverN,...
            length(signal),fontName,fontSize,length(noisySet.orientations),length(noisySet.xs),length(noisySet.ys),...
            noisySet.signalContrast,noisySet.noiseContrast,noisySet.background,noisySet.propLetterCorrect_ideal,...
            size(signalMatrix,1),size(signalMatrix,2),size(signalMatrix,3),size(signalMatrix,4),size(signalMatrix,5),size(signalMatrix,6),...
            size(inputMatrix),size(inputMatrix,3),size(inputMatrix,1),size(inputMatrix,2), ...
            size(signal,1),...
            propLetterCorrect_ideal,...
            signalBounds,...
            size(signal,1),size(signal,2),size(signal,3),size(signal,4));
%}