
getNoisyLetterOptsStr = function(noisyLetterOpts)
    Opt = noisyLetterOpts    
    local oxyStr = ''
  
    if noisyLetterOpts.expName ~= 'Crowding' then
        oxyStr = getOriXYStr(noisyLetterOpts.OriXY) .. '-'
    end
    
    local imageSizeStr = ''
    if not noisyLetterOpts.autoImageSize then
        imageSizeStr = string.format('[%dx%d]', noisyLetterOpts.imageSize[1], noisyLetterOpts.imageSize[2]);        
    end
    
    
    local differentTrainTestImageSize = noisyLetterOpts.trainingImageSize and not isequal(noisyLetterOpts.trainingImageSize, 'same') 
            and not isequal(noisyLetterOpts.trainingImageSize, noisyLetterOpts.imageSize);

    local trainingImageSizeStr = ''
    if differentTrainTestImageSize then
        trainingImageSizeStr = string.format('_tr%dx%d', noisyLetterOpts.trainingImageSize[1], noisyLetterOpts.trainingImageSize[2]);        
    end

    
    local useBlur = noisyLetterOpts.blurStd and noisyLetterOpts.blurStd > 0
    local blurStr = ''
    if useBlur then
        blurStr = string.format('_blur%.0f', noisyLetterOpts.blurStd*10)
    end
    
    
    local differentTrainTestFonts = noisyLetterOpts.trainingFonts and not isequal(noisyLetterOpts.trainingFonts, 'same') 
                                and not isequal(noisyLetterOpts.trainingFonts, noisyLetterOpts.fontName) 
    local trainingFonts_str = ''
    if differentTrainTestFonts then
        local trainingFonts = table.copy(noisyLetterOpts.trainingFonts)
        if noisyLetterOpts.doTextureStatistics and isRealDataFont(trainingFonts) then
            trainingFonts.realData_opts.textureParams = nil
        end
        trainingFonts_str = '_trf' .. abbrevFontStyleNames(trainingFonts)
    end
    
    
    local differentTrainTestWiggle = noisyLetterOpts.trainingWiggle and not isequal(noisyLetterOpts.trainingWiggle, 'same') 
                                 and not isequal(noisyLetterOpts.trainingWiggle, noisyLetterOpts.fontName.wiggles)
    local trainingWiggle_str = ''
    if differentTrainTestWiggle then
        trainingWiggle_str = '_trW' .. getSnakeWiggleStr(noisyLetterOpts.trainingWiggle)
    end
    
    local differentTrainTestUncertainty = noisyLetterOpts.trainingOriXY and not isequal(noisyLetterOpts.trainingOriXY, 'same') 
                                and not isequal(noisyLetterOpts.trainingOriXY, noisyLetterOpts.OriXY) 
    local trainingOriXY_str = ''
    if differentTrainTestUncertainty  then
        trainingOriXY_str = '_trU' .. getOriXYStr(noisyLetterOpts.trainingOriXY)
    end
    
    
    local noiseFilter_str = noiseFilterOptStr(noisyLetterOpts)    -- includes "trained with" if appropriate

    local differentTrainTestNoise = noisyLetterOpts.trainingNoise and not isequal(noisyLetterOpts.trainingNoise, 'same') 
                            and not (filterStr(noisyLetterOpts.noiseFilter, 1) == filterStr(noisyLetterOpts.trainingNoise, 1))
    local trainNoise_str = ''
    if differentTrainTestNoise then
        trainNoise_str = '_tr' .. filterStr(noisyLetterOpts.trainingNoise, 1)
    end
    
    
    assert(not (noisyLetterOpts.doOverFeat and noisyLetterOpts.doTextureStatistics))
    local textureStats_str = ''
    if noisyLetterOpts.doTextureStatistics then
        textureStats_str = getTextureStatsStr(noisyLetterOpts.textureParams)    
    end
    
    local overFeat_str = '' 
    if noisyLetterOpts.doOverFeat then
        overFeat_str = getOverFeatStr(noisyLetterOpts)        
    end
    
    
    if not differentTrainTestNoise and not differentTrainTestFonts and not differentTrainTestWiggle
                and not differentTrainTestUncertainty and not differentTrainTestImageSize then
        noisyLetterOpts.retrainFromLayer = '';
    end
    
    local retrainFromLayer_str = ''
    if noisyLetterOpts.retrainFromLayer and noisyLetterOpts.retrainFromLayer ~= '' then
        retrainFromLayer_str = '_rt' .. networkLayerStrAbbrev(noisyLetterOpts.retrainFromLayer)
    end
    
    local nPositions = 1
    if noisyLetterOpts.Nori then
        nPositions = noisyLetterOpts.Nori * noisyLetterOpts.Nx * noisyLetterOpts.Ny
    end
    
    local indiv_pos_str = ''
    if noisyLetterOpts.trainOnIndividualPositions and (nPositions > 1) then
        indiv_pos_str = '_trIP'
    
        if noisyLetterOpts.retrainOnCombinedPositions then
            indiv_pos_str = indiv_pos_str .. '_rtCP'
        end
    end
                
                
                
    
    local crowdedOpts_str = ''
    if noisyLetterOpts.expName == 'Crowding' then
       crowdedOpts_str = getCrowdedLetterOptsStr(noisyLetterOpts)
    end
    
                    
    local classifierForEachFont_str = ''
    local nFontShapes = (getFontClassTable(noisyLetterOpts.fontName)).nFontShapes
    if noisyLetterOpts.classifierForEachFont and (nFontShapes > 1) then
        classifierForEachFont_str = '_clsFnt'
    end    
                
    local loadOpts_str = ''
    if noisyLetterOpts.loadOpts then
        loadOpts_str = getLoadOptsStr(noisyLetterOpts.loadOpts)
    end
                    
    return oxyStr .. imageSizeStr .. blurStr .. 
            --oxyStr .. nLetters_str .. targetPosition_str .. imageSizeStr .. blurStr ..
            trainingOriXY_str .. trainingImageSizeStr .. trainingFonts_str .. trainingWiggle_str .. 
            noiseFilter_str .. trainNoise_str ..
            textureStats_str .. overFeat_str .. 
            retrainFromLayer_str .. indiv_pos_str .. crowdedOpts_str .. classifierForEachFont_str .. loadOpts_str
    
    
            
end



stringAndNumber = function(strWithNum)
    
    local maxForNum = 3
    local L = #strWithNum
    
    local str, num
    local numLastN
    for n = maxForNum, 1, -1 do
        local stringSub = string.sub(strWithNum, L-n+1, L)
        numLastN = tonumber(stringSub)
        if numLastN then
            str = string.sub(strWithNum, 1, L-n)
            num = numLastN
            return str, num
        end
    end
    
    -- no numbers at end - just return full string 
    return strWithNum, nil
            
end

networkLayerStrAbbrev = function(layerStrFull)
    
    local layerAbbrev_tbl = {conv='Conv',
                             linear= 'Lin',
                             classifier='Cls'}
    local layerStr, num = stringAndNumber(layerStrFull)
                                 
    local abbrev_str = layerAbbrev_tbl[layerStr]
    if not abbrev_str then
        error(string.format('%s is not one of the correct layers', layerStr))
    end
    assert(abbrev_str)
    if not num and layerStr ~= 'classifier' then
        num = 1
    end
    if num then
        abbrev_str = abbrev_str .. tostring(num)
    end
    return abbrev_str 
                     
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
        
        
        --local ori_lims_str = getLimitsStr(nOri, dataOpts.ori_range);
        --local x_lims_str = getLimitsStr(nX, dataOpts.x_range);
        --local y_lims_str = getLimitsStr(nY, dataOpts.y_range);        
        --oxyStr = string.format('%dori%s_%dx%s_%dy%s', nOri,ori_lims_str, nX,x_lims_str, nY,y_lims_str);
    end
    
    return oxyStr
end



noiseFilterOptStr = function(dataOpts)
     
    local useNoiseFilter = dataOpts.noiseFilter 
    local noiseFilter_str = ''
    if useNoiseFilter then
        
        local testFilt_str = filterStr(dataOpts.noiseFilter)
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


    elseif string.sub(filt.filterType, 1, 3) == '1/f' then
   
        local f_exp_std_str = ''
        if filt.f_exp_std and filt.f_exp_std > 0 then
            f_exp_std_str = string.format('s%.0f', filt.f_exp_std*100)
        end
    

        if filt.filterType == '1/f' then
            filtStr = string.format('Npink%.0f%s', filt.f_exp*10, f_exp_std_str)
        
        elseif (filt.filterType == '1/fPwhite') or  (filt.filterType == '1/fOwhite' ) then
        
            local f_exp = filt.f_exp;
            local f_exp_default = 1.0;
            local f_exp_str = '';
            local pinkWhiteRatio = filt.ratio;
                
            local pinkExtraStr = '';
            local whiteExtraStr = '';
            if pinkWhiteRatio > 1 then
                pinkExtraStr = string.format('%.0f', pinkWhiteRatio * 10);
            elseif pinkWhiteRatio < 1 then
                whiteExtraStr = string.format('%.0f', (1/pinkWhiteRatio)*10 );
            end
            
            if f_exp ~= f_exp_default then
                f_exp_str = string.format('%.0f', f_exp*10);
            end
            
            local plus_or_str = switchh(filt.filterType, {'1/fPwhite','1/fOwhite'}, {'P', 'O'});
           
            filtStr = string.format('N%spink%s%s%sw%s', pinkExtraStr, f_exp_str, f_exp_std_str, 
                plus_or_str, whiteExtraStr);    
        end
    
    else
        error(string.format('Unknown filter type: %s ', filt.filterType))
    end
    
    return filtStr .. normStr
    

end






getCrowdedLetterOptsStr = function(dataOpts)
            
            
    if dataOpts.crowdingSettings then
        dataOpts = dataOpts.crowdingSettings;
    end
    
    local xrange = dataOpts.xrange;
    
    assert(#xrange == 3)
    local x_range_str = string.format('x%d-%d-%d', xrange[1], xrange[2], xrange[3])
    
  
    
    local targetPositionStr = function(targetPosition)
        if type(targetPosition) == 'string' then
            assert(targetPosition == 'all')
            return 'T' .. targetPosition
        else
            return 'T' .. toOrderedList(targetPosition)
        end
    end

    
    local details_str = ''
    
    local nLetters = 1
    if dataOpts.nLetters then
        nLetters = dataOpts.nLetters
    elseif dataOpts.nDistractors then
        nLetters = dataOpts.nDistractors + 1
    end        

--    if crowdedLetterOpts.nLetters and (crowdedLetterOpts.nLetters > 0) then
        
    local dnr_str = ''
    local distractorSpacing_str = ''
    local curTargetPosition_str
    local trainPositions_str = ''
    
    local nLetters_str = string.format('%dlet', nLetters); 

    if nLetters == 1  then -- Training data (train on 1 letter)

        --targetPosition = dataOpts.trainPositions
        local trainPositions = dataOpts.trainPositions or dataOpts.targetPosition
        curTargetPosition_str = '_' .. targetPositionStr ( trainPositions )


    elseif nLetters > 1 then -- Test on multiple letters

        local testPositions = dataOpts.testPositions
        curTargetPosition_str = '_' .. targetPositionStr ( testPositions )
        
        dnr_str = string.format('_DNR%02.0f', dataOpts.logDNR*10); -- distractor-to-noise ratio
        
        distractorSpacing_str = string.format('_d%d', dataOpts.distractorSpacing); --  ie: all positions differences in X pixels
       
        if dataOpts.testPositions and dataOpts.trainPositions and not isequal(dataOpts.trainPositions, dataOpts.testPositions) then
            trainPositions_str = string.format('_tr%s', targetPositionStr( dataOpts.trainPositions ) )
        end
                    
    end
    
    details_str = string.format('__%s%s%s%s', nLetters_str, distractorSpacing_str, dnr_str, trainPositions_str);
        
    return '__' .. x_range_str .. curTargetPosition_str .. details_str
        
    
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

getTextureStatsStr = function(opts)
    
    if opts.textureParams then
        opts = opts.textureParams
    end
    
    local Nscl = opts.Nscl_txt
    local Nori = opts.Nori_txt
    local Na = opts.Na_txt    
    
    
    local textureStats_str = ''
    if string.sub(opts.textureStatsUse, 1, 2) == 'V2' then
        local useExtraV2Stats_str = iff(opts.textureStatsUse == 'V2r', '_r', '')
 
        textureStats_str = string.format('_N%d_K%d_M%d%s', Nscl, Nori, Na, useExtraV2Stats_str)
    elseif string.sub(dataOpts.textureStatsUse, 1, 2) == 'V1' then
        
        textureStats_str = string.format('_N%d_K%d_%s', Nscl, Nori, dataOpts.textureStatsUse)
            
    end

    
    return textureStats_str


end


getLoadOptsStr = function(loadOpts)
    
    local pctUse_str = ''
    local pctUse = loadOpts.totalUseFrac * 100
    if pctUse < 100 then
       pctUse_str = string.format('_use%d', pctUse) 
    end
    
    local loadOpts_str = pctUse_str
    
    return loadOpts_str
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


getExpSubtitle = function(dataOpts, networkOpts, trialId)
    
    local dataOpts_str = getDataOptsStr(dataOpts)
    
    local network_str = '__' .. getNetworkStr(networkOpts)
    
    
    local trialId_str = ''
    if trialId and (trialId > 1) then
        trialId_str = '__tr' .. trialId
    end
        
    
    --local str = fontName_str .. sizeStyle_str .. snr_train_str .. dataOpts_str  .. network_str .. classesSep_str .. gpu_str .. trialId_str
    local str = dataOpts_str  .. network_str .. trialId_str
    return str
end

toList = function(X, maxN, sep)
    local typeX = getType(X)
    sep  = sep or '_'
    if typeX == 'table' then
        if #X == 0 then
            return ''
        end
        maxN = math.min(maxN or #X, #X)
        return table.concat(X, sep, 1, maxN)
        
    elseif typeX == 'number' then
        return tostring(X)
        
    --elseif string.find(typeX, 'Tensor') then
        
    elseif string.find(typeX, 'Storage') then
        
        maxN = math.min(maxN or #X, #X)
        local s = tostring(X[1])
        for i = 2, maxN do
            s = s .. sep .. tostring(X[i])
        end

        return s
    end
    error('Unhandled case type(X) = ' ..  typeX)
    
end


toOrderedList = function(X, maxN, sep, maxRunBeforeAbbrev)
    
    sep  = sep or '_'
    maxRunBeforeAbbrev = maxRunBeforeAbbrev or 2
    
    local abbrevSepValues = {[1] = 't', [0.5] = 'h', [0.25] = 'q', [5] = 'f', [10] = 'd'}

    local useHforHalfValues = true
    
    local typeX = getType(X)
    local str = ''
    
    if typeX == 'table' then
        if #X == 0 then
            return ''
        end
        maxN = math.min(maxN or #X, #X)
        
        
        local curIdx = 1
        str = tostring(X[1])
        while curIdx < maxN do
            local runLength = 0
            local initDiff = X[curIdx+1] - X[curIdx]
            local curDiff = initDiff
            while (curIdx+runLength < maxN) and (curDiff == initDiff) do
                runLength = runLength + 1
                if curIdx+runLength < maxN then
                    curDiff = X[curIdx+runLength+1] - X[curIdx+runLength]
                end
            end
            --print('run = ', runLength)
            if runLength >= maxRunBeforeAbbrev then
                --print('a');
                --print( 't' .. X[curIdx+runLength] )
                local abbrevSep
                for diffVal,diffSymbol in pairs(abbrevSepValues) do
                    
                    if initDiff == diffVal then
                        abbrevSep = diffSymbol
                    end
                end
                if not abbrevSep then
                    --print(initDiff)
                    abbrevSep = string.format('t%st', tostring(initDiff))
                end
                
                str = str .. abbrevSep .. tostring(X[curIdx+runLength])
                curIdx = curIdx + runLength+1
            else
                --print('b');
                --print( table.concat(X, sep, curIdx, curIdx+runLength) )
                if (runLength > 0) then 
                    str = str .. sep .. table.concat(X, sep, curIdx+1, curIdx+runLength)
                end 
                curIdx = curIdx + runLength+1
            end       
            if curIdx <= maxN then
                str = str .. sep .. tostring(X[curIdx])
            end
        end        
        
    elseif typeX == 'number' then
        str = tostring(X)
    else
        error('Unhandled case type(X) = ' ..  typeX)
    end
    
    str = string.gsub(str, '-', 'n')        
    
    if useHforHalfValues then
        str = string.gsub(str, '%.5', 'H')
    end
    
    return str
end



getDataOptsStr = function(dataOpts)
    
    assert(type(dataOpts.fontName) == 'table')
    
    if isRealDataFont(dataOpts.fontName) then
        local realDataName_str = dataOpts.fontName.fonts
        return realDataName_str .. getRealDataOptsStr(dataOpts.fontName.realData_opts)
        
    else
        return getLetterOptsStr(dataOpts)
    end 
    
    
    
end


getLetterOptsStr = function(letterOpts)
        
    assert(type(letterOpts.fontName) == 'table')
    local fontName_str = abbrevFontStyleNames(letterOpts.fontName)
    
    local sizeStyle_str = '-' .. getFontSizeStr(letterOpts.sizeStyle)
    
    local snr_train_str = '_SNR' .. toOrderedList(letterOpts.SNR_train)
        
    local opt_str
    
    if letterOpts.expName == 'Metamer' then
        opt_str = getMetamerLetterOptsStr(letterOpts)
    else
        opt_str = getNoisyLetterOptsStr(letterOpts)
    end
    
    return  fontName_str .. sizeStyle_str .. snr_train_str .. '__' .. opt_str
    
    
end

getRealDataOptsStr = function(realDataOpts)
    
    local orig_rgb = realDataOpts.orig and opts.orig == true
    
    local gray_suffix_fileStr = '_gray'
    if orig_rgb then
        gray_suffix_fileStr = '';
    end  
        
    
    local useExtra_str = ''   -- for SVHN extra samples
    if realDataOpts.useExtraSamples then
        useExtra_str = 'x'
    end
    
    local globalNorm_str = ''
    local globalNorm_fileStr = '_gnorm'
    if not realDataOpts.globalNorm then
        globalNorm_str = 'u' -- ="unnnormalized" (no global normalization) (default: global normalized)
        globalNorm_fileStr = ''
    end
    
    local localContrastNorm_str = ''
    local localContrastNorm_fileStr = ''
    if realDataOpts.localContrastNorm then
        localContrastNorm_str = 'c' -- ="contrast" normalization (default: not contrast normalized)
        localContrastNorm_fileStr = '_lcnorm'
    end
    
    local imageSize_str = ''
    local imageSize = {32, 32}
    if realDataOpts.imageSize then
        imageSize = realDataOpts.imageSize
    end
    
    if type(imageSize) == 'number' then
        imageSize = {imageSize, imageSize}
    end
    if (imageSize[1] ~= 32 or imageSize[2] ~= 32) or realDataOpts.showSize then
        imageSize_str = string.format('_%dx%d', imageSize[1], imageSize[2])
    end
    local imageSize_fileStr = string.format('_%dx%d', imageSize[1], imageSize[2])
    
    
    
    local scaleMethod_str = '';
    local scaleMethod_fileStr = '';
    if (imageSize[1] ~= 32 or imageSize[2] ~= 32) and realDataOpts.scaleMethod then
        local scaleMethod = string.lower(realDataOpts.scaleMethod)
        if     scaleMethod == 'fourier' then  scaleMethod_str = ''; scaleMethod_fileStr = '';
        elseif scaleMethod == 'pad'     then  scaleMethod_str = 'p'; scaleMethod_fileStr = '_pad';
        elseif scaleMethod == 'tile'    then  scaleMethod_str = 't'; scaleMethod_fileStr = '_tile';
        else    error('Unknown scaling method');
        end
    end


    local textureStats_str = ''
    if realDataOpts.textureParams then
        textureStats_str = getTextureStatsStr(realDataOpts.textureParams)    
    end

    local loadOpts_str = ''
    if realDataOpts.loadOpts then
        loadOpts_str = getLoadOptsStr(realDataOpts.loadOpts)
    end


    local realData_opt_str      = globalNorm_str  .. localContrastNorm_str .. useExtra_str .. imageSize_str .. scaleMethod_str .. textureStats_str .. loadOpts_str
    local realData_opt_fileStr = imageSize_fileStr .. scaleMethod_fileStr .. gray_suffix_fileStr  .. globalNorm_fileStr .. localContrastNorm_fileStr  .. textureStats_str
    
    return realData_opt_str, realData_opt_fileStr
    
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
        local oriAnglesStr = string.format('Or%s', toOrderedList(wiggleSettings.orientation))
        
        str = string.append(str, oriAnglesStr, sep)
    end

    if haveOffsetWiggle then
        local offsetAnglesStr = string.format('Of%s', toOrderedList(wiggleSettings.offset))
        
        str = string.append(str, offsetAnglesStr, sep)
    end
    
    if havePhaseWiggle then
        local phaseAnglesStr = 'Ph'
        
        str = string.append(str, phaseAnglesStr, sep)
    end
        
    return str
end




basename = function(fn, nrep)
    if not nrep then
        nrep = 1
    end
    local str = ''
    for i = 1,nrep do
        if i == 1 then
            str = paths.basename(fn)
        else
            str =  paths.basename(fn) .. '/' .. str
        end
        
        fn = paths.dirname(fn)
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
isRealDataFont = function(font)
    if not font then
        return false
    end
    
    local font_str = abbrevFontStyleNames(font)
    local realDataFontList = getRealDataFontList()
    for k,realFontName in ipairs(realDataFontList) do
        if string.find(font_str, realFontName)  then
            return true
        end
    end
    
    return false
   
end


   

fixDataOpts = function(opt)
    
    if (opt.OriXY) then   
        for k,v in pairs(opt.OriXY) do
            opt[k] = v
        end
    end     
    
    -- make sure fontName is in a table, even if just a single font.
    if type(opt.fontName) == 'string' then
        opt.fontName = {opt.fontName}
    end
    if type(opt.trainingFonts) == 'string' and opt.trainingFonts ~= 'same' then
        opt.trainingFonts = {opt.trainingFonts}
    end
    
    -- remove 'retrainFromLayer' if trainNoise is same as testNoise, and trainFonts = testFonts
    local differentTrainTestNoise = opt.trainingNoise and (opt.trainingNoise ~= 'same') and (filterStr(opt.noiseFilter, 1) ~= filterStr(opt.trainingNoise, 1))
    OO = opt
    local differentTrainTestFonts = opt.trainingFonts and (opt.trainingFonts ~= 'same') and (abbrevFontStyleNames(opt.trainingFonts) ~=  abbrevFontStyleNames(opt.fontName) )
            
    if not differentTrainTestNoise and not differentTrainTestFonts then
        opt.retrainFromLayer = nil
    end
    
    
    
    -- copy SVHN/CIFAR image size --> trainingImageSize 
    if isRealDataFont(opt.trainingFonts) then
        if opt.trainingFonts.realData_opts.imageSize then
            opt.trainingImageSize = opt.trainingFonts.realData_opts.imageSize
        end
        --print(' --- updated ---')
    end
    
    
    if opt.doTextureStatistics then  -- copy textureParams over to any SVHN/CIFAR training or testing fonts.
        if isRealDataFont( opt.trainingFonts ) then
            opt.trainingFonts.realData_opts.textureParams = opt.textureParams
        end
        
        if isRealDataFont(opt.fontName) then
            opt.fontName.realData_opts.textureParams      = opt.textureParams
        end        
    end

    if opt.loadOpts then
        if isRealDataFont( opt.trainingFonts ) then
            opt.trainingFonts.realData_opts.loadOpts = opt.loadOpts
        end
        
        if isRealDataFont(opt.fontName) then
            opt.fontName.realData_opts.loadOpts      = opt.loadOpts
        end                
    end
    
    
    
    -- if is crowded opts, expand multi-letter-opts
    
    if opt.allMultiLetterTestOpts_tbl then
        local nDistractorsMAX = table.max(opt.allMultiLetterTestOpts_tbl.tbl_nDistractors)
        local fontWidth = getFontAttrib(opt.fontName[1], opt.sizeStyle, 'width')
        local tbl_distractorSpacing = getAllDistractorSpacings(opt.xrange, fontWidth, nDistractorsMAX, opt.allMultiLetterTestOpts_tbl.testPositions)
        opt.allMultiLetterTestOpts_tbl.tbl_distractorSpacing = tbl_distractorSpacing
        opt.allMultiLetterTestOpts = expandOptionsToList(opt.allMultiLetterTestOpts_tbl)
        
        
        -- copy all values from opt to each copy of multiletteropts
        for i,multLetTestOpt in ipairs(opt.allMultiLetterTestOpts) do
            for k,v in pairs(opt) do                
                if (string.find(k, 'MultiLet') == nil) then -- prevent infinite recursion / copying
                    multLetTestOpt[k] = v  -- multiletteropts
                end
            end
            multLetTestOpt.nLetters = multLetTestOpt.nDistractors + 1
        end
        
    
    end
    
    return opt

end




    

tableContains = function(tbl, value)
    for k,v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false

end



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
        
        
uniqueNetworks = function(allNetworks)

    local tbl_networkNames = {}
    local tbl_networkNames_nice = {}
    for i,net in ipairs(allNetworks) do
        local net_str, net_str_nice = getNetworkStr(net);
        
        table.insert(tbl_networkNames, net_str)
        table.insert(tbl_networkNames_nice, net_str_nice)
    end

    local uniqueNames, idx_unique = table.unique(tbl_networkNames)
    
    local uniqueNetworks = table.subsref(allNetworks, idx_unique)
    local uniqueNetworkNiceNames = table.subsref(tbl_networkNames_nice, idx_unique)
    return uniqueNetworks, uniqueNetworkNiceNames, uniqueNames

end


uniqueOpts = function(allDataOpts)

    local tbl_opts = {}
    for i,opt in ipairs(allDataOpts) do
        local opt_str = getDataOptsStr(opt) 
        Opt = opt
        if opt.trialId and opt.trialId > 1 then
            opt_str = opt_str .. '_' .. opt.trialId
        end
        tbl_opts[i] = opt_str
    end
    DataOpts = allDataOpts

    local uniqueOptStrs, idx_unique = table.unique(tbl_opts)
    
    local uniqueOpts = table.subsref(allDataOpts, idx_unique)

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
    
    assert(targetPosition)
    
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
   Names_orig = names_orig
    -- Book[M]an, Brai[L]le, [C]heckers4x4, Cou[R]ier, [H]elvetica, [K]uenstler  [S]loan, [Y]ung, 
    
    if not names_orig then
        error('Input was nil')
    end
    assert(names_orig)
    if names_orig == 'same' then
        return 'same', 'same', 'same'
    end
    
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
                                      
                                      SVHN        = 'SVHN',
                                      CIFAR10     = 'CFR10',
                                      CIFAR100    = 'CFR100',
                                      
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
    
    
    if names_orig.fonts or names_orig.styles or names_orig.wiggles or names_orig.realData_opts then
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
       
       if names_orig.realData_opts then            
            local realData_opt_str = getRealDataOptsStr(names_orig.realData_opts) 
            styleName_str_short, styleName_str_medium, styleNames_full = realData_opt_str, realData_opt_str, realData_opt_str
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
        if allFontName_abbrevs_med[ getRawFontName( names[1]) ] then
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
        
        
    elseif (font== 'SVHN') or (font== 'CIFAR10') or (font == 'Snakes') then
        return 10
    elseif (font== 'CIFAR100') then
        return 100
    else    
        error(string.format('Unknown font : %s', font))
    end
    
    
end




getRawFontName = function(fontName, keepUpperCaseFlag)


    local rawFontName = fontName
    local fontAttrib = {upper_tf = false, bold_tf = false, italic_tf = false}
    if not fontName or #rawFontName == 0 then
        return '', fontAttrib
    end   
    
    if table.anyEqualTo(fontName, getRealDataFontList())  then
        return fontName, fontAttrib
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
        
        local n = #rawFontName
        local last3 = string.sub(rawFontName, n-2, n)
        if (last3 == '4x4' or last3 == '5x7') then
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





fileExistsInSisterSubdirs = function(mainExperimentDir, subdir, filename, checkInAllSisterSubdirs)
    -- returns; fileExists, fullFileNameIfExists
    --local maxLevelDown = maxLevelDown or 1
    subdir = subdir or '' 
    local foldersChecked = {}
            
    local preferredFileName = mainExperimentDir .. subdir .. filename
    local alsoCheckNYU_folder = true
    local alsoCheckOtherFolders = checkInAllResultsFolders
    local mainExperimentDir_NYU
    checkInAllSisterSubdirs = checkInAllSisterSubdirs or true

    -- 1. check if is in expected subdir (e.g. Complexity/NoisyLetters/filename)
    if paths.filep(preferredFileName) then
        return true, preferredFileName, foldersChecked
    end
    table.insert(foldersChecked, mainExperimentDir .. subdir)
    
    -- 2. Check if is in subdir of NYU version of folder (e.g. Complexity_NYU/NoisyLetters/)
    if alsoCheckNYU_folder and not string.find(mainExperimentDir, 'NYU') then
        mainExperimentDir_NYU = string.sub(mainExperimentDir, 1, #mainExperimentDir-1) .. '_NYU/'
        local preferredFileName_NYU = mainExperimentDir_NYU .. subdir .. filename
        if paths.filep(preferredFileName_NYU) then
            return true, preferredFileName_NYU, foldersChecked
        end
        table.insert(foldersChecked, mainExperimentDir_NYU .. subdir)
    end
    
    -- 3. Check in any other sister subdirs of this folder
    --   (e.g. ChannelTuning/NoisyLetters/filename, Grouping/NoisyLetters/filename, etc)
    if checkInAllSisterSubdirs then
        -- resultsMainDir = (e.g) /f/nyu/letters/data/TrainedNetworks/ + [
        local resultsMainDir = paths.dirname(mainExperimentDir)  .. '/'
        local subfolder_names = subfolders(resultsMainDir)
        for i,subfolder_name in ipairs(subfolder_names) do
            
            local checkedAlready = (subfolder_name == mainExperimentDir) or
                 (alsoCheckNYU_folder and (subfolder_name == mainExperimentDir_NYU))
            
            if not checkedAlready then 
                local pathToTry = resultsMainDir .. subfolder_name .. '/' .. subdir .. '/'
                local fullFileName =  pathToTry.. filename
                if paths.filep(fullFileName) then
                    return true, fullFileName, foldersChecked
                else
                    --io.write(string.format('Not present : %s\n', fullFileName))
                end
                
                table.insert(foldersChecked, pathToTry)
            end
            
        end
        
    end
    
    return false, preferredFileName, foldersChecked
    
    --[[
    local altFileName = mainExperimentDir .. filename
    if paths.filep(altFileName) then
        return true, altFileName
    end
        --]]
    
    --local dir_name = paths.dirname(filename_full)
    --local file_name = paths.basename(filename_full)
    
    --[[
    local sub_dirs_str = sys.execute(string.format('ls -d %s*/', mainExperimentDir))
    local subdirs = string.split(sub_dirs_str)
    --]]
    
    --[[
    local subdirs = subfolders(mainExperimentDir)
    if alsoCheckNYU_folder and not string.find(mainExperimentDir, 'NYU') and paths.dirp(mainExperimentDir_NYU) then
        subdirs = table.merge(subdirs, subfolders(mainExperimentDir_NYU))
    end
    
        
    for i,subdir in ipairs(subdirs) do
        local file_name_i = subdir .. filename
        
        if paths.filep(file_name_i) then
            return true, file_name_i
        end
    end
    --]]
    
    
    
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



getDatasetSubfolder = function(letterOpts)
    local subfolder
    
    subfolder = letterOpts.stimType
    ---[[
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


getResultsSubfolder = function(letterOpts)
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



verifyFolderExists = function(dirname)
    if string.find(  string.sub(dirname, #dirname - 5, #dirname), '[.]') then  -- ie. has filename at end
        dirname = paths.dirname(dirname)
    end
    if not paths.dirp(dirname) then
        error(string.format('Error: Path does not exist: %s', dirname))
    end        
end

getRealDataFontList = function()
    return {'SVHN', 'MNIST', 'CIFAR10', 'CIFAR100'};
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
