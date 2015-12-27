function [fn, f_path] = getCIFARdataFile(opts)
    

    if nargin < 1
        opts = struct;
    end

    opts.showSize = true;
    [~, ~, realData_opt_fileStr] = getRealDataOptsStr(opts);
    
    fileType = 'train';
    if isfield(opts, 'fileType') && ~isempty(opts.fileType)
        fileType = opts.fileType;
    end
    
    batchIdx = 1;
    if isfield(opts, 'batchIdx') && ~isempty(opts.batchIdx)
        batchIdx = opts.batchIdx;
    end

       
    
    orig_rgb = isfield(opts, 'orig') && isequal(opts.orig, true);

    if orig_rgb
        orig_subfolder = ['orig_rgb' filesep];
        if strcmp(opts.realDataName, 'CIFAR10')
            switch fileType
                case 'train',
                    fn = sprintf('data_batch_%d.mat', batchIdx);
                case 'test', 
                    fn = 'test_batch.mat';
            end
            
        elseif strcmp(opts.realDataName, 'CIFAR100')
            fn = fileType;
        end
    else        
        orig_subfolder = '';
        CIFAR_prefix_str = [opts.realDataName '_'];
        fn = sprintf('%s%s%s.mat', CIFAR_prefix_str, fileType, realData_opt_fileStr);
    end
    
    if nargout > 1
        f_path = [datasetsPath opts.realDataName filesep orig_subfolder];
    end
    
end

