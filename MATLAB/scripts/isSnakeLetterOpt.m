function tf = isSnakeLetterOpt(letterOpts)
   
    tf = strncmpi(letterOpts.fontName, 'Snakes', 6) || ...
        isstruct(letterOpts.fontName) && isfield( letterOpts.fontName, 'fonts' ) && all(strcmp( letterOpts.fontName.fonts, 'Snakes' ));

    
end