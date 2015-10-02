function [fn, f_path] = getSVHNdataFile(opts)

    
%     rgb_fileName  = [datasetsPath 'SVHN' filesep 'orig_rgb' filesep  sprintf('%s_%dx%d.mat', fileTypes{fi}, origSize, origSize) ];
%     gray_fileName = [datasetsPath 'SVHN' filesep                     sprintf('SVHN_%s_%dx%d_gray.mat', fileTypes{fi}, newSize, newSize) ];
    
%     svhnOpt_str = getSVHNOptsStr(opts);

    if nargin < 1
        opts = struct;
    end

    imageSize = 32;
    if isfield(opts, 'imageSize') && ~isempty(opts.imageSize)
        imageSize = opts.imageSize;
    end
    size_str = sprintf('_%dx%d', imageSize, imageSize);
     

    textureStats_str = '';
    if isfield(opts, 'doTextureStatistics') && opts.doTextureStatistics
        textureStats_str = getTextureStatsStr(opts);        
    end

    
    
    orig_rgb = false;
    if isfield(opts, 'orig') && isequal(opts.orig, true)
        orig_rgb = true;
    end


    if orig_rgb
        subfolder = ['orig_rgb' filesep];
        prefix_str = '';
        suffix_str = '';
    else        
        subfolder = '';
        prefix_str = 'SVHN_';
        suffix_str = '_gray';
    end
    
    fileType = 'train';
    if isfield(opts, 'fileType') && ~isempty(opts.fileType)
        fileType = opts.fileType;
    end
    
    
    
    fn = sprintf('%s%s%s%s%s.mat', prefix_str, fileType, size_str, suffix_str, textureStats_str);
        
    if nargout > 1
        f_path = [datasetsPath 'SVHN' filesep subfolder];
    end
    
end

