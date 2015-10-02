function [str_short, str_med, str_long] = abbrevFontStyleNames(names_orig, fontOrStyle, opt)
    % print(names_orig)
    if nargin < 3
        opt = struct;
    end
    doSort = ~isfield(opt, 'dontSort') || ~isequal(opt.dontSort, 1);
    
    niceStrFields = {};
    if isfield(opt, 'niceStrFields')
        niceStrFields = opt.niceStrFields;
    end
%     doSort = nargin < 3 || ~isequal(dontSort_flag, 1);
    
   
    %  Book[M]an, Brai[L]le, [C]heckers4x4, Cou[R]ier, [H]elvetica, [K]uenstler  [S]loan, [Y]ung, 
    skipAbbrevIfOneFont = true;
    %%
    allFontName_abbrevs = struct('Armenian', 'A', ...
                                 'Bookman', 'M', ...
                                 'Braille', 'L', ...
                                 'Checkers4x4', 'C', ...
                                 'Courier', 'R', ...
                                 'Devanagari', 'D', ...
                                 'Helvetica', 'H', ...
                                 'Hebraica', 'I', ...
                                 'Kuenstler', 'K', ...
                                 'Sloan', 'S', ...
                                 'Yung', 'Y', ...
                                 ...
                                 'SVHN', 'N', ...
                                 ...
                                 'Snakes', 'G' ... % gabor
                             );
    
    allFontName_abbrevs_med = struct('Armenian', 'Arm', ...
                                     'Bookman', 'Bkm', ...
                                     'Braille', 'Brl', ...
                                     'Checkers4x4', 'Ch4',  ...
                                     'Courier', 'Cur', ...
                                     'Devanagari', 'Dev', ...
                                     'Helvetica', 'Hlv', ...
                                     'Hebraica', 'Heb', ...
                                     'Kuenstler', 'Kun', ...
                                     'Sloan', 'Sln', ...
                                     'Yung', 'Yng', ...
                                     ...
                                     'SVHN', 'SVHN', ...
                                     ...
                                     'Snakes', 'Snk' ...
                                 );
                                 
                             
    allStyleName_abbrevs = struct('Roman',      'r', ...
                                  'Bold',       'B', ...
                                  'Italic',     'I', ...
                                  'BoldItalic', 'J' ... 
                            );
    
    allStyleName_abbrevs_med = struct('Roman',      'Rom', ...
                                      'Bold',       'Bld', ...
                                      'Italic',     'Ital', ...
                                      'BoldItalic', 'BldItal'  ...
                               );
     
    
    
    if ischar(names_orig)
        names_orig = {names_orig};
    end
    

    
    if isstruct(names_orig) && (isfield(names_orig, 'fonts') || isfield(names_orig, 'styles') || isfield(names_orig, 'wiggles') || isfield(names_orig, 'svhn_opts'))
       [fontName_str_short,   fontName_str_medium,  fontNames_full]   = deal('');
       [styleName_str_short,  styleName_str_medium, styleNames_full]  = deal('');
       [pre_full, join_short, join_med, join_full,  post_full]        = deal('');
       if isfield(names_orig, 'fonts')
           % print(names_orig.fonts)
            [fontName_str_short, fontName_str_medium, fontNames_full] = abbrevFontStyleNames(names_orig.fonts, 'font');
       end
       
       if isfield(names_orig, 'styles') && (length(names_orig.styles) == 1  && (strcmp(names_orig.styles{1}, 'Roman')) && isfield(names_orig, 'fonts'))
           names_orig = rmfield(names_orig, 'styles');
       end
       
       if isfield(names_orig, 'styles')
           [styleName_str_short, styleName_str_medium, styleNames_full] = abbrevFontStyleNames(names_orig.styles, 'style');
       end
       
       if isfield(names_orig, 'wiggles')
           assert(~isfield(names_orig, 'styles'))
           wiggle_str = getSnakeWiggleStr(names_orig.wiggles);
           [styleName_str_short, styleName_str_medium, styleNames_full] = deal(wiggle_str);
       end
       
       if isfield(names_orig, 'svhn_opts')
           assert(~isfield(names_orig, 'styles'))
           [svhn_opt_str, svhn_opt_str_nice] =  getSVHNOptsStr(names_orig.svhn_opts, niceStrFields);
           [styleName_str_short, styleName_str_medium, styleNames_full] = deal(svhn_opt_str, svhn_opt_str_nice, svhn_opt_str_nice);
       end
       
       
       if isfield(names_orig, 'fonts') && (isfield(names_orig, 'styles') || isfield(names_orig, 'wiggles'))
           [join_short, join_med] = deal('_', '_x_');
           [pre_full, join_full, post_full] = deal('{', ' X ', '}');
       end
       % print(names_orig)
       
       str_short = [fontName_str_short  join_short  styleName_str_short];
       str_med = [fontName_str_medium  join_med  styleName_str_medium];
       str_long = [pre_full  fontNames_full  join_full  styleNames_full  post_full];
       return
       
    end
    
    if ~exist('fontOrStyle', 'var') 
        % print(names_orig[1])
        if isfield(allFontName_abbrevs, getRawFontName( names_orig{1}) )  
            fontOrStyle = 'font';
        elseif isfield( allStyleName_abbrevs, names_orig{1} ) 
            fontOrStyle = 'style';
        else
            error('!')
        end
    end
    
    if skipAbbrevIfOneFont && strcmp(fontOrStyle, 'font') && (length(names_orig) == 1) 
        [str_short, str_med, str_long] = deal(names_orig{1});
        return
    end

    names = names_orig;
    if doSort
        if strcmp(fontOrStyle, 'font')
            names = sort(names);
        else
            styleOrder = {'Roman', 'Bold', 'Italic', 'BoldItalic'};
            unknownStyles = setdiff(names, styleOrder);
            if ~isempty(unknownStyles)
                error('Unknown styles : %s', cellstr2csslist(unknownStyles))
            end

            names_new = {};
            for i = 1:length(styleOrder)
                style = styleOrder{i};

                for j = 1:length(names)
                    nm = names{j};
                    if strcmp(style, nm)
                        names_new = [names_new, style];
                    end
                end

            end
            names = names_new;

        end
    end    
    
   
    % getRawFontName(
    [tbl_short, tbl_med] = deal(cell(1, length(names)));

    for i = 1:length(names)
        name = names{i};
        
        
        if strcmp(fontOrStyle, 'font')
            [rawFontName, fontAttrib] = getRawFontName(name);
            
            bold_str = iff(fontAttrib.bold_tf, 'B', '');
            italic_str = iff(fontAttrib.italic_tf, 'I', '');
            upper_str = iff(fontAttrib.upper_tf, 'U', '');
            outline_w_str = iff(isnan(fontAttrib.outline_w), '', num2decstr(fontAttrib.outline_w));
            thin_w_str    = iff(isnan(fontAttrib.thin_w), '', num2decstr(fontAttrib.thin_w));

            
            fontAbbrev     = allFontName_abbrevs.(rawFontName);
            fontAbbrev_med = allFontName_abbrevs_med.(rawFontName);
            if ~fontAttrib.upper_tf 
                fontAbbrev = lower(fontAbbrev);
            end
            str_short = [fontAbbrev 	             bold_str italic_str outline_w_str thin_w_str];
            str_med   = [fontAbbrev_med upper_str bold_str italic_str outline_w_str thin_w_str];
        elseif strcmp(fontOrStyle, 'style')
            
            styleName = name;
            str_short = allStyleName_abbrevs.(styleName);
            str_med   = allStyleName_abbrevs_med.(styleName);
            
        end
        
        % tbl_short[i] = fontAbbrev .. upper_str .. bold_str
        tbl_short{i} = str_short;
        tbl_med{i}   = str_med;
        
    end
    
    str_short = [tbl_short{:}];
    
    if nargout >= 2
        str_med = cellstr2csslist(tbl_med, '_');
    end
    
    if nargout >= 3
        str_long = cellstr2csslist(names, ',');
    end

   
    
end


%{
function str = compressFontNames(str)
    
       allFontName_abbrevs = struct('Bookman', 'M', ...
                                    'Braille', 'L',  ...
                                    'Checkers4x4', 'C',  ...
                                    'Courier', 'R',  ...
                                    'Helvetica', 'H',  ...
                                    'Kuenstler', 'K',  ...
                                    'Sloan', 'S',  ...
                                    'Yung', 'Y' ...
                                  );
      fontNames = fieldnames(allFontName_abbrevs);
      for i = 1:length(fontNames)
         
          str = strrep(str, fontNames{i}, allFontName_abbrevs.(fontNames{i}) );
          
      end
      
    
end

%}