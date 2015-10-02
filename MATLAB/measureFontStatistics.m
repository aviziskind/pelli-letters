function fontData = measureFontStatistics(fontName, allLetters, opt)
 
    [rawFontName, fontAttrib] = getRawFontName(fontName);
    upper_tf = fontAttrib.upper_tf;
    bold_tf = fontAttrib.bold_tf;
    italic_tf = fontAttrib.italic_tf;
    % Center align fonts
    
    if opt.centerAlignFonts
         allLetters = centerAlignLetters(allLetters);        
    end

    % find bounding box sizes, mean heights/widths
    [nH, nW, nLetters] = size(allLetters);
    fprintf('   Image box is %d x %d (height x width)\n', nH, nW);

    [idxT_each, idxB_each, idxL_each, idxR_each] = findLetterBounds(allLetters, opt.margin_pixels, 1);
    allHeights = idxB_each-idxT_each+1;
    allWidths = idxR_each-idxL_each+1;
    nH_av = mean(allHeights);
    nW_av = mean(allWidths);
    fprintf('   Average letter is %.1f x %.1f (height x width)\n', nH_av, nW_av);


    % height/widths after being rotated
    oris_rotated = opt.orientations;

    printRotatedBoundingBoxes = 0;
    [nH_rot, nW_rot] = getBoundOfRotatedLetters(allLetters, oris_rotated, opt.margin_pixels_rotated, printRotatedBoundingBoxes);


    %%%% k-height
    allLetters_char = 'A':'Z';
    
%     switch rawFontName
%         case 'Hebraica', 
%     
%         case 'Yung', 
%             k_height = ceil(median(allHeights));
% 
%         case {'Braille', 'Checkers4x4', 'Bookman', 'Courier', 'Helvetica', 'Sloan', 'Kuenstler' }
%             k_idx = find(allLetters_char == 'K', 1);
%             k_height = allHeights(k_idx);
% 
%         otherwise,
%             error('Unhandled case');
%     end
    
    k_char = 'K';
    x_char = 'X';
    q_char = 'Q'; % or p
    
    k_height = [];
    x_height = [];
    baseline = [];
    
    x_height_factor = [];
    
    x_height_factor_default = 2/3;
    
    % x-height
    switch rawFontName
        
        case {'Bookman', 'Helvetica', 'Courier', 'Kuenstler'}  % these have a upper & lower-case version
           
            if strcmp(rawFontName, 'Kuenstler')
                q_char = 'G';
            end
            
            if upper_tf  % have to make approximation for lower-case x-height. 
                x_height_factor = x_height_factor_default;
            end  % else - if lowercase, will use x-char for x-height
        
        case {'Braille', 'Checkers4x4', 'Sloan'};  % these fonts don't have uppercase/lower-case versions, and most characters just fill up the entire height.
%                         
            x_height_factor = x_height_factor_default;

        case 'Hebraica', 
            
            k_char = 'L'; % lamed   - extends higher
            x_char = 'A'; % alef
            q_char = 'S'; % kuf;    - extends below baseline
                       
        case 'Armenian',
            x_char = 'X';  % m-type letter
            k_char = 'J';  % d-type letter
            q_char = 'F';  % q-type letter
            
            
        case 'Yung',
            q_char = 'Z'; % this one decends below
            
            k_height = ceil(median(allHeights));
            
            x_height_factor = x_height_factor_default;
            
            baseline = ceil(median(idxB_each));
            
            
         case 'Devanagari'
            q_char = 'O'; % this one decends below
            
            k_height = ceil(median(allHeights));
            
            x_height_factor = x_height_factor_default;
            
            baseline = ceil(median(idxB_each));
            
        otherwise
            error('Unhandled case');
    end

    
    
    k_idx = find(allLetters_char == k_char, 1);
    k_char_letter = allLetters(:,:,k_idx);

    x_idx = find(allLetters_char == x_char, 1);
    x_char_letter = allLetters(:,:,x_idx);

    q_idx = find(allLetters_char == q_char, 1);
    q_char_letter = allLetters(:,:,q_idx);

    
    if isempty(k_height)  % if not defined manually (for Yung & Devanagari), k-height is the height of a k-char
        k_height = allHeights(k_idx);
    end
    
    if ~isempty(x_height_factor) % for english fonts without lower case letters (eg Sloan, or BookmanU), or checkers fonts, or script fonts (Yung, Devanagari), define x-height as a fraction of the k-height
        x_height = round(k_height * x_height_factor);
    else  % if is a lower case font, or is clear delimitation of different heights (Armenian or Hebrew), use the height of an x-char
        x_height = allHeights(x_idx);
    end
    

    
    % typographical measures
    
    % x-height
    x_char_profile = sum(x_char_letter,2);
    k_char_profile = sum(k_char_letter,2);
    q_char_profile = sum(q_char_letter,2);
    %%
    typ.cap      =  find(k_char_profile > 0, 1, 'first');
    typ.median   =  find(x_char_profile > 0, 1, 'first');
    if ~isempty(baseline)
        typ.baseline = baseline;
    else
        typ.baseline = find(x_char_profile > 0, 1, 'last');
    end
    typ.decender =  find(q_char_profile > 0, 1, 'last');
    
    testTyp = 0;
    if testTyp
        %%
        figure(67); clf;
        imPlot = tileImages(allLetters, 1, nLetters, 0, 0);
        idx_k_height = typ.baseline - [1:k_height]+1;
        idx_x_height = typ.baseline - [1:x_height]+1;
        
        imPlot(idx_k_height,end+3:end+4) = 255*.6;
        imPlot(idx_x_height,end+6:end+7) = 255*.6;
        
        imPlot(:,end+10) = 0;
        imagesc(imPlot);
        colormap('gray'); 
        axis image;
        drawHorizontalLine([typ.cap], 'color', 'r', 'linestyle', '-');
        drawHorizontalLine([typ.median], 'color', 'b', 'linestyle', '--');
        drawHorizontalLine([typ.baseline], 'color', 'm', 'linestyle', '-');
        drawHorizontalLine([typ.decender], 'color', 'g', 'linestyle', '--');
        
        3;
        
        
    end

%%

    % stroke frequency
    [strokeFrequency_perPix, strokeFrequency_perLet] = getFontStrokeFrequency(allLetters, rawFontName);


    % complexity

    [fontComplexity_0, all_c0] = calculateFontComplexity(allLetters, 0);
    [fontComplexity_1, all_c1, areas1] = calculateFontComplexity(allLetters, 1);
    [fontComplexity_2, all_c2, areas2] = calculateFontComplexity(allLetters, 2);

    boxArea_noMargin = (nH-2*opt.margin_pixels)*(nW-2*opt.margin_pixels);
    fontDensity_bool = mean(areas1) / boxArea_noMargin;
    fontDensity_grey = mean(areas2) / boxArea_noMargin;
    3;
    %%
    assert(min(allLetters(:)) == 0);
    assert( ibetween( max(allLetters(:)), 250, 255.1));
    
    fontData = struct('fontName', fontName, 'rawFontName', rawFontName, 'fontsize', [], 'bold', bold_tf, 'italic', italic_tf, ...
        'uppercase', upper_tf, 'letters', uint8(allLetters), ...
        'size', [nH, nW], 'size_av', [nH_av, nW_av], 'orientations', oris_rotated, 'size_rotated', [nH_rot, nW_rot], ...
        'k_height', k_height, 'x_height', x_height, 'typography', typ, 'strokeFrequency', strokeFrequency_perPix, 'strokeFrequency_perLet', strokeFrequency_perLet, ...
        'complexity_0', fontComplexity_0, 'complexity_1', fontComplexity_1, 'complexity_2', fontComplexity_2, ...
        'fontDensity_bool', fontDensity_bool, 'fontDensity_grey', fontDensity_grey, ...
        'complexity_0_all', all_c0(:), 'complexity_1_all', all_c1(:), 'complexity_2_all', all_c2(:), 'datenum', now);

end
