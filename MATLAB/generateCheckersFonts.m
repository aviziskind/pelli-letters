function generateCheckersFonts

    nameFor2x3Checkers = 'Braille';
%     fontsToCreate = {};
    fontsToCreate = {'Checkers2x3'};
    fontsToCreate = {'Checkers2x3', 'Checkers4x4'};
%     fontsToCreate = {'Checkers2x3', 'Checkers4x4', 'Ascii5x7'};
%     fontsToCreate = {'Checkers4x4'};
%     fontSizesToDo = [8, 28, 36, 48, 60, 72];
%     fontSizesToDo = [1:20];

%     alsoCreateBoldFonts = true;
%     alsoCreateItalicFonts = true;
    opt.centerAlignFonts = 0;
    opt.orientations = [0:5:90];    
    opt.margin_pixels = 0;
    opt.margin_pixels_rotated = 0;

    alsoCreateBoldFonts = true;
        boldFactor = 1.1;
    alsoCreateItalicFonts = true;
        italicSlopeDegrees = 10;
  
    show = 1 && onLaptop;
        saveToFontsFile = true;
        

    sizeMax = 85;
%     brailleFontSizes = [24];
%     fontName = 'Braille';
%     allLetterCodes = getBrailleCode; % real braille
%     fontSizesToDo = [10, 20, 40];

    for i = 1:length(fontsToCreate)
        
        fontName = fontsToCreate{i};
        
        switch fontName
            case 'Checkers2x3',
                allLetterCodes = get2x3CheckersFont;
                fontName_save = nameFor2x3Checkers;
                fontSizesToDo = 1: round(sizeMax/3);
                
            case 'Checkers4x4',
                allLetterCodes = get4x4CheckersFont;
                fontName_save = fontName;
                fontSizesToDo = 1: round(sizeMax/4);

            case 'Ascii5x7',
                allLetterCodes = get5x7Font;
                fontName_save = fontName;
                fontSizesToDo = 1: round(sizeMax/7);
        end
    
        fprintf('==== Generating "%s" font =====\n', fontName)
    
        fontStyles = {'Regular'};
        if alsoCreateBoldFonts 
            fontStyles = [fontStyles, 'Bold'];            
        end
        if alsoCreateItalicFonts
            fontStyles = [fontStyles, 'Italic'];
        end
        if alsoCreateBoldFonts && alsoCreateItalicFonts
            fontStyles = [fontStyles, 'BoldItalic']; %#ok<*AGROW>
        end
%         fontStyles = {'Italic'};

        for style_i = 1:length(fontStyles)
            
            fontStyle = fontStyles{style_i};

            for size_i = 1:length(fontSizesToDo)

                fontName_save_full = fontName_save;
                margin_pixels = 0;
                fontSize = fontSizesToDo(size_i);

                fprintf('\n\n === %s, Size = %d...  ', fontName_save_full, fontSize)
                allLetters = createSignalMatrix(allLetterCodes, fontSize, margin_pixels);

                bold_tf = ~isempty(strfind(fontStyle, 'Bold'));
                italic_tf = ~isempty(strfind(fontStyle, 'Italic'));
                
                if bold_tf
                    allLetters = makeCheckersFontBold(allLetters, boldFactor);
                    fontName_save_full = [fontName_save_full 'B'];
                end
                if italic_tf
                    allLetters = makeFontItalic(allLetters, italicSlopeDegrees);
                    shearAngle = italicSlopeDegrees;
                    fontName_save_full = [fontName_save_full 'I'];
                else
                    shearAngle = 0;
                end
                
              

                fontData = measureFontStatistics(fontName_save_full, allLetters, opt);
%                 allLetters = fontData.letters;

                fontData.fontsize = fontSize;
                fontData.shearAngle = shearAngle;
    
                S = fontData;

                % Printout
                fprintf('   C0 = %.1f. C1 = %.1f. C2 = %.1f\n\n', S.complexity_0, S.complexity_1, S.complexity_2)

                oris_rotated = opt.orientations;
                idx_5  = find(oris_rotated==5,1);
                idx_10 = find(oris_rotated==10,1);
                idx_15 = find(oris_rotated==15,1);
                idx_20 = find(oris_rotated==20,1);

                fprintf('          -> %d x %d.  %d x %d,  %d x %d,  %d x %d,  %d x %d. \n', ...
                    S.size, S.size_rotated([idx_5, idx_10, idx_15, idx_20], :)' );

    
                if saveToFontsFile
                    loadLetters(fontName_save_full, fontSize, [], fontData);
                end

%                 show = 1;
                if show
                    figure(12); clf;
                    letters_tiled = tileImages(allLetters, 5, 6, 10, 0);

                    imagesc(letters_tiled);
                    imageToScale;

                    axis equal tight;
                    set(gca, 'xtick', [], 'ytick', [])
                    colormap('gray');
                end
                
            end % of loop for each size
        
            addSummaryOfFontSizesToFontFile(fontName_save_full);
        end % of loop for each style

        
    end  % of loop for each checkers font

    if saveToFontsFile
        loadLetters('save');
    end
end



function signalMatrix = createSignalMatrix(brailleLetters, fontSize, margin)
    
    maxSignal = 255;
    nLetters = length(brailleLetters);
    3;
    [nBlocksH, nBlocksW] = size(brailleLetters{1});
    nH = fontSize*nBlocksH + margin*2;
    nW = fontSize*nBlocksW + margin*2;
    
    signalMatrix = zeros(nH, nW, nLetters);
    %%
    idx = 1:fontSize;
    r = cell(1,nBlocksH);
    for ri = 1:nBlocksH
        r{ri} = margin + fontSize*(ri-1) + idx;
    end
    c = cell(1,nBlocksW);
    for ci = 1:nBlocksW
        c{ci} = margin + fontSize*(ci-1) + idx;
    end
    %%
    
    for let_i = 1:nLetters
        let = brailleLetters{let_i};
        sig = zeros(nH, nW);
        
        for ri = 1:nBlocksH
            for ci = 1:nBlocksW
                sig(r{ri}, c{ci}) = let(ri, ci);                
            end
        end
 
        signalMatrix(:,:,let_i) = sig*maxSignal;
    end

    %{
    c1 = idx + 1;
    c2 = idx + fontSize + 1;
    r1 = idx + 1;
    r2 = idx + fontSize + 1;
    r3 = idx + fontSize*2 + 1;
    
    for let_i = 1:nLetters
        let = brailleLetters{let_i};
        sig = zeros(nH, nW);
        sig(r1,c1) = let(1,1); sig(r1,c2) = let(1,2);
        sig(r2,c1) = let(2,1); sig(r2,c2) = let(2,2);
        sig(r3,c1) = let(3,1); sig(r3,c2) = let(3,2);        
        signalMatrix(:,:,let_i) = sig*maxSignal;
    end
    %}
    3;

end



function allChecks = getAllCheckers

    allChecks = zeros(3,2,64);
    for i = 1:64
        
%         sig = zeros(3,2);
        sig = mod( bitshift(i, [0:-1:-5]), 2);
        allChecks(:,:,i) = reshape(sig, 3,2);        
        
    end

end