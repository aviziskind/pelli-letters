function [hnd, bndbox] = circleBankWithLetters(L,C, sz, spc, nTot, maxHeight)

    
    hgt_v_nCirc = sz*[1:nTot] + spc*([0:nTot-1]);
    skipSomeCircles = hgt_v_nCirc(end) > maxHeight;
    if skipSomeCircles
        nCircs_can_show = find(hgt_v_nCirc < maxHeight & ~mod(1:nTot,3), 1, 'last');
%         nCircs_can_show = 3;
        nCircsTop = nCircs_can_show/3;
        
        circ_idx_use = [1:nCircsTop, floor(nCircsTop*2)+1:nCircs_can_show];
        let_idxs_use = [1:nCircsTop, nTot-nCircsTop+1 : nTot];

    else
        nCircs_can_show = nTot;
        circ_idx_use = [1:nTot];
        let_idxs_use = [1:nTot];
    end
        
%%    
  %%  
%     C + [1:nCircs_can_show]*sz + [0:nCircs_can_show-1]*spc - (nCircs_can_show/2)*(sz+spc);
    
    nTot_use = length(circ_idx_use);
    
%     if nCircs_can_show < nTot
%         h_tot = nCircs_can_show * sz + (nCircs_can_show-1)*spc;
        all_circ_cents = [0:nCircs_can_show-1]*(spc+sz); %  - h_tot/2;
        all_circ_cents = C + all_circ_cents - (all_circ_cents(end)/2);
        all_circ_cents = fliplr(all_circ_cents);
        
%     end
    %%
    
%%
%     hnd_test = zeros(1,nCircs_can_show);
%     for idx = 1:nCircs_can_show
%         
%         h_i = all_circ_cents( idx );
%         pos_i = [L, h_i-sz/2, sz, sz];
%         hnd_test(idx) = ellipsePix(pos_i);
%         
%     end


%%

    hnd = zeros(nTot_use,2);
    for idx = 1:nTot_use
    
        circ_idx = circ_idx_use(idx);
        let_idx = let_idxs_use(idx);
        h_i = all_circ_cents( circ_idx );
        pos_i = [L, h_i-sz/2, sz, sz];
        hnd(idx, 1) = ellipsePix(pos_i);
        
        hnd(idx,2) = annotation('textbox', [0, 0, 1, 1], 'units', 'pixels', 'position', ...
            pos_i, 'string', char('a'+let_idx-1) );

        set( hnd(idx,2), 'LineStyle', 'none', 'horiz', 'center', 'vert', 'middle', ...
            'fontsize', 10)
            3;

    end
    
    hnd = hnd(:);
%%
    if skipSomeCircles
%         yy = [all_circ_cents(nCircsTop+1), all_circ_cents(2*nCircsTop+1)];
%         hnd_line = annotation('line', [0 1], [0 1], 'units', 'pixels', 'x', (L+sz/2) * [1,1], 'y', yy) ;
%         %%
%         set(hnd_line, 'lineStyle', ':', 'linewidth', 5)
        w = 2;
        yy_idxs = nCircsTop+1 : 2*nCircsTop;
        for i = 1:length(yy_idxs)
            pos_i = [L+sz/2-w/2, all_circ_cents( yy_idxs(i)) - w/2, w, w];
            hnd_mid(i) = ellipsePix(pos_i);
        end
        set(hnd_mid, 'faceColor', 'k');
        
        hnd = [hnd; hnd_mid(:)];
        
    end
    %%
    bndL = L;
    bndR = L+sz;
    bndB = all_circ_cents(end)-sz/2;
    bndT = all_circ_cents(1)+sz/2;
    
    bndbox = [bndL, bndB, bndR, bndT];
    if 0
        h_bnd = rectanglePix([bndL, bndB, bndR-bndL, bndT-bndB]);
        hnd = [hnd; h_bnd];
    end
    
    
end







