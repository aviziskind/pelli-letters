function [V1s, V1c, V1hp_sc, V1lp_sc] = getSteerDecomp_V1(image_i, Nscl, Nori)
    
    [pyr0,pind0] = buildSCFpyr(image_i,Nscl,Nori-1);
    V1s_C = cell(Nscl, Nori);
    V1c_C = cell(Nscl, Nori);
    for sc_i = 1:Nscl
        for or_i = 1:Nori
            3;
            band_idx = (sc_i-1)*Nori+or_i+1;
            indices = pyrBandIndices(pind0,band_idx);
            
            V1s_C{sc_i,or_i} = real( pyr0(indices) );
            V1c_C{sc_i,or_i} = abs( pyr0(indices) );
        end
    end
    V1hp = pyr0(pyrBandIndices(pind0,1));    
    V1hp_s = real( V1hp );
    V1hp_c = abs(  V1hp );
    V1hp_sc = [V1hp_s(:); V1hp_c(:)];
    
    V1lp = pyrLow(pyr0,pind0);
    V1lp_s = real( V1lp );
    V1lp_c = abs(  V1lp );
    V1lp_sc = [V1lp_s(:); V1lp_c(:)];
    
    V1s = vertcat(V1s_C{:});
    V1c = vertcat(V1c_C{:});
    
end