function createFontSizesFile

    fontSizesFile = [lettersCodePath 'fontSizes.mat'];
    doSizeStyles = 0 && 0;
    sizeStyles = {'sml', 'med', 'big', 'large'};

    S_fonts = loadLetters;
    fn = fieldnames(S_fonts);

    allFonts = unique( cellfun(@(s) strtok(s, '_'), fn, 'un', 0));
    
    S = struct;
    for fi = 1:length(allFonts)
        fontName = allFonts{fi};
        
        S_i = S_fonts.(fontName);
                
        S.([fontName '_sizes']) = S_i.sizes;
        S.([fontName '_widths']) = S_i.boxW;
        S.([fontName '_heights']) = S_i.boxH;
        S.([fontName '_k_heights']) = S_i.k_heights;
        S.([fontName '_x_heights']) = S_i.x_heights;
        
        if doSizeStyles
            for i = 1:length(sizeStyles)
                szStyle = sizeStyles{i};
                S.([fontName '_' szStyle]) = getFontSize(fontName, szStyle);            
            end
        end
    3;

    end

    save(fontSizesFile, '-struct', 'S')




end