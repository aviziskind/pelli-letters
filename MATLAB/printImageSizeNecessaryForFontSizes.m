function printImageSizeNecessaryForFontSizes

%     allFonts =  {'BookmanU', 'CourierU', 'Sloan', 'HelveticaU', 'KuenstlerU'};
%     allFonts =  {'Bookman', 'BookmanU', 'Courier', 'Sloan', 'Helvetica', };
%     allFonts  = {'KuenstlerU', 'Bookman', 'BookmanU', 'BookmanUB', 'BookmanB', 'Helvetica', 'Courier',  'Hebraica', 'Yung', 'Sloan', ...
%             'Braille', 'Checkers4x4', ...
        ...'Devanagari', 'Armenian'...
%         };
    allFonts = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};
    
    nFonts = length(allFonts); 

%     all_bold = [0, 1];
%     all_ital = [0, 1];
    all_bold = [0];
    all_ital = [0];

    all_oris = -20:2:20; 
%     all_oris = 0;
    all_xs = [0:2:10];  x_range = all_xs(end)-all_xs(1);
    all_ys = [0:2:16];  y_range = all_ys(end)-all_ys(1);
    k_heights = [24];
    
    getFontName = @(fontName, bold_tf, ital_tf) [fontName, iff(bold_tf, 'B', '') iff(ital_tf, 'I', '')];
    
    [fontBoxH, fontBoxW, fontBoxW_withRot, fontBoxH_withRot] = deal( zeros(1, nFonts) );

    [fontSizes, fontKheights] = deal(zeros(1, nFonts));
    
    for fi = 1:nFonts
        fontName_raw = allFonts{fi};
        
        fontSizes(fi) = getFontSize(allFonts{fi}, sprintf('k%d', max(k_heights))); 
%         fontName = getFontName(fontName_raw, all_bold(bld_i), all_ital(ital_i));
        S_font = loadLetters(fontName_raw);
%         idx_size = find(S_font.k_heights >= max(k_heights), 1, 'first');
        idx_size = find(S_font.sizes == fontSizes(fi), 1);
%         fontSizes(fi) = S_font.sizes(idx_size);
        fontKheights(fi) = S_font.k_heights(idx_size);

        
        for bld_i = 1:length(all_bold)
            for ital_i = 1:length(all_ital)
                %%
                [fontName_raw2, fontAttrib] = getRawFontName(fontName_raw);
                fontAttrib.bold_tf = all_bold(bld_i);
                fontAttrib.italic_tf = all_ital(ital_i);
                
                fontName = getFullFontName(fontName_raw2, fontAttrib);
                S_font = loadLetters(fontName);
                
                idx_size_i = find(S_font.sizes == fontSizes(fi), 1);
                
%                 idx_size = find(S_font.k_heights <= max(k_heights), 1, 'last');
                rot_idx = find(S_font.box_oris >= max(abs(all_oris)), 1);

                boxH(bld_i, ital_i) = S_font.boxH_rot(1, idx_size_i);
                boxW(bld_i, ital_i) = S_font.boxW_rot(1, idx_size_i);
                
                boxH_withRot(bld_i, ital_i) = S_font.boxH_rot(rot_idx, idx_size_i);
                boxW_withRot(bld_i, ital_i) = S_font.boxW_rot(rot_idx, idx_size_i);
                
            end
        end
        fontBoxH(fi) = max(boxH(:));
        fontBoxW(fi) = max(boxW(:));
        fontBoxH_withRot(fi) = max(boxH_withRot(:));
        fontBoxW_withRot(fi) = max(boxW_withRot(:));
        
        fprintf('Font %20s. Size = %d (k%d) : min size is %d x %d (1 pos), %d x %d (+rotations), or %d x %d (rotations+positions) \n', ...
            fontName_raw, fontSizes(fi), fontKheights(fi),  ...
            fontBoxH(fi), fontBoxW(fi), ...
            fontBoxH_withRot(fi), fontBoxW_withRot(fi), ...
            fontBoxH_withRot(fi)+y_range, fontBoxW_withRot(fi)+x_range );

    end
    
    maxH = max(fontBoxH);
    maxW = max(fontBoxW);
    bestFitBox = [maxH, maxW];

    maxH_withRot = max(fontBoxH_withRot);
    maxW_withRot = max(fontBoxW_withRot);
    bestFitBox_withRot = [maxH_withRot, maxW_withRot];
    
    fprintf('One box to fit all fonts: %d x %d (1 pos). %d x %d (+rotations), or %d x %d (rot + pos)\n\n', bestFitBox, bestFitBox_withRot, bestFitBox_withRot + [y_range, x_range]);

    maxNLetters = iff(any(strcmp(allFonts, 'Armenian')), 35, 26);
    %%
    for fi = 1:nFonts;
        [allLet{fi}, data{fi}] = loadLetters(allFonts{fi}, sprintf('k%d', max(k_heights)));
        
        
    end
    %%
    allM = cellfun(@(x) size(x,1), allLet);
    allN = cellfun(@(x) size(x,2), allLet);
%     maxM = max(allM);
%     maxN = max(allN);
    
    for fi = 1:nFonts
%         dm = (maxM - allM(fi));
%         dn = (maxN - allN(fi));
        dm = (maxH - allM(fi));
        dn = (maxW - allN(fi));
        
        dm_top = floor(dm/2);
        dm_bot = dm - dm_top;
        dn_left = floor(dn/2);
        dn_right = dn-dn_left;
        
        allLet_padded{fi} = padarray(padarray(allLet{fi}, [dm_top dn_left], 0, 'pre'), [dm_bot, dn_right], 0, 'post');
        allLet_tile{fi} = tileImages( allLet_padded{fi}, 1, maxNLetters, 1, 0.5);
    end
    allLet_tile_all = tileImages( cat(3, allLet_tile{:}), nFonts, 1, 1, 0.5);
        
    %%
    figure(58); clf;
    imagesc(allLet_tile_all);
    ticksOff;
    colormap('gray');
    imageToScale([], 1);
    
    
    %%
    allSize = 1:50;
%     size_conv = (allSize - 5+1);
    pSz = 2;
    convSize = 5;
    size_conv1 = (allSize - convSize+1);
    size_pool1 = size_conv1/pSz;
    
    size_conv2 = size_pool1 - convSize+1;
    size_pool2 = size_conv2/pSz;
    
    allSize( mod(size_conv1, pSz) == 0  &  mod(size_conv2, pSz) == 0)
    3;
%}








end

