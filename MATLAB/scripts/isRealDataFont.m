function tf = isRealDataFont(font)

    if isempty(font)
        tf = false;
        return;
    end

    font_str = abbrevFontStyleNames(font);
    realDataFontList = getRealDataFontList();
    tf = any(  cellfun(@(f) ~isempty(strfind(font_str, f)), realDataFontList) );

    
end


%     tf = (~isempty(fontName)) && any(strcmp(abbrevFontStyleNames(fontName), )) ;
