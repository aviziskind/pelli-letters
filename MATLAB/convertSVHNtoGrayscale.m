function convertSVHNtoGrayscale
   
    fileTypes = {'train', 'test'};
%     fileTypes = {'test'};

    all_sizeIncreaseFactors = [1, 2];
%     all_sizeIncreaseFactors = [2];
%         scale_method = 'PixelRep';
        scale_method = 'Fourier';
%         scale_method = 'GetFromOrig';

    redo = 0;
        redoIfOlderThan = 736234.195339; % sprintf('%.6f', now)

    origSize = 32;
    
    for i = 1:length(all_sizeIncreaseFactors)
        sizeIncreaseFactor = all_sizeIncreaseFactors(i);

        newSize = origSize*sizeIncreaseFactor;
        %%
        for fi = 1:length(fileTypes)
            %%
            
            opt_rgb = struct('imageSize', origSize, 'fileType', fileTypes{fi}, 'orig', 1);
            opt_gray = struct('imageSize', newSize, 'fileType', fileTypes{fi});

            [rgb_fileBase, rgb_path] = getSVHNdataFile(opt_rgb);
            [gray_fileBase, gray_path] = getSVHNdataFile(opt_gray);

            rgb_fileName = [rgb_path, rgb_fileBase];
            gray_fileName = [gray_path, gray_fileBase];

    %         
    %         rgb_fileName  = [datasetsPath 'SVHN' filesep 'orig_rgb' filesep  sprintf('%s_%dx%d.mat', fileTypes{fi}, origSize, origSize) ];
    %         gray_fileName = [datasetsPath 'SVHN' filesep                     sprintf('SVHN_%s_%dx%d_gray.mat', fileTypes{fi}, newSize, newSize) ];

            if exist(gray_fileName, 'file') && ~(redo || fileOlderThan(gray_fileName, redoIfOlderThan))
                fprintf('File %s already exists\n', gray_fileName);
                continue;
            end
    
            fprintf('\n Creating : \n %s ==> \n %s\n', rgb_fileName, gray_fileName);
            
            
            S_rgb = load(rgb_fileName);
            [h, w, n3, nSamples] = size(S_rgb.X);
            assert(n3 == 3);

            newH = h * sizeIncreaseFactor;
            newW = w * sizeIncreaseFactor;
            X_gray = zeros(newH,newW,nSamples, class(S_rgb.X));

            T    = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
            coeff = T(1,:);
            pBar_step = 100;
            progressBar('init-', nSamples/pBar_step)

            for si = 1:nSamples
                xi_rgb = S_rgb.X(:,:,:,si);
                xi_gray = rgb2gray(xi_rgb);

                if sizeIncreaseFactor > 1
                    xi_gray = scaleUpImage(xi_gray, sizeIncreaseFactor, scale_method);                
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
            S_gray.labels = single(S_rgb.y);
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


