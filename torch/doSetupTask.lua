doSetupTask = function(expName, modelName) -- (allFontNames, allSNRs, loadOpts, noisyLetterOpts, trainOpts)
--nstates = {6,16,120} --- ORIGINAL SET ---
--nstates = {9,24,180}	  --- x 1.5 ---
--nstates = {10,27,200}
--nstates = {12,32,240}	  --- x 2 ---
--nstates = {30,80,600}	  --- x 5 --    
--nstates = {60, 160, 1200} -- x 10 --- physiological parameters --- 


    local task = {expName = expName, modelName = modelName}
    
    setFolders(expName, modelName)
    
    print(string.format('Starting %s Experiment', expName))

    local saveTaskFile = onLaptop and true


    local doConvNet      = (modelName == 'ConvNet')
    local doTextureModel = (modelName == 'Texture')
    local doOverFeat     = (modelName == 'OverFeat')
    
    ------- ChannelTuning Settings ------
    
    --local channelTuningStage = 'train'
    --local channelTuningStage = 'retrain'
    local channelTuningStage = 'test'
    
    
    -- TRAIN
    local channels_realData_imageSize_train = {32, 32}
    local channels_trainOn = 'RealData'
        local channels_realDataName = 'SVHN'
        --local channels_realDataName = 'CIFAR10'
    --local channels_trainOn = 'PinkNoise'

    -- RETRAIN
    --local channelTuningRetrainOn = 'white'
    local channelTuningRetrainOn = ''

    -- TEST
    local channelTuningTestOn = 'band'
    --local channelTuningTestOn = 'hiLo'
    
        local testOnCentralBands = false

    
    --local channels_realData_imageSize_train = {64, 64}
        
    --local channels_imageSize_test = {30, 30}
    --local channels_imageSize_test = {32, 32}
    --local channels_imageSize_test = {36, 36}
    --local channels_imageSize_test = {45, 45}
    local channels_imageSize_test = {64, 64}
        
        
        
    --local channels_imageSize = {32, 32}
        local channels_realData_settings_noNorm = {imageSize = channels_realData_imageSize_train, globalNorm = true, localContrastNorm = false}
        local channels_realData_settings_norm   = {imageSize = channels_realData_imageSize_train, globalNorm = true, localContrastNorm = true}
        
        --local channels_realData_settings_noNorm_32 = {imageSize = {32, 32}, globalNorm = true, localContrastNorm = false}
        --local channels_realData_settings_norm_32 = {imageSize = {32, 32}, globalNorm = true, localContrastNorm = true}
    
    ------- Grouping Settings ------
    --local groupingStage = 'train'
    local groupingStage = 'test'
    
    
    local grouping_imageSize_test = {64, 64}
    local grouping_realData_imageSize_train = {32, 32}
    local grouping_trainOn = 'RealData'
        local grouping_realDataName = 'SVHN'
        local grouping_realData_settings = {imageSize = grouping_realData_imageSize_train, globalNorm = true, localContrastNorm = false}
        --local grouping_dWiggle = 45
        local grouping_dWiggle = 5
        
    --local grouping_trainOn = 'allWiggles'
    --local grouping_trainOn = 'noWiggle'
    --local grouping_trainOn = 'Sloan'
    --local grouping_trainOn = 'sameWiggle'
    
    
    ------- Complexity Settings ------
    local complexity_realData_imageSize_train = {32, 32}
    --local complexity_realData_imageSize_train = {64, 64}
    
    
    --local complexity_trainOn = 'PinkNoise'
    local complexity_trainOn = 'RealData'
        local complexity_realDataName = 'SVHN'
        --local complexity_realDataName = 'CIFAR10'
    --local complexity_trainOn = 'WhiteNoise'
        
    local doOnlyBookman = false;
    
        local complexity_realData_settings_noNorm = {imageSize = complexity_realData_imageSize_train, globalNorm = true, localContrastNorm = false}
        local complexity_realData_settings_norm   = {imageSize = complexity_realData_imageSize_train, globalNorm = true, localContrastNorm = true}
    
    
    
    --local complexityStage = 'train'
    local complexityStage = 'test'
    
    
    ------ Crowding Settings ------
    local crowding_trainOn = 'RealData'
        local crowding_realDataName = 'SVHN'
    --local crowding_trainOn = 'WhiteNoise'
    
    --local crowdingStage = 'train'
    local crowdingStage = 'test'
    
    
    
    -------------
    
    local netType, stimType, allSNRs
    if doConvNet then
        netType = 'ConvNet'
        stimType = 'NoisyLetters'
    elseif doTextureModel then
        netType = 'MLP'
        stimType = 'NoisyLettersTextureStats'
    elseif doOverFeat then        
        netType = 'MLP'
        stimType = 'NoisyLettersOverFeat'
    end

--netType = 'MLP'

    local convertOverFeatFilesNow = false and (THREAD_ID  ~= nil)
    if doOverFeat and convertOverFeatFilesNow then
        print('Creating all OverFeat torch files... ')
        dofile (torchLetters_dir .. 'convertAllOverFeatFiles.lua')
        convertAllOverFeatFiles()
        return
    end

    
    local nTrials = 1



    local loadOpts = {}
    loadOpts.totalUseFrac = 1
    loadOpts.trainFrac  = 0.8   -- fraction of data to use for training (vs testing)
    loadOpts.elementWiseNormalizeInputs = doTextureModel or doOverFeat
    task.loadOpts = loadOpts
    

    local trainOpts = {}
    trainOpts.REQUIRE_COST_MINIMUM = false
    trainOpts.REQUIRE_TRAINING_ERR_MINIMUM = true
    trainOpts.SWITCH_TO_LBFGS_AT_END = false
    trainOpts.LBFGS_USE_REDUCED_SET_FIRST = false
    trainOpts.LBFGS_REDUCED_FRAC = 0.1
    trainOpts.SAVE_TRAINING = true
    trainOpts.BATCH_SIZE = 1

    trainOpts.COST_CHANGE_FRAC_THRESH = 0.001  -- = 0.1%
    trainOpts.TRAIN_ERR_CHANGE_FRAC_THRESH = 0.001  -- = 0.1%
    trainOpts.MIN_EPOCHS = 5
    trainOpts.STOP_IF_ZERO_TEST_ERROR = true
    trainOpts.MAX_EPOCHS = 200

    local GPU_BATCH_SIZE = 128
    if useGPU then
        trainOpts.BATCH_SIZE = GPU_BATCH_SIZE
    end

    task.trainOpts = trainOpts

    ----------------------------------------------------------------------------------------------------------
    -------------------------------------------- NETWORK OPTIONS  --------------------------------------------
    ----------------------------------------------------------------------------------------------------------

   
   
    local setName 
    
    --setName = 'bestNetworks' 
    setName = '3LayerNets'
    --setName = 'bestNetworks' 
    --local setName = 'nStates'
    --setName = 'poolSizes'
    --setName = 'filtSizes' 
    --setName = 'filtSizes_poolSizes'
    --setName = 'LeNet'
    
    
    --allNHiddenUnits = {3,4,5,6,7,8,9,10,20,50,100}
    
    
    
    
    local allNetworkOptions_tbl
    local convFunction
    if onLaptop then
        if useGPU then
        --convFunction = 'SpatialConvolutionMap' 
            --convFunction = 'SpatialConvolutionCUDA'
            convFunction = 'SpatialConvolutionMM'
        else
            convFunction = 'SpatialConvolution'
        end
    else
        if useGPU then
            --convFunction = 'SpatialConvolutionCUDA'
            convFunction = 'SpatialConvolutionMM'
            --convFunction = 'SpatialConvolution'        
        else
            convFunction = 'SpatialConvolution'
        end

    end

    local snr_train012 = {0,1,2}
    local snr_train_n1t2 = {-1,0,1,2}
    local snr_train_n2t1 = {-2,-1,0,1}
    local snr_train1t3 = {1,2,3}
    local snr_train1t4 = {1,2,3,4}
    local snr_train1h3 = table.range(1, 3, 0.5) --{0,1,2}
    local snr_train1h3p5 = table.range(1, 3.5, 0.5) --{0,1,2}
    local snr_train4 = {4}
        
    local finalLayer = 'LogSoftMax'
    local all_nStates_and_filtSizes_and_poolSizes_and_fullImagePooling
    print('=======NetType', netType)
    
    local snr_train, snr_train2, tbl_allSNRs_train
    if netType == 'ConvNet' then
        -- ConvNet options

        
        if expName == 'ChannelTuning' then
            tbl_allSNRs_train = { snr_train1h3 }
            --tbl_allSNRs_train = { snr_train_n1t2, snr_train_n2t1 }
        elseif expName == 'Uncertainty' or expName == 'Complexity' or expName == 'Grouping' or expName == 'Crowding' then
            tbl_allSNRs_train = { snr_train1h3 }
        end
        
        --tbl_allSNRs_train = { snr_train, snr_train2 }
        
        --snr_train = {4}

        --snr_train = {1,2,3,4}
        --snr_train = {0,1,2,3,4}


        --allNStates = { {6, -50}, {6, -100},  {12, -50}, {12, -100} }
        --allNStates = { {6, -100}  }
        --allNStates = {  {6, 16, -120}, {9,24, -180}, {12,32,-240} } -- {60, 160, -1200} }
        --allNStates = {  {6, 16, -120}, {12,32,-240}, {60, 160, -1200} } -- {60, 160, -1200} }
        
        --allNStates = { {3, 8, -60}, {6, 16, -120}, {6, 16, -30}, {12,32,-240}, } -- {60, 160, -1200} }
        --allNStates = {  {6, 16, -120}, } --  {12, 32, -120}, {24, 64, -120},  {48, 128, -120} } 
        --allNStates = {  {6, 16, -15},  {6, 16, -30}, {6, 16, -60},  {6, 16, -120}, {6, 16, -240}, {6, 16, -480}, {6, 16, -960} } -- {60, 160, -1200} }
        
        --allNStates = {  {6, 16, -120},  {6, 32, -120}, {6, 64, -120},  {6, 128, -120}, {6, 16, -960}  } -- {60, 160, -1200} }
        --allNStates = {  {3, 16, -120}, {6, 16, -120},  {12, 16, -120}, {24, 16,-120}, {48, 16, -120},   } -- {60, 160, 1200} }
        --allNStates = {  {3, 8, -60}, {6, 16, -120}, {6, 16, -30}, {6,16, -15}, {6,16,-8}, {12,32,-240},  {3,8,-10}, {3,8,-5}, {3,8,-3}, {3,8,-30}, {6,8,-10}, {12,8,-10} }
        --allNStates = {  {6, 16, -120}, {}
            
        --allNStates = { {6, 16, -960} ,
          --              {6, 4, -120},  {6, 8, -120},  {6, 16, -120},  {6, 32, -120}, {6, 64, -120},  {6, 128, -120}, {6, 256, -120},  -- {60, 160, -1200} }
            --             {3, 16, -120}, {6, 16, -120},  {12, 16, -120}, {24, 16, -120}, {48, 16, -120}, {96, 16, -120}, {192, 16, -120}  } -- {60, 160, -1200} }
            
        --local allNStates = { {6, -15}, {6, -30}, {6,-60}, {6,-120}, {6,-240}, {12, -15}, {12, -30}, {12,-60}, {12,-120}, {12, -240} }
        
        --local allNStates = { {12, -60}, {24, -120}, {48, -120} }
        
--        local allNStates = {  {16, 32, -120}, {16, -120}, }
        --local allNStates = {  {3, -15}, {6, -15}, {12, -15},  {24, -15},   {6, -30}, {6, -60}, {6, -120},   {16, -30}, {16, -60}, {16, -120}    }
        --local allNStates = {  {16, -120} }
        
        --local allNStates = { {6, 16, -120}, {16, 32, -120},  {6, 16, 120, -84},   }
        --local allNStates = { {6, -120}, }
        --local allNStates = {  {16, 32, -32}, }--{16, 128, -32}, {16, 512, -32}, {16, 32, -120},  {16, 128, -120},  }
        --local allNStates = { {16, 32, -120}, {16, 128, -120},  }
        
        --local allNStates = { {6, 16, -120}, {16, 32, -240}, {16, 32, -120}, {16, 128, -120},  }
        
        --local allNStates = { {6, 16, -120}, {16, 32, -120}, {16, 64, -120} }
        local allNStates = { {6, 16, -120}, {16, 32, -120}, {16, 64, -120} }
        
        --local allNStates = { {6, -120} }
        
        --local allNStates = {  {24, 16, -240}  }
        --local allNStates = { {6, 16, -120}, {24, 16, -120}, {16, 64, -120},   }
        --local allNStates = { {6, 16, -120}, {16, 32, -120}, {16, 32, -240}, {16, 128, -120},  }
        
        if useGPU then
            allNStates = { {16, 32, -120},  }
        end
        
        if onLaptop then
            --allNStates = { {16, -120} }
        end
            
        --local allNStates = { {6,-15}, {6,-30} }
        
        --local allNStates = {12, -60}, {24,-120}, {48,-120}

        local filtSizes = {5, 4}
        --local allFiltSizes = { {5, 5, 5}}
        --local allFiltSizes = { {3, 3}, {5, 5}, }
        --local allFiltSizes = {  {5, 5}, {7, 7} }
        --local allFiltSizes = {  {5, 5}  }
        local allFiltSizes = {  {5, 4} ,  {5, 5}  }
        
        --local allFiltSizes = { {5 } }-- {5, 7}  }
        --local allFiltSizes = {  5, 10, 20 }
        
        local doPooling = true
        --local allDoPooling = {false, true}
        local allDoPooling = {true}

        
        --local filtSizes = {34}
        
        local poolTypes = 'MAX'
        --local allPoolTypes = {2}  -- {1, 2, 'MAX'}
        --local allPoolTypes = {2, 'MAX'}  -- {1, 2, 'MAX'}
        local allPoolTypes = {'MAX'}  -- {1, 2, 'MAX'}

        if useGPU then
            allPoolTypes = {'MAX'}  -- {1, 2, 'MAX'}
        end
        
        local poolStride = 'auto'
        --local poolStride = 2
        
        --local allPoolStrides = {'auto', 2,4,6,8}
        --local allPoolStrides = {'auto', 2}
        local allPoolStrides = {'auto'}
        --local allPoolStrides = {2,4}
            
        local poolSize = {4, 2}        
        --local allPoolSizes = { {4, 2}, {4, 4}, {2, 2}, {2, 4}, }
        --local allPoolSizes = { {4, 2}, {0, 0} } 
        --local allPoolSizes = { {4, 0, 0}, {2, 2, 0}, {0, 0, 0},  } 
        --local allPoolSizes = { 0, 2, 4, 6, 7, 8, 10, 12, 14} 
        --local allPoolSizes = {0, 2, 4, 6, 8, 12, 16, 20} 
        --local allPoolSizes = { {0, 0}, {2, 2}, {4, 0}, {4, 2} } 
        --local allPoolSizes = { 6 }
        --local allPoolSizes = { {4, 0}, {4, 2}, {4, 4}, {4, 6} } 
        --local allPoolSizes = {2, 3, 4, 6, 8}
        --local allPoolSizes = {2, 3, 4, 6, 8}
        --local allPoolSizes = {2, 4, 8, 0} 
        --local allPoolSizes = { {2, 2, 2}, {2, 2, 0} } 
        --local allPoolSizes = { {2, 2}, {4, 2}  } 
        
        --local allPoolSizes = { {2, 2}, {3, 2}, {4, 2} } 
        local allPoolSizes = { {2, 2}, {3, 2}, {4, 2} } 
                
        if onLaptop then
            --allPoolSizes = { 6 }
        end

        
        if setName == 'nStates' then
            --allNStates =  { {3,-15}, {6,-15}, {12,-15}, {24,-15},   {6,-8}, {6,-30}, {6,-60}  } 
            --allNStates =  { {6,-15}, {6,-60}, {6,-120}, {6,-240}  } 
            --allNStates =  { {6,-15},  {6,-120}, {6},  {6, 16},  {6, 16, -120},  } --{6, 16}, {6, 16,  }
            
            allNStates =  {   {6, -15}, {6, -120},   }
            
            --allNStates =  {   {6, 16},  {6, 16, -120},   {6,16, -240}, {12, 32},  {12, 32, -240}   }  -- {24, 64, -480}
             
            
        elseif setName == 'filtSizes' then
            --allFiltSizes = {2,3,4,5,10,20}
            allFiltSizes = {3,5,10}
            
        elseif setName == 'poolSizes' then
            --allDoPooling = {true}
            
            --[[
            allNStates = { { 1,15}, {1,60},  } --, {2, 30}  }
            allFiltSizes = {0}
            allPoolSizes = {0,2,4,6,8} --{0, 2,4,6,8}
            allPoolTypes = {1}
            --]]
            --allPoolSizes = {0,2,4,6,8} --{0, 2,4,6,8}
            allPoolSizes = {0, 2, 4, 6,8} --{0, 2,4,6,8}
            
        elseif setName == 'poolTypes' then
            allPoolTypes = {1, 2, 'MAX'}
            
        elseif setName == 'filtSizes_poolSizes' then
            --allFiltSizes = {5,10}
            --allPoolSizes = {0,2,4,6}

            --allFiltSizes = {2,3,5,8,16,20,24}
            --allPoolSizes = {0, 2,4,6,8,10,12}
            
            --allFiltSizes = {2,3,5,16,24}
            --allPoolSizes = {0, 2,4,6,8,12}

            --allFiltSizes = {3,5,10,20}
            --allPoolSizes = {0, 2,4,8,16}
            
            --allNStates =  {  {6}, {6, -15}, {6, -120}, {6, -480} }, -- {6, 16}, {6, 16, -30}, {6, 16, -120},  }            
            --allNStates =  {   {6, -120},  } -- {6, 16}, {6, 16, -30}, {6, 16, -120},  }            
            --allNStates =  {  {12, -60, -60} }            
            --allNStates =  {  {6, -120} }            
            --allNStates =  {  {24, -120}, }            
            allNStates =  {  {6, -15}, }            
            --allNStates =  {  {24}, {24, -15}, {24, -120}, {24, -480}, {96}, {96, -15}, {96, -120}, {96, -480},  }            
            --allNStates =  {  {20, 50, -500}  }            
            
            allFiltSizes = { {5, 4} }
            --allFiltSizes = { {5}, {10}, {20} }
            
            --allPoolSizes = { {0, 0}, {2, 2}, {4, 2} }
            allPoolSizes = { {0, 0}, {4, 2}  } 
            --allPoolSizes = { {2, 2} } 
        elseif setName == 'LeNet' then
            
            allNStates = { {6, 16, 120, -84}, }--{6,-15} }

            allFiltSizes = { {5, 5, 5} }
            
            --local allDoPooling = {false, true}
            allDoPooling = {true, false}
                        
            allPoolStrides = {'auto'}
               
            allPoolSizes = { {2, 2, 0} } 
           
           
        elseif setName == 'bestNetworks' then
            
            allNStates = { {6, 16, -120}, {16, 32, -120} }--{6,-15} }

            allFiltSizes = { {5, 5} }
            
            --local allDoPooling = {false, true}
            allDoPooling = {true}
                        
            allPoolStrides = {'auto'}
               
            allPoolSizes = { {2, 2}, {3, 2}, {4, 2} } 
            
            allPoolTypes = {'MAX'}  -- {1, 2, 'MAX'}
    
        elseif setName == '3LayerNets' then
        
            allNStates = {{16, 64, 256, -120}, {16, 128, 512, -240}, {16, 64, 512, -120},  {6, 16, 64, -120}}
            allFiltSizes = {{5, 5, 3}, {5, 3, 3}}
            allPoolSizes = {{2,2,2}, {2,2,3} }
            
            --allNStates = {{16, 64, 256, -120}, {16, 128, 512, -240}, {16, 64, 512, -120},  {6, 16, 64, -120}}
            --allNStates = {{16, 64, 512, -120}, } -- {16, 128, 512, -240} 
            --allNStates = { {16, -120}, {16, 64, -120}, {16, 64, 512, -120}, } -- {16, 128, 512, -240} 
            allNStates = {{16, -120}, {16, -512}, {16, -1024}, {16, -2048}, 
                          {16, 64, -120}, {16, 64, -512}, {16, 64, -1024}, {16, 64, -2048}, 
                          {16, 64, 512, -120}, {16, 64, 512, -512}, {16, 64, 512, -1024},  {16, 64, 512, -2048}} -- {16, 128, 512, -240} 
            
            allFiltSizes = { {5, 5, 3}}
            allPoolSizes = {{2,2,2}, }
                        
            --[[
            all_nStates_and_filtSizes_and_poolSizes = {
                 {{16, 64, 512, -120}, {5, 5, 3}, {2,2,3}},
                 {{6, 16, 64, -120},   {5, 3, 3}, {2,2,2}},
             }
            --]]

            --allNStates = {{16, 64, 512, -120},  {6, 16, 64, -120}}
            --allNStates = {{6, 16, -120},  {6, 16, 64, -120}, {16, 64, 512, -120},}
            --[[
            allNStates = {{16, 64, 512, -512}, {16, 64, 512, -120}}
            allFiltSizes = {{5, 5, 3}}
            allPoolSizes = {{2,2,2}, }
            --]]
            
            
            
            if expName == 'Uncertainty' then
                allNStates = {{16, -512},          {16, -120},
                              {16, 64, -512},      {16, 64, -120},
                              {16, 64, 512, -512}, {16, 64, 512, -120}}
                          
            elseif expName == 'Grouping' then
              allNStates =  { {16, 64, 512, -120}, {16, 64, 1024, -120} }
                --allNStates = {--{16, 64, -512},      {16, 64, -120},
                              
                  --            {16, 64, 512, -120}, }-- {16, 64, 512, -512} }
                allPoolSizes = { {2,2,2}, {2,2,4}, {2,2,12} }

                allPoolSizes = { {2,2,16}, {2,3,16}, {2,4,16} ,
                                 {3,2,16}, {3,3,16},{3,4,16}, 
                                 {4,2,16}, {4,3,16},{4,4,16} }

             elseif expName == 'Complexity' then
                allNStates =  {  {16, 64, 512, -120}, {16, 64, 1024, -120} }
                allFiltSizes = { {5, 5, 3}, }
                --allPoolSizes = { {2,2,2}, {2,2,3}, {2,2,4}, {2,2,6}, {2,2,12} }
                allPoolSizes = { {2,2,16}, {2,3,16}, {2,4,16} ,
                                 {3,2,16}, {3,3,16},{3,4,16}, 
                                 {4,2,16}, {4,3,16},{4,4,16} }
                --allPoolSizes = { {3,3,12}, {2,3,6},{2,2,12} }
                allPoolTypes = {'MAX'}
            
            
                allNStates =  {  {16, 64, 256, 512, 1024, -120},  }
                --allFiltSizes = { {5, 5, 5, 5, 5}, {5, 5, 5, 3, 3}, }
                allFiltSizes = { {5, 5, 5, 5, 5},  }
                allPoolSizes = { {2,2,2,2,4},  }
            --[[
                allNStates =  {  {16, 64, -120}, {32, 128, -120} }
                allFiltSizes = { {5, 5}, }
                --allPoolSizes = { {2,2,2}, {2,2,3}, {2,2,4}, {2,2,6}, {2,2,12} }
                allPoolSizes = { {2,26}, }
--]]
            
            elseif expName == 'ChannelTuning' then
            
                --allNStates =  { {16, 64, 512, -120}, {16, 64, 1024, -120} }
                allNStates =  { {16, 64, 1024, -120} }
                allFiltSizes = { {5, 5, 3}}
                --allPoolSizes = { {2,2,2}, {2,2,3}, {2,2,4}, {2,2,6}, {2,2,12} }
                --allPoolSizes = { {2,2,2}, {2,2,4}, {2,2,6}, {2,2,12} }
                allPoolTypes = {'MAX'}
                allPoolSizes = { --{2,2,16}, {2,3,16},{2,4,16},
                                 --{3,2,16}, {3,3,16},{3,4,16}, 
                                 --{4,2,16}, {4,3,16},{4,4,16} }
                                 {2,2,16}, --{3,3,16},{4,4,16},                                
                             }
 
                allPoolSizes = { {2,2,16}, {2,3,16}, {2,4,16} ,
                                 {3,2,16}, {3,3,16},{3,4,16}, 
                                 {4,2,16}, {4,3,16},{4,4,16} }
                allPoolTypes = {'MAX', 2}
                             

--[[
                allNStates =  { {32, 128, -120} }
                allFiltSizes = { {5, 5}, }
                --allPoolSizes = { {2,2,2}, {2,2,3}, {2,2,4}, {2,2,6}, {2,2,12} }
                allPoolSizes = { {2,26}, }
--]]

                --allNStates =  {  {16, 64, -120} }
                --allFiltSizes = { {5, 5}, }
                --allPoolSizes = { {2,2,2}, {2,2,3}, {2,2,4}, {2,2,6}, {2,2,12} }
                --allPoolSizes = { {2,26} }
                                 --{3,2,16}, {3,3,16},{3,4,16}, 
                                 --{4,2,16}, {4,3,16},{4,4,16} }
                --allPoolSizes = { {3,3,12}, {2,3,6},{2,2,12} }
                
                allNStates =  {  {16, 64, 256, 512, 1024, -120},  }
                allFiltSizes = { {5, 5, 5, 5, 5}, {5, 5, 5, 3, 3}, }
                allPoolSizes = { {2,2,2,2,4},  }
                allPoolTypes = {'MAX'}

            end
            --]]
                      
        --        allNStates = {
          --                    {16, 64, 512, -512}, {16, 64, 512, -120},
                              --{16, 64, -512},      {16, 64, -120},
            --                  }
          --allNStates = {{6, -120}, {6, 16, -120}}
            --allFiltSizes = {{5, 5}}
            --allPoolSizes = {{2,2}, }
            
                    -- 4 layers
                allNStates =  {  {16, 64, 256, 512, -120}, {16, 64, 256, 512, -1200},  }
                --allFiltSizes = { {5, 5, 5, 5, 5}, {5, 5, 5, 3, 3}, }
                allFiltSizes = { {5, 5, 5, 5},  }
                allPoolSizes = { {2,2,2,2}, {2,2,2,8},  }


                -- 3 layers
                allNStates =  {  {16, 64, -120}, {16, 64, -1200},  }
                --allFiltSizes = { {5, 5, 5, 5, 5}, {5, 5, 5, 3, 3}, }
                allFiltSizes = { {5, 5},  }
                allPoolSizes = { {2,2}, {2,32},  }

            all_nStates_and_filtSizes_and_poolSizes_and_fullImagePooling = {
                --{ {16, -120},  {5}, {2}, },
                --{ {16, -1200}, {5}, {2}, },
                --{ {16, -120},  {5}, {64}, },
                --{ {16, -1200}, {5}, {64}, },
                { {16, 64, 256, 512, 1024, -120},  {5, 5, 5, 5, 5}, {2,2, 2, 2, 4}, true},
                
                
                --{ {16, 64, -120},  {5, 5}, {2,2}, false},
                --{ {16, 64, -1200}, {5, 5}, {2,2}, false },
                { {16, 64, -120},  {5, 5}, {2,32}, true },
               -- { {16, 64, -1200}, {5, 5}, {2,32}, true },
             
                --{ {16, 64, 256, -120},  {5, 5, 5}, {2,2, 2}, false, },
                --{ {16, 64, 256, -1200}, {5, 5, 5}, {2,2, 2}, false, },
               { {16, 64, 256, -120},  {5, 5, 5}, {2,2, 16}, true, },
                --{ {16, 64, 256, -1200}, {5, 5, 5}, {2,2, 16}, true, },
            
                --{ {16, 64, 256, 512, -120},  {5, 5, 5, 5}, {2,2, 2, 2}, false, },
                --{ {16, 64, 256, 512, -1200}, {5, 5, 5, 5}, {2,2, 2, 2}, false },
                { {16, 64, 256, 512, -120},  {5, 5, 5, 5}, {2,2, 2, 8}, true },
                --{ {16, 64, 256, 512, -1200}, {5, 5, 5, 5}, {2,2, 2, 8}, true },
                 
                --{ {16, 64, 256, 512, 1024, -120},  {5, 5, 5, 5, 5}, {2,2, 2, 2, 2}, false },
                --{ {16, 64, 256, 512, 1024, -1200}, {5, 5, 5, 5, 5}, {2,2, 2, 2, 2}, false },
                { {16, 64, 256, 512, 1024, -120},  {5, 5, 5, 5, 5}, {2,2, 2, 2, 4}, true},
                --{ {16, 64, 256, 512, 1024, -1200}, {5, 5, 5, 5, 5}, {2,2, 2, 2, 4}, true },
                 
             }
            
            if expName == 'Crowding' then
                

                all_nStates_and_filtSizes_and_poolSizes_and_fullImagePooling = {
                    --{ {16, -120},  {5}, {2}, },
                    --{ {16, -1200}, {5}, {2}, },
                    --{ {16, -120},  {5}, {64}, },
                    --{ {16, -1200}, {5}, {64}, },
                    { {16, 64, 256, 512, 1024, -120},  {5, 5, 5, 5, 5}, {2,2, 2, 2, 10}, },
                    
                    { {16, 64, -120},  {5, 5}, {2,2}, },
                    { {16, 64, -120},  {5, 5}, {2,80}, },
                    --{ {16, 64, -1200}, {5, 5}, {2,2}, },
                   -- { {16, 64, -1200}, {5, 5}, {2,32}, },
                 
                    { {16, 64, 256, -120},  {5, 5, 5}, {2,2, 2}, },
                    --{ {16, 64, 256, -1200}, {5, 5, 5}, {2,2, 2}, },
                    { {16, 64, 256, -120},  {5, 5, 5}, {2,2, 40}, },
                    --{ {16, 64, 256, -1200}, {5, 5, 5}, {2,2, 16}, },
                
                    { {16, 64, 256, 512, -120},  {5, 5, 5, 5}, {2,2, 2, 2}, },
                    --{ {16, 64, 256, 512, -1200}, {5, 5, 5, 5}, {2,2, 2, 2}, },
                    { {16, 64, 256, 512, -120},  {5, 5, 5, 5}, {2,2, 2, 20}, },
                    --{ {16, 64, 256, 512, -1200}, {5, 5, 5, 5}, {2,2, 2, 8}, },
                     
                    { {16, 64, 256, 512, 1024, -120},  {5, 5, 5, 5, 5}, {2,2, 2, 2, 2}, },
                    --{ {16, 64, 256, 512, 1024, -1200}, {5, 5, 5, 5, 5}, {2,2, 2, 2, 2}, },
                    --{ {16, 64, 256, 512, 1024, -1200}, {5, 5, 5, 5, 5}, {2,2, 2, 2, 4}, },
                     
                 }                
                    
            end


            allNStates = nil ; allPoolSizes =nil; allFiltSizes = nil;

            --allNStates = {{6, -120}}
            --allFiltSizes = {{5}}
            --allPoolSizes = {{2}}
    
        end
        
        --2Layer_fromScratch_u1_1369_Bookman_Sloan
        --[[
        allNStates = { {6, 16, -120},  }
        allPoolSizes = { {2, 2}, } 
        local allFiltSizes = {  {5, 4}   }
            --]]
        
        local config_sgd = {learningRate = 1e-3,  learningRateDecay = 1e-4,  weightDecay = 0}
        local config_sgd_mom = {learningRate = 1e-3,  learningRateDecay = 1e-4, weightDecay = 0, momentum = 0.95, dampening = 0}
        local config_sgd_mom_nest = {learningRate = 1e-3,  learningRateDecay = 1e-4, weightDecay = 0, momentum = 0.95, dampening = 0, nesterov = 1}
        local config_adadelta = {adaptiveMethod = 'ADADELTA', rho = 0.95, epsilon = 1e-6}
        local config_rmsprop = {adaptiveMethod = 'rmsprop', rho = 0.95, epsilon = 1e-6}
        local config_vSGD = {adaptiveMethod = 'vSGD'}
            
        --local tbl_trainConfig = {config_vSGD, config_sgd, config_sgd_mom, config_adadelta, config_rmsprop, config_vSGD}
        --local tbl_trainConfig = {config_sgd, config_sgd_mom, config_adadelta}
        local tbl_trainConfig = {config_sgd_mom }
        
        local zeroPadForConvolutions = true
        local fullImagePooling = false
            
        allNetworkOptions_tbl = { netType = 'ConvNet', 
                                tbl_nStates = allNStates,
                                
                                --filtSizes = filtSizes,
                                tbl_filtSizes = allFiltSizes,
                                
                                --doPooling = doPooling, 
                                tbl_doPooling = allDoPooling,
                                
                                --poolSizes = poolSize,
                                tbl_poolSizes = allPoolSizes,
                                
                                --poolStrides = poolStride, 
                                tbl_poolStrides = allPoolStrides,
                                
                                --poolTypes = poolTypes,
                                tbl_poolTypes = allPoolTypes,
                                
                                tbl_nStates_and_filtSizes_and_poolSizes_and_fullImagePooling 
                                = all_nStates_and_filtSizes_and_poolSizes_and_fullImagePooling,
                                
                                --useConnectionTable = useConnectionTable,
                                convFunction = convFunction,
                                
                                trainOnGPU = useGPU,
                                gpuBatchSize = GPU_BATCH_SIZE,
                                
                                tbl_trainConfig = tbl_trainConfig,
                                
                                finalLayer = finalLayer,
                                zeroPadForConvolutions = zeroPadForConvolutions,
                                
                                fullImagePooling = fullImagePooling,
                                
                              }

        
    elseif netType == 'MLP' then
        --trainOpts.MIN_EPOCHS = 3
        
        --tbl_allSNRs_train = { snr_train1, snr_train2 }
        --tbl_allSNRs_train = { {3}, {4}, {3,4}, {2, 3, 4}, {2, 3, 4, 5} }
        --tbl_allSNRs_train = { {1, 2, 3}, {1, 2, 3, 4}, {1, 2, 3, 4, 5}, {2, 3, 4}, {2, 3, 4, 5} }
        --tbl_allSNRs_train = { {2, 3, 4, 5} }
        --tbl_allSNRs_train = { snr_train1t3, snr_train1t4 }
        
        if expName == 'ChannelTuning' then
            tbl_allSNRs_train = { snr_train1h3 }
            --tbl_allSNRs_train = { snr_train_n1t2, snr_train_n2t1 }
        elseif expName == 'Uncertainty' or expName == 'Complexity' or expName == 'Grouping' or expName == 'Crowding' then
            tbl_allSNRs_train = { snr_train1h3 }
        end

        
--        local allNHiddenUnits = { {6}, {12}, {24}, {48}, {96},   {6, 16}, {6, 32}, {6, 64},   {12, 16}, {12, 32}, {12, 64} }
        --local allNHiddenUnits = { {}, {4}, {5}, {8}, {10}, {15}, {30}, {60}, {120} }
--        allNHiddenUnits = {4,10,20,40,100,200}
        --allNHiddenUnits = {1,2, 3, 4, 5,10,25,50}
        
        --local allNHiddenUnits = { {}, {30}, {120}, {240}, {480}, {60, 60} }
        --local allNHiddenUnits = { {}, {30}, {120}, {240}, }
        --local allNHiddenUnits = { {}, {120} }
        --local allNHiddenUnits = { {120}, {120, 120} }
        local allNHiddenUnits = { {128}}
        --local allNHiddenUnits = { {512, 512}, {150, 150}, {128, 128}, {120, 120}, {64, 64}, {32, 32}, {120}, {64}, {32}, }
        --local allNHiddenUnits = { {}, }
           
  --          {6, 15}, {6, 30}, {6,60}, {6,120}, {6, 240}, {12, 15}, {12, 30}, {12,60}, {12,120}, {12, 240} }
        allNetworkOptions_tbl = { netType = 'MLP',
                                    finalLayer = finalLayer,
                                  tbl_nHiddenUnits = allNHiddenUnits }                    
        
        --allNetworks = expandOptionsToList(allNetworkOptions_tbl)
        
    end
    
    
    NN = allNetworkOptions_tbl

    ----------------------------------------------------------------------------------------------------------
    -------------------------------------------- LETTER STIMULUS OPTIONS  ------------------------------------
    ----------------------------------------------------------------------------------------------------------

    ----------------
    ----- FONT NAMES

   
    --allFontNames_ext = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'GeorgiaUpper', 'Yung', 'Kuenstler'}

   
    local styles_use = {'Roman', 'Bold', 'Italic', 'BoldItalic'}
    --local styles_use = {'Roman', 'Bold'}
    
    
    
    local allStdFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
    local allStdFontNames2      = {'Bookman', 'BookmanU', 'HelveticaU', 'CourierU', 'BookmanUB', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
    local allExtFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung', 
                                    'BookmanB', 'BookmanU', 'Hebraica', 'Devanagari', 'Armenian', 'Checkers4x4', 'Courier'};
    local allStdFontNames_tbl  = { {'Bookman'}, {'Sloan'}, {'Helvetica'}, {'KuenstlerU'}, {'Braille'}, {'Yung'} }

    
    local Bookman_rBIJ = {fonts = {'Bookman'}, styles = styles_use};
    local mK_rBIJ = {fonts = {'Bookman', 'KuenstlerU'}, styles = styles_use};
    local mrh_rBIJ = {fonts = {'Bookman', 'Courier', 'Helvetica'}, styles = styles_use};
    --local mMlrhKsy_rBIJ = {fonts = allStdFontNames, styles = styles_use} 
    local mlhKsy = {fonts = allStdFontNames } 
    local mlhKsy_rBIJ = {fonts = allStdFontNames, styles = styles_use} 
    


        
    
    -- NOISE FILTERS

    local applyGainFactor_band = true
    local applyGainFactor_hiLo = false
    local applyGainFactor_pink = true
    
    --local allBandNoise_cycPerLet = {0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13}
    --local allCycPerLet = {0.5, 0.71, 1, 1.41, 2, 2.83, 4, 5.66, 8, 11.31, 16}
    local allCycPerLet = {0.5, 0.59, 0.71, 0.84, 1.00, 1.19, 1.41, 1.68, 2, 2.38, 2.83, 3.36, 4, 4.76, 5.66, 6.73, 8, 9.51, 11.31, 13.45, 16}
    allCycPerLet = {2 }
    
    if testOnCentralBands then
        --allCycPerLet = {1.00,  1.41,    2, 2.38,    3.36, 4.76, }
        allCycPerLet = {1.00,  2, 4, }
    end
    
    
    --allCycPerLet = {1.3}
    --local allCycPerLet = {0.5}
    
    local tbl_allBandNoiseFilters = {}
    local tbl_allHiPassFilters = {}         
    local tbl_allLoPassFilters = {}
    for i,v in ipairs(allCycPerLet) do
        tbl_allBandNoiseFilters[i] = {filterType = 'band', cycPerLet_centFreq = v,   applyFourierMaskGainFactor = applyGainFactor_band}
        tbl_allHiPassFilters[i]    = {filterType = 'hi',   cycPerLet_cutOffFreq = v, applyFourierMaskGainFactor = applyGainFactor_hiLo}
        tbl_allLoPassFilters[i]    = {filterType = 'lo',   cycPerLet_cutOffFreq = v, applyFourierMaskGainFactor = applyGainFactor_hiLo}
    end
    local tbl_allBandHiLoNoiseFilters = table.merge(tbl_allBandNoiseFilters, tbl_allHiPassFilters, tbl_allLoPassFilters)
    local tbl_allHiLoNoiseFilters = table.merge(tbl_allHiPassFilters, tbl_allLoPassFilters)
    
    
    --local allPinkNoise_exp = {1, 1.5, 2}
    --local allPinkNoise_exp = {1, 1.7, 1.6, 1.5}
    --local allPinkNoise_exp = {1, 1.6, 1.7}
    local allPinkNoise_exp = {1, 1.6, 2.0}
    --local allPinkNoise_exp = {1, 1.2, 1.4, 1.6, 1.8, 2.0}
    
    local allPinkWhiteRatios = {0.5, 1, 2}
    --local allF_exp_stds = {0, 0.2, 0.3}
    local allF_exp_stds = {0}
    
    
    local f_exp_pink = 1;
    
    --allPinkNoise_exp = {1}
    --local allBandNoise_cycPerLet = {0.5}
    
    local tbl_allPinkNoiseFilters = expandOptionsToList(
        {filterType = '1/f',  tbl_f_exp = allPinkNoise_exp, applyFourierMaskGainFactor = applyGainFactor_pink} )
    local tbl_allPinkOrWhiteNoiseFilters = expandOptionsToList(
        {filterType = '1/fOwhite',  f_exp = f_exp_pink, tbl_ratio = allPinkWhiteRatios, applyFourierMaskGainFactor = applyGainFactor_pink} )
    local tbl_allPinkPlusWhiteNoiseFilters = expandOptionsToList(
        {filterType = '1/fPwhite',  f_exp = f_exp_pink, tbl_ratio = allPinkWhiteRatios, applyFourierMaskGainFactor = applyGainFactor_pink} )
    local tbl_allPinkWideNoiseFilters = expandOptionsToList(
        {filterType = '1/f',  tbl_f_exp = allPinkNoise_exp, tbl_f_exp_std = allF_exp_stds, applyFourierMaskGainFactor = applyGainFactor_pink} )
               
    
    local whiteNoiseFilter = {filterType = 'white'}
    
    --local tbl_allPinkNoises = table.merge(tbl_allPinkNoiseFilters, tbl_allPinkOrWhiteNoiseFilters, tbl_allPinkPlusWhiteNoiseFilters, whiteNoiseFilter)
    --local tbl_allPinkNoises = table.merge(tbl_allPinkNoiseFilters, tbl_allPinkOrWhiteNoiseFilters, whiteNoiseFilter)
    
    local tbl_whiteNoiseAndPinkNoises = table.merge(tbl_allPinkNoiseFilters, whiteNoiseFilter)
    
    
    local tbl_whiteNoiseAndPinkOrWhiteNoises = table.merge(tbl_allPinkNoiseFilters[1], tbl_allPinkOrWhiteNoiseFilters, tbl_allPinkPlusWhiteNoiseFilters, whiteNoiseFilter)
    
    
    --tbl_allPinkNoises = table.merge(tbl_allPinkNoiseFilters)
    --local tbl_allPinkNoises = {whiteNoiseFilter}
    
    --local tbl_wiggleSettings = {}
    local tbl_trainingWiggle
    
    local allBlurs = {0}
    
   
   
    local tbl_fontNames, allSNRs_test, tbl_OriXY, tbl_imageSize, tbl_sizeStyle, tbl_imageSize_and_sizeStyle, tbl_imageSize_and_sizeStyle_and_OriXY
    local tbl_noiseFilter, tbl_trainingNoise, tbl_retrainingNoise, tbl_trainingFonts, tbl_retrainFromLayer, tbl_secondRetrainFromLayer, tbl_classifierForEachFont, tbl_trainingOriXY
    local xrange, trainPositions, testPositions, tbl_xrange_and_trainPositions_and_testPositions
    local allMultiLetterTestOpts_tbl
    
    local tbl_trainingImageSize, tbl_realData_fontNames
    local loopKeysOrder_dataOpts 
    
    if expName == 'ChannelTuning' then
        print('Channel Tuning Experiment')
        tbl_fontNames = { {'Bookman'}  }
        --tbl_fontNames = { {'Bookman'}, {'BookmanU'}, {'BookmanB'}, {'BookmanUB'}, {'Helvetica'}, {'HelveticaU'}, } 
        --tbl_fontNames = { {'Bookman'}, {'BookmanU'}, } 
        
        --tbl_fontNames = { {'Bookman'}, {'Braille'}, {'Sloan'}, {'Helvetica'}, {'Yung'}, {'KuenstlerU'} }
        if channels_trainOn == 'RealData' then
                --tbl_fontNames = { {'SVHN'}  }              --TRAIN ON SVHN
                if doTextureModel then
                    channels_realData_imageSize_train = {64, 64}
                    local all_realData_opts = expandOptionsToList({imageSize = channels_realData_imageSize_train, 
                                            globalNorm = true, 
                                            tbl_localContrastNorm = {true},
                                            tbl_scaleMethod = {'tile', 'pad', 'fourier'} } )
                                    
                    tbl_realData_fontNames = expandOptionsToList( 
                        {tbl_fonts = channels_realDataName, tbl_realData_opts= all_realData_opts} )
                else
                    tbl_realData_fontNames = { {fonts = channels_realDataName, realData_opts = channels_realData_settings_noNorm}, 
                                               --{fonts = channels_realDataName, realData_opts = channels_realData_settings_norm}, 
                                        }

                                        
                end
        end
        
            
        
        tbl_OriXY = { getXYset(1,1,1) }
        if doTextureModel then
            tbl_OriXY = { getXYset(1,1,1) }
        end
        
      
        
        --tbl_imageSize_and_sizeStyle_and_OriXY =  {  {{64, 64}, 'k36',  getXYset(1, 1, 1) }, }
        
        --local channels_train_noiseFilters = tbl_whiteNoiseAndPinkOrWhiteNoises
        --local channels_train_noiseFilters = tbl_allPinkWideNoiseFilters
        local channels_train_noiseFilters = tbl_whiteNoiseAndPinkNoises
        
        
        if channelTuningStage == 'train' then
            
            if channels_trainOn == 'RealData' then
                tbl_fontNames = tbl_realData_fontNames
                 allSNRs_test = {0}
                
            elseif channels_trainOn == 'PinkNoise' then
                --tbl_fontNames = channelFonts
                tbl_noiseFilter = channels_train_noiseFilters  -- TRAIN ON PINK (and/or WHITE) NOISES
                
                tbl_trainingNoise = {'same'}
                allSNRs_test = table.range(-1, 5,  0.5);
            end
            
        elseif channelTuningStage == 'retrain' then  -- e.g retrain on white noise (after training on SVHN), before testing on band noise
            tbl_OriXY = nil
            if channelTuningRetrainOn == 'white' then
                --channels_realData_imageSize_retrain = {64, 64}
                tbl_noiseFilter = {whiteNoiseFilter}
                
                tbl_imageSize_and_sizeStyle_and_OriXY =  {  {{64, 64}, 'k36',  getXYset(8, 11, 1) } }
                tbl_retrainFromLayer = {'conv5', 'conv4', 'conv3', 'linear'}
                
                --tbl_
                
                
            end
            
        elseif channelTuningStage == 'test' then
            
            if channelTuningTestOn == 'hiLo' then
                tbl_noiseFilter = tbl_allHiLoNoiseFilters    -- TEST ON HI/LO NOISE (after being trained on PINK NOISE or SVHN)
                 allSNRs_test = table.range(-3, 5,  0.5);
            
            elseif channelTuningTestOn == 'band' then
                tbl_noiseFilter = tbl_allBandNoiseFilters    -- TEST ON BAND  NOISE (after being trained on PINK NOISE or SVHN)    
                --tbl_noiseFilter = {whiteNoiseFilter}         -- RETRAIN ON WHITE NOISE
                 allSNRs_test = table.range(-1, 5,  0.5);
            end
            
            
            
            if channels_trainOn == 'RealData' then 
                tbl_trainingFonts = tbl_realData_fontNames
                tbl_trainingNoise = {'same'}
                
                --tbl_trainingImageSize = { channels_realData_imageSize_train } -- this is done automatically
                --tbl_retrainFromLayer = {'classifier'}
                --tbl_retrainFromLayer = {'classifier', 'linear'}
                if doTextureModel then
                    tbl_retrainFromLayer = {'linear-2', 'classifier'}
                else
                    --tbl_retrainFromLayer = {'linear', 'conv3'}
                    --tbl_retrainFromLayer = {'linear', 'conv3', 'conv5'}
                    --tbl_retrainFromLayer =  {'conv1'} -- {'conv2', 'conv3', 'linear'} -- {'conv1'}
                    
                    if channelTuningRetrainOn == 'white' then
                        
                        tbl_retrainingNoise = {whiteNoiseFilter}
                        --tbl_retrainFromLayer = nil  -- already trained on letters (in white noise). now just test
                        --tbl_retrainFromLayer = {'conv5', 'conv4', 'conv3', 'linear'}
                        tbl_retrainFromLayer = {'conv3'}
                        tbl_secondRetrainFromLayer = {'linear'}
                    elseif channelTuningRetrainOn == '' then
                        
                        tbl_retrainFromLayer = {'conv5', 'conv4', 'conv3', 'linear'}
                    end
                    
                    
                end
            
            
            
            elseif channels_trainOn == 'PinkNoise' then
                tbl_trainingNoise = channels_train_noiseFilters 
                
                --tbl_retrainFromLayer = {'', 'classifier', 'linear'}
                --tbl_retrainFromLayer = {'classifier', ''}
                --tbl_retrainFromLayer = {''}
                tbl_retrainFromLayer = {'linear'}
            end            
            loopKeysOrder_dataOpts  = { 'noiseFilter', 'OriXY', };
            
            

            if channels_imageSize_test[1] == 30 then
                tbl_imageSize_and_sizeStyle =  {  {{30, 30}, 'k15'} }
            elseif channels_imageSize_test[1] == 32 then
                tbl_imageSize_and_sizeStyle =  {  {{32, 32}, 'k15'}, {{32, 32}, 'k20'}  }
            elseif channels_imageSize_test[1] == 36 then
                tbl_imageSize_and_sizeStyle =  {  {{36, 36}, 'k20'} }
            elseif channels_imageSize_test[1] == 45 then
                --tbl_imageSize_and_sizeStyle =  {   {{45, 45}, 'k30'} , {{45, 45}, 'k15'}}
                tbl_imageSize_and_sizeStyle =  {   {{45, 45}, 'k30'} }
            elseif channels_imageSize_test[1] == 64 then
                --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k32'}  }
                --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k36'} }
                --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k15'} }
                --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k24'} }

                tbl_imageSize_and_sizeStyle_and_OriXY =  {  {{64, 64}, 'k36',  getXYset(8, 11, 1) },
                  --                                          {{64, 64}, 'k24',  getXYset(27, 28, 1) }, 
                                                        }

            end
            
            
        end 

        
        
        
        
        

    elseif expName == 'Uncertainty' then
        print('Uncertainty Experiment')
        --tbl_fontNames = { Bookman_rBIJ, mrh_rBIJ, {'Bookman'},  }
        
        --tbl_fontNames = table.merge( { allStdFontNames, 
                                   --{fonts = {'Bookman'}, styles = styles_use},  
                                   --{fonts = {'KuenstlerU'}, styles = styles_use}, 
                                   --{fonts = {'Braille'}, styles = styles_use} 
          --                       } )
    
        --tbl_fontNames = expandOptionsToList( { tbl_fonts = allStdFontNames_tbl,       
          --                                     tbl_styles = {styles_use, {'Roman'}} } ) 
        
        tbl_fontNames = { {'Bookman'}, {'Sloan'} }
        
        --allSNRs_test = {0, 1, 2, 3, 4}
        allSNRs_test = table.range(0, 5,  0.5);
        
        tbl_OriXY = { oriXYSet_long_32_128_dx5, oriXYSet_long_32_128_dx5_ori, oriXYSet_long_32_128_dx10, oriXYSet_long_32_128_dx10_ori }
        
          --tbl_OriXY = { getXYset(1,1,1) }, 
          --tbl_OriXY = { getXYset(1,1,1), oriXYSet_large_48_k14}, 
          --tbl_OriXY  = { oriXYSet_long_32_128_dx2_ori }, 
          --tbl_OriXY = { oriXYSet_long_32_128_dx5, oriXYSet_long_32_128_dx5_ori, oriXYSet_long_32_128_dx10, oriXYSet_long_32_128_dx10_ori }, 
        --tbl_imageSize = { {32, 128}  }
        
        tbl_imageSize = { {64, 64}  }
        --tbl_imageSize = { {32, 160}  }
        
        --tbl_sizeStyle = {'k16'}
        tbl_sizeStyle = {'k15'}
 
        --[[
        local oriXYSet_3x1y_d1  = {Nori = 1,  dOri = 0,    Nx = 3, dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_5x1y_d1  = {Nori = 1,  dOri = 0,    Nx = 5, dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_15x1y_d1 = {Nori = 1,  dOri = 0,    Nx = 15, dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_30x1y_d1 = {Nori = 1,  dOri = 0,    Nx = 30, dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_15x2y_d1 = {Nori = 1,  dOri = 0,    Nx = 15, dX = 1,   Ny = 2, dY = 1}
        local oriXYSet_3x5y_d1  = {Nori = 1,  dOri = 0,    Nx = 3, dX = 1,   Ny = 5, dY = 1}
        local oriXYSet_5x3y_d1  = {Nori = 1,  dOri = 0,    Nx = 5, dX = 1,   Ny = 3, dY = 1}
        local oriXYSet_2x15y_d1 = {Nori = 1,  dOri = 0,    Nx = 2, dX = 1,   Ny = 15, dY = 1}
        local oriXYSet_1x30y_d1 = {Nori = 1,  dOri = 0,    Nx = 1, dX = 1,   Ny = 30, dY = 1}
        
        tbl_OriXY = { getXYset(1,1,1), oriXYSet_3x1y_d1, oriXYSet_5x1y_d1, oriXYSet_15x1y_d1, oriXYSet_30x1y_d1, 
                        oriXYSet_15x2y_d1, oriXYSet_3x5y_d1, oriXYSet_5x3y_d1, oriXYSet_2x15y_d1, oriXYSet_1x30y_d1 };
    --]]
    
    
    --[[
        local oriXYSet_3x_d3  = {Nori = 1,  dOri = 0,    Nx = 3,  dX = 3,   Ny = 1, dY = 0}
        local oriXYSet_7x_d3  = {Nori = 1,  dOri = 0,    Nx = 7,  dX = 3,   Ny = 1, dY = 0}
        local oriXYSet_15x_d3 = {Nori = 1,  dOri = 0,    Nx = 15, dX = 3,   Ny = 1, dY = 0}
        local oriXYSet_20x_d3 = {Nori = 1,  dOri = 0,    Nx = 20, dX = 3,   Ny = 1, dY = 0}
        local oriXYSet_30x_d3 = {Nori = 1,  dOri = 0,    Nx = 30, dX = 3,   Ny = 1, dY = 0}
        local oriXYSet_45x_d3 = {Nori = 1,  dOri = 0,    Nx = 45, dX = 3,   Ny = 1, dY = 0}
               
       tbl_OriXY = {getXYset(1,1,1), oriXYSet_3x_d3, oriXYSet_7x_d3, oriXYSet_15x_d3, oriXYSet_20x_d3, 
                    oriXYSet_30x_d3, oriXYSet_45x_d3};
--]]

        local oriXYSet_1x_d1      = {Nori = 1,  dOri = 0,    Nx = 1,  dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_2x1y_d1    = {Nori = 1,  dOri = 0,    Nx = 2,  dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_3x1y_d1    = {Nori = 1,  dOri = 0,    Nx = 3,  dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_5x1y_d1    = {Nori = 1,  dOri = 0,    Nx = 5,  dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_11x1y_d1   = {Nori = 1,  dOri = 0,    Nx = 11,  dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_25x1y_d1   = {Nori = 1,  dOri = 0,    Nx = 25,  dX = 1,   Ny = 1, dY = 1}
        local oriXYSet_5x5_d1     = {Nori = 1,  dOri = 0,    Nx = 5,  dX = 1,   Ny = 5, dY = 1}
        local oriXYSet_11x5y_d1   = {Nori = 1,  dOri = 0,    Nx = 11,  dX = 1,   Ny = 5, dY = 1}
        local oriXYSet_25x5y_d1   = {Nori = 1,  dOri = 0,    Nx = 25,  dX = 1,   Ny = 5, dY = 1}
        local oriXYSet_25x11y_d1  = {Nori = 1,  dOri = 0,    Nx = 25,  dX = 1,   Ny = 11, dY = 1}
        local oriXYSet_22x28y_d1  = {Nori = 1,  dOri = 0,    Nx = 22,  dX = 1,   Ny = 28, dY = 1}
        local oriXYSet_37x37y_d1  = {Nori = 1,  dOri = 0,    Nx = 37,  dX = 1,   Ny = 37, dY = 1}

               

        tbl_OriXY = {getXYset(1,1,1), oriXYSet_2x1y_d1, oriXYSet_3x1y_d1, oriXYSet_5x1y_d1 , oriXYSet_11x1y_d1 , oriXYSet_25x1y_d1, oriXYSet_5x5_d1,
                    oriXYSet_11x5y_d1,  oriXYSet_25x5y_d1 ,oriXYSet_25x11y_d1 , oriXYSet_22x28y_d1, oriXYSet_37x37y_d1 }

        tbl_OriXY = {getXYset(1,1,1), oriXYSet_11x1y_d1 , oriXYSet_25x5y_d1, oriXYSet_37x37y_d1 }

   
   
        local all_realData_opts = {imageSize = {32, 32}, globalNorm = true, localContrastNorm = false}
                    
        tbl_realData_fontNames = expandOptionsToList( {fonts = 'SVHN', tbl_realData_opts= {all_realData_opts} } )
        
        --tbl_trainingFonts = {tbl_realData_fontNames[1], 'same'}
        tbl_trainingFonts = { 'same'}
        tbl_retrainFromLayer = {'linear'}
        
        loopKeysOrder_dataOpts  = {'OriXY', 'fontName', 'trainingFonts'  };
    
    
    elseif expName == 'Complexity' then
        
        print('Efficiency Vs Complexity Experiment')
        --tbl_fontNames = { {'Bookman', 'Courier'}  }
        
        
        
        --tbl_fontNames = allStdFontNames
        --tbl_fontNames = allStdFontNames2
        
        --tbl_fontNames = {{allStdFontNames}, {allStdFontNames2}}
        --tbl_fontNames = allExtFontNames
        tbl_fontNames = {allStdFontNames}
        --tbl_fontNames = table.merge(allStdFontNames, {allStdFontNames})
        
        if doOnlyBookman then
            tbl_fontNames = { 'Bookman'}
        end
        
            
        if complexity_trainOn == 'RealData' then
            
            if doTextureModel then
                complexity_realData_imageSize_train = {64, 64}
                local all_realData_opts = expandOptionsToList({imageSize = complexity_realData_imageSize_train, 
                                        globalNorm = true, 
                                        tbl_localContrastNorm = {false, true},
                                        tbl_scaleMethod = {'tile', 'pad', 'fourier'} } )
                
                tbl_realData_fontNames = expandOptionsToList( {fonts = complexity_realDataName, 
                                                               tbl_realData_opts= all_realData_opts} )
            else
                tbl_realData_fontNames = 
                    { {fonts = 'SVHN',    realData_opts = channels_realData_settings_noNorm}, 
                      --{fonts = 'CIFAR10', realData_opts = channels_realData_settings_noNorm}, 
                      --{fonts = complexity_realDataName, realData_opts = channels_realData_settings_norm}, 
                    }
            end

            
            if complexityStage == 'train' then
                tbl_fontNames = tbl_realData_fontNames
                tbl_noiseFilter = {whiteNoiseFilter}
                tbl_trainingNoise = {'same'}
                
            elseif complexityStage == 'test' then
                tbl_trainingFonts = tbl_realData_fontNames
                
                tbl_noiseFilter = {whiteNoiseFilter}
                --tbl_retrainFromLayer = {'classifier', 'linear'}
                --tbl_retrainFromLayer = {'linear'}
                --tbl_retrainFromLayer = {'linear-2', 'classifier'}
                tbl_retrainFromLayer = {'conv3', 'conv5', 'conv4', 'linear'}
                
                loopKeysOrder_dataOpts  = {'fontName', 'trainingFonts', };
            end
            
            
        elseif complexity_trainOn == 'PinkNoise' then
            if complexityStage == 'train' then
                tbl_noiseFilter =  tbl_whiteNoiseAndPinkOrWhiteNoises 
                tbl_trainingNoise = {'same'}
                
            elseif complexityStage == 'test' then
                tbl_trainingNoise = tbl_whiteNoiseAndPinkOrWhiteNoises 
                tbl_noiseFilter = {whiteNoiseFilter}
                tbl_retrainFromLayer = {'', 'classifier', 'linear'}
                
                loopKeysOrder_dataOpts  = {'fontName', 'OriXY', 'trainingNoise'};
            end
            
        elseif complexity_trainOn == 'WhiteNoise' then
            tbl_trainingNoise = {whiteNoiseFilter}
            tbl_noiseFilter = {whiteNoiseFilter}
            tbl_retrainFromLayer = {''}
            
        end
        
            
            
        --local complexity_imageSize = {32, 32}
        --local complexity_imageSize = {45, 45}
        --local complexity_imageSize = {56, 56}
        local complexity_imageSize = {64, 64}
        --local complexity_imageSize = {80, 80}
            
        --tbl_fontNames = table.merge( { allStdFontNames, {fonts=allStdFontNames}, } )
        --tbl_fontNames = table.merge( { allStdFontNames, {fonts=allStdFontNames} , {fonts=allStdFontNames, styles= styles_use} } )
        
        --allSNRs_test = {0, 1, 2, 2.5, 3, 4}
        --allSNRs_test = {0, 0.5, 1, 1.5, 2, 2.5, 3, 4}
        allSNRs_test = table.range(0, 5,  0.5);
        
        
        if doTextureModel then
            --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k32'} }
        end
        
        if complexity_imageSize[1] == 64 then
            --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k32'} }
            --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k24'} }
            --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k30'} }
            --tbl_imageSize_and_sizeStyle =  {  {{64, 64}, 'k15'}, {{64, 64}, 'k24'} }
            tbl_imageSize_and_sizeStyle_and_OriXY =  { -- {{64, 64}, 'k15',  getXYset(1, 1, 1) },
                                                        {{64, 64}, 'k15',  getXYset(30, 39, 1) }, 
                                                        {{64, 64}, 'k24',  getXYset(15, 26, 1) }, }
            tbl_OriXY = { getXYset(1,1,1) }
            
        elseif complexity_imageSize[1] == 32 then
            --tbl_imageSize_and_sizeStyle =  {  {{32, 32}, 'k15'} }
            tbl_imageSize_and_sizeStyle_and_OriXY =  { -- {{64, 64}, 'k15',  getXYset(1, 1, 1) },
                                                        --{{64, 64}, 'k15',  getXYset(30, 39, 1) }, 
                                                          {{32, 160}, 'k15',  getXYset(12, 1, 12) }, }
            
            
        end
        
        
        tbl_classifierForEachFont = {false}
        --allBlurs = {0, 1, 1.5, 2}
        --allBlurs = {0, 1, 2}
        allBlurs = {0}
        
        
        if (complexity_trainOn == 'RealData' and complexityStage == 'train') then
            tbl_OriXY = { getXYset(1,1,1) }
        end        

        loopKeysOrder_dataOpts  = {'fontName', 'OriXY' };
        
    elseif expName == 'Grouping' then
        
        print('Grouping Experiment')
                
                       
        local sloanTrainFonts = {{'Sloan'}, {'SloanO2'}, {'SloanT3'}}
        allSNRs_test = table.range(-1,  5,   0.5)
        
        if grouping_trainOn == 'sameWiggle' then
            --groupingStage = 'train'
        end
        
        local tbl_OriXY_forTraining
        
        
        tbl_OriXY_forTraining = { getXYset(1,1,1), oriXYSet_3x3y, oriXYSet_5x5y }
        --tbl_OriXY = { oriXYSet_9x9y7o }
        --tbl_OriXY_forTraining = { oriXYSet_10x10y11o }
        --tbl_OriXY_forTraining = { oriXYSet_10x10y21o }
        --tbl_OriXY_forTraining = { getXYset(1,1,1) }
        tbl_OriXY_forTraining = { oriXYSet_30x30y21o }
        --tbl_OriXY_forTraining = { oriXYSet_19x19y21o }
        
                

        
        
        --tbl_imageSize = { {32, 32}, {64, 64}  }
        --tbl_imageSize = { {32, 32},  }
        --tbl_imageSize = { {96, 96}  }
        tbl_imageSize = { {64, 64}  }
        --tbl_imageSize = { {96, 96}  }
        --tbl_imageSize = { {80, 80}  }
        --tbl_imageSize = { {40, 40}  }
        
        tbl_sizeStyle = { 'k55' }
        --tbl_sizeStyle = { 'k32' } 
        --tbl_sizeStyle = { 'k48' } 
        --tbl_sizeStyle = { 'k27' } 
        tbl_sizeStyle = nil
        
        tbl_imageSize_and_sizeStyle_and_OriXY =  { -- {{64, 64}, 'k15',  getXYset(1, 1, 1) },
                                            {{64, 64}, 'k23',  getXYset(38, 38, 1) }, 
                                            {{64, 64}, 'k32',  getXYset(30, 28, 1) }, }

        
        local doNoWiggle = true
        local doOriWiggle    = true
        local doOffsetWiggle = false
        local doPhaseWiggle  = false
        --local wiggleType = 'offset'
        --local wiggleType = 'phase'
        
        local doMult = false and (sys.memoryAvailable()/1024 > 40)
        
        local oriAngles, offsetAngles, phaseAngles
        if doMult then
            oriAngles    = table.merge( {table.range(10, 90, 10), {table.range(0, 60, 10)} } )
            offsetAngles = table.merge( {table.range(10, 60, 10), {table.range(0, 60, 10)} } )
            phaseAngles = table.merge( {{1}, {{0, 1}}} )
        else
            oriAngles   = table.range(grouping_dWiggle, 90, grouping_dWiggle)
            offsetAngles = table.range(grouping_dWiggle, 60, grouping_dWiggle)
            phaseAngles = table.range(10, 10, 10)
        end
        
        
        
        local wiggleSettings_none, wiggleSettings_ori, wiggleSettings_offset, wiggleSettings_phase = {}, {}, {}, {}
        if doNoWiggle then
            wiggleSettings_none    = { none = 1 }
        end
        if doOriWiggle then
            wiggleSettings_ori     = expandOptionsToList( { tbl_orientation = oriAngles } )
        end
        if doOffsetWiggle then
            wiggleSettings_offset  = expandOptionsToList( { tbl_offset = offsetAngles } )
        end
        if doPhaseWiggle then
            wiggleSettings_phase   = expandOptionsToList( { tbl_phase = phaseAngles } )
        end
        local tbl_wiggleSettings = table.merge(wiggleSettings_none, wiggleSettings_ori, wiggleSettings_offset, wiggleSettings_phase)
                    
        
        
        local tbl_trainingWiggle_exp
        
        --tbl_wiggleSettings  = expandOptionsToList( { tbl_orientation = table.range(0, 30, 10) } )
        if grouping_trainOn == 'allWiggles' then
            assert(wiggleType)
            if wiggleType == 'orientation' then  
                tbl_trainingWiggle_exp  = { 'same', { orientation = oriAngles } }
            elseif wiggleType == 'offset' then   
                tbl_trainingWiggle_exp  = { 'same', { offset = offsetAngles } }
            elseif wiggleType == 'phase' then    
                tbl_trainingWiggle_exp  = { 'same', { phase = phaseAngles } }
            end
        elseif grouping_trainOn == 'noWiggle' then
            tbl_trainingWiggle_exp  = { wiggleSettings_none }
        else
            tbl_trainingWiggle_exp = {'same'}
        end
        
            if doTextureModel then
                    grouping_realData_imageSize_train = {64, 64}
                    local all_realData_opts = expandOptionsToList({imageSize = grouping_realData_imageSize_train, 
                                            globalNorm = true, 
                                            tbl_localContrastNorm = {false},
                                            tbl_scaleMethod = {'tile'} } )
                                            --tbl_localContrastNorm = {false, true},
                                            --tbl_scaleMethod = {'tile', 'pad', 'fourier'} } )
                    
                    tbl_realData_fontNames = expandOptionsToList( 
                        {fonts = grouping_realDataName, tbl_realData_opts= all_realData_opts} )
                else
                    tbl_realData_fontNames = { {fonts = grouping_realDataName, realData_opts = grouping_realData_settings}, 
                                           --{fonts = grouping_realDataName, realData_opts = grouping_realData_settings_norm}, 
                                        }
                end
        
        if groupingStage == 'train' then
        
            if grouping_trainOn == 'RealData' then
                tbl_fontNames = { {fonts = grouping_realDataName, realData_opts = grouping_realData_settings} }
                tbl_imageSize = { grouping_realData_settings.imageSize }
                tbl_OriXY         = { getXYset(1,1,1) }  
                
            else
                
                if grouping_trainOn == 'Sloan' then
                    tbl_fontNames = sloanTrainFonts  
                
                elseif grouping_trainOn == 'allWiggles' or grouping_trainOn == 'noWiggle' or grouping_trainOn == 'sameWiggle' then
                    tbl_fontNames = expandOptionsToList(  { fonts = {'Snakes'}, tbl_wiggles = tbl_trainingWiggle_exp  } )
                    
                end
                
                tbl_noiseFilter = tbl_whiteNoiseAndPinkOrWhiteNoises  -- TRAIN ON PINK (and/or WHITE) NOISES
                tbl_trainingNoise = {'same'} 
                tbl_OriXY = tbl_OriXY_forTraining
                
                --tbl_wiggleSettings = trainingWiggle -- train on training wiggle
                
            end
            
        elseif groupingStage == 'test' then
            
            tbl_fontNames = expandOptionsToList(  { fonts = {'Snakes'}, tbl_wiggles = tbl_wiggleSettings  } )
            
            if grouping_trainOn == 'RealData' then
                tbl_trainingNoise = {'same'}
                tbl_trainingFonts = tbl_realData_fontNames
                --tbl_trainingImageSize = { grouping_realData_settings.imageSize } -- this is done automatically
                --tbl_OriXY         = { getXYset(1,1,1), oriXYSet_5x5y11o, oriXYSet_10x10y21o } 
                --tbl_OriXY         = { oriXYSet_5x5y11o_d2, oriXYSet_41o, oriXYSet_7x7y, getXYset(1,1,1), oriXYSet_5x5y11o,  }
                                
             --   tbl_OriXY         = { getXYset(1,1,1), oriXYSet_2x2y_d1, 
                    --                    oriXYSet_4x4y_d1, oriXYSet_8x8y_d1, oriXYSet_16x16y_d1, oriXYSet_22x22y_d1}
                          
              
                tbl_OriXY = { getXYset(1,1,1), oriXYSet_15x15y_d1,    oriXYSet_7x7y_d2, oriXYSet_21x21y_d1, oriXYSet_10x10y_d2, 
                    oriXYSet_11o_15x15y_d1, oriXYSet_11o_7x7y_d2,  oriXYSet_11o_21x21y_d1, oriXYSet_11o_10x10y_d2 };

                
                
            else                
                
                if grouping_trainOn == 'Sloan' then
                    tbl_trainingFonts = sloanTrainFonts
                    
                elseif grouping_trainOn == 'allWiggles' or grouping_trainOn == 'noWiggle' then
                    tbl_trainingWiggle = tbl_trainingWiggle_exp
                    
                end
                
                --tbl_trainingNoise = tbl_whiteNoiseAndPinkOrWhiteNoises     
                tbl_trainingNoise = {whiteNoiseFilter}
            
                --tbl_OriXY         = { getXYset(1,1,1), oriXYSet_10x10y21o }
                tbl_OriXY         = tbl_OriXY_forTraining -- { oriXYSet_19x19y21o }
                tbl_trainingOriXY = {'same'}
                
                --tbl_OriXY         = { getXYset(1,1,1)}
            end
            tbl_noiseFilter = { whiteNoiseFilter }
            
            --tbl_retrainFromLayer = {'classifier', '', 'linear'}
            --tbl_retrainFromLayer = {'classifier', 'linear'}
            --tbl_retrainFromLayer = {'linear'}
            --tbl_retrainFromLayer = {'linear', 'linear-2'}
            --tbl_retrainFromLayer = {'linear', 'conv3', 'conv5'}
            tbl_retrainFromLayer = {'conv5', 'linear', 'conv4', 'conv3'}
            --tbl_retrainFromLayer = {''}
            
            --tbl_OriXY         = { getXYset(1,1,1) }
            
            
            loopKeysOrder_dataOpts  = {'OriXY', 'fontName'};
            
            
        end  -- if groupingStage == 'train' or 'test'
        
        
        --tbl_OriXY = {getXYset(1,1,1),  oriXYSet_3o_d5, oriXYSet_13o_d5, oriXYSet_21o_d2,   oriXYSet_25o_d5 };
        --[[
        
        local oriXYSet_15x19y_d1_3o_d5  = {Nori = 3,  dOri = 5,    Nx = 15, dX = 1,   Ny = 19, dY = 1}
        local oriXYSet_15x19y_d1_7o_d5  = {Nori = 7,  dOri = 5,    Nx = 15, dX = 1,   Ny = 19, dY = 1}
        local oriXYSet_15x19y_d1_21o_d2 = {Nori = 21, dOri = 2,    Nx = 15, dX = 1,   Ny = 19, dY = 1}
        local oriXYSet_15x19y_d1_11o_d1 = {Nori = 11, dOri = 1,    Nx = 15, dX = 1,   Ny = 19, dY = 1}
        local oriXYSet_15x19y_d1_31o_d1 = {Nori = 31, dOri = 1,    Nx = 15, dX = 1,   Ny = 19, dY = 1}
        
        tbl_OriXY = { getXYset(1,1,1), oriXYSet_15x19y_d1,  oriXYSet_15x19y_d1_3o_d5, oriXYSet_15x19y_d1_7o_d5, 
                             oriXYSet_15x19y_d1_21o_d2, oriXYSet_15x19y_d1_11o_d1, oriXYSet_15x19y_d1_31o_d1}        
        --]]
        
        --[[
        --local oriXYSet_15x19y_d1        = {Nori = 1,  dOri = 0,    Nx = 15, dX = 1,   Ny = 19, dY = 1}
        --local oriXYSet_22x26y_d1        = {Nori = 1,  dOri = 0,    Nx = 22, dX = 1,   Ny = 26, dY = 1}
        local oriXYSet_22x26y_d1_21o_d1 = {Nori = 21, dOri = 1,    Nx = 22, dX = 1,   Ny = 26, dY = 1}
        local oriXYSet_22x26y_d1_41o_d1 = {Nori = 41, dOri = 1,    Nx = 22, dX = 1,   Ny = 26, dY = 1}
                           
        --tbl_OriXY = { getXYset(1,1,1), oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, oriXYSet_22x26y_d1_21o_d1, 
          --                              oriXYSet_22x26y_d1_41o_d1};
--]]
---[[
        local oriXYSet_15x19y_d1        = {Nori = 1,  dOri = 0,    Nx = 15, dX = 1,   Ny = 19, dY = 1}
        local oriXYSet_22x26y_d1        = {Nori = 1,  dOri = 0,    Nx = 22, dX = 1,   Ny = 26, dY = 1}
        local oriXYSet_31x36y_d1        = {Nori = 1,  dOri = 0,    Nx = 31, dX = 1,   Ny = 36, dY = 1}
        local oriXYSet_45x47y_d1        = {Nori = 1,  dOri = 0,    Nx = 45, dX = 1,   Ny = 47, dY = 1}
        local oriXYSet_45x47y_d1_21o_d1 = {Nori = 21, dOri = 1,    Nx = 45, dX = 1,   Ny = 47, dY = 1}
        local oriXYSet_45x47y_d1_41o_d1 = {Nori = 41, dOri = 1,    Nx = 45, dX = 1,   Ny = 47, dY = 1}
        local oriXYSet_7x7y_d1          = {Nori = 1,  dOri = 0,    Nx = 7,  dX = 1,   Ny = 7,  dY = 1}
                   

        --tbl_OriXY = { oriXYSet_45x47y_d1, oriXYSet_31x36y_d1, oriXYSet_22x26y_d1, oriXYSet_15x19y_d1, getXYset(1,1,1),
          --             };
    
        --tbl_OriXY = { oriXYSet_15x19y_d1, getXYset(1,1,1) };
        --tbl_OriXY = { oriXYSet_7x7y_d1, getXYset(1,1,1) };
        --tbl_OriXY = { oriXYSet_15x19y_d1 };   -- standard for k32 in 64x64
        --tbl_OriXY = { oriXYSet_7x7y_d1};  -- standardd for k55 in 64x64
    
    --]]
    
                   --[[
        tbl_OriXY = { getXYset(1,1,1), oriXYSet_15x19y_d1,  oriXYSet_22x26y_d1, oriXYSet_31x36y_d1, 
                       oriXYSet_45x47y_d1, oriXYSet_45x47y_d1_21o_d1, oriXYSet_45x47y_d1_41o_d1};
        
        local oriXYSet_2x_d1        = {Nori = 1,  dOri = 0,    Nx = 2, dX = 1,   Ny = 1, dY = 0}
        local oriXYSet_2x_d2        = {Nori = 1,  dOri = 0,    Nx = 2, dX = 2,   Ny = 1, dY = 0}
        local oriXYSet_2x_d3        = {Nori = 1,  dOri = 0,    Nx = 2, dX = 3,   Ny = 1, dY = 0}
        local oriXYSet_2x_d4        = {Nori = 1,  dOri = 0,    Nx = 2, dX = 4,   Ny = 1, dY = 0}
        local oriXYSet_2x_d6        = {Nori = 1,  dOri = 0,    Nx = 2, dX = 6,   Ny = 1, dY = 0}
        local oriXYSet_2x_d8        = {Nori = 1,  dOri = 0,    Nx = 2, dX = 8,   Ny = 1, dY = 0}
        local oriXYSet_2x_d16       = {Nori = 1,  dOri = 0,    Nx = 2, dX = 16,  Ny = 1, dY = 0}
                             
         tbl_OriXY = {oriXYSet_2x_d1, oriXYSet_2x_d2, oriXYSet_2x_d3, 
             oriXYSet_2x_d4, oriXYSet_2x_d6, oriXYSet_2x_d8, oriXYSet_2x_d16};
        --]]
    
    --[[
        local oriXYSet_24x24y_d1        = {Nori = 1,  dOri = 0,    Nx = 24, dX = 1,   Ny = 24, dY = 1}
        local oriXYSet_26x26y_d1        = {Nori = 1,  dOri = 0,    Nx = 26, dX = 1,   Ny = 26, dY = 1}
        local oriXYSet_28x28y_d1        = {Nori = 1,  dOri = 0,    Nx = 28, dX = 1,   Ny = 28, dY = 1}
        local oriXYSet_12x12y_d2        = {Nori = 1,  dOri = 0,    Nx = 12, dX = 2,   Ny = 12, dY = 2}
        local oriXYSet_6x6y_d4          = {Nori = 1,  dOri = 0,    Nx = 6,  dX = 4,   Ny = 6,  dY = 4}
        local oriXYSet_4x4y_d6          = {Nori = 1,  dOri = 0,    Nx = 4,  dX = 6,   Ny = 4,  dY = 6}
        
        tbl_OriXY = {oriXYSet_24x24y_d1, oriXYSet_26x26y_d1, oriXYSet_28x28y_d1, 
                        oriXYSet_12x12y_d2, oriXYSet_6x6y_d4, oriXYSet_4x4y_d6};
                     
        --]]
        
        --[[
        local oriXYSet_38x38y_d1        = {Nori = 1,  dOri = 0,    Nx = 38, dX = 1,   Ny = 38, dY = 1}
        local oriXYSet_39x39y_d1        = {Nori = 1,  dOri = 0,    Nx = 39, dX = 1,   Ny = 39, dY = 1}
        local oriXYSet_40x40y_d1        = {Nori = 1,  dOri = 0,    Nx = 40, dX = 1,   Ny = 40, dY = 1}
        local oriXYSet_41x41y_d1        = {Nori = 1,  dOri = 0,    Nx = 41, dX = 1,   Ny = 41, dY = 1}
        local oriXYSet_42x42y_d1        = {Nori = 1,  dOri = 0,    Nx = 42, dX = 1,   Ny = 42, dY = 1}
        local oriXYSet_43x43y_d1        = {Nori = 1,  dOri = 0,    Nx = 43, dX = 1,   Ny = 43, dY = 1}
        local oriXYSet_44x44y_d1        = {Nori = 1,  dOri = 0,    Nx = 44, dX = 1,   Ny = 44, dY = 1}
                    
                   
        --tbl_OriXY = { oriXYSet_38x38y_d1, oriXYSet_40x40y_d1,  oriXYSet_42x42y_d1}
                                       
        local oriXYSet_40x40y_d1_3ori_d5        = {Nori = 3,  dOri = 5,    Nx = 40, dX = 1,   Ny = 40, dY = 1}
        local oriXYSet_41x41y_d1_3ori_d5        = {Nori = 3,  dOri = 5,    Nx = 41, dX = 1,   Ny = 41, dY = 1}
        local oriXYSet_42x42y_d1_3ori_d5        = {Nori = 3,  dOri = 5,    Nx = 42, dX = 1,   Ny = 42, dY = 1}
        local oriXYSet_43x43y_d1_3ori_d5        = {Nori = 3,  dOri = 5,    Nx = 43, dX = 1,   Ny = 43, dY = 1}
        local oriXYSet_44x44y_d1_3ori_d5        = {Nori = 3,  dOri = 5,    Nx = 44, dX = 1,   Ny = 44, dY = 1}
                                       
        local oriXYSet_40x40y_d1_11ori_d1        = {Nori = 11,  dOri = 1,    Nx = 40, dX = 1,   Ny = 40, dY = 1}
        local oriXYSet_41x41y_d1_11ori_d1        = {Nori = 11,  dOri = 1,    Nx = 41, dX = 1,   Ny = 41, dY = 1}
        local oriXYSet_42x42y_d1_11ori_d1        = {Nori = 11,  dOri = 1,    Nx = 42, dX = 1,   Ny = 42, dY = 1}
        local oriXYSet_43x43y_d1_11ori_d1        = {Nori = 11,  dOri = 1,    Nx = 43, dX = 1,   Ny = 43, dY = 1}
        local oriXYSet_44x44y_d1_11ori_d1        = {Nori = 11,  dOri = 1,    Nx = 44, dX = 1,   Ny = 44, dY = 1}
                    
        
        tbl_OriXY = { oriXYSet_40x40y_d1,  oriXYSet_41x41y_d1, oriXYSet_42x42y_d1, oriXYSet_43x43y_d1, oriXYSet_44x44y_d1, 
            oriXYSet_40x40y_d1_3ori_d5,  oriXYSet_41x41y_d1_3ori_d5, oriXYSet_42x42y_d1_3ori_d5, oriXYSet_43x43y_d1_3ori_d5, oriXYSet_44x44y_d1_3ori_d5, 
            oriXYSet_40x40y_d1_11ori_d1,  oriXYSet_41x41y_d1_11ori_d1, oriXYSet_42x42y_d1_11ori_d1, oriXYSet_43x43y_d1_11ori_d1, oriXYSet_44x44y_d1_11ori_d1}
        --]]
        --[[
        local oriXYSet_24x24y_d1_3ori_d5= {Nori = 3,  dOri = 5,    Nx = 24, dX = 1,   Ny = 24, dY = 1}
        local oriXYSet_24x24y_d1        = {Nori = 1,  dOri = 0,    Nx = 24, dX = 1,   Ny = 24, dY = 1}
        local oriXYSet_26x26y_d1        = {Nori = 1,  dOri = 0,    Nx = 26, dX = 1,   Ny = 26, dY = 1}
        local oriXYSet_28x28y_d1        = {Nori = 1,  dOri = 0,    Nx = 28, dX = 1,   Ny = 28, dY = 1}
        local oriXYSet_12x12y_d2        = {Nori = 1,  dOri = 0,    Nx = 12, dX = 2,   Ny = 12, dY = 2}
        
        tbl_OriXY = {oriXYSet_24x24y_d1_3ori_d5, oriXYSet_24x24y_d1, oriXYSet_26x26y_d1, oriXYSet_28x28y_d1, 
                        oriXYSet_12x12y_d2};
                     
        --]]
                    
        
    elseif  expName == 'TrainingWithNoise' then
        print('Training With Noise Experiment')
        tbl_fontNames = { {'Bookman'}, {'KuenstlerU' } }
        tbl_imageSize = { {32, 32} }
        tbl_sizeStyle = { 'k16' }
        tbl_OriXY = { getXYset(1,1,1) }
        
        tbl_allSNRs_train = { {0}, {1}, {2}, {3}, {4},   {0, 1}, {1, 2}, {2, 3}, {3, 4},    {0, 1, 2}, {1, 2, 3}, {2, 3, 4},   
                                {0, 1, 2}, {.5, 1.5, 2.5}, {1, 2, 3}, {1.5, 2.5, 3.5}, {2, 3, 4}, 
                                {1, 1.5, 2, 2.5},  {1.5, 2, 2.5, 3}, {2, 2.5, 3, 3.5},
                                {1, 1.5, 2, 2.5, 3},  {1, 1.5, 2, 2.5, 3, 3.5}, {1, 2, 3, 4},   }
        --tbl_allSNRs_train = { {1}, {2}, {3}, {4}, }

        allSNRs_test = table.range(0, 4,   0.5)
    elseif expName == 'TestConvNet' then
        
        local oriXYSet_8x8y21o = {Nori = 21,  dOri = 2,    Nx = 8, dX = 2,    Ny = 8, dY = 2}
        
        tbl_fontNames = { {'Bookman'} }
        tbl_imageSize = { {40, 40} }
        tbl_sizeStyle = { 'k14' }
        --tbl_OriXY = { oriXYSet_8x8y21o }
        tbl_OriXY = { getXYset(1,1,1) }
        tbl_allSNRs_train = { {1, 2, 3}, }
            
        allSNRs_test = table.range(0, 4,   1)
        
    elseif expName == 'Crowding' then
        --tbl_fontNames = { {'Bookman'}, {'Sloan'} }
        tbl_fontNames = { {'Bookman'}, {'Sloan'} }
        --tbl_fontNames = { {'Sloan'} }
        --tbl_fontNames = { {'HelveticaUB'} }
        
         
        allSNRs_test = table.range(0, 5,  0.5);
         
        tbl_sizeStyle = {'k15'}
    
        if doOverFeat then
            tbl_sizeStyle = {'k23'}
        end
        
        allSNRs_test = table.range(0, 5,  0.5);
                
        if doConvNet or doTextureModel then
        
       --[[
        all_xrange_and_trainPositions_and_testPositions = {
            {[-16, 12, 176], [3:15], 9},     (-16 -4) 8 20 32 44 56 68 [80] 92 104 116 128 140 152 (164 176)
            {[-16, 8, 176],  [3:23], 13}       (-16 -8) 0 8 16 24 32 40 48 56 64 72 [80] 88 96 104 112 120 128 136 144 152 160 (168 176)
         
         --]]
            
            tbl_imageSize = {{32, 160}}
            
            --xrange = {-16, 12, 176};  trainPositions = table.range(3,15);  testPositions = 9 -- CONVNET & TEXTURE STATISTICS
            --xrange = {-16, 8, 176};   trainPositions = table.range(3,23);  testPositions = 13 -- CONVNET & TEXTURE STATISTICS
            xrange = {-15, 5, 175};  trainPositions = table.range(6,34);  testPositions = 20 -- CONVNET & TEXTURE STATISTICS
            
            
            
        elseif doOverFeat then
            tbl_imageSize = {{231, 231}};  
            xrange = {-34,15,266}; 
            trainPositions = table.range(4,18);  
            testPositions = 11   --- OVERFEAT
        end
            
        if  crowdingStage == 'test' then
            allMultiLetterTestOpts_tbl = {  testPositions = testPositions,
                                     --testPositions = {11},
                                     
                                     tbl_nDistractors = {2},
                                     --tbl_logDNR = {2.5} , 
                                     --tbl_nDistractors = {2, 1},
                                     tbl_logDNR = {2.5, 2.9}
                                     }
        end
                           
        if crowding_trainOn == 'RealData' then
            
            --tbl_fontNames = { {'SVHN'}  }              --TRAIN ON SVHN
            if doTextureModel then
                local crowding_realData_imageSize_train = {64, 64}
                local all_realData_opts = expandOptionsToList({imageSize = crowding_realData_imageSize_train, 
                                        globalNorm = true, 
                                        localContrastNorm = false,  --tbl_localContrastNorm = {false, true},
                                        tbl_scaleMethod = {'tile', 'pad', 'fourier'} } ) --tbl_scaleMethod = {'tile', 'pad', 'fourier'} } )
                
                tbl_realData_fontNames = expandOptionsToList( 
                    {fonts = crowding_realDataName, tbl_realData_opts= all_realData_opts} )
            else
                tbl_realData_fontNames = { {fonts = crowding_realDataName, realData_opts = channels_realData_settings_noNorm}, 
                                         --{fonts = crowding_realDataName, realData_opts = channels_realData_settings_norm}, 
                                       
                                    }
                
            end

            
            if crowdingStage == 'train' then
                tbl_fontNames = tbl_realData_fontNames
                tbl_noiseFilter = {whiteNoiseFilter}
                tbl_trainingNoise = {'same'}
                
            elseif crowdingStage == 'test' then
                tbl_trainingFonts = table.merge(tbl_realData_fontNames, {'same'})  -- once have figured out to convert texture 
                --tbl_trainingFonts = tbl_realData_fontNames   -- once have figured out to convert texture 
                
                
                --tbl_trainingFonts = {'same'}
                --tbl_noiseFilter = {whiteNoiseFilter}
                --tbl_retrainFromLayer = {'classifier', 'linear'}
                -- tbl_retrainFromLayer = {'linear'}
                --tbl_retrainFromLayer = {'linear-2'}
                --tbl_retrainFromLayer = {'linear-2', 'classifier'}
                tbl_retrainFromLayer = {'conv3', 'conv4', 'conv5', 'linear',}
                
                loopKeysOrder_dataOpts  = {'retrainFromLayer', 'trainingFonts', 'fontName', }; 
            end
            
            
        elseif crowding_trainOn == 'PinkNoise' then
            if crowdingStage == 'train' then
                tbl_noiseFilter =  tbl_whiteNoiseAndPinkOrWhiteNoises 
                tbl_trainingNoise = {'same'}
                
            elseif crowdingStage == 'test' then
                tbl_trainingNoise = tbl_whiteNoiseAndPinkOrWhiteNoises 
                tbl_noiseFilter = {whiteNoiseFilter}
                tbl_retrainFromLayer = {'', 'classifier', 'linear'}
                
                loopKeysOrder_dataOpts  = {'fontName', 'OriXY', 'trainingNoise'};
            end
            
        elseif crowding_trainOn == 'WhiteNoise' then
            tbl_trainingNoise = {whiteNoiseFilter}
            tbl_noiseFilter = {whiteNoiseFilter}
            tbl_retrainFromLayer = {''}
            
        end
        
                          
        
    else
        error(string.format('Unknown experiment name: %s', expName))
        
    end
    
        
    
    local tbl_textureParams
    if doTextureModel then
        local tbl_textureStatsUse = {'V2'}
        --local tbl_Nscl_Nori_Na = { {4, 4, 7},  {3, 4, 7}, }
        local tbl_Nscl_Nori_Na = { {3, 4, 7} }
        tbl_textureParams = expandOptionsToList({doTextureStatistics=true,
                                                 tbl_Nscl_txt_and_Nori_txt_and_Na_txt = tbl_Nscl_Nori_Na,
                                                 tbl_textureStatsUse = tbl_textureStatsUse})
        --tbl_Nscl_txt = {3}
        --tbl_Nori_txt = {4}
        --tbl_Na_txt = {7}
       
    end


    local all_layerId, all_OF_contrast, all_OF_offset
    if doOverFeat then
                
              --local layerId = 19
        --local OF_contrast = 32
        --local OF_offset = 0
         
        all_layerId = {19, 17, 16}
        all_OF_contrast = {127, 64, 32, 16, 2}
        all_OF_offset = {0, 64, 127}
        
        --tbl_sizeStyle = {'k68'}
        tbl_sizeStyle = {'128-64'}
        --tbl_sizeStyle = {'128-64', 'k68'}
        tbl_imageSize = {231, 231}
    end
    
    
      
    
    local allDataOpts_tbl = { expName = expName, 
                                      stimType = stimType,
        
                                      tbl_fontName = tbl_fontNames,

                                      tbl_OriXY = tbl_OriXY,                                      
                                      
                                      autoImageSize = false,                                      
                                      
                                      tbl_imageSize = tbl_imageSize,
                                      tbl_sizeStyle = tbl_sizeStyle,
                                      tbl_imageSize_and_sizeStyle = tbl_imageSize_and_sizeStyle,                                      
                                      tbl_imageSize_and_sizeStyle_and_OriXY = tbl_imageSize_and_sizeStyle_and_OriXY,
                                      
                                      tbl_blurStd = allBlurs,
                                                                            
                                      tbl_noiseFilter = tbl_noiseFilter, 
                                            tbl_trainingNoise = tbl_trainingNoise, 
                                            tbl_retrainingNoise = tbl_retrainingNoise,
                                      
                                      tbl_retrainFromLayer = tbl_retrainFromLayer, 
                                            tbl_secondRetrainFromLayer = tbl_secondRetrainFromLayer,
                                      
                                      tbl_trainingFonts = tbl_trainingFonts,
									  
                                      doTextureStatistics = doTextureModel,  
                                      tbl_textureParams = tbl_textureParams, 
                                      
                                      doOverFeat = doOverFeat, networkId = 0,  tbl_layerId = all_layerId, tbl_OF_contrast = all_OF_contrast, tbl_OF_offset = all_OF_offset, 
									  
                                      tbl_trainOnIndividualPositions = {false},
                                      retrainOnCombinedPositions = false, 
                                    
                                      tbl_classifierForEachFont = tbl_classifierForEachFont,
                                      
                                      tbl_trainingWiggle = tbl_trainingWiggle, 
                                      tbl_trainingOriXY = tbl_trainingOriXY,
                                      tbl_trainingImageSize = tbl_trainingImageSize,
                                      
                                      tbl_SNR_train = tbl_allSNRs_train,
                                      
                                      SNR_test = allSNRs_test, 
                                      tbl_trialId = table.range(1, nTrials),
                                      
                                      ---- Crowding options      
                                      
                                      xrange = xrange,
                                      trainPositions = trainPositions,
                                      allMultiLetterTestOpts_tbl = allMultiLetterTestOpts_tbl,
                                      
                                      -- loadOpts
                                      loadOpts = loadOpts
                                    }
    
    task.loopKeysOrder_dataOpts = loopKeysOrder_dataOpts



    print('Current task : ')
    print('\n===Using the following network options ===')
    print(optionsTable2string(allNetworkOptions_tbl))
    
    print('\n=== Using the following noisy-letter noisy-letter options : ===');
    print(optionsTable2string(allDataOpts_tbl))


    if saveTaskFile then
        io.write('Save Current task to task file ? [n]')
        local ans = io.read("*line")
        if not (ans == 'y' or ans == 'Y') then
            saveTaskFile = false
        end        
        
    end

    task.allNetworkOptions_tbl = allNetworkOptions_tbl
    task.allDataOpts_tbl = allDataOpts_tbl
    local descrip = ''
    if saveTaskFile then
        
        io.write(string.format('Creating task file : Enter description of current task : %s_%s_', expName, modelName))
        local descrip = io.read("*line")
        if not (descrip == '') then
            local nTaskFilesPresent = paths.nFilesMatching(tasks_dir .. 'task*.t7');
    
            local taskId = nTaskFilesPresent + 1;
    
            local taskFileNameBase = string.format('task_%03d_%s_%s_%s.t7', taskId, expName, modelName, descrip);
            local taskFileName = tasks_dir .. taskFileNameBase
            
            task.taskFileName=taskFileNameBase
            task.descrip = descrip  
           
            torch.save(taskFileName, task);
            
            io.write(string.format('[Writing to task file file ==>  %s...]\n', taskFileNameBase))

        end
    
        task.savedTaskFile = saveTaskFile
    end
        

    
    
    if onLaptop then

        do
            --error('!') 
           --return
        end
        
    end
    T = task
    
    results = doTask(task)
    

  --]]  
  
end

getXYset = function(nx,ny,dx, dy)
    assert(nx > 0)
    assert(ny > 0)
    if not dx then
        dx = 1;
        dy = 1;
    elseif not dy then
        dy = dx;
    end
        
    local s = {Nori = 1,  dOri = 0,  Nx = nx, dX = dx,  Ny = ny, dY = dy}
    return s
end


    
--[[

if THREAD_ID and (math.mod(fi-1, N_THREADS_TOT)+1 ~= THREAD_ID) then
                print(string.format(' ** Thread %d, skipping font # %d ** \n', THREAD_ID, fi))
                
            else
                if THREAD_ID then
                    print(string.format(' ** Thread %d, doing font # %d ** \n', THREAD_ID, fi))
                end
            
            
            --]]
            
  --[[          
  (1): nn.SpatialConvolutionMap
  (2): nn.Tanh
  (3): nn.Sequential {
    [input -> (1) -> (2) -> (3) -> output]
    (1): nn.Square
    (2): nn.SpatialSubSampling
    (3): nn.Sqrt
  }
  (4): nn.Reshape
  
  (5): nn.Linear
  (6): nn.Tanh
  
  (7): nn.Linear
  (8): nn.LogSoftMax

--]]
                                      --tbl_OriXY = oriXYSet_mult, 
                                      --tbl_OriXY = oriXYSet_scan,
                                      --tbl_OriXY = oriXYSet_test,
                                      --tbl_OriXY = oriXYSet_large_48,
                                      --tbl_OriXY = oriXYSet_long,
                                      --tbl_OriXY = oriXYSet_med1,
                                      
                                      
                                      --autoImageSize = true,
                                      --autoImageSize = false, imageSize = {32, 32},  
                                      --autoImageSize = false, imageSize = {40, 40},  
                                      --autoImageSize = false, imageSize = {32, 80},  
                                      --autoImageSize = false, imageSize = {45, 45},  
--                                      autoImageSize = false, imageSize = {65, 65},  
                                      --autoImageSize = false, imageSize = {40, 80},
                                      --autoImageSize = false, imageSize = {48, 48},  


                                      --autoImageSize = false, imageSize = {64, 64},                                        
                                      --autoImageSize = false, imageSize = {36, 88},  
                                      --autoImageSize = false, imageSize = {36, 164},  
                                      --autoImageSize = false, imageSize = {36, 116},
                                      --autoImageSize = false, tbl_imageSize = { {20, 20}, {50, 50}, },  --  {80, 80}
                                      --autoImageSize = false, tbl_sizeStyle_and_imageSize = { { 'k9', {35, 35}}, {'k18', {49, 49}}, {'k36', {99,99}}, {'k72', {147, 147} } },  --  {80, 80}
                                      --autoImageSize = false, tbl_sizeStyle_and_imageSize = { {'k18', {49, 49} },  {'k36', {99,99} }, {'k72', {147, 147} } },  --  {80, 80}
--                                      autoImageSize = false, tbl_sizeStyle_and_imageSize = { {'k18', {49, 49} },  {'k36', {99,99} }, {'k72', {147, 147} } },  --  {80, 80}
                                      --autoImageSize = false, tbl_sizeStyle_and_imageSize = {   {'k36', {99,99} },  },  --  {80, 80}
                                      --autoImageSize = false, tbl_sizeStyle_and_imageSize = { { 'k9', {35, 35}} },  --  {80, 80}




    --tbl_fontNames = { {'Bookman'}, Bookman_rBIJ,  mlhKsy_rBIJ}  }
    --tbl_fontNames = {  {'BookmanU'}, Bookman_rBIJ   }
    --tbl_fontNames = { Bookman_rBIJ, mK_rBIJ, mMlrhKsy_rBIJ }
    --tbl_fontNames = { {fonts = {'Bookman'}, styles = {'Roman'}},  {fonts = allStdFontNames, styles = {'Roman'}} }
    
    --tbl_fontNames = {  } 
    --tbl_fontNames = { allStdFontNames,  {fonts = allStdFontNames, styles = styles_use} }
    
    --tbl_fontNames = table.merge( { {allStdFontNames}, allStdFontNames })
    
   
    --------
    --- SIZE
    
        --tbl_sizeStyle = {'sml', 'med', 'big'}
    --tbl_sizeStyle = {'med'}
    --tbl_sizeStyle = {8, 16, 24,  12, 20,}
    --tbl_sizeStyle = {{24,8}, {16,8}, 8, 16, 24}
    --tbl_sizeStyle = {15, 16}
    --tbl_sizeStyle = {'k18'}
    --tbl_sizeStyle = {'k38'}
    --tbl_sizeStyle = {'k16'}
    --tbl_sizeStyle = {'k14'    }
    --tbl_sizeStyle = {'k30'}

    --allSNRs = {-1, 0, 0.5, 1, 1.5, 2, 2.5, 3, 4}
    --local allSNRs = {0, 1, 2, 2.5, 3, 4}
    --local allSNRs = {0, 1, 1.5, 2, 2.5, 3, 4, 5}    
    --local allSNRs_band = {-3, -2, -1, 0, 1, 2, 3, 4, 5};
    
   
    --local nSNRs = #allSNRs
    --local allSNRs = {0, 1, 2,   2.5,   3, 4}
    
    
   
    
  
  
      --    local tbl_fontNames = allFontNames
--    local tbl_fontNames = allFontNames_ext
    
    --fontNames = {'Kuenstler', 'Yung'}
    --fontNames = {'Bookman', 'GeorgiaUpper'}
    --tbl_fontNames = {'Bookman'}
    --tbl_fontNames = { {'Bookman', 'BookmanB'} }
    --tbl_fontNames = { {'KuenstlerU', 'KuenstlerUB'} }
    --tbl_fontNames = {'Bookman', {'Bookman', 'BookmanB'} }
    --tbl_fontNames = {'Bookman', 'Braille', 'KuenstlerU'}

--    local allStdFontNames      = {'BookmanU', 'Sloan', 'HelveticaU', 'CourierU'};
    --local allStdFontNames      = {'BookmanU', 'HelveticaU'};
    --local allStdFontNames      = {'Bookman', 'BookmanU', 'Sloan', 'Helvetica', 'Courier', 'KuenstlerU', 'Braille', 'Yung'}
    --local allStdFontNames_tbl = { {'Bookman'}, {'BookmanU'}, {'Sloan'}, {'Helvetica'}, {'Courier'}, {'KuenstlerU'}, {'Braille'}, {'Yung'} }
    --local allStdFontNames      = {'Bookman', 'KuenstlerU', 'Braille'}
