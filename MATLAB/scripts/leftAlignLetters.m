
function [allLetters, allshifts] = leftAlignLetters(allLetters)
    nLetters = size(allLetters,3);
    allshifts = zeros(1,nLetters);

    for i = 1:nLetters
        let_i = allLetters(:,:,i);
        nBlankOnLeft = find( sum(let_i, 1), 1)-1;

        if nBlankOnLeft > 1     
            allshifts(i) = (nBlankOnLeft-1); 
            let_i_shft = circshift(let_i, [0, -allshifts(i) ]);
            allLetters(:,:,i) = let_i_shft;
        end


    end

end
