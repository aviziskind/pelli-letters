%%
dx = 0.25;
x = -1:dx:4;
% x = x(:);

%%
% y = zeros(size(x));

centFreq = 2;
channelW = 1;

y = zeros(size(x));
y (   abs(x-centFreq) < channelW/2) = 1;

figure(536); clf; hold on;
plot(x,y, 's-', 'markersize', 8, 'linewidth', 1);

widthBox = 2;
x_box = 0:dx:widthBox;
octaveBox = ones( 1, length(x_box) );
octaveBox = octaveBox/ sum(octaveBox);
plot(x_box, octaveBox, 'rs:');


y_convBox = conv(y, octaveBox, 'same');

% y_convBox = y_convBox + randn(size(y_convBox))/50;

y_convBox = gaussSmooth(y_convBox, 0.5)';

% y_convBox_full = conv(y, octaveBox);
plot(x, y_convBox, 'g*-')

% y_orig_from_full = deconv(y_convBox_full, octaveBox);

% nToAdd = length(octaveBox)-1;
% nBefore = ceil(nToAdd/2);
% nAfter = nToAdd-nBefore;
% 
% y_convBox_padded = padarray( padarray(y_convBox, [0, nBefore], 'replicate', 'pre'), [0, nAfter], 'replicate', 'post');
% 
% y_orig = deconv(y_convBox_padded, octaveBox);

y_deconv = dConvWithBox(x, y_convBox, widthBox);

% plot(x, y_orig_from_full, 'k*-');
% plot(x, y_convBox, 
plot(x, y_deconv, 'm^-')

% %%
% figure(537); clf;
% y_thresholds = powerInHumanChannels_m;
% y_deconvChannel = dConvWithBox(x, y_thresholds, widthBox);
% plot(x, y_thresholds, 'bo-'); hold on;
% plot(x, y_deconvChannel, 'ro-')

