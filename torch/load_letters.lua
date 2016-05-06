loadDatafile = function(dataOpts, loadOpts)
    
    if isRealDataFont(dataOpts.fontName) then
        return loadRealData(dataOpts.fontName, loadOpts)
    else
        return loadLetters(dataOpts.fontName, dataOpts.allSNRs, dataOpts, loadOpts)
    end
end



loadLetters = function(fontNames, SNRs, letterOpts, loadOpts)   -- for noisy letters, or texture statistics of noisy letters
    -- returns: trainData_tbl, testData_tbl, idealProportion (only if one font & one snr) 
        
    local totalUseFrac = loadOpts.totalUseFrac or 1
    local trainFrac    = loadOpts.trainFrac or 1
    
    
    local doTrainData = trainFrac > 0 and ((loadOpts.loadTrainingData == nil) or (loadOpts.loadTrainingData == true))
    local doTestData  = trainFrac < 1 and ((loadOpts.loadTestData     == nil) or (loadOpts.loadTestData     == true))

    local separateFontsAndSNR = loadOpts.separateFontsAndSNR

--[[
    if doTrainData and not doTestData then
        trainFrac = 1
    elseif not doTrainData and doTestData then
        trainFrac = 0
    end
    --]]

    --print('train = ', doTrainData, ' test = ', doTestData)
    
    local fonts_descrip, snr_descrip
    -- process which fonts to load
    
    fontNames = getFontList(fontNames)
    
    fontNames, fonts_descrip = assign_describe(fontNames, allFontNames)
    
    SNRs, snr_descrip = assign_describe(SNRs, allSNRs)
       
        
    local font_snr_descrip =  'Fonts = ' .. fonts_descrip .. '; SNRs = ' .. snr_descrip
    
    if type(fontNames) == 'string' then
        fontNames = {fontNames}
    end
    local nFonts = #fontNames    
    
    if type(SNRs) == 'number' then
        SNRs = {SNRs}        
    end    
    local nSNRs = #SNRs
        
    local trainData = {}
    local testData = {}
    
    
    if separateFontsAndSNR then   -- recurse and load each font & snr into separate table entry (for testing)
        local lockDataFiles = loadOpts.lockDataFiles
        local loadOpts_copy = table.copy(loadOpts)
        loadOpts_copy.lockDataFiles = false
        loadOpts_copy.separateFontsAndSNR = false
        
        
        for fi,font in ipairs(fontNames) do
            local loadingFontLockName 
            if lockDataFiles then
                loadingFontLockName = 'Loading_' .. string.gsub ( basename( dataFileName_torch(font, 0, letterOpts) ), '.t7', '')        
                lock.waitForLock(loadingFontLockName)             
            end
            
            trainData[fi] = {}
            testData[fi] = {}
            for si, snr in ipairs(SNRs) do
                trainData[fi][si], testData[fi][si] = loadLetters(font, snr, letterOpts, loadOpts_copy)
            end
            
            if lockDataFiles then
                lock.removeLock(loadingFontLockName)
            end
        end
        
        collectgarbage('collect')  -- remove unused training/test 
        collectgarbage('collect')  -- data
        
        return trainData, testData
    end
    
    
    
    if totalUseFrac < 1 then
        font_snr_descrip = font_snr_descrip .. string.format(' (Using %.1f%%)', totalUseFrac*100) 
    end
    

    
    trainData.descrip = 'Training Data; ' .. font_snr_descrip
    testData.descrip = 'Testing Data; ' .. font_snr_descrip
    
    local last_trainIdx = 0
    local last_testIdx = 0
    local nSamplesTotal
    local nClassesTot
    
    local firstIteration = true
        
    for fi,font in ipairs(fontNames) do
        local loadingFontLockName
        if loadOpts.lockDataFiles then
            loadingFontLockName = 'Loading_' .. string.gsub ( basename( dataFileName_torch(font, 0, letterOpts) ), '.t7', '')        
            lock.waitForLock(loadingFontLockName)             
        end

        
        local class_offset = 0
        local rawFontName = getRawFontName(font, 1)
        if loadOpts.fontClassTable then
            class_offset = loadOpts.fontClassTable[ rawFontName ]
            nClassesTot = loadOpts.fontClassTable.nClassesTot
        end        
        
        local nClassesThisFont = getNumClassesForFont(rawFontName)
                       
                       
        for si, snr in ipairs(SNRs) do
            
            local S, file_name= loadTorchDataFile(font, snr, letterOpts)
            SS = S
            File_name = file_name
            
            if nSamplesTotal then
                assert(nSamplesTotal == S.labels:numel())  -- make sure all files have same # samples (10,000)
                
            else
                nSamplesTotal = S.labels:numel()
            end
            
            
            local nUse = math.ceil(nSamplesTotal * totalUseFrac)
            local nTrainSamp = math.ceil(nUse * trainFrac)
            local nTestSamp = nUse - nTrainSamp
            --local signalSize = S.signalMatrix:size()
            --local nClasses = signalSize[#signalSize-2]
            local nClasses = S.nClasses[1][1]
            
            local nX, nY, nOri = S.xs:numel(), S.ys:numel(), S.orientations:numel()
            local nPositions = nX * nY * nOri
            local labels_indiv_pos
            
            if nPositions > 1 then
                labels_indiv_pos = torch.Tensor(nSamplesTotal)
                local x_idx   = S.x_idxs   or torch.ones(nSamplesTotal)
                local y_idx   = S.y_idxs   or torch.ones(nSamplesTotal)
                local ori_idx = S.ori_idxs or torch.ones(nSamplesTotal)
                x_idx = x_idx:reshape(nSamplesTotal)
                y_idx = y_idx:reshape(nSamplesTotal)
                ori_idx = ori_idx:reshape(nSamplesTotal)
                
                for lbl_i = 1,nSamplesTotal do
                    labels_indiv_pos[lbl_i] = (x_idx[lbl_i]-1)  +  ((y_idx[lbl_i]-1) * nX) +  ((ori_idx[lbl_i]-1) * nX*nY) +  ( (S.labels[lbl_i][1]-1) * nX*nY*nOri) + 1
                end
                
            end
            
            assert(nClasses == nClassesThisFont)
            if not nClassesTot then
                nClassesTot = nClasses
            end
            local nInputs = S.inputMatrix[1]:numel()
            
            SS = S
            
            local height, width, haveLabelsDistract, haveLabelsDistract2
            if firstIteration then -- initialize tensors to hold data
                height = S.inputMatrix:size(2) -- 6/15/2014 changed height/width: now height = size(2), width = size(3).
                width  = S.inputMatrix:size(3)
                
                haveLabelsDistract  = S.labels_distract  ~= nil
                haveLabelsDistract2 = S.labels_distract2 ~= nil

                
                if doTrainData then
                    trainData.inputMatrix = torch.Tensor(nTrainSamp * nSNRs * nFonts, 1, height, width) 
                    trainData.labels = torch.Tensor(nTrainSamp * nSNRs * nFonts)
                    if nPositions > 1 then
                        trainData.labels_indiv_pos = torch.Tensor(nTrainSamp * nSNRs * nFonts)
                    end                    
                    if haveLabelsDistract then
                        trainData.labels_distract = torch.Tensor(nTrainSamp * nSNRs * nFonts)
                    end
                    if haveLabelsDistract2 then
                        trainData.labels_distract2 = torch.Tensor(nTrainSamp * nSNRs * nFonts)
                    end             
                    trainData.nInputs = nInputs
                    trainData.height = height
                    trainData.width = width
                    trainData.nClasses = nClassesTot
                    trainData.fileNames = ''
                    trainData.nPositions = nPositions
                end
                                
                if doTestData then
                    testData.inputMatrix = torch.Tensor(nTestSamp * nSNRs * nFonts, 1, height, width) 
                    testData.labels = torch.Tensor(nTestSamp * nSNRs * nFonts)
                    if nPositions > 1 then
                        testData.labels_indiv_pos = torch.Tensor(nTestSamp * nSNRs * nFonts)
                    end
                    if haveLabelsDistract then
                        testData.labels_distract = torch.Tensor(nTestSamp * nSNRs * nFonts)
                    end
                    if haveLabelsDistract2 then
                        testData.labels_distract2 = torch.Tensor(nTestSamp * nSNRs * nFonts)
                    end

                    testData.nInputs = nInputs
                    testData.height = height
                    testData.width = width
                    testData.nClasses = nClassesTot
                    testData.fileNames = ''
                    testData.nPositions = nPositions
                end
                
                firstIteration = false
            end
            
            
            if loadOpts.elementWiseNormalizeInputs == true then
                elementWiseNormalizeDataset(S) 
            end
            
            
            -- training data: get indices 
            if doTrainData then
                SS = S
                NTr = nTrainSamp
                TT = trainData
                local train_idxs = { last_trainIdx + 1, last_trainIdx + nTrainSamp}   
                last_trainIdx = last_trainIdx + nTrainSamp            
                -- training data: copy inputs & labels to collection tensor 
                trainData.inputMatrix[{ train_idxs }]  = S.inputMatrix[{{1, nTrainSamp }}]
                trainData.labels[{ train_idxs }]       = S.labels      [{{1, nTrainSamp }}] + class_offset
                if nPositions > 1 then
                    trainData.labels_indiv_pos[{ train_idxs }]   = labels_indiv_pos[{{1, nTrainSamp }}]
                end                
                if haveLabelsDistract then
                    trainData.labels_distract[ { train_idxs }] = S.labels_distract [{{1, nTrainSamp}}] + class_offset
                end
                if haveLabelsDistract2 then
                    trainData.labels_distract2[ { train_idxs }] = S.labels_distract2[{{1, nTrainSamp}}] + class_offset
                end                
                
                trainData.fileNames = trainData.fileNames .. file_name .. ';'
            end       
            
            if doTestData then
                -- test data: get indices 
                local test_idxs = { last_testIdx + 1, last_testIdx + nTestSamp}
                last_testIdx  = last_testIdx  + nTestSamp
                -- test data: copy inputs & labels to collection tensor 
                testData.inputMatrix[{ test_idxs }] = S.inputMatrix[{{nTrainSamp+1, nTrainSamp+nTestSamp}}]
                testData.labels[{ test_idxs }]       = S.labels      [{{nTrainSamp+1, nTrainSamp+nTestSamp}}] + class_offset
                if nPositions > 1 then
                    testData.labels_indiv_pos[{ test_idxs }]   = labels_indiv_pos[{{nTrainSamp+1, nTrainSamp+nTestSamp}}]
                end
                if haveLabelsDistract then
                    testData.labels_distract[ { test_idxs }] = S.labels_distract [{{1, nTestSamp}}] + class_offset
                end
                if haveLabelsDistract2 then
                    testData.labels_distract2[ { test_idxs }] = S.labels_distract2[{{1, nTestSamp}}] + class_offset
                end                
                
                testData.fileNames = testData.fileNames .. file_name .. ';'
            end
   

        end
    
        
        if loadOpts.lockDataFiles then
            lock.removeLock(loadingFontLockName)
        end
    end
    
    
    if doTrainData then
        checkDataSetValid(trainData)
    end
    if doTestData then
        checkDataSetValid(testData)
    end
    return trainData, testData

    
end

--loadNoisyLetters = function(fontNames, SNRs, noisyLetterOpts, loadOpts)   -- for noisy letters, or texture statistics of noisy letters
    

loadMetamerLetters = function(fontName, metamerLetterOpts, loadOpts)
    -- returns: trainData_tbl, testData_tbl, idealProportion (only if one font & one dnr) 
                
    local totalUseFrac = loadOpts.totalUseFrac or 1
    local trainFrac    = loadOpts.trainFrac or 1
    
    local doTestData = trainFrac < 1

    local fonts_descrip, snr_descrip
    -- process which fonts to load
            
    local font_descrip =  'Font = ' .. fontName 
    
    
    if totalUseFrac < 1 then
        font_snr_descrip = font_descrip .. string.format(' (Using %.1f%%)', totalUseFrac*100) 
    end
    
    local trainData = {}
    local testData = {}
    if doTestData then        
        trainData.descrip = 'Training Data; ' .. font_descrip
        testData.descrip = 'Testing Data; ' .. font_descrip
    else
        trainData.descrip = 'All Data; ' .. font_descrip 
    end
    
    local nSamplesTotal
    
            
    local S, noisy_file_name = loadTorchDataFile(fontName, snr, metamerLetterOpts)
    
    nSamplesTotal = S.labels:numel()
    
    local nUse = math.ceil(nSamplesTotal * totalUseFrac)
    local nTrainSamp = math.ceil(nUse * trainFrac)
    local nTestSamp = nUse - nTrainSamp
    local nClasses = S.nClasses[1][1]
    local nInputs = S.inputMatrix[1]:numel()
    
    local height
    local width
    if not trainData.inputMatrix then -- initialize tensors to hold data
        local heightOrig = S.inputMatrix:size(2) -- 6/15/2014 switched height/width
        local widthOrig  = S.inputMatrix:size(3)
        if metamerLetterOpts.tileMetamers then
            height = heightOrig*2
            width = heightOrig*2  
        else
            height = heightOrig
            width = widthOrig
        end
        
        trainData.inputMatrix = torch.Tensor(nTrainSamp, 1, height, width) 
        trainData.labels = torch.Tensor(nTrainSamp)
        trainData.nInputs = nInputs
        trainData.height = height
        trainData.width = width
        trainData.nClasses = nClasses
        trainData.fileNames = ''
                        
        if doTestData then
            testData.inputMatrix = torch.Tensor(nTestSamp, 1, height, width) 
            testData.labels = torch.Tensor(nTestSamp)
            testData.nInputs = nInputs
            testData.height = height
            testData.width = width
            testData.nClasses = nClasses
            testData.fileNames = ''
        end
    end
    
    -- training data: get indices 
    local train_idxs = { 1, nTrainSamp}   
    
    
    -- training data: copy inputs & labels to collection tensor 
    trainData.inputMatrix[{ train_idxs }]  = S.inputMatrix[{{1, nTrainSamp }}]
    trainData.labels[{ train_idxs }]       = S.labels      [{{1, nTrainSamp }}]
    trainData.fileNames = trainData.fileNames .. noisy_file_name .. ';'

    if doTestData then
        -- test data: get indices 
        local test_idxs = { 1, nTestSamp}
        -- test data: copy inputs & labels to collection tensor 
        testData.inputMatrix[{ test_idxs }] = S.inputMatrix[{{nTrainSamp+1, nTrainSamp+nTestSamp}}]
        testData.labels[{ test_idxs }]       = S.labels      [{{nTrainSamp+1, nTrainSamp+nTestSamp}}]
        testData.fileNames = testData.fileNames .. noisy_file_name .. ';'
    end

    
    if doTestData then
        return trainData, testData
    else
        return trainData
    end

    
end



--[[
matlab version (rgb)
matlab version2 (gray, uint8)

--> torch version1 (gray, float, normalized to have 0 mean, unit variance)

--]]


---[[
saveRealDataMatFiles = true --not onNYUserver


         


loadRealData = function(realDataFont, loadOpts)
    --print('realDataFont', realDataFont)
    RealDataFont = realDataFont
    ---print('loadopts', loadOpts)
    
    local S_train = loadRealDatafile(realDataFont, 'train', loadOpts)
    local S_test  = loadRealDatafile(realDataFont, 'test',  loadOpts)
    
    if loadOpts and loadOpts.separateFontsAndSNR then
        S_train = {{S_train}}
        S_test = {{S_test}}
    end
    
    SS_train = S_train
    SS_test = S_test
    return S_train, S_test

end

loadAllNormalizedRealDataFiles = function(doTextureStats)
    
    doTextureStats = doTextureStats == true or doTextureStats == 1 or false
    local doTransposeForMATfiles = false
   
    --local tbl_realDataNames = {'SVHN', 'CIFAR10'}
    local tbl_realDataNames = {'SVHN'}
    --local tbl_realDataNames = {'CIFAR10'}
    local fileTypes = {'train', 'test'}
    local tbl_globalNorm_and_localContrastNorm = { {false, false}, {true, false}, {true, true} }
    --local tbl_globalNorm_and_localContrastNorm = { {false, false} }
    --local tbl_imageSizes = { {32, 32}, {64, 64} }
    local tbl_imageSizes = { {32, 160} }
    
    local tbl_textureStatsUse = {'V2'}
    local tbl_Nscl_Nori_Na = { {3, 4, 7},  }
    local tbl_textureParams 
    if doTextureStats then
        tbl_textureParams = expandOptionsToList({doTextureStatistics=true,
                                                 tbl_Nscl_txt_and_Nori_txt_and_Na_txt = tbl_Nscl_Nori_Na,
                                                 tbl_textureStatsUse = tbl_textureStatsUse})
    end
    
    local allRealData_opts = expandOptionsToList( 
        {tbl_realDataName = tbl_realDataNames,
         tbl_globalNorm_and_localContrastNorm = tbl_globalNorm_and_localContrastNorm,
        tbl_imageSizes = tbl_imageSizes, 
        tbl_textureParams = tbl_textureParams} )
                                        
    local copyToMatlab = true and not doTextureStats
    --print(realData_opts)
    do
        --return
    end
    for i,realData_opts in ipairs(allRealData_opts) do
        
        for j,fileType in ipairs(fileTypes) do
            
            realData_opts.fileType = fileType
            local realDataName = realData_opts.realDataName
            local realDataFont = {fonts=realDataName, realData_opts=realData_opts}
            
            local dataOpts = {fontName = realDataFont}
            local _, opt_str = getRealDataOptsStr(dataOpts)
            
            
            local torchDatafileName = realDataFileName_torch(realDataName, fileType, realData_opts)
            local matDatafileName   = realDataFileName_matlab(realDataName, fileType, realData_opts)
            
            print('\n', i, '/', #allRealData_opts, ' : ', realDataName, ', file : ', opt_str, ' : ', fileType)
            print(' -- torch  : ', torchDatafileName)
            print(' -- matlab : ', matDatafileName)
            
            local S = loadRealDatafile(realDataFont)
        
            if copyToMatlab and realData_opts.globalNorm or realData_opts.localContrastNorm then
                if not paths.filep(matDatafileName) or paths.fileOlderThan( matDatafileName, torchDatafileName)  then
    
                    local createMatFileLockName = 'Creating_' .. string.gsub ( basename( matDatafileName ), '.mat', '')
                    lock.waitForLock(createMatFileLockName)
                    
                    if not paths.filep(matDatafileName) or paths.fileOlderThan( matDatafileName, torchDatafileName) then
                
                        local S_doubleFormat = mattorch.doubleFormat(S)
                        
                        S_doubleFormat.inputMatrix = removeInputPlaneDimension( S_doubleFormat.inputMatrix )
            
                        io.write(string.format('   =>Saving as %s  ... ', matDatafileName))
                        paths.verifyFolderExists(matDatafileName)
                        mattorch.save(matDatafileName, S_doubleFormat)    
                        io.write(' done\n');
                    
                    else 
                        io.write(' Another process created the file while we were waiting for the lock.\n')
                    end
                    lock.removeLock(createMatFileLockName)
                    
                        
                end
                
            end
            
        end
        
    end
         



end


loadRealDatafile = function(realDataFont, fileType, loadOpts)
    DF = realDataFont
    
    loadOpts = loadOpts or {}
    local realDataName = realDataFont.fonts
    fileType = fileType or realDataFont.realData_opts.fileType
    
    local realData_opts = table.mix(table.copy(realDataFont.realData_opts), {fileType = fileType})
    realData_opts.doTextureStatistics = realData_opts.textureParams and realData_opts.textureParams.doTextureStatistics
    
    local realData_opts_noNorm = table.copy(realData_opts)
    realData_opts_noNorm.globalNorm = false
    realData_opts_noNorm.localContrastNorm = false
    
    -- for texture statistics, always just copy from MATLAB file (dont do normalization again)
    local doSomeNormalization =  (realData_opts.globalNorm or realData_opts.localContrastNorm) and not realData_opts.doTextureStatistics 
    


    local torchDatafileName        = realDataFileName_torch(realDataName, fileType, realData_opts)
    local torchDatafileName_noNorm = realDataFileName_torch(realDataName, fileType, realData_opts_noNorm) 
    
    local matDatafileName         = realDataFileName_matlab(realDataName, fileType, realData_opts)
    local matDatafileName_noNorm  = realDataFileName_matlab(realDataName, fileType, realData_opts_noNorm)
    
    local torchNormalizationOutOfDate = doSomeNormalization and paths.fileOlderThan(torchDatafileName, torchDatafileName_noNorm)
    local matlabNormalizationOutOfDate = doSomeNormalization and (paths.fileOlderThan(matDatafileName, matDatafileName_noNorm) or 
                                                                  paths.fileOlderThan(matDatafileName, torchDatafileName) )
    
    local needToCreateTorchFile =  not paths.filep(torchDatafileName) or torchNormalizationOutOfDate
    local needToCreateMatFile   = (not paths.filep(matDatafileName) or matlabNormalizationOutOfDate) and not realData_opts.doTextureStatistics 
    
    local dbug = false
    if dbug then
        print(torchDatafileName, os.date( '%X %x', paths.filedate(torchDatafileName) ) )
        print(torchDatafileName_noNorm, os.date( '%X %x', paths.filedate(torchDatafileName_noNorm) ) )
        print('torchNormalizationOutOfDate  : ', torchNormalizationOutOfDate)
        print('matlabNormalizationOutOfDate : ', matlabNormalizationOutOfDate)
    
        print('needToCreateTorchFile', needToCreateTorchFile)
        print('needToCreateMatFile', needToCreateMatFile)
    end
    
    local useNormalizationScript = doSomeNormalization and (needToCreateTorchFile or needToCreateMatFile)
        
    if useNormalizationScript  then
        --(not paths.filep(torchDatafileName) or normalizationOutOfDate) or ( and not paths.filep(matDatafileName)) then
        print('using normalization script')
            
        if not paths.filep(torchDatafileName) then
            print('torch file : ', torchDatafileName, ' does not exist')
        elseif torchNormalizationOutOfDate then
            print('torch file : ', torchDatafileName, ' is older than unnormalized version - have to redo')
        end
        
        if (not paths.filep(matDatafileName)) then
            print('mat file : ', matDatafileName, ' does not exist')
        elseif matlabNormalizationOutOfDate then
            print('mat file : ', matDatafileName, ' is older than unnormalized version (or torch normalized version)')
        end
        
        local createRealDataFileLockName = 'Creating_' .. string.gsub ( basename( torchDatafileName ), '.t7', '')
        lock.waitForLock(createRealDataFileLockName)
        
        local stillNeedToCreateTorchFile =  not paths.filep(torchDatafileName) or torchNormalizationOutOfDate
        local stillNeedToCreateMatFile   = (not paths.filep(matDatafileName) or matlabNormalizationOutOfDate) and not realData_opts.doTextureStatistics 

        if stillNeedToCreateTorchFile or stillNeedToCreateMatFile   then
            realDataFont = {fonts= realDataName, realData_opts = realData_opts}
            createRealDatafile(realDataFont, fileType, needToCreateMatFile)
        else
            io.write('Another process created the files while we were waiting!')
        end
        lock.removeLock(createRealDataFileLockName)
    end
    
    if dbug then
        print(' ==> Now proceeding the regular load [and converting from mat->torch if necessary]')
    end
    
    local realData_opts_copy = table.copy(realData_opts)
    realData_opts_copy.matFileCanBeNewer = doSomeNormalization
    realData_opts_copy.fileType=fileType
    
    local realDataFont_copy = {fonts=realDataName, realData_opts=realData_opts_copy}
    
    local S = loadTorchRealDataFile(realDataName, fileType, realData_opts_copy)
        
    if loadOpts.elementWiseNormalizeInputs == true then
        elementWiseNormalizeDataset(S) 
    end
    SS = S
    S.nSamples_orig = S.inputMatrix:size(1)        
    if loadOpts and loadOpts.totalUseFrac and loadOpts.totalUseFrac < 1 then 
        local nUse = math.ceil(S.nSamples_orig * loadOpts.totalUseFrac)
        S.inputMatrix = S.inputMatrix[{{1, nUse}, {}, {}}]
        S.labels      = S.labels:reshape(1, S.nSamples_orig)[{ {}, {1, nUse} }]
        io.write(string.format('      [Keeping only %d out of %d total Samples]\n', nUse, S.nSamples_orig))
    end
    
    S.nInputs = S.inputMatrix[1]:numel()
    --assert(S.inputMatrix:size(2) == 1)
    S.nSamples = S.inputMatrix:size(1)
    S.height = S.inputMatrix:size(2)   --note: different from letters files, where is dims 2,3 [[ now is the same  as letters]]
    S.width = S.inputMatrix:size(3)
    
    S.inputMatrix = addInputPlaneDimension(S.inputMatrix)
    S.labels = S.labels:reshape(S.nSamples)
        
    S.nClasses = S.nClasses[1][1]
    
    checkDataSetValid(S)
    
    return S
end


function checkDataSetValid(S)
    if (S.labels:min() ~= 1) then
        error(string.format('Minimum label is %d, should be 1', S.labels:min()))
    end   
    if (S.labels:max() ~= S.nClasses) then
        error(string.format('Maximum label is %d, should be %d', S.labels:min(), S.nClasses))
    end
    
end



createRealDatafile = function(realDataFont, fileType, needToCreateMatFile)
    
    -- creates a new (possibly normalized) (torch) SVHN datafile from the original torch/MATLAB unnormalized version, 
    -- possibly adding global normalization / local contrast normalization in the process
    
    -- only do this if the matlab version does not yet exist
    local realDataName = realDataFont.fonts
    local realData_opts = realDataFont.realData_opts;
    local realData_opts_no_norm = table.copy(realData_opts) 
    realData_opts_no_norm.fileType = fileType
    realData_opts_no_norm.globalNorm = false
    realData_opts_no_norm.localContrastNorm = false
    
    
        

    local torchDatafileName_orig   = realDataFileName_torch(realDataName, fileType, realData_opts_no_norm)
    local torchDatafileName_create = realDataFileName_torch(realDataName, fileType, realData_opts)    
    
    local matDatafileName_create   = realDataFileName_matlab(realDataName, fileType, realData_opts)
    
    assert(torchDatafileName_orig ~= torchDatafileName_create)
    print(string.format('   Converting :\n      %s ==>\n      %s...', 
            paths.basename(torchDatafileName_orig), paths.basename(torchDatafileName_create)))
    

    --local torchDatafileName_orig   = dataFileName_torch('SVHN', 0, realData_opts_no_norm)
    --S = torch.load(torchDatafileName_orig)
    S = loadTorchRealDataFile(realDataName, fileType, realData_opts_no_norm) -- converts from MATLAB if necessary
    
    if realData_opts.globalNorm then   
        globalNormalizeDataset(S)
    end
    if realData_opts.localContrastNorm then
        localContrastNormalizeDataset(S)
    end
       
    
    io.write(string.format('   =>Creating %s ...', torchDatafileName_create))
    torch.save(torchDatafileName_create, S)
    io.write(' done\n');
    
    
    if needToCreateMatFile then            -- save the real data file afterwards, so its clear it doesnt need to be updated
        print('Now saving to MAT file')
        sys.sleep(1)
        local S_doubleFormat = mattorch.doubleFormat(S)
        S_doubleFormat.inputMatrix = removeInputPlaneDimension( S_doubleFormat.inputMatrix )
        
        io.write(string.format('   =>Creating %s  ... ', matDatafileName_create))
        paths.verifyFolderExists(matDatafileName_create)
        mattorch.save(matDatafileName_create, S_doubleFormat)    
        io.write(' done\n');
        
        sys.sleep(2)
    end
    
end

assign_describe = function (x_input, allX)
    local x = x_input
    local x_descrip
    if not x_input or x_input == 'all' or x_input == '' or ((type(x_input) == 'table') and #x_input == 0) then
        x = allX
        x_descrip = 'ALL'
    elseif type(x_input) == 'table' then
        x_descrip = table.concat(x_input, ',') 
    elseif  type(x_input) == 'number' or  type(x_input) == 'string'  then
        x_descrip = tostring(x_input)
    end
    
    return x, x_descrip 
    
end


    





createOverFeatFeaturesFile = function(matImFile, matFeatFiles, convertOpts)
    
    require 'mattorch'
    
    local matImFile_base = paths.basename(matImFile)
    --local matFeatFile_base = paths.basename(matFeatFile)
    
    print(string.format('   Converting :  %s  \n', matImFile_base))
    
    local S_mat = mattorch.load(matImFile)    
       
    S_mat.inputMatrix = S_mat.inputMatrix:float()  -- SVHN inputMatrix is in uint8 (byte) format
    S_mat = convertAllFieldsToDouble(S_mat)
    
    local allFeatureMatrices = convertToOverFeatFeatures(S_mat.inputMatrix, convertOpts)
    AllFeatureMatrices = allFeatureMatrices
    
    for i,matFeatFile in ipairs(matFeatFiles) do
        
        io.write(string.format(' ===> %s [%d features] \n', paths.basename(matFeatFile), allFeatureMatrices[i]:size(3) ))
        
        S_mat.inputMatrix = allFeatureMatrices[i]:double()
        mattorch.save(matFeatFile, S_mat)
        
    end
            
    MatFeatFiles = matFeatFiles
    SS = S_mat  
    
    
    --SS2 = convertAllFieldsToDouble(SS)
    --mattorch.save(MatFeatFile, SS2)
    

end



convertToOverFeatFeatures = function(inputMatrix, convertOpts)
    require 'liboverfeat_torch'
    local networkId_default = 0
    local layerId_default = 19
    
    local networkId = convertOpts.networkId or networkId_default
    
    local layerId = convertOpts.layerId or layerId_default
    
    local nSamples = inputMatrix:size(1)
    --InputMatrx = inputMatrix
    freeResourcesAfterUse = false
    
    if not weightsLoaded then
        
        io.write('Loading overfeat weight files ... '); tic()
        liboverfeat_torch.init(overfeat_weights_dir .. 'net_weight_' .. tostring(networkId), networkId)
        io.write(string.format(' done (%.1f sec) \n', toc()));
        weightsLoaded = true
    end
        
    local feature_vec = torch.FloatTensor(1)
    local output_vec = torch.FloatTensor(1)
    local image_RGB = torch.FloatTensor(3, 231, 231);
    
    io.write(string.format('Converting To Overfeat features (%d Samples)\n', nSamples))
    
    local doPBar = true
    
    if doPBar then
        progressBar.init(nSamples, math.min(80, nSamples) )
    end
    --tic()
    local inputMatrix_rescaled
    local maxAbsValue = math.max(math.abs(inputMatrix:min()), math.abs(inputMatrix:max()))
--    local maxValuePossible = 
    
    local maxRGBvalue = 255
    local offset_default = maxRGBvalue/2
    if convertOpts.autoRescaleContrast then
        print('Autoscaling contrast')
    
        inputMatrix_rescaled = (inputMatrix) * (maxRGBvalue/2) / (maxAbsValue) + (maxRGBvalue /2)
        assert (inputMatrix_rescaled:min() >= 0)
        assert (inputMatrix_rescaled:max() <= maxRGBvalue)
    
    else
        local contrast = convertOpts.OF_contrast
        local offset = convertOpts.OF_offset or offset_default
        print(string.format('Using contrast = %d, offset = %d', contrast, offset))
        inputMatrix_rescaled = (inputMatrix) * contrast  +  offset
    
    end
    
    local layerIds = convertOpts.layerIds or convertOpts.layerId
    if type(layerIds) == 'number' then
        layerIds = {layerIds}
    end
    
    local nLayersToOutput = #layerIds
    local outputMatrices = {}
    
    --inputMatrix_rescaled
    
    
    for sample_i = 1,nSamples do
        local input_i = inputMatrix_rescaled[sample_i]
        Input_i = input_i
        -- replicate value to all thee (RGB) dimensions of image
        image_RGB[1] = input_i
        image_RGB[2] = input_i
        image_RGB[3] = input_i
        
        --Output_vec = output_vec
        --Image_RGB = image_RGB;
        
        liboverfeat_torch.fprop(image_RGB, output_vec)
        
        for layer_i, layerId in ipairs(layerIds) do
            liboverfeat_torch.get_output(output_vec, layerId)
            --error('!')
            local nFeatures_thisLayer = output_vec:nElement()
        
            if sample_i == 1 then
                outputMatrices[layer_i] = torch.FloatTensor(nSamples, 1, nFeatures_thisLayer)
            end
            outputMatrices[layer_i][sample_i] = output_vec:resize(1, nFeatures_thisLayer)
        
            OutputMatrices = outputMatrices
            if sample_i == 1 and i == 1 then
                --require 'image'
                --image.display(image_RGB)
            end
        end
    
        if doPBar then
            progressBar.step()
        else
            io.write('*')
        end
        
    end
    
    if doPBar then
        progressBar.done()
    else
        io.write( string.format('%.1f\n', toc()) )
    end
    
    if freeResourcesAfterUse then
        io.write( string.format('Releasing weight file from memory ...\n') )
        liboverfeat_torch.free()
        weightsLoaded = false
    end
    
    return outputMatrices
    
end



char2string = function(charTensor)
	local str = ''
	for k = 1, charTensor:t()[1]:size(1) do 
		str = str..string.char(charTensor:t()[1][k] ) 
	end
	return str
end 


displayLetterExamples = function(trainData, nToShow, showInOrder, gap)

    local inputs = trainData.inputMatrix 
    --labels = trainData.labels
    local haveDistractLabels = trainData.labels_distract ~= nil
    local haveDistract2Labels = trainData.labels_distract2 ~= nil
    --targets = trainData.labels

    local nSamples = inputs:size(1)
    local height = inputs:size(3)  -- this is actually the width of the image in the original .mat file
    local width = inputs:size(4)
    local nPix = height*width
    
    gap = gap or 1
    
    nToShow = nToShow or 100
    local nToShowH = math.ceil(torch.sqrt(nToShow * width/height) ) 
    local nToShowW = math.floor(nToShow / nToShowH)
    nToShow = nToShowH * nToShowW -- nToShowSide*nToShowSide
    
    local alsoPrintLabels = true
    
    showInOrder = true
    local showInFileOrder = true
    
    local  image_idxs
    if showInOrder then
        image_idxs = torch.Tensor(nToShow)
        for i = 1,nToShow do
            for j = 1, nSamples do
                if trainData.labels[j] == math.mod(i-1, trainData.nClasses)+1  then
                    image_idxs[i] = j
                    break
                end
            end         
        end
            
        
    else
        image_idxs = (torch.randperm(nSamples))[{{1,nToShow}}];
    end
    if showInFileOrder then
        image_idxs = torch.range(1, nToShow)
    end
        
    
    local X_show = torch.Tensor(nToShowH*height + (nToShowH-1)*gap, nToShowW*width + (nToShowW-1)*gap);
    local med_val = (inputs:max() + inputs:min())/2
    X_show:fill(med_val)
    
    
    --SXt = S.X:t();
    
    local idx = 1
    local A_offset = string.byte('A')-1
    
    
    for j = 1,nToShowW do
        for i = 1,nToShowH do
                        
            X_show[ { {(i-1)*height + 1 + gap*(i-1), i*height + gap*(i-1)}, {(j-1)*width + 1 + gap*(j-1), j*width + gap*(j-1)} } ] = inputs[image_idxs[idx]]
            
            --[[
            if i == 1 and j == 1 then
                I = inputs[image_idxs[idx]]
            --    image.display( I[1]:t() )
            --end
            --]]

            
            if alsoPrintLabels then
                --writeChar(labels[image_idxs[idx]])
                io.write(string.format('  %s', string.char(  trainData.labels[image_idxs[idx]] + A_offset) ) )
                if haveDistractLabels then
                    --writeChar(trainData.labels_distract[image_idxs[idx]])
                    io.write(string.format('(%s)', string.char( trainData.labels_distract[image_idxs[idx]] + A_offset) ) )
                end
                if haveDistract2Labels then
                    local label2 = trainData.labels_distract2[image_idxs[idx]]
                    --io.write('[' .. tostring(label2) .. ']')
                    local validLabel = label2 >= 1 and label2 <= trainData.nClasses
                    if validLabel then
--                    writeChar(trainData.labels_distract[image_idxs[idx]])
                        io.write(string.format('(%s)', string.char( trainData.labels_distract2[image_idxs[idx]] + A_offset) ) )
                    else
                        io.write('___');
                    end
                end
                
            end

            idx = idx + 1;
        end
        io.write('\n')
    end
      
    image.display(X_show:t())
   
end






getDatafileStats = function(dataOpts, loadOpts)
    
    local fontName = getFontList(dataOpts.fontName)[1]
    
    if isRealDataFont(fontName) then
        dataOpts.fileType = 'test'
    end
                
    local sample_filename     = dataFileName_torch(fontName, 0, dataOpts)
    local sample_filename_mat = dataFileName_matlab(fontName, 0, dataOpts)
    
    local nan = 0/0
    local statsFileName = string.gsub(dataFileName_torch(fontName, nan, dataOpts), '.t7', '-stats.t7')
    local statsFileName_base = basename(statsFileName)
    
    local check = false
    local redoIfBeforeDate = 1410557030 -- 1402890705
    --fileOld = haveTorchFile and haveMatFile and paths.fileOlderThan(filename_t7, filename_mat)
    
    
    local redo = paths.fileOlderThan(statsFileName, sample_filename) or 
                 paths.fileOlderThan(statsFileName, sample_filename_mat) or 
                 paths.fileOlderThan(statsFileName, redoIfBeforeDate)
        
    local stats
    if not paths.filep(statsFileName) or check or redo then        
        print('Creating Stats file name : ', statsFileName_base)
        
        local creatingStatsFileLockName = 'Creating_' .. string.gsub ( basename( statsFileName_base ), '.t7', '')
        lock.waitForLock(creatingStatsFileLockName)
        
        -- before actually doing the conversion, double check that it still doesn't exist (maybe another session created it while we were waiting for the lock):
        local stillNeedToDo = not paths.filep(statsFileName) or check or redo
        
        if not stillNeedToDo then
            io.write('[Another process created the stats file while we were waiting!]\n')
            stats = torch.load(statsFileName)
            lock.removeLock(creatingStatsFileLockName)
            return stats
        end        
        
        if isRealDataFont(fontName) then
             loadRealData(dataOpts.fontName, loadOpts)
        end
        local S_sample, sample_filename = loadTorchDataFile(fontName, 0, dataOpts)
        Sample_filename = sample_filename
        SS_sample = S_sample
        
        
        local fieldsShouldHave = {'inputMatrix', 'nClasses', 'labels', 'orientations', 'xs', 'ys'}
        for i,fld in pairs(fieldsShouldHave) do
            if not S_sample[fld] then
                print(string.format('Error! File does not have the variable "%s". Deleting ... (please re-create afterwards)', fld)) 
                os.execute(string.format('rm %s', sample_filename))
                error('File was deleted. Aborting ...');
            end
        end
        
        local nInputs  = S_sample.inputMatrix[1]:numel()
        local nSamples = S_sample.inputMatrix:size(1)
        
        --local height   = S_sample.inputMatrix:size(3) -- old versions
        --local width    = S_sample.inputMatrix:size(2)
        local height   = S_sample.inputMatrix:size(2) -- 6/15/2014 - changing "height" & "width" to *torch* (NOT matlab) height/width 
        local width    = S_sample.inputMatrix:size(3) -- torch will be viewing the images/inputs 'sideways' compared to matlab. (e.g. a 'wide' input will be 'tall')
        local nClasses = S_sample.nClasses[1][1]
        local nX       = S_sample.xs:numel()
        local nY       = S_sample.ys:numel()
        local nOri     = S_sample.orientations:numel()
        local nPositions = nX * nY * nOri
        
        --local signalSize = S_sample.signalMatrix:size()        
        --local nClasses = signalSize[#signalSize-2]
        stats = {file_name = sample_filename, nInputs = nInputs, height = height, width = width, nClasses = nClasses, nX = nX, nY = nY, nOri = nOri, nPositions = nPositions, nSamples = nSamples}
                                                    
        if paths.filep(statsFileName) and check and not redo then
            local stats_saved = torch.load(statsFileName)
        
            assert(stats_saved.nInputs == stats.nInputs)
            assert(stats_saved.nClasses == stats.nClasses)
            assert(stats_saved.height == stats.height)
            assert(stats_saved.width == stats.width)
        
        end
                                            
        torch.save(statsFileName, stats)
        
        lock.removeLock(creatingStatsFileLockName)
    else
        --stats = torch.load(statsFileName)
        stats = loadFile(statsFileName, true)
        if (stats == nil) then -- if failed to load, should delete and try again.
            stats = getDatafileStats(dataOpts, loadOpts)
        end
        
    end
    return stats
                 

end



loadTorchDataFile = function(fontName, snr, dataOpts)
            
    local filename_t7  = dataFileName_torch(fontName, snr, dataOpts)
    local filename_mat = dataFileName_matlab(fontName, snr, dataOpts)
    
    local S = loadTorchOrMatlabFile(filename_t7, filename_mat, dataOpts)    
    
    return S, filename_t7
        
end


loadTorchRealDataFile = function(realDataName, fileType, realData_opts)
            
    local filename_t7  = realDataFileName_torch(realDataName, fileType, realData_opts)
    local filename_mat = realDataFileName_matlab(realDataName, fileType, realData_opts)
    
    local S = loadTorchOrMatlabFile(filename_t7, filename_mat, realData_opts)
    
    return S, filename_t7    
    
end




dataFileName_torch = function(fontName, snr, dataOpts)
    if isRealDataFont(fontName) then
        return realDataFileName_torch(fontName, dataOpts.fileType, dataOpts.fontName.realData_opts)
        
    elseif table.anyEqualTo(dataOpts.expName, {'ChannelTuning', 'Complexity', 'Grouping', 
                             'TrainingWithNoise', 'TestConvNet', 'Uncertainty', 'Crowding'})  then
        return noisyLetterFileName_torch(fontName, snr, dataOpts)
    
    elseif dataOpts.expName == 'MetamerLetters' then
        return metamerLetterFileName_torch(fontName, snr, dataOpts)
    end
end

dataFileName_matlab = function(fontName, snr, dataOpts)
    if isRealDataFont(fontName) then        
        return realDataFileName_matlab(fontName, dataOpts.fileType, dataOpts.fontName.realData_opts)
        
    elseif table.anyEqualTo(dataOpts.expName, {'ChannelTuning', 'Complexity', 'Grouping', 
                            'TrainingWithNoise', 'TestConvNet', 'Uncertainty','Crowding'})  then
        return noisyLetterFileName_matlab(fontName, snr, dataOpts)
    
    elseif dataOpts.expName == 'MetamerLetters' then
        return metamerLetterFileName_matlab(fontName, snr, dataOpts)
    end
end



    
loadTorchOrMatlabFile = function(filename_t7, filename_mat, convertOpts, secondTry)
    
    local deleteFileAndTryAgainIfReadError = true
    --local curTime = os.time()
    print('   Loading:   ' .. paths.basename(filename_t7))

    local lockWhenConvertingFiles = not SKIP_LOCKS
    local haveTorchFile = paths.filep(filename_t7)
    local haveMatFile = paths.filep(filename_mat)
    
    local isTexture = string.find(filename_mat, '_N') and string.find(filename_mat, '_K') and string.find(filename_mat, '_M')
    local isRealData_norm_image = (string.find(filename_mat, 'gnorm') or string.find(filename_mat, 'lcnorm')) and not isTexture
    local canConvertFromMAT = not isRealData_norm_image
    
    local fileOld = haveTorchFile and haveMatFile and (paths.fileOlderThan(filename_t7, filename_mat) and not convertOpts.matFileCanBeNewer) and canConvertFromMAT
    --local isOverFeatFile = string.find(filename_t7, '_OF')
    
    if not haveTorchFile or fileOld then
                
        if canConvertFromMAT and not haveMatFile then
            error(string.format('Torch File : \n   %s \n not found and MATLAB file %s    \n is not found either:', filename_t7, filename_mat ))
        elseif not canConvertFromMAT then
            error(string.format('Torch File : \n   %s \n was not found (and could not be converted from a MATLAB file )', filename_t7 ))
        end
        
        ---[[
        -- place a lock so that another session doesn't try to create this file at the same time.
        --local convertingFontLockName
        
        local convertingFontFileLockName = 'Converting_' .. string.gsub ( basename( filename_t7 ), '.t7', '')
        assert(canConvertFromMAT)
        
        if lockWhenConvertingFiles then
            lock.waitForLock(convertingFontFileLockName)
        end 
        
        -- before actually doing the conversion, double check that it still doesn't exist (maybe another session created it while we were waiting for the lock):
        haveTorchFile = paths.filep(filename_t7)
        fileOld = haveTorchFile and haveMatFile and (paths.fileOlderThan(filename_t7, filename_mat) )
        
        if not haveTorchFile or fileOld then
            if fileOld then
                io.write('MAT file is newer than current torch file: updating ...\n')
            end
        
            convertMatToTorch(filename_mat, filename_t7, convertOpts)
        else
            io.write('[Another process created the file while we were waiting!]\n')
        end
        
        if lockWhenConvertingFiles then
            lock.removeLock(convertingFontFileLockName)
        end
            
--]]
        
        
    end
    
    local S, result = loadFile( filename_t7 )

    if (S == nil) then
        if not secondTry and deleteFileAndTryAgainIfReadError then -- ie. is first try, and want delete and try again
            io.write(string.format('Tried to load this torch file:\n   %s\nbut got this error:\n   %s\nDeleting file and trying one more time...\n', filename_t7 , result))
            
            os.execute(string.format('rm %s', filename_t7))
            
            S = loadTorchOrMatlabFile(filename_t7, filename_mat, convertOpts, true)
                
        elseif secondTry then
            error(string.format('Error : could not read torch file: \n   %s', filename_t7))
        end
    end
    
    
    return S
end

get_SNR_str = function(snr, prefix, flip)
    
    prefix = prefix or '-'
        
    if (snr == nil) or isnan(snr) then
        return ''
    else
        if flip then
            return prefix .. string.gsub (  string.format('SNR%02.0f', snr*10), '-', 'n' )
        else
            return prefix .. string.gsub (  string.format('%02.0fSNR', snr*10), '-', 'n' )
        end
    end
end



---------------   Noisy file names  --------------------------------------------



noisyLetterFileName_torch = function(fontName, snr, noisyLetterOpts)
            
    return torch_datasets_dir .. getDatasetSubfolder(noisyLetterOpts) .. '/' .. fontName .. '/' .. 
        noisyLetterFileName_raw(fontName, snr, noisyLetterOpts) .. '.t7'
    
end


noisyLetterFileName_matlab = function(fontName, snr, noisyLetterOpts)

    return matlab_datasets_dir .. getDatasetSubfolder(noisyLetterOpts) .. '/' .. fontName .. '/' .. 
        noisyLetterFileName_raw(fontName, snr, noisyLetterOpts) .. '.mat'
    
end


noisyLetterFileName_raw = function(fontName, snr, noisyLetterOpts)
    
    local wiggleStr = ''
    local fontNameStr = abbrevFontStyleNames(fontName)
    
    local tf_pca = noisyLetterOpts.PCA and (noisyLetterOpts.PCA == true)
    local pca_str = iff(tf_pca, '_PCA', '')
    local sizeStr = getFontSizeStr(noisyLetterOpts.sizeStyle)
    
    local noisyOpts_str = getNoisyLetterOptsStr(noisyLetterOpts)
    local snr_str = get_SNR_str(snr)
                        
    return string.format('%s%s_%s%s-%s%s',fontNameStr, wiggleStr, sizeStr, pca_str, 
        noisyOpts_str, snr_str)   
end


---------------   Noisy Letter Texture Statistics file names  --------------------------------------------
--[[
NoisyLettersTextureStatsFileName_torch = function(fontName, snr, NoisyLettersTextureStatsOpts)
        
    return torch_datasets_dir .. 'NoisyLettersStats/' .. fontName .. '/' .. 
        NoisyLettersTextureStatsFileName_raw(fontName, snr, NoisyLettersTextureStatsOpts) .. '.t7'
    
end


NoisyLettersTextureStatsFileName_matlab = function(fontName, snr, NoisyLettersTextureStatsOpts)

    return matlab_datasets_dir .. 'NoisyLettersStats/' .. fontName .. '/' .. 
        NoisyLettersTextureStatsFileName_raw(fontName, snr, NoisyLettersTextureStatsOpts) .. '.mat'
    
end



NoisyLettersTextureStatsFileName_raw = function(fontName, snr, NoisyLettersTextureStatsOpts)
    
    local opts_str = getTextureStatsOptsStr(NoisyLettersTextureStatsOpts)
    
    local snr_str = get_SNR_str(snr)
             
    return string.format('%sStats-%s_%s%s',fontName, tostring(NoisyLettersTextureStatsOpts.sizeStyle), opts_str, snr_str)
    
end


--]]

------------- Crowded file names ---------------------------------------------

--[[
paradigm #1
--train with 1 letter at all possible positions [1,2,3,4,5]
--test with 2 letters where distances = {1,2,3,4} 
--hard to define target vs distractor - use multiple possible labels paradigm
--maybe no need to add gaussian noise, but probably good to do anyway

_x_10_10_100__Train_all_snrX
_x_10_10_100__Test_all_snrX

paradigm #2
--train with 1 letter at only at position 1 out of [1,2,3,4,5]
--test on 2 letters where letter 1 is at position1, letter 2 varies in {2,3,4,5} 
--well defined target (use single label testing paradigm), can use threshold (measure dnr)
--probably need to add gaussian noise to learn to suppress inputs at other positions

_x_10_10_100__Train_1_snrX
_x_10_10_100__Test_1_dnrY_snrX == 
--]]

--[[
crowdedLetterFileName_torch = function(fontName, logSNR, crowdedLetterOpts)
        
    return torch_datasets_dir .. getDatasetSubfolder(crowdedLetterOpts) .. '/' .. fontName .. '/' .. 
        crowdedLetterFileName_raw(fontName, logSNR, crowdedLetterOpts) .. '.t7'
    
end


crowdedLetterFileName_matlab = function(fontName, logSNR, crowdedLetterOpts)

    return matlab_datasets_dir .. getDatasetSubfolder(crowdedLetterOpts) .. '/' .. fontName .. '/' ..
        crowdedLetterFileName_raw(fontName, logSNR, crowdedLetterOpts) .. '.mat'
    
end


crowdedLetterFileName_raw = function(fontName, logSNR, crowdedLetterOpts)
    
    local sizeStyle = crowdedLetterOpts.sizeStyle;
    
    crowdedLetterOpts.logSNR = logSNR

    local crowdedOpts_str = getCrowdedLetterOptsStr(crowdedLetterOpts);
    
    local filename = string.format('%s-%s_%s', fontName, sizeStyle, crowdedOpts_str);
    return filename
    
end
--]]


---------------   Metamer file names  --------------------------------------------

metamerLetterFileName_torch = function(fontName, metamerLetterOpts)
        
    return torch_datasets_dir .. 'MetamerLetters/' .. fontName .. '/' .. 
        metamerLetterFileName_raw(fontName, metamerLetterOpts) .. '.t7'
    
end


metamerLetterFileName_matlab = function(fontName, metamerLetterOpts)
    
    return matlab_datasets_dir .. 'MetamerLetters/' .. fontName .. '/' .. 
        metamerLetterFileName_raw(fontName, metamerLetterOpts) .. '.mat'
    
end


metamerLetterFileName_raw = function(fontName, metamerLetterOpts)
    
    return string.format('%s_%s-metamers',fontName, getMetamerLetterOptsStr(metamerLetterOpts) )
end

------------------- RealData (SVHN, CIFAR) file names ------------------------------------



realDataFileName_torch = function(realDataName, fileType, realDataOpts)
    
    local torch_dir = torch_datasets_dir .. realDataName .. '/'
    local torch_filename = realDataFileName_raw(realDataName, fileType, realDataOpts)
    
    return torch_dir .. torch_filename .. '.t7'
end

realDataFileName_matlab = function(realDataName, fileType, realDataOpts)
    
    local matlab_dir = matlab_datasets_dir .. realDataName .. '/'    
    local matlab_filename = realDataFileName_raw(realDataName, fileType, realDataOpts)
    
    return matlab_dir .. matlab_filename .. '.mat'
end

realDataFileName_raw = function(realDataName, fileType, realDataOpts)
    
    --local realDataName_str = abbrevFontStyleNames(realDataOpts.fontName)
--[[    
    if realDataOpts.fontName and isRealDataFont(realDataOpts.fontName) 
        and realDataOpts.fontName.realData_opts then
        realDataOpts = realDataOpts.fontName.realData_opts;
    end
    --]]    
    local _, realData_opts_fileStr = getRealDataOptsStr(realDataOpts)
    
    return string.format('%s_%s%s', realDataName, fileType, realData_opts_fileStr)
end






--------------- Misc Helper functions   --------------------------------------------

getLimitsStr = function(nx, x_range)
    local str
    if nx > 1 then
        str = string.format('[%d]', x_range)
    else
        str = ''
    end
    return str

end



--[[
    if not fontNames or fontNames == 'all' or fontNames == '' then
        fontNames = allFontNames    
        fonts_descrip = 'ALL'
    elseif type(fontNames) == 'table' then
        fonts_descrip = table.concat(fontNames, ',')
    elseif type(fontNames) == 'string' then
        fonts_descrip = fontNames
    end
    
    if not SNRs or SNRs == 'all' or ((type(SNRs) == 'table') and #SNRs == 0) then
        SNRs = allSNRs     
        snr_descrip = 'ALL'
    elseif type(SNRs) == 'table' then
        snr_descrip =  table.concat(SNRs, ',')
    elseif type(SNRs) == 'number' then
        snr_descrip = SNRs
    end

--]]


--[[
                    if test_dnrs_separate then
                        test_idxs = { 1, nTestSamp }
                    else
                        test_idxs = { last_test2Idx + 1, last_test2Idx + nTestSamp}   
                        last_test2Idx  = last_test2Idx  + nTestSamp
                        
                    end
                    
                    if test_dnrs_separate then
                        testData2[ndist_i][ds_i][dnr_i] = table.copy(testData2_i)
                    end
--]]

--[[


loadCrowdedLetters = function(fontNames, SNRs, crowdedLetterOpts, loadOpts)
    
--all_nDistractors, distractorSpacings, testDNRs
    -- returns: trainData_tbl, testData_tbl, idealProportion (only if one font & one dnr) 
        
            
    local totalUseFrac = loadOpts.totalUseFrac or 1
    local trainFrac    = loadOpts.trainFrac or 1
    
        
    local doTrainData = trainFrac > 0 and (loadOpts.loadTrainingData == nil) or (loadOpts.loadTrainingData == true)
    local doTestData = trainFrac < 1  and (loadOpts.loadTestData     == nil) or (loadOpts.loadTestData     == true)

    
    local snr = crowdedLetterOpts.logSNR
    local nDistractors = crowdedLetterOpts.nDistractors
    local distractorSpacing = crowdedLetterOpts.distractorSpacing
    local logDNR = crowdedLetterOpts.logDNR
    
    local nLetters = crowdedLetterOpts.nLetters
    local trainTestType = iff(nLetters == 1, 'Train', 'Test')
    
    local fonts_descrip, snr_descrip
    
    -- process which fonts to load
    fontNames, fonts_descrip = assign_describe(fontNames, allFontNames)
    
    testSNRs, snr_descrip = assign_describe(testSNRs, SNRs)
        
    local font_descrip = 'Fonts = ' .. fonts_descrip
    local font_snr_descrip = font_descrip  .. '; SNRs = ' .. snr_descrip
    
    if type(fontNames) == 'string' then
        fontNames = {fontNames}
    end
    local nFonts = #fontNames    
    
    --[[
    if type(nDistractors) == 'number' then
        all_nDistractors = {all_nDistractors}        
    end    
    local nnDistractors = #all_nDistractors
    
    if type(distractorSpacings) == 'number' then
        distractorSpacings = {distractorSpacings}        
    end    
    local nSpacings = #distractorSpacings
    
    if type(testSNRs) == 'number' then
        testSNRs = {testSNRs}        
    end    
    local nSNRs = #testSNRs    
        --]]
    
    --[[
    if totalUseFrac < 1 then
        font_snr_descrip = font_snr_descrip .. string.format(' (Using %.1f%%)', totalUseFrac*100) 
    end
    
    local nTestSamp
    local trainData = {}
    local testData = {}
    
    
    if doTestData then
        trainData.descrip = 'Training Data (1 letter); ' .. font_descrip
        testData.descrip = 'Testing Data  (1 letter); ' .. font_descrip
    else
        trainData.descrip = 'All Data  (1 letter); ' .. font_descrip
    end
--    testData2.descrip = 'Testing Data (2 letters); ' .. font_snr_descrip
    testData2_i.descrip = 'Testing Data (2 letters); ' .. font_snr_descrip
    
        
    local last_trainIdx = 0
    local last_testIdx = 0
    
    local firstIteration = true
    
    
    for fi,fontName in pairs(fontNames) do
                
        for si,SNR in pairs(allSNRs) do

        
        
        
        local S1, noisy_file_name_train = loadCrowdedLetterTorchFile(trainTestType, fontName, crowdedLetterOpts)
    
    
        local nSamplesTotal = S1.labels:numel()
        local nUse = math.ceil(nSamplesTotal * totalUseFrac)
        local nTrainSamp = math.ceil(nUse * trainFrac)   -- nUse = math.ceil(nSamplesTotal * totalUseFrac)
        local nTestSamp  = nUse - nTrainSamp
        local height      = S1.inputMatrix:size(3)
        local width       = S1.inputMatrix:size(2)
        local nInputs     = S1.inputMatrix[1]:numel()
        local nClasses    = S1.nLetters[1][1]

        if firstIteration then -- initialize tensors to hold data        
            do
            trainData.inputMatrix = torch.Tensor(nTrainSamp * nFonts, 1, height, width) 
            trainData.labels = torch.Tensor(nTrainSamp * nFonts)
            trainData.nInputs = nInputs
            trainData.height = height
            trainData.width = width
            trainData.nClasses = nClasses
            trainData.fileNames = ''
            
            if doTestData then -- initialize tensors to hold data        
                testData.inputMatrix = torch.Tensor(nTestSamp * nFonts, 1, height, width) 
                testData.labels = torch.Tensor(nTestSamp * nFonts)
                testData.nInputs = nInputs
                testData.height = height
                testData.width = width
                testData.nClasses = nClasses
                testData.fileNames = ''
            end
            
        end
    
            -- training data: get indices 
        local train_idxs = { last_trainIdx + 1, last_trainIdx + nTrainSamp}   
        last_trainIdx = last_trainIdx + nTrainSamp            
        -- training data: copy inputs & labels to collection tensor 
        trainData.inputMatrix[{ train_idxs }]  = S1.inputMatrix[{{1, nTrainSamp }}]
        trainData.labels[{ train_idxs }]       = S1.labels     [{{1, nTrainSamp }}]
        trainData.fileNames = trainData.fileNames .. noisy_file_name_train .. ';'
    
        if doTestData then
            -- test data: get indices 
            local test_idxs = { last_testIdx + 1, last_testIdx + nTestSamp}
            
            -- test data: copy inputs & labels to collection tensor 
            testData.inputMatrix[{ test_idxs }] = S1.inputMatrix[{{nTrainSamp+1, nTrainSamp+nTestSamp}}]
            testData.labels[{ test_idxs }]      = S1.labels      [{{nTrainSamp+1, nTrainSamp+nTestSamp}}]
            testData.fileNames = testData.fileNames .. noisy_file_name_train .. ';'
            
            last_testIdx  = last_testIdx  + nTestSamp
        end
    
        local nDistractorsMAX = all_nDistractors[#all_nDistractors]
        for ndist_i, nDistractors in ipairs(all_nDistractors) do
            testData2[ndist_i] = {}
                
            for ds_i, DistSpacing in ipairs(distractorSpacings) do
                testData2[ndist_i][ds_i] = {}
                
                for snr_i, SNR in ipairs(allSNRs) do
                    
                    local S2, noisy_file_name_test = loadCrowdedLetterTorchFile('Test', fontName, crowdedLetterOpts, nDistractors, DistSpacing, DNR)
                    
                   
                    if nTestSamp then
                        assert(nTestSamp == S2.labels_signal:numel())  -- make sure all files have same # samples (10,000)
                    else
                        nTestSamp = S2.inputMatrix:size(1)
                    end
                    --nUse = math.ceil(nSamplesTotal * totalUseFrac)
                                
                    if not testData2_i.inputMatrix then -- initialize tensors to hold data  
                        print('initializing ...')
                        testData2_i.inputMatrix = torch.Tensor(nTestSamp * mult * nFonts, 1, height, width)
                        testData2_i.labels = torch.Tensor(nTestSamp * mult * nFonts)
                        testData2_i.labels_distract = torch.Tensor(nTestSamp * mult * nFonts)
                        
                        if nDistractorsMAX > 1 then
                            assert(nDistractorsMAX == 2)
                            testData2_i.labels_distract2 = torch.Tensor(nTestSamp * mult * nFonts)
                        end
                        testData2_i.nInputs = nInputs
                        testData2_i.height = height
                        testData2_i.width = width
                        testData2_i.nClasses = nClasses
                        testData2_i.fileNames = ''
                    end
                    
                    -- test data: get indices 
                    local test_idxs
                    if test_dnrs_separate then
                        test_idxs = { 1, nTestSamp }
                    else
                        test_idxs = { last_test2Idx + 1, last_test2Idx + nTestSamp}   
                        last_test2Idx  = last_test2Idx  + nTestSamp
                        
                    end
                    --print(test_idxs);
                    
                    --print('before')
                    --print(testData2_i.labels[5], testData2_i.labels[10005])
                    -- test data: copy inputs & labels to collection tensor 
                    --test_idxs_cpy = test_idxs
                    --nTestSamp_cpy = nTestSamp
                    --S2_cpy = S2
                    testData2_i.inputMatrix [{ test_idxs  }] = S2.inputMatrix[  {{1, nTestSamp}}]
                    testData2_i.labels      [{ test_idxs }]  = S2.labels_signal[{{1, nTestSamp}}]
                    testData2_i.labels_distract[ { test_idxs }] = S2.labels_distract [{{1, nTestSamp}}]
                    if nDistractors > 1 then
                        testData2_i.labels_distract2[ { test_idxs }] = S2.labels_distract2[{{1, nTestSamp}}]
                    end
                    testData2_i.fileNames = testData2_i.fileNames .. noisy_file_name_test;
                    --print('returning')
                    --print('after')
                    --print(testData2_i.labels[5], testData2_i.labels[10005])
                    
                    if test_dnrs_separate then
                        testData2[ndist_i][ds_i][dnr_i] = table.copy(testData2_i)
                    end

                end -- loop over DNRs
                
            end -- loop over distractorSpacings
            
        end  -- loop over all_nDistractors
        
        
    end -- loop over fontNames



    return trainData, testData

    
end

--]]


--[[
            if letterOpts.exp_typ == 'NoisyLetters' then
                S, file_name= loadTorchDataFile(font, snr, letterOpts)
            elseif letterOpts.exp_typ == 'NoisyLettersTextureStats' then
                S, file_name = loadNoisyLettersTextureStatsTorchFile(font, snr, letterOpts)
            elseif letterOpts.exp_typ == 'CrowdedLetters' then
                S, file_name = loadCrowdedLetterTorchFile(font, snr, letterOpts.nLetters, letterOpts)
            end

--]]

--[[


loadNoisyLetterTorchFile = function(fontName, snr, noisyLetterOpts)
            
    local filename_t7  = noisyLetterFileName_torch(fontName, snr, noisyLetterOpts)
    local filename_mat = noisyLetterFileName_matlab(fontName, snr, noisyLetterOpts)
    
    --getNoisyLettersStats(fontName, noisyLetterOpts)

    local S = loadTorchOrMatlabFile(filename_t7, filename_mat)
    return S, filename_t7
    
end

loadNoisyLettersTextureStatsTorchFile = function(fontName, snr, noisyLetterStatsOpts)
            
    local filename_t7  = NoisyLettersTextureStatsFileName_torch(fontName, snr, noisyLetterStatsOpts)
    local filename_mat = NoisyLettersTextureStatsFileName_matlab(fontName, snr, noisyLetterStatsOpts)
    
    --getNoisyLettersStats(fontName, noisyLetterOpts)

    local S = loadTorchOrMatlabFile(filename_t7, filename_mat)
    return S, filename_t7
    
end


loadCrowdedLetterTorchFile = function(fontName, logSNR, crowdedLetterOpts)
            
    local filename_t7 = crowdedLetterFileName_torch(fontName, logSNR, crowdedLetterOpts)
    local filename_mat = crowdedLetterFileName_matlab(fontName, logSNR, crowdedLetterOpts)
    
    local S = loadTorchOrMatlabFile(filename_t7, filename_mat)
    
    return S, filename_t7
end


loadMetamerLetterTorchFile = function(fontName, metamerLetterOpts)
    
    local filename_t7 = metamerLetterFileName_torch(fontName, metamerLetterOpts)
    local filename_mat = metamerLetterFileName_matlab(fontName, metamerLetterOpts)
    
    local S = loadTorchOrMatlabFile(filename_t7, filename_mat)
   
    return S, filename_t7
end
--]]


--[[


getNoisyLettersStats = function (fontName, noisyLetterOpts)
    

    if noisyLetterOpts.exp_typ == 'NoisyLettersTextureStats' then
        local stats = getNoisyLetterTextureStatisticsStats(fontName, noisyLetterOpts)
        return stats
    end
    
    local NoisyLettersTextureStatsFileName_base = string.format('%s-%s-%s-stats',fontName, getFontSizeStr(noisyLetterOpts.sizeStyle), 
        getNoisyLetterOptsStr(noisyLetterOpts))    

    local NoisyLettersTextureStatsFileName = noisy_letters_dir .. fontName .. '/' .. NoisyLettersTextureStatsFileName_base .. '.t7'
    local check = false
    
    local sample_filename = noisyLetterFileName_torch(fontName, 0, noisyLetterOpts)
    local sample_filename_mat = noisyLetterFileName_matlab(fontName, 0, noisyLetterOpts)
    
    --fileOld = haveTorchFile and haveMatFile and paths.fileOlderThan(filename_t7, filename_mat)
    
    local redo = paths.fileOlderThan(NoisyLettersTextureStatsFileName, sample_filename) or paths.fileOlderThan(NoisyLettersTextureStatsFileName, sample_filename_mat)
    
    local stats
    if not paths.filep(NoisyLettersTextureStatsFileName) or check or redo then        
        print('Creating Stats file name : ', NoisyLettersTextureStatsFileName_base)
        local S_sample, sample_filename = loadNoisyLetterTorchFile(fontName, 0, noisyLetterOpts)
        
        local nInputs = S_sample.inputMatrix[1]:numel()
        local height = S_sample.inputMatrix:size(3)
        local width  = S_sample.inputMatrix:size(2)
        local nClasses = S_sample.nClasses[1][1]
        --local signalSize = S_sample.signalMatrix:size()        
        --local nClasses = signalSize[#signalSize-2]
        stats = {file_name = sample_filename, nInputs = nInputs, height = height, width = width, nClasses = nClasses}
                                                    
        if paths.filep(NoisyLettersTextureStatsFileName) and check and not redo then
            local stats_saved = torch.load(NoisyLettersTextureStatsFileName)
        
            assert(stats_saved.nInputs == stats.nInputs)
            assert(stats_saved.nClasses == stats.nClasses)
            assert(stats_saved.height == stats.height)
            assert(stats_saved.width == stats.width)
        
        end
                                            
        torch.save(NoisyLettersTextureStatsFileName, stats)
    else
        stats = torch.load(NoisyLettersTextureStatsFileName)
        
    end
    return stats
    
end




getNoisyLetterTextureStatisticsStats = function (fontName, NoisyLettersTextureStatsOpts)
        
    local s = getTextureStatsOptsStr(NoisyLettersTextureStatsOpts)
    local NoisyLettersTextureStatsFileName_base = string.format('%s-%s-stats',fontName, getTextureStatsOptsStr(NoisyLettersTextureStatsOpts))    
    

    local NoisyLettersTextureStatsFileName = noisy_letter_stats_dir .. fontName .. '/' .. NoisyLettersTextureStatsFileName_base .. '.t7'
    local check = false
    
    local sample_filename = NoisyLettersTextureStatsFileName_torch(fontName, 0, NoisyLettersTextureStatsOpts)
    local sample_filename_mat = NoisyLettersTextureStatsFileName_matlab(fontName, 0, NoisyLettersTextureStatsOpts)
        
    local redo = paths.fileOlderThan(NoisyLettersTextureStatsFileName, sample_filename) or paths.fileOlderThan(NoisyLettersTextureStatsFileName, sample_filename_mat)
    
    local stats
    if not paths.filep(NoisyLettersTextureStatsFileName) or check or redo then        
        print('Creating Stats file name : ', NoisyLettersTextureStatsFileName_base)
        local S_sample, sample_filename = loadNoisyLettersTextureStatsTorchFile(fontName, 0, NoisyLettersTextureStatsOpts)
        
        local nInputs = S_sample.inputMatrix[1]:numel()
        local height = S_sample.inputMatrix:size(3)
        local width  = S_sample.inputMatrix:size(2)
        local nClasses = S_sample.nClasses[1][1]
        --local signalSize = S_sample.signalMatrix:size()        
        --local nClasses = signalSize[#signalSize-2]
        stats = {file_name = sample_filename, nInputs = nInputs, height = height, width = width, nClasses = nClasses}
                                                    
        if paths.filep(NoisyLettersTextureStatsFileName) and check and not redo then
            local stats_saved = torch.load(NoisyLettersTextureStatsFileName)
        
            assert(stats_saved.nInputs == stats.nInputs)
            assert(stats_saved.nClasses == stats.nClasses)
            assert(stats_saved.height == stats.height)
            assert(stats_saved.width == stats.width)
        
        end
                                            
        torch.save(NoisyLettersTextureStatsFileName, stats)
    else
        stats = torch.load(NoisyLettersTextureStatsFileName)
        
    end
    return stats
    
end


---[[
getCrowdedLettersStats = function (fontName, crowdedLetterOpts)
    
    local crowdedLetterTextureStatsFileName_base = string.format('%s-%s-%s-stats',fontName, crowdedLetterOpts.sizeStyle, 
        getCrowdedLetterOptsStr(crowdedLetterOpts))    

    local crowdedLetterTextureStatsFileName = crowded_letters_dir .. fontName .. '/' .. crowdedLetterTextureStatsFileName_base .. '.t7'
    local check = false
    
    local sample_filename = crowdedLetterFileName_torch(fontName, 0, crowdedLetterOpts)
    local redo = paths.fileOlderThan(crowdedLetterTextureStatsFileName, sample_filename)
    
    local stats
    if not paths.filep(crowdedLetterTextureStatsFileName) or check or redo then        
        local S_sample, sample_filename = loadCrowdedLetterTorchFile(fontName, 0, crowdedLetterOpts)
        local nInputs = S_sample.inputMatrix[1]:numel()
        local height = S_sample.inputMatrix:size(3)
        local width  = S_sample.inputMatrix:size(2)
        local nClasses = S_sample.nClasses[1][1]
        stats = {file_name = sample_filename, nInputs = nInputs, height = height, width = width, nClasses = nClasses}
                                                    
        if paths.filep(crowdedLetterTextureStatsFileName) and check and not redo then
            local stats_saved = torch.load(crowdedLetterTextureStatsFileName)
        
            assert(stats_saved.nInputs == stats.nInputs)
            assert(stats_saved.nClasses == stats.nClasses)
            assert(stats_saved.height == stats.height)
            assert(stats_saved.width == stats.width)
        
        end
                                            
        torch.save(crowdedLetterTextureStatsFileName, stats)
    else
        stats = torch.load(crowdedLetterTextureStatsFileName)
        
    end
    return stats
    
end
--]]


--[[

    
    if letterOpts.exp_typ == 'NoisyLetters' then
        statsFileName_base = string.format('%s-%s-%s-stats',fontName, getFontSizeStr(letterOpts.sizeStyle), 
                getNoisyLetterOptsStr(letterOpts))   
            
        statsFileName = noisy_letters_dir .. fontName .. '/' .. statsFileName_base .. '.t7'
                
    elseif letterOpts.exp_typ == 'NoisyLettersTextureStats' then
        statsFileName_base = string.format('%s-%s-stats',fontName, getTextureStatsOptsStr(letterOpts))    
                            
        statsFileName = noisy_letter_stats_dir .. fontName .. '/' .. statsFileName_base .. '.t7'
        
    elseif letterOpts.exp_typ == 'CrowdedLetters' then
        
        statsFileName_base = string.format('%s-%s-%s-stats',fontName, letterOpts.sizeStyle, 
                            getCrowdedLetterOptsStr(letterOpts))    
                        
        statsFileName = crowded_letters_dir .. fontName .. '/' .. statsFileName_base .. '.t7'
                        
    elseif letterOpts.exp_typ == 'MetamerLetters' then
        
        statsFileName_base = string.format('%s-%s-stats',fontName,  
                    getMetamerLetterOptsStr(letterOpts))    

        statsFileName = metamer_letters_dir .. fontName .. '/' .. statsFileName_base .. '.t7'
    end
--]]


--[[
        local nX, nY, nOri = 1, 1, 1
        if S_sample.xs then             nX = S_sample.xs:numel()              end
        if S_sample.ys then             nY = S_sample.xy:numel()              end
        if S_sample.orientations then   nOri = S_sample.orientations:numel()  end

--]]

--[[

        if CONVERT_IN_PARALLEL then
            --print( convertingFontFileLockName)
            --print('isLocked',  lock.isLocked(convertingFontFileLockName)     )
           -- print( 'haveLock',  lock.haveThisLock(convertingFontFileLockName) )
            
            if lock.isLocked(convertingFontFileLockName) and not lock.haveThisLock(convertingFontFileLockName) then
                io.write(string.format('Another process is already doing %s... we will do the next one...\n', convertingFontFileLockName))
                return {}, ''
            end
        end
--]]



--[[
    loadOpts = {totalUseFrac, trainFrac, elementWiseNormalizeInputs, 
                loadTrainingData, loadTestingData, separateFontsAndSNR,
                lockDataFiles,
                fontClassTable}




--]]