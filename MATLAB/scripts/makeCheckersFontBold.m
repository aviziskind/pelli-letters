function boldLetters = makeCheckersFontBold(letters, boldFactor)
 

    [h_orig, w_orig, nLetters] = size(letters); %#ok<NASGU,ASGLU>
    h_margin = 2 + round(w_orig / 2);
    w_margin = 2 + round(w_orig / 2);
    lettersPadded = padarray(letters, [h_margin, w_margin], 0, 'both');

    nPixOrig = nnz(letters(:));
    curIncrease = 0;
    shift_amt = 0;
    while curIncrease < boldFactor
        shift_amt = shift_amt + 1;
%         let_shL = circshift(lettersPadded, [0, -shift_amt]);
        let_shR = circshift(lettersPadded, [0,  shift_amt]);
%         let_shU = circshift(lettersPadded, [-shift_amt, 0]);
%         let_shD = circshift(lettersPadded, [shift_amt,  0]);

%         toAdd = ~lettersPadded & (let_shL | let_shR);
         toAdd = ~lettersPadded & (let_shR);
        curIncrease = (nPixOrig + sum(toAdd(:))) / nPixOrig;
    end


    lettersPadded = max(lettersPadded, let_shR);
    
%     lettersPadded = centerAlignLetters(lettersPadded);
    margin = 0;
    [~, ~, ~, ~, boldLetters] = findLetterBounds(lettersPadded, margin);



end

