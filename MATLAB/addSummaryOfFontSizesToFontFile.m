function addSummaryOfFontSizesToFontFile(fontName)

%     fontsFile = [lettersPath 'fonts.mat'];
    S_fonts = loadLetters;
    fn = sort(fieldnames(S_fonts));
    
    if nargin < 1
        allFonts = unique( cellfun(@(s) strtok(s, '_'), fn, 'un', 0));
        for i = 1:length(allFonts)
            addSummaryOfFontSizesToFontFile(allFonts{i})
        end
        %%
%         S_fonts = load(fontsFile);
%         S_fonts = orderfields(S_fonts);
%         save(fontsFile, '-struct', 'S_fonts');
        %%
        createFontSizesFile;
        return
    end
    
    
    idx_thisFont = find(strncmp(fn, [fontName '_'], length(fontName)+1));
    nThisFont = length(idx_thisFont);
    if nThisFont == 0
        return;
    end
    allS = cellfun(@(fld) S_fonts.(fld), fn(idx_thisFont)); 
    
    fontSizes_thisFont = [allS.fontsize];
    [~, idx_sortBySize] = sort(fontSizes_thisFont);
    allS = allS(idx_sortBySize);
    
            %%
    summary = struct;
    summary.sizes = [allS.fontsize];
    fontBoxSizes = cat(1, allS.size)';
    summary.boxH = fontBoxSizes(1,:);
    summary.boxW = fontBoxSizes(2,:);
    
%     k_heights = round(mean(cat(1, allS.k_height),2));
    
    %%

%         summary.BoxH = cat(1, allS.size)';
    summary.k_heights = [allS.k_height];
    summary.x_heights = [allS.x_height];
    if isfield(allS(1), 'strokeFrequency')
        summary.strokeFreq_let = [allS.strokeFrequency_perLet];
        summary.strokeFreq_pix = [allS.strokeFrequency];
    end
    %%
    summary.box_oris = allS(1).orientations;
    fontBoxSizes_rotated = cat(3, allS.size_rotated);
    
%     fontBoxSizes_rotated_HW = permute(fontBoxSizes_rotated, [3, 1, 2])
    
    summary.boxH_rot = squeeze( fontBoxSizes_rotated(:,1,:));
    summary.boxW_rot = squeeze( fontBoxSizes_rotated(:,2,:));

   
    fontBoxSizes_mean = cat(3, allS.size_av);
    summary.boxH_mean = squeeze( fontBoxSizes_mean(:,1,:));
    summary.boxW_mean = squeeze( fontBoxSizes_mean(:,2,:));

%         summary.BoxSizes = [allS.size];
    if isfield(allS(1), 'complexity_0')
        summary.complexities_bool = [allS.complexity_0];
        summary.complexities_bool_allLetters = [allS.complexity_0_all];
        summary.complexities_grey_old = [allS.complexity_1];
        summary.complexities_grey = [allS.complexity_2];
        summary.complexities_grey_allLetters = [allS.complexity_2_all];
    end
    
    if isfield(allS(1), 'fontDensity_bool')
        summary.density_bool = [allS.fontDensity_bool];
        summary.density_grey = [allS.fontDensity_grey];
    end

    rawFontName = getRawFontName(fontName);
    if ~any(strcmp(rawFontName, {'Ascii5x7', 'Braille'})) && ~any(strncmpi(rawFontName, {'Snakes', 'Sloan', 'Checkers'}, 6))
        assert(  length(unique(summary.complexities_bool)) == nThisFont )
        assert(  length(unique(summary.complexities_grey_old)) == nThisFont )
        assert(  length(unique(summary.complexities_grey)) == nThisFont )
    end    
    S_add.(fontName) = summary;
    
    %%
    3;
%         fontBoxSizes = {S(:).size};
%         fontComplexities_bool = 
%         fontComplexities_grey =
%         fontBoxW = S(i) 

%         sizeVsFontSize.(fontName);

    loadLetters(fontName, [], [], summary);
%     save(fontsFile, '-struct', 'S_add', '-append')
        
end