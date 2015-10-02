function italicLetters = makeFontItalic(letters, theta)
%%
    [h_orig, w_orig, nLetters] = size(letters); %#ok<ASGLU>
    h_margin = 5;
    w_margin = round(h_orig * 1.2 * tan( deg2rad( abs(theta) ) ) );
    lettersPadded = padarray(letters, [h_margin, w_margin], 0, 'both');
    
    [m,n, ~] = size(lettersPadded);
    
%     italicLettersPadded = zeros(size(letters));
    for let_idx = 1:nLetters
        
%         let_orig = letters(:,:,let_idx);
        let_padded = lettersPadded(:,:,let_idx);
        
        let_sheared = shearImage(let_padded, -theta);
%         let_sheared_tmp = shearImage(let_padded, -theta);
        3;
        lettersPadded(:,:,let_idx) = let_sheared(1:m, 1:n);
%         let_sheared_cent = shiftAndCropToMatchCOM(let_sheared, let_orig)
        
%         lettersPadded(:,:,let_idx) = 
        
        
    end

    lettersPadded = centerAlignLetters(lettersPadded);
    margin = 0;
    [~, ~, ~, ~, italicLetters] = findLetterBounds(lettersPadded, margin);
        3;



end