function [strokeFrequency_perPix, strokeFrequency_perLet] = getFontStrokeFrequency(allLetters, fontName)
%%
    allLetters = padarray(allLetters, [3 3], 0, 'both');
%     allLetters = addMargin(allLetters, 3);
    [H,W,nLetters] = size(allLetters); %#ok<ASGLU>
    [idxT, idxB, idxL, idxR] = findLetterBounds(allLetters, 0, 1);

    allHeights = idxB-idxT+1;
    allWidths = idxR-idxL+1;

    k_height = allHeights(find('A':'Z' == 'K', 1));

    capsFont = strncmp(fontName, 'Yung', 4) || strncmp(fontName, 'Sloan', 5) || strncmp(fontName, 'Hebraica', 8) ......
        || fontName(end) == 'U' || fontName(end-1) == 'U';
    if capsFont
        height = k_height;
    else
        x_height = allHeights(find('A':'Z' == 'X', 1));
        height = x_height;
    end
    startHeight = idxB(1) - floor(height/2)-1;
    
    nCrossesEachLetter = zeros(H,nLetters);
    for let_i = 1:nLetters
        letter_i = allLetters(:,:,let_i);
        for h = 1:H
            nCrossesEachLetter(h, let_i) = nLineCrosses(letter_i(h,:));
        end
    end
    
    h_use = startHeight;

    meanNcross_allHeights = mean(nCrossesEachLetter, 2 );
    strokeFrequency_perLet = meanNcross_allHeights(h_use);
    meanWidth_pix = mean(allWidths);
    strokeFrequency_perPix = strokeFrequency_perLet / meanWidth_pix;
    3;

end

function n = nLineCrosses(h_rule)
    pix_prev = h_rule(1:end-2);
    pix_cur  = h_rule(2:end-1);
    pix_next = h_rule(3:end);
    %%
    
    lineStarts_orLocalMin = (pix_prev >= pix_cur) & (pix_cur < pix_next); % start of line (or local minimum) 
%      lineStarts= h_rule(1:end-1) == 0 & h_rule(2:end) > 0
    n = nnz(lineStarts_orLocalMin);
    3;

end
   






