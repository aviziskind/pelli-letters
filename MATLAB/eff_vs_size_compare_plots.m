%%
x  = [0.1,   0.25,  0.5,  1,    2,     4,     8,     16,    30];

y0 = [0.0715, 0.095, 0.14, 0.12, 0.097, 0.075, 0.053, 0.036, 0.0275];
y5 = [nan    0.04  0.065, 0.111, 0.078, 0.065, 0.049, 0.035, 0.0255];


S = imread('eff_vs_size_orig.png');
S_gray = flipud( rgb2gray(S) );

ylims_img = [.0107 1];
xlims_img = [0.108, 70];

ylims_ax = [.01 1];
xlims_ax = [0.07, 70];

ylims_orig = [.01 1];
xlims_orig = [0.07, 70];

ylims_line = [.01 1];
xlims_line = [0.07, 70];


xx = linspace(xlims_img(1), xlims_img(2), size(S_gray,2));
yy = linspace(ylims_img(1), ylims_img(2), size(S_gray,1));

figure(55); clf; hold on; box on;
imagesc(xx, yy, S_gray); colormap('gray');
axis

h(1) = plot(x, y0, 'ro-', 'markersize', 13, 'markerfacecolor', 'r', 'linewidth', 3);
h(2) = plot(x, y5, 'ro-', 'markersize', 13, 'markerfacecolor', 'b', 'linewidth', 3);
set(gca, 'xscale', 'log', 'yscale', 'log', 'tickDir', 'out')
drawHorizontalLine(ylims_line, 'color', 'r')
drawVerticalLine(xlims_line, 'color', 'r')
xlim(xlims_ax)
ylim(ylims_ax);