function loadOpts_str = getLoadOptsStr(loadOpts)
    
    pctUse_str = '';
    pctUse = loadOpts.totalUseFrac * 100;
    if pctUse < 100 then
       pctUse_str = sprintf('_use%d', pctUse);
    end
    
    loadOpts_str = pctUse_str;
    
end

