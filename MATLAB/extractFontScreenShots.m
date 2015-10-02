function extractFontScreenShots

%     fontsFile = [lettersPath 'fonts.mat'];
    fontsMainFolder = [lettersPath 'fonts' filesep 'fonts_from_word' filesep];    

    doAllFiles = 0;
    doUpdatedFiles = 1;
    
    allFonts = subfolders(fontsMainFolder);
    idx_skip = strncmp(allFonts, '~', 1);
    allFonts(idx_skip) = [];
%     allFonts = {'Kuenstler'};
    %%
    for fi = 1:length(allFonts)
        %%
        font_i = allFonts{fi};
        fprintf('* %s *\n', font_i);
        
        
        fontTypes = subfolders([fontsMainFolder font_i]);
        
        for fti = 1:length(fontTypes)
            %%
            fontType_i = fontTypes{fti};
            fprintf('  - %s \n', fontType_i);
            dir_i = [fontsMainFolder font_i filesep fontType_i filesep];
            screen_shot_dir_i = [dir_i 'screenshots' filesep];
            s_screenshots = dir(screen_shot_dir_i);
            s_extracted = dir(dir_i);
            %%
            screenshot_files = {s_screenshots(~[s_screenshots.isdir]).name};
            extracted_files = {s_extracted(~[s_extracted.isdir]).name};
            
            if doAllFiles
                filesToDo = screenshot_files;
            else
                new_files = setdiff(screenshot_files, extracted_files);
                have_files = intersect(screenshot_files, extracted_files);
                haveNewVersion = false(1, length(have_files));
                for i = 1:length(have_files)
                    idx_screen = find(strcmp({s_screenshots.name}, have_files{i}), 1);
                    idx_extracted = find(strcmp({s_extracted.name}, have_files{i}), 1);
                    if s_screenshots(idx_screen).datenum > s_extracted(idx_extracted).datenum
                        haveNewVersion(i) = 1;
                    end
                end
                updated_files = screenshot_files(haveNewVersion);

                filesToDo = new_files;
                if doUpdatedFiles
                    filesToDo = sort([filesToDo, updated_files]);
                end
            end
            
            for file_i = 1:length(filesToDo)
                %%
                src = [screen_shot_dir_i filesToDo{file_i}];
                dst = [dir_i filesToDo{file_i}];
                                
                extractFileInfoFromScreenGrab(src, dst);
                fprintf('%s\n', dst);
                
            end
            
        end
        
        
    end




end


function extractFileInfoFromScreenGrab(src, dst)
    
    
    image_rgb = imread(src);
%     image_grey = rgb2gray(image_rgb);
    %%
    is_red = (image_rgb(:,:,1) == 255 & image_rgb(:,:,2) == 0 & image_rgb(:,:,3) == 0) + 0;

    [m,n] = size(is_red);
    is_red_shL = is_red(:, [n, 1:n-1]);
    is_red_shD = is_red([m, 1:m-1], :);
%                 is_red_shL = is_red([2:m, 1], [2:n, 1]);

    tl_corners = is_red & ~is_red_shL & ~is_red_shD;

    [red_corner_top,red_corner_left] = find(tl_corners);
    [red_corner_bot,red_corner_right] = deal(red_corner_top,red_corner_left);
    for i = 1:length(red_corner_bot)
        while is_red(red_corner_bot(i)+1, red_corner_right(i))
            red_corner_bot(i) = red_corner_bot(i) + 1;
        end
        while is_red(red_corner_bot(i), red_corner_right(i)+1)
            red_corner_right(i) = red_corner_right(i) + 1;
        end

    end


    for i = 1:length(red_corner_top)
        is_red(red_corner_top(i):red_corner_bot(i), red_corner_left(i):red_corner_right(i)) = 10;
    end
    %%
    areas = (red_corner_top - red_corner_bot) .* (red_corner_left - red_corner_right);

    [sorted_areas, idx] = sort(areas, 'descend');
    if length(sorted_areas) > 2
        assert(sorted_areas(2)/sorted_areas(3) > 5);
    end
    idxs_use = sort(idx(1:2));

    idx_UL = idxs_use(1);
    idx_LR = idxs_use(2);

    margin = 5;

    

    im_use = image_rgb( red_corner_bot(idx_UL) + margin : red_corner_top(idx_LR) - margin, red_corner_right(idx_UL) + margin : red_corner_left(idx_LR) - margin, :);
    showOrig = 0;
    showExtracted = 1;
    if showOrig
        %%
        figure(1); clf;
        image(image_rgb);
    end
    if showExtracted
        %%
        [~, fn, ext] = fileparts(dst);
        figure(2); clf;
        imagesc(rgb2gray(im_use));
        colormap('gray');
        ticksOff;
        imageToScale([], 1);
        pos = get(gca, 'position');
        set(gca, 'position', [1 1 pos(3:4)]);
        title([fn, ext], 'interpreter', 'none');
        refresh;
    end
    imwrite(im_use, dst);
    


end

