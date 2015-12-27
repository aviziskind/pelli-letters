%%
pCorr_ideal   = [16.2000   34.8000   75.5300   98.8600   99.9900  100.0000  100.0000  100.0000];
% pCorr_convnet = [3.7500    4.8500    8.8000   21.7000   58.2000   91.7000   97.5000   96.1000];
pCorr_convnet = [3.7500    4.8500    8.8000   21.7000   58.2000   91.7000   100  100];
pCorr_texture = [ 3.5000    4.1000    4.8500    8.8500   26.9000   74.4500   100  100.0000];
% pCorr_human   = [];

allLogSNRs = [0, 0.5, 1, 1.5 2, 2.5 3, 4];

idx_use = [1, 2, 3, 4, 5, 6, 7, 8];
allLogSNRs = allLogSNRs(idx_use);
pCorr_ideal = pCorr_ideal(idx_use);
pCorr_convnet = pCorr_convnet(idx_use);
pCorr_texture = pCorr_texture(idx_use);

allSNRs = 10.^allLogSNRs;  

allLogSNRs_fine = linspace(min(allLogSNRs), max(allLogSNRs), 200);
allSNRs_fine = 10.^allLogSNRs_fine;


allLogSNRs_human = [1.8000    1.9000    2.0000    2.1000    2.2000    2.3000    2.4000];
pCorr_human =      [0.3056    0.3871    0.4516    0.7377    0.7377    0.8033    0.8667]*100;

opt = struct('assumeMax100pct', 1);
[snr_th_ideal, bestFitFunc_ideal] = getSNRthreshold(allLogSNRs, pCorr_ideal, opt);
[snr_th_convnet, bestFitFunc_convnet] = getSNRthreshold(allLogSNRs, pCorr_convnet, opt);
[snr_th_texture, bestFitFunc_texture] = getSNRthreshold(allLogSNRs, pCorr_texture, opt);
[snr_th_human, bestFitFunc_human] = getSNRthreshold(allLogSNRs_human, pCorr_human, opt);
allSNRs_human = 10.^allLogSNRs_human;

replaceHumanPointsWithFit = 1;
if replaceHumanPointsWithFit
    pCorr_human = bestFitFunc_human(allSNRs_human);
end

idx_human_use = [2, 3, 4, 5, 6];
allLogSNRs_human = allLogSNRs_human(idx_human_use);
pCorr_human = pCorr_human(idx_human_use);
allSNRs_human = 10.^allLogSNRs_human;

%%



pCorr_ideal_fine = bestFitFunc_ideal(allSNRs_fine);   
pCorr_ideal_convnet = bestFitFunc_convnet(allSNRs_fine);   
pCorr_ideal_texture = bestFitFunc_texture(allSNRs_fine);   
pCorr_ideal_human = bestFitFunc_human(allSNRs_fine);   



mkSize = 12;
lw = 3;
figure(54); clf; hold on; box on;

h_pts(1) = plot(allSNRs, pCorr_ideal, 'r*', 'markersize', mkSize, 'linewidth', lw);
h(1) = plot(allSNRs_fine, pCorr_ideal_fine, 'r-', 'linewidth', lw);

h_pts(3) = plot(allSNRs, pCorr_convnet, 'bs', 'markersize', mkSize, 'linewidth', lw);
h(3) = plot(allSNRs_fine, pCorr_ideal_convnet, 'b-', 'linewidth', lw);

h_pts(4) = plot(allSNRs, pCorr_texture, 'g^', 'markersize', mkSize, 'linewidth', lw);
h(4) = plot(allSNRs_fine, pCorr_ideal_texture, 'g-', 'linewidth', lw);

h_pts(2) = plot(allSNRs_human, pCorr_human, 'ks', 'markersize', mkSize, 'linewidth', lw, 'color', 'k');
h(2) = plot(allSNRs_fine, pCorr_ideal_human, 'k-', 'linewidth', lw);

set(gca, 'xscale', 'log')

drawHorizontalLine(64, 'linewidth', 2, 'linestyle', ':');


set(h, 'linewidth', lw)
set(h_pts, 'linewidth', lw, 'markersize', mkSize);
legend(h, {'Ideal Observer', 'Human observer', 'ConvNet', 'Texture model'}, 'location', 'SE');
ylabel('% correct', 'fontsize', 15);
xlabel('E / N', 'fontsize', 15);
title('Psychometric curves', 'fontsize', 18);
