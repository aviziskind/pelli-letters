function [h_ax, h_im] = displayPyramidCross(pyrBands_C, scl, spc_frac, margin_frac, cent_margin_frac)
    if nargin < 2
        scl = 1;
    end
    if nargin < 3
        spc_frac = 0.5;
    end
    if nargin < 4
        margin_frac = 0.5;
    end
    if nargin < 5
        cent_margin_frac = 1.5;
    end

    for i = 1:numel(pyrBands_C)
        pyrBands_C{i} = real(pyrBands_C{i});
    end
    
    [nOri, nScl] = size(pyrBands_C);
    assert(nOri == 4);

    bandSzs = cellfun(@length, pyrBands_C(1,:));
    
    spc = spc_frac * scl * min(bandSzs);
    margin = margin_frac * scl * min(bandSzs);
    cent_margin = cent_margin_frac * scl * bandSzs(end);    

    C = margin + sum(bandSzs)*scl + spc*(nScl-1) + cent_margin/2;
    
    caxis_ext_factor = 0;
    
    [allL, allB, h_ax, h_im] = deal( zeros(nOri, nScl) );
    
    for si = 1:nScl

        allL(1, si) = margin + spc*(si-1) + sum(bandSzs(1:si-1)*scl);
        allB(1, si) = C-bandSzs(si)*scl/2;

        h_ax(1,si) = axes('units', 'pixels', 'position', [allL(1,si), allB(1,si), bandSzs(si)*scl, bandSzs(si)*scl]); %#ok<*LAXES>
        h_im(1,si) = imagesc(pyrBands_C{1, si}); ticksOff;
        caxis( lims(pyrBands_C{1, si}(:), caxis_ext_factor) );

        allL(3, si) = 2*C - (margin + spc*(si-1) + sum(bandSzs(1:si)*scl)) ;
        allB(3, si) = C-bandSzs(si)*scl/2;

        h_ax(3,si) = axes('units', 'pixels', 'position', [allL(3,si), allB(3,si), bandSzs(si)*scl, bandSzs(si)*scl]);
        h_im(3,si) = imagesc(pyrBands_C{3, si}); ticksOff;
        caxis( lims(pyrBands_C{3, si}(:), caxis_ext_factor) );



        allL(2, si) = C-bandSzs(si)*scl/2;
        allB(2, si) = margin + spc*(si-1) + sum(bandSzs(1:si-1)*scl);

        h_ax(2,si) = axes('units', 'pixels', 'position', [allL(2,si), allB(2,si), bandSzs(si)*scl, bandSzs(si)*scl]);
        h_im(2,si) = imagesc(pyrBands_C{2, si}); ticksOff;
        caxis( lims(pyrBands_C{2, si}(:), caxis_ext_factor) );

        allL(4, si) = C-bandSzs(si)*scl/2;
        allB(4, si) = 2*C - (margin + spc*(si-1) + sum(bandSzs(1:si)*scl)) ;

        h_ax(4,si) = axes('units', 'pixels', 'position', [allL(4,si), allB(4,si), bandSzs(si)*scl, bandSzs(si)*scl]);
        h_im(4,si) = imagesc(pyrBands_C{4, si}); ticksOff;
        caxis( lims(pyrBands_C{4, si}(:), caxis_ext_factor) );

    end
            
    colormap('gray');
end