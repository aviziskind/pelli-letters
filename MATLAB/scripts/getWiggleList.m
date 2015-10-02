function wiggleList = getWiggleList(wiggleSettings)
    %%
    is_already_list = true;
    for i = 1:length(wiggleSettings)
        [~, nWigglesTot] = getSnakeWiggleStr(wiggleSettings(i));
        if nWigglesTot > 1
            is_already_list = false;
        end        
    end
    %%
    if is_already_list
        wiggleList = wiggleSettings;
        return
    end
    
    [~, ~, nWigglesTot] = getSnakeWiggleStr(wiggleSettings);
    wiggleList = cell(1, nWigglesTot);
    curIdx = 1;

    
    haveNoWiggle = isfield(wiggleSettings, 'none') || ...
        isfield(wiggleSettings, 'orientation') && any(wiggleSettings.orientation == 0) || ...
        isfield(wiggleSettings, 'offset') && any(wiggleSettings.offset == 0) || ...
        isfield(wiggleSettings, 'phase') && any(wiggleSettings.phase == 0);
    
    if haveNoWiggle
        wiggleList{curIdx} = struct('none', 1);
        curIdx = curIdx + 1;
    end
    

    haveOriWiggle = isfield(wiggleSettings, 'orientation');
    if haveOriWiggle 
        for ori = nonzeros(wiggleSettings.orientation)'
            wiggleList{curIdx} = struct('orientation', ori);
            curIdx = curIdx + 1;
        end
        
    end
    
    haveOffsetWiggle = isfield(wiggleSettings, 'offset');
    if haveOffsetWiggle 
        for offset = nonzeros(wiggleSettings.offset)'
            wiggleList{curIdx} = struct('offset', offset);
            curIdx = curIdx + 1;
        end
    end

    
    havePhaseWiggle = isfield(wiggleSettings, 'phase');
    if havePhaseWiggle 
        for phase = nonzeros(wiggleSettings.phase)'
            wiggleList{curIdx} = struct('phase', 1);
            curIdx = curIdx + 1;
        end
    end
    
    assert(curIdx-1 == nWigglesTot);
    
end







function tf = isSingleWiggle(wiggleSettings)
    nWiggles
   fn = fieldnames(wiggleSettings);
    
    
    
    
end