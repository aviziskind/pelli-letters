function wiggleAmount = getWiggleAmount(wiggleType, wiggleAngle, opt)
    % determine the correct wiggle amount for a particular wiggle type and
    % angle

    switch wiggleType
        case 'orientation', wiggleAmount = wiggleAngle;
        case 'offset', wiggleAmount = opt.markSpacing_deg / pi * tan( deg2rad( wiggleAngle) );
        case 'phase', wiggleAmount = [];
        case 'none', wiggleAmount = 0;
    end

end