function [hnd, bndBox] = rectangleSet(L, B, w, h, spc, nRects)

    hnd = zeros(1,nRects);
    for i = nRects:-1:1
        hnd(i) = rectanglePix([L-spc*(i-1), B+spc*(i-1), w, h]);
    end
    set(hnd, 'facecolor', 'w')
    
    bndL = L - spc*(nRects-1);
    bndR = L + w;
    bndB = B;
    bndT = B + h + spc*(nRects-1);
    bndBox = [bndL, bndB, bndR, bndT];
    if 0
        h_bnd = rectanglePix([bndL, bndB, bndR-bndL, bndT-bndB]);

        hnd = [hnd, h_bnd];
    end    
end

