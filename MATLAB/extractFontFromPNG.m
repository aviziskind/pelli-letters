function [allLetters_out, S_out] = extractFontFromPNG(fontName, fontSize, redoFlag)

%     fontsFile = [lettersPath 'fonts.mat'];
    fontsMainFolder = [lettersDataPath 'fonts' filesep 'fonts_from_word' filesep];    

%     leftAlignKuenslterFont = 1;
    opt.centerAlignFonts = 1;

    opt.truncKuenstlerN = 1;
    opt.useDeslantedKuenstlerAsItalic = 1;
        opt.Kuenstler_shearAngle = -30;
        opt.Kuenstler_realItalicSymbol = 'i';
        opt.saveSloanTenFont = 0;

    opt.orientations = [0:5:90];    
    opt.margin_pixels = 0;
    opt.margin_pixels_rotated = 0;

    redoAll = 0 || exist('redoFlag', 'var') && isequal(redoFlag, 1);
        redoFontsIfOlderThan = 736231.380973 ; %  sprintf('%.6f', now)
    
    
    if (nargin < 1) || isempty(fontName) || strcmp(fontName, 'all') || ~isempty(strfind(fontName, '*'))
        if exist('fontName', 'var')  &&  ~isempty(strfind(fontName, '*'))
            allFontNames = subfolders ([fontsMainFolder strrep(fontName, '*', '\')]);
        else 
            allFontNames = subfolders (fontsMainFolder);
        end
        allFontNames = allFontNames(~strcmp(allFontNames, '~old'));
%         allFontNames = {'Kuenstler'};
        for fi = 1:length(allFontNames)
            
            allFontNames_detail = subfolders ([fontsMainFolder allFontNames{fi}]);
            for fdi = 1:length(allFontNames_detail)
                fprintf('===== Font: %s (%d/%d) : Processing Type: %s (%d/%d) ... ==== \n', allFontNames{fi}, fi, length(allFontNames), allFontNames_detail{fdi}, fdi, length(allFontNames_detail) );
                extractFontFromPNG(allFontNames_detail{fdi}, [], redoAll);
            end
        end
        addSummaryOfFontSizesToFontFile;
        loadLetters('save');
        createFontSizesFile;
        return;
    end
        
    [rawFontName, fontAttrib] = getRawFontName(fontName);
    italic_tf = fontAttrib.italic_tf;
    outline_w = fontAttrib.outline_w;

    fontsFolder = [fontsMainFolder rawFontName filesep fontName filesep];
    
    if (nargin < 2) || isempty(fontSize) || strcmp(fontSize, 'all')
        curFiles = dir([fontsFolder '*.png']);
        fontSizes_files_C = arrayfun(@(f) sscanf(f.name, [fontName '_%d.png']), curFiles, 'un', 0);
        fontSizes = [fontSizes_files_C{:}];
        [fontSizes, idx] = sort(fontSizes);
        file_dates = [curFiles(idx).datenum];
        
        S_fonts = loadLetters;
        
        addedSomeData = 0;
        for sz_i = 1:length(fontSizes)
            
            font_fld_curFontSize = sprintf('%s_%02d', fontName, fontSizes(sz_i));
            
            haveThisFontSize = isfield(S_fonts, font_fld_curFontSize);
            
            data_too_old = haveThisFontSize && (~isfield(S_fonts.(font_fld_curFontSize), 'datenum') ...
                || S_fonts.(font_fld_curFontSize).datenum <= file_dates(sz_i) ... 
                || S_fonts.(font_fld_curFontSize).datenum <= redoFontsIfOlderThan);
                  
            if ~haveThisFontSize || data_too_old || redoAll 
                extractFontFromPNG(fontName, fontSizes(sz_i), redoAll);
                addedSomeData = 1;
            end

            
                need_to_do_italic_version = 0;
                if strcmp(rawFontName, 'Kuenstler') && ~italic_tf && opt.useDeslantedKuenstlerAsItalic
                    font_fld_curFontSize_italic = sprintf('%s_%02d', [fontName 'I'], fontSizes(sz_i));

                    need_to_do_italic_version = ~isfield(S_fonts, font_fld_curFontSize_italic) || ((~isfield(S_fonts.(font_fld_curFontSize_italic), 'datenum') ...
                        || S_fonts.(font_fld_curFontSize_italic).datenum <= file_dates(sz_i) ... 
                        || S_fonts.(font_fld_curFontSize_italic).datenum <= redoFontsIfOlderThan)) || redoAll;
                end
                if (need_to_do_italic_version)
                    extractFontFromPNG([fontName 'I'], fontSizes(sz_i));
                end

        end
            
%         fontBold = fontDetails(2,:);
        if addedSomeData || true
            addSummaryOfFontSizesToFontFile(fontName);
        end
%%
%         SS = load(fontsFile);
%         SS = orderfields(SS);
%         SS.(fontName) = summary.(fontName);
%         save(fontsFile, '-struct', 'SS');
        return;
    end

    if nargin < 3
        bold_tf = 0;
    end
    
    file_ext = '.png';
    
    fprintf('------ Processing %s, size %d  ----- \n', fontName, fontSize);

    % 1. Extract letters from image.

    font_descrip = sprintf('%s_%02d', fontName, fontSize);
    
    [rawFontName, fontAttrib] = getRawFontName(fontName);
%     upper_tf = fontAttrib.upper_tf;
%     bold_tf = fontAttrib.bold_tf;
%     italic_tf = fontAttrib.italic_tf;

%     upper_str = iff(upper_tf, 'U', '');
%     bold_str = iff(bold_tf, 'B', '');
%     italic_str = iff(italic_tf, 'I', '');
    
    
    deslantLettersNow = strcmp(rawFontName, 'Kuenstler') && fontName(end) == 'I' && opt.useDeslantedKuenstlerAsItalic;
    if deslantLettersNow
        fontAttrib_nonItalic = fontAttrib;
        fontAttrib_nonItalic.italic_tf = 0;
        fontName_nonItalic = getFullFontName(rawFontName, fontAttrib_nonItalic);
        
        font_descrip = sprintf('%s_%02d', fontName_nonItalic, fontSize);
        
        fontsFolder = [fontsMainFolder rawFontName filesep fontName_nonItalic filesep];
    end
%     if strcmp(rawFontName, 'Kuenstler')
%         if any(strcmp(fontName, {'KuenstlerUI', 'KuenstlerUBI'}))
% %             italic_str = 
%         elseif any(strcmp(fontName, {'KuenstlerUi', 'KuenstlerUBi'}))
%             
%         else
%             
%             
%         end
%         
%     end
%         
% %     if italic_tf 
% %         italic_str = iff(strcmp(rawFontName, 'Kuenstler') && opt.useDeslantedKuenstlerAsItalic, opt.Kuenstler_realItalicSymbol, 'I');
%     else
%         italic_str = '';
%     end

        
    fontName_save = fontName; % [rawFontName, upper_str, bold_str, italic_str];

    
%     file_ext = '.bmp';
    
    file_fullname = [fontsFolder font_descrip file_ext];
    
    allLetters_raw = extractLettersFromImageFile(file_fullname, opt);
    
    
    shearAngle = 0;
    if deslantLettersNow
        allLetters_raw = makeFontItalic(allLetters_raw, opt.Kuenstler_shearAngle);
        shearAngle = opt.Kuenstler_shearAngle;
    end

    %%
    fontData = measureFontStatistics(fontName_save, allLetters_raw, opt);
    allLetters = fontData.letters;
    fontData.fontsize = fontSize;
    fontData.shearAngle = shearAngle;
    
    
    loadLetters(fontName_save, fontSize, [], fontData);
 
    S = fontData;


    % Printout
    fprintf('   C0 = %.1f. C1 = %.1f. C2 = %.1f\n\n', S.complexity_0, S.complexity_1, S.complexity_2)

    oris_rotated = opt.orientations;
    idx_5  = find(oris_rotated==5,1);
    idx_10 = find(oris_rotated==10,1);
    idx_15 = find(oris_rotated==15,1);
    idx_20 = find(oris_rotated==20,1);

    fprintf('          -> %d x %d.  %d x %d,  %d x %d,  %d x %d,  %d x %d. \n', ...
        S.size, S.size_rotated([idx_5, idx_10, idx_15, idx_20], :)' );


     % Display fonts
     showOrigImage = 0;
     showExtractedLetters = 1;

    if showOrigImage
        %%
        figure(1); clf;
        h_im = imagesc(image_grey);

        hold on    
        plot(corners_j,corners_i, 'ro');
    end

    idx_use = 1:size(allLetters,3);
    sloan10_letters = 'CDHKNORSVZ';
    idx_use_sloan10 = binarySearch(double('A':'Z'), double(sloan10_letters));
    
    if strcmp(fontName, 'Sloan') && opt.saveSloanTenFont
        %%
%         idx_use = idx_use_sloan10;
        
    end
    
    if showExtractedLetters
       %%
%        figure(4);
%        imagesc(sumLetters);
       %%
       showRotated = 0;

       if showRotated
          
           allLettersRotated_plot1 = rotateLetters(allLetters, oris_rotated(end));
           allLettersRotated_plot2 = rotateLetters(allLetters, -oris_rotated(end));
           [idxT_rot, idxB_rot, idxL_rot, idxR_rot] = findLetterBounds(cat(3, allLettersRotated_plot1, allLettersRotated_plot2), opt.margin_pixels_rotated + 1);

            allLetters_tiled = tileImages(allLetters, 3);
            allLetters_tiled_plot1 = tileImages(allLettersRotated_plot1(idxT_rot:idxB_rot, idxL_rot:idxR_rot,:), 3, [], 1, 1);
            allLetters_tiled_plot2 = tileImages(allLettersRotated_plot2(idxT_rot:idxB_rot, idxL_rot:idxR_rot,:), 3);
       else
%            allLetters_tiled = tileImages(allLetters, 4, 7, 1, 0.5);
           allLetters_tiled = tileImages(allLetters(:,:,idx_use), 2, 5, 10, 0);
            
            
       end

        figure(2); clf;
        if showRotated
            h_ax(1) = subplot(3,1,1);
            imagesc(allLetters_tiled);

            h_ax(2) = subplot(3,1,2);
            imagesc(allLetters_tiled_plot1);

            h_ax(3) = subplot(3,1,3);
            imagesc(allLetters_tiled_plot2);
        else
            h_ax = axes;
            imagesc(allLetters_tiled);
        end
        colormap('gray')
%         linkaxes(h_ax, 'xy');
        imageToScale;
        label_str = sprintf('%s. size = %d', fontData.fontName, fontSize);
        title(label_str);
        xlabel(label_str);

        set(h_ax, 'xtick', [], 'ytick', []);
        3;
%         mm = floor(sqrt(nLetters)); nn = ceil(nLetters / mm);
%         figure(2); clf;
%         for i = 1:nLetters
%             % bnd = signal(i).scratchBounds;
%             subplot(mm,nn,i); imagesc(allLetters_orig(:,:,i))
%             set(gca, 'xtick', [], 'ytick', []);
%     %         sigMatrix(:,:,i) = signal(i,1,1).image;
%         end
%         colormap('gray')
        3;
%         return
    end

    showHeights = 0;
    if showHeights
%         allKLetters_tiled = tileImages(allLetters(:,:,k_height_idxs),
%         3);
%%

        figure(55);
        show_idxs = [k_idx, idx_fullSizeLetters(~let_sameHeight)];
        allKLetters_tiled = tileImages(allLetters(:,:,show_idxs), 1, length(show_idxs));
        imagesc(allKLetters_tiled); axis equal tight; colormap('gray');
        3;

        if length(unique(k_height)) > 1
            3;
        end

        4;
%         k_height_idxs = [b_idx, k_idx, f_idx, d_idx, p_idx];
%         b_height = allHeights(b_idx);
%         k_height = allHeights(k_idx);
%         f_height = allHeights(f_idx);
%         d_height = allHeights(d_idx);
%         p_height = allHeights(p_idx);


    end

    
    
    %%
    
    if nargout > 0
        allLetters_out = allLetters;
    end
    if nargout > 1
        S_out = S;
    end
        
    



end

function [all_corners_i,all_corners_j] = findAllCorners(font_image)

    nExt = 6;
    nOffset = 2;
    corner_template = zeros(nExt, nExt);
    corner_template(nOffset,:) = 255;
    corner_template(:,nOffset) = 255;

    
    [m,n] = size(font_image);
    shiftedUp   = [font_image(2 : m,:); zeros(1, n)];
    shiftedLeft = [font_image(:,2:n), zeros(m,1)];
    shiftedUpLeft = [[font_image(2:m,2:n); zeros(1,n-1)], zeros(m,1)];
    
    
%     X = font_image/max(font_image(:))*.1 + 
    %%
    ON = 255; OFF = 0;
    isCorner = (font_image == ON) & (shiftedLeft == ON) & (shiftedUp == ON) & (shiftedUpLeft == OFF);
    [potential_corners_j, potential_corners_i] = find(isCorner');
    idx_remove = (potential_corners_i) > m-nExt | (potential_corners_j > n-nExt);
    potential_corners_i(idx_remove) = [];
    potential_corners_j(idx_remove) = [];
    
%     figure(59); clf;
%     imagesc(font_image); hold on; colormap('gray')
%     plot(potential_corners_j, potential_corners_i, 'ro');
    %%
    
    idx_add = [1:nExt]-nOffset;

     
    all_corners_i = zeros(1,26);            
    all_corners_j = zeros(1,26);            
    corner_idx = 1;
    
    for idx = 1:length(potential_corners_i)
        i = potential_corners_i(idx);
        j = potential_corners_j(idx);
        
        if isequal(font_image(i + idx_add,j + idx_add), corner_template)
            all_corners_i(corner_idx) = i;
            all_corners_j(corner_idx) = j;

            corner_idx = corner_idx + 1;               
        end
    end
    
    
%%    
%{
    all_corners_i2 = zeros(1,26);            
    all_corners_j2 = zeros(1,26);            
    corner_idx = 1;
        
    
    [m,n] = size(font_image);
    for j = nOffset:n-nExt
        for i = nOffset:m-nExt            
            if isequal(font_image(i + idx_add,j + idx_add), corner_template)  % first check small version
                all_corners_i2(corner_idx) = i;
                all_corners_j2(corner_idx) = j;
                
                corner_idx = corner_idx + 1;
                
            end
        end
    end
    
   assert(isequal(all_corners_i, all_corners_i2))
   assert(isequal(all_corners_j, all_corners_j2))
    
  %}  
    3;
end


      

function checkOtherTallLettersAreKheight(allLetters, fontName)
    
    margin_pixels = 0;
    allLetters_char = 'A':'Z';
    k_idx = find(allLetters_char == 'K', 1);
    [idxT_each, idxB_each, idxL_each, idxR_each] = findLetterBounds(allLetters, margin_pixels, 1);
    allHeights = idxB_each-idxT_each+1;
    
    nLetters = size(allLetters,3);
    
    fullSizeLetters = upper('bdfhklpqy');
    idx_fullSizeLetters = binarySearch(double(allLetters_char), double(fullSizeLetters));
    
    
    if strncmp(fontName, 'Yung', 4)
        return
    end
    
    allCapsFont = strncmp(fontName, 'Sloan', 5) || strncmp(fontName, 'Hebraica', 8) || ...
        any(fontName(end-2:end) == 'U');

    if allCapsFont
        idx_fullSizeLetters = 1:nLetters;
        if strncmp(fontName, 'Kuenstler', 9)
            idx_rm = binarySearch(double(allLetters_char), double('EGJ'));
            idx_fullSizeLetters = setdiff(idx_fullSizeLetters, idx_rm);
        end
        if strncmp(fontName, 'BookmanU', 8) || strncmp(fontName, 'GeorgiaU', 8)
            idx_rm = binarySearch(double(allLetters_char), double('CGOSQ'));
            idx_fullSizeLetters = setdiff(idx_fullSizeLetters, idx_rm);
        end
        if strncmp(fontName, 'CourierU', 8) 
            idx_rm = binarySearch(double(allLetters_char), double('Q'));
            idx_fullSizeLetters = setdiff(idx_fullSizeLetters, idx_rm);
        end
        if strncmp(fontName, 'Hebraica', 8) 
            idx_rm = binarySearch(double(allLetters_char), double('JLS')); % yud, lamed, kuf
            idx_fullSizeLetters = setdiff(idx_fullSizeLetters, idx_rm);
        end
        if strncmp(fontName, 'Helvetica', 9)
            idx_rm = binarySearch(double(allLetters_char), double('CGOSQ')); 
            idx_fullSizeLetters = setdiff(idx_fullSizeLetters, idx_rm);
        end

%         elseif strcmp(fontName, 'Braille') || strcmp(fontName, 'Checkers4x4')

    else
        if strncmp(fontName, 'Kuenstler', 9)
            idx_rm = binarySearch(double(allLetters_char), double('FDQY')); 
            idx_fullSizeLetters = setdiff(idx_fullSizeLetters, idx_rm);
        end
        if strncmp(fontName, 'Helvetica', 9) || strncmp(fontName, 'ComicSans', 9)
            idx_rm = binarySearch(double(allLetters_char), double('PQY')); 
            idx_fullSizeLetters = setdiff(idx_fullSizeLetters, idx_rm);
        end
    end

        
    botDiff = abs( idxB_each(idx_fullSizeLetters) - idxB_each(k_idx) );
    topDiff = abs( idxT_each(idx_fullSizeLetters) - idxT_each(k_idx) );
    allDiffs = abs( allHeights(idx_fullSizeLetters) - allHeights(k_idx) );
    allMaxDiff = max(  topDiff, botDiff );

    pctDiff = (allDiffs ./ allHeights(idx_fullSizeLetters) )*100;
    let_sameHeight = allMaxDiff <= 1 | allDiffs <= 1  | pctDiff < 8;
    
    if ~let_sameHeight
        %%
         figure(55);
        show_idxs = [k_idx, idx_fullSizeLetters(~let_sameHeight)];
        allKLetters_tiled = tileImages(allLetters(:,:,show_idxs), 1, length(show_idxs));
        imagesc(allKLetters_tiled); axis equal tight; colormap('gray');
        3;
    end
    
    assert( all( let_sameHeight ) )
end    
        


function allLetters = extractLettersFromImageFile(filename_full, opt)

    image_rgb = imread(filename_full);

    image_grey = rgb2gray(image_rgb);
    image_size = size(image_grey);

    [corners_i,corners_j] = findAllCorners(image_grey);
    nCorners = length(corners_i);

    %%
    uCornersI = unique(corners_i);
    uCornersJ = unique(corners_j);
    boxH = min(diff(uCornersI))-1;
    boxW = min(diff(uCornersJ))-1;

    allBoxes = zeros(boxH, boxW, nCorners);

    idx_i = [1:boxH];
    idx_j = [1:boxW];

    for cr_i = 1:nCorners
        if (corners_i(cr_i) + boxH < image_size(1)) && (corners_j(cr_i) + boxW < image_size(2))
            allBoxes(:,:,cr_i) = image_grey(corners_i(cr_i) + idx_i, corners_j(cr_i) + idx_j);
        end
    end
    sumBoxVals = squeeze(sum(sum(allBoxes,1),2));
    hasLetter = sumBoxVals > 1;
    nLetters = nnz(hasLetter);

    allLetters_inBox = allBoxes(:,:,hasLetter);
    %%
    % make sure none of the letters are touching the edges of the box
    % (might mean they're cut off)
    assert( all(all( allLetters_inBox(:,1,:) == 0)) ); % left edge
    assert( all(all( allLetters_inBox(:,end,:) == 0)) ); % right edge
    assert( all(all( allLetters_inBox(1,:,:) == 0)) ); % top edge
    assert( all(all( allLetters_inBox(end,:,:) == 0)) ); % bottom edge
    if 0
        %%
        allLetters_inBox( allLetters_inBox(:,1,:) > 0 ) == 10
        allLetters_inBox( allLetters_inBox(:,end,:) > 0 ) == 10
        allLetters_inBox( allLetters_inBox(1,:,:) > 0 ) == 10
        allLetters_inBox( allLetters_inBox(end,:,:) > 0 ) == 10

    end
    % for Kuenstler font, bring in some of the outliers (specifically, W):
    %%

    [idxT, idxB, idxL, idxR] = findLetterBounds(allLetters_inBox, opt.margin_pixels);


    %%
    allLetters = allLetters_inBox(idxT:idxB, idxL:idxR, :);
    
    %%
    
    % 2. Trim margins.

    % first align all fonts to the left, to get bounds
    allLetters = leftAlignLetters(allLetters);       
    nLetters = size(allLetters, 3);

    allLetters_char = 'A':'Z';

    idx_use_for_bound = 1:nLetters;
    [~, filename_base] = fileparts(filename_full);
    if opt.truncKuenstlerN && strncmp(filename_base, 'Kuenstler', 9)
        idx_use_for_bound( allLetters_char == 'N' ) = [];
    end

    [idxT, idxB, idxL, idxR] = findLetterBounds(allLetters(:,:,idx_use_for_bound), opt.margin_pixels);

    allLetters = allLetters(idxT:idxB, idxL:idxR, :);

    
    
    
end



%{
  
%     S.(font_descrip) = 
   
   
%     append_str = iff(exist(fontsFile, 'file'), {'-append'}, {});
%     save(fontsFile, '-struct', 'S', append_str{:}, '-v6');
    
  %}




% OUTLINE in pts     THICKNESS in pixels
%%
%{
X = ...
[...

0.7         1;
1.0         1.62;
1.2         2;
1.5         2.5;
1.8         3;


2.0         3.37;
3.0         5;
4.0         6.75];

%}