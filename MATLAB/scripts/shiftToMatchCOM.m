function im_shift = shiftToMatchCOM(im, im_ref, alsoClipFlag)

    com = centerOfMass(im);
    com_ref = centerOfMass(im_ref);
    
    im_shift = im;
    im_shift = circshift(im, -(round(com - com_ref)));
    
    if exist('alsoClipFlag', 'var') && isequal(alsoClipFlag, 1);
%         [m,n] = size(im_ref);
%         im_shift = im(1:m, 1:n);
    end


end