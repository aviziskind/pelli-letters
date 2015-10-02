function trainedNetwork = loadTrainedModel(noisyLetterOpts, network_use, trialId, opt)

    if nargin < 3 || isempty(trialId)
        trialId = 1;
    end

    if ~exist('opt', 'var') || isempty(opt)
        opt = struct('skipIfDontHaveModelFile', false);
    end

    if ~isfield(opt, 'convNetFilterLayer')
        opt.convNetFilterLayer = [];
    end
    
    stimType = noisyLetterOpts.stimType;
%     torch_networks_dir = [torchPath 'TrainedNetworks' fsep stimType fsep];
    
    if isfield(noisyLetterOpts, 'trainingNoise') && ~isequal(noisyLetterOpts.trainingNoise, 'same')
        noisyLetterOpts.noiseFilter = noisyLetterOpts.trainingNoise;
        noisyLetterOpts.trainingNoise = 'same';
    end
    if isfield(noisyLetterOpts, 'trainingFonts') && ~isequal(noisyLetterOpts.trainingFonts, 'same')
        noisyLetterOpts.fontName = noisyLetterOpts.trainingFonts;
        noisyLetterOpts.trainingFonts = 'same';
    end
%%
    expSubtitle = getExpSubtitle(noisyLetterOpts, network_use, trialId);
    
    
    mainFolder = [lettersDataPath 'TrainedNetworks' fsep noisyLetterOpts.expName fsep];
    file_name = [expSubtitle '.mat'];
    preferredSubdir = [stimType '/'];
    
    [haveFile, filename, foldersChecked] = fileExistsInSisterSubdirs(mainFolder, preferredSubdir, file_name);
    
%%
    trainedNetwork = [];
    
    if ~haveFile 
        if opt.skipIfDontHaveModelNetworkFile || trialId > 1;
            fprintf('Warning : could not find network file : %s\n', filename);
            return;
        else
            error('Network file %s not present', filename)
        end
    else
        fprintf('Loaded network file : %s\n', filename);
    end

    
    S_model = load(filename);
    S_model = parseModel(S_model);
    
    if ~isempty(opt.convNetFilterLayer)
        if strcmp(network_use.netType, 'ConvNet') % && isfield(S_model, 'm1_weight')
            moduleSeq = S_model.modules_strC;
            idx_conv = find(strcmp(moduleSeq, 'Conv'));
            
            if length(idx_conv) < opt.convNetFilterLayer
                error('This Network does not have %d convolutional layers', opt.convNetFilterLayer);
            end
            idx_conv = idx_conv(opt.convNetFilterLayer);
            
            trainedNetwork = S_model.(sprintf('m%d_weight', idx_conv));
            if ndims(trainedNetwork) == 4
                sz = size(trainedNetwork);
                trainedNetwork = reshape(trainedNetwork, [sz(1), sz(2), sz(3)*sz(4)] );
            end
        elseif strcmp(network_use.netType, 'MLP') % && isfield(S_model, 'm1_weight')
            if any(length(network_use.nHiddenUnits) == [0, 1]);
                %%
                weights = S_model.m2_weight;
                [nPixInImage, nUnits] = size(weights);
                assert(nPixInImage == prod(noisyLetterOpts.imageSize))
                weights = reshape(weights, [noisyLetterOpts.imageSize, nUnits]);
                
                %%
                
                if length(network_use.nHiddenUnits) == 0
                    templates = weights;
                else
                    templates = zeros([noisyLetterOpts.imageSize, 26]);
                    for i = 1:26                
                        templates(:,:,i) = zeros(noisyLetterOpts.imageSize);                
                        for j = 1:nUnits
                            templates(:,:,i) = templates(:,:,i) + ((weights(:,:,j)) * S_model.m4_weight(j,i));
                        end
                    end
                end
                3;
                trainedNetwork = templates;
            else
                3;
                
            end
                
        end
    else
        trainedNetwork = S_model;
    end
 
    
end


function S_model = parseModel(S_model)
    %%
    fn = fieldnames(S_model);
    S_model.moduleNames = {};
    for i = 1:length(fn)
        if ~isempty(strfind(fn{i}, 'str'))
            S_model.(fn{i}) = char(S_model.(fn{i})');
        end
    end
    %%
    S_model.modules_strC = strsplit(S_model.modules_str, ';');
    
    S_model = orderfields(S_model);
    % transpose CUDA convolutional filters
    for i = 1:S_model.nModules
        if strcmp(S_model.(sprintf('m%d_str', i)), 'SpatialConvolutionCUDA')
%             fprintf('layer %d: permuting CUDA filters\n', i);
            wgt_field = sprintf('m%d_weight', i);
            wgt = S_model.(wgt_field);
            if ndims(wgt) == 3  % first layer:  nOutMaps x h x w --> h x w x nOutMaps
                S_model.(wgt_field) = permute(wgt, [2 3 1]);
            elseif ndims(wgt) == 4 % subsequent layers: nOutMaps x h x w x nInputMaps --> h x w x nOutputMaps x nInputMapx
                S_model.(wgt_field) = permute(wgt, [2 3 1 4]);  
            end
        end
    end
    
    
end

%{

function allTrainedNetworks = loadTrainedModel(stimType, allFontNames, allSNRs_train, allNetworksSpecs, noisyLetterOpts, opt, trialId)

%     pctCorrect_model_v_snr = loadModelResults(stimType, allFontNames, allSNRs_test, allSNR_train, allNetworks, noisyLetterOpts); 

    if ~iscell(allFontNames)
        allFontNames = {allFontNames};
    end

    nNetworks = length(allNetworksSpecs);
    nFonts = length(allFontNames);
%     all_nHUnits = [1,2,3,4,5,6,7,8,9,10,20,50,100];
    
%     convNet_state_str = '30_80__';
%     convNet_state_str = '6_16__';
%     convNet_state_str = '12_32__';
%     expTitle = iff(convNet, 'ConvNet', 'HiddenUnits');

%     torch_dir = [torchPath 'Results' fsep 'HiddenUnits' fsep 'copy_2013_11_19' fsep];
    
    torch_networks_dir = [torchPath 'TrainedNetworks' fsep expTitle fsep];
    

    justFirstStageFilters = true;
    
%     pca_flag = 0;
%     old_str = iff(noisyLetterOpts.useOldStim, '_old', '');

%     ori_x_y_str = getNoisyLetterOptsStr(oris, xs, ys);

        
    allTrainedNetworks = cell(nNetworks, nFonts);

    for fi = 1:nFonts
        
        for net_i = 1:nNetworks
            network_i = allNetworksSpecs(net_i);
    %                 nStates =  allNetworks{net_i};
    %                 networkOpts.nStates = nStates;
    %                 network_str = getConvNetStr(networkOpts);
            if isfield(noisyLetterOpts, 'trainingNoise')
                noisyLetterOpts.noiseFilter = noisyLetterOpts.trainingNoise;
                noisyLetterOpts = rmfield(noisyLetterOpts, 'trainingNoise');
            end
    
    
            expSubtitle = getExpSubtitle(allFontNames{fi}, allSNRs_train, network_i, noisyLetterOpts, trialId);
            filename = [torch_networks_dir expSubtitle '.mat'];
                
            haveFile = exist(filename, 'file');
            if ~haveFile 
                if opt.skipIfDontHaveModelFile
                    continue;
                else
                    error('Results file %s not present', filename)
                end
            end    
                
            S_model = load(filename);
            if justFirstStageFilters
                allTrainedNetworks{net_i, fi} = S_model.m1_weight;
            else
                allTrainedNetworks{net_i, fi} = S_model;
            end
            3;

        end
    end        
end
%}

