function [fn, f_path] = getSVHNdataFile(opts)

%     rgb_fileName  = [datasetsPath 'SVHN' filesep 'orig_rgb' filesep  sprintf('%s_%dx%d.mat', fileTypes{fi}, origSize, origSize) ];
%     gray_fileName = [datasetsPath 'SVHN' filesep                     sprintf('SVHN_%s_%dx%d_gray.mat', fileTypes{fi}, newSize, newSize) ];

    if nargin < 1
        opts = struct;
    end

    opts.showSize = true;
    [~, ~, svhn_opt_fileStr] = getRealDataOptsStr(opts);
    
    orig_rgb = isfield(opts, 'orig') && isequal(opts.orig, true);

    if orig_rgb
        orig_subfolder = ['orig_rgb' filesep];
        SVHN_prefix_str = '';
    else        
        orig_subfolder = '';
        SVHN_prefix_str = 'SVHN_';
    end
    
    fileType = 'train';
    if isfield(opts, 'fileType') && ~isempty(opts.fileType)
        fileType = opts.fileType;
    end
    
    
    fn = sprintf('%s%s%s.mat', SVHN_prefix_str, fileType, svhn_opt_fileStr);
    
    if nargout > 1
        f_path = [datasetsPath 'SVHN' filesep orig_subfolder];
    end
    
end

