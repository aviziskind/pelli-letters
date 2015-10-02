function fonts_styles_list = getFontList(fontsArg)
        
    
    if ischar(fontsArg)
        fonts_styles_list = {fontsArg};
    elseif iscell(fontsArg)
        fonts_styles_list = fontsArg;
    elseif isstruct(fontsArg)
        
        fontNames = fontsArg.fonts;
        if ischar(fontNames)
            fontNames = {fontNames};
        end
    
        if isfield(fontsArg, 'styles')
            stylesAbbrev = fontsArg.styles;
            stylesAbbrevTable = struct('Roman', '', 'Bold', 'B',  'Italic', 'I',   'BoldItalic', 'BI');
            for i = 1:length(stylesAbbrev)
                stylesAbbrev{i} = stylesAbbrevTable.(fontsArg.styles{i});
            end
        elseif isfield(fontsArg, 'wiggles')
            %%
            wiggleList_C = getWiggleList(fontsArg.wiggles);
            if ~iscell(wiggleList_C)
                wiggleList_C = {wiggleList_C};
            end
            stylesAbbrev = cellfun(@getSnakeWiggleStr, wiggleList_C, 'un', 0);
        else
            
            stylesAbbrev = {''};
        end
        fonts_styles_C = expandOptionsToList(struct('tbl_font', {fontNames}, 'tbl_style', {stylesAbbrev}));

        fonts_styles_list = arrayfun(@(s) [s.font s.style], fonts_styles_C, 'un', 0);
        
    end
    
end                    

