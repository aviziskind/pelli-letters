function [meanComplexity, complexities, area, perim, calc_images] = calculateFontComplexity(signalMatrix, CALC_MODE, show_flag)
    nClasses = size(signalMatrix, 3);
    % CALC_MODE;
    %  0 - original algorithm, using boolean values (black/white)
    %  1 - version 2, which still only works on black/white images but is more consistently scale-invariant 
    %  2 - version 3, which is scale-invariant and can be used for grayscale images.
%     global corner_scl
    
    
    if nargin < 2
        CALC_MODE = 2;
    end
    complexities = zeros(1, nClasses);
    if nargin < 3
        show_flag = 0;
    end
    
    minMargin = 2;
    signalMargins = getSignalMargin(signalMatrix);
    if any(signalMargins < minMargin)
        signalMatrix = addMargin(signalMatrix, minMargin);
    end
%     if fi
    3;
    
    normalizeImages = 1;
   
    for let_i = 1:nClasses
        letter_i = signalMatrix(:,:,let_i,1,1,1);
        % normalize letter image:
        if normalizeImages
            min_val = min(letter_i(:));
            max_val = max(letter_i(:));
            letter_i = (letter_i-min_val)/(max_val-min_val);
        end
        if CALC_MODE == 0 || CALC_MODE == 1
            letter_i(letter_i > 0) = 1; % set to boolean value
        end
        
        area = countActivePixels(letter_i, CALC_MODE, 1);
        [perim, calc_images] = calculatePerimeter(letter_i, CALC_MODE, area, show_flag);
        complexities(let_i) = perim*perim / area;
    end
    meanComplexity = mean(complexities);
        
end


function count = countActivePixels(imageMtx, CALC_MODE, sqr_tf)
    if sqr_tf
        imageMtx = imageMtx.^2;
    end
    switch CALC_MODE
        case 0, count = nnz(imageMtx > 0);
        case {1,2}, count = sum(imageMtx(:)); % grayscale
%         case 2, count = sum(imageMtx(:));
    end
                
end

function imageMtxShifted = OR_shifted(imageMtx, CALC_MODE, corner_scl)
    
    [m,n] = size(imageMtx);
%     shiftedUp   = imageMtx(2:w,:);
%     shiftedDown = imageMtx(1:w-1,:);
%     shiftedLeft = imageMtx(:,2:w);
%     shiftdRight = imageMtx(:,1:w-1);

    imageMtxShifted = imageMtx;
        
    for i = 2:m-1 
        for j = 2:n-1
            if CALC_MODE > 0
               imageMtxShifted(i,j) = (imageMtxShifted(i,j) + ...
                    imageMtx(i-1,j) + imageMtx(i+1,j) + imageMtx(i,j-1) + imageMtx(i,j+1)) + ...
                    corner_scl * (imageMtx(i-1,j-1) + imageMtx(i-1,j+1) + imageMtx(i+1,j-1) + imageMtx(i+1,j+1));
                
            else
                imageMtxShifted(i,j) = imageMtxShifted(i,j) || ...
                    imageMtx(i-1,j) || imageMtx(i+1,j) || imageMtx(i,j-1) || imageMtx(i,j+1);
            end
        end
    end
    
    % remove edge effects.
    imageMtxShifted(1,:) = imageMtx(1,:)*5;
    imageMtxShifted(:,1) = imageMtx(:,1)*5;
    imageMtxShifted(end,:) = imageMtx(end,:)*5;
    imageMtxShifted(:,end) = imageMtx(:,end)*5;

    imageMtxShifted(1,:) = 0;
    imageMtxShifted(:,1) = 0;
    imageMtxShifted(end,:) = 0;
    imageMtxShifted(:,end) = 0;
    
%     v = imageMtxShifted(2,2);
%     imageMtxShifted(1,:) = v;
%     imageMtxShifted(end,:) = v;
%     imageMtxShifted(:,1) = v;
%     imageMtxShifted(:,end) = v;
3;
    
    
end
    
function bitCleared = bitClear(image1, image2, CALC_MODE, corner_scl)
    
    switch CALC_MODE
        case 0, 
            bitCleared = image1 & ~image2;
        case 1, 
            bitCleared = image1;
            bitCleared(image2>0) = 0;
        case 2, 
            s = 1 + 4 + corner_scl*4;
            bitCleared = abs(image1 - image2*s);
            
            
    end
    
end
    
function [perimeter, calc_images] = calculatePerimeter(origLetterImage, CALC_MODE,area, show_flag)
    if CALC_MODE == 2
        corner_scl = 1/2;
    else
        corner_scl = 0;
    end
        

    imageShifted = OR_shifted(origLetterImage, CALC_MODE, corner_scl);
    image_bitCleared = bitClear(imageShifted, origLetterImage, CALC_MODE, corner_scl);
    image_bitCleared_shifted = OR_shifted(image_bitCleared, CALC_MODE, 0);
    wide_perimeter = countActivePixels(image_bitCleared_shifted, CALC_MODE, 0);
    calc_images = {imageShifted, image_bitCleared, image_bitCleared_shifted};
    if CALC_MODE == 2
        perimeter = wide_perimeter/10;
    elseif CALC_MODE == 1
        perimeter = wide_perimeter/5;
    else
        perimeter = wide_perimeter/3;
    end
    c = perimeter^2 / area;
%%
    show = show_flag; %CALC_MODE == 2;
    if show 
        %%
        s = @(XX) sprintf('[%.1f - %.1f]', lims(XX));
        shft_name = iff(CALC_MODE, 'Plus-shifted', 'OR-shifted');
        btclr_name = iff(CALC_MODE==2, 'abs(Subtract Orig*5)', 'Bit-clear with orig');
        figure(10+CALC_MODE);  clf;
        image_func = @imagesc;
%         image_func = @pcolor;
%         doColorbar = 0;
        h_ax(1) = subplot(1,4,1); image_func(origLetterImage);                  
                    title({'Original', s(origLetterImage)});   
%                     title('Original');   
                    axis square;  colorbar('location', 'southoutside')
        h_ax(2) = subplot(1,4,2); image_func(imageShifted);                    
                    title({shft_name, s(imageShifted)});
%                     title(shft_name);
                    axis square;colorbar('location', 'southoutside')
        h_ax(3) = subplot(1,4,3); image_func(double(image_bitCleared));         
                    title({btclr_name, s(image_bitCleared)}); 
%                     title('bit-cleared with orig'); 
                    axis square; colorbar('location', 'southoutside')
        h_ax(4) = subplot(1,4,4); image_func(double(image_bitCleared_shifted)); 
                    title({[shft_name ' again'], s(image_bitCleared_shifted)}); 
%                     title([shft_name ' again']); 
                    axis square;colorbar('location', 'southoutside')
%         xlabel(sprintf('c = %.1f', c))
        3;
        set(h_ax, 'xtick', [], 'ytick', [])
%         for i = 1:4
%             curLims = get(h_ax(i), 'clim');
%             newLims = max(abs(curLims))*[-1, 1];
%             set(h_ax(i), 'clim', newLims);
%         end
        
        colormap(gray);
        3;
    end
    3;

end

    
    

function signalMargins = getSignalMargin(signalMatrix)

    sumSignal = sum(signalMatrix,3);
    rows = sum(sumSignal, 1);
    cols = sum(sumSignal, 2);
    left_margin = find(rows, 1, 'first') -1;
    right_margin = length(rows) - find(rows, 1, 'last');
    top_margin = find(cols, 1, 'first') -1;
    bottom_margin = length(cols) - find(cols, 1, 'last');
    
    signalMargins = [left_margin, right_margin, top_margin, bottom_margin];
    
end

function newSignalMatrix = addMargin(signalMatrix, marginWidth)

    % take margin value to be median of all values on the border
    borderVals_r = [signalMatrix(1,:,:); signalMatrix(end,:,:)]; 
    borderVals_c = [signalMatrix(:,1,:); signalMatrix(:,end,:)];
    medianBorderVal = median([borderVals_r(:); borderVals_c(:)]);

    [m,n, nLet] = size(signalMatrix);
    new_m = m + marginWidth*2;
    new_n = n + marginWidth*2;

    newSignalMatrix = ones(new_m, new_n, nLet)*medianBorderVal;
    idx_rows = [1:m] + marginWidth;
    idx_cols = [1:n] + marginWidth;
    
    newSignalMatrix(idx_rows, idx_cols, :) = signalMatrix;    

end