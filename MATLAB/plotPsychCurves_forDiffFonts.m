%%


%%

load('modelPerformance');

figure(16) 
clf; hold on; box on;

nUnits = 5;


%    all_nHUnits = [0,1,2,3,4,5,6,7,8,9,10,20,50,100];
 %  pctCorrect_v_nHiddenUnits_snr 
 % pctCorrect_vs_snr_ideal = [12.7500  52.660  99.6700,  100.0000,  100.0000];

fontsize = 12;

h = [];

idx_use = find(all_nHUnits == nUnits,1);

nnUnits = length(nHUnits_use);
for fi = 1:nFonts
    pcorr_model = pctCorrect_v_nHiddenUnits_snr.(allFontNames{fi})(idx_use,:);
    h_mp(fi) = plot(allSNRs, pcorr_model, ['o'], 'markersize', 6, 'color', color_s(fi));
    [snr_th, f_fit_model] = getSNRthreshold(allSNRs, pcorr_model) ;
    
    [xx1,yy1] = fplot(f_fit_model, [0, 4]);
    h_mf(fi) = plot(xx1,yy1, [color_s(fi) '-'], 'linewidth', 1);

    
    pcorr_ideal = pctCorrect_vs_snr_ideal.(allFontNames{fi});
    h_ip(fi) = plot(allSNRs, pcorr_ideal, '*', 'markersize', 6, 'color', color_s(fi));
    [snr_th, f_fit_ideal] = getSNRthreshold(allSNRs, pcorr_ideal ) ;
    
    [xx2,yy2] = fplot(f_fit_ideal, [0, 4]);
    h_if(fi) = plot(xx2,yy2, [color_s(fi) '--'], 'linewidth', 1);
    
end
drawHorizontalLine(64, 'linestyle', ':', 'color', 'k')

%pcorr_ideal = pctCorrect_vs_snr_ideal.(fontName);
%[snr_th, f_fit_ideal] = getSNRthreshold(allSNRs, pcorr_ideal ) ;

leg_model = legendarray('', allFontNames, ' (Model)');
leg_ideal = legendarray('', allFontNames, ' (Ideal)');


legend([h_mp, h_ip], [leg_model; leg_ideal], 'location', 'SE', 'fontsize', fontsize)
xlabel('log SNR', 'fontsize', fontsize)
ylabel('Percent Correct', 'fontsize', fontsize)
title(sprintf('Psychometric curves for %d Hidden Units', nUnits), 'fontsize', fontsize)

