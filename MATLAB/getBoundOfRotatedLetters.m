function [nH_rot, nW_rot] = getBoundOfRotatedLetters(allLetters, oris_rotated, margin, print_flag)

    show = exist('print_flag', 'var') && isequal(print_flag, 1);
    nRotations = length(oris_rotated);
    
    nH_rot = zeros(nRotations, 1);
    nW_rot = zeros(nRotations, 1);
    
    useLetterSum = 1;
    for ori_i = 1:length(oris_rotated)
        
        if useLetterSum
            lettersUse = sum(allLetters, 3);
        else
            lettersUse = allLetters;
        end
        
        allLetters_rotated =  rotateLetters(lettersUse, oris_rotated(ori_i)*[-1, 1] );            
        allLetters_rotated_cat = cat(3, allLetters_rotated{:});        
        [idxT_rot, idxB_rot, idxL_rot, idxR_rot] = findLetterBounds(allLetters_rotated_cat, margin);
        
        nH_rot(ori_i) = idxB_rot-idxT_rot+1;
        nW_rot(ori_i) = idxR_rot-idxL_rot+1;
        if show
            fprintf('   When Rotated %d-%d: Image box is %d x %d (height x width)\n', oris_rotated(ori_i)*[-1,1], nH_rot(ori_i), nW_rot(ori_i));
        end
    end

end


% function [nH_rot, nW_rot, idxT_rot, idxB_rot, idxL_rot, idxR_rot] = getBoundOfRotatedLetters(allLetters, oris_rotated)
%     
%     allLettersRotated = rotateLetters(allLetters, oris_rotated);
% 
%     margin_pixels_rotated = 0;
%     [idxT_rot, idxB_rot, idxL_rot, idxR_rot] = findLetterBounds(allLettersRotated, margin_pixels_rotated);
%     nH_rot = idxB_rot-idxT_rot+1;
%     nW_rot = idxR_rot-idxL_rot+1;
% 
% end
