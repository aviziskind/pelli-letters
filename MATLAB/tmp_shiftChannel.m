%%
allTh = [3.8107    5.3456    6.6681   13.4276   24.3781   45.7088  144.5440  503.5006  609.5369  187.9317   58.2103];
allCycPerLet = [0.5000    0.7100    1.0000    1.4100    2.0000    2.8300    4.0000    5.6600    8.0000   11.3100   16.0000];

allTh_plot = allTh .* ((norm_factors.^(0))); % (log2(allCycPerLet).^(1));
figure(65); clf;
plot(allCycPerLet, allTh_plot, 'o-');
set(gca, 'yscale', 'log', 'xscale', 'log', 'xtick', allCycPerLet(1:2:end), 'xlim', lims(allCycPerLet([1, end]), .05, [], 1) );



