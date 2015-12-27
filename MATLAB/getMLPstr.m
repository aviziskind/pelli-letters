function [str, str_nice] = getMLPstr(networkOpts, niceOutput_fields)
    HU = networkOpts.nHiddenUnits;
    str_nice = '';
    doNiceStr = exist('niceOutput_fields', 'var') && ~isempty(niceOutput_fields);
    if isempty(HU)
        str = 'X';
        if doNiceStr
%             str_nice = '(1 layer)';
            str_nice = '(no hidden layer)';
        end
    else
        %%
        nLayers = length(HU);
        str = toList(HU);
        if doNiceStr
%             str_nice = sprintf('(2 layers: %s Hidden Units)', toList(HU, [], ','));
            str_nice = sprintf('(%d hidden layers: %s HU)', nLayers, toList(HU, [], ','));
        end
    end
end