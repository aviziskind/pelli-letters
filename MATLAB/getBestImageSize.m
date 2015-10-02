function [imageHeight, imageWidth] = getBestImageSize(orientations, xs, ys, fontNames_use, sizeStyle, marginPixels, requireSquareImage_flag, trimXY_flag)

    requireSquareImage = exist('requireSquareImage_flag', 'var') && isequal(requireSquareImage_flag, 1);
    if ~exist('marginPixels', 'var') || isempty(marginPixels)
        marginPixels = 2;
    end
    
    
    trimXY = ~exist('trimXY_flag', 'var') || ~isequal(trimXY_flag, 0);

%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'GeorgiaUpper', 'Yung', 'Kuenstler'};
    allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'Courier', 'Yung', 'KuenstlerU'};
% %                         {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
    
    if nargin < 4
        fontNames_use = allFontNames;
    end
    if ~iscell(fontNames_use)
        fontNames_use = {fontNames_use};
    end
    
    if nargin < 5
        sizeStyle = 'k32';
    end

    sizeSpec = 'maxSize';
%     haveFontSizes = exist('fontSizes_use', 'var') && ~isempty(fontSizes_use);

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   unrotated   rot 5,     rot 10    rot 15   rot 20 
%     defaultFontSize.Braille      =  9; % 29 x 20.  29 x 21,  31 x 23,  31 x 25,  33 x 27.   C0 = 27  C2 = 28
%     defaultFontSize.Sloan        = 16; % 28 x 29.  29 x 31,  31 x 31,  33 x 33,  35 x 35.   C0 = 42  C2 = 43
%     defaultFontSize.Helvetica    = 20; % 33 x 25.  33 x 25,  35 x 27,  35 x 29,  35 x 29.   C0 = 49  C2 = 55
%     defaultFontSize.Bookman      = 18; % 32 x 30.  31 x 31,  32 x 31,  33 x 31,  33 x 33.   C0 = 55  C2 = 63
%     defaultFontSize.GeorgiaUpper = 16; % 26 x 31.  27 x 33,  28 x 33,  30 x 35,  32 x 37.   C0 = 59  C2 = 85
%     defaultFontSize.Courier      = 21; % 32 x 24.  32 x 25,  32 x 25,  34 x 29,  34 x 31.   C0 = 78  C2 = 121
%     defaultFontSize.Yung         = 21; % 32 x 32.  32 x 32,  33 x 32,  34 x 34,  34 x 34.   C0 = 78  C2 = 114
%     defaultFontSize.Kuenstler    = 14; % 24 x 33.  25 x 33,  27 x 35,  30 x 36,  32 x 37.   C0 = 83  C2 = 286

%{

Braille: 29 x 20   ok  
Bookman: 26 x 26   ** 15 close          [    3, 26, 5, 28]
Courier: 27 x 21   ** 19 ok            3    27     8    26
Georgia: 26 x 31   ok
Helvetica: 28x33   ** -->19 close     [2    27     7    27]
Sloan:     28x29   ok
Yung:      27x25   ** -->17 ok
Kuenstler 24x33    ok


bookman->15?
Courier ->21
Yung 17 [25x23]

%}


        
% 
%     29    28    33    32    32    26    32    24
%     20    30    26    24    31    32    32    34

    nFonts = length(fontNames_use);
          
    
    xs=round(xs);
    ys=round(ys);
    
    if trimXY
        Dx = xs(end)-xs(1);
        Dy = ys(end)-ys(1);
    else
        Dx = xs(end);
        Dy = ys(end);
    end
    
    S_fonts = loadLetters;
    %%
    allHeights = zeros(1,nFonts);
    allWidths = zeros(1,nFonts);
    for font_i = 1:nFonts
        fontName = fontNames_use{font_i};
        fontSizeData = S_fonts.(fontName);
%         if haveFontSizes
%             fontSize = fontSizes_use(font_i);
%         else
            fontSize = getFontSize(fontName, sizeStyle, sizeSpec);
%         end
        
        size_idx = find(fontSizeData.sizes == fontSize,1);
        curH = 0;
        curW = 0;
        if any(orientations == 0)
            curH = fontSizeData.boxH(size_idx);
            curW = fontSizeData.boxW(size_idx);
        end
        if any(abs(orientations) > 0)
            idx_rot_max = find(  fontSizeData.box_oris >= max(abs(orientations)), 1, 'first'); 
            curH = max( [curH; fontSizeData.boxH_rot(1:idx_rot_max, size_idx)] );
            curW = max( [curW; fontSizeData.boxW_rot(1:idx_rot_max, size_idx)] );            
        end
            
        allHeights(font_i) = curH;
        allWidths(font_i) = curW;

    end
    
    
    % [29x33] --> 27x31
    % find image size that can fit all (rotated) fonts
    imageHeight_rot = max(allHeights);
    imageWidth_rot = max(allWidths);
    
    % add extra space for x & y shifts
    imageWidth_rot_shft  = imageWidth_rot + Dx;
    imageHeight_rot_shft = imageHeight_rot + Dy;
    
    % add margin on the edge for ConvNet convolutional filters
    if length(marginPixels) == 1
        marginPixels = marginPixels*[1, 1];
    end
    
    if trimXY
        margin_mult = 2; 
    else
        margin_mult = 1;
    end
    imageHeight = imageHeight_rot_shft + marginPixels(1)*margin_mult;
    imageWidth = imageWidth_rot_shft + marginPixels(2)*margin_mult;
    
    if requireSquareImage
        [imageHeight, imageWidth] = deal(max(imageWidth, imageHeight)); %#ok<UNRCH>
    end
    
    
end
