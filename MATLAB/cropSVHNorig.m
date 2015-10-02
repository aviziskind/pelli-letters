function cropSVHNorig

%%
    fileTypes = {'train', 'test'};
%     fileTypes = {'test'};


    cropToSize = 32;
    fileType = fileTypes{2};
    
    pth = [datasetsPath 'SVHN' filesep 'orig_rgb_full' filesep fileType filesep];
  %%
    S_full = load([pth 'digitStruct.mat']);
    digitStruct = S_full.digitStruct;
    
    if cropToSize == 32
        %%
        S_cropped = load([datasetsPath 'SVHN' filesep 'orig_rgb' filesep fileType '_32x32.mat']);
        
    end
    
    %%
    for i = 1:1; %length(digitStruct)
        
        dig_i = dig_i+1; sub_dig = 1;
        im = imread([pth digitStruct(dig_i).name]);
        [im_height, im_width, ~] = size(im);
        box = digitStruct(dig_i).bbox(sub_dig);

%         box_top = box.top;
        box.bot = box.top + box.height-1;
        box.right = box.left + box.width-1;
        
        box.spaceOnLeft   =             box.left-1;
        box.spaceOnRight  = im_width  - box.right-1;
        box.spaceOnTop    =             box.top-1;
        box.spaceOnBottom = im_height - box.bottom-1;

        
%         box_left = box.left;
        
        im_justNumber = im(box.top:box.bot, box.left:box.right, :);

%         box_height = box_bot - box.top + 1;
%         box_width = box.right - box.left + 1;
        
        
        figure(1); clf; 
        subplot(1,3,1); image(im); title(sprintf('Original image [%dx%d] (with box) [%d x %d]', size(im,1), size(im,2), box_height, box_width));
        axis image;
       rectangle('position', [box.left, box_bot-box_height, box_width, box_height]);
              
        marginAroundBox = 2;
        gapW = cropToSize - marginAroundBox * 2 - box.width;
        gapH = cropToSize - marginAroundBox * 2 - box.height;
        
        sqBox = box;
        
        if gapW > gapH 
            addPaddingToBox(box, gapW-gapH, 1);
        else
            addPaddingToBox(box, gapH-gapW, 2);
        end
            
            
            nPadLR = gapW - gapH;
            nPadL = floor(nPadLR/2);
            nPadR = nPadLR - nPadL;
            % check that doesn't go over boundary:
            
            box.spaceOnLeft = box.left-1;
            box.spaceOnRight = im_width-box.right-1;
            nExtra_onLeft = nPadL - box.left-1;
            nExtra_onRight = nPadR - (box.spaceOnRight);
            
            
            if nExtra_onLeft < 0  || nExtra_onRight < 0
                if nExtra_onLeft + nExtra_onRight <= nPadL+nPadR
                    % have enough padding, but might have to transfer some
                    % from one to the other
                    if nExtra_onLeft < 0
                        nPadL = box.spaceOnLeft;
                        nPadR = nPadLR - nPadL;
                        
                    elseif nExtra_onRight < 0
                        nPadR = box.spaceOnRight;
                        nPadL = nPadLR - nPadR;
                    
                    end
                    
                else
                    keyboard;
                    
                end
             
                
                
                
            end
            
            
            sqBox.left = box.left - nPadL;
            sqBox.right = box.right - nPadR;
            
            
        
        
        

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
        for c = 1:dig_i-1;
            offset = offset + length(digitStruct(c).bbox);
        end
        cropped_i = offset + sub_dig;
        
%         cropped_i = 2;
%         subplot(1,3,2); image(im); title('My cropped image'); axis image;
        subplot(1,3,3); image(S_cropped.X(:,:,:,cropped_i));  title('Saved Cropped image');
        imageToScale([], 2)
        
        
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
        
    

    
    
end