function let_rot = rotateLetters(allLetters, ori, margin)
    if nargin < 3
        margin = [];
    end
    
    
    nOris = length(ori);
    if nOris > 1

        let_rot = cell(1, nOris);
        for ori_i = 1:nOris
            let_rot{ori_i} = rotateLetters(allLetters, ori(ori_i));
        end
        if ~isempty(margin)
            [idxT, idxB, idxL, idxR] = findLetterBounds(let_rot{ori_i}, margin);
            let_rot{ori_i} = let_rot{ori_i}(idxT:idxB, idxL:idxR, :);
        end
        
        return
    end
    
    nLet = size(allLetters,3);
    let_rot1 = imrotate(allLetters(:,:,1), ori, 'bilinear');

    let_rot = zeros(size(let_rot1,1), size(let_rot1,2), nLet);
    let_rot(:,:,1) = let_rot1;

    for i = 2:nLet
        let_rot(:,:,i) = imrotate(allLetters(:,:,i), ori, 'bilinear');
    end

end