function S = getCrowdingRangeTrainPosTestPos(imW, fontHalfW, buffer, stepSize)
    %%
    % [imW, fontHalfW, buffer, stepSize] = deal(160, 11, 5, 12);

    im_mid = imW/2;
    x_hi = im_mid : stepSize : imW + fontHalfW + buffer;
    x_overHang = max(x_hi) - imW;
    x_lo = -x_overHang : stepSize :  im_mid - stepSize;
    x = [x_lo, x_hi];

    %%

    %                     x = [x_lo: stepSize : imW + fontHalfW];
    xrange = [x(1), stepSize, x(end)];
    
    
%     trainOnPos_minAppearanceFrac = 1/2; %  1/2: as long as at least half the letter is visible, is an ok position (x >= 0)
    trainOnPos_minAppearanceFrac = 3/4; %  3/4: as long as 3/4 of the letter is visible, is an ok position (x_cent >= fontWidth/4)  
%     trainOnPos_minAppearanceFrac = 1; %  1: must have entire letter visible (x_cent >= fontWidth/2);
    
    frac_use = trainOnPos_minAppearanceFrac - 0.5; %
    buffer_margin_pix = frac_use * (fontHalfW*2);
    
    trainPos_idx = find(x > buffer_margin_pix   &   x < imW - buffer_margin_pix);
%     trainPos = x(trainPos_idx);
    
    
    
    testPos_idx = find(x == imW/2);
    testPos = x(testPos_idx);

    assert(length(testPos_idx)==1);

    S = {xrange, trainPos_idx, testPos_idx};
end

