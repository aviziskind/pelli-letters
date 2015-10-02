doNoisyTrainingBatch = function(allNetworks, all_LetterOpts)
        
    local redoResultsFiles = false
    local redoResultsFilesIfOld = true
    local redoResultsIfBefore =  1414730610  --10/30   -- 1410794504 -- 9/15 -- 1410444121 -- (9/11)  -- 1410111580 -- (9/7) 1409946083  --(9/5) -- 1406787530 -- (7/31)  1406742732 --(7/30)  	 1406226179 -- (7/23) -- 1404877451 -- (7/8) --  1404517899 --(7/4)        --  1402977793 --(6/15)      --[ 1401839863 -- (6/1)]  1400079231 -- 1394474541	   -- =os.time()
    --local redoResultsIfBefore =  1411018128 -- 9/18  -- 1410794504 -- 9/15 -- 1410444121 -- (9/11)  -- 1410111580 -- (9/7) 1409946083  --(9/5) -- 1406787530 -- (7/31)  1406742732 --(7/30)  	 1406226179 -- (7/23) -- 1404877451 -- (7/8) --  1404517899 --(7/4)        --  1402977793 --(6/15)      --[ 1401839863 -- (6/1)]  1400079231 -- 1394474541	   -- =os.time()

    local saveNetworkToMatfile = true and (not onLaptop or true) and (stimType ~= 'NoisyLettersTextureStats') -- and (NetType == 'ConvNet')

    local nLetterOpts = #all_LetterOpts
    --local nFontSets = #allFontNames
    local nNetworks = #allNetworks
    local nToDo_total = nLetterOpts * nNetworks 
    local glob_idx = 0
    
           
	local alsoTestOnTrainData = true
	local savePctCorrectOnIndivLetters = false
    local checkFontHeight = true
    local checkNetworkFits = true
    
    local doTestingNow = true
    local lockDataFilesWhenLoading = false
        
    local showResultsFromFiles = PRINT_RESULTS   -- if want to display results from networks that have already been trained
    local skipIfNotDone = SKIP_IF_NOT_DONE    -- if want to retest networks that have already been trained
	local onlyRetrainIfHavePretrainedNetworks = true
    
    local inputStatsTest, inputStatsTrain, inputStatsRetrain
    local train_trData, train_tsData
    local retrain_trData, retrain_tsData
    local test_trData, test_tsData
    local test_1let_tsData, test_2let_tsData  -- for crowding experiments
    local nSkipped = 0;
    local debugFileNames =  DEBUG_FILES
    
    local crowding_testMultipleLetters = true

    if expName == 'Crowding' and not crowding_testMultipleLetters then
        print('[ONLY DOING SINGLE LETTER TRAINING : SKIPPING MULTIPLE LETTER TESTS]');
    end

    
    local tbl_Log = {nCompletedAlready=0, nBeingDoneByOthers=0, nSkipped=0, nCompleted=0};
    
            
    -------------------------------------------------------------------------
    ----------------------- LOOP OVER LETTER OPTIONS ------------------------

    for opt_i, letterOpts_i in ipairs(all_LetterOpts) do        
        --LetterOpts = letterOpts_i 
        O = letterOpts_i
        
        local letterOpts = table.copy(letterOpts_i)
        local sizeStyle = letterOpts.sizeStyle
        local SNR_train = letterOpts.SNR_train
        local trialId = letterOpts.trialId or 1
        --local size_str = string.format('Size = %s. ', getFontSizeStr(sizeStyle))
        --local snr_train_str =  string.format('SNR-train = %s. ', abbrevList(SNR_train))
        local OriXY = letterOpts_i.OriXY or {Nx = 1, Ny = 1, Nori = 1}  -- **************
        local nPositions_opt = OriXY.Nx * OriXY.Ny * OriXY.Nori
        local trainOnIndividualPositions = letterOpts_i.trainOnIndividualPositions and nPositions_opt > 1
        local autoImageSize = true
        local imageSize = {0,0}
        if letterOpts.imageSize then
            autoImageSize = false
            imageSize = letterOpts.imageSize
        end
                    
        letterOpts.autoImageSize = autoImageSize
        letterOpts.imageSize = imageSize
       
        --local letterOpts_data_all, letterOpts_network_all,  = parseLetterOpts(letterOpts)
        LetterOpts = letterOpts
       
        
        local letterOpts_network         = table.copy(letterOpts)
        local letterOpts_network_retrain = table.copy(letterOpts)
        
        local letterOpts_data_train   = table.copy(letterOpts)               
            letterOpts_data_train.trainingFonts   = nil  -- dont add '_trfX' (=trainedWithFontsX)' tag to training data files, 
            letterOpts_data_train.trainingNoise   = nil  -- dont add '_trX' (=trainedWithX)' tag to training data files, 
            letterOpts_data_train.retrainFromLayer  = nil  -- dont add '_trfX' (=trainedWithFontsX)' tag to training data files, 
            letterOpts_data_train.trainOnIndividualPositions = nil  -- dont add '_trIP' (=trainedWithIndividualPositions)' tag to training data files,             
            letterOpts_data_train.retrainOnCombinedPositions = nil
            letterOpts_data_train.classifierForEachFont = nil -- don't add 'clsFnt' (=separate set of classes for each font) tag to training data files.
        local letterOpts_data_retrain = table.copy(letterOpts_data_train)
        local letterOpts_data_test    = table.copy(letterOpts_data_train)  
        

        local saveNetworkToMatfile_now = saveNetworkToMatfile
        
        local trainTestOnDifferentFonts = letterOpts.trainingFonts and not (letterOpts.trainingFonts == 'same') 
                                            and ( abbrevFontStyleNames(letterOpts.trainingFonts) ~= abbrevFontStyleNames(letterOpts.fontName)) 
        
        local trainTestOnDifferentNoise = letterOpts.trainingNoise and not (letterOpts.trainingNoise == 'same') 
                                            and (filterStr(letterOpts.trainingNoise, 1) ~= filterStr(letterOpts.noiseFilter, 1)) 
                                            and not string.find( abbrevFontStyleNames(letterOpts.fontName), 'SVHN') 
                                            
                    
        local trainTestOnDifferentWiggle = letterOpts.trainingWiggle and not isequal(letterOpts.trainingWiggle, 'same') 
                                                and not isequal(letterOpts.trainingWiggle, letterOpts.fontName.wiggles ) 
            
        local trainTestOnDifferentUncertainty = letterOpts.trainingOriXY and not isequal(letterOpts.trainingOriXY, 'same') 
                                                    and not isequal(letterOpts.trainingOriXY, letterOpts.OriXY) 
           
        local trainTestOnDifferentImageSize = letterOpts.trainingImageSize and not isequal(letterOpts.trainingImageSize, 'same')
                                            and not isequal(letterOpts.trainingImageSize, letterOpts.imageSize)
           
        local sameOptionsTrainTest = not (trainTestOnDifferentFonts or trainTestOnDifferentNoise or 
                                    trainTestOnDifferentWiggle or trainTestOnDifferentUncertainty or
                                    trainTestOnDifferentImageSize or 
                                    trainOnIndividualPositions)
                                
        local retrainSomeLayers = not sameOptionsTrainTest and 
            ( ((letterOpts.retrainFromLayer ~= nil) and (letterOpts.retrainFromLayer ~= '')) or trainOnIndividualPositions)
        
                                --[[
        local showIfDiff = true
        print('font', trainTestOnDifferentFonts)
        print('noise', trainTestOnDifferentNoise)
        print('wiggle', trainTestOnDifferentWiggle)
        print('uncertainty', trainTestOnDifferentUncertainty)
        print('wiggle', trainTestOnDifferentWiggle)
        print('same', sameOptionsTrainTest)
        print('retrainsomelayers', retrainSomeLayers)

        --]]
        Let = letterOpts
        if trainTestOnDifferentFonts then
                            
            local nClasses_trainFonts = getNumClassesForFont(letterOpts.trainingFonts, 1)
            local nClasses_testFonts  = getNumClassesForFont(letterOpts.fontName, 1)
            local needToRetrainClassifier = nClasses_trainFonts ~= nClasses_testFonts   -- eg train on SVHN (10 classes), retrain on letters (26 classes)  - to add: OR if training on numbers (svhn), testing on letters (Sloan10)
            
            if not retrainSomeLayers and needToRetrainClassifier then
                retrainSomeLayers = true
                letterOpts_network_retrain.retrainFromLayer = 'classifier'
            end
            
            -- correctly set the 'options' for the training data and the saved network (their 'noiseFilter' should be the same as the current 'trainingNoise')
            letterOpts_data_train.fontName = letterOpts.trainingFonts  -- correctly set fonts of training data
            
            --letterOpts_data_retrain.fontName = letterOpts.fontName
            --letterOpts_data_test.fontName = letterOpts.fontName

            letterOpts_network.fontName = letterOpts.trainingFonts  -- 
            letterOpts_network.trainingFonts = nil  -- dont add '_trfX' (=trainedWithFontsX)' tag to saved network, 
                
            if retrainSomeLayers then                                        
                letterOpts_network.retrainFromLayer = nil -- for regular network don't add 'retrained-with' tag.   
            else                
                --saveNetworkToMatfile_now = false -- this isn't a new network, so don't bother saving it.
            end
             -- otherwise, keep details about noisefilter in descriptor of which trained network we're using.                        
             --letterOpts_data_stats.trainingNoise = nil  -- so that loads stats wi
        end
        
        if trainTestOnDifferentNoise then
          
            -- correctly set the 'options' for the training data and the saved network (their 'noiseFilter' should be the same as the current 'trainingNoise')
            letterOpts_data_train.noiseFilter = letterOpts.trainingNoise  -- correctly set noiseFilter of training data

            letterOpts_network.noiseFilter = letterOpts.trainingNoise  -- correctly set noiseFilter of training network
            letterOpts_network.trainingNoise = nil  -- dont add '_trX' (=trainedWithX)' tag to saved network, 
                
            if retrainSomeLayers then                                        
                letterOpts_network.retrainFromLayer = nil -- for regular network don't add 'retrained-with' tag.   
            else
                --saveNetworkToMatfile_now = false -- this isn't a new network, so don't bother saving it.
            end
             -- otherwise, keep details about noisefilter in descriptor of which trained network we're using.                        
             --letterOpts_data_stats.trainingNoise = nil  -- so that loads stats wi
        
        end
    
        if trainTestOnDifferentWiggle then
          
            -- correctly set the 'options' for the training data and the saved network (their 'noiseFilter' should be the same as the current 'trainingNoise')
            letterOpts_data_train.fontName.wiggles = letterOpts.trainingWiggle  -- correctly set noiseFilter of training data
            
            
            --letterOpts_data_retrain.trainingWiggle = nil  -- correctly set noiseFilter of training data
            letterOpts_data_retrain.trainingWiggle = nil  -- correctly set noiseFilter of training data
            letterOpts_data_test.trainingWiggle = nil  -- correctly set noiseFilter of training data
            
            letterOpts_network.fontName.wiggles = letterOpts.trainingWiggle  -- correctly set noiseFilter of training network
            letterOpts_network.trainingWiggle = nil  -- dont add '_trX' (=trainedWithX)' tag to saved network, 
                
            if retrainSomeLayers then                                        
                letterOpts_network.retrainFromLayer = nil -- for regular network don't add 'retrained-with' tag.   
            else
                --saveNetworkToMatfile_now = false -- this isn't a new network, so don't bother saving it.
            end
             -- otherwise, keep details about noisefilter in descriptor of which trained network we're using.                        
             --letterOpts_data_stats.trainingNoise = nil  -- so that loads stats wi
        
        end
        Ln = letterOpts_network
        
        if trainTestOnDifferentUncertainty then
            
            sameOptionsTrainTest = false    
          
            -- correctly set the 'options' for the training data and the saved network (their 'noiseFilter' should be the same as the current 'trainingNoise')
            letterOpts_data_train.OriXY = letterOpts.trainingOriXY  -- correctly set noiseFilter of training data

            letterOpts_data_retrain.trainingOriXY = nil  -- correctly set noiseFilter of training data
            letterOpts_data_test.trainingOriXY = nil  -- dont add '_trX' (=trainedWithX)' tag to saved network, 

            letterOpts_network.OriXY = letterOpts.trainingOriXY  -- correctly set noiseFilter of training network
            letterOpts_network.trainingOriXY = nil  -- dont add '_trX' (=trainedWithX)' tag to saved network, 
                
            if retrainSomeLayers then                                        
                letterOpts_network.retrainFromLayer = nil -- for regular network don't add 'retrained-with' tag.   
            else
                --saveNetworkToMatfile_now = false -- this isn't a new network, so don't bother saving it.
            end
             -- otherwise, keep details about noisefilter in descriptor of which trained network we're using.                        
             --letterOpts_data_stats.trainingNoise = nil  -- so that loads stats wi
             
             
        end
        
        if trainTestOnDifferentImageSize then
          
            -- correctly set the 'options' for the training data and the saved network (their 'noiseFilter' should be the same as the current 'trainingNoise')
            letterOpts_data_train.imageSize = letterOpts.trainingImageSize -- correctly set image size of training data
            letterOpts_data_retrain.trainingImageSize = nil 
            letterOpts_data_test.trainingImageSize = nil

            letterOpts_network.imageSize = letterOpts.trainingImageSize  -- correctly set noiseFilter of training network
            letterOpts_network.trainingImageSize = nil  -- dont add '_trX' (=trainedWithX)' tag to saved network, 
                
            if retrainSomeLayers then                                        
                letterOpts_network.retrainFromLayer = nil -- for regular network don't add 'retrained-with' tag.   
            else
                --saveNetworkToMatfile_now = false -- this isn't a new network, so don't bother saving it.
            end
             -- otherwise, keep details about noisefilter in descriptor of which trained network we're using.                        
             --letterOpts_data_stats.trainingNoise = nil  -- so that loads stats wi
        
        end
        
        
        if trainOnIndividualPositions then
            --sameOptionsTrainTest = false
            letterOpts_data_train.trainOnIndividualPositions = false
            letterOpts_network.retrainOnCombinedPositions = false   -- for the first training, don't add 'retrained-with' tag.
            --letterOpts_network_retrain.retrainOnCombinedPositions = true
            
        end
        --letterOpts_data.trainingNoise = nil  -- always load the same band-filtered noise letter dataset, regardless of what we train on
                    
        letterOpts.nLetters = 1   -- even for crowding, base letterOpts is for training single letters
        local noisyLetterOpt_str = getLetterOptsStr(letterOpts)

        local fontNamesSet = letterOpts.fontName
        assert(type(fontNamesSet) == 'table')
            
        local fontNamesList = getFontList(fontNamesSet)
        local fontName_str_short, fontName_str_med, fontName_str_long = abbrevFontStyleNames(fontNamesSet)
        local nFontShapes = (getFontClassTable(fontNamesSet)).nFontShapes
                        
        local fontName1 = fontNamesList[1]
        local nFontsThisSet = #fontNamesList
        local doThisFont = true            

        if checkFontHeight and (fontName1 ~= 'SVHN') then
            local fontFits = true -- checkFontsFitInImage(fontNamesList, sizeStyle, imageSize)
            if not fontFits then
                doThisFont = false
                glob_idx = glob_idx + nNetworks
            end                    
        end                        

        if doThisFont then
            
            local trial_str = ''
            if trialId > 1 then
                trial_str = string.format('Trial #%d. ', trialId)
            end
            
            local font_str = 'Font = ' .. fontName_str_med .. '. '
            io.write(string.format('\n==== %s Stim: %s (%d/%d) \n', 
                trial_str, noisyLetterOpt_str, opt_i, nLetterOpts ))

            L = letterOpts_data_train
            Lr = letterOpts_data_retrain
            --print(letterOpts_data_train)
            --print(letterOpts_data_retrain)
            inputStatsTrain   = getDatafileStats(letterOpts_data_train)
            inputStatsRetrain = getDatafileStats(letterOpts_data_retrain)
            inputStatsTest    = getDatafileStats(letterOpts_data_test)
            
            local nMBPerFile = (inputStatsTrain.nSamples * inputStatsTrain.height * inputStatsTrain.width * 4)/(1024^2)
            local nSNRs_train = #letterOpts.SNR_train
            
            local allSNRs_test = letterOpts.SNR_test
            local nSNRs_test = #allSNRs_test
            
            --local trainFrac = loadOpts.trainFrac;
            --local testFrac = 1 - loadOpts.trainFrac;
            local trainFrac = 1;
            local testFrac = 1;
            
            
            local memRequired_train_MB = ( nFontShapes *  nSNRs_train * trainFrac ) * nMBPerFile
            local memRequired_retrain_MB = 0
            if retrainSomeLayers then
                memRequired_retrain_MB = ( nFontShapes * nSNRs_train * trainFrac ) * nMBPerFile
                --error('fix this')
            end
            local memRequired_test_MB = ( nFontShapes *  nSNRs_test * testFrac ) * nMBPerFile
            
            local memoryRequired_tot_MB = memRequired_train_MB + memRequired_retrain_MB + memRequired_test_MB;
            local memoryAvailable_MB = sys.memoryAvailable()
            
            local factor
            
            local haveEnoughMemory = memoryAvailable_MB / memoryRequired_tot_MB > 1.1;
            haveEnoughMemory  = true
            local memory_str = ''                
            if haveEnoughMemory then
                memory_str = string.format('[Enough memory: %.f MB memory required, which is less than half the memory available (%.1f MB)]', memoryRequired_tot_MB, memoryAvailable_MB)
            else
                memory_str = string.format('[Not enough memory : %.f MB memory required, more than half of that available (%.1f MB)]', memoryRequired_tot_MB, memoryAvailable_MB)
            end
            print(memory_str);
            
            train_trData = nil
            train_tsData = nil
             
            retrain_trData = nil
            retrain_tsData = nil
            
            test_trData = nil           -- non-crowding : training portion of test data (discarded)
            test_tsData = nil           -- non-crowding : testing portion of test data
            
            test_1let_tsData = nil      -- crowding : test on 1 letter
            test_2let_tsData = nil      -- crowding : test on 2 letters
            
                        
            
            if haveEnoughMemory then
                
                -------------------------------------------------------------------
                ----------------------- LOOP OVER NETWORKS ------------------------
                
                for net_i, networkOpts_i in ipairs(allNetworks) do                        
                    local pct_correct_vs_snr_total       = torch.Tensor(nFontsThisSet, nSNRs_test):zero()
                    local pct_correct_vs_snr_eachLetter  = torch.Tensor(nFontsThisSet, nSNRs_test, inputStatsTest.nClasses):zero()
                    
                    local pct_correct_vs_snr_total_train = torch.Tensor(nFontsThisSet, nSNRs_test):zero()
                    local pct_correct_vs_snr_eachLetter_train = torch.Tensor(nFontsThisSet, nSNRs_test, inputStatsTrain.nClasses):zero()
                    
                    local pct_correct_vs_snr_any    = torch.Tensor(nSNRs_test):zero()  -- (for crowding test)
                    local pct_correct_vs_snr_target = torch.Tensor(nSNRs_test):zero()  -- (for crowding test)
                    
                    local doThisNetwork = true
                    glob_idx = glob_idx + 1                        
                    
                    if checkNetworkFits and (networkOpts_i.netType == 'ConvNet') then
                        local networkFits = checkNetworkFitsInImage(networkOpts_i, imageSize)
                        if not networkFits then
                            doThisNetwork = false
                        end                    
                    end                        
                      
                    if doThisNetwork then
                        
                        
                        local networkStr, networkStr_nice = getNetworkStr(networkOpts_i)
                        io.write(string.format('  ----- [%d / %d (%.1f%%)]    Network # %d / %d : %s :   \n    Params : %s\n', 
                                glob_idx,nToDo_total,glob_idx/nToDo_total*100,  net_i, nNetworks, networkStr, networkStr_nice))
                        
                        --print(networkOpts_i);
                        do
                        --error('!')
                        end
                        expSubtitle = getExpSubtitle(letterOpts, networkOpts_i, trialId)
                        if sameOptionsTrainTest then
                            expSubtitle_network = expSubtitle
                        else
                            
                            expSubtitle_network = getExpSubtitle(letterOpts_network, networkOpts_i, trialId)
                            
                            if retrainSomeLayers then
                                expSubtitle_network_retrain = getExpSubtitle(letterOpts_network_retrain, networkOpts_i, trialId)
                            end
                            
                        end
                        
                        local skipNow = skipIfNotDone
                        local skipReason = 'not done'
                        
                        -- 1. files (results/network files) that are present if have completed this experiment.
                        expFullTitle = stimType .. '_' .. expSubtitle
                        --expFullTitle_network = stimType .. '_' .. expSubtitle_network
                        expFullTitle_network = expSubtitle_network   -- don't add stimType as prefix!
                        
                        local results_dir_main = paths.dirname(results_dir)  .. '/'     -- e.g. /../Complexity/
                        local preferred_subdir = paths.basename(results_dir) .. '/'     -- e.g.                NoisyLetters/
                        assert(paths.basename(results_dir) == stimType)
                        
                        local results_filename_base = expFullTitle .. '.mat'
                        local resultsFileExists, results_filename = fileExistsInSisterSubdirs(
                            results_dir_main, preferred_subdir, results_filename_base)
                        
                        if debugFileNames then
                            if resultsFileExists then
                                print('  ====> Results file exists :', results_filename, os.date('%x %X', paths.filedate(results_filename) ) )
                            else
                                print('  ====> Results file does not exist !', results_filename_base)
                            end
                        end
                        
                        --local results_filename = results_dir .. results_filename_base
                        --local resultsFileExists = paths.filep(results_filename)
                        
                        
                        
                        
                        -- check network file
                        local training_dir_main = paths.dirname(training_dir) .. '/'
                        local network_filename_base = expSubtitle .. '.mat'
                        --local network_matfile = training_dir .. expSubtitle .. '.mat'
                        Network_filename_base = network_filename_base
                        --local networkFileExists = paths.filep(network_matfile)
                        local networkFileExists, network_matfile = fileExistsInSisterSubdirs(
                            training_dir_main, preferred_subdir, network_filename_base)
                        
                        
                        if debugFileNames then
                            if networkFileExists then
                                print('   ====> Network file exists :', network_matfile, os.date('%x %X', paths.filedate(network_matfile) ) )
                            else
                                print('   ====> Network file does not exist!', network_filename_base)
                            end
                        end
                        --paths.filep(network_matfile)
                                                    
                        local resultsFileTooOld = resultsFileExists and redoResultsFilesIfOld and 
                            fileOlderThan(results_filename, redoResultsIfBefore)
                        
                        local networkFileTooOld = networkFileExists and redoResultsFilesIfOld and 
                            fileOlderThan(network_matfile, redoResultsIfBefore)
                        
                        
                                
                        -- multi-letter results for crowding experiment        
                        local haveAllFiles_2let = true
                        local allMultiLetterTestOpts = letterOpts.allMultiLetterTestOpts
                        
                        local allMultiLetterResultsFileNames = {}
                        if letterOpts.expName == 'Crowding' and allMultiLetterTestOpts and crowding_testMultipleLetters then
                            for i,optMultiLet in ipairs(allMultiLetterTestOpts) do
                                local expSubtitle_2let = getExpSubtitle(optMultiLet, networkOpts_i, trialId)
                                local results_filename_base_2let = stimType .. '_' .. expSubtitle_2let .. '.mat'
                                
                                local resultsFileExists_2let, results_filename_2let = fileExistsInSisterSubdirs(results_dir_main, preferred_subdir, results_filename_base_2let)
                           
                           
                                allMultiLetterResultsFileNames[i] = results_filename_2let
                                --local results_filename_2let = results_dir .. results_filename_base_2let
                                --local resultsFileExists_2let = paths.filep(results_filename_2let)
                                local resultsFileTooOld_2let = resultsFileExists_2let and redoResultsFilesIfOld and 
                                    fileOlderThan(results_filename_2let, redoResultsIfBefore)
                                                                        
                                if not (resultsFileExists_2let and not resultsFileTooOld_2let) then
                                    local showIfHave = false;
                                    if haveAllFiles_2let then   -- first time we find, print this message
                                        io.write(string.format('Dont have this file (and maybe others:)\n   %s \n ... have to do this experiment... \n', basename(results_filename_base_2let)))
                                    elseif showIfHave then
                                        io.write(string.format('  Have %s\n', basename(results_filename_base_2let)))
                                    end
                                    haveAllFiles_2let = false
                                else
                                    --io.write(string.format('%d/%d Have %s\n', i, #allMultiLetOpt, results_filename_base_2let))
                                end
                            
                            end
                        end
                        
                        
                        
                        
                        local haveAllExperimentFiles = (resultsFileExists and (not resultsFileTooOld or not doTestingNow)) and 
                                                       ((networkFileExists and not networkFileTooOld) or not saveNetworkToMatfile_now) and
                                                       haveAllFiles_2let
                        
                        local pretrainedNetworkFileExists, pretrainedNetwork_filename, foldersChecked
                        
                        local extraLocksToPlace = {}
                        if not sameOptionsTrainTest then
                            -- 2. files that are prerequisites (ie. pretrained networks). 
                                -- if don't have the results file ==>, skip if onlyRetrainIfHavePretrainedNetworks = true
                                -- if don't have results file, and lock is placed on a pretraining experiment 
                                --   (being pretrained by another process), then skip.

                            
                            --local pretrainedNetwork_file = training_dir .. expSubtitle .. '.t7'
                            --local pretrainedNetworkFileExists = paths.filep(pretrainedNetwork_file)
                            --local pretrainedResults_file = training_dir .. expSubtitle .. '.t7'
                            --local pretrainedResultsFileExists = paths.filep(pretrainedNetwork_file)
                            local checkForPretrainedResults = false
                            local pretrainedResults_filename_base = expFullTitle_network .. '.mat'
                            
                            
                            --[[
                            local pretrainedResultsFileExists, pretrainedNetworkFileExists
                            if checkForPretrainedResults then
                                local pretrainedResultsFileExists, pretrainedResults_filename = fileExistsInSisterSubdirs(
                                    results_dir_main, preferred_subdir, pretrainedResults_filename_base)
                        
                            end
                            --]]
                            local pretrainedNetwork_filename_base = expFullTitle_network .. '.mat'
                            
                            pretrainedNetworkFileExists, pretrainedNetwork_filename, foldersChecked = fileExistsInSisterSubdirs(
                                training_dir_main, preferred_subdir, pretrainedNetwork_filename_base)
                        
                            if not pretrainedNetworkFileExists and onlyRetrainIfHavePretrainedNetworks then
                                print('No pretrained network:', pretrainedResults_filename_base)
                                if debugFileNames then
                                    print(' ==>Checked in : ');
                                    print(foldersChecked);
                                end
                                skipNow = true
                                skipReason = 'Pretrained network not present'
                                nSkipped = nSkipped + 1
                            else
                                if debugFileNames then
                                    print('Found pretrained network :', pretrainedNetwork_filename)
                                end
                                local isAlreadyLocked, otherProcessID = lock.isLocked(expFullTitle_network)
                                if isAlreadyLocked then
                                    skipNow = true
                                    skipReason = string.format('Another process [%s] is doing the pretraining', otherProcessID )
                                else
                                    table.insert(extraLocksToPlace, expFullTitle_network)
                                end
                            end
                                
                        end
                       
                                                        
                        if haveAllExperimentFiles and not redoResultsFiles then
                                                            

                            io.write(string.format('      =>Already completed : %s\n', results_filename_base))
                            tbl_Log.nCompletedAlready = tbl_Log.nCompletedAlready + 1;
                            
                            if showResultsFromFiles then
                                
                                io.write('*** Psychometric curves for all fonts *** ')
                                
                                local S_mat = mattorch.load(results_filename)
                                local allFontNamesInFile = string.split( string.char(unpack(torch.toTable(S_mat.allFontNames))), ',')
                                local allSNRs_test_inFile = torch.toTable( S_mat.allSNRs:float() )                                
                                printPsychCurves(allFontNamesInFile, allSNRs_test_inFile, 
                                        S_mat.pct_correct_vs_snr_total, S_mat.pct_correct_vs_snr_total_train)
                                                               
                                
                            end
                            
                            --error('!')
                                
                        else
                        
                        -- if not resultsFileExists or redoResultsFiles or resultsFileTooOld then
                            
                            local gotLock, ID_of_otherProcess, lock_of_otherProcess
                            local tryDoThisProcess = not skipNow
                            if tryDoThisProcess then
                                if #extraLocksToPlace == 0 or true then
                                    gotLock, ID_of_otherProcess = lock.createLock(expFullTitle)
                                        lock_of_otherProcess = expSubtitle
                                else
                                    gotLock, ID_of_otherProcess, lock_of_otherProcess = lock.createMultipleLocks(
                                        table.merge(extraLocksToPlace, {expFullTitle}) )
                                end
                            end
                            
                            if not gotLock then 
                                if tryDoThisProcess then
                                    io.write(string.format(' [Process %s is already doing %s]\n', ID_of_otherProcess, lock_of_otherProcess))
                                    tbl_Log.nBeingDoneByOthers = tbl_Log.nBeingDoneByOthers + 1;
                                else
                                    
                                    io.write(string.format('Skipping (#%d) [ %s ]..\n', nSkipped, skipReason));
                                    tbl_Log.nSkipped = tbl_Log.nSkipped + 1;
                                end
                                
                            else
                                                    
                                print('Experiment subtitle : ' .. expSubtitle)
                                print(string.format('Started at %s', os.date('%x %X', os.time()) ))
                                local fontClassTable = nil
                                if letterOpts.classifierForEachFont then
                                    fontClassTable = getFontClassTable(fontNamesList)
                                end
                                
                                --FontClassTable = fontClassTable
                                
                             
                                        
                                if not train_trData then  -- load training/testing data for this font if don't have already
                                    
                                    if letterOpts.doTextureStatistics or letterOpts.doOverFeat then 
                                        loadOpts.normalizeInputs = true 
                                    end 

                                    ------------------------
                                    ---- 1. TRAINING DATA
                                    loadOpts_train = table.copy(loadOpts)
                                    loadOpts_train.fontClassTable = fontClassTable
                                    loadOpts_train.lockDataFiles = lockDataFilesWhenLoading
                                    loadOpts_train.separateFontsAndSNR = false
                                    letterOpts_data_train.allSNRs = SNR_train
                                    
                                    print('Loading TRAINING data (train & cross-validation) data ... ')     
                                    train_trData, train_tsData = loadDatafile(letterOpts_data_train, loadOpts_train)  
                                    --Train_trData = train_trData
                                    --InputStatsTrain = inputStatsTrain
                                    assertSameDataStats(train_trData, inputStatsTrain, fontClassTable)

                                    --Train_trData, Train_tsData = train_trData, train_tsData
                                    
                                    ------------------------
                                    ---- 2. RETRAINING DATA
                                    letterOpts_data_retrain.allSNRs = SNR_train
                                    if retrainSomeLayers then
                                        print('Loading RE-TRAINING data ... ')           
                                        retrain_trData, retrain_tsData = loadDatafile(letterOpts_data_retrain, loadOpts_train)  
                                        assertSameDataStats(retrain_trData, inputStatsRetrain, fontClassTable)
                                    end
                                    
                                    
                                    collectgarbage('collect')  -- remove unused training/test 
                                    collectgarbage('collect')  -- data
                                    
                                    ------------------------
                                    ---- 3. TEST DATA
                                    if letterOpts.expName == 'Crowding' then
                                        test_1let_tsData = {}
                                        test_2let_tsData = {}
                            
                                        loadOpts_test_1let = table.copy(loadOpts)
                                        loadOpts_test_1let.loadTrainingData = alsoTestOnTrainData  -- if want to record performance (when saving results to file)
                                        loadOpts_test_1let.lockDataFiles = lockDataFilesWhenLoading
                                        loadOpts_test_1let.separateFontsAndSNR = true
                                        letterOpts_data_test.allSNRs = allSNRs_test
                                        
                                        loadOpts_test_2let = table.copy(loadOpts_test_1let)
                                        loadOpts_test_1let.loadTrainingData = false
                                        loadOpts_test_2let.trainFrac = 0
                                        
                                        if doTestingNow then
                                            print('Loading 1-letter TESTING data  ... ')
                                            test_trData, test_tsData = loadDatafile(letterOpts_data_test, loadOpts_test_1let)
                                            if crowding_testMultipleLetters then                                        
                                                print('Loading MULTIPLE-letter TESTING data  ... ')
                                                
                                                test_2let_tsData = {}
                                                for opt_j, multLetOpt in ipairs(letterOpts.allMultiLetterTestOpts) do 
                                                    local multLetOpt_data = table.copy(multLetOpt)
                                                    multLetOpt_data.trainTargetPosition = nil  -- don't append 'trained on X' to data file name
                                                    _, test_2let_tsData[opt_j] = loadDatafile(multLetOpt_data, loadOpts_test_2let)
                                                    
                                                    assertSameDataStats(test_2let_tsData[opt_j][1][1], inputStatsTest, fontClassTable)
                                                end           
                                                
                                            end
                                        end
                                                    
                                               
                                                    
                                        collectgarbage('collect')  -- train/test data can be very big -- after done with one font, 
                                        collectgarbage('collect')  -- clear memory for next font data            
                                    
                                    else
                                        test_trData = {}
                                        test_tsData = {}
                                        loadOpts_test = table.copy(loadOpts_train)
                                        loadOpts_test.loadTrainingData = alsoTestOnTrainData  -- if want to record performance (when saving results to file)
                                        loadOpts_test.lockDataFiles = false
                                        loadOpts_test.separateFontsAndSNR = true
                                        letterOpts_data_test.allSNRs = allSNRs_test
                                        
                                        if doTestingNow then                                        
                                            print('Loading TESTING data (train & test) data ... ')
                                            test_trData, test_tsData = loadDatafile(letterOpts_data_test, loadOpts_test)
                                        end
                                                                        
                                        InputStatsTest = inputStatsTest
                                        Train_trData = train_trData
                                        assertSameDataStats(test_trData[1][1], inputStatsTest, fontClassTable)
                                    end
                                    

                                end
                                
                                TrainData = trainData
                                InputStatsTrain = inputStatsTrain
                                
                                local model_struct = generateModel(inputStatsTrain, networkOpts_i, letterOpts)
                                local model_struct_pretrained 
                                
                                --Model_struct = model_struct
                                
                                MS = model_struct
                                trainOpts.trainConfig = networkOpts_i.trainConfig
                                 
                                 --[[
                                    local getBestSolution = false
                                    if getBestSolution then
                                        print('Cheating and Getting optimal solution!')
                                        new_wgts, new_bias = getBestWeightsAndOffset(train_trData.inputMatrix, train_trData.labels)
                                        
                                        torch.copyTensorValues( new_bias, model_struct.model.modules[2].modules[1].bias )
                                        torch.copyTensorValues( new_wgts, model_struct.model.modules[2].modules[1].weight )
                                        --print(model_struct.model.modules[2].modules[1].bias)
                                        
                                    end
                                    --]]
                                
                                --error('!')
                                
                                if not retrainSomeLayers then   -- standard training paradigm
                                    io.write(string.format('Standard training (One training set) \n '))
                                    trainOpts.trainingFileBase = training_dir .. expSubtitle_network
                                    
                                    model_struct = trainModel(model_struct, train_trData, train_tsData, trainOpts)       
                                  
                                    MS = model_struct
                                    
                                elseif retrainSomeLayers and not trainOnIndividualPositions then
                                   --- train/retrain on different datasets
                                    -- train original network on training data 
                                    io.write(string.format('Training on one dataset, then retraining on a different dataset\n'))
                                    
                                    local trainingFileBase = training_dir .. expSubtitle_network
                                    if pretrainedNetwork_filename then
                                        print('Again, using pretrained network : ', pretrainedNetwork_filename)
                                        trainingFileBase = paths.removeFileExtension(pretrainedNetwork_filename)
                                    end
                                    
                                    trainOpts.trainingFileBase = trainingFileBase
                                    
                                    model_struct = trainModel(model_struct, train_trData, train_tsData, trainOpts)
                                    local model_struct_pretrained = model_struct
                                    print('  ==> Pretrained model, first conv value = ',
                                        firstConvolutionalWeightValue(model_struct_pretrained))
                                    
                                    Train_trData = train_trData
                                    Retrain_trData = retrain_trData
                                    M = model_struct
                                    local trainImageSize = {train_trData.height, train_trData.width}
                                    local retrainImageSize = {retrain_trData.height, retrain_trData.width}
                                    if not isequal(trainImageSize, retrainImageSize) then 
                                        io.write(string.format(
                                                '\n\nTraining data was %dx%d, but retraining data is %dx%d. Resizing the network\n' ..
                                                '(Preserving only the convolutional filters)\n', 
                                                trainImageSize[1], trainImageSize[2], retrainImageSize[1], retrainImageSize[2]))
                                        local model_struct_newSize = generateModel(inputStatsRetrain, networkOpts_i, letterOpts)
                                        
                                        copyConvolutionalFiltersToNetwork(model_struct, model_struct_newSize)
                                        assert ( areConvolutionalWeightsTheSame(model_struct, model_struct_newSize) )
                                        
                                        model_struct = model_struct_newSize
                                       
                                       
                                        print('  ==> First conv value = ', firstConvolutionalWeightValue(model_struct))
                                    end
                                   -- error('stop!')
                                   

                                    if train_trData.nClasses ~= retrain_trData.nClasses then
                                        model_struct = replaceClassifierLayer(model_struct, retrain_trData.nClasses)
                                    end
                                    
                                    -- split network and retrain upper layers on retraining data
                                    model_struct = splitModelAfterLayer(model_struct, letterOpts_network_retrain.retrainFromLayer)
                                                                           

                                    -- retrain network
                                    retrainOpts = table.copy(trainOpts)
                                    retrainOpts.trainingFileBase = training_dir .. expSubtitle_network_retrain
                                    retrainOpts.freezeFeatures = true
                                    retrainOpts.prevTrainingDate = model_struct.trainingDate
                                    --retrainOpts.redoTraining = true
                                    --print(os.date('%x %X', retrainOpts.prevTrainingDate))
                                    model_struct = trainModel(model_struct, retrain_trData, retrain_tsData, retrainOpts)
                                    
                                    --local sameAfterRetrain, val1, val2 = areConvolutionalWeightsTheSame(model_struct_pretrained, model_struct)
                                    --print('After retrain, same filters = ', sameAfterRetrain, val1, val2);
                                    --print('After retrain, first conv value = ', firstConvolutionalWeightValue(model_struct))
                                     assert(areConvolutionalWeightsTheSame(model_struct_pretrained, model_struct) )
                                      print('  ==> After retraining, first conv value = ', firstConvolutionalWeightValue(model_struct))
                                    
                                elseif trainOnIndividualPositions then   -- train/retrain on the same dataset using different criteria
                                    io.write(string.format('Training on Individual positions, testing on combined positions. \n '))
                                    trainOpts.trainingFileBase = training_dir .. expSubtitle_network
                                    
                                    -- train model to categorize each position / letter as separate categories
                                    model_struct.model = model_struct.model_indiv_pos
                                    trainOpts.trainOnIndividualPositions = true
                                    model_struct = trainModel(model_struct, train_trData, train_tsData, trainOpts)
                                    
                                    
                                    local doIntermediateTesting = true
                                    if doIntermediateTesting then
                                        local testOpts = {batchSize = trainOpts.BATCH_SIZE, savePctCorrectOnIndivLetters=savePctCorrectOnIndivLetters, printResults = true, returnPctCorrect = true}
                                        testModelOnFontsSNRs(model_struct, fontNamesList, allSNRs_test, test_tsData, nil, testOpts)                                    
                                    end
                                        
                                    -- now select the model that combines the output from the individual position classifiers to combined classifiers.
                                    model_struct.model = model_struct.model_indiv_pos_combined
                                    
                                    -- resplit network so that just the top-most classifier is trained
                                    model_struct = splitModelAfterLayer(model_struct, -3)  -- last 3 layers: -1: logSoftMax, -2: linear to 26 outputs. -3: layer before that one

                                   
                                    
                                    local useFixedTopLayer = true
                                    Ms = model_struct;
                                    if useFixedTopLayer then
                                        fixTopLayer( model_struct.classifier.modules[1], inputStatsTest.nClasses, inputStatsTest.nPositions )
                                    else
                                        retrainOpts = table.copy(trainOpts)
                                        retrainOpts.trainingFileBase = training_dir .. expSubtitle_network_retrain
                                        retrainOpts.freezeFeatures = true
                                        retrainOpts.trainOnIndividualPositions = false -- now, are retraining to classify the letters, irrespective of position.
                                        
                                        model_struct = trainModel(model_struct, retrain_trData, retrain_tsData, retrainOpts)
                                    end
                                    
                                end
                                    
                                --[[
                                Model_struct = model_struct
                                M = model_struct
                                --errRate = testModel(model_struct, train_tsData)
                                Test_trData = test_trData
                                Test_tsData = test_tsData
                               
                                print(model_struct)
                                do
                                    return
                                end
                                --]]
                                
                               
                                if saveNetworkToMatfile_now then
                                    print('Saving network to ' .. basename(network_matfile, 3))
                                    local model_matFormat = convertNetworkToMatlabFormat(model_struct.model)
                                    checkFolderExists(network_matfile)
                                    mattorch.save(network_matfile, model_matFormat)
                                end
                               
                                if model_struct_pretrained then 
                                    assert ( areConvolutionalWeightsTheSame(model_struct_pretrained, model_struct) )
                                end
                                    
                               
                                Test_tsData = test_tsData
                                if doTestingNow then
                                    
                                    -- if NOT crowding experiment :
                                    if letterOpts.expName ~= 'Crowding' then
                                        
                                        local testOpts = {batchSize = trainOpts.BATCH_SIZE, nClasses = inputStatsTest.nClasses, 
                                            savePctCorrectOnIndivLetters = savePctCorrectOnIndivLetters, 
                                            printResults = true, returnPctCorrect = true}
                                        local allSNRs_use = iff(fontName1 == 'SVHN', {0}, allSNRs_test)
                                        
                                        pct_correct_vs_snr_total, pct_correct_vs_snr_eachLetter,   pct_correct_vs_snr_total_train, pct_correct_vs_snr_eachLetter_train = 
                                            testModelOnFontsSNRs(model_struct, fontNamesList, allSNRs_use, test_tsData, test_trData, testOpts)
                                                                                                                        
                                        
                                        local fontNames_cslist = string.toTensor( table.concat(fontNamesList, ',') )
                                        local var_list = {allFontNames       = fontNames_cslist:double(), 
                                                          allSNRs            = torch.DoubleTensor(allSNRs_test), 
                                                          pct_correct_vs_snr_total      = pct_correct_vs_snr_total:double(),
                                                          pct_correct_vs_snr_eachLetter = pct_correct_vs_snr_eachLetter:double(),
                                                          allSNRs_train      =  torch.DoubleTensor(SNR_train),
                                                          pct_correct_vs_snr_total_train = pct_correct_vs_snr_total_train:double(),
                                                          pct_correct_vs_snr_eachLetter_train = pct_correct_vs_snr_eachLetter_train:double(),
                                                          }
                                        
                                        --print('full name = ', results_filename)
                                        
                                        print('Saving results to ' .. basename(results_filename,3))
                                        checkFolderExists(results_filename)                                    
                                        mattorch.save(results_filename, var_list)
                                         
                                        
                                    elseif letterOpts.expName == 'Crowding' then                                        
                                        
                                        -- 1. first test on 1 letter
                                        io.write(string.format('*** Testing on font = %s, 1 letter \n', fontName1))   -- '  SNR = '
                        
                                        local testOpts = {batchSize = trainOpts.BATCH_SIZE, nClasses = inputStats.nClasses, 
                                            savePctCorrectOnIndivLetters = savePctCorrectOnIndivLetters, 
                                            printResults = true, printInOneLine = true, returnPctCorrect = true, reshapeToVector = true}
                                        
                                        pct_correct_vs_snr_any = testModelOnFontsSNRs(model_struct, fontNamesList, allSNRs_test, {test_1let_tsData}, nil, testOpts)
                                                                                    
                                        local var_list_1let = {pct_correct_vs_snr_total    = pct_correct_vs_snr_any:double(),    -- total = "all Letters"
                                                               allSNRs                     = torch.DoubleTensor({allSNRs_test})} 
                                                                    
                                        print('  => Saved to ' .. basename(results_filename, 2))
                                        
                                        checkFolderExists( results_filename )
                                        mattorch.save(results_filename, var_list_1let)
                                        
                                                
                                        ---2. TEST Model on multiple letters (all SNRs)
                                        if crowding_testMultipleLetters then
                                            io.write(string.format('*** Testing on multiple letters: \n'))
                                                      
                                            for opt_j, multLetOpt in ipairs(allMultiLetOpt) do 
                                                
                                                local prefix_str_a = string.format('N=%d. Spc=%2d. DNR=%.1f : pCorrA=', multLetOpt.nLetters, multLetOpt.distractorSpacing, multLetOpt.logDNR)
                                                local prefix_str_t = string.rep(' ', string.find(prefix_str_a, 'pCorr')-1) .. 'pCorrT='                        
                                        
                                                local testOpts_any = table.copy(testOpts)
                                                testOpts_any.multipleLabels = true
                                                testOpts_any.doSNRheader = (opt_j == 1)
                                                testOpts_any.prefix = prefix_str_a
                                                
                                                local testOpts_target = table.copy(testOpts)
                                                testOpts_target.doSNRheader = false                                                                                        
                                                testOpts_target.prefix = prefix_str_t
                                                                                          
                                                pct_correct_vs_snr_any    = testModelOnFontsSNRs(model_struct, fontNamesList, allSNRs_test, {test_2let_tsData[opt_j]}, nil, testOpts_any)
                                                pct_correct_vs_snr_target = testModelOnFontsSNRs(model_struct, fontNamesList, allSNRs_test, {test_2let_tsData[opt_j]}, nil, testOpts_target)
                                        
                                                local var_list_nlet = {pct_correct_vs_snr_total        = pct_correct_vs_snr_any:double(), 
                                                                       pct_correct_vs_snr_total_target = pct_correct_vs_snr_target:double(), 
                                                                       allSNRs                         = torch.DoubleTensor({allSNRs_test})}
                                        
                                                local expSubtitle_2let = getExpSubtitle(multLetOpt, networkOpts_i, trial_i)
                                                local results_filename_base_2let = stimType .. '_' .. expSubtitle_2let .. '.mat'
                                                local results_filename_2let = results_dir .. results_filename_base_2let

                                                print('    => Saved to ' .. basename(allMultiLetterResultsFileNames[opt_j], 2) ) --  basename(results_filename_2let, 2))
                                                checkFolderExists(allMultiLetterResultsFileNames[opt_j])
                                                mattorch.save(allMultiLetterResultsFileNames[opt_j], var_list_nlet)
                                                    
                                            end
                                        end 
                                        
                                    
                                        print('Successfully saved files')
                                        
                                    end   -- if Crowding vs not Crowding
                                    
                                    tbl_Log.nCompleted = tbl_Log.nCompleted + 1;
                                end -- if doTestingNow
                            
                                lock.removeLock(expFullTitle)
                            end -- if gotLock
                        
                        end  -- if don't have results file
                    
                    end --if doing this network (if network fits in image)
                    
                end -- loop over networks  (nNetworks)
                
                collectgarbage('collect')  -- train/test data can be very big -- after done with one font, 
                collectgarbage('collect')  -- clear memory for next font data
            
            end
        end  --if doing this font (if font fits)
                        
    
    end -- loop over all_LetterOpts
            
                

    return tbl_Log
end



function assertSameDataStats(trainData, stats, fontClassTable)
    Tr = trainData
    St = stats
    assert(trainData.nInputs  == stats.nInputs)
    if not fontClassTable then
        assert(trainData.nClasses == stats.nClasses)
    end
    assert(trainData.height   == stats.height)
    assert(trainData.width    == stats.width)
    
end




function printPsychCurves(allFontNames, allSNRs_test, pct_correct_vs_font_snr, pct_correct_vs_font_snr_train)

    local skipSNRheaders = (#allFontNames == 1) and allFontNames[1] == 'SVHN'
    if not skipSNRheaders then
        io.write('\n                   SNR = ')

        for si, snr in ipairs(allSNRs_test) do
            io.write(string.format('  %4.1f  | ', snr))
        end
    end
    io.write('\n')

    for fi, fontName_i in ipairs(allFontNames) do
        io.write(string.format('FontName = %12s ', fontName_i))
        local allSNRs_test_i = allSNRs_test 
        if fontName_i == 'SVHN' then
            allSNRs_test_i = {0}
        end
        
        for si = 1,#allSNRs_test_i do       
            io.write(string.format(' %5.1f %% |', pct_correct_vs_font_snr[fi][si]))        
        end
        
        if #allSNRs_test_i > 1 then
            local log_snr_th_estimate = estimateSNRthreshold(allSNRs_test, pct_correct_vs_font_snr[fi]:float())
            if log_snr_th_estimate then
                io.write(string.format('  ==> Th: %.1f.  Log th: %.2f', 10^log_snr_th_estimate, log_snr_th_estimate ))
            end
        end
        io.write('\n')
        
        if pct_correct_vs_font_snr_train then           
            io.write('         [Training Set]:')
            for si = 1,#allSNRs_test_i do       
                io.write(string.format(' %5.1f %% |', pct_correct_vs_font_snr_train[fi][si]))        
            end
            
        end
        io.write('\n')
        
    end

    io.write('\n')
    
end



testModelOnFontsSNRs = function (model_struct, fontNames, allSNRs_test, testData, trainData, testOpts)
    local nFonts = #fontNames
    local nSNRs_test = #allSNRs_test
    local multipleFonts = nFonts > 1
    
    local alsoDoTrainData = trainData ~= nil
    local printResults = testOpts.printResults or true
    local reshapeToVector = testOpts.reshapeToVector or false
    
    local printInOneLine = testOpts.printInOneLine or true
    local doSNRheader = testOpts.doSNRheader or ((testOpts.doSNRheader == nil) and true)
    
    local snr_header_prefix = ' SNR= '
    local pCorr_prefix_str = testOpts.prefix or ' pCorr='

    local pct_correct_vs_snr_total,       pct_correct_vs_snr_eachLetter,
          pct_correct_vs_snr_total_train, pct_correct_vs_snr_eachLetter_train
    
    pct_correct_vs_snr_total = torch.Tensor(nFonts, nSNRs_test):zero()
    --if testOpts.savePctCorrectOnIndivLetters then
        pct_correct_vs_snr_eachLetter  = torch.Tensor(nFonts, nSNRs_test, testOpts.nClasses):zero()
    --end
    if alsoDoTrainData then
        pct_correct_vs_snr_total_train = torch.Tensor(nFonts, nSNRs_test):zero()
        --if testOpts.savePctCorrectOnIndivLetters then
            pct_correct_vs_snr_eachLetter_train = torch.Tensor(nFonts, nSNRs_test, testOpts.nClasses):zero()
        --end
    end

    local pct_correct_vs_snr_eachLetter_i, pct_correct_vs_snr_eachLetter_train_i
    
    local gapBeforeSNRHeaderForFontName = string.rep(' ', #pCorr_prefix_str - #snr_header_prefix + 1);
    if multipleFonts then
        gapBeforeSNRHeaderForFontName = gapBeforeSNRHeaderForFontName .. string.rep(' ', 23)
    end
    
    for fi, fontName_i in ipairs(fontNames) do
        
        if printResults and printInOneLine then  -- print out header
            if doSNRheader then
                io.write(string.format('%s%s', gapBeforeSNRHeaderForFontName, snr_header_prefix))
                for si, snr in ipairs(allSNRs_test) do
                    io.write(string.format('  %4.1f  | ', snr))
                end
                io.write('\n')
            end

            if multipleFonts then
                io.write(string.format('FontName = %12s ', fontName_i))
            end
            io.write( pCorr_prefix_str )
        end
        
        
        for si,snr_test in ipairs(allSNRs_test) do
            
            if printResults and not printInOneLine then
                io.write(string.format(' -- testing on font = %s, snr = %.1f ...  ', fontName_i, snr_test))
            end
            
            pct_correct_vs_snr_total[fi][si], pct_correct_vs_snr_eachLetter_i = testModel(model_struct, testData[fi][si], testOpts)
            if testOpts.savePctCorrectOnIndivLetters then
                pct_correct_vs_snr_eachLetter[fi][si] = pct_correct_vs_snr_eachLetter_i
            end            
            
            if printResults then
                if printInOneLine then
                    io.write(string.format(' %5.1f %% |', pct_correct_vs_snr_total[fi][si]))        
                elseif not printInOneLine then
                    io.write(string.format('pct correct = %.1f %%', pct_correct_vs_snr_total[fi][si]))
                end
            end
            
            if alsoDoTrainData then
                if printResults and not printInOneLine then
                    io.write(string.format(' [on training set: '))
                end

                pct_correct_vs_snr_total_train[fi][si], pct_correct_vs_snr_eachLetter_train_i = testModel(model_struct, trainData[fi][si], testOpts)
                if testOpts.savePctCorrectOnIndivLetters then
                    pct_correct_vs_snr_eachLetter_train[fi][si] = pct_correct_vs_snr_eachLetter_train_i
                end
                --errRate_i = testModel_multipleLabels(model_struct, test_tsData[si], true)
                
                if printResults and not printInOneLine then
                    io.write(string.format(' %.1f %% ]', pct_correct_vs_snr_total_train[fi][si]))
                end
            end
            if printResults and not printInOneLine then
                io.write('\n')
            end
            if printResults then    
                io.flush()
                sys.sleep(.01)
                io.flush()
                sys.sleep(.01)
            end
        end
        
        if printResults and (#allSNRs_test > 1) then
            local log_snr_th_estimate = estimateSNRthreshold(allSNRs_test, pct_correct_vs_snr_total[fi])
            if log_snr_th_estimate then
                if not printInOneLine then
                    io.write(string.format('  ==> Threshold estimate: %.1f.  Log th: %.2f \n', 10^log_snr_th_estimate, log_snr_th_estimate ))
                else
                    io.write(string.format(' [Th: %.2f]', log_snr_th_estimate ))
                end 
            end
        end
        
        if printResults and printInOneLine then  
            io.write('\n')
            if alsoDoTrainData and printResults then  -- print training data on next line if printing on one line.
                io.write('         [Training Set]:')
                for si = 1,#allSNRs_test do       
                    io.write(string.format(' %5.1f %% |', pct_correct_vs_snr_total_train[fi][si]))        
                end
                io.write('\n')
            end
        end    
        
        
    end
    local pct_correct_vs_snr_total_av = pct_correct_vs_snr_total:mean(1):reshape(nSNRs_test)
    
    
    if printResults and nFonts > 1  and (nSNRs_test > 1) then
        io.write(string.format(' -- Averaging over all fonts (%s) : \n', table.concat(fontNames, ', ') ))
        for si,snr_test in ipairs(allSNRs_test) do
            io.write(string.format(' -- test on all fonts : snr = %.1f ...  pct correct = %.1f %%\n', snr_test, pct_correct_vs_snr_total_av[si]))
        end
        local log_snr_th_estimate = estimateSNRthreshold(allSNRs_test, pct_correct_vs_snr_total_av)
        if log_snr_th_estimate then
            io.write(string.format('  ==> Threshold estimate: %.1f.  Log th: %.2f \n', 10^log_snr_th_estimate, log_snr_th_estimate ))
        end
    end
    
    if nFonts == 1 and reshapeToVector then
        pct_correct_vs_snr_total = pct_correct_vs_snr_total:reshape(nSNRs_test)
        if pct_correct_vs_snr_total_train then
            pct_correct_vs_snr_total_train = pct_correct_vs_snr_total_train:reshape(nSNRs_test)
        end
        
    end
    
    
    return pct_correct_vs_snr_total,       pct_correct_vs_snr_eachLetter, 
           pct_correct_vs_snr_total_train, pct_correct_vs_snr_eachLetter_train
    
end

        --[[
        for sz_i, sizeStyle in ipairs(allSizeStyles) do
            if #allSizeStyles > 1 then
                size_str = string.format('Size = %s (%d / %d). ', getFontSizeStr(sizeStyle), sz_i, #allSizeStyles)
            end
            --]]
            --[[
            for snrt_i, SNR_train in ipairs(allSNRs_train) do
                if #allSNRs_train > 1 then
                    snr_train_str = string.format('SNR-train set %d/%d. ', snrt_i, #allSNRs_train)
                end
--]]


--[[


                io.write(string.format(' -- loading test data for font = %s, snr = %.1f.   ', fontName_i, snr_test_i))
                    if alsoTestOnTrainData then
                        test_trData[fi][si], test_tsData[fi][si] = loadNoisyLetters(fontName_i, snr_test_i, letterOpts_data_test, loadOpts)
                    end
            if alsoTestOnTrainData then
                for si,snr_train in ipairs(SNR_train) do
                    print('train: ', snr_train)
                    io.write(string.format(' -- loading training data for snr = %.1f.   ', snr_train))	
                    test_trData[si] = loadNoisyLetters(fontName, snr_train, letterOpts, loadOpts)
                end
            end


       if alsoTestOnTrainData then
            for fi, fontName_i in ipairs(fontNames) do
                for si,snr_train in ipairs(allSNRs_test) do   -- *use ALL test data snrs (even though didn't train on all of them)
                    io.write(string.format(' -- testing on font = %s, snr = %.1f ... (from training set) ', fontName_i, snr_train))
                   
                    local errRateTotal_i_train, errRate_eachLetter_train = testModel(model_struct, test_trData[fi][si])
                    --errRate_i = testModel_multipleLabels(model_struct, test_tsData[si], true)
                    
                    pct_correct_vs_snr_total_train[fi][si]         = 100 - errRateTotal_i_train   -- a number
                    --pct_correct_vs_snr_eachLetter[si] = -errRate_eachLetter + 100    -- a tensor (so need to put first to add a number)
                    io.write(string.format('pct correct = %.1f %%\n', pct_correct_vs_snr_total_train[fi][si]))
                end
            end
        end
 
 --]]
 
 
 --[[
 
  for fi, fontName_i in ipairs(fontNamesList) do
                                            
                                            local dataLockName
                                            if lockDataFilesWhenLoading then
                                                dataLockName = 'Loading_' .. string.gsub ( basename( dataFileName_torch(fontName_i, 0, letterOpts_data_train) ), '.t7', '')        
                                                lock.waitForLock(dataLockName)                 
                                            end
                                            
                                            test_trData[fi] = {}
                                            test_tsData[fi] = {}
                                            for si,snr_test_i in ipairs(allSNRs_test) do
                                            
                                                io.write(string.format(' -- loading test data for font = %s, snr = %.1f.   ', fontName_i, snr_test_i))
                                                
                                                --_, test_tsData[fi][si] = loadLetters(fontName_i, snr_test_i, letterOpts_data_test, loadOpts_test)
                                        
                                                --loadOpts_test.loadTrainingData = alsoTestOnTrainData
                                                test_trData[fi][si], test_tsData[fi][si] = loadLetters(fontNamesList, allSNRs_test, letterOpts_data_test, loadOpts_test)
                                                
                                                
                                            end
                                            
                                            if lockDataFilesWhenLoading then
                                                lock.removeLock(dataLockName)
                                            end
                                        end            
                                        
                                        --]]
                                        
                                        --[[
                                        
                                                        --if train_trData and not inputStats_prev or not isequal(inputStats, inputStats_prev)  then
                    --print('Resetting training / testing data');
                    train_trData = nil
                    train_tsData = nil
                     
                    retrain_trData = nil
                    retrain_tsData = nil
                    
                    test_trData = nil
                    test_tsData = nil
                --elseif train_trData and inputStats_prev then
                --    print('Re-using training / testing data from last font & network');
                --end
                
                --inputStats_prev = inputStats
--]]

--[[
                                    local dataLockName 
                                    if lockDataFilesWhenLoading then
                                        --local dataLockName = 'Loading_' .. string.gsub ( basename( dataFileName_torch(fontName1, 0, letterOpts_data_train) ), '.t7', '')        
                                        --print('Creating lock', dataLockName)
                                        --lock.waitForLock(dataLockName)                 
                                    end

--]]


--[[

check if testing results are done
if done
    stop
elseif not done, 
    check if pretraining is done
    if pretraining is done
        continue with testing
        
    elseif pretraining not done
        if justDoingRetraining
            abort
        end
        check if pretraining is locked
        if pretraining is locked
            abort
        end
        make a note to lock pretraining file
        
        
    end
    
    lock testing file (and pretraining file)
    
end
hi

    
--]]


--[[

                                        local sameAfterSave = areConvolutionalWeightsTheSame(model_struct_pretrained, model_struct)
                                        print('After save, same filters = ', sameAfterSave);
                                        print('After save, first conv value = ', firstConvolutionalWeightValue(model_struct))
                                        --]]