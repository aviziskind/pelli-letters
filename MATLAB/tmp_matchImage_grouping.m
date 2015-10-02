% function tmp_matchImage

S = imread('pelli2009_fig6.png');
Sg = rgb2gray(S);
%%
xlims = [5:5:100];
ylims = [.005, .1];

xx = linspace(xlims(1), xlims(2), size(Sg,2));
yy = linspace(ylims(1), ylims(2), size(Sg,1));

figure(55); clf; hold on;
imagesc(Sg); axis tight ij; colormap('gray');
ticksOff;
h_ax_im = gca;

h_ax_plot = axes('position', get(h_ax_im, 'position'), 'color', 'none');

xlim(lims(xlims))
ylim(ylims);
yticks = [.001:.001:.01, .02:.01:.1];
set(gca, 'xscale', 'log', 'yScale', 'log', 'tickDir', 'out', 'nextPlot', 'add', 'xtick', [10:10:100], 'ytick', yticks);


%%
% hold on;
if exist('h1', 'var') && ~isempty(h1) && ishandle(h1(1))
    delete(h1);    
end

x1 = [ 5.2,    15,  30,  35,   40,  45,  60, 90 ];
y1 = [ .075, .08, .045,.035, .039, .0207, .0203, .0166 ];

x2 = [ 5.2,    15,  30,     62,];
y2 = [ .065, .065, .034,  .018];

x3 = [ 20.5, 29, 43];
y3 = [ .05, .03, .0265];

x4 = [ 10.5, 25, 43];
y4 = [ .07, .03, .0165];

x5 = [ 5.5, 29];
y5 = [ .073, .034 ];


h1(1) = plot(h_ax_plot, x1, y1, 'bs', 'markersize', 12);
h1(2) = plot(h_ax_plot, x2, y2, 'bo', 'markersize', 12);
h1(3) = plot(h_ax_plot, x3, y3, 'rs', 'markersize', 12);
h1(4) = plot(h_ax_plot, x4, y4, 'ro', 'markersize', 12);
h1(5) = plot(h_ax_plot, x5, y5, 'gx', 'markersize', 12);
% set(h1, 'xdata', x,'ydata', y, 'markersize', 12, 'color', 'r');


%%
cf_top_x = [0, 6.6];
cf_top_y = [1, 1]*1.68 ;
cf_bot_x = [11.6, 25];
cf_bot_y = [1, 1]*.176;

% h2 = plot(0, 0, 'r-');
set(h2, 'xdata', [cf_top_x, cf_bot_x], 'ydata', [cf_top_y cf_bot_y]);


%%

if exist('h2', 'var') && ~isempty(h2) && ishandle(h2)
    delete(h2);    
end


% x2 = [1   1   1   1   1   1.125   1.2  1.2  1.25   1.3  1.375   1.5  1.8   2   2   2.5  3   3   4   8  25  25];
% y2 = 10.^[  -0.39   -0.92    0.03   -0.25   -0.06   -1.03   -1.29   -1.11   -1.01   -1.24   -1.19   -1.22   -1.35,  -1.24   -1.39   -1.36   -1.31   -1.36   -1.47   -1.31   -1.36   -1.36 ];

x2 = [1    1    1    1.2    1.5    2    2    2    2.25    2.5    2.5    2.5    3     3    3    3    3.5    3.5    3.5    4    4    4    4.5    5    7.5   25  25   25];
y2 = 10.^[0.01    0.06    0.03    0.04    0.03   -0.03   -0.94    0.02   -1.24   -1.25   -0.94   -1.14   -1.28   -1.17   -1.19   -1.36   -1.27   -1.47   -1.26   -1.3   -1.26   -0.97   -1.3   -1.28   -1.33   -1.39  -1.29   -1.35 ];


h2 = plot(h_ax_plot, x2, y2, 'b^', 'markersize', 12);

%%

cf2_top_x = [0, 2.1];
cf2_top_y = [1, 1]*1 ;
cf2_bot_x = [2.7, 25];
cf2_bot_y = [1, 1]*.048;

if ~exist('h3', 'var') || isempty(h3)
    h3 = plot(0, 0, 'r-');
else
    set(h3, 'xdata', [cf2_top_x, cf2_bot_x], 'ydata', [cf2_top_y cf2_bot_y], 'color', 'b');
end

