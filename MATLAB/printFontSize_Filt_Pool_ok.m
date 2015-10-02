function printFontSize_Filt_Pool_ok(fontSizeArg, filtSizes, poolSizes)
    if iscell(fontSizeArg) && length(fontSizeArg) == 2
        fontName = fontSizeArg{1};
        fontSize = fontSizeArg{2};
        [~,fontData] = loadLetters(fontName, fontSize);
        k_height = fontData.k_height;
        L = max(fontData.size);
        fontBoxSize = fontData.size;
    elseif length(fontSizeArg) == 2
        fontBoxSize = fontSizeArg;
        
    end
        
    
    
    
%     margin = floor( (imageSize - L) / 2 );
    fprintf('FontBox = %d x %d : \n', fontBoxSize );
    
    for dim = 1:2
        if dim == 1
            L = fontBoxSize(1);
            fprintf('--Height:\n');
        elseif dim == 2;
            L = fontBoxSize(2);
            fprintf('--Width:\n');
        end
%     fprintf('Font = %s. size = %s. font box = %dx%d, imageSize = %d x %d. : \n', fontName, num2str(fontSize) );
    
        maxImageSize = 300;
        allMinImageSizes = zeros(length(filtSizes), length(poolSizes));

        for fi = 1:length(filtSizes)
            filtSize = filtSizes(fi);
            for pi = 1:length(poolSizes);
                %%
                poolSize = poolSizes(pi);

    %             f_out_size = (imageSize-filtSize+1);
    %             p_out_size = poolSize * floor( f_out_size / poolSize);

                allImageSizes = 1:maxImageSize;

                minNPoolWindows = ceil ((L + filtSize) / poolSize);

                im_canFitFilt = allImageSizes > (L + filtSize * 2);
                im_canFitPool = (allImageSizes - filtSize + 1)/poolSize >= minNPoolWindows;
                im_sizes_ok = im_canFitFilt  & im_canFitPool;

                minImageSize = allImageSizes ( find(im_sizes_ok, 1) );
                allMinImageSizes(fi, pi) = minImageSize;

                fprintf('   filtSize = %d. poolSize = %d. minSize = %d\n', filtSize, poolSize, minImageSize);
                3;
            end
        end
        3;
        imSize(dim) = max(allMinImageSizes(:));
    end
    fprintf('\n min image size = %d x %d\n', imSize );
    3;
    
    
    
    
    
end