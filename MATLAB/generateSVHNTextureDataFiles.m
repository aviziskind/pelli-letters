function generateSVHNTextureDataFiles
   
    fileTypes = {'train', 'test'};
%     fileTypes = {'test'};

%     all_sizeIncreaseFactors = [1, 2];

%             allNScales = {3, 4};
    allNScales_and_imageSizes = { {3, 32}, {3, 64}, {4, 64} };
%     allNScales = {3};
% all_imageSizes = [32, 64];
    allNOrientations = {4}; %3,4};
    allNa = {7}; %5};
    allTextureStatsUse = {'V2'};

    allTextureOpts = (struct('tbl_Nscl_txt_and_imageSize', {  allNScales_and_imageSizes   }, ...
                            'tbl_Nori_txt', {allNOrientations}, ...
                            'tbl_Na_txt',   {allNa}, ...
                            'tbl_textureStatsUse', {allTextureStatsUse} ...
                             ) );
    allTextureSettings = num2cell(  expandOptionsToList (allTextureOpts)  );

% 	textureOpts = struct('Nscl_txt', 4, 'Nori_txt', 4, 'Na_txt', 7);

    
%         scale_method = 'PixelRep';
%         scale_method = 'Fourier';
%         scale_method = 'GetFromOrig';

%     origSize = 32;

    redo = false;
        redoIfOlderThan = 736233.195339; % sprintf('%.6f', now)

     
            %%
            
    for txt_i = 1:length(allTextureSettings)
        textureSettings = allTextureSettings{txt_i};

        for fi = 1:length(fileTypes)
            fileType = fileTypes{fi};

            imageSize = textureSettings.imageSize;

            Nscl = textureSettings.Nscl_txt;
            Nori = textureSettings.Nori_txt;
            Na = textureSettings.Na_txt;

            
            opt_gray_im = struct('imageSize', imageSize(1), 'fileType', fileType);
            opt_gray_txt = struct('imageSize', imageSize(1), 'fileType', fileType, 'doTextureStatistics', true);
            opt_gray_txt = mergeStructs( opt_gray_txt, textureSettings);

            [im_fileBase, im_path] = getSVHNdataFile(opt_gray_im);
            svhn_image_fileName = [im_path, im_fileBase];

            [texture_fileBase, texture_path] = getSVHNdataFile(opt_gray_txt);
            svhn_texture_fileName = [texture_path, texture_fileBase];
    %         
    

            if exist(svhn_texture_fileName, 'file') 
                if ~(redo || fileOlderThan(svhn_texture_fileName, redoIfOlderThan))
                    fprintf('File %s already exists\n', svhn_texture_fileName);
                    continue;
                elseif fileOlderThan(svhn_texture_fileName, redoIfOlderThan)
                    fprintf('File date (%s) is older than cutoff(%s) : redoing file\n', datestr( filedate(svhn_texture_fileName)), datestr(redoIfOlderThan) )
                    
                end
            end
            
            fprintf('\n ======== \n Converting SVHN to image : N=%d. M=%d, K=%d. ImageSize = %dx%d. FileType = %s\n\n', Nscl, Nori, Na, imageSize, imageSize, fileType);
    %         rgb_fileName  = [datasetsPath 'SVHN' filesep 'orig_rgb' filesep  sprintf('%s_%dx%d.mat', fileTypes{fi}, origSize, origSize) ];
    %         gray_fileName = [datasetsPath 'SVHN' filesep                     sprintf('SVHN_%s_%dx%d_gray.mat', fileTypes{fi}, newSize, newSize) ];

            fprintf('\n %s ==> \n %s\n', svhn_image_fileName, svhn_texture_fileName);

            S_im = load(svhn_image_fileName);
            [h, w, nSamples] = size(S_im.inputMatrix);


            pBar_step = 100;
            progressBar('init-', nSamples/pBar_step)

            xi_image1 = double( S_im.inputMatrix(:,:,1) );
            xi_texture1 = textureAnalysis(xi_image1, Nscl, Nori, Na);
            [textureStatistics_vector, idx_textureStats_use] = textureStruct2vec(xi_texture1, [], 1);

            %                 nTexParams = nTextureStatisticsForParams(Nscl, Nori, Na, 1);
            nTexParams = length(textureStatistics_vector);
            X_texture = zeros(nTexParams,1, nSamples, 'single');


            for si = 1:nSamples
                xi_image = double( S_im.inputMatrix(:,:,si) );

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

            save(svhn_texture_fileName, '-struct', 'S_text');
        end

    
    end
    
    
end

function im_gray = myGray(im_rgb, coeff)
      
   im_gray  = uint8(round(coeff(1) * double(im_rgb(:,:,1)) + coeff(2) * double(im_rgb(:,:,2)) + coeff(3) * double(im_rgb(:,:,3))));
    
end

function im_gray_enlarged = scaleUpImage(im_gray, scaleFactor, scale_method)
    
        if strcmp(scale_method, 'PixelRep')
            im_gray_enlarged = scaleByPixelRep(im_gray, scaleFactor);
        elseif strcmp(scale_method, 'Fourier')
            im_gray_enlarged = fourierInterpImage(single(im_gray), 'mult', scaleFactor);
            L = lims(im_gray_enlarged);
            if (L(1) < 0 || L(2) > 255)
                overshoot = max(-L(1), L(2)-255);
                h = 128;
                c_factor = h/(overshoot+h+1);
                im_gray_enlarged_rescaled = (im_gray_enlarged-h)*c_factor + h; 
                L2 = lims(im_gray_enlarged_rescaled);
                assert(L2(1) >= 0 && L2(2) <= 255);
                im_gray_enlarged = uint8(round(im_gray_enlarged));
            end
            
        end
    
end


