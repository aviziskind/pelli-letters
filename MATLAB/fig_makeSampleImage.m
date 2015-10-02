%%
imSize = [64, 64];

allLet = loadLetters('BookmanU', 36);
noiseType = 'gaussian';    nNoiseSamples = 1e5; rand_seed = 0;
noiseSamples = generateNoiseSamples(nNoiseSamples, noiseType, rand_seed);
noiseSamples.noiseSize = imSize;
noiseImage = RandSample(noiseSamples.noiseList, noiseSamples.noiseSize);
params.imageHeight = imSize(1);
params.imageWidth = imSize(2);
sig = generateLetterSignals(allLet, 0, 0, 0, params);
%%
signal_image = circshift(sig(1).image, [5, 0]);

sampleImage = signal_image * 4 + noiseImage;

figure(49); clf;
subplot(1,2,1);
imagesc(sampleImage);
colormap('gray');
axis equal tight;

%%
textureSt = textureAnalysis(double(sampleImage), 4,4,5);
%%
nSamples = 10;
for i = 1:nSamples
    sampleMet_C{i} = createMetamer(textureSt, size(sampleImage), i-1, 25, 100);
    fprintf('*');
    sampleMet_cent_C{i} = centerMetamer(sampleMet_C{i});
end
%%

for i = 1:nSamples
   subplot(3,4,i); imagesc(sampleMet_cent_C{i}); axis equal tight; 
end

%%
% S.sampleImage2 = 
sampleMet = sampleMet_C = createMetamer(textureSt, size(sampleImage), 2, 25, 100);
%%
sampleMet_cent = centerMetamer(sampleMet);
sampleMet_cent2 = centerMetamer(sampleMet2);
%%
subplot(1,2,1);

imagesc(sampleMet_cent2);
colormap('gray');
axis equal tight;
