function [rawFontName, fontAttrib] = getRawFontName(fontName, keepFlags)
    rawFontName = fontName;
    fontAttrib = struct('upper_tf', 0, 'bold_tf', 0, 'italic_tf', 0, 'outline_w', nan, 'thin_w', nan,  'wiggle', '');
%     upper_tf, bold_tf, italic_tf, outline_w, thin_w
%     upper_tf = false;
%     bold_tf = false;
%     italic_tf = false;
%     outline_w = nan;
%     thin_w = nan;
    
    if isempty(fontName)
        return;
    end

    % keep some flags:
    %  keep the uppercase on KuenstlerU
    %  keep the bold on BookmanB
    
    if nargin < 2
        keepFlags = {};
    end
    
    keepUpperCase = any(strcmp(keepFlags, 'keepU'));
%     keepSloanT = any(strcmp(keepFlags, 'keepSloanT'));
    keepKuenstlerU = any(strcmp(keepFlags, 'keepKuenstlerU'));  % The x-height for Kuenstler is calculated using the uppercase Kuenstler, not lower case, as for the rest of the fonts.
    keepBookmanB = any(strcmp(keepFlags, 'keepBookmanB'));      % The BookmanBold that I use is actually a different font from regular bookman. 
    keepSnakeWiggle = any(strcmp(keepFlags, 'keepSnakeWiggle')); 
            
    
%     if nargin >= 2 && ~isempty(keepFlags_arg) 
%         switch keepFlags_arg
%             case 'keepU', keepUpperCase = 1;
%             case 'keepKuenstlerU_BookmanB_SnakeWiggle', keepKuenstlerU_BookmanB = 1;  
%             otherwise,  error('Unknown flag option')
%         end
%     end
%         keepUpperCaseFlag = strcmp(keepFlags_arg, 'keepU');
            
    isKuenstler = strncmp(fontName, 'Kuenstler', 9);
    isBookman = strncmp(fontName, 'Bookman', 7);
    isSnakes = strncmp(fontName, 'Snakes', 6);
%     isCourier = strncmp(fontName, 'Courier', 7);
    
    charsToAddBack = '';
    while any(rawFontName(end) == ['U', 'B', 'I'])  || (isKuenstler && (rawFontName(end) == 'i') ) ...
            || ((~isnan(str2double(rawFontName(end))) && isreal(str2double(rawFontName(end)))) && ~isSnakes)

        if rawFontName(end) == 'U'
            fontAttrib.upper_tf = true;
            
            if ((isKuenstler ) && keepKuenstlerU)  ||  keepUpperCase
                charsToAddBack = [charsToAddBack, 'U']; %#ok<*AGROW>
            end
        end
        
        if rawFontName(end) == 'B'
            fontAttrib.bold_tf = true;
            
            if (isBookman && keepBookmanB)
                charsToAddBack = [charsToAddBack, 'B'];
            end

        end
        
        if rawFontName(end) == 'I' || (isKuenstler && rawFontName(end) == 'i')
            fontAttrib.italic_tf = true;
        end

        if any(strncmp(rawFontName(end-2:end), {'4x4', '5x7'}, 3))
            % is 'Checkers4x4' or 'Ascii5x7'
            break;
        end
        
        if ~isnan(str2double(rawFontName(end))) && ~isSnakes
            i = length(rawFontName);
            while ~isnan(str2double(rawFontName(i))) && i > 1;
                i = i-1;
            end
            n = str2double(rawFontName(i+1:end));
            if n > 10
                n = n / 10;
            end
            if (rawFontName(i) == 'O')
                fontAttrib.outline_w = n;
            elseif (rawFontName(i) == 'T')
                fontAttrib.thin_w = n;
            end
            
            rawFontName(i+1:end) = [];
        end
        
        rawFontName(end) = [];
    end
    
    if strncmpi(rawFontName, 'Snakes', 6) && ~keepSnakeWiggle
        if length(rawFontName) > 6
            fontAttrib.wiggle = rawFontName(7:end);
        end
        rawFontName = 'Snakes';
    end
    
    
    rawFontName = [rawFontName, charsToAddBack];
end
