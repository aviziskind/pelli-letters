doTask = function(task)
    
    local repeatUntilNoSkips = true
    
    if task.taskFileName then
       print('\n\n-----------------------------------------------------------------------------------------') 
       print('----     Task : ' .. basename(task.taskFileName)  );
       print('-----------------------------------------------------------------------------------------\n') 
       if onNYUserver then
            sys.sleep(2)
       end 
    end
      
    local logNoisySet = onLaptop and true
    local showDetailedOptions = true
    
  
    setFolders(task.expName, task.modelName)
       
    
     ------------------------ NETWORK OPTIONS ----------------------------
     
    local allNetNames, allNetNames_nice

    T = task
    local allNetworkOptions_tbl = task.allNetworkOptions_tbl
       --print('print1', allNetworks)    
    local allNetworks = expandOptionsToList(allNetworkOptions_tbl, task.networkOpts_loopKeysOrder)
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


   if onNYUserver then
        sys.sleep(2)
   end 



    ------------------------ LETTER OPTIONS ----------------------------
    
    
    local allDataOpts_tbl = task.allDataOpts_tbl or task.allNoisyLetterOpts_tbl
    local allDataOpts = expandOptionsToList(allDataOpts_tbl, task.loopKeysOrder_dataOpts)
    --print(allDataOpts_tbl)
    
   
    
    for i,opt in ipairs(allDataOpts) do
        -- unpack values in OriXY to main struct.
        allDataOpts[i] = fixDataOpts(allDataOpts[i])
        
    end
    A = allDataOpts
    
    local dataOpts_strs
    allDataOpts, dataOpts_strs = uniqueOpts(allDataOpts)
    
 
    print('\n===Using the following fonts : ===');
    
    local fontNames_use_strs = {}
    assert(#allDataOpts_tbl.tbl_fontName > 0)
    for i,fn_i in ipairs(allDataOpts_tbl.tbl_fontName) do
        fontNames_use_strs[i] = abbrevFontStyleNames(fn_i)
    end
    print(fontNames_use_strs)
    
    
    --[[
    local dataOpts_strs = {}
    for i,opt in ipairs(allDataOpts) do
        dataOpts_strs[i] = getDataOptsStr(opt) 
    end
    --]]
    print('\n=== Using the following data options : ===');
    
    print(optionsTable2string(allDataOpts_tbl))
    
   if onNYUserver then
            sys.sleep(2)
   end 

    do
        --return
    end
    if showDetailedOptions then
        print('\n=== Using the following data settings : ===');
        --table.sort(dataOpts_strs)
        print(dataOpts_strs)
    end
    


    -------------------------------

      
    if logNoisySet then
        io.write('Save Current script to log file? [n]')
        local ans = io.read("*line")
        if not (ans == 'y' or ans == 'Y') then
            logNoisySet = false
        end        
        
    end

    
    
    if logNoisySet then
           --logFile
        local date_time_str = string.gsub(string.gsub( os.date('%Y-%m-%d__%H-%M-%S', os.time()), '[ ]', '_' ), '[/:]', '-')
        local descrip = ''
        if task.descrip then
            descrip = '_' .. task.descrip
        end
        local logFileName = lettersData_dir .. 'log/logFile_' .. date_time_str .. '_' .. task.expName .. '_' .. task.modelName .. descrip .. '.txt' 
        logFile = assert( io.open(logFileName, 'w') )
        io.write('[Writing to log file ...]\n')

        
        
        logFile:write( table.tostring(string.format('\n\n\n ======================== %s ====================== \n', os.date('%x %X', os.time()))) ) 
        --logFile:write( '\n===Using the following networks options ===')
        --logFile:write( table.tostring(allNetworkOptions))
        logFile:write( '\n===Using the following network options ===\n')
        logFile:write( optionsTable2string(allNetworkOptions_tbl))
       if onNYUserver then
            sys.sleep(2)
       end 
    end



    
    
    
    if logNoisySet then
        
        logFile:write('\n\n')
        logFile:write('\n=== Using the following dataset options : ===\n');
        logFile:write( optionsTable2string(allDataOpts_tbl))
        
        if showDetailedOptions or true then
            logFile:write( '\n\n\n\n More Details: \n ===Using the following networks ===\n')
            logFile:write( table.tostring(allNetNames))
            
            logFile:write(  '\n===Using the following networks (full descriptions) ===\n')
            logFile:write( table.tostring(allNetNames_nice))
            
            logFile:write('\n===Using the following fonts : ===\n') 
            logFile:write(table.tostring( fontNames_use_strs))
        
            logFile:write('\n=== Using the following dataset settings : ===\n');
            logFile:write(table.tostring(dataOpts_strs))  
            logFile:write('\n\n\n\n')
        end        

        logFile:close()
        io.write('[Finished writing to log file ...]\n')
        return
    end



    local nTotal = 0;

    local results
    
    repeat 
        
        results = doTrainingBatch(allNetworks, allDataOpts, task.loadOpts, task.trainOpts)
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
    
    if task.taskFileName and (results.nSkipped == 0) then
        print('\n------------------------ Completed task! (' .. task.taskFileName .. ')------------------------\n')
        local completedTaskFileName = string.gsub(task.taskFileName, '.t7', '_completed.txt')
        if not string.find(completedTaskFileName, tasks_dir) then
            completedTaskFileName = completedTaskFileName .. tasks_dir
        end
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