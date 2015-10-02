
function cycPerLet_range = getCycPerLet_range(noiseFilter)
    if any(strcmp (noiseFilter.filterType, {'band', 'lo', 'hi'}))
        switch noiseFilter.filterType
            case 'band', cycPerLet_range = noiseFilter.cycPerLet_centFreq * [1/sqrt(2), sqrt(2)];
            case 'lo',   cycPerLet_range = [0, noiseFilter.cycPerLet_cutOffFreq];
            case 'hi',   cycPerLet_range = [noiseFilter.cycPerLet_cutOffFreq, inf];

        end

    end
end