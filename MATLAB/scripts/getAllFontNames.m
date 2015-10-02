function allFontsNames = getAllFontNames()
    
    S = loadLetters;
%%    
    fieldnms = fieldnames(S);    

    isSummaryField = cellfun(@(s) isempty(strfind(s, '_')), fieldnms);
    allFontsNames = fieldnms(isSummaryField);

%     allFonts2 = unique( cellfun(@(s) strtok(s, '_'), fieldnms, 'un', 0));
%     assert(isequal(sort(allFonts1), sort(allFonts2)))
    
    
end