function [padBox, success] = addPaddingToBox(box, pad_amount, padding_dim)
    nPadAB = pad_amount;
    nPadA = floor(nPadAB/2);
    nPadB = nPadAB - nPadA;
    % check that doesn't go over boundary:

    if padding_dim == 1
        spaceA = box.spaceOnTop;
        spaceB = box.spaceOnBottom;
    elseif padding_dim == 2;
        spaceA = box.spaceOnLeft;
        spaceB = box.spaceOnRight;
    end
    
    nExtra_A = nPadA - spaceA;
    nExtra_B = nPadB - spaceB;

    success = 1;
    if nExtra_A < 0  || nExtra_B < 0
        if nExtra_A + nExtra_B <= pad_amount
            % have enough padding, but might have to transfer some
            % from one to the other
            if nExtra_A < 0
                nPadL = box.spaceOnLeft;
                nPadR = nPadLR - nPadL;

            elseif nExtra_B < 0
                nPadR = box.spaceOnRight;
                nPadL = nPadLR - nPadR;

            end

        else
            success = 0;
            keyboard;

        end




    end
    
    padBox = box;
    padBox.left = box.left - nPadL;
    padBox.right = box.right - nPadR;

end