allCycPerLet = [0.5    0.59    0.71    0.84    1    1.19    1.41    1.68    2    2.38    2.83    3.36    4 4.76    5.66    6.73    8    9.51   11.31   13.45   16];
pixPerLet = 49;
pixPerImage = 144;
letPerImage = pixPerImage / pixPerLet;

%%  
logThs_band_1oct =  [-18.5906  -18.3596  -18.2104  -18.016  -17.9588  -17.7324   -5.2176   -3.1371   -2.4211   -2.106   -1.8645   -1.8233   -1.9179    -2.1203   -2.8264  -16.4283  -16.3153  -16.2207  -16.0884  -15.9839  -15.8656];
logThs_band_2oct =  [-17.9609   -6.7954   -4.7318   -3.8051   -3.1425   -2.7643   -2.4717   -2.3003   -2.146   -1.9914   -1.839   -1.6771   -1.5217   -1.3663   -1.2132   -1.2053   -1.303   -1.4872   -2.1085  -15.2481  -15.1271];
th_band_1oct = 10.^logThs_band_1oct;
th_band_2oct = 10.^logThs_band_2oct;

figure(67); clf; hold on;
plot(allCycPerLet, th_band_1oct, '.-');
set(gca, 'xscale', 'log', 'yscale', 'log');


%%
% maxFreq_cpl = 22;
% minFreq_cpl = 0.3;

%%

nFreqTest = length(allCycPerLet);
logF = log2(allCycPerLet);

allCycPerImage = 1:pixPerImage/2;
nFreqAll = length(allCycPerImage);

allCycPerLet_image = allCycPerImage / letPerImage;


A = zeros(nFreqTest,nFreqAll);

octaveRange = [1/sqrt(2), sqrt(2)];


% cycPerPix_range = cycPerLet_range * letPerImage;
% cycPerImage_range = cycPerPix_range .* letPerImage;

for i = 1:nFreqTest
%     cycPerPixel_range =  allCycPerLet(i) * octaveRange * letPerImage;
    cycPerImage_range =  allCycPerLet(i) * octaveRange * letPerImage;
    idx_activated = ibetween(allCycPerImage, cycPerImage_range);
    A(i, idx_activated) = 1;    
end

%%


% testCycPerImage = 

% A * chGain = th
chGain_band = A\th_band_1oct(:);

ch_sim = zeros(1, nFreqTest);
ch_sim(ibetween(allCycPerLet, 3*octaveRange )) = 1; 

%%
ch_sim = zeros(1, nFreqAll);
% ch_sim(ibetween(allCycPerLet_image, 2*octaveRange )) = 1; 

ch_sim = gaussian(    log2(allCycPerLet_image), log2(2), 1 );


plot(allCycPerLet, A * ch_sim(:), '.-');
set(gca, 'xscale', 'log')


%%
figure(70); clf; hold on;
plot(allCycPerLet, chGain_band, '.-');
set(gca, 'xscale', 'log', 'yscale', 'log');


%%

    %%


ch_f = [0.5469    0.6528    0.7777    0.9235    1.0991    1.3046    1.5509    1.8469    2.1982    2.6147    3.1063    3.6939    4.3965  5.2294    6.2181    7.3923    8.7875   10.4488   12.4262   14.7801];
log_chGain_lo_sim = [-4   -4   -4   -4   -4   -4   -4   -1.9573   -1.0472   -0.797   -0.8394   -0.7929   -1.1237  -1.5338   -4   -4   -4   -4   -4   -4 ];
log_chGain_hi_sim = [-4   -4   -4   -4   -4   -4   -4   -1.1477   -1.042   -0.7806   -0.7993   -0.8041   -1.1792  -4   -4   -4   -4   -4   -4   -4 ];
   
chGain_lo_sim = 10.^log_chGain_lo_sim;
chGain_hi_sim = 10.^log_chGain_hi_sim;
   



%%

figure(68); clf; hold on;
plot(ch_f, chGain_lo_sim, 'r.-')
plot(ch_f, chGain_hi_sim, 'b.-');
set(gca, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(ch_f, [], 2, 1));


widthOfBandPass_oct = 1;

%%

% allCycPerLet
log_th_band_sim = [-14.4577   -3.4782   -1.6040   -0.8652   -0.3420   -0.1411   -0.0049    0.0030    0.0003   -0.0042   -0.0095    0.0011   -0.0002  0.0012    0.0009   -0.1426   -0.3927   -0.7289   -1.5017  -14.7896  -14.8271];
th_band_sim = 10.^log_th_band_sim;

th_band_sim_sm = gaussSmooth(th_band_sim, 1)';

log_th_band_sim = log10(th_band_sim_sm);
chGain_band_sim = dConvWithBox(allCycPerLet, th_band_sim, 1);

figure(59);
plot(allCycPerLet, th_band_sim, '.-');
set(gca, 'xscale', 'log')

set(gca, 'yscale', 'log')


chGain_band_sim = bestConvFilterFit(allCycPerLet, th_band_sim, 1);


% getCycPerLet_range(
