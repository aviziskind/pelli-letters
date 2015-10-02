%%
S= load('modelPerformance.mat');

nHUnits_use = [1:10];
idx_nhu_use = binarySearch(S.all_nHUnits, nHUnits_use, 1, 0);

%%
nHUnits_use = nHUnits_use(idx_nhu_use > 0);
idx_nhu_use = binarySearch(S.all_nHUnits, nHUnits_use, 1, 0);

nFonts = S.nFonts;
fontsize = 12;
figure(10); clf; hold on; box on;

for fi = 1:nFonts
%    all_nHUnits = [0,1,2,3,4,5,6,7,8,9,10,20,50,100];
 %  pctCorrect_v_nHiddenUnits_snr 
 % pctCorrect_vs_snr_ideal = [12.7500  52.660  99.6700,  100.0000,  100.0000];

    h(fi) = plot(nHUnits_use, S.pctCorrect_v_nHiddenUnits_snr.(S.allFontNames{fi})(idx_nhu_use,end), [color_s(fi) 'o-']);
end
hL = legend(S.allFontNames, 'location', 'E', 'fontsize', fontsize);
xlabel('Number of Hidden Units', 'fontsize', fontsize);
ylabel('% Correct (SNR = 4)', 'fontsize', fontsize);

set(h, 'markersize', 10)
% plot([nHUnits([1, 7])], [1/26, 1/26]*100, 'k:')

%image_folder = '/home/avi/Code/torch/letters/font_files/samples/';
%braille_im = imread([image_folder 'Braille_N.png']);
%   georgia_im = imread([image_folder 'Georgia_G.png']);


%ax_b = axes('position',[0,0.9,0.1,0.1]);
%imshow(braille_im);

