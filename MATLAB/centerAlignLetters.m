function [allLetters, allshifts] = centerAlignLetters(allLetters)
    nLetters = size(allLetters,3);
    allshifts = zeros(1,nLetters);

    for i = 1:nLetters
        let_i = allLetters(:,:,i);
        cols = sum(let_i, 1);
        nBlankOnLeft = find( cols, 1, 'first')-1;
        nBlankOnRight = length(cols) - find( cols, 1, 'last');
        
        amountToShift = floor((nBlankOnRight-nBlankOnLeft)/2);
        if (nBlankOnRight == 0) && (nBlankOnLeft == 1)
           amountToShift = 0;
        end
        if abs(amountToShift) > 0
            allshifts(i) = amountToShift; 
            let_i_shft = circshift(let_i, [0, amountToShift]);
            allLetters(:,:,i) = let_i_shft;
        end


    end

end