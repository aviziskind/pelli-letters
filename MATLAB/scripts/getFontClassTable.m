function classesTable = getFontClassTable(fontNamesSet)
    fontNamesList = sort( getFontList(fontNamesSet) );
    
    %{
        Kuenstler = 0
        Bookman = 26
        BookmanU = 52
        Braille = 78
        nClasses = 104
    %}
    
    nClassesTot = 0;
    nFontShapes = 0;
    classesTable = struct;
   
    for fi = 1 : length(fontNamesList)
        fontNameU = getRawFontName(fontNamesList{fi}, 'keepU');
        
        if ~isfield(classesTable, fontNameU)
            nClassesThisFont = getNumClassesForFont(fontNameU);
                
            classesTable.(fontNameU) = nClassesTot;
            nClassesTot = nClassesTot + nClassesThisFont;
            nFontShapes = nFontShapes + 1;
        end
    end
    classesTable.nClassesTot = nClassesTot;
    classesTable.nFontShapes = nFontShapes;
    
    
end