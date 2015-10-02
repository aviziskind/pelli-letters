function createPixelVarianceDatafile(squareSize, nSquares, snr)

%     allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'BookmanBold', 'BookmanUpper', 'Georgia', 'Yung', 'Kuenstler'};
    % pelli complexity:    28,            65         67          100,       107         57          139                        199       451  

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   unrotated   rot 5,     rot 10    rot 15   rot 20 
%     defaultFontSize.Braille      =  9; % 20 x 29.  29 x 21,  31 x 23,  31 x 25,  33 x 27.   C0 = 27  C2 = 28
%     defaultFontSize.Sloan        = 16; % 28 x 29.  29 x 31,  31 x 31,  33 x 33,  35 x 35.   C0 = 42  C2 = 43
%     defaultFontSize.Helvetica    = 20; % 33 x 25.  33 x 25,  35 x 27,  35 x 29,  35 x 29.   C0 = 49  C2 = 55
%     defaultFontSize.Bookman      = 18; % 32 x 30.  31 x 31,  32 x 31,  33 x 31,  33 x 33.   C0 = 55  C2 = 63
%     defaultFontSize.GeorgiaUpper = 16; % 26 x 31.  27 x 33,  28 x 33,  30 x 35,  32 x 37.   C0 = 59  C2 = 85
%     defaultFontSize.Courier      = 21; % 32 x 24.  32 x 25,  32 x 25,  34 x 29,  34 x 31.   C0 = 78  C2 = 121
%     defaultFontSize.Yung         = 21; % 32 x 32.  32 x 32,  33 x 32,  34 x 34,  34 x 34.   C0 = 78  C2 = 114
%     defaultFontSize.Kuenstler    = 14; % 24 x 33.  25 x 33,  27 x 35,  30 x 36,  32 x 37.   C0 = 83  C2 = 286


    if ~exist('squareSize', 'var') || isempty(squareSize)
        squareSize = 10;
    end
    
    if ~exist('nSquares', 'var') || isempty(nSquares)
        nSquares = 9;
    end
    
    if ~exist('snr', 'var') || isempty(snr)
        snr = 2;
    end

    
    sepWidth_pix = 1;
       
    % c1 = target centered, 1 distractor
    % c2 = target centered, 2 distractor
    % r1 = target random position, 1 distractor (only space for 1)
    

    precision = 'single'; precision_func = @single;
    
    
    noiseType = 'gaussian';
    nNoiseSamples = 1e5;
    noiseSamples = generateNoiseBank(nNoiseSamples, noiseType);
    noiseSize = [squareSize, squareSize];

%     rand_seed = mod(fontSize * sum(fontName) * (imageHeight*imageWidth) * (Dx+1) *(Dy+1) * (nOris+1), 2^32);
%     rng(rand_seed);
    nSquares_side = sqrt(nSquares);
    

    
        
    figure(4); clf; imagesc(X);
    colormap('gray')
    3;
    
    %%

    
    
    varianceSquaresPath = [datasetsPath 'VarianceSquares' filesep]; % 'sz32x32' filesep];
    if ~exist(varianceSquaresPath, 'dir')
        mkdir(varianceSquaresPath)
    end
    
     

    params.setSize = 1000;
    params.sepWidth_pix = sepWidth_pix;
    params.noiseSamples = noiseSamples;
    params.nSquares_side = nSquares_side;
    params.squareSize = squareSize;
    
    
       
%     computeMiniSets = ~isempty(CPU_id);
%     allLogSNRs_min = -2;
%     allLogSNRs = [-2, -1, -.75, -0.5, -0.25,  0];
    all
    allLogSNRs = [-2, -1, 0, 1, 2, ];
%     allLogSNRs = 0;
   
    
    
    allLogSNRs_save = allLogSNRs;

    fprintf('======= Now computing multiple-letter sets \n');

    for snr_i = 1:length(allLogSNRs)
%%    
        testing_filename = getCrowdedLetterFileName('Test', fontName, crowdedLetterOpts, allLogSNRs_save(snr_i));

        fprintf('logSNR = %.2f [%s] : ', allLogSNRs(snr_i), testing_filename)
        set = generateCrowdedSamples(signal, allLetters, params, allLogSNRs(snr_i), targetPosition, nDistractors);
        
        testSetSamples = cat(3, set.stimulus(:).image);
        labels_signal = [set.stimulus.whichSignalLetter];
        labels_distract = [set.stimulus.whichDistractLetter];
        if nDistractors == 2
            labels_distract2 = [set.stimulus.whichDistractLetter2];
            labels2_C = {'labels_distract2', labels_distract2};
        else
            labels2_C = {};
        end
        x_dist = precision_func([set.stimulus.x_dist]);
        dist_sign = precision_func([set.stimulus.dist_sign]);
        
          
      
        S_test = struct('inputMatrix', testSetSamples, 'labels_signal', labels_signal, 'labels_distract', labels_distract, labels2_C{:}, ...
            'xs', xs, 'ys', ys, 'fontName', fontName, 'fontSize', fontSize, 'logSNR', allLogSNRs(snr_i), 'nLetters', nLetters, ...
            'x_dist', x_dist, 'dist_sign', dist_sign); %#ok<NASGU>
%         save([crowdedLettersPath testing_filename], '-struct', 'S_test', '-v6')
%%
        showSamples = 1;
        if showSamples
            % Show the stimulus, signal, and stimulus minus signal, which should be just noise. One for each set. 
            fig_id = 50;

            figure(fig_id);
            if snr_i == 1
                clf;
            end
            fig=1+3*(snr_i-1);
            rows=length(allLogSNRs);
            snImage=set.stimulus(1).image;
            h_ax(snr_i) = subplot(rows,3,fig,'align'); imagesc(snImage); xlabel(testing_filename, 'interp', 'none'); axis equal tight; %#ok<AGROW,NASGU> % set(h_ax(1), 'xtick', [], 'ytick', [])
            whichSignalLetter=set.stimulus(1).whichSignalLetter;
            whichX=set.stimulus(1).whichX;
            whichY=set.stimulus(1).whichY;
            sImage=signal(whichSignalLetter,whichX,whichY).image;
            subplot(rows,3,fig+1,'align'); imagesc(sImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
            nImage=snImage-sImage;
            subplot(rows,3,fig+2,'align'); imagesc(nImage); axis equal tight; %set(gca, 'xtick', [], 'ytick', []);
        %             energy=sum(sum((sImage-1).^2));
        %             noiseLevel=var(nImage(:));
            caxis auto
            colormap('gray')
        %         fprintf('cond %d, log E/N nominal %.2f, actual %.2f\n',cond,set.logEOverN,log10(energy/noiseLevel));
        3;
        end


    end
%%
%         return
 
    
%     fprintf('%s',readme);  
    fprintf('Done.\n');
    
end



% 
% function new_image = addToImage(orig_image, letter_idx, position, allLetters)
% 
% 
% end





function noisySet = createNoisySquarePatches(params)

    setSize = params.setSize;
    nSquares_side = params.nSquares_side;
    squareSize = params.squareSize;
    sepWidth_pix = params.sepWidth_pix;
    snr = params.snr;

    var_signal = 1;
    var_noise = 1/snr;


    nSquaresTot = nSquares_side^2;
    

    imageSize = squareSize * nSquares_side + sepWidth_pix * (nSquares_side + 1);
%%
    X = zeros(imageSize, imageSize, params.setSize);
    allLabels = randi(nSquaresTot, setSize);

    for samp_i = 1:setSize

        X_i = zeros(imageSize, imageSize);
        
        target_idx = allLabels(samp_i);
        [target_j, target_i] = ind2sub([nSquares_side, nSquares_side], target_idx);

        for i = 1:nSquares_side

            i_idx = [1:squareSize] +  squareSize * (i-1) + sepWidth_pix * (i);
            for j = 1:nSquares_side

                j_idx = [1:squareSize] +  squareSize * (j-1) + sepWidth_pix * (j);

                if (i == target_i) && (j == target_j) 
                    var_cur = var_signal;
                else
                    var_cur = var_noise;
                end

                noise_im = RandSample(n.noiseList, noiseSize) * sqrt(var_cur);

                X_i(i_idx, j_idx) = noise_im;

            end
        end

        X(:,:,samp_i) = X_i;
    end

    noisySet.inputMatrix = X;
    noisySet.labels = allLabels;
end
