%%

load('modelPerformance');

figure(15) 
clf; hold on; box on;

fontName = 'Georgia';


%    all_nHUnits = [0,1,2,3,4,5,6,7,8,9,10,20,50,100];
 %  pctCorrect_v_nHiddenUnits_snr 
 % pctCorrect_vs_snr_ideal = [12.7500  52.660  99.6700,  100.0000,  100.0000];

fontsize = 12;

% nHUnits_use = [1,2,3,4,5,8,10,50];
nHUnits_use = [8,10,50];
idx_use = find( arrayfun(@(i) any(i == nHUnits_use), all_nHUnits) );
h = [];

nnUnits = length(nHUnits_use);
for nni = 1:nnUnits
    pcorr = pctCorrect_v_nHiddenUnits_snr.(fontName)(idx_use(nni),:);
    h(nni) = plot(allSNRs, pcorr, [color_s(nni) 'o'], 'markersize', 6, 'markerfacecolor', color_s(nni));
    [snr_th, f_fit_i] = getSNRthreshold(allSNRs, pcorr ) ;
    
    [xx,yy] = fplot(f_fit_i, [0, 4]);
    plot(xx,yy, [color_s(nni) '-'], 'linewidth', 1)
    
end

pcorr_ideal = pctCorrect_vs_snr_ideal.(fontName);
[snr_th, f_fit_ideal] = getSNRthreshold(allSNRs, pcorr_ideal ) ;

h(nni+1) = plot(allSNRs, pcorr_ideal, 'o', 'markersize', 8, 'color', 'k', 'linewidth', 2);
[xx,yy] = fplot(f_fit_ideal, [0, 4]);
plot(xx,yy, 'k--', 'linewidth', 1);
leg_entries = legendarray('#Hidden = ', nHUnits_use);

legend(h, [leg_entries; 'Ideal'], 'location', 'NW', 'fontsize', fontsize)

xlabel('log SNR', 'fontsize', fontsize)
ylabel('Percent Correct', 'fontsize', fontsize)
title('Georgia Font', 'fontsize', fontsize)

