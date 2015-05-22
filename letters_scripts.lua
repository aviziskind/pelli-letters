

getNoisyLetterOptsStr = function(letterOpts)
        
    local oxyStr = getOriXYStr(letterOpts.OriXY)
    
    local targetPosition_str = ''       
    if letterOpts.targetPosition and letterOpts.targetPosition ~= 'all' then
        targetPosition_str = string.format('_T%d', letterOpts.targetPosition);
    end
    
    local nLetters_str = ''
    if letterOpts.nLetters and letterOpts.nLetters > 1 then
        nLetters_str = string.format('_L%d', letterOpts.nLetters);
    end
        
    local imageSizeStr = ''
    if not letterOpts.autoImageSize then
        imageSizeStr = string.format('-[%dx%d]', letterOpts.imageSize[1], letterOpts.imageSize[2]);        
    end
    
    local trainingImageSizeStr = ''
    if letterOpts.trainingImageSize and not isequal(letterOpts.trainingImageSize, 'same') 
            and not isequal(letterOpts.trainingImageSize, letterOpts.imageSize) then
        trainingImageSizeStr = string.format('_tr%dx%d', letterOpts.trainingImageSize[1], letterOpts.trainingImageSize[2]);        
    end

    
    local useBlur = letterOpts.blurStd and letterOpts.blurStd > 0
    local blurStr = ''
    if useBlur then
        blurStr = string.format('_blur%.0f', letterOpts.blurStd*10)
    end
    
    
    local trainingFonts_str = ''
    if letterOpts.trainingFonts and not isequal(letterOpts.trainingFonts, 'same') 
                                and not isequal(letterOpts.trainingFonts, letterOpts.fontName) then
        trainingFonts_str = '_trf' .. abbrevFontStyleNames(letterOpts.trainingFonts)
    end
    
    
    local trainingWiggle_str = ''
    if letterOpts.trainingWiggle and not isequal(letterOpts.trainingWiggle, 'same') 
                                 and not isequal(letterOpts.trainingWiggle, letterOpts.fontName.wiggles) then
        trainingWiggle_str = '_trW' .. getSnakeWiggleStr(letterOpts.trainingWiggle)
    end
    
    local trainingOriXY_str = ''
    if letterOpts.trainingOriXY and not isequal(letterOpts.trainingOriXY, 'same') 
                                and not isequal(letterOpts.trainingOriXY, letterOpts.OriXY) then
        trainingOriXY_str = '_trU' .. getOriXYStr(letterOpts.trainingOriXY)
    end
    
    
    local noiseFilter_str = noiseFilterOptStr(letterOpts)    -- includes "trained with" if appropriate

    local trainNoise_str = ''
    if letterOpts.trainingNoise and not isequal(letterOpts.trainingNoise, 'same') 
                                and not (filterStr(letterOpts.noiseFilter, 1) == filterStr(letterOpts.trainingNoise, 1)) then
        trainNoise_str = '_tr' .. filterStr(letterOpts.trainingNoise, 1)
        
    end
    
    
    assert(not (letterOpts.doOverFeat and letterOpts.doTextureStatistics))
    local textureStats_str = ''
    if letterOpts.doTextureStatistics then
        textureStats_str = getTextureStatsStr(letterOpts)    
    end
    
    local overFeat_str = '' 
    if letterOpts.doOverFeat then
        overFeat_str = getOverFeatStr(letterOpts)        
    end
    
    
    local retrainFromLayer_str = ''
    if letterOpts.retrainFromLayer and letterOpts.retrainFromLayer ~= '' then
        retrainFromLayer_str = '_rt' .. networkLayerStrAbbrev(letterOpts.retrainFromLayer)
    end
    
    local nPositions = letterOpts.Nori * letterOpts.Nx * letterOpts.Ny
    local indiv_pos_str = ''
    if letterOpts.trainOnIndividualPositions and (nPositions > 1) then
        indiv_pos_str = '_trIP'
    
        if letterOpts.retrainOnCombinedPositions then
            indiv_pos_str = indiv_pos_str .. '_rtCP'
        end
    end
                
                    
    local classifierForEachFont_str = ''
    local nFontShapes = (getFontClassTable(letterOpts.fontName)).nFontShapes
    if letterOpts.classifierForEachFont and (nFontShapes > 1) then
        classifierForEachFont_str = '_clsFnt'
    end    
                
                
    return oxyStr .. nLetters_str .. targetPosition_str .. imageSizeStr .. blurStr ..
            trainingOriXY_str .. trainingImageSizeStr .. trainingFonts_str .. trainingWiggle_str .. 
            noiseFilter_str .. trainNoise_str ..
            textureStats_str .. overFeat_str .. 
            retrainFromLayer_str .. indiv_pos_str .. classifierForEachFont_str
            
end




getOriXYStr = function(OriXY)
        --print(OriXY)
    local oxyStr
    local dOri, nOri = OriXY.dOri, OriXY.Nori
    local dX, nX     = OriXY.dX,   OriXY.Nx
    local dY, nY     = OriXY.dY,   OriXY.Ny
    
    if nOri == 1 and nX == 1 and nY == 1 then
        oxyStr = '1oxy'
    else
        
        local ori_lims_str = ''
        local x_lims_str = ''
        local y_lims_str = ''
        
        if nOri > 1 then
            ori_lims_str = string.format('%dori[%s]_', nOri, dOri);
        end
        
        if nX > 1 then
            x_lims_str = string.format('%dx[%s]_', nX, dX);
        end
        
        if nY > 1 then
            y_lims_str = string.format('%dy[%s]_', nY, dY);
        end
        
        
        oxyStr = string.format('%s%s%s',  ori_lims_str, x_lims_str, y_lims_str);
        oxyStr = string.sub(oxyStr, 1, #oxyStr-1) -- remove trailing '_'
        
        
        --local ori_lims_str = getLimitsStr(nOri, letterOpts.ori_range);
        --local x_lims_str = getLimitsStr(nX, letterOpts.x_range);
        --local y_lims_str = getLimitsStr(nY, letterOpts.y_range);        
        --oxyStr = string.format('%dori%s_%dx%s_%dy%s', nOri,ori_lims_str, nX,x_lims_str, nY,y_lims_str);
    end
    
    return oxyStr
end



noiseFilterOptStr = function(letterOpts)
     
    local useNoiseFilter = letterOpts.noiseFilter 
    local noiseFilter_str = ''
    if useNoiseFilter then
        
        local testFilt_str = filterStr(letterOpts.noiseFilter)
        -- define training noise string
        
        -- final test noise filter:
        noiseFilter_str =  '_' .. testFilt_str
        if #noiseFilter_str == 1 then
            noiseFilter_str = ''
        end
        
    end
    return noiseFilter_str
    
end
 
   


filterStr = function(filt, wForWhite)
    
    local filtStr
    
    
    local applyFourierMaskGainFactor_default = false
    local applyFourierMaskGainFactor = applyFourierMaskGainFactor_default
    if filt and filt.filterType == 'white' then
        applyFourierMaskGainFactor = false
    elseif filt and filt.applyFourierMaskGainFactor then
        applyFourierMaskGainFactor = filt.applyFourierMaskGainFactor
    end
    local normStr = iff(applyFourierMaskGainFactor, 'N', '')
    
    
    if filt == nil or filt == 'same' then
        filtStr = ''
        
    elseif filt.filterType == 'white' then
        if wForWhite then
            filtStr = 'w'
        else
            filtStr = ''
        end
        
    elseif filt.filterType == 'band' then
        filtStr = string.format('Nband%.0f', filt.cycPerLet_centFreq*10)
        
    elseif filt.filterType == 'hi' then
        filtStr = string.format('Nhi%.0f', filt.cycPerLet_cutOffFreq*10)
    
    elseif filt.filterType == 'lo' then
        filtStr = string.format('Nlo%.0f', filt.cycPerLet_cutOffFreq*10)

    elseif filt.filterType == '1/f' then
        filtStr = string.format('Npink%.0f', filt.f_exp*10)
    
    elseif filt.filterType == '1/fPwhite' then
        filtStr = string.format('Npink%.0fPw', filt.f_exp*10)
    
    elseif filt.filterType == '1/fOwhite' then
        filtStr = string.format('Npink%.0fOw', filt.f_exp*10)
    else
        error(string.format('Unknown filter type: %s ', filt.filterType))
    end
    
    return filtStr .. normStr
    

end






getCrowdedLetterOptsStr = function(crowdedLetterOpts)
            
    local xrange = crowdedLetterOpts.xrange;
    
    assert(#xrange == 3)
    local x_range_str = string.format('x%d-%d-%d', xrange[1], xrange[2], xrange[3])
    
    
	local blur_str = ''
    local useBlur = crowdedLetterOpts.blurStd and  crowdedLetterOpts.blurStd > 0
    if useBlur then
        blur_str = string.format('_blur%.0f', crowdedLetterOpts.blurStd*10)
    end
    
    local imageSizeStr = ''
    if crowdedLetterOpts.imageSize then
        local sz = crowdedLetterOpts.imageSize
        imageSizeStr = string.format('-[%dx%d]', sz[1], sz[2]);        
    end
    
    
    local snr_str = get_SNR_str(crowdedLetterOpts.logSNR, '_', 1)
        
    local targetPositionStr = function(targetPosition)
        if type(targetPosition) == 'string' then
            assert(targetPosition == 'all')
            return 'T' .. targetPosition
        else
            return 'T' .. abbrevOrderedList(targetPosition)
        end
    end
    
    
    local noiseFilter_str = noiseFilterOptStr(crowdedLetterOpts)    
    
    local details_str = ''
    
    local nLetters = 1
    if crowdedLetterOpts.nLetters then
        nLetters = crowdedLetterOpts.nLetters
    elseif crowdedLetterOpts.nDistractors then
        nLetters = crowdedLetterOpts.nDistractors + 1
    end        

--    if crowdedLetterOpts.nLetters and (crowdedLetterOpts.nLetters > 0) then
        
    local dnr_str = ''
    local distractorSpacing_str = ''
    local curTargetPosition_str
    local trainTargetPosition_str = ''
    
    local nLetters_str = string.format('%dlet', nLetters); 

    if nLetters == 1  then -- Training data (train on 1 letter)

        --targetPosition = crowdedLetterOpts.trainTargetPosition
        local trainTargetPosition = crowdedLetterOpts.trainTargetPosition or crowdedLetterOpts.targetPosition
        curTargetPosition_str = '_' .. targetPositionStr ( trainTargetPosition )


    elseif nLetters > 1 then -- Test on multiple letters

        local testTargetPosition = crowdedLetterOpts.testTargetPosition or crowdedLetterOpts.targetPosition
        curTargetPosition_str = '_' .. targetPositionStr ( testTargetPosition )
        
        dnr_str = string.format('_DNR%02.0f', crowdedLetterOpts.logDNR*10); -- distractor-to-noise ratio
        
        distractorSpacing_str = string.format('_d%d', crowdedLetterOpts.distractorSpacing); --  ie: all positions differences in X pixels
       
        if crowdedLetterOpts.testTargetPosition and crowdedLetterOpts.trainTargetPosition and not isequal(crowdedLetterOpts.trainTargetPosition, crowdedLetterOpts.testTargetPosition) then
            trainTargetPosition_str = string.format('_tr%s', targetPositionStr( crowdedLetterOpts.trainTargetPosition ) )
        end
                    
    end
    
    details_str = string.format('__%s%s%s%s', nLetters_str, distractorSpacing_str, dnr_str, trainTargetPosition_str);
        
    local textureStats_str = ''
    if crowdedLetterOpts.doTextureStatistics then
        textureStats_str = getTextureStatsStr(crowdedLetterOpts)
        assert(not crowdedLetterOpts.doOverFeat)
    end
    
    local overFeat_str = '' 
    if crowdedLetterOpts.doOverFeat then
        overFeat_str = getOverFeatStr(crowdedLetterOpts)        
        assert(not crowdedLetterOpts.doTextureStatistics)
    end
        
    return x_range_str .. curTargetPosition_str .. imageSizeStr .. snr_str .. blur_str .. noiseFilter_str .. textureStats_str .. overFeat_str .. details_str
    
end



    
getOverFeatStr = function(opts)
        
    local networkId_default = 0
    local layerId_default = 19
    
    local image_str = ''
    local networkId_str = ''
    local layerId_str = ''
    local contrast_str = ''
    
    local isImage = opts.OF_image == true
    if isImage then
        -- raw image file
        image_str = 'im'
    else    
        -- extracted features file
        local networkId = opts.networkId or networkId_default
        if networkId ~= networkId_default then
            networkId_str = string.format('_Net%d', networkId)
        end
        
        local layerId = opts.layerId or layerId_default
        if layerId ~= layerId_default then
            layerId_str = string.format('_L%d', layerId)
        end
            
        if opts.autoRescaleContrast then
            contrast_str = '_auto'
        else
            local contrast = opts.OF_contrast 
            local offset = opts.OF_offset
            contrast_str = string.format('_c%d_o%d', contrast, offset)
        end
    end
    
    return string.format('_OF%s%s%s%s', image_str, networkId_str, layerId_str, contrast_str)
        
end

getTextureStatsStr = function(letterOpts)
    
    local Nscl = letterOpts.Nscl_txt
    local Nori = letterOpts.Nori_txt
    local Na = letterOpts.Na_txt    
    
    
    local textureStats_str = ''
    if string.sub(letterOpts.textureStatsUse, 1, 2) == 'V2' then
        local useExtraV2Stats_str = iff(letterOpts.textureStatsUse == 'V2r', '_r', '')
 
        textureStats_str = string.format('_N%d_K%d_M%d%s', Nscl, Nori, Na, useExtraV2Stats_str)
    elseif string.sub(letterOpts.textureStatsUse, 1, 2) == 'V1' then
        
        textureStats_str = string.format('_N%d_K%d_%s', Nscl, Nori, letterOpts.textureStatsUse)
            
    end

    
    return textureStats_str

--[[
    local useSubsetOfA = letterOpts.Na_sub_txt and not (letterOpts.Na_sub_txt == 'all')  -- #(letterOpts.Na_sub_txt) > 0 
    local subsetChar = ''
    if useSubsetOfA then
        Na = letterOpts.Na_sub_txt;
        subsetChar = 'S';
    end
    local stat_params_str = string.format('_%dscl-%dori-%da%s',Nscl, Nori, Na, subsetChar)
--]]


end






--[[
getCrowdedLetterOptsStr = function(crowdedLetterOpts)
            
    local Nx = crowdedLetterOpts.Nx;
    local spacing = crowdedLetterOpts.spacing;
        
    return string.format('%dx_%s', Nx, spacing)
    
end
--]]


--[[
getCrowdedLetterOptsStr = function(crowdedLetterOpts, addTestStyle)
            
    local Nx = crowdedLetterOpts.Nx    
    local x_lims_str = getLimitsStr(Nx, crowdedLetterOpts.x_range);
    
    local nY = crowdedLetterOpts.nY    
    local y_lims_str = getLimitsStr(nY, crowdedLetterOpts.y_range);
    
    
    local basename = string.format('%dx%s_%dy%s', Nx,x_lims_str, nY,y_lims_str);
    local testStyle = string.format('%s%d', crowdedLetterOpts.targetPosition, crowdedLetterOpts.nDistractors); 
    
    if addTestStyle then
        basename = basename .. '_' .. testStyle
    end
    
    return basename, testStyle 

end
--]]

        


checkFontsFitInImage = function(fontNames, fontSize, imageSize)
    
    for fi,fontName in ipairs(fontNames) do
        local fontHeight = getFontAttrib(fontName, fontSize, 'height')
        local fontWidth = getFontAttrib(fontName, fontSize, 'width')
    
        local thisFontFits = fontHeight <= imageSize[1] and fontWidth <= imageSize[2]
        if not thisFontFits then
            print(string.format( '======= font = %d x %d is too large for imageSize = %dx%d ! =====', 
                fontHeight, fontWidth, imageSize[1], imageSize[2]) )
            return false
        end
    end
    
    return true
end
                    
checkNetworkFitsInImage = function(networkOpts, imageSize)
    
    local _, nOutputsEachBank = nOutputsFromConvStages(networkOpts, imageSize)
    
    local networkFits = nOutputsEachBank > 0
    --local net_str = getNetworkStr(networkOpts)
    --printf('\n --- net = %s. nOutputs = %d --- \n', net_str, nOutputsEachBank);
    if not networkFits then
        local net_str = getNetworkStr(networkOpts)
        print(string.format( '======= network (%s) is too small for imageSize = %dx%d ! =====', 
            net_str, imageSize[1], imageSize[2]) )
    end
    return networkFits
end
                    

getMetamerLetterOptsStr = function(metamerLetterOpts)
    return string.format('%dx%d_it%d', metamerLetterOpts.size, metamerLetterOpts.size, metamerLetterOpts.niter)    
end


getFontSizeStr = function(fontSize)
    if type(fontSize) == 'string' then
        return fontSize
    elseif type(fontSize) == 'number' then
        return tostring(fontSize)
    elseif type(fontSize) == 'table' then
        assert(#fontSize <= 2)
        if (#fontSize == 2) and (fontSize[1] == fontSize[2]) then
            return tostring(fontSize[1])
        else 
            return string.format('%d(%d)', fontSize[1], fontSize[2])
        end
    end
end


getExpSubtitle = function(letterOpts, networkOpts, trialId)
    
    local letterOpts_str = getLetterOptsStr(letterOpts)
    
    local network_str = '__' .. getNetworkStr(networkOpts)
    
    
    local trialId_str = ''
    if trialId and (trialId > 1) then
        trialId_str = '__tr' .. trialId
    end
        
    
    --local str = fontName_str .. sizeStyle_str .. snr_train_str .. letterOpts_str  .. network_str .. classesSep_str .. gpu_str .. trialId_str
    local str = letterOpts_str  .. network_str .. trialId_str
    return str
end



getLetterOptsStr = function(letterOpts)
        
    assert(type(letterOpts.fontName) == 'table')
    if (letterOpts.fontName[1] == 'SVHN') then
        return 'SVHN' .. getSVHNOptsStr(letterOpts.fontName.svhn_opts)
    end
        
    local fontName_str = abbrevFontStyleNames(letterOpts.fontName)
    
    local sizeStyle_str = '-' .. getFontSizeStr(letterOpts.sizeStyle)
    
    local snr_train_str = '_SNR' .. abbrevOrderedList(letterOpts.SNR_train)
        
    local opt_str
    

    if table.anyEqualTo(letterOpts.expName, {'ChannelTuning', 'Complexity', 'Grouping', 'TrainingWithNoise', 'TestConvNet'})  then          
    --if table.any({'ChannelTuning', 'Complexity', 'Grouping', 'TrainingWithNoise'}, function(s) return (s == letterOpts.expName))
        opt_str = getNoisyLetterOptsStr(letterOpts)
    elseif letterOpts.expName == 'Crowding' then
        opt_str = getCrowdedLetterOptsStr(letterOpts)
    --elseif letterOpts.expName == 'NoisyLettersTextureStats' then
    --    opt_str = getNoisyLettersTextureStatsOptsStr(letterOpts)
    elseif letterOpts.expName == 'Metamer' then
        opt_str = getMetamerLetterOptsStr(letterOpts)
        
    else
        error(string.format('Unknown type: %s', letterOpts.expName))
    end
    
    
    return  fontName_str .. sizeStyle_str .. snr_train_str .. '__' .. opt_str
    
end

getSVHNOptsStr = function(svhn_opts)
    
    local useExtra_str = ''
    if svhn_opts.useExtraSamples then
        useExtra_str = 'x'
    end
    
    local globalNorm_str = ''
    if not svhn_opts.globalNorm then
        globalNorm_str = 'u' -- ="unnnormalized" (no global normalization) (default: global normalized)
    end
    
    local localContrastNorm_str = ''
    if svhn_opts.localContrastNorm then
        localContrastNorm_str = 'c' -- ="contrast" normalization (default: not contrast normalized)
    end
    
    local imageSize_str = ''
    local imageSize = {32, 32}
    if svhn_opts.imageSize then
        imageSize = svhn_opts.imageSize
    end
    if type(imageSize) == 'number' then
        imageSize = {imageSize, imageSize}
    end
    if imageSize[1] ~= 32 or imageSize[2] ~= 32 then
        imageSize_str = string.format('_%dx%d', imageSize[1], imageSize[2])
    end
    
    
    return globalNorm_str .. localContrastNorm_str .. useExtra_str .. imageSize_str
    
end





getSnakeWiggleStr = function ( wiggleSettings_orig )
   
    if not wiggleSettings_orig then
        return ''
    end
    local wiggleSettings = table.copy(wiggleSettings_orig)
   
    local isZero = function(x) return (x == 0) end
   
    local haveNoWiggle = wiggleSettings.none


    local haveOriWiggle = wiggleSettings.orientation
    if haveOriWiggle and type(wiggleSettings.orientation) ~= 'table' then
        wiggleSettings.orientation = {wiggleSettings.orientation}
    end 
    if haveOriWiggle and table.any(wiggleSettings.orientation, isZero) then
        wiggleSettings.orientation = table.nonzeros(wiggleSettings.orientation)
        haveNoWiggle = true
    end
    haveOriWiggle = haveOriWiggle and #wiggleSettings.orientation > 0
    
    
    local haveOffsetWiggle = wiggleSettings.offset
    if haveOffsetWiggle and type(wiggleSettings.offset) ~= 'table' then
        wiggleSettings.offset = {wiggleSettings.offset}
    end 
    
    if haveOffsetWiggle and table.any(wiggleSettings.offset, isZero) then
        wiggleSettings.offset = table.nonzeros(wiggleSettings.offset)
        haveNoWiggle = true
    end
    haveOffsetWiggle = haveOffsetWiggle and #wiggleSettings.offset > 0

    
    local havePhaseWiggle = wiggleSettings.phase
    if havePhaseWiggle and type(wiggleSettings.phase) ~= 'table' then
        wiggleSettings.phase = {wiggleSettings.phase}
    end 
    if havePhaseWiggle and table.any(wiggleSettings.phase, isZero) then
        wiggleSettings.phase = table.nonzeros(wiggleSettings.phase)
        haveNoWiggle = true
    end
    havePhaseWiggle = havePhaseWiggle and #wiggleSettings.phase > 0
    
    --local sep = '_'
    local sep = ''
    
    local str = ''
    if haveNoWiggle then
        local noWiggleStr = 'N'
        
        str = string.append(str, noWiggleStr, sep)
    end
    
    
    if haveOriWiggle then
        local oriAnglesStr = string.format('Or%s', abbrevOrderedList(wiggleSettings.orientation))
        
        str = string.append(str, oriAnglesStr, sep)
    end

    if haveOffsetWiggle then
        local offsetAnglesStr = string.format('Of%s', abbrevOrderedList(wiggleSettings.offset))
        
        str = string.append(str, offsetAnglesStr, sep)
    end
    
    if havePhaseWiggle then
        local phaseAnglesStr = 'Ph'
        
        str = string.append(str, phaseAnglesStr, sep)
    end
        
    return str
end




--testExpandOptionsToList()
--[[
length = function(x)
    if type(x) == 'number' then
        return 1
    elseif type(x) == 'table' then
        return #x
    end
end
--]]



--[[
tblRep = function(x, n)
   local tbl = {}
   for i = 1,n do
       tbl[i] = x
   end
   return tbl
end

tblTrim = function(tbl, n)
    for i,v in ipairs(tbl) do
        if i > n then
            tbl[i] = nil
        end
    end
    return tbl
end

num2tbl = function(x)
    if type(x) == 'number' then
        return {x}
    elseif type(x) == 'table' then
        return x
    end
    error('Put in a number or a table');
end
--]]
        
        
uniqueNetworks = function(allNetworks)

    local tbl_networkNames = {}
    local tbl_networkNames_nice = {}
    for i,net in ipairs(allNetworks) do
        local net_str, net_str_nice = getNetworkStr(net);
        
        table.insert(tbl_networkNames, net_str)
        table.insert(tbl_networkNames_nice, net_str_nice)
    end

    local uniqueNames, idx_unique = tbl_unique(tbl_networkNames)
    
    local uniqueNetworks = table.subsref(allNetworks, idx_unique)
    local uniqueNetworkNiceNames = table.subsref(tbl_networkNames_nice, idx_unique)
    return uniqueNetworks, uniqueNetworkNiceNames, uniqueNames

end


uniqueOpts = function(allLetterOpts)

    local tbl_opts = {}
    for i,opt in ipairs(allLetterOpts) do
        local opt_str = getLetterOptsStr(opt)
        
        tbl_opts[i] = opt_str
    end

    local uniqueOptStrs, idx_unique = tbl_unique(tbl_opts)
    
    local uniqueOpts = table.subsref(allLetterOpts, idx_unique)

    return uniqueOpts, uniqueOptStrs

end

getFontAttrib = function(fontName, fontSize, param)
    -- created in MATLAB with 'createFontSizesFile.m'
    
    local fontSizeFile = matlabLetters_dir .. 'fontSizes.mat'
    local S = mattorch.load(fontSizeFile)
    
    local allSizes = S[fontName .. '_sizes']
    local idx_fontSize
    
    
    if (type(fontSize) == 'string') and (string.sub(fontSize, 1, 1) == 'k')  then
        local k_height = tonumber( string.sub(fontSize, 2, #fontSize) )
        local allKHeights = S[fontName .. '_k_heights']
        local k_idx_use
        for i = 1,allKHeights:numel() do
            if allKHeights[i][1] >= k_height then
                idx_fontSize = i
                break;
            end
        end           
        -- idx_fontSize = find(allKHeights, k_height)[1]
    else
        if (type(fontSize) == 'string') then  -- eg 'med' or 'big'
            fontSize = S[fontName .. '_' .. fontSize][1][1]
        
        --elseif (type(fontSize) == 'number') then        
        end
    
        idx_fontSize = find(allSizes, fontSize)[1]
    
    end    
    
    
    return  S[fontName .. '_' .. param .. 's'][idx_fontSize][1]        
    
end


--[[            
getAllDistractorSpacings = function(xrange, fontWidth, nDistractors)
    
    local letterSpacingPixels = 1
    local dx = xrange[2]
    local Nx = (xrange[3]-xrange[1])/dx + 1
--    Xrange = xrange
--    Dx = dx
--    NX = Nx
  
   
    assert(Nx == math.floor(Nx) and Nx == math.ceil(Nx))
    local allDistractSpacings_poss   = torch.range(1, (Nx-1)/nDistractors )
    
    --print(allDistractSpacings_poss)
    --print(torch.ge(allDistractSpacings_poss*dx, fontWidth + letterSpacingPixels))
    
    local allDistractSpacings_idx_use = torch.find(torch.ge(allDistractSpacings_poss*dx, fontWidth + letterSpacingPixels))
    
    local allDistractSpacings_pix_tnsr = allDistractSpacings_poss:index(1, allDistractSpacings_idx_use:long())*dx;
    
    local allDistractorSpacings_pix_tbl = torch.toTable(allDistractSpacings_pix_tnsr);
    
    return allDistractorSpacings_pix_tbl, allDistractSpacings_pix_tnsr
end
--]]

getAllDistractorSpacings = function(xrange, fontWidth, nDistractors, targetPosition)
    
    local letterSpacingPixels = 1
    local dx = xrange[2]
    local Nx = (xrange[3]-xrange[1])/dx + 1
    assert(Nx == math.floor(Nx) and Nx == math.ceil(Nx))
--    Xrange = xrange
--    Dx = dx
--    NX = Nx
    local minXSpacing = math.ceil( (fontWidth + letterSpacingPixels)/dx )
   
    local minTargetPos, maxTargetPos
    
    if type(targetPosition) == 'string' then
        assert(targetPosition == 'all') 
        minTargetPos, maxTargetPos = 1, Nx
    
    elseif type(targetPosition) == 'number' then
        minTargetPos, maxTargetPos = targetPosition, targetPosition
        
    elseif type(targetPosition) == 'table' then
        minTargetPos, maxTargetPos = table.max(targetPosition), table.min(targetPosition)
    
    elseif torch.isTensor(targetPosition) then
        minTargetPos, maxTargetPos = targetPosition:min(), table.min(targetPosition)        
    end
    
    local maxDistOnLeft  = minTargetPos - 1
    local maxDistOnRight = Nx - maxTargetPos

    local maxXSpacing
    if nDistractors == 1 then
        maxXSpacing = math.max(maxDistOnLeft, maxDistOnRight)
    elseif nDistractors == 2 then
        maxXSpacing = math.min(maxDistOnLeft, maxDistOnRight)
    end
    
    local allDistractSpacings = torch.range(minXSpacing, maxXSpacing)
    local allDistractSpacings_pix = allDistractSpacings * dx;
    
    return torch.toTable(allDistractSpacings_pix), allDistractSpacings_pix
    
end




abbrevFontStyleNames = function(names_orig, fontOrStyle)
    --print(names_orig)
   
    -- Book[M]an, Brai[L]le, [C]heckers4x4, Cou[R]ier, [H]elvetica, [K]uenstler  [S]loan, [Y]ung, 
    
    assert(names_orig)
    
    local skipAbbrevIfOneFont = true
    
    local allFontName_abbrevs = { Armenian =    'A',
                                  Bookman =     'M',
                                  Braille =     'L',
                                  Checkers4x4 = 'C',
                                  Courier =     'R',
                                  Devanagari =  'D', 
                                  Helvetica =   'H',
                                  Hebraica =    'I',
                                  Kuenstler =   'K',
                                  Sloan =       'S',
                                  Yung =        'Y',
                                  
                                  SVHN =        'N',
                                  
                                  Snakes =      'G',   -- '=Gabor'
                                 }
    
    local allFontName_abbrevs_med = { Armenian    = 'Arm',
                                      Bookman     = 'Bkm',
                                      Braille     = 'Brl',
                                      Checkers4x4 = 'Ch4',
                                      Courier     = 'Cur',
                                      Devanagari  = 'Dev', 
                                      Helvetica   = 'Hlv',
                                      Hebraica =    'Heb',
                                      Kuenstler   = 'Kun',
                                      Sloan       = 'Sln',
                                      Yung        = 'Yng',
                                      
                                      SVHN = 'SVHN', 
                                      
                                      Snakes = 'Snk',
                                 }
                                 
                             
    local allStyleName_abbrevs = { Roman      = 'r',
                                   Bold       = 'B',
                                   Italic     = 'I',
                                   BoldItalic = 'J', 
                                 }
    
    local allStyleName_abbrevs_med = { Roman      = 'Rom',
                                       Bold       = 'Bld',
                                       Italic     = 'Ital',
                                       BoldItalic = 'BldItal', 
                                     }
     
    
    
    local tbl_short = {}
    local tbl_med = {}
    local tbl_full = {}
    
    if type(names_orig) == 'string' then
        names_orig = {names_orig}
    end
    
    
    if names_orig.fonts or names_orig.styles or names_orig.wiggles or names_orig.svhn_opts then
       local fontName_str_short,   fontName_str_medium,  fontNames_full   = '', '', ''
       local styleName_str_short,  styleName_str_medium, styleNames_full  = '', '', ''
       local pre_full, join_short, join_med, join_full,  post_full        = '', '', '', '', ''
       local opt_str = ''
       if names_orig.fonts then
           --print(names_orig.fonts)
            fontName_str_short, fontName_str_medium, fontNames_full = abbrevFontStyleNames(names_orig.fonts, 'font')
       end
       
       if (names_orig.styles) and ((#names_orig.styles== 0) or (#names_orig.styles == 1  and names_orig.styles[1] == 'Roman')) and names_orig.fonts then
           names_orig.styles = nil
       end
       
       if names_orig.styles then
            styleName_str_short, styleName_str_medium, styleNames_full = abbrevFontStyleNames(names_orig.styles, 'style')
       end
       
       if names_orig.wiggles then            
            local wiggle_str = getSnakeWiggleStr(names_orig.wiggles) 
            styleName_str_short, styleName_str_medium, styleNames_full = wiggle_str, wiggle_str, wiggle_str
       end
       
       if names_orig.svhn_opts then            
            local svhn_opt_str = getSVHNOptsStr(names_orig.svhn_opts) 
            styleName_str_short, styleName_str_medium, styleNames_full = svhn_opt_str, svhn_opt_str, svhn_opt_str
       end
       
       if names_orig.fonts and (names_orig.styles or names_orig.wiggles) then
           --pre_full, join_short, join_med, join_full, post_full = '{', '_', '_x_', ' X ', '}'
           join_short, join_med = '_', '_x_'
           pre_full, join_full, post_full = '{', ' X ', '}'
       end
       --print(names_orig)
       
       if names_orig.opts then
           opt_str = getFontOptStr(names_orig.opts)
       end
       
       return fontName_str_short .. join_short .. styleName_str_short .. opt_str, 
              fontName_str_medium .. join_med  .. styleName_str_medium .. opt_str,
              pre_full .. fontNames_full .. join_full .. styleNames_full .. opt_str .. post_full
       
       
    end
    
    local names = table.copy(names_orig)
   
    
    if not fontOrStyle then
        --print(names_orig[1])
        if allFontName_abbrevs[ getRawFontName( names[1]) ] then
            fontOrStyle = 'font'
        elseif allStyleName_abbrevs[ names[1] ] then
            fontOrStyle = 'style'
        else
            error('!')
        end
    end
    
   
   
    if skipAbbrevIfOneFont and (fontOrStyle == 'font') and (#names == 1) then
        return names[1], names[1], names[1]
    end

    
    
    if fontOrStyle == 'font' then
        table.sort(names)
        
        
    elseif fontOrStyle == 'style' then
        local styleOrder = {'Roman', 'Bold', 'Italic', 'BoldItalic'}
        local names = table.reorderAs(names, styleOrder);
        names = names_new
        
    elseif fontOrStyle == 'wiggle' then
        names = {getSnakeWiggleStr(names)}
        
    end
    

    local str_full = table.concat(names, ',');

    --getRawFontName(

    for i,name in ipairs(names) do
        
        local abbrev_short, abbrev_med
        if fontOrStyle == 'font' then
            local rawFontName, fontAttrib = getRawFontName(name)
            local bold_str = iff(fontAttrib.bold_tf, 'B', '')
            local italic_str = iff(fontAttrib.italic_tf, 'I', '')
            local upper_str = iff(fontAttrib.upper_tf, 'U', '')
        
            local fontAbbrev     = allFontName_abbrevs[rawFontName]
            local fontAbbrev_med = allFontName_abbrevs_med[rawFontName]
            if not fontAttrib.upper_tf then                
                fontAbbrev = string.lower(fontAbbrev)
            end
            abbrev_short = fontAbbrev ..                  bold_str .. italic_str
            print(abbrev_short)
            abbrev_med   = fontAbbrev_med .. upper_str .. bold_str .. italic_str
            print(abbrev_med)
        elseif fontOrStyle == 'style' then
            
            local styleName = name
            abbrev_short = allStyleName_abbrevs[styleName]
            abbrev_med   = allStyleName_abbrevs_med[styleName]
            
        elseif fontOrStyle == 'wiggle' then
            abbrev_short = names[1]
            abbrev_med = names[1]
            
        end
        
        --tbl_short[i] = fontAbbrev .. upper_str .. bold_str
        tbl_short[i] = abbrev_short
        tbl_med[i]   = abbrev_med 
        
    end
    local str_short = table.concat(tbl_short)
    local str_medium = table.concat(tbl_med, '_')
    
    return str_short, str_medium, str_full
    
    
end



getFontList = function(fontTable)
    
    if type(fontTable) == 'string' then   -- if just input a single font name  ("Bookman")
        fontTable = {fontTable}
    end
    if not fontTable.fonts and not fontTable.styles and not fontTable.wiggles then  -- already have a list of fonts
        return fontTable
    end
            
    if not fontTable.fonts then
        error('Input table has a "styles" field, but no "fonts" field')
    end
    
    
    local fontNameList = fontTable.fonts 
    if type(fontNameList) == 'string' then   -- if just input a single font name  ("Bookman")
        fontNameList = {fontNameList}
    end
    
    local fonts_styles_tbl, stylesAbbrev
    
    if fontTable.styles then
        stylesAbbrev = table.copy(fontTable.styles)
        local stylesAbbrevTable = {Roman = '', Bold = 'B', Italic = 'I', BoldItalic = 'BI'}
        for i,styleFull in ipairs(stylesAbbrev) do
            stylesAbbrev[i] = stylesAbbrevTable[styleFull]
        end
    elseif fontTable.wiggles then
            
        local wiggleList = getWiggleList(fontTable.wiggles)
        stylesAbbrev = {}
        for i,w in ipairs(wiggleList) do
            stylesAbbrev[i] = getSnakeWiggleStr(w)
        end
        
        --print(wiggleList)
        --print(stylesAbbrev)
        
    else
        
        stylesAbbrev = {''}
    end
    fonts_styles_tbl = expandOptionsToList({tbl_font = fontNameList, tbl_style = stylesAbbrev})
    
    local fonts_styles = {}       
    for i = 1, #fonts_styles_tbl do
        fonts_styles[i] = fonts_styles_tbl[i].font .. fonts_styles_tbl[i].style
    end                        
    return fonts_styles
    
end                    
                    

getWiggleList = function(wiggleSettings)
    local wiggleList = {}
    if wiggleSettings.none then
        table.insert(wiggleList, {none = 1})
    end
    
    if wiggleSettings.orientation then
        for i,ori in ipairs(totable(wiggleSettings.orientation)) do
            table.insert(wiggleList, {orientation = ori})
        end
    end
    
    if wiggleSettings.offset then
        for i,off in ipairs(totable(wiggleSettings.offset)) do
            table.insert(wiggleList, {offset = off})
        end
    end
    
    if wiggleSettings.phase then
        table.insert(wiggleList, {phase = 1})
    end

    return wiggleList
end

tbl_max = function(tbl)
    local max_val = tbl[1]
    for k,v in pairs(tbl) do
        max_val = math.max(max_val, v)
    end
    return max_val
end



getNumClassesForFont = function(fontName, sumIfMultipleFonts)
    
    if type(fontName) == 'table' then
       local nClasses = {}
       local nClassesTot = 0
       for i,font in ipairs(fontName) do
            nClasses[i] = getNumClassesForFont(font)
            nClassesTot = nClassesTot + nClasses[i]
       end
       if sumIfMultipleFonts then
           return nClassesTot
       else
           return nClasses
       end
    end
    
    
    local font = getRawFontName(fontName)
    if (font=='Bookman') or (font=='Courier') or (font=='Helvetica') or (font=='Kuenstler') 
        or (font== 'Sloan') or (font== 'Yung') or (font== 'Devanagari') or (font== 'Braille') or (font== 'Checkers4x4') then
        return 26
    elseif (font== 'Hebraica') then
        return 22
    elseif (font== 'Armenian') then
        return 35
        
        
    elseif (font== 'SVHN') or (font == 'Snakes') then
        return 10
    else
        error(string.format('Unknown font : %s', font))
    end
    
    
end




getRawFontName = function(fontName, keepUpperCaseFlag)

    local rawFontName = fontName
    local fontAttrib = {upper_tf = false, bold_tf = false, italic_tf = false}
    if not fontName or #rawFontName == 0 then
        return '', false, false, false
    end   
    
    local LastChar = function(s) return string.sub(s, #s, #s) end
    local lastChar = LastChar(rawFontName)
    
    while string.find( 'UBI', lastChar ) or tonumber(lastChar) do
        
        if lastChar == 'U' then
            fontAttrib.upper_tf = true
        elseif lastChar == 'B' then
            fontAttrib.bold_tf = true; 
        elseif lastChar == 'I' then
            fontAttrib.italic_tf = true;
        elseif lastChar == 'U' and keepUpperCaseFlag then
            break;
        end
        
        
        if tonumber(lastChar) then
            local i = #rawFontName;
            while tonumber(string.sub(rawFontName, i, i)) and i > 1  do
                i = i-1;
            end
            local n = tonumber(string.sub(rawFontName, i+1, #rawFontName));
            if n > 10 then
                n = n / 10;
            end
            local tp = string.sub(rawFontName, i, i)
            if tp == 'O' then
                fontAttrib.outline_w = n;
            elseif tp == 'T' then
                fontAttrib.thin_w = n;
            end
            rawFontName = string.sub(rawFontName, 1, i)
            
        end
        
        rawFontName = string.sub(rawFontName, 1, #rawFontName - 1)
        lastChar = LastChar(rawFontName)
    end
    
    if string.find(rawFontName, 'Snakes') then
        rawFontName = 'Snakes'
    end    
    
    return rawFontName, fontAttrib
end




getFontClassTable = function(fontNamesSet)
    local fontNamesList = table.copy(getFontList(fontNamesSet))
    table.sort(fontNamesList)
   --[[
    Kuenstler = 0
    Bookman = 26
    BookmanU = 52
    Braille = 78
    nClasses = 104
   --]]
    local nClassesTot = 0
    local nFontShapes = 0
    local classesTable = {}
   
    for fi, fontName in ipairs(fontNamesList) do
        local fontName_raw = getRawFontName(fontName, 1)
       
        if not classesTable[fontName_raw] then
            local nClasses = getNumClassesForFont(fontName_raw)
                
            classesTable[fontName_raw] = nClassesTot
            nClassesTot = nClassesTot + nClasses
            nFontShapes = nFontShapes + 1
        end
    end
    classesTable.nClassesTot = nClassesTot 
    classesTable.nFontShapes = nFontShapes
    
    return classesTable
end





fileExistsInPreferredSubdir = function(mainDir, preferredSubdir, filename)
    --local maxLevelDown = maxLevelDown or 1
    if not preferredSubdir then
        preferredSubdir = ''
    end
            
    local preferredFileName = mainDir .. preferredSubdir .. filename
    local alsoCheckNYU_folder = true
    local mainDir_NYU

    
    if paths.filep(preferredFileName) then
        return true, preferredFileName
    elseif alsoCheckNYU_folder and not string.find(mainDir, 'NYU') then
        mainDir_NYU = string.sub(mainDir, 1, #mainDir-1) .. '_NYU/'
        local preferredFileName_NYU = mainDir_NYU .. preferredSubdir .. filename
        if paths.filep(preferredFileName_NYU) then
            return true, preferredFileName_NYU
        end
    end
    
    local altFileName = mainDir .. filename
    if paths.filep(altFileName) then
        return true, altFileName
    end
        
    
    --local dir_name = paths.dirname(filename_full)
    --local file_name = paths.basename(filename_full)
    
    --[[
    local sub_dirs_str = sys.execute(string.format('ls -d %s*/', mainDir))
    local subdirs = string.split(sub_dirs_str)
    --]]
    local subdirs = subfolders(mainDir)
    if alsoCheckNYU_folder and not string.find(mainDir, 'NYU') and paths.dirp(mainDir_NYU) then
        subdirs = table.merge(subdirs, subfolders(mainDir_NYU))
    end
        
    for i,subdir in ipairs(subdirs) do
        local file_name_i = subdir .. filename
        
        if paths.filep(file_name_i) then
            return true, file_name_i
        end
    end
        
    return false, preferredFileName
    
end



getBestWeightsAndOffset = function(inputMatrix, labels, nClasses)
    local nSamples = inputMatrix:size(1)
    local h = inputMatrix:size(3)
    local w = inputMatrix:size(4)
    
    assert(labels:numel() == nSamples)
    
    nClasses = nClasses or labels:max()
    local nEachClass = torch.Tensor(nClasses):zero()
    local E1 = torch.Tensor(nClasses)
    local templates = torch.Tensor(nClasses, 1, h, w):zero()
    for i = 1,nSamples do
        local class_idx = labels[i]
        templates[labels[i]] = templates[labels[i]] + inputMatrix[i]
        nEachClass[labels[i]] = nEachClass[labels[i]] + 1        
    end
    
    for i = 1, nClasses do
        templates[i] = templates[i] / nEachClass[i]
        
        E1[i] = torch.dot(templates[i], templates[i])
    end
    
    local bias = -E1/2
    
    return templates, bias
    
    
end



getDataSubfolder = function(letterOpts)
    local subfolder
    
    subfolder = letterOpts.stimType
    --[[
    if letterOpts.expName == 'Crowding' then
        subfolder = 'Crowding/' .. subfolder
    end
    --]]

    --[[
    if letterOpts.expName == 'ChannelTuning' or letterOpts.expName == 'Complexity' then
        subfolder = letterOpts.stimType        
    else
        error('Unhandled case')
    end 
    --]]
    
    return subfolder
end


checkFolderExists = function(dirname)
    if string.find(  string.sub(dirname, #dirname - 5, #dirname), '[.]') then  -- ie. has filename at end
        dirname = paths.dirname(dirname)
    end
    if not paths.dirp(dirname) then
        error(string.format('Error: Path does not exist: %s', dirname))
    end        
end







--[[

--getNoisyLettersTextureStatsOptsStr = function(letterOpts)
  
    
    local imageSize = letterOpts.imageSize
    local imageSize_str = string.format('%dx%d', imageSize[1],imageSize[2])
    
    local Nscl = letterOpts.Nscl_txt
    local Nori = letterOpts.Nori_txt
    local Na = letterOpts.Na_txt
      
    local useSubsetOfA = letterOpts.Na_sub_txt and not (letterOpts.Na_sub_txt == 'all')  -- #(letterOpts.Na_sub_txt) > 0 
    local subsetChar = '';
    if useSubsetOfA then
        Na = letterOpts.Na_sub_txt;
        subsetChar = 'S';
    end
    local stat_params_str = string.format('_%dscl-%dori-%da%s',Nscl, Nori, Na, subsetChar)


    local useBlur = letterOpts.blurStd and letterOpts.blurStd > 0
    local blur_str
    if useBlur then
        blur_str = string.format('_blur%.0f', letterOpts.blurStd*10)
    else
        blur_str = ''
    end
        
    local statsParams_str = ''
    if string.sub(letterOpts.textureStatsUse, 1, 2) == 'V2' then
        local useExtraV2Stats_str = iff(letterOpts.textureStatsUse == 'V2r', '_r', '')
 
        statsParams_str = string.format('_%dscl-%dori-%da%s%s', Nscl, Nori, Na, subsetChar, useExtraV2Stats_str)
    elseif string.sub(letterOpts.textureStatsUse, 1, 2) == 'V1' then
        
        statsParams_str = string.format('_%dscl-%dori_%s', Nscl, Nori, letterOpts.textureStatsUse)
            
    end
    
    local noiseFilter_str = noiseFilterOptStr(letterOpts)

    return imageSize_str .. statsParams_str  .. noiseFilter_str  .. blur_str


    --test_str = iff(isfield(letterOpts, 'tf_test') && isequal(letterOpts.tf_test, 1), '_test', '');
    
    --return  imageSizeStr .. stat_params_str .. blurStr
 

end
--]]

   --[[
    local wiggleType = wiggleSettings.wiggleType;
    local wiggleAngle = wiggleSettings.wiggleAngle;
    
    if wiggleType == 'none' then
        wiggleAngle = 0
    end    

    if wiggleAngle == 0 then
        return ''
    end
    
    if wiggleType == 'orientation' then 
        return string.format('Or%d', wiggleAngle)
    elseif wiggleType == 'offset' then
        return string.format('Of%d', wiggleAngle)
    elseif wiggleType == 'phase' then
        return string.format('Ph')
    end
--]]
