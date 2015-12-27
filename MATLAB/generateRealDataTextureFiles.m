function generateRealDataTextureFiles

    realDataName = 'SVHN';
%     realDataName = 'CIFAR10';

    fileTypes = {'train', 'test'};
%     fileTypes = {'test'};

    imageSize_orig = [32 32];
    all_scaleFactors_and_scaleMethods_and_Nscl_txt = ...
        { {[1 5], 'Tile', 3}, {[1 5], 'Pad', 3}, ...
          ..., {2, 'Pad',     4}, {2, 'Pad',     3},  ...  
          ...{2, 'Tile',    4}, {2, 'Tile',    3} ...
          ...{2, 'Fourier', 4}, {2, 'Fourier', 3},  ...
          } ;
%     all_scaleFactors_and_scaleMethods = { {1, ''} };
%         all_scaleMethods = {'Fourier', 'ZeroPad', 'Tile'};

%             allNScales = {3, 4};
%     allNScales_and_imageSizes = { {3, 32}, {3, 64}, {4, 64} };
    allNScales_and_imageSizes = { {3, 32} };
%     allNScales = {3};
% all_imageSizes = [32, 64];
    allNOrientations = {4}; %3,4};
    allNa = {7}; %5};
    allTextureStatsUse = {'V2'};

    
    all_Glob_Lc_Norms = {{false, false}, {true, false}, {true, true} };
    
    
    allRealDataOpts_tbl = (struct('realDataName', realDataName, ...
                            'tbl_Nscl_txt_and_imageSize', {  allNScales_and_imageSizes   }, ...
                            'tbl_Nori_txt', {allNOrientations}, ...
                            'tbl_Na_txt',   {allNa}, ...
                            'tbl_textureStatsUse', {allTextureStatsUse}, ...
                            'tbl_globalNorm_and_localContrastNorm', {all_Glob_Lc_Norms}, ...
                            ...
                            'tbl_scaleFactor_and_scaleMethod_and_Nscl_txt', {all_scaleFactors_and_scaleMethods_and_Nscl_txt}, ...
                            'tbl_fileType', { fileTypes }, ...
                            'doTextureStatistics', true ...;
                             ) );
    allRealDataOpts = num2cell(  expandOptionsToList (allRealDataOpts_tbl, {'', 'globalNorm_and_localContrastNorm',  'fileType'})  );

    displayOptions(allRealDataOpts_tbl);
% 	textureOpts = struct('Nscl_txt', 4, 'Nori_txt', 4, 'Na_txt', 7);

    
%         scale_method = 'PixelRep';
%         scale_method = 'Fourier';
%         scale_method = 'GetFromOrig';

%     origSize = 32;

    redo = false;
        redoIfOlderThan = 736248.540042; % sprintf('%.6f', now)

     
            %%
            
    for txt_i = 1:length(allRealDataOpts)
        opts = allRealDataOpts{txt_i};

        Nscl = opts.Nscl_txt;
        Nori = opts.Nori_txt;
        Na = opts.Na_txt;
        globNorm = opts.globalNorm;
        localContrastNorm = opts.localContrastNorm;

        scaleFactor = opts.scaleFactor;
        scaleMethod = opts.scaleMethod;
        
        newImageSize = imageSize_orig .* scaleFactor;
        opts.imageSize = newImageSize;
        
        
        fileType = opts.fileType;
            
            [opt_gray_txt,opt_gray_im] = deal( opts); 
            
            opt_gray_im.doTextureStatistics = false;
            opt_gray_im.imageSize = imageSize_orig;
            

            [im_fileBase, im_path] = getRealDataFile(opt_gray_im);
            realData_image_fileName = [im_path, im_fileBase];

            [texture_fileBase, texture_path] = getRealDataFile(opt_gray_txt);
            realData_texture_fileName = [texture_path, texture_fileBase];
    %         
            scaleMethod_str = '';
            if scaleFactor > 1
                scaleMethod_str = sprintf(' [Scale Method : %s]', scaleMethod);
            end
    
            fprintf('\n======================== \n (%d/%d) Converting %s image to texture: ImageSize = %dx%d. %s GlobNorm=%d. LocalNorm=%d.  N=%d. M=%d, K=%d.   FileType = %s\n\n', ...
                txt_i, length(allRealDataOpts), realDataName, opts.imageSize, scaleMethod_str, globNorm, localContrastNorm,  Nscl, Nori, Na,  fileType);
    
            if exist(realData_texture_fileName, 'file') 
                redoNow = redo;
                if fileOlderThan(realData_texture_fileName, realData_image_fileName)
                    fprintf('\nMatlab texture file (%s : %s)\n is older than matlab image file (%s:%s) \n', ...
                    realData_texture_fileName, datestr( filedate(realData_texture_fileName)), realData_image_fileName,  datestr(filedate(realData_image_fileName) ) );
                    redoNow = true;
                elseif fileOlderThan(realData_texture_fileName, redoIfOlderThan)
                    fprintf('\nMatlab texture file (%s : %s) is older than cutoff(%s)\n', ...
                        realData_texture_fileName, datestr( filedate(realData_texture_fileName)), datestr(redoIfOlderThan) )
                    redoNow = true;
                end
                
                if redoNow 
                    fprintf('Redoing file ...\n');
                else
                    fprintf('\nFile %s already exists\n', realData_texture_fileName);
                    continue;                    
                end
            end
            
            lock_name = ['create_' strrep(texture_fileBase, '.mat', '')];
            [gotLock, otherID] = lock_createLock(lock_name);
            if ~gotLock
                fprintf('\n        [Another matlab session (%s) is doing %s...]\n', otherID, lock_name);
                continue
            end
            
    %         rgb_fileName  = [datasetsPath 'SVHN' filesep 'orig_rgb' filesep  sprintf('%s_%dx%d.mat', fileTypes{fi}, origSize, origSize) ];
    %         gray_fileName = [datasetsPath 'SVHN' filesep                     sprintf('SVHN_%s_%dx%d_gray.mat', fileTypes{fi}, newSize, newSize) ];

            fprintf('\n %s ==> \n %s\n', realData_image_fileName, realData_texture_fileName);

            S_im = load(realData_image_fileName);
            [h, w, nSamples] = size(S_im.inputMatrix);


            pBar_step = 100;
            progressBar('init-', nSamples/pBar_step)

%             xi_image1 = double( S_im.inputMatrix(:,:,1) );
%             if (scaleFactor > 1)
%                 xi_image1 = scaleUpImage(xi_image1, scaleFactor, scaleMethod);                
%             end
%             
%             xi_texture1 = textureAnalysis(xi_image1, Nscl, Nori, Na);
            [~, idx_textureStats_use] = textureStruct2vec([Nscl, Nori, Na], [], 1, newImageSize);

            %                 nTexParams = nTextureStatisticsForParams(Nscl, Nori, Na, 1);
            nTexParams = length(idx_textureStats_use);
            X_texture = zeros(nTexParams,1, nSamples, 'single');

            meanVal = mean(S_im.inputMatrix(:));

            for si = 1:nSamples
                xi_image = double( S_im.inputMatrix(:,:,si) );
                if (scaleFactor > 1)
                    xi_image = scaleUpImage(xi_image, scaleFactor, scaleMethod, meanVal);
                end
                
                xi_texture = textureAnalysis(xi_image, Nscl, Nori, Na);
                xi_texture_vec = textureStruct2vec(xi_texture, idx_textureStats_use, 1);

                X_texture(:,:,si) = xi_texture_vec;

                if ~mod(si, pBar_step)
                    progressBar(si/pBar_step);
                end

            end
            S_text.inputMatrix = X_texture;
            S_text.labels = single(S_im.labels);
            S_text.nClasses = 10;

            S_text.xs = 0;
            S_text.ys = 0;
            S_text.orientations = 0;

            save(realData_texture_fileName, '-struct', 'S_text');
            
            lock_removeLock(lock_name);
     
    
    end
    
    
end

function im_gray = myGray(im_rgb, coeff)
      
   im_gray  = uint8(round(coeff(1) * double(im_rgb(:,:,1)) + coeff(2) * double(im_rgb(:,:,2)) + coeff(3) * double(im_rgb(:,:,3))));
    
end


