function textureStats_str = getTextureStatsStr(letterOpts)
    
    textureStats_str = '';
    
    if strncmp(letterOpts.textureStatsUse, 'V2', 2)
        useExtraV2Stats_str = iff(strcmp(letterOpts.textureStatsUse, 'V2r'), '_r', '');
        textureStats_str = sprintf('_N%d_K%d_M%d%s', letterOpts.Nscl_txt, letterOpts.Nori_txt, letterOpts.Na_txt, useExtraV2Stats_str);

    elseif strcmp(letterOpts.textureStatsUse, 'V1')
        textureStats_str = sprintf('_N%d_K%d_%s', letterOpts.Nscl_txt, letterOpts.Nori_txt, letterOpts.Na_txt, opts.textureStatsUse);

    end


end
