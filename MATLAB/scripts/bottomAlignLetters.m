
function [allLetters, allshifts] = bottomAlignLetters(allLetters)
    [H,~, nLetters] = size(allLetters);
    allshifts = zeros(1,nLetters);

    for i = 1:nLetters
        let_i = allLetters(:,:,i);
        nBlankOnBottom = H - find( sum(let_i, 2), 1, 'last');

        if nBlankOnBottom > 1     
            allshifts(i) = (nBlankOnBottom-1); 
            let_i_shft = circshift(let_i, [allshifts(i), 0 ]);
            allLetters(:,:,i) = let_i_shft;
        end


    end

end
