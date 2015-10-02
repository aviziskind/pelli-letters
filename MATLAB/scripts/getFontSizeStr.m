function str = getFontSizeStr(fontSize)

    if ischar(fontSize)
        str = fontSize;
    elseif isnumeric(fontSize)
        if length(fontSize) == 1 || (length(fontSize) == 2 && (fontSize(1) == fontSize(2)) )
            str = sprintf('%d', fontSize(1));
        elseif length(fontSize) == 2
            str = sprintf('%d-%d', fontSize(1), fontSize(2));
        end
    end
    
end