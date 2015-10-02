function [hnd, bndbox] = circleBank(L,C, m,n,sz, spc, nTot)


    
%     if nCircs_can_show < nTot
%         h_tot = nCircs_can_show * sz + (nCircs_can_show-1)*spc;
    all_circ_cents = [0:m-1]*(spc+sz); %  - h_tot/2;
    all_circ_cents = C + all_circ_cents - round((all_circ_cents(end)/2));
    assert( all(all_circ_cents > 0));
        
    %%

    hnd = zeros(1, nTot);
    for idx = 1:nTot
        [i,j] = ind2sub([m,n], idx);
        pos_i = [L+(j-1)*(spc+sz),  all_circ_cents(i) - round(sz/2),  sz, sz];
        hnd(idx) = ellipsePix(pos_i);
    end
    
    bndL = L;
    bndR = L+sz*n + spc *(n-1);
    bndB = min(all_circ_cents)-floor(sz/2);
    bndT = max(all_circ_cents)+ceil(sz/2);
    
    bndbox = [bndL, bndB, bndR, bndT];
    if 0
        h_bnd = rectanglePix([bndL, bndB, bndR-bndL, bndT-bndB]);
        hnd = [hnd, h_bnd];
    end


end