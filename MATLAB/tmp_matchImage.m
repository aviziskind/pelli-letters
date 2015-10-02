% function tmp_matchImage

S = imread('filter_gain.png');
Sg = rgb2gray(S);
%%
xlims = [.1, 100];
ylims = [.001, 1];

xx = linspace(xlims(1), xlims(2), size(Sg,2));
yy = linspace(ylims(1), ylims(2), size(Sg,1));

figure(55); clf; hold on;
imagesc(Sg); axis tight ij; colormap('gray');
ticksOff;
h_ax_im = gca;
%%
h_ax_plot = axes('position', get(h_ax_im, 'position'), 'color', 'none');

xlim(xlims)
ylim(ylims);
set(gca, 'xscale', 'log', 'yScale', 'log');

%%
hold on;
delete(h1);
delete(h2);

x  = [ 0.41, 0.82, 1.65, 3.3, 6.7, 13];
y1 = [.0031, .019, .035, .083, .065, .001];
y2 = [.001, .001, .17, .109, .03, .001];
y1u = [.0075,   .009,  .008,  .06,   .035,   .003 ];
y1l = [.002,   .009,  .009,  .029,   .046,   .0 ];
y2u = [.0,   .0,      .14,  .03,   .01,   .014 ];
y2l = [.0,   .0,      .15,  .05,   .012,   .0 ];

h1 = errorbar(h_ax_plot, x, y1, y1l, y1u, 'bo-');
h2 = errorbar(h_ax_plot, x, y2, y2l, y2u, 'ro-');

%%
xlim(xlims)
ylim(ylims);
%%
%         allCycPerLet = [nan, 0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13];
%             allCycPerLet= [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];


%     allCycPerLet= [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];

% set(h1, 'xdata', x, 'ydata', y1);
% set(h2, 'xdata', x, 'ydata', y2);




% end