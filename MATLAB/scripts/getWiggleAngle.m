function wiggleAngle = getWiggleAngle(wiggleSettings)
    % determine the correct wiggle amount for a particular wiggle type and
    % angle
    wiggleType_C = fieldnames(wiggleSettings);
    assert(length(wiggleType_C) == 1)
    wiggleType = wiggleType_C{1};
    
    switch wiggleType
        case 'none',        wiggleAngle = 0;
        case 'orientation', wiggleAngle = wiggleSettings.(wiggleType);
        case 'offset',      wiggleAngle = wiggleSettings.(wiggleType); 
        case 'phase',       wiggleAngle = 40.8;
    end

end