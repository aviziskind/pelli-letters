function [meanComplexity, complexities, areas, perims, calc_images] = calculateFontComplexity(signalMatrix, CALC_MODE, show_flag)
    signalMatrix = double(signalMatrix);
    nClasses = size(signalMatrix, 3);
    % CALC_MODE;
    %  0 - original algorithm, using boolean values (black/white)
    %  1 - version 2, which still only works on black/white images but is more consistently scale-invariant 
    %  2 - version 3, which is scale-invariant and can be used for grayscale images.
    
    if nargin < 2
        CALC_MODE = 2;
    end
    complexities = zeros(1, nClasses);
    areas = zeros(1,nClasses);
    perims  = zeros(1,nClasses);
    if nargin < 3
        show_flag = 0;
    end
    
    minMargin = 2;
    signalMargins = getSignalMargin(signalMatrix);
    if any(signalMargins < minMargin)
        signalMatrix = padarray(signalMatrix, minMargin, 0, 'both');
%         signalMatrix  = addMarginToSignal(signalMatrix, minMargin);
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
        
        if CALC_MODE == 4
            complexities(let_i) = getFourierComplexity(letter_i);
        else

            areas(let_i) = countActivePixels(letter_i, CALC_MODE, 0);
            [perims(let_i), calc_images] = calculatePerimeter(letter_i, CALC_MODE, areas(let_i), show_flag);
            complexities(let_i) = perims(let_i)^2 / areas(let_i);
        end
    end
    meanComplexity = mean(complexities);
        
end


function count = countActivePixels(imageMtx, CALC_MODE, sqr_tf)
    if sqr_tf
        imageMtx = imageMtx.^2;
    end
    switch CALC_MODE
        case 0, count = nnz(imageMtx > 0);
        case {1,2,3}, count = sum(imageMtx(:)); % grayscale
%         case 2, count = sum(imageMtx(:));
    end
                
end

function imageMtxShifted = OR_shifted(imageMtx, CALC_MODE)
    
    [m,n] = size(imageMtx);
    s = 1;
    shiftedUp   = [imageMtx(1+s : m,:); zeros(s, n)];
    shiftedDown = [zeros(s, n);   imageMtx(1:m-s,:)];

    shiftedLeft = [imageMtx(:,1+s:n), zeros(m,s)];
    shiftedRight = [zeros(m,s), imageMtx(:,1:n-s)];

    p = 1.7;
    if CALC_MODE == 0
        imageMtxShifted = imageMtx | shiftedUp | shiftedDown | shiftedLeft | shiftedRight;
    elseif CALC_MODE == 1 || CALC_MODE == 2 
        imageMtxShifted = imageMtx + shiftedUp + shiftedDown + shiftedLeft + shiftedRight;
    elseif CALC_MODE == 3
        imageMtxShifted = abs(imageMtx - shiftedUp).^p + abs(imageMtx - shiftedDown).^p + ... 
                          abs(imageMtx - shiftedLeft).^p + abs(imageMtx - shiftedRight).^p;
    end

    % old method
%     imageMtxShifted = imageMtx;
%         
%     for i = 2:m-1 
%         for j = 2:n-1
%             if CALC_MODE > 0
%                imageMtxShifted(i,j) = (imageMtxShifted(i,j) + ...
%                     imageMtx(i-1,j) + imageMtx(i+1,j) + imageMtx(i,j-1) + imageMtx(i,j+1));
%             else
%                 imageMtxShifted(i,j) = imageMtxShifted(i,j) || ...
%                     imageMtx(i-1,j) || imageMtx(i+1,j) || imageMtx(i,j-1) || imageMtx(i,j+1);
%             end
%         end
%     end
%     
%     assert(isequal(imageMtxShifted, imageMtxShifted2));
    
    % remove edge effects.
%     imageMtxShifted(1,:) = imageMtx(1,:)*5;
%     imageMtxShifted(:,1) = imageMtx(:,1)*5;
%     imageMtxShifted(end,:) = imageMtx(end,:)*5;
%     imageMtxShifted(:,end) = imageMtx(:,end)*5;
% 
%     imageMtxShifted(1,:) = 0;
%     imageMtxShifted(:,1) = 0;
%     imageMtxShifted(end,:) = 0;
%     imageMtxShifted(:,end) = 0;
    
%     v = imageMtxShifted(2,2);
%     imageMtxShifted(1,:) = v;
%     imageMtxShifted(end,:) = v;
%     imageMtxShifted(:,1) = v;
%     imageMtxShifted(:,end) = v;
3;
    
    
end
    
function bitCleared = bitClear(image1, image2, CALC_MODE)
    
    switch CALC_MODE
        case 0, 
            bitCleared = image1 & ~image2;
        case 1, 
            bitCleared = image1;
            bitCleared(image2>0) = 0;
        case 2, 
            bitCleared = abs(image1 - image2*5);
    end
    
end
    
function [perimeter, calc_images] = calculatePerimeter(origLetterImage, CALC_MODE,area, show_flag)
    if CALC_MODE == 0
        imageShifted = OR_shifted(origLetterImage, CALC_MODE);
        image_bitCleared = bitClear(imageShifted, origLetterImage, CALC_MODE);
        image_bitCleared_shifted = OR_shifted(image_bitCleared, CALC_MODE);
        wide_perimeter = countActivePixels(image_bitCleared_shifted, CALC_MODE, 0);
        perimeter = wide_perimeter/3;
        
        calc_images = {imageShifted, image_bitCleared, image_bitCleared_shifted};

    elseif CALC_MODE == 1
        imageShifted = OR_shifted(origLetterImage, CALC_MODE);
        image_bitCleared = bitClear(imageShifted, origLetterImage, CALC_MODE);
        wide_perimeter = countActivePixels(image_bitCleared, CALC_MODE, 0);
        perimeter = wide_perimeter;
        
        calc_images = {imageShifted, image_bitCleared};
    elseif CALC_MODE == 2
        %%
        imageShifted = OR_shifted(origLetterImage, CALC_MODE); 
        image_bitCleared = bitClear(imageShifted, origLetterImage, CALC_MODE);
        wide_perimeter = countActivePixels(image_bitCleared, CALC_MODE, 0);
        perimeter = wide_perimeter/2;
        
        calc_images = {imageShifted, image_bitCleared};

    elseif CALC_MODE == 3
        imageShifted = OR_shifted(origLetterImage, CALC_MODE);
        wide_perimeter = countActivePixels(imageShifted, CALC_MODE, 0);
        perimeter = wide_perimeter/2;
        
        calc_images = {imageShifted};
        
    end
%     imageShifted = OR_shifted(origLetterImage, CALC_MODE);
%     image_bitCleared = bitClear(imageShifted, origLetterImage, CALC_MODE);
%     image_bitCleared_shifted = OR_shifted(image_bitCleared, CALC_MODE);
%     wide_perimeter = countActivePixels(image_bitCleared_shifted, CALC_MODE, 0);
%     calc_images = {imageShifted, image_bitCleared, image_bitCleared_shifted};
%     if CALC_MODE == 2
%         perimeter = wide_perimeter/10;
%     elseif CALC_MODE == 1
%         perimeter = wide_perimeter/5;
%     else
        
   
    c = perimeter^2 / area;
%%
%     show = 1;
    show = show_flag; %CALC_MODE == 2;
    if show 
        %%
        s = @(XX) sprintf('[%.1f - %.1f]', lims(XX));
        shft_name = iff(CALC_MODE, 'Plus-shifted', 'OR-shifted');
        btclr_name = iff(CALC_MODE==2, 'abs(Subtract Orig*5)', 'Bit-clear with orig');
        labels = {shft_name, btclr_name};
        if CALC_MODE == 0
            labels = [labels, 'OR-shifted again'];
        end
        figure(100+CALC_MODE+ show_flag);  clf;
        image_func = @imagesc;
        
        plot_images = [origLetterImage, calc_images];
        plot_labels = ['Original', labels];
        
        nPlots = length(plot_images);
%         image_func = @pcolor;
%         doColorbar = 0;
       
        for i = 1:nPlots
            h_ax(i) = subplot(1,nPlots, i);
            image_func(plot_images{i})
            title({plot_labels{i}, s(plot_images{i})})
            axis square;  colorbar('location', 'southoutside')
                    
        end
        linkaxes(h_ax, 'xy')
     
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

% function newSignalMatrix = addMarginToSignal(signalMatrix, marginWidth)
% 
%     % take margin value to be median of all values on the border
%     borderVals_r = [signalMatrix(1,:,:); signalMatrix(end,:,:)]; 
%     borderVals_c = [signalMatrix(:,1,:); signalMatrix(:,end,:)];
%     minBorderVal = min([borderVals_r(:); borderVals_c(:)]);
% %     medianBorderVal = median([borderVals_r(:); borderVals_c(:)]);
% 
% %     newSignalMatrix = addMargin(signalMatrix, marginWidth, minBorderVal);
% 
% end