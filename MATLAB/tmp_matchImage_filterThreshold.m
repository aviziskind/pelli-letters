% function tmp_matchImage

S = imread('filter_threshold_LL.png');
Sg = rgb2gray(S);
%%
xlims = [.1, 100];
ylims = [-20, 80];

xx = linspace(xlims(1), xlims(2), size(Sg,2));
yy = linspace(ylims(1), ylims(2), size(Sg,1));

figure(55); clf; 

imagesc(Sg); colormap('gray');

ticksOff;
h_ax_im = gca;

h_ax_plot = axes('position', get(h_ax_im, 'position'), 'color', 'none');

ylims = [-20, 80];
xlim(lims(xlims))
ylim(ylims);
set(gca, 'yScale', 'linear', 'xscale', 'log', 'tickDir', 'out');
hold on;

h1 = [];

% hold on;
%%



x = [0.5, 1, 2, 4.0, 8.0, 16];

y = [ 54, 68, 44, 11, .1, .1];

if isempty(h1)
    h1 = plot(h_ax_plot, x, y, 'ro', 'markersize', 12);
else
    set(h1, 'xdata', x,'ydata', y, 'markersize', 12, 'color', 'r');
end

%%