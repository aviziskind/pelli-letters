function printAverageSizesOfFonts(fontName)

%     printout('sml');
%     printout('med');
%     printout('big');
%     printout('large');
    printout('k36');
%     printout('dflt');
%         printout('large');
    return;
%         return;
    if nargin < 1
%         S = load([lettersPath 'fonts.mat']);
        allFonts = {'Braille', 'Checkers4x4', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'BookmanB', 'BookmanU', 'Yung', 'KuenstlerU'};
        for i = 1:length(allFonts)
            printAverageSizesOfFonts(allFonts{i})
            fprintf('\n\n');
        end
        return
    end
    S = loadLetters;
    S_font = S.(fontName);
    
    mx = 40;
    idx = find(S_font.sizes <= mx);
    for i = idx
        %%
        sz = S_font.sizes(i);
        
        sz_idx = find(S_font.sizes == sz);
        
        boxH = S_font.boxH(sz_idx);
        boxW = S_font.boxW(sz_idx);
        %         
        meanH = S_font.boxH_mean(sz_idx);
        meanW = S_font.boxW_mean(sz_idx);
        k_height = S_font.k_heights(sz_idx);
%         fld = sprintf('%s_%02d', fontName, sz);
%         s_i = S.(fld);
% 
%         
%         [idxT, idxB, idxL, idxR] = findLetterBounds(s_i.letters, 0, 1);
%         hs = idxB-idxT+1;
%         ws = idxR-idxL+1;
%         [idxT_all, idxB_all, idxL_all, idxR_all] = findLetterBounds(s_i.letters, 0);
%         h = idxB_all-idxT_all+1;
%         w = idxR_all-idxL_all+1;
        
%         h_av2 = mean(idxB)-mean(idxT)+1;
%         w_av2 = mean(idxR)-mean(idxL)+1;
        
        fprintf('%s size %2d, Average: [%4.1f x %4.1f]. Max: [%2d x %2d]. k height: [%d]\n', fontName, sz, meanH, meanW, boxH, boxW, k_height);
        
        
    end
    
    

end




function printout(sizeStyle)
    S = getFontSize([], sizeStyle);
    fontNames = fieldnames(S);
    
    S_fonts = loadLetters;
    
    maxL = max(cellfun(@length, fontNames))+1;
    fprintf('\n\n')
    for i = 1:length(fontNames)
        font_i = fontNames{i};
        if strcmp(font_i, 'Kuenstler')
            font_i = 'KuenstlerU';
        end
        sz = S.(fontNames{i});
        s_i = S_fonts.(font_i);
        sz_idx = find( s_i.sizes == sz, 1);
        
        if strcmp(font_i, 'Braille')
            h = s_i.boxH(sz_idx);
            w = s_i.boxW(sz_idx);
        else
            h = s_i.boxH_mean(sz_idx);
            w = s_i.boxW_mean(sz_idx);
        end
        k_height = s_i.k_heights(sz_idx);
        fprintf('%sFontSizes.%s = %2d;  %% [k: %2d] [%2.0f x %2.0f] ', sizeStyle, padRight(fontNames{i}, maxL), sz, k_height, h, w)
        
        idx_5  = find(s_i.box_oris==5,1);
        idx_10 = find(s_i.box_oris==10,1);
        idx_15 = find(s_i.box_oris==15,1);
        idx_20 = find(s_i.box_oris==20,1);

         fprintf('  %2d x %2d.  %2d x %2d,  %2d x %2d,  %2d x %2d,  %2d x %2d.   C0 = %.0f  C2 = %.0f\n', ...
         s_i.boxH(sz_idx), s_i.boxW(sz_idx), ...
         s_i.boxH_rot(idx_5, sz_idx), s_i.boxW_rot(idx_5, sz_idx), ...
         s_i.boxH_rot(idx_10, sz_idx), s_i.boxW_rot(idx_10, sz_idx), ...
         s_i.boxH_rot(idx_15, sz_idx), s_i.boxW_rot(idx_15, sz_idx), ...
         s_i.boxH_rot(idx_20, sz_idx), s_i.boxW_rot(idx_20, sz_idx), ...
         s_i.complexities_bool(sz_idx), s_i.complexities_grey(sz_idx) );

    end
    

end

function s = padRight(s, n)
    if length(s) < n
        s = [s, repmat(' ', 1, n - length(s))];
    end

end

%{
Bookman size 05, Average: [ 5.0 x  5.7]. Max: [08 x 09]
Bookman size 06, Average: [ 6.2 x  7.0]. Max: [10 x 11]
Bookman size 07, Average: [ 7.5 x  8.0]. Max: [12 x 13]
Bookman size 08, Average: [ 7.6 x  8.1]. Max: [13 x 14]
Bookman size 09, Average: [ 9.0 x  9.2]. Max: [15 x 16]
Bookman size 10, Average: [10.1 x 10.3]. Max: [16 x 17]
Bookman size 11, Average: [11.1 x 10.7]. Max: [18 x 17]
Bookman size 12, Average: [12.3 x 11.8]. Max: [20 x 19]
Bookman size 13, Average: [13.6 x 13.0]. Max: [22 x 21]
Bookman size 14, Average: [13.8 x 13.4]. Max: [23 x 22]
Bookman size 15, Average: [15.1 x 14.4]. Max: [24 x 24]
Bookman size 16, Average: [16.3 x 15.6]. Max: [27 x 26]
Bookman size 17, Average: [17.3 x 16.2]. Max: [28 x 27]
Bookman size 18, Average: [19.0 x 16.6]. Max: [30 x 28]
Bookman size 19, Average: [20.2 x 17.5]. Max: [32 x 30]
Bookman size 20, Average: [21.0 x 18.2]. Max: [33 x 31]


Helvetica size 04, Average: [ 4.5 x  4.2]. Max: [06 x 07]
Helvetica size 05, Average: [ 5.7 x  4.7]. Max: [08 x 07]
Helvetica size 06, Average: [ 6.1 x  5.5]. Max: [09 x 09]
Helvetica size 07, Average: [ 8.1 x  6.4]. Max: [11 x 11]
Helvetica size 08, Average: [ 8.6 x  5.7]. Max: [13 x 10]
Helvetica size 09, Average: [ 9.6 x  6.3]. Max: [14 x 11]
Helvetica size 10, Average: [11.1 x  7.2]. Max: [17 x 12]
Helvetica size 11, Average: [11.8 x  7.8]. Max: [17 x 13]
Helvetica size 12, Average: [13.1 x  8.5]. Max: [19 x 15]
Helvetica size 13, Average: [14.3 x  9.3]. Max: [21 x 16]
Helvetica size 14, Average: [14.7 x  9.5]. Max: [22 x 16]
Helvetica size 15, Average: [15.7 x 10.4]. Max: [23 x 19]
Helvetica size 16, Average: [17.8 x 11.3]. Max: [26 x 21]
Helvetica size 17, Average: [18.2 x 11.7]. Max: [27 x 20]
Helvetica size 18, Average: [19.2 x 12.9]. Max: [28 x 22]
Helvetica size 19, Average: [20.7 x 13.7]. Max: [31 x 23]
Helvetica size 20, Average: [21.4 x 13.8]. Max: [31 x 23]


Courier size 05, Average: [ 4.5 x  5.2]. Max: [07 x 07]
Courier size 06, Average: [ 5.0 x  6.2]. Max: [08 x 08]
Courier size 07, Average: [ 7.0 x  7.3]. Max: [10 x 09]
Courier size 08, Average: [ 7.0 x  7.6]. Max: [10 x 10]
Courier size 09, Average: [ 7.7 x  8.5]. Max: [13 x 11]
Courier size 10, Average: [ 9.7 x  9.6]. Max: [15 x 12]
Courier size 11, Average: [ 9.7 x 10.1]. Max: [15 x 13]
Courier size 12, Average: [11.1 x 11.2]. Max: [17 x 14]
Courier size 13, Average: [12.1 x 12.0]. Max: [18 x 15]
Courier size 14, Average: [12.1 x 12.2]. Max: [18 x 15]
Courier size 15, Average: [13.7 x 13.4]. Max: [22 x 16]
Courier size 16, Average: [14.7 x 14.2]. Max: [23 x 17]
Courier size 17, Average: [14.7 x 14.9]. Max: [23 x 18]
Courier size 18, Average: [16.2 x 15.8]. Max: [25 x 19]
Courier size 19, Average: [17.2 x 16.7]. Max: [26 x 20]
Courier size 20, Average: [17.2 x 17.4]. Max: [26 x 20]


GeorgiaUpper size 04, Average: [ 4.0 x  5.3]. Max: [05 x 07]
GeorgiaUpper size 05, Average: [ 6.1 x  6.4]. Max: [08 x 10]
GeorgiaUpper size 06, Average: [ 7.1 x  7.8]. Max: [09 x 11]
GeorgiaUpper size 07, Average: [ 9.1 x  9.0]. Max: [11 x 13]
GeorgiaUpper size 08, Average: [10.1 x  9.8]. Max: [12 x 15]
GeorgiaUpper size 09, Average: [11.1 x 11.0]. Max: [14 x 17]
GeorgiaUpper size 10, Average: [12.1 x 12.5]. Max: [15 x 19]
GeorgiaUpper size 11, Average: [13.1 x 13.1]. Max: [16 x 20]
GeorgiaUpper size 12, Average: [14.2 x 14.4]. Max: [18 x 22]
GeorgiaUpper size 13, Average: [16.2 x 15.8]. Max: [20 x 24]
GeorgiaUpper size 14, Average: [16.2 x 16.4]. Max: [20 x 25]
GeorgiaUpper size 15, Average: [18.2 x 17.8]. Max: [23 x 27]
GeorgiaUpper size 16, Average: [19.2 x 18.8]. Max: [24 x 29]
GeorgiaUpper size 17, Average: [20.2 x 19.5]. Max: [25 x 29]
GeorgiaUpper size 18, Average: [21.2 x 19.5]. Max: [27 x 29]
GeorgiaUpper size 19, Average: [22.2 x 20.3]. Max: [28 x 31]
GeorgiaUpper size 20, Average: [23.2 x 21.0]. Max: [29 x 32]


Helvetica size 04, Average: [ 4.5 x  4.2]. Max: [06 x 07]
Helvetica size 05, Average: [ 5.7 x  4.7]. Max: [08 x 07]
Helvetica size 06, Average: [ 6.1 x  5.5]. Max: [09 x 09]
Helvetica size 07, Average: [ 8.1 x  6.4]. Max: [11 x 11]
Helvetica size 08, Average: [ 8.6 x  5.7]. Max: [13 x 10]
Helvetica size 09, Average: [ 9.6 x  6.3]. Max: [14 x 11]
Helvetica size 10, Average: [11.1 x  7.2]. Max: [17 x 12]
Helvetica size 11, Average: [11.8 x  7.8]. Max: [17 x 13]
Helvetica size 12, Average: [13.1 x  8.5]. Max: [19 x 15]
Helvetica size 13, Average: [14.3 x  9.3]. Max: [21 x 16]
Helvetica size 14, Average: [14.7 x  9.5]. Max: [22 x 16]
Helvetica size 15, Average: [15.7 x 10.4]. Max: [23 x 19]
Helvetica size 16, Average: [17.8 x 11.3]. Max: [26 x 21]
Helvetica size 17, Average: [18.2 x 11.7]. Max: [27 x 20]
Helvetica size 18, Average: [19.2 x 12.9]. Max: [28 x 22]
Helvetica size 19, Average: [20.7 x 13.7]. Max: [31 x 23]
Helvetica size 20, Average: [21.4 x 13.8]. Max: [31 x 23]


Kuenstler size 04, Average: [ 4.2 x  8.0]. Max: [06 x 11]
Kuenstler size 05, Average: [ 5.2 x  9.9]. Max: [08 x 12]
Kuenstler size 06, Average: [ 7.2 x 11.9]. Max: [10 x 15]
Kuenstler size 07, Average: [ 8.2 x 13.8]. Max: [11 x 17]
Kuenstler size 08, Average: [ 9.2 x 14.8]. Max: [12 x 18]
Kuenstler size 09, Average: [10.3 x 16.8]. Max: [15 x 21]
Kuenstler size 10, Average: [12.2 x 19.1]. Max: [17 x 23]
Kuenstler size 11, Average: [12.4 x 20.2]. Max: [18 x 25]
Kuenstler size 12, Average: [14.2 x 22.1]. Max: [19 x 27]
Kuenstler size 13, Average: [15.4 x 24.2]. Max: [22 x 30]
Kuenstler size 14, Average: [16.2 x 25.2]. Max: [22 x 31]
Kuenstler size 15, Average: [17.5 x 27.4]. Max: [25 x 34]
Kuenstler size 16, Average: [18.6 x 29.4]. Max: [26 x 36]
Kuenstler size 17, Average: [19.5 x 30.7]. Max: [27 x 38]
Kuenstler size 18, Average: [20.6 x 31.2]. Max: [29 x 39]
Kuenstler size 19, Average: [22.5 x 33.3]. Max: [32 x 42]
Kuenstler size 20, Average: [23.0 x 34.4]. Max: [32 x 43]

Sloan size 05, Average: [ 7.0 x  8.0]. Max: [07 x 08]
Sloan size 06, Average: [ 9.0 x 10.0]. Max: [09 x 10]
Sloan size 07, Average: [10.0 x 11.9]. Max: [10 x 12]
Sloan size 08, Average: [12.0 x 13.0]. Max: [12 x 13]
Sloan size 09, Average: [13.0 x 14.9]. Max: [13 x 15]
Sloan size 10, Average: [16.0 x 17.0]. Max: [16 x 17]
Sloan size 11, Average: [17.0 x 18.0]. Max: [17 x 18]
Sloan size 12, Average: [19.0 x 20.0]. Max: [19 x 20]
Sloan size 13, Average: [21.0 x 22.0]. Max: [21 x 22]
Sloan size 14, Average: [22.0 x 23.0]. Max: [22 x 23]
Sloan size 15, Average: [24.0 x 25.0]. Max: [24 x 25]
Sloan size 16, Average: [26.0 x 27.0]. Max: [26 x 27]
Sloan size 17, Average: [27.0 x 28.0]. Max: [27 x 28]
Sloan size 20, Average: [33.0 x 33.0]. Max: [33 x 33]

Yung size 05, Average: [ 5.5 x  6.2]. Max: [06 x 08]
Yung size 06, Average: [ 7.3 x  7.4]. Max: [08 x 09]
Yung size 07, Average: [ 8.3 x  8.6]. Max: [09 x 10]
Yung size 08, Average: [ 9.7 x  9.2]. Max: [12 x 11]
Yung size 09, Average: [10.3 x 10.4]. Max: [11 x 13]
Yung size 10, Average: [12.7 x 11.9]. Max: [15 x 15]
Yung size 11, Average: [13.3 x 12.7]. Max: [16 x 15]
Yung size 12, Average: [14.7 x 13.8]. Max: [18 x 17]
Yung size 13, Average: [16.0 x 15.2]. Max: [19 x 19]
Yung size 14, Average: [16.7 x 15.9]. Max: [20 x 20]
Yung size 15, Average: [18.2 x 17.1]. Max: [22 x 21]
Yung size 16, Average: [19.6 x 18.4]. Max: [24 x 23]
Yung size 17, Average: [20.2 x 19.0]. Max: [25 x 23]
Yung size 18, Average: [21.7 x 20.5]. Max: [26 x 25]
Yung size 19, Average: [23.1 x 21.8]. Max: [29 x 27]
Yung size 20, Average: [24.0 x 22.2]. Max: [29 x 28]


==== Generating "Checkers2x3" font =====
Braille size 01, Average: [ 2.6 x  1.9]. Max: [03 x 02]
Braille size 02, Average: [ 5.2 x  3.8]. Max: [06 x 04]
Braille size 03, Average: [ 7.8 x  5.7]. Max: [09 x 06]
Braille size 04, Average: [10.5 x  7.5]. Max: [12 x 08]
Braille size 05, Average: [13.1 x  9.4]. Max: [15 x 10]
Braille size 06, Average: [15.7 x 11.3]. Max: [18 x 12]
Braille size 07, Average: [18.3 x 13.2]. Max: [21 x 14]
Braille size 08, Average: [20.9 x 15.1]. Max: [24 x 16]
Braille size 09, Average: [23.5 x 17.0]. Max: [27 x 18]
Braille size 10, Average: [26.2 x 18.8]. Max: [30 x 20]
Braille size 11, Average: [28.8 x 20.7]. Max: [33 x 22]
Braille size 12, Average: [31.4 x 22.6]. Max: [36 x 24]
Braille size 13, Average: [34.0 x 24.5]. Max: [39 x 26]
Braille size 14, Average: [36.6 x 26.4]. Max: [42 x 28]
Braille size 15, Average: [39.2 x 28.3]. Max: [45 x 30]
Braille size 16, Average: [41.8 x 30.2]. Max: [48 x 32]
Braille size 17, Average: [44.5 x 32.0]. Max: [51 x 34]
Braille size 18, Average: [47.1 x 33.9]. Max: [54 x 36]
Braille size 19, Average: [49.7 x 35.8]. Max: [57 x 38]
Braille size 20, Average: [52.3 x 37.7]. Max: [60 x 40]



Checkers4x4 size  1, Average: [ 3.9 x  3.8]. Max: [ 4 x  4]. k height: [4]
Checkers4x4 size  2, Average: [ 7.8 x  7.7]. Max: [ 8 x  8]. k height: [8]
Checkers4x4 size  3, Average: [11.8 x 11.5]. Max: [12 x 12]. k height: [12]
Checkers4x4 size  4, Average: [15.7 x 15.4]. Max: [16 x 16]. k height: [16]
Checkers4x4 size  5, Average: [19.6 x 19.2]. Max: [20 x 20]. k height: [20]
Checkers4x4 size  6, Average: [23.5 x 23.1]. Max: [24 x 24]. k height: [24]
Checkers4x4 size  7, Average: [27.5 x 26.9]. Max: [28 x 28]. k height: [28]
Checkers4x4 size  8, Average: [31.4 x 30.8]. Max: [32 x 32]. k height: [32]
Checkers4x4 size  9, Average: [35.3 x 34.6]. Max: [36 x 36]. k height: [36]
Checkers4x4 size 10, Average: [39.2 x 38.5]. Max: [40 x 40]. k height: [40]
Checkers4x4 size 11, Average: [43.2 x 42.3]. Max: [44 x 44]. k height: [44]
Checkers4x4 size 12, Average: [47.1 x 46.2]. Max: [48 x 48]. k height: [48]
Checkers4x4 size 13, Average: [51.0 x 50.0]. Max: [52 x 52]. k height: [52]
Checkers4x4 size 14, Average: [54.9 x 53.8]. Max: [56 x 56]. k height: [56]
Checkers4x4 size 15, Average: [58.8 x 57.7]. Max: [60 x 60]. k height: [60]
Checkers4x4 size 16, Average: [62.8 x 61.5]. Max: [64 x 64]. k height: [64]
Checkers4x4 size 17, Average: [66.7 x 65.4]. Max: [68 x 68]. k height: [68]
Checkers4x4 size 18, Average: [70.6 x 69.2]. Max: [72 x 72]. k height: [72]
Checkers4x4 size 19, Average: [74.5 x 73.1]. Max: [76 x 76]. k height: [76]
Checkers4x4 size 20, Average: [78.5 x 76.9]. Max: [80 x 80]. k height: [80]
Checkers4x4 size 21, Average: [82.4 x 80.8]. Max: [84 x 84]. k height: [84]
Checkers4x4 size 22, Average: [86.3 x 84.6]. Max: [88 x 88]. k height: [88]
Checkers4x4 size 23, Average: [90.2 x 88.5]. Max: [92 x 92]. k height: [92]
Checkers4x4 size 24, Average: [94.2 x 92.3]. Max: [96 x 96]. k height: [96]

%}
