function crowdedSet = generateSetOfCrowdedLetters(signal, params)
    
  
    [nLettersTot, nX, nY, nOri] = size(signal);
    
    logSNR = params.logSNR;
    [signalContrast, noiseContrast] = getSignalNoiseContrast(logSNR, params);    
    
    
    addDistractors = isfield(params, 'nDistractors') && params.nDistractors > 0;    
    
    if addDistractors
        nDistractors = params.nDistractors;
        distractorSpacing = params.distractorSpacing;
        distractContrast = signalContrast * (10^ params.logTDR);
    else
        nDistractors = 0;
    end
    targetPosition = params.targetPosition;
    
    
    
    noiseSamples = params.noiseSet;
    
    blurImage = isfield(params, 'blurStd') && params.blurStd > 0;
    if blurImage
        blurStd = params.blurStd;
    end
    %%
    
    nPBars = 25; step = params.setSize/nPBars;
    tic;
        
    setSize = params.setSize;
    
    
    xs = params.xs;
    
    if nDistractors == 0
        xs_available_idx = 1:length(xs);
        
    elseif nDistractors > 0
        
        xs_withSpacingOnRight = 1:length(xs) >= distractorSpacing+1;
        xs_withSpacingOnLeft  = 1:length(xs) <= length(xs) - distractorSpacing;
        if nDistractors == 1
            xs_available_idx = find( xs_withSpacingOnLeft | xs_withSpacingOnRight);
        elseif nDistractors == 2
            xs_available_idx = find( xs_withSpacingOnLeft & xs_withSpacingOnRight);
        end
    end
    
    xs_available = xs(xs_available_idx);
    nXs_available = length(xs_available);

    
    for sample_idx=1:setSize
        
        targetLetter_idx = randi(nLettersTot);  

        if strcmp(targetPosition, 'all')
            target_x_idx_idx = randi(nXs_available);
            target_x_idx = xs_available_idx(target_x_idx_idx);
        elseif isnumeric(targetPosition)
            target_x_idx = targetPosition;
        end
        
        target_y_idx   = randi(nY);

        target_ori_idx = randi(nOri);
        
        target_image = signal(targetLetter_idx, target_x_idx, target_y_idx, target_ori_idx).image;
        if signalContrast ~= 1
            target_image = target_image * signalContrast;
        end
        
        new_image = target_image;

                    
        if nDistractors > 0
            distract_let_idx = randi(nLettersTot, [1, nDistractors]);

            xs_distract_options = [target_x_idx - distractorSpacing, target_x_idx + distractorSpacing];
            xs_distract_options = xs_distract_options( xs_distract_options >= 1 & xs_distract_options <= length(xs));
        end
        
        for d_i = 1:nDistractors
        
            if nDistractors == 1  % pick one of the two sides randomly
                distract_x_idx_idx = randi(size(xs_distract_options));
            else  % on first iteration, pick left slot; on second iteration, pick right slot
                distract_x_idx_idx = d_i; 
            end
            
            distract_x_idx = xs_distract_options(distract_x_idx_idx);
                        
            distract_y_idx   = randi(nY);
            
            distract_ori_idx   = randi(nOri);

            
            distract_image = signal(distract_let_idx(d_i), distract_x_idx, distract_y_idx, distract_ori_idx).image;

            assert( ~any(distract_image(:) & target_image(:) ) );

            new_image = new_image + distract_image * distractContrast;

            
            x_dist_pix_signed = xs(distract_x_idx)-xs(target_x_idx);
            
            dist_sign = sign(x_dist_pix_signed);               
            x_dist_pix = abs(x_dist_pix_signed);
        end
        
        if logSNR > 0 % add random gaussian noises
            noiseImage = qRandSample(noiseSamples.noiseList,  noiseSamples.noiseSize);
            new_image = new_image + noiseContrast * noiseImage;
        end
        
        if blurImage
            nonBlurredImage = new_image;
            new_image = gaussSmooth( gaussSmooth(new_image, blurStd, 1), blurStd, 2);            
        end

        
        show = 0;
        if show
            %%
            figure(21); clf;
%             subplot(1,2,1);
%             imagesc(signal_i.image); axis equal tight;
%             title(sprintf('Sample %d', sample_idx));
% 
%             subplot(1,2,2);
            imagesc(new_image); axis equal tight;
            colormap('gray');
%             imageToScale;
            3;
        end
   
        stim_i.image  = single( new_image );
        stim_i.targetLetter_idx = single(targetLetter_idx);
        stim_i.target_x_idx = single( target_x_idx     );
        stim_i.target_y_idx = single( target_y_idx     );
    
        if blurImage
            stim_i.nonBlurredImage = nonBlurredImage;
        end
                
        if nDistractors > 0    
            stim_i.distractLetter_idx=distract_let_idx(1);
            stim_i.x_dist = distractorSpacing;
            stim_i.x_dist_pix = x_dist_pix;
            stim_i.dist_sign = dist_sign;
        end
        if nDistractors > 1
            stim_i.distractLetter_idx2=distract_let_idx(2);
        end
        

        crowdedSet.stimulus(sample_idx) = stim_i;
%         if sample_idx == 1
%             crowdedSet.stimulus(setSize) = blankStruct(stim_i);
%         end

        if mod(sample_idx, step) == 0
            fprintf('.');
        end

    end
     
    
    
    fprintf(' done. '); toc;
        
    crowdedSet.fontSize=params.fontSize;
    crowdedSet.fontName=params.fontName;

%     crowdedSet.orientations=orientations;
    crowdedSet.xs=params.xs;
    crowdedSet.ys=params.ys;
    crowdedSet.orientations = params.orientations;
    crowdedSet.shapes=nLettersTot;

end



%{

    nCombs = nLettersTot ^ (nDistractors + 1);
    doRandomSamples = 1; %nCombs > params.setSize;
    if ~doRandomSamples
        if nDistractors == 1
            allIndexCombos = generateAllCombos([2, nLettersTot, nLettersTot]);
        end
    end
%}