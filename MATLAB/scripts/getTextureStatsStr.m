function textureStats_str = getTextureStatsStr(letterOpts)
    
    textureStats_str = sprintf('_N%d_K%d_M%d', letterOpts.Nscl_txt, letterOpts.Nori_txt, letterOpts.Na_txt);
    if ~strcmp(letterOpts.textureStatsUse, 'V2') 
        textureStats_str = [textureStats_str '_' letterOpts.textureStatsUse];
    end


end
