function str = getExpSubtitle(dataOpts, networkOpts, trialId_arg)
    
    
    dataOpts_str = getDataOptsStr(dataOpts);
    

    network_str = ['__' getNetworkStr(networkOpts)];
    
    
    trialId = 1;
    if exist('trialId_arg', 'var') && ~isempty(trialId_arg) 
        trialId = trialId_arg;
    elseif isfield(networkOpts, 'trialId')
        trialId = networkOpts.trialId;
    end
        
    trialId_str = '';
    if trialId > 1
        trialId_str = ['__tr' num2str(trialId)];
    end

    
    str = [dataOpts_str  network_str   trialId_str];
    
end

%     if isfield(letterOpts, 'useOldStim') && letterOpts.useOldStim
%         old_str = '_old';
%     else
%         old_str = '';
%     end
    

%     str = [fontName  sizeStyle_str old_str snr_train_str network_str letterOpts_str trialId_str];
