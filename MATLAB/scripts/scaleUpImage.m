function im_gray_enlarged = scaleUpImage(im_gray, scaleFactor, scale_method, varargin)
    switch scale_method
        case 'PixelRep'
            assert(length(scaleFactor)==1);
            im_gray_enlarged = scaleByPixelRep(im_gray, scaleFactor);

        case 'Fourier'
            assert(length(scaleFactor)==1);
            % if original is uint8, convert back to uint8 at the end.
            isUint8 = isa(im_gray, 'uint8');
%             im_gray = double(im_gray);
            
            im_gray_enlarged = fourierInterpImage(double(im_gray), 'mult', scaleFactor);
            
            L = lims(im_gray_enlarged);
            if (L(1) < 0 || L(2) > 255)
                overshoot = max(-L(1), L(2)-255);
                h = 128;
                c_factor = h/(overshoot+h+1);
                
                im_gray_enlarged_rescaled = (im_gray_enlarged-h)*c_factor + h; 
                
                L2 = lims(im_gray_enlarged_rescaled);
                assert(L2(1) >= 0 && L2(2) <= 255);
            end
            
            if isUint8
                im_gray_enlarged = uint8(round(im_gray_enlarged));
            end
            
        case 'Pad',
%             padValue = varargin{1};
%%
            padValue = mean(im_gray(:));
            new_size = size(im_gray) .* scaleFactor;
%             im_gray_enlarged = zeros(  );
            padding = new_size - size(im_gray);
            padTB = padding(1)/2;
            padLR = padding(2)/2;
            im_gray_enlarged = padarray(im_gray, [padTB, padLR], padValue, 'both');
            assert(all(  size(im_gray_enlarged) == new_size  ))
            3;
        case 'Tile',
            im_gray_enlarged = repmat(im_gray, scaleFactor);
   
    end
    
    %%
%     figure(5); subplot(1,2,1); imagesc(im_gray); colorbar; subplot(1,2,2); imagesc(im_gray_enlarged); colorbar; colormap('gray'); imageToScale([], 3);
%     3;
%             pause(.2);
    
end
