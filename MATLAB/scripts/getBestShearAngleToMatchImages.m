function [bestAngle, minErrForAngle, bestImage] = getBestShearAngleToMatchImages(im1, im2, allAngles)


    com1 = centerOfMass(im1);

    com2 = centerOfMass(im2);

    % allAngles = [12];
    nAngles = length(allAngles);

    allShifts = [-1:1]; nShifts = length(allShifts);
    minErrForAngle = zeros(1,nAngles);
    % maxCorr
    minErr = inf;

    for angle_i = 1:nAngles
        im1_sheared = shearImage(im1, allAngles(angle_i));

        im1_sheared_cent = shiftAndCropToMatchCOM(im1_sheared, im2);

%         com_im_sheared = centerOfMass(im1_sheared);
%         im1_sheared_cent = circshift(im1_sheared, flipud( -round(com_im_sheared - com2) ) );

%         com_new = centerOfMass(im1_sheared_cent);    

        allErrs = zeros(nShifts, nShifts);

        for ishift_idx = 1:nShifts
            for jshift_idx = 1:nShifts
                im1_sheared_cent_shft = circshift(im1_sheared_cent, [allShifts(ishift_idx), allShifts(jshift_idx)]);

                allErrs(ishift_idx, jshift_idx) = sum( (im1_sheared_cent_shft(:) - im2(:)).^2 );
            end
        end
        minErrForAngle(angle_i) = min(allErrs(:));
        if minErrForAngle(angle_i) < minErr 
            minErr = minErrForAngle(angle_i);
            bestImage = im1_sheared_cent_shft;
        end

    end

    
    bestAngle_idx = indmin(minErrForAngle);
    bestAngle = allAngles(bestAngle_idx);
    

end