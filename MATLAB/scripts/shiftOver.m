function xs = shiftOver(x, n)
    L = length(x);
    if n >= 0 % shift to the right
        xs = [ones(1,min(n,L))*x(1),  x(1:end-n)];
        
    elseif n < 0  % shift to the left
        xs = [x(-n+1:end), ones(1, min(-n,L) )*x(end)];
        
    end
        



end


