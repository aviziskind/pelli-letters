function [min_cpl, max_cpl] = getMinMaxCyclesPerLetter(x_height, imageSize, fontName)
%%
    if nargin < 3
        fontName = 'Bookman';
    end
    
    if nargin < 2
        imageSize = [64, 64];
    end

    if nargin < 1
        x_height = 24;
    end
    
    if ~isnumeric(x_height)
        [point_size, x_height, k_height] = getFontSize(fontName, x_height);
    end

  %%
    min_cycPerImage = 1;
    lettersPerImage = min( imageSize ) / x_height;
    min_cpl = min_cycPerImage / lettersPerImage;  
    max_cpl =  x_height / 2;




end