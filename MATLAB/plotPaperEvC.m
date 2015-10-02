%%
allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'Kuenstler'};
% stats = getStatsFromPaper;

% allFonts = fieldnames(stats);
%%
% allC = structfun(@(s) s.complexity, stats);
% allE = structfun(@(s) s.efficiency, stats);

for i = 1:length(allFontNames)
    allC_paper(i) = getStatsFromPaper(allFontNames{i}, 'complexity');
    allE_paper(i) = getStatsFromPaper(allFontNames{i}, 'efficiency');
    allC_calc(i) = getFontComplexity(allFontNames{i}, 60);
end
%%

figure(49); clf;
plot(allC_paper, allE_paper, 'ko');
hold on;
plot(allC_calc, allE_paper, 'ro');
fplot(@(x) 9./x, lims(allC_calc, .05, [], 1), 'b:');
set(gca, 'xscale', 'log', 'yscale', 'log');
