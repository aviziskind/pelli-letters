% function tmp_matchImage

S = imread('pelli94_3a.png');
Sg = rgb2gray(S);
%%
xlims = [.1, 100];
ylims = [-20, 80];

xx = linspace(xlims(1), xlims(2), size(Sg,2));
yy = linspace(ylims(1), ylims(2), size(Sg,1));
%%
figure(55); clf; hold on;
imagesc(Sg); axis tight ij; colormap('gray');
ticksOff; hold on;
h_ax_im = gca;
%%
h_ax_plot = axes('position', get(h_ax_im, 'position'), 'color', 'none');

xlim(xlims)
ylim(ylims);
set(gca, 'xscale', 'log', 'yScale', 'linear');

%%
% 
hold on;
if exist('h1', 'var') && ishandle(h1)
    delete(h1);
end
if exist('h2', 'var') && ishandle(h2)
    delete(h2);
end
% 

x  = [ 0.5, 1, 2, 4, 8, 16];
y_lo = [.01, .1, .4, 18.5, 69, 70];
y_hi = [ 69, 68, 44, 10.5, 1, .1];

h1 = plot(h_ax_plot, x, y_lo, 'bo-', 'markersize', 6, 'markerfacecolor', 'b');
h2 = plot(h_ax_plot, x, y_hi, 'ro-', 'markersize', 6, 'markerfacecolor', 'r');

%%
xlim(xlims)
ylim(ylims);

%%
figure(56); clf;
[freqs, Gain1] = getChannelFromThresholds(x, y_lo, 'lo');
[freqs, Gain2] = getChannelFromThresholds(x, y_hi, 'hi');
plot(freqs, Gain1, 'bo-'); hold on;
plot(freqs, Gain2, 'ro-'); 
set(gca, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(freqs, .05, [], 1), 'xtick', freqs)




%%
%         allCycPerLet = [nan, 0.5, 0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13];
%             allCycPerLet= [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];


%     allCycPerLet= [0.5, 0.8, 1.0, 1.3, 1.6, 2.0, 2.5, 3.2, 4.1, 5.1, 6.5, 8.1, 10.3, 13];

% set(h1, 'xdata', x, 'ydata', y1);
% set(h2, 'xdata', x, 'ydata', y2);




% end