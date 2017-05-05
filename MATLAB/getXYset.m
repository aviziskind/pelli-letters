function s = getXYset(nx,ny,dx, dy)
    assert(nx > 0);
    assert(ny > 0);
    if nargin == 2
        dx = 1;
        dy = 1;
    elseif nargin == 3;
        dy = dx;
    end
        
   s = struct('oris', [0], 'xs', [0 : (nx-1)]*dx, 'ys', [0:(ny-1)]*dy );    
end