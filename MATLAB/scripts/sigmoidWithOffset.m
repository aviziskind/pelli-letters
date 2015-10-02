function s = sigmoidWithOffset(x, a, b, w, x50)
%     if nargin < 4
%         n = 1;
%     end
%     s = M./(1+exp( - n.*(x-c) ));
    zeroCenter = false;
    
    s = a + (b-a)./(1+exp( - (x-x50)/w) );

    
    
end