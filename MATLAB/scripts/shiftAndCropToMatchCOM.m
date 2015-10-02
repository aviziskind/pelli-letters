function im_new = shiftAndCropToMatchCOM(im, im_ref)
%%
    com = centerOfMass(im);
    if exist('im_ref', 'var') && ~isempty(im_ref)
        com_ref = centerOfMass(im_ref);
        [m,n] = size(im_ref);
    else        
        com_ref = size(im)/2;
        [m,n] = size(im);
    end
        

    im_new = im;

    im_new = circshift(im_new, -(round(com - com_ref)));

    
    im_new = im_new(1:m, 1:n);
    
    
    doCheck = 1;
    if doCheck
        com_new = centerOfMass(im_new);
        
        assert(max(abs(com_new - com_ref)) < 1)
    end
    
    show = 0;
    if show
        %%
        figure(13); clf;
        %%
        subplot(1,4,1); imagesc(im); axis square
        subplot(1,4,2); imagesc(im_ref); axis square
        subplot(1,4,3); imagesc(im_new); axis square
        %%
%         subplot(1,4,4); imagesc(im1); axis square
        imageToScale([], 3);
        
        
    end
    
    


end