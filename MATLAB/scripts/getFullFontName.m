function fontName = getFullFontName(rawFontName, varargin)
    
    if length(varargin) == 1
        fontAttrib = varargin{1};
        [upper_tf, bold_tf, italic_tf, outline_w, thin_w] = deal(false, false, false, nan, nan);
        if isfield(fontAttrib, 'upper_tf'), upper_tf = fontAttrib.upper_tf; end;
        if isfield(fontAttrib, 'bold_tf'),  bold_tf = fontAttrib.bold_tf; end;
        if isfield(fontAttrib, 'italic_tf'), italic_tf = fontAttrib.italic_tf; end;
        if isfield(fontAttrib, 'outline_w_tf'), outline_w = fontAttrib.outline_w; end;
        if isfield(fontAttrib, 'thin_w_tf'), thin_w = fontAttrib.thin_w; end;        
    else
        [upper_tf, bold_tf, italic_tf, outline_w, thin_w] = deal(varargin{:});
    end
    
    
    bold_str   = iff(bold_tf, 'B', '');
    italic_str = iff(italic_tf, 'I', '');
    upper_str  = iff(upper_tf, 'U', '');
    outline_w_str = iff(isnan(outline_w), '', num2decstr(outline_w));
    thin_w_str    = iff(isnan(thin_w), '', num2decstr(thin_w));
    fontName      = [rawFontName upper_str bold_str italic_str outline_w_str thin_w_str];

end