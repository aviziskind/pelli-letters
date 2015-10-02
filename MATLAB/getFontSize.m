function [fontPointSize, fontXheight, fontKheight] = getFontSize(fontNames, sizeStyle, sizeAllowance)

    
    useUpperCaseKforK_height = 1;
    useLowerCaseXforX_height = 1;
    dontUseLowerCaseForKuenstler = true;
    
    if nargin < 3
        sizeAllowance = 'exact';
    end
        
    
    
    setPointSize = ~isnan(str2double(sizeStyle)) || isnumeric(sizeStyle);
    setKheight = strncmp(sizeStyle, 'k', 1);
    setXheight = strncmp(sizeStyle, 'x', 1);
    
    assert(setPointSize || setKheight || setXheight)

    scaleFactor = 1;
    if setPointSize
        if ischar(sizeStyle)
            sizeVal = str2double(sizeStyle);
        elseif isnumeric(sizeStyle)
            scaledUpFont = length(sizeStyle) == 2;
            if scaledUpFont
                sizeVal = sizeStyle(2);
                scaleFactor = sizeStyle(1) / sizeStyle(2);
                assert(scaleFactor == round(scaleFactor));
            else 
                sizeVal = sizeStyle;
            end
        end
            
    elseif setKheight || setXheight    
        sizeVal = str2double(sizeStyle(2:end));
    end
        
    fontSizesFile = [lettersCodePath 'fontSizes.mat'];
    S_fontSizes = load(fontSizesFile);

    haveOneFont = ~isempty(fontNames) & ischar(fontNames);
    
    if isempty(fontNames)
        fontNames = getAllFontNames(); %fieldnames(medFontSizes);
    elseif ischar(fontNames)
        fontNames = {fontNames};
    elseif isstruct(fontNames) && strcmp(fontNames.fonts, 'Snakes')
        fontNames = {'Snakes' getSnakeWiggleStr(fontNames.wiggles)};
    end
    
    
    
    for i = 1:length(fontNames)
            
        rawFontName = getRawFontName(fontNames{i}, {'keepKuenstlerU', 'keepBookmanB', 'keepSnakeWiggle'});
        all_point_sizes = S_fontSizes.([rawFontName '_sizes']);

        haveUpperAndLowerCase = haveUpperAndLowerCaseForFont(getRawFontName(fontNames{i}));

       
        if useUpperCaseKforK_height && haveUpperAndLowerCase
            rawFontNameU = uppercaseVersion(rawFontName); 
        else
            rawFontNameU = rawFontName; 
        end
        all_font_k_heights = S_fontSizes.([rawFontNameU '_k_heights']);
        
        
        if useLowerCaseXforX_height && haveUpperAndLowerCase
            rawFontNameL = lowercaseVersion(rawFontName, dontUseLowerCaseForKuenstler); 
        else
            rawFontNameL = rawFontName;
        end
        all_font_x_heights = S_fontSizes.([rawFontNameL '_x_heights']);
        
        
        if setPointSize
            all_sizes_use = all_point_sizes;
        elseif setKheight
            all_sizes_use = all_font_k_heights;
        elseif setXheight
            all_sizes_use = all_font_x_heights;
        end
                
            
        switch sizeAllowance
            case 'exact',    size_idx = find( all_sizes_use == sizeVal, 1);
            case 'minSize',  size_idx = find( all_sizes_use >= sizeVal, 1, 'first');
            case 'maxSize',  size_idx = find( all_sizes_use <= sizeVal, 1, 'last');
            case 'closest',  size_idx = indmin( abs( all_sizes_use - sizeVal) );
        end
                    
        
        pointSize = all_point_sizes(size_idx);
        kHeight   = all_font_k_heights(size_idx);
        xHeight   = all_font_x_heights(size_idx);
        
        if haveOneFont
            fontPointSize = pointSize * scaleFactor;
            fontKheight = kHeight * scaleFactor;
            fontXheight = xHeight * scaleFactor;
        else
            fontPointSize.(rawFontName) = pointSize * scaleFactor;
            fontPointSize.(rawFontName) = kHeight * scaleFactor;
            fontPointSize.(rawFontName) = xHeight * scaleFactor;
        end
    end
        3;
%     else
% 
%         allStyles = getFontStyleSets;
%         
%         fontSizes = allStyles.(sizeStyle);
% 
%         if nargin < 1 || isempty(fontName)
%             fontSize = fontSizes;
%         else
%             if isfield(fontSizes, rawFontName)
%                 fontSize = fontSizes.(rawFontName);
%             else
%                 fontSize = 0;
%             end
%         end
%     end    
    
end

function fontNameU = uppercaseVersion(fontName)
    [rawFontName, fontAttrib] = getRawFontName(fontName);  
    fontAttrib.upper_tf = 1;
    fontNameU = getFullFontName(rawFontName, fontAttrib);
end
    
function fontNameU = lowercaseVersion(fontName, notForKuenstler_flag)
    notForKuenstler = exist('notForKuenstler_flag', 'var') && isequal(notForKuenstler_flag, 1);
    [rawFontName, fontAttrib] = getRawFontName(fontName);  
    if ~(strcmp(rawFontName, 'Kuenstler') && notForKuenstler)
        fontAttrib.upper_tf = false;
    end
    fontNameU = getFullFontName(rawFontName, fontAttrib);
end

function tf = haveUpperAndLowerCaseForFont(rawFontName)
    if any(strcmp(rawFontName, {'Bookman', 'Courier', 'Helvetica', 'Kuenstler'}))
        tf = true;
    elseif any(strcmp(rawFontName, {'Hebraica', 'Yung', 'Sloan', 'Braille', 'Checkers4x4', 'Devanagari', 'Armenian'})) || strncmp(rawFontName, 'Snakes', 6)
        tf = false;
    end
        
end

%{





%}






function allStyles = getFontStyleSets
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   [no mrgn] unrotated   rot 5,    rot 10    rot 15   rot 20                        
    origFontSizes.Braille      =  8; % (24x16)  26 x 18.  29 x 21,  29 x 23,  31 x 25,  31 x 25.   C0 = 27  C2 = 28
    origFontSizes.Sloan        = 16; %          28 x 29.  29 x 31,  31 x 31,  33 x 33,  35 x 35.   C0 = 42  C2 = 43
    origFontSizes.Helvetica    = 16; %          28 x 23.  27 x 23,  29 x 25,  29 x 25,  29 x 26.   C0 = 44  C2 = 50
    origFontSizes.Bookman      = 15; %          26 x 26.  27 x 25,  27 x 27,  29 x 27,  29 x 27.   C0 = 45  C2 = 71
%     origFontSizes.Georgia      = 7;  % (11x14)  13 x 15.  15 x 17,  15 x 17,  17 x 19,  17 x 19.   C0 = 30  C2 = 57
    origFontSizes.Courier      = 18; %          27 x 21.  27 x 21,  29 x 23,  29 x 23,  31 x 25.   C0 = 70  C2 = 111
    origFontSizes.Yung         = 16; % (25x24)  26 x 25.  27 x 27,  27 x 28,  27 x 28,  27 x 29.   C0 = 62  C2 = 99
    origFontSizes.Kuenstler    = 7 ; % (12x17)  13 x 19.  15 x 21,  17 x 21,  18 x 22,  19 x 22.   C0 = 32  C2 = 101

    
    
    % sml: aim for height ~10 (~12x12 with 1 pixel margin)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    average    unrotated   rot 5,    rot 10    rot 15    rot 20                           
    smlFontSizes.Braille       =  4;  % [k: 12] [12 x  8]   12 x  8.  13 x  9,  15 x 11,  15 x 11,  15 x 13.   C0 = 5  C2 = 27
    smlFontSizes.Checkers4x4   =  3;  
    smlFontSizes.Sloan         =  7;  % [k: 10] [10 x 12]   10 x 12.  11 x 13,  13 x 15,  13 x 15,  15 x 15.   C0 = 5  C2 = 29
    smlFontSizes.Helvetica     =  9;  % [k: 11] [10 x  6]   14 x 12.  15 x 13,  17 x 15,  17 x 15,  17 x 15.   C0 = 31  C2 = 38
    smlFontSizes.Bookman       =  9;  % [k: 11] [ 9 x  9]   15 x 17.  17 x 18,  17 x 18,  17 x 18,  19 x 18.   C0 = 31  C2 = 57
%     smlFontSizes.Georgia       =  9;  % [k: 11] [11 x 11]   14 x 17.  16 x 19,  17 x 21,  18 x 21,  19 x 21.   C0 = 39  C2 = 67
    smlFontSizes.Courier       = 11;  % [k: 11] [10 x 10]   15 x 13.  17 x 15,  17 x 15,  18 x 17,  18 x 17.   C0 = 42  C2 = 78
    smlFontSizes.Yung          =  9;  % [k: 10] [10 x 10]   11 x 13.  13 x 15,  13 x 15,  15 x 16,  15 x 16.   C0 = 33  C2 = 64
    smlFontSizes.KuenstlerU    =  8;  % [k:  9] [ 9 x 15]   12 x 19.  15 x 20,  16 x 20,  17 x 22,  18 x 22.   C0 = 36  C2 = 122

    
    
    % med: aim for height ~15-16
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    average    unrotated   rot 5,    rot 10    rot 15    rot 20                           
    medFontSizes.Braille       =  6;  % [k: 18] [18 x 12]   18 x 12.  19 x 15,  21 x 17,  21 x 17,  21 x 19.   C0 = 8  C2 = 33
    medFontSizes.Checkers4x4   =  4;  
    medFontSizes.Sloan         = 11;  % [k: 17] [17 x 18]   17 x 19.  19 x 21,  21 x 23,  23 x 23,  23 x 25.   C0 = 39  C2 = 42
    medFontSizes.Helvetica     = 15;  % [k: 18] [16 x 10]   23 x 20.  25 x 22,  25 x 22,  27 x 22,  27 x 24.   C0 = 41  C2 = 45
    medFontSizes.Bookman       = 15;  % [k: 18] [15 x 14]   24 x 25.  26 x 26,  27 x 26,  28 x 27,  29 x 28.   C0 = 45  C2 = 71
%     medFontSizes.Georgia       = 15;  % [k: 18] [18 x 18]   23 x 28.  26 x 30,  28 x 32,  30 x 33,  31 x 34.   C0 = 56  C2 = 81
    medFontSizes.Courier       = 16;  % [k: 17] [15 x 14]   23 x 17.  25 x 19,  26 x 21,  26 x 21,  26 x 23.   C0 = 63  C2 = 104
    medFontSizes.Yung          = 15;  % [k: 18] [18 x 17]   22 x 21.  23 x 23,  23 x 24,  23 x 24,  25 x 26.   C0 = 58  C2 = 97
    medFontSizes.KuenstlerU    = 12;  % [k: 14] [14 x 22]   19 x 28.  22 x 30,  24 x 30,  26 x 32,  28 x 32.   C0 = 68  C2 = 241




    % big: aim for height~21-22 or so
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    average    unrotated   rot 5,    rot 10    rot 15    rot 20                           
    bigFontSizes.Braille       =  8;  % [k: 24] [24 x 16]   24 x 16.  27 x 19,  27 x 21,  29 x 23,  29 x 23.   C0 = 10  C2 = 37
    bigFontSizes.Checkers4x4   =  6;  
    bigFontSizes.Sloan         = 14;  % [k: 22] [22 x 23]   22 x 24.  25 x 27,  27 x 29,  29 x 29,  29 x 31.   C0 = 42  C2 = 44
    bigFontSizes.Helvetica     = 18;  % [k: 22] [19 x 13]   28 x 23.  31 x 24,  31 x 26,  31 x 26,  33 x 27.   C0 = 46  C2 = 50
    bigFontSizes.Bookman       = 19;  % [k: 24] [20 x 18]   32 x 31.  34 x 32,  35 x 33,  36 x 34,  36 x 34.   C0 = 56  C2 = 62
%     bigFontSizes.Georgia       = 18;  % [k: 21] [21 x 19]   27 x 30.  30 x 32,  32 x 34,  34 x 36,  35 x 38.   C0 = 78  C2 = 107
    bigFontSizes.Courier       = 20;  % [k: 20] [17 x 17]   26 x 20.  29 x 23,  29 x 25,  31 x 27,  33 x 29.   C0 = 74  C2 = 119
    bigFontSizes.Yung          = 18;  % [k: 21] [22 x 20]   26 x 25.  27 x 27,  28 x 28,  28 x 29,  29 x 29.   C0 = 68  C2 = 105
    bigFontSizes.KuenstlerU    = 14;  % [k: 16] [16 x 25]   22 x 32.  25 x 34,  28 x 35,  30 x 36,  32 x 37.   C0 = 83  C2 = 286


    % large: aim for height~33-35 or so
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    average    unrotated   rot 5,    rot 10    rot 15    rot 20                           
    largeFontSizes.Braille      = 11;  % [k: 33]   [33 x 22]   33 x 22.  35 x 25,  37 x 29,  39 x 31,  39 x 33.   C0 = 27  C2 = 28
    largeFontSizes.Checkers4x4  =  9;  % [k: 36]   [35 x 35]   36 x 36.  39 x 39,  43 x 43,  45 x 45,  47 x 47.   C0 = 49  C2 = 52
    largeFontSizes.Sloan        = 20;  % [k: 33]   [33 x 33]   33 x 34.  37 x 37,  39 x 41,  41 x 43,  43 x 45.   C0 = 45  C2 = 44
    largeFontSizes.Helvetica    = 24;  % [k: 29]   [26 x 17]   37 x 29.  39 x 30,  41 x 32,  41 x 34,  41 x 36.   C0 = 51  C2 = 54
    largeFontSizes.Bookman      = 28;  % [k: 35]   [29 x 25]   47 x 40.  49 x 42,  50 x 44,  51 x 44,  52 x 46.   C0 = 66  C2 = 71
    largeFontSizes.Courier      = 28;  % [k: 29]   [25 x 22]   39 x 28.  41 x 31,  42 x 33,  44 x 34,  45 x 36.   C0 = 100  C2 = 126
    largeFontSizes.Yung         = 24;  % [k: 28]   [29 x 27]   35 x 33.  37 x 35,  37 x 36,  37 x 37,  38 x 38.   C0 = 86  C2 = 119
    largeFontSizes.KuenstlerU   = 24;  % [k: 27]   [28 x 42]   40 x 59.  44 x 61,  46 x 62,  50 x 64,  53 x 64.   C0 = 196  C2 = 384

    
    

%     % dflt: what i had before
%     defaultFontSize.Braille      =  9; % 20 x 29.  29 x 21,  31 x 23,  31 x 25,  33 x 27.   C0 = 27  C2 = 28
%     defaultFontSize.Sloan        = 16; % 28 x 29.  29 x 31,  31 x 31,  33 x 33,  35 x 35.   C0 = 42  C2 = 43
%     defaultFontSize.Helvetica    = 20; % 33 x 25.  33 x 25,  35 x 27,  35 x 29,  35 x 29.   C0 = 49  C2 = 55
%     defaultFontSize.Bookman      = 18; % 32 x 30.  31 x 31,  32 x 31,  33 x 31,  33 x 33.   C0 = 55  C2 = 63
%     defaultFontSize.GeorgiaU = 16; % 26 x 31.  27 x 33,  28 x 33,  30 x 35,  32 x 37.   C0 = 59  C2 = 85
%     defaultFontSize.Courier      = 21; % 32 x 24.  32 x 25,  32 x 25,  34 x 29,  34 x 31.   C0 = 78  C2 = 121
%     defaultFontSize.Yung         = 21; % 32 x 32.  32 x 32,  33 x 32,  34 x 34,  34 x 34.   C0 = 78  C2 = 114
%     defaultFontSize.Kuenstler    = 14; % 24 x 33.  25 x 33,  27 x 35,  30 x 36,  32 x 37.   C0 = 83  C2 = 286

    % dflt: what i had before
    dfltFontSizes.Braille       =  9;  % [k: 27] [27 x 18]   27 x 18.  29 x 21,  31 x 23,  31 x 25,  33 x 27.   C0 = 11  C2 = 39
    dfltFontSizes.Sloan         = 16;  % [k: 26] [26 x 27]   26 x 28.  29 x 31,  31 x 33,  33 x 35,  35 x 35.   C0 = 42  C2 = 43
    dfltFontSizes.Helvetica     = 17;  % [k: 21] [18 x 12]   27 x 21.  29 x 22,  29 x 24,  31 x 24,  31 x 25.   C0 = 44  C2 = 49
    dfltFontSizes.Bookman       = 15;  % [k: 18] [15 x 14]   24 x 25.  26 x 26,  27 x 26,  28 x 27,  29 x 28.   C0 = 45  C2 = 71
%     dfltFontSizes.Georgia       = 16;  % [k: 19] [19 x 19]   24 x 30.  27 x 32,  29 x 34,  30 x 36,  32 x 36.   C0 = 59  C2 = 85
    dfltFontSizes.Courier       = 19;  % [k: 20] [17 x 17]   26 x 20.  29 x 23,  29 x 23,  31 x 25,  31 x 27.   C0 = 72  C2 = 113
    dfltFontSizes.Yung          = 17;  % [k: 20] [20 x 19]   25 x 23.  27 x 25,  27 x 26,  27 x 27,  27 x 28.   C0 = 62  C2 = 99
    dfltFontSizes.KuenstlerU    = 13;  % [k: 15] [15 x 24]   22 x 31.  25 x 32,  26 x 34,  29 x 35,  31 x 35.   C0 = 77  C2 = 270

    
    
%     Braille: 29 x 20   ok  
% Bookman: 26 x 26   ** 15 close          [    3, 26, 5, 28]
% Courier: 27 x 21   ** 19 ok            3    27     8    26
% Georgia: 26 x 31   ok
% Helvetica: 28x33   ** -->19 close     [2    27     7    27]
% Sloan:     28x29   ok
% Yung:      27x25   ** -->17 ok
% Kuenstler 24x33    ok
    
    allStyles.orig = origFontSizes;
    allStyles.sml = smlFontSizes;
    allStyles.med = medFontSizes;
    allStyles.big = bigFontSizes;
    allStyles.dflt = dfltFontSizes;
    allStyles.large = largeFontSizes;


end

%{
        haveUpperAndLowerCase = haveUpperAndLowerCaseForFont(getRawFontName(fontNames{i}));

        if sizeStyle(1) == 'k'  % k-height       
            if useUpperCaseKforK_height && haveUpperAndLowerCase
                rawFontName_i = uppercaseVersion(rawFontName_i); 
            end
            all_font_k_heights = S_fontSizes.([rawFontName_i '_k_heights']);
            size_idx = find( all_font_k_heights >= sizeVal, 1);

        elseif sizeStyle(1) == 'x' % x-height
            if useLowerCaseXforX_height && haveUpperAndLowerCase
                rawFontName_i = lowercaseVersion(rawFontName_i, dontUseLowerCaseForKuenstler); 
            end
            all_font_x_heights = S_fontSizes.([rawFontName_i '_x_heights']);
            size_idx = find( all_font_x_heights >= sizeVal, 1);

        end
%}