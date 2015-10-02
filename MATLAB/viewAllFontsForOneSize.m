function viewAllFontsForOneSize(fontSize)

%%
%     allFonts = {'
%     allFontNames  = {'BookmanU', 'Bookman',  'BookmanUB', 'BookmanB', 'HelveticaU', 'Helvetica', 'CourierU', 'Courier',  ...
%         'Hebraica', 'Yung', 'KuenstlerU', 'Sloan', 'Braille', 'Checkers4x4', 'Devanagari', 'Armenian'};
%     allFontNames  = {'BookmanU', 'Bookman', 'KuenstlerU', 'Braille'};
    allFontNames  = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};
    includeKuenstler = 1;
    if ~includeKuenstler
        allFontNames = allFontNames( ~strncmp(allFontNames, 'Kuenstler', 9) );
    end
        
    sizeSpec = 'maxSize';
    
%     [fontAbbrev,fontAbbrev_med,fontList] = abbrevFontStyleNames(allFontNames, 'font', struct('dontSort', 1));
    
    nFonts = length(allFontNames);
    runningFromCmdLine = exist('isBase', 'var');
    if runningFromCmdLine  || (nargin < 1)
        fontSize = 'k48';
%         fontSize = 'x32';
    end
    nLettersEachFont = 26;
    let_use_idx = 1:nLettersEachFont;
%     let_use_idx = unique([let_use_idx, 11, 12, 15, 16, 20, 24]);
    nLettersEachFont = length(let_use_idx);
    clear S_all S fontData
    for fi = 1:nFonts
        
%         fontName_full = all
        [S_all{fi}, fontData(fi)] = loadLetters(allFontNames{fi}, fontSize, sizeSpec);
        let_use_idx_here = let_use_idx;
        nHere = size(S_all{fi},3);
        idx_over = let_use_idx_here > nHere;
        if any(idx_over);
            let_use_idx_here(idx_over) = let_use_idx_here(idx_over) - 5;
        end
        S{fi} = S_all{fi}(:,:,let_use_idx_here);
    end
    
    showLines = 0;
    typ = [fontData.typography];
    allBaselines = [typ.baseline];
    allMedians   = [typ.median];
    allCaps   = [typ.cap];
    allDecenders   = [typ.decender];
    if showLines
        for fi = 1:nFonts
            S{fi}(allDecenders(fi),:,:)  = 0.4;
            S{fi}(allMedians(fi),:,:)  = 0.4;

            S{fi}(allBaselines(fi),:,:) = 0.7;
            S{fi}(allCaps(fi),:,:)     = 0.7;
        end
    end    
    [s_im, imageStack] = tileImages(S, -nLettersEachFont, nFonts, 2, 0.9, {allBaselines, 'center'} );
%     allH = 
%     maxH = 
    figure(25); clf;
    imagesc(s_im); colormap('gray');
    ticksOff;
    pos = get(gca, 'position');
    set(gca, 'position', [0, 0, pos(3), pos(4)]);
    imageToScale([], 1)
    
    pos_pix = get(gca, 'position');
    
    blockEdges = round(linspace(pos_pix(1), pos_pix(1)+pos_pix(3), nFonts+1));
    dblock = diff(blockEdges(1:2));
%     blockCents = binEdge2cent(blockEdges);
    hnd = [];
    
    if dblock < 50
        [fontAbbrev,fontAbbrev_med,fontList] = abbrevFontStyleNames(allFontNames, 'font', struct('dontSort', 1));
        fontAbbrev_med_C = strsplit(fontAbbrev_med, '_');
        allFontNames_show = fontAbbrev_med_C;
    else
        allFontNames_show = allFontNames;
    end
    
    for i = 1:nFonts
%         [blockEdges(i), pos_pix(2), dblock, 20]
        hnd(i) = annotation('textbox', [0 0 .1 .1], 'units', 'pixels', 'position', [blockEdges(i), pos_pix(2)+pos_pix(4)+5, dblock, 30], 'string', allFontNames_show{i}, 'horiz', 'center', 'fontsize', 8);
    end
    
    
    

    
    %%
    fprintf('Image Size for all fonts : %d x %d\n', size(imageStack,1), size(imageStack,2) );
    fprintf('Sizes     : %s \n', sprintf('%3d ', [fontData.fontsize]) ); 
    fprintf('k_heights : %s \n', sprintf('%3d ', [fontData.k_height]) ); 
    fprintf('x_heights : %s \n', sprintf('%3d ', [fontData.x_height]) ); 
    %%
    
    


end