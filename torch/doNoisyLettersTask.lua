doNoisyLettersTask = function(allNetworkOptions_tbl, allNoisyLetterOpts_tbl, taskOpts)
    
    local repeatUntilNoSkips = true
    
    if taskOpts and taskOpts.taskFileName then
       print('\n\n-----------------------------------------------------------------------------------------') 
       print('----     Task : ' .. basename(taskOpts.taskFileName)  );
       print('-----------------------------------------------------------------------------------------\n') 
        
    end
    
    local logNoisySet = onLaptop and true
    local showDetailedOptions = true
    
    
    if logNoisySet then
        io.write('Save Current script to log file? [n]')
        local ans = io.read("*line")
        if not (ans == 'y' or ans == 'Y') then
            logNoisySet = false
        end        
        
    end

    
   
    
     ------------------------ NETWORK OPTIONS ----------------------------
     
    local allNetNames, allNetNames_nice

       --print('print1', allNetworks)    
    local allNetworks = expandOptionsToList(allNetworkOptions_tbl, taskOpts.networkOpts_loopKeysOrder)
    if allNetworkOptions_tbl.netType == 'ConvNet' then
        allNetworks = fixConvNetParams(allNetworks)
    end
    --print('print2', allNetworks)


    allNetworks, allNetNames_nice, allNetNames = uniqueNetworks(allNetworks)        
    --print( '\n===Using the following networks options ===')
    print('\n===Using the following network options ===')
    print(optionsTable2string(allNetworkOptions_tbl))
    if showDetailedOptions then
        print('\n===Using the following networks ===')
        print(allNetNames)    
        print('\n===Using the following networks (full descriptions) ===')
        print(allNetNames_nice)
    end




    
    
    if logNoisySet then
           --logFile
        local date_time_str = string.gsub(string.gsub( os.date('%Y-%m-%d__%H-%M-%S', os.time()), '[ ]', '_' ), '[/:]', '-')
        local descrip = ''
        if taskOpts.descrip then
            descrip = '_' .. taskOpts.descrip
        end
        local logFileName = lettersData_dir .. 'log/logFile_' .. date_time_str .. '_' .. expName .. '_' .. modelName .. descrip .. '.txt' 
        logFile = assert( io.open(logFileName, 'w') )
        io.write('[Writing to log file ...]\n')

        
        
        logFile:write( table.tostring(string.format('\n\n\n ======================== %s ====================== \n', os.date('%x %X', os.time()))) ) 
        --logFile:write( '\n===Using the following networks options ===')
        --logFile:write( table.tostring(allNetworkOptions))
        logFile:write( '\n===Using the following network options ===\n')
        logFile:write( optionsTable2string(allNetworkOptions_tbl))
        
    end




    ------------------------ LETTER OPTIONS ----------------------------
    
    

    local allNoisyLetterOpts = expandOptionsToList(allNoisyLetterOpts_tbl, taskOpts.loopKeysOrder_letterOpts)
    --print(allNoisyLetterOpts_tbl)
    
   
    
    for i,opt in ipairs(allNoisyLetterOpts) do
        -- unpack values in OriXY to main struct.
        allNoisyLetterOpts[i] = fixNoisyLetterOpts(allNoisyLetterOpts[i])
        
    end
    
    
    local noisyLetterOpts_strs
    allNoisyLetterOpts, noisyLetterOpts_strs = uniqueOpts(allNoisyLetterOpts)
    
 
                    --[[
                allNoisyLetterOpts = { { stimType = 'NoisyLetters', 
                                       Nori = 1, dOri = 0,    Nx = 1, dX = 0,    Ny = 1, dY = 0, 
                                       sizeStyle = 12,
                                       autoImageSize = false, 
                                       imageSize = {20, 20}, 
                                       SNR_train = snr_train
                                      } }
                              nTrials = 1
                --]]
                
                    
    print('\n===Using the following fonts : ===');
    
    local fontNames_use_strs = {}
    assert(#allNoisyLetterOpts_tbl.tbl_fontName > 0)
    for i,fn_i in ipairs(allNoisyLetterOpts_tbl.tbl_fontName) do
        fontNames_use_strs[i] = abbrevFontStyleNames(fn_i)
    end
    print(fontNames_use_strs)
    
    
    --[[
    local noisyLetterOpts_strs = {}
    for i,opt in ipairs(allNoisyLetterOpts) do
        noisyLetterOpts_strs[i] = getLetterOptsStr(opt) 
    end
    --]]
    print('\n=== Using the following noisy-letter noisy-letter options : ===');
    W = allNoisyLetterOpts_tbl
    print(optionsTable2string(allNoisyLetterOpts_tbl))
    
    do
        --return
    end
    if showDetailedOptions then
        print('\n=== Using the following noisy-letter settings : ===');
        --table.sort(noisyLetterOpts_strs)
        print(noisyLetterOpts_strs)
    end
    

    
    
    
    if logNoisySet then
        
        logFile:write('\n\n')
        logFile:write('\n=== Using the following noisy-letter options : ===\n');
        logFile:write( optionsTable2string(allNoisyLetterOpts_tbl))
        
        if showDetailedOptions or true then
            logFile:write( '\n\n\n\n More Details: \n ===Using the following networks ===\n')
            logFile:write( table.tostring(allNetNames))
            
            logFile:write(  '\n===Using the following networks (full descriptions) ===\n')
            logFile:write( table.tostring(allNetNames_nice))
            
            logFile:write('\n===Using the following fonts : ===\n ') 
            logFile:write(table.tostring( fontNames_use_strs))
        
            logFile:write('\n=== Using the following noisy-letter settings : ===\n');
            logFile:write(table.tostring(noisyLetterOpts_strs))  
            logFile:write('\n\n\n\n')
        end        

        logFile:close()
        io.write('[Finished writing to log file ...]\n')
        return
    end



    local nTotal = 0;

    local results
    
    repeat 
        
        results = doNoisyTrainingBatch(allNetworks, allNoisyLetterOpts)
            --function(fontNames, allSNRS_train, allSNRs_test, allNetworks, all_OriXY, allSizeStyles)
         
        print(results)
    
        if (results.nSkipped > 0) and repeatUntilNoSkips then
            io.write(string.format('--------------------\n\n Skipped %d networks. Trying again in 30 minutes.\n\n----------------------\n', results.nSkipped))
            for i = 1, 30 do
                for j = 1, 60 do
                    sys.sleep(1)
                end
                io.write('.');
            end
        end
     
        
    --until (results.nCompletedAlready == nTotal) or not repeatUntilNoSkips
    until (results.nSkipped == 0) or not repeatUntilNoSkips
    
    if taskOpts and taskOpts.taskFileName and (results.nSkipped == 0) then
        print('\n------------------------ Completed task! (' .. taskOpts.taskFileName .. ')------------------------\n')
        local completedTaskFileName = tasks_dir .. string.gsub(taskOpts.taskFileName, '.t7', '_completed.txt')
        if not paths.filep(completedTaskFileName) then
           print('\n------------------------ Creating "completed task" file ------------------------\n')
           logFile = assert( io.open(completedTaskFileName, 'w') )
           logFile:close()
        end
    end
    
end
       
    
    
    --[[
    
       
        
        if (nTotal == 0) then
            for k,val in pairs(results) do
                nTotal = nTotal + val
            end
        end
        
        --]]