function [fn, f_path] = getRealDataFile(opts)
   
%     rgb_fileName  = [datasetsPath 'SVHN' filesep 'orig_rgb' filesep  sprintf('%s_%dx%d.mat', fileTypes{fi}, origSize, origSize) ];
%     gray_fileName = [datasetsPath 'SVHN' filesep                     sprintf('SVHN_%s_%dx%d_gray.mat', fileTypes{fi}, newSize, newSize) ];

    switch opts.realDataName
        case 'SVHN',    [fn, f_path] = getSVHNdataFile(opts);
        case 'CIFAR10', [fn, f_path] = getCIFARdataFile(opts);
    end
    
end

