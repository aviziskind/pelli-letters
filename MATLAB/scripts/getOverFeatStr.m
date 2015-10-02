function overfeat_str = getOverFeatStr(letterOpts)
        
    networkId_default = 0;
    layerId_default = 19;
    
    networkId_str = '';
    layerId_str = '';
    contrast_str = '';

    
    imageFile_str = '';
    isImage = isfield(letterOpts, 'overFeatImageFile') && letterOpts.overFeatImageFile == true;
    if isImage
        imageFile_str = 'im';
    else
        
        % networkID
        networkId = networkId_default;
        if isfield(letterOpts, 'networkId')
            networkId = letterOpts.networkId;
        end

        if networkId ~= networkId_default
            networkId_str = sprintf('_Net%d', networkId);
        end

        % layerID
        layerId = layerId_default;
        if isfield(letterOpts, 'layerId')
            layerId = letterOpts.layerId;
        end

        if layerId ~= layerId_default 
            layerId_str = sprintf('_L%d', layerId);
        end       
        
        contrast_str = sprintf('_c%d_o%d', letterOpts.OF_contrast, letterOpts.OF_offset);
        
    end
    
    overfeat_str = sprintf('_OF%s%s%s%s', imageFile_str, networkId_str, layerId_str, contrast_str);
        
end