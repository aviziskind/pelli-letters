function fig_crowdingDemo
%%
%%
plotHumanData = 1;
if plotHumanData
    %%
    th_1letter = .176;
    crit_spacing = 11.6;
    
    rescale_axes = 1;
    
    figure(1); clf; hold on; box on;
    ylims_orig = [.01, 10];

    x = [ 1,     2,   2,   4     8,  8, 8,     9,  9,    9   10, 10,  11, 11,    11, 12,   12,  12,  12, 13, 13,  14,   14, 14,  18, 18, 18, ];
    y = [ 1.68, 1.71, 1.9, 1.9  .5, .72, 1.49, .63, .67, .77, .32, 1, .13, .177, .38, .155, .31, .33, .8, .19, .21,.131, .18, .2, .145, .19, .21];

    if rescale_axes
        x_factor = 1/crit_spacing;
        y_factor = 1/th_1letter;
        xlims = [0, 2];
        ylims = [0.1, 100];
    else
        x_factor = 1;
        y_factor = 1;
        
        ylims = ylims_orig;
    end
    x = x * x_factor;
    y = y * y_factor;

    
    h1 = plot(  x, y, 'o', 'markersize', 12, 'color', .6*[1,1,1], 'linewidth', 2);
    % set(h1, 'xdata', x,'ydata', y, 'markersize', 12, 'color', 'r');

    line_w = 6;
     x_factor = 1/crit_spacing;
        y_factor = 1/th_1letter;
        xlims = [0, 2];
        ylims = [0.1, 100];
    cf_top_x = [0, 6.6] * x_factor;
    cf_top_y = [1, 1]*1.68 * y_factor;
    cf_bot_x = [11.6, 25] * x_factor;
    cf_bot_y = [1, 1]*.176 * y_factor;

    beta = [cf_top_x(2), cf_bot_x(1), cf_top_y(1), cf_bot_y(1)];
%     xx = linspace(xlims(1), xlims(2), 100);
%     yy = clippedLine(beta, xx);
    
%     [func, xx2, yy_fit] = fitCrowdingThresholds(x, y);
    
    h2 = plot([cf_top_x, cf_bot_x], [cf_top_y cf_bot_y], 'k-', 'linewidth', line_w);
%     h3 = plot(xx2, yy_fit , 'r-');
% %     yticks = [
    set(gca, 'yscale', 'log');
    set(gca, 'xlim', xlims, 'ylim', ylims);
    setLogAxesDecimal;
    
    set(gcf, 'position', [1197         338         536         412]);
    set(gca, 'units', 'pixels', 'position', [101    55   348   327]);
    
    xlabel('Spacing re critical spacing', 'fontsize', 18);
    ylabel('Threshold re that for 1 letter', 'fontsize', 18);
    
end

%%





fontName = {'Braille', 'BookmanB', 'Courier', 'KuenstlerU'};
nFonts = length(fontNames);

nLetVert = 7;

fontSize = 'large';
fontComplexities = zeros(1, nFonts);
for i = 1:nFonts
    efficiencies(i) = getStatsFromPaper(fontNames{i}, 'efficiency');
    th_human(i) = 10^getStatsFromPaper(fontNames{i}, 'th_human');
    fontComplexities(i) = getFontComplexity(fontNames{i}, fontSize);
end

%%
allSNRs_test = [0, 1, 1.5, 2, 2.5, 3, 4];
noisyLetterOpt = struct( 'oris', 0, 'xs', 0, 'ys', 0, 'stimType', 'NoisyLetters', 'tf_pca', 0, ...
                            'sizeStyle', fontSize, 'autoImageSize', 1);

braille_ok_letters = [4,5,6,9,11,15,16,17,21, 23, 24, 25, 26];                                
for fi = 1:nFonts
    [allLet{fi}, fontData{fi}] = loadLetters(fontNames{fi}, fontSize);
    allSignals{fi} = generateLetterSignals(allLet{fi}, 0, 0, 0);
    
    [pCorr_ideal_i] = getIdealPerformance(fontNames{fi}, allSNRs_test, noisyLetterOpt); 
    th_ideal(fi) = getSNRthreshold(allSNRs_test, pCorr_ideal_i);
    
end
%%
allH = cellfun(@(x) size(x,1), allLet);
allW = cellfun(@(x) size(x,2), allLet);
%%

nPixPerLetH = max(allH); nSpcH = 2;
nPixPerLetW = max(allW); nSpcW = 20;
N = nPixPerLetW*nFonts   + nSpcW * (nFonts+1);
M = nPixPerLetH*nLetVert + nSpcH * (nLetVert+1);


%%
cmpX = logspace(log10(fontComplexities(1)), log10(fontComplexities(end)), nFonts);

X_cent = round(nSpcW + nPixPerLetW/2 + [0:nFonts-1]*(nPixPerLetW+nSpcW));
Y_cent = round(nSpcH + nPixPerLetH/2 + [0:nLetVert-1]*(nPixPerLetH+nSpcH));

logCmp = log10(fontComplexities);


% logFontComplexities_scaled = (logCmp - logCmp(1))  / diff(logCmp([1, end])) * ;

%%
% X_cent = round(fontComplexities);

    noiseType = 'gaussian';    nNoiseSamples = 1e5; rand_seed = 0;
    noiseSamples = generateNoiseSamples(nNoiseSamples, noiseType, rand_seed);
    noiseSamples.noiseSize=[M,N];
    noiseImage = RandSample(noiseSamples.noiseList, noiseSamples.noiseSize);


    efficiencies = fliplr( logspace(log10(.01), log10(1), nLetVert) );
    
    %%
    
% logSNRs = logspace(.1, .2, nLetVert);

let_idxs = zeros(nLetVert, nFonts);
let_offset = 'a' - 1;
for fi = 1:nFonts
    rng(fi);
    switch fontNames{fi}, 
        case 'Braille', 
            rng(4);
            [4     5     6     9    11    15    16    17    21    23    24    25    26];
%             let_idxs_i = [17    25    15    21    23     9    11];
            let_idxs_i = braille_ok_letters([10    11     7     2    10     12     5]);
%             let_idxs_i = braille_ok_letters(10*[1,1,1,1,1,1,1]);
%             let_idxs_i = [17    25    15    21    23     5    11];
%             let_idxs_i = randsample( braille_ok_letters, nLetVert);
%         case 'BookmanB', 
%             let_idxs_i = 'hmpwuo' - let_offset;
        case 'Courier', 
            let_idxs_i = 'ayjiqfm' - let_offset;
        case 'KuenstlerU',
            let_idxs_i = 'ahsumza' - let_offset;
        otherwise,        
            let_idxs_i = randsample( braille_ok_letters, nLetVert);
    end
    let_idxs(:,fi) = let_idxs_i;
    
end
% let_idxs = randi(26, nLetVert, nFonts);
% let_idxs(:,1) = braille_ok_letters(randi( length(braille_ok_letters), nLetVert, 1));


% X_cent = round(nSpcW + nPixPerLetW/2 + [0:nFonts-1]*(nPixPerLetW+nSpcW));
% X_cent = round(log10(fontComplexities));
X_signals = zeros(M,N);
logX = logspace(1, 3, N);
idx_X = binarySearch(logX, fontComplexities);
X_cent = idx_X;


for fi = 1:nFonts
        
    for let_i = 1:nLetVert
        cur_th = th_ideal(fi) / efficiencies(let_i);
        th_human(let_i, fi) = cur_th;

        let_sig = allSignals{fi}(let_idxs(let_i,fi));
        
%         logE1=log10(let_sig.E1);
        logE1=log10([allSignals{fi}.E1]);
        params.logE1 = logE1;
        params.signalContrast = 1;
        params.varyContrast = 'signal';
        params.pixPerDeg = 1;

        logSNR = log10(cur_th); %logSNRs(let_i);
        
    %     params.logSNR = logSNRs(let_i);
        [signalContrast, noiseContrast, logE, logN] = getSignalNoiseContrast(logSNR, params);
        
        let_sig_image = let_sig.image; [h,w] = size(let_sig_image);
        pos_u = round(Y_cent(let_i) - h/2);
        pos_l = round(X_cent(fi)    - w/2);
        
        X_signals(pos_u + [0:h-1], pos_l + [0:w-1]) = let_sig_image * signalContrast;
        
%         generateSetOfLetters(allSignals{fi}, params)


    end

end

X_noise = noiseImage;
X_display = X_signals + X_noise*1;
% X_display = X_signals*1;
figure(99); clf; 
imagesc(X_display);
h_ax_im = gca;
L = max(abs(lims(X_display(:))));
caxis([-L, L]);
ticksOff;

axis equal tight;
imageToScale([], 1);
set(h_ax_im, 'units', 'normalized', 'visible', 'off');




% ax_pos = get(h_ax_im, 'position');
% annotation('rectangle', ax_pos);
ax_pos2 = getModifiedAxPosition(h_ax_im);
% annotation('rectangle', ax_pos2, 'color', 'r');


            
%             fig_pos = get(gcf, 'position');
%             fig_ar = fig_pos(4)/fig_pos(3);
%             
%             ax_log_xlim = log10(get(h_ax, 'xlim'));
% %             ax_log_ylim = log10(get(h_ax, 'ylim'));
%                                     
%             log_cmp = log10(font_complexities_model);



h_ax_scl = axes('position', ax_pos2, 'box', 'off');

xticks = [10, 100, 1000]; xticklabels = {'10', '100', '1000'};
yticks = [.01, .1, 1]; yticklabels = {'0.01', '0.1', '1'};
set(h_ax_scl, 'color', 'none', 'xlim', [10, 1000], 'ylim', [.01, 1], 'xscale', 'log', 'yscale', 'log', ...
    'xtick', xticks, 'ytick', yticks, 'xticklabel', xticklabels, 'ytickLabel', yticklabels, 'tickDir', 'out');
% xlabel('Complexity'); ylabel('Efficiency');


%%

% imageToScale;

colormap('gray');
3;



