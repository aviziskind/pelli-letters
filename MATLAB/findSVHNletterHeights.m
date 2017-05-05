function findSVHNletterHeights
    
    %%
    fileTypes = {'train', 'test'};
    %     fileTypes = {'test'};
    
    
    cropToSize = 32;
    fileType = fileTypes{2};
    
    pth = [datasetsPath 'SVHN' filesep 'orig_rgb_full' filesep fileType filesep];
    %%
    S_full = load([pth 'digitStruct.mat']);
    digitStruct = S_full.digitStruct;
    
    %%
    
    if cropToSize == 32
        %%
        S_cropped = load([datasetsPath 'SVHN' filesep 'orig_rgb' filesep fileType '_32x32.mat']);
        
    end
    
    %%
    digit_idx = 0;
    allNImages = arrayfun(@(s) length(s.bbox), digitStruct);
    
    cumNImages = cumsum(allNImages);
    
    firstImIdx = cumsum([0 allNImages(1:end-1)])+1;
    lastImIdx = cumsum(allNImages);
    imOffsetIdx = cumsum([0 allNImages]);
    
    nTotDigits = sum(allNImages);
    
    %%
    for digit_idx = 169:nTotDigits; %length(digitStruct)
        
        %         digit_idx = digit_idx+1;
%         digit_idx = digit_idx + 1;
        
        img_idx = find(digit_idx >= firstImIdx, 1, 'last');
%         img_idx = 3;
%         digit_idx = 1;
        
        sub_idx = digit_idx - firstImIdx(img_idx)+1;
        
        
        
        dig_S = digitStruct(img_idx);
        
        im = imread([pth dig_S.name]);
        [im_height, im_width, ~] = size(im);
        
        
        %%
        nDigitsThisImage = length( dig_S.bbox );
        
        %         for sub_i = 1:nDigitsThisImage
        
        cropped_idx = imOffsetIdx(img_idx) + sub_idx;
        assert(cropped_idx == digit_idx);
        cropped_im = rgb2gray(S_cropped.X(:,:,:,cropped_idx));
        
        
        
        
        box = dig_S.bbox(sub_idx);
        
        %         box_top = box.top;
        box.bot = box.top + box.height-1;
        box.right = box.left + box.width-1;
        
        box.spaceOnLeft   =             box.left-1;
        box.spaceOnRight  = im_width  - box.right-1;
        box.spaceOnTop    =             box.top-1;
        box.spaceOnBottom = im_height - box.bot-1;
        %%
        
        %         box_left = box.left;
        
        im_justNumber = im(box.top:box.bot, box.left:box.right, :);
        
        box_height = box.bot - box.top + 1;
        box_width = box.right - box.left + 1;
        
        
        
        
        
        
        figure(1); clf;
        subplot(1,3,1); h_im_f = image(im); title(sprintf('Original image [%dx%d] (with box) [%d x %d]', size(im,1), size(im,2), box_height, box_width));
        axis image;
        imageToScale(h_im_f, 1);
        rectangle('position', [box.left, box.bot-box_height, box_width, box_height]);
        
        subplot(1,3,3); h_im_c = image(repmat(cropped_im, [1 1 3])); axis image;
        imageToScale(h_im_c, 1);
       
        %%
        3;
        continue;
        
%     end
        %%
        
        
        
        
        
        
        smallerGap = min(gapW, gapH);
        scaleUp   = smallerGap > 0;
        scaleDown = smallerGap < 0;
        
        scaleRatio = (cropToSize - smallerGap) / cropToSize;
        if scaleUp
            
            
            %             fourierInterpImage(
            
            
            
            
            
        elseif scaleDown
            
            
            
            
            
        end
        
        %  rectangle(
        offset = 0;
        for c = 1:digit_idx-1;
            offset = offset + length(digitStruct(c).bbox);
        end
        cropped_i = offset + sub_idx;
        
        %         cropped_i = 2;
        %         subplot(1,3,2); image(im); title('My cropped image'); axis image;
        subplot(1,3,3); image(S_cropped.X(:,:,:,cropped_i));  title('Saved Cropped image');
        imageToScale([], 2)
        
    end
    
    
    %%
    %
    %         for j = 1:length(digitStruct(i).bbox)
    %             [height, width] = size(im);
    %             aa = max(digitStruct(i).bbox(j).top+1,1);
    %             bb = min(digitStruct(i).bbox(j).top+digitStruct(i).bbox(j).height, height);
    %             cc = max(digitStruct(i).bbox(j).left+1,1);
    %             dd = min(digitStruct(i).bbox(j).left+digitStruct(i).bbox(j).width, width);
    %
    %             im_j = im(aa:bb, cc:dd, :);
    %             imshow();
    %             fprintf('%d\n',digitStruct(i).bbox(j).label );
    %             pause;
    %         end
    3;
end





% end