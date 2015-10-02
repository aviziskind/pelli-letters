%%
F.Braille.cycPerLet = [0.5000    0.7100    1.0000    1.4100    2.0000    2.8300    3.3600    4.0000    5.6600    8.0000   11.3100   16.0000];
F.Braille.thresholds = [6.5616    9.2849   15.0025   27.6775   55.1916  216.7931  230.3661  150.0584   30.7078   15.1621       NaN       NaN];
F.Braille.threshold_white = 83.39;
F.Braille.threshold_white_ideal = 16.00; 

F.Sloan.cycPerLet = [0.5000    0.7100    1.0000    1.4100    2.0000    2.3800    2.8300    3.3600    4.0000    5.6600    8.0000   11.3100   16.0000];
F.Sloan.thresholds = [5.6245   14.6141   20.5912   40.1828  120.6456  300.4263  409.0894  343.4588  285.1249   66.3436    8.5418       NaN       NaN];
F.Sloan.threshold_white = 124.01;
F.Sloan.threshold_white_ideal = 20.28; 

F.Bookman.cycPerLet = [0.5,   0.71,    1,      1.41,    2,        2.83, 2.83, 3.36,  4, 4.76,     5.66,     8,     11.31,     16];
F.Bookman.thresholds = [2.7812    3.4633    9.7016   18.8326   44.2199  155.1633  155.1633  323.3074  250.0650  118.4970   61.4418   11.2803    8.6847    5.1478];
F.Bookman.threshold_white = 102.26;
F.Bookman.threshold_white_ideal = 11.51; 

F.KuenstlerU.cycPerLet = [0.5000    0.7100    1.0000    1.4100    2.0000    2.8300    3.3600    4.0000    4.7600    5.6600    8.0000   11.3100   16.0000];
F.KuenstlerU.thresholds = [3.4424    4.3661    6.7984   10.8180   19.9354   70.9974  143.5656  390.5711  325.8387  158.1933   43.7129   18.5641    7.7647];
F.KuenstlerU.threshold_white = 174.24;
F.KuenstlerU.threshold_white_ideal = 7.22; 
    

imageSize = [100 100];
%%
fontNames = fieldnames(F);
figure(75); clf; hold on;
for i = 1:length(fontNames)
    %%
    x = F.(fontNames{i}).cycPerLet;
    y = F.(fontNames{i}).thresholds;
    plot(x,y, 'o-', 'color', color_s(i));
    
    logx = log10(x);
    logy = log10(y);
    
    i_peak = indmax(y);
    idx_around_peak = i_peak + [-2 : 2];
    p = polyfit(logx(idx_around_peak), logy(idx_around_peak), 2);
    a = p(1); b = p(2);  c = p(3);
    x_mid = 10.^( -b/(2*a) );
    th_peak_est = 10.^( c - (b^2)/(4*a) );
    
    line( x_mid  * [1, 1], lims(y), 'color', color_s(i), 'linestyle', '-', 'linewidth', 2  );
    
    x_fit = logspace( logx(idx_around_peak(1)), logx(idx_around_peak(end)), 50);
    y_fit = 10.^polyval(p, log10(x_fit));
    h(i) = plot(x_fit, y_fit, '-', 'color', color_s(i), 'linewidth', 2);
    plot(x_mid, th_peak_est, 'k*', 'markersize', 12)
    
    channel_cent(i) = x_mid;
    fontName_ext{i} = sprintf('%s : Freq=%.2f c/deg. Th=%.1f' , fontNames{i}, x_mid, th_peak_est);
    [a,fontData] = loadLetters(fontNames{i}, 'k32', 'minSize');
    stroke_freqs(i) = fontData.strokeFrequency;
    F.(fontNames{i}).channel_cent = x_mid;
    F.(fontNames{i}).threshold_channel = th_peak_est;
    
    opt.applyFourierMaskGainFactor = 1;
    noiseFilter.filterType = 'band';
    noiseFilter.cycPerLet_centFreq = x_mid;
    noiseFilter.cycPerLet_range = getCycPerLet_range(noiseFilter);
    noiseFilter.cycPerPix_range = noiseFilter.cycPerLet_range / fontData.x_height;
    mask_fftshifted = fourierMask(imageSize, noiseFilter.cycPerPix_range, 'band_cycPerPix', opt);
    max_mask = max(mask_fftshifted(:));

%     mask_fftshifted2 = fourierMask(imageSize, 'white');
%     noiseFilter_w.filterType = 'white';
%     [~, mask_fftshifted_w] = getNoiseMask(noiseFilter_w, imageSize); mask_fftshifted_w = mask_fftshifted_w{1};

    th_white(i) = F.(fontNames{i}).threshold_white;    
    th_channel_cent(i) = th_peak_est / max_mask;
    
end

set(gca, 'xscale', 'log', 'yscale', 'log');
xlim(lims(F.Braille.cycPerLet, 0.01, [], 1) );  
ylim([10, 1000]);
setLogAxesDecimal;
legend(h, fontName_ext, 'location', 'SE');

%%
figure(76); clf; 
plot(th_white, th_channel_cent, 'o'); hold on;
fplot(@(x) x, xlim, 'r:');


   
