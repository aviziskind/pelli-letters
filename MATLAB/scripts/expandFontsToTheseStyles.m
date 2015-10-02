function allFontStyles = expandFontsToTheseStyles(allFontNames, allStyles)
    allFontStyles = cell(length(allStyles), length(allFontNames));
    for fi = 1:length(allFontNames)
        for si = 1:length(allStyles) 
            allFontStyles{si, fi} = [allFontNames{fi} allStyles{si}];
        end
    end
    allFontStyles = allFontStyles(:);
    
end
