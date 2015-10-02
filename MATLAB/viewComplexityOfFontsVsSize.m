function viewComplexityOfFontsVsSize(fontName)
    if nargin < 1
        fontName = 'Bookman';
    end

    alsoPlotBoldedVersion = 1;
    
    S = loadLetters;
    S = orderfields(S);
    fn = fieldnames(S);

    if alsoPlotBoldedVersion
        fontNames = {fontName, [fontName 'B']};
        l_widths = [1, 2];
    else
        fontNames = {fontName}
        l_widths = [1];
    end
    
    figure(11);
    clf; hold on; box on;
    plotComplexity_bool = 1;
    plotComplexity_grey_old = 0;
    plotComplexity_grey = 1;

    for fi = 1:length(fontNames)
        fontName = fontNames{fi};
        s = S.(fontName);
        fontSizes = s.sizes;
        c_bool = s.complexities_bool;
        c_grey_old = s.complexities_grey_old;
        c_grey = s.complexities_grey;
        assert(length(c_grey) == length(unique(c_grey)))
        assert(length(c_bool) == length(unique(c_bool)))
        assert(length(c_grey_old) == length(unique(c_grey_old)))

        if plotComplexity_bool
            h{fi} = plot(fontSizes, c_bool, 'bo-', 'linewidth', l_widths(fi));
            
        end
        if plotComplexity_grey_old
            h{fi}(end+1) = plot(fontSizes, c_grey_old, 'gs-', 'linewidth', l_widths(fi));
            
        end
        if plotComplexity_grey
            h{fi}(end+1) = plot(fontSizes, c_grey, 'r*-', 'linewidth', l_widths(fi));
        end
        
    
    end
    3;
%%
    legend('OR-shifted', 'Add-shifted (Gray-scale)', 'location', 'SE')
%     legend('OR-shifted', 'Add-shifted', 'location', 'SE')
    xlabel('Font size');
    ylabel('Complexity')
    title(fontName)
    3;

end