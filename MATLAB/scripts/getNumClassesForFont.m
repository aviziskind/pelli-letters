function n = getNumClassesForFont(fontName, sumIfMultipleFonts)
    
    if iscell(fontName)
       allN = cellfun(@getNumClassesForFont, fontName);
       if exist('sumIfMultipleFonts', 'var') && isequal(sumIfMultipleFonts, 1)
           n = sum(allN);
       else
           n = allN;
       end
       return
    end
    
    
    fontName = getRawFontName(fontName);
    if any(strcmp(fontName, {'Bookman', 'Courier',  'Helvetica', 'Kuenstler', 'Sloan', 'Yung', 'Devanagari', 'Braille', 'Checkers4x4'}))
        n = 26;
    elseif strcmp(fontName, 'Hebraica')
        n = 22;
    elseif strcmp(fontName, 'Armenian')
        n = 35;
    
    elseif any( strcmp(fontName, {'SVHN', 'Snakes'}))
        n = 10;
    else
        error('Unknown font : %s', fontName);
    end
    
    
end