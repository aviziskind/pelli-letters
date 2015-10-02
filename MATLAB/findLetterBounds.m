function [idxT, idxB, idxL, idxR, allLetters_cropped] = findLetterBounds(allLetters_ext, margin, indivLettersFlag)
    if nargin < 2
        margin = 0;
    end
    doIndivLetters = exist('indivLettersFlag', 'var') && isequal(indivLettersFlag, 1);

    [nRows, nCols] = size(allLetters_ext(:,:,1));

    if doIndivLetters
        allLet = allLetters_ext;
    else
        allLet = sum(allLetters_ext,3);
    end
    n = size(allLet,3);
    [idxT, idxB, idxL, idxR] = deal(zeros(1, n));
    for i = 1:n
        let_i = allLet(:,:,i);
        
        bnd_T = find( sum(let_i,2), 1, 'first');
        bnd_B = find( sum(let_i,2), 1, 'last');
        bnd_L = find( sum(let_i,1), 1, 'first');
        bnd_R = find( sum(let_i,1), 1, 'last');

        idxT(i) = max( bnd_T - margin, 1);
        idxB(i) = min( bnd_B + margin, nRows);
        idxL(i) = max( bnd_L - margin, 1);
        idxR(i) = min( bnd_R + margin, nCols);
    
    end
    if nargout >= 5
        if doIndivLetters
            error('can''t return cropped letters if cropped each one individually')
        else
            allLetters_cropped = allLetters_ext(idxT:idxB, idxL:idxR, :);
        end
    end

    4;
end