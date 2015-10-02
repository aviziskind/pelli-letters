function score = getPcaScore(imageMtx, meanImageVec, coeff)
    if numel(imageMtx) == length(meanImageVec)
        centdata = imageMtx(:)' - meanImageVec;
    else % assume multiple rows
        centdata = bsxfun(@minus, imageMtx, meanImageVec);
    end
    score = centdata/coeff';

end

