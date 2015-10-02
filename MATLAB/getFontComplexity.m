function [cmp_mean, cmp_eachLetter] = getFontComplexity(fontName, fontSize_arg, fontSizeSpec, cmp_type)

%     persistent fontData
% 
%     if isempty(fontData)
%         %%
%         S_fonts = loadLetters;
%         fld_names = fieldnames(S_fonts);
%         for i = 1:length(fld_names)
%             if isempty(strfind(fld_names{i}, '_'))
%                 fontData.(fld_names{i}) = S_fonts.(fld_names{i});
%             end
%         end
%         
%     end
    
    fontData = loadLetters;

    s = fontData.(fontName);
    
    
    if nargin < 2 || isempty(fontSize_arg);
        fontSize_arg = 'big';
    end
    
    if nargin < 3 || isempty(fontSizeSpec)
        fontSizeSpec = 'exact';
    end
    
    if nargin < 4 || isempty(cmp_type)
        cmp_type = 'complexities_grey';
    end

    if isnumeric(fontSize_arg)
        fontSize = fontSize_arg;
    elseif ischar(fontSize_arg)
        sizeStyle = fontSize_arg;
        fontSize = getFontSize(fontName, sizeStyle, fontSizeSpec);    
    end
    idx = find(s.sizes == fontSize, 1);
    
    
    cmp_mean = s.(cmp_type)(idx);
    cmp_eachLetter = s.([cmp_type '_allLetters'])(:,idx);
    assert(mean(cmp_eachLetter) == cmp_mean)
        
    3;

end