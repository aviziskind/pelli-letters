function [allLetters, fontData] = loadLetters(fontName, fontSize, fontSizeSpec, newData)
        
    persistent S_fonts nNewFields dateLoaded

    fontsFile = [lettersCodePath 'fonts.mat'];
    redoAll = 0;
    
    if nargin < 3 || isempty(fontSizeSpec)
        fontSizeSpec = 'exact';
    end
    
    outOfDate = ~isempty(dateLoaded) && exist(fontsFile, 'file') && fileOlderThan(dateLoaded, fontsFile);
    if isempty(S_fonts) || outOfDate
        if exist(fontsFile, 'file') && ~redoAll
            tic; fprintf('Loading fonts file .. ');
            S_fonts = load(fontsFile);
            toc;
            dateLoaded = now;
        else
            S_fonts = struct;
        end
        nNewFields = 0;
    end
    
    if nargin >= 1 && strcmp(fontName, 'save') 
        if ~isempty(S_fonts) && (nNewFields > 0)
            %%
            fprintf('Saving fonts file ... '); tic;
            S_fonts = orderfields(S_fonts);
            save(fontsFile, '-struct', 'S_fonts');
            nNewFields = 0;
            dateLoaded = now; % don't have to reload next time, because up to date.
            fprintf('done.'); toc;
        end
        return
    end
        
    fontData = [];
    if nargin == 0
        allLetters = S_fonts;
        return;
    elseif nargin == 1
        allLetters = S_fonts.(fontName);
        return
    end
    
    isSnakesFont = isstruct(fontName) && strcmp(fontName.fonts, 'Snakes');
    if isSnakesFont
        fontName = ['Snakes' getSnakeWiggleStr(fontName.wiggles)];
    end
    
    if ischar(fontSize)
        fontSize_orig = fontSize;
        fontSize = getFontSize(fontName, fontSize, fontSizeSpec);
        if isempty(fontSize)
            error('No %s font that matches size %s (%s)', fontName, fontSize_orig, fontSizeSpec);
        end
    end    
%%    
    if length(fontSize) > 1
        fontSize_end = fontSize(1);
        fontSize_src = fontSize(2);
        
        scaleFactor = fontSize_end / fontSize_src;
        assert(scaleFactor == round(scaleFactor));        
    else
        fontSize_src = fontSize;
        scaleFactor = 1;
    end
    
    if ~isempty(fontSize_src)
        font_field_name = sprintf('%s_%02d', fontName, fontSize_src);
    else
        font_field_name = fontName;
    end
    haveNewData = nargin >= 4 && ~isempty(newData);
    removeData = nargin >= 4 && isempty(newData);
    
    
    isSnakesFont = strncmpi(fontName, 'Snakes', 6);
    
    if haveNewData
        if isfield(newData, 'letters')
            if isSnakesFont
                assert(isa(newData.letters, 'int8'))   ;
            else
                assert(isa(newData.letters, 'uint8'))   ;
            end
        end
        S_fonts.(font_field_name) = newData;
        nNewFields = nNewFields + 1;
        return
    end
    
    %otherwise, are in 'load' mode:
    fontData = S_fonts.(font_field_name);

    
    allLetters = single( fontData.letters);
    if isSnakesFont
        scale_range = [-1, 1];
        allLetters = rescaleToRangeWithoutOffset( allLetters, scale_range );    
    else
        scale_range = [0, 1];
        allLetters = rescaleToRange( allLetters, scale_range );    
    end
    
    fontData.letters = allLetters;
    %%
    if scaleFactor > 1
        %%
%         for scaleFactor = 1:9

        allLetters = scaleByPixelRep(allLetters, scaleFactor);

%             dx = (1/scaleFactor);
%             [m,n] = size(allLetters(:,:,1));
%             vidxs = floor(1: dx : m+ 1-dx);  % 1,1, 2,2, 3,3, ... m,m
%             hidxs = floor(1: dx : n+ 1-dx);  % 1,1, 2,2, 3,3, ... n,n
%             assert(length(vidxs) == m*scaleFactor);
%             assert(length(hidxs) == n*scaleFactor);
% 
% 
%             allLetters = allLetters(vidxs, hidxs, :);
%             allLetters_bw_scl = allLetters_bw(vidxs, hidxs, :);
%             C(scaleFactor) = calculateFontComplexity(allLetters_scl);
%             C_bw(scaleFactor) = calculateFontComplexity(allLetters_bw_scl);
%         end
    end


end

