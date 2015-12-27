function convertRealDatasetToGrayscale

    datasetName = 'SVHN';
%     datasetName = 'CIFAR10';

    fileTypes = {'train', 'test'};
%     fileTypes = {'test'};

%     all_scaleFactors = [1, 2];
    all_scaleFactors = {[1 5]};
%     all_scaleFactors = [2];
%         scale_method = 'PixelRep';
%         scale_method = 'Fourier';
%         all_scaleMethods = {'Fourier', 'Pad', 'Tile'};
        all_scaleMethods = {'Pad', 'Tile'};
%         scale_method = 'GetFromOrig';

    allSettings = expandOptionsToList(struct('tbl_scaleFactor', {all_scaleFactors}, ...
                                              'tbl_scaleMethod', {all_scaleMethods}));

    redo = 1;
        redoIfOlderThan = 736250.407209; % sprintf('%.6f', now)

    doTransposeFromOrig = false;  % we always keep things vertical in the MATLAB perspective (images are tranposed in the torch perspective)
    addInputPlaneDimension = false; % torch adds the input plane dimension when it loads the SVHN file    
    

    nCifarTrainBatches = 5;
    
    origSize = 32;
    
    for i = 1:length(allSettings)
        scaleFactor = allSettings(i).scaleFactor;
        scaleMethod = allSettings(i).scaleMethod;
        
        if length(scaleFactor) == 1
            scaleFactor = scaleFactor*[1,1];
        end

        newSize = origSize .* scaleFactor;
        %%
        for fi = 1:length(fileTypes)
            fileType = fileTypes{fi};
            %%
            switch datasetName
                case 'SVHN'
                    opt_gray = struct('realDataName', 'SVHN', 'imageSize', newSize, 'fileType', fileType, 'globalNorm', false, 'localContrastNorm', false, 'scaleMethod', scaleMethod);
                    [gray_fileBase, gray_path] = getSVHNdataFile(opt_gray);
                    gray_fileName = [gray_path, gray_fileBase];
                    
                    if exist(gray_fileName, 'file') && ~(redo || fileOlderThan(gray_fileName, redoIfOlderThan))
                        fprintf('File %s already exists\n', gray_fileName);
                        continue;
                    end
                    
                    opt_rgb = struct('realDataName', 'SVHN', 'imageSize', origSize, 'fileType', fileType, 'globalNorm', false, 'localContrastNorm', false, 'orig', 1);
                    [rgb_fileBase, rgb_path] = getSVHNdataFile(opt_rgb);
                    rgb_fileName = [rgb_path, rgb_fileBase];
                    
                    
                    fprintf('\n Creating : \n %s ==> \n %s\n', rgb_fileName, gray_fileName);
                    
                    S_rgb = load(rgb_fileName);
                    X = S_rgb.X;
                    
                    labels = single(S_rgb.y);
                case 'CIFAR10',
                    
                    opt_gray = struct('realDataName', 'CIFAR10', 'imageSize', newSize, 'fileType', fileType, 'globalNorm', false, 'localContrastNorm', false, 'scaleMethod', scaleMethod);
                    [gray_fileBase, gray_path] = getCIFARdataFile(opt_gray);
                    gray_fileName = [gray_path, gray_fileBase];
                    
                    if exist(gray_fileName, 'file') && ~(redo || fileOlderThan(gray_fileName, redoIfOlderThan))
                        fprintf('File %s already exists\n', gray_fileName);
                        continue;
                    end
                    
                    
                    nBatches = iff(strcmp(fileType, 'train'), nCifarTrainBatches, 1);
                    X_C = cell(1, nBatches);
                    labels_C = cell(1, nBatches);
                    fprintf('\n Adding : \n');
                    for batch_idx = 1:nBatches
                        opt_rgb = struct('realDataName', 'CIFAR10', 'imageSize', origSize, 'fileType', fileType, 'globalNorm', false, 'localContrastNorm', false, 'orig', 1, 'batchIdx', batch_idx, 'nClasses', 10);
                        
                        [rgb_fileBase, rgb_path] = getCIFARdataFile(opt_rgb);
                        rgb_fileName = [rgb_path, rgb_fileBase];
                        
                        fprintf(' (%d) %s \n', batch_idx, rgb_fileName);
                        
                        S_rgb_i = load(rgb_fileName);
                        
                        X_C{batch_idx} = permute( reshape( S_rgb_i.data', [32, 32, 3, 10000] ), [2, 1, 3, 4] );
                        labels_C{batch_idx} = single(S_rgb_i.labels(:));
                        
                    end
                    fprintf(' ==> %s\n', gray_fileName);
                    X = cat(4, X_C{:});
                    labels = cat(1, labels_C{:});
                    
                    if min(labels(:)) == 0
                        fprintf('Adding offset of 1 to the labels so that minimum label is non-zero\n')
                        labels = labels + 1;
                    end
                    
                    
            end
            
            [h, w, n3, nSamples] = size(X);
            assert(n3 == 3);

            
            newH = h * scaleFactor(1);
            newW = w * scaleFactor(2);
            
            assert(~addInputPlaneDimension);
%             if addInputPlaneDimension
%                 X_gray = zeros(newH,newW, 1, nSamples, class(S_rgb.X));
%             else
                X_gray = zeros(newH,newW, nSamples, class(X));
%             end

            T    = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
            coeff = T(1,:);
            pBar_step = 100;
            progressBar('init-', nSamples/pBar_step)

            for si = 1:nSamples
                xi_rgb = X(:,:,:,si);
                xi_gray = rgb2gray(xi_rgb);

                if any(scaleFactor > 1)
                    xi_gray = scaleUpImage(xi_gray, scaleFactor, scaleMethod);                
                end
                if doTransposeFromOrig
                   xi_gray = xi_gray'; 
                end
                
                X_gray(:,:,si) = xi_gray;

    %             xi_gray2 = myGray(xi_rgb, coeff);

    %             assert(isequal(xi_gray, xi_gray2));
                3;

                if ~mod(si, pBar_step)
                    progressBar(si/pBar_step);
                end
            end
            
            S_gray.inputMatrix = X_gray;
            S_gray.labels = labels;
            S_gray.nClasses = 10;

            S_gray.xs = 0;
            S_gray.ys = 0;
            S_gray.orientations = 0;

            save(gray_fileName, '-struct', 'S_gray');


        end

    
    end
    
    
end

function im_gray = myGray(im_rgb, coeff)
      
   im_gray  = uint8(round(coeff(1) * double(im_rgb(:,:,1)) + coeff(2) * double(im_rgb(:,:,2)) + coeff(3) * double(im_rgb(:,:,3))));
    
end




%{
1. run convertSVHNtoGrayscale           from matlab
2. run loadAllNormalizedSVHNfiles(0)    from torch
3. run generateSVHNTextureDataFiles     from matlab
4. run loadAllNormalizedSVHNfiles(1)    from torch

               MATLAB                          torch
--------------------------------------------------------------------------------------------------------
           train_32x32.mat                                      (original)                                   [h x w x 3 x N]    
               |
            convertSVHNtoGrayscale {.m}
               |
               v                    (loadAllNormalizedSVHNfiles(0) {.lua}] 
           SVHN_train_32x32_gray.mat    ->    SVHN_train_32x32_gray.t7                                       [h x w x  N]    ->   [N x w x h]     
                                                    |
                                                loadAllNormalizedSVHNfiles(0) {.lua} (globalNormalizeDataset and/or localContrastNormalizeDataset)                                                 
                                                    |
                                                    v
       SVHN_train_32x32_gray_gnorm.mat  <-      SVHN_train_32x32_gray_gnorm.t7, SVHN_train_32x32_gray_gnorm_lcnorm.t7 
                |
         generateSVHNTextureDataFiles {.m}
                |
                v                           loadAllNormalizedSVHNfiles(1)
       SVHN_train_32x32_gray_gnorm_N3_M4_K7.mat      ->  SVHN_train_32x32_gray_gnorm_N3_M4_K7.t7
       SVHN_train_64x64_gray_pad_gnorm_N3_M4_K7.mat  ->  SVHN_train_64x64_gray_pad_gnorm_N3_M4_K7.t7





%}


