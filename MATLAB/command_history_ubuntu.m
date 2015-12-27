%-- Unknown date --%
/Code/nyu/letters/torch/TrainedNetworks/Grouping_NYU/NoisyLetters/SVHN_64x64__Conv_f6_16_F120_fs5_5_psz2_2_ptMAX__SGD__tr2.mat')
S = orderfields(S)
w = S.m1_weight;
size(w)
figure
imagesc(tileImages(squeeze(w)))
colormap('gray')
a = fourierMask([64, 64], '1/f', 1);
a = fourierMask([64, 64], 1, '1/f');
figure
imagesc(a)
S = loadLetters('Snakes', 'k32');
figure
[snk,snk_data] = loadLetters('Snakes', 'k32');
subplot(1,2,1)
imagesc(tileImages(snk))
subplot(1,2,2)
[sln,sln_data] = loadLetters('Sloan', 'k32');
idx_use = binarySearch(double('A':'Z'), double('CDHKNORSVZ'))
imagesc(tileImages(sln(:,:,idx_use)))
size(sln)
sln_pad = padarray(sln, 12, 0, 'both');
size(sln_pad)
sln_pad = padarray(sln, 12, 2, 'both');
size(sln_pad)
sln_pad = padarray(sln, 12, 1, 'both');
size(sln_pad)
sln_pad = padarray(sln, [14, 14], 0, 'both');
size(sln_pad)
sln_pad = padarray(sln, [15, 15], 0, 'both');
size(sln_pad)
sln_pad= sln_pad(:,1:64, :);
sln_pad = padarray(sln, [17, 16], 0, 'both');
size(sln_pad)
sln_pad= sln_pad(1:64,1:64, :);
imagesc(tileImages(sln_pad(:,:,idx_use)))
edit fourierMask
edit testFourierMask.m
sln_pad_filt = fourierMask(sln_pad, 1, '1/f');
for i = 1:n3
X_filtered(:,:,i) = ifft2( ifftshift( Xf(:,:,i) .* mask), 'symmetric') ;
end
n3 = size(Xf, 3);
for i = 1:n3
X_filtered(:,:,i) = ifft2( ifftshift( Xf(:,:,i) .* mask), 'symmetric') ;
end
sln_pad_filt = fourierMask(sln_pad, 1, '1/f');
imagesc(tileImages(sln_pad_filt(:,:,idx_use)))
colormap('gray')
sln_pad_filt = fourierMask(sln_pad, [5, 10], 'band_cycPerImage');
imagesc(tileImages(sln_pad_filt(:,:,idx_use)))
imagesc(tileImages(sln_pad_filt(:,:,:)))
imagesc(tileImages(sln_pad(:,:,:)))
subplot(1,2,1)
size(snk)
snk_data
[snk,snk_data] = loadLetters('Snakes', '32');
snk_data
createFontSizesFile
addSummaryOfFontSizesToFontFile
loadLetters('save')
createFontSizesFile
[snk,snk_data] = loadLetters('Snakes', '32');
snk_data
[snk,snk_data] = loadLetters('SnakesN', '32');
snk_data
S = loadLetters;
S
edit loadLetters
loadLetters
S = loadLetters
S_fonts
S_fonts = rmfield(S_fonts, 'Snakes_55');
S_fonts = rmfield(S_fonts, 'Snakes');
save(fontsFile, '-struct', 'S_fonts');
S = loadLetters('Snakes', 'k32');
[snk,snk_data] = loadLetters('SnakesN', '32');
subplot(1,2,1)
imagesc(tileImages(snk))
snk_pad = padarray(snk, [17, 16], 0, 'both');
size(snk)
size(snk_pad)
snk_pad = padarray(snk, [15, 15], 0, 'both');
size(snk_pad)
snk_pad = snk_pad(1:64, 1:64, :);
imagesc(tileImages(snk_pad))
subplot(1,2,2)
imagesc(tileImages(sln_pad))
imagesc(tileImages(sln_pad_filt))
sln_pad_filt = fourierMask(sln_pad, [5, 10], 'band_cycPerImage');
imagesc(tileImages(sln_pad_filt))
sln_pad_filt = fourierMask(sln_pad, [5, 10], 'band_cycPerImage');
imagesc(tileImages(sln_pad_filt))
imagesc(tileImages(sln_pad_filt(:,:,idx_use))
imagesc(tileImages(sln_pad_filt(:,:,idx_use)))
figure
imagesc(abs(fft2(snk_pad(:,:,1)))
imagesc(abs(fft2(snk_pad(:,:,1))))
imagesc(fftshift( abs(fft2(snk_pad(:,:,1)))) )
imagesc(fftshift( abs(fft2(snk_pad(:,:,2)))) )
imagesc(fftshift( abs(fft2(snk_pad(:,:,3)))) )
imagesc(fftshift( abs(fft2(snk_pad(:,:,4)))) )
imagesc(fftshift( abs(fft2(snk_pad(:,:,5)))) )
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,:)))) , 3  ) )
axis image
subplot(1,2,1)
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,:)))) , 3  ) )
axis image
subplot(1,2,2);
imagesc(fourierMask([64, 64], [.1, .2], 'band_cycPerPix'))
imagesc(fourierMask([64, 64], [.1, .15], 'band_cycPerPix'))
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,6)))) , 3  ) )
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,7)))) , 3  ) )
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,8)))) , 3  ) )
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,9)))) , 3  ) )
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,10)))) , 3  ) )
imagesc(fourierMask([64, 64], .25*[1/sqrt(2), sqrt(2)], 'band_cycPerPix'))
subplot(1,2,2);
log2([1/sqrt(2), sqrt(2)])
2^[-.25, .25]
2.^[-.25, .25]
imagesc(fourierMask([64, 64], .25*(2.^[-.25, .25]), 'band_cycPerPix'))
imagesc(fourierMask([64, 64], .25*(2.^[-.1, .1]), 'band_cycPerPix'))
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,10)))) , 3  ) )
imagesc( mean( fftshift( abs(fft2(snk_pad(:,:,:)))) , 3  ) )
imagesc( ifft2( fftshift( fourierMask([64, 64], .25*(2.^[-.25, .25]), 'band_cycPerPix')) ), 'symmetric' )
imagesc( ifft2( fftshift( fourierMask([64, 64], .25*(2.^[-.25, .25]), 'band_cycPerPix')), 'symmetric' ) )
imagesc( ifft2( ifftshift( fourierMask([64, 64], .25*(2.^[-.25, .25]), 'band_cycPerPix')), 'symmetric' ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .25*(2.^[-.25, .25]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .25*(2.^[-.1, .1]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .25*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .2*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .5*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .8*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .7*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .6*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .5*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .4*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .3*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .4*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .5*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .4*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .25*(2.^[-.01, .01]), 'band_cycPerPix')), 'symmetric' ) ) )
imagesc( ifftshift( ifft2( ifftshift( fourierMask([64, 64], .25*(2.^[-.1, .1]), 'band_cycPerPix')), 'symmetric' ) ) )
snk_pad_filt = fourierMask(snk_pad, .25*(2.^[-.1, .1]), 'band_cycPerPix');
figure
subplot(1,2,1)
imagesc( tileImages( snk_pad_filt ))
colormap('gray')
snk_pad_filt = fourierMask(snk_pad, .5*(2.^[-.5, .5]), 'band_cycPerPix');
imagesc( tileImages( snk_pad_filt ))
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .5*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .2*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .1*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-1, 1]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-1, 1]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-.5, .5]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-1, 1]), 'band_cycPerPix') ) );
imagesc( fourierMask( [64, 64], .25*(2.^[-1, 1]), 'band_cycPerPix') );
imagesc(tileImages( fourierMask(snk_pad, .25*(2.^[-1, 1]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(sln_pad, .25*(2.^[-1, 1]), 'band_cycPerPix') ) );
imagesc(tileImages( fourierMask(sln_pad(:,:,idx_use), .25*(2.^[-1, 1]), 'band_cycPerPix') ) );
edit convertSVHNtoGrayscale.m
legendarray('', 1:10)
edit cropSVHNorig.m
cropSVHNorig
size(S_cropped.X)
im = imread([pth digitStruct(dig_i).name]);
cropSVHNorig
clf
figure
subplot(1,3,1); image(im); title('Original image (with box)');
clf
imageToScale
imageToScale([], 2)
imageToScale([], 3)
imageToScale([], 1)
edit cropSVHNorig.m
imageToScale([], 1)
box = digitStruct(dig_i).bbox(sub_dig);
[im_height, im_width, ~] = size(im);
edit cropSVHNorig.m
edit createNoisyLettersDatafile
createFontSizesFile
createNoisyLettersDatafile
edit createNoisyLettersDatafile
%-- 01/07/2015 01:35:17 PM --%
figure(3)
plot(1:10, 1:10)
edit getRawFontName.m
edit createNoisyLettersDatafile
createNoisyLettersDatafile
S = loadLetters
extractFontFromPNG
edit extractFontFromPNG.m
extractFontFromPNG
edit loadLetters.m
extractFontFromPNG
S_fonts
addSummaryOfFontSizesToFontFile
any(strncmpi(rawFontName, {'Snakes', 'Sloan', 'Checkers'}, 6))
[ra, u,b,i,o,t] = getRawFontName('Sloan02')
[ra, u,b,i,o,t] = getRawFontName('SloanO2')
[ra, u,b,i,o,t] = getRawFontName('Checkers4x4')
any(strncmp(rawFontName(end-2:end), {'4x4', '5x7'}, 3))
[ra, u,b,i,o,t] = getRawFontName('Checkers4x4')
extractFontFromPNG('Sloan', 'k32')
extractFontFromPNG('Sloan', '19')
extractFontFromPNG('Sloan', 19)
edit loadLetters.m
edit createNoisyLettersDatafile
createNoisyLettersDatafile
S = loadLetters('SnakesN', 'k32')
[a,b] = loadLetters('SnakesN', 'k32'); b
[a,b] = loadLetters('Sloan', 'k32'); b
createNoisyLettersDatafile
S = loadLetters('SnakesT3', 'k32')
createFontSizesFile
S = loadLetters('SnakesT3', 'k32')
S = loadLetters('SloanT3', 'k32')
S = loadLetters
ls
ls *.mat
ls fonts*.mat
edit loadLetters.m
loadLetters('save')
createFontSizesFile
edit getRawFontName.m
edit generateLetterSignals.m
edit createNoisyLettersDatafile
580/20
edit tmp_renameFilesInFolder.m
lettersPath
codePath
edit lettersPath.m
tmp_renameFilesInFolder
createNoisyLettersDatafile
imageToScale([], 1)
edit convertSVHNtoGrayscale.m
S = load('SnakesN_55-1oxy-[64x64]-30SNR.mat')
lims(S.inputMatrix)
std(S.inputMatrix)
std(S.inputMatrix(:))
edit plotResults
edit getNoisyLetterOptsStr.m
plotResults
noisyLetterOpts.fontName
allWiggles
allWiggles{1}
allWiggles{2}
plotResults
noisyLetterOpts.fontName.wiggles
noisyLetterOpts.trainingWiggle
isequal(noisyLetterOpts.trainingWiggle, noisyLetterOpts.fontName.wiggles)
plotResults
varargin
nargin
varargin{:}
help varargin
print(varargin)
celldisp(varargin)
disp(varargin)
plotResults
DataHash('asdf')
DataHash('asdg')
DataHash(fld_name_orig)
length(DataHash(fld_name_orig))
tic; length(DataHash(fld_name_orig)) toc;
tic; length(DataHash(fld_name_orig)); toc;
plotResults
edit getNoisyLetterOptsStr.m
plotResults
noiseFilterOptStr(noisyLetterOpts, niceStrFields)
edit tmp_renameFilesInFolder.m
tmp_renameFilesInFolder
%-- 01/12/2015 05:13:10 PM --%
plotResults
noisyLetterOpts.trainingNoise
noisyLetterOpts.noiseFilter
plotResults
(filterStr(noisyLetterOpts.noiseFilter, 1) ~= filterStr(noisyLetterOpts.trainingNoise, 1))
plotResults
DataHash(fld_name_orig, struct('Method', 'SHA-1'))
length(DataHash(fld_name_orig, struct('Method', 'SHA-1')))
length(DataHash(fld_name_orig, struct('Method', 'MD2')))
DataHash(fld_name_orig, struct('Method', 'MD2'))
DataHash(fld_name_orig, struct('Method', 'SHA-256'))
length(DataHash(fld_name_orig, struct('Method', 'SHA-256')))
length(DataHash(fld_name_orig, struct('Method', '384')))
length(DataHash(fld_name_orig, struct('Method', 'SHA-384')))
length(DataHash(fld_name_orig, struct('Method', 'SHA-512')))
plotResults
edit plotResults
plotResults
filterStr( letterOpt_use.trainingNoise )
filterStr( letterOpt_use.trainingNoise, 1 )
[a,b] = filterStr( letterOpt_use.trainingNoise, 1 )
plotResults
edit convertSVHNtoGrayscale.m
plotResults
edit getNetworkStr.m
plotResults
edit getNetworkStr.m
plotResults
edit createNoisyLettersDatafile
createNoisyLettersDatafile
imageToScale([], 1)
load('SloanO2_k32-21ori[2]_10x[2]_10y[2]-[64x64]-50SNR.mat')
lims(inputMatrix(:0)
lims(inputMatrix(:))
plotResults
edit getSVHNOptsStr.m
edit abbrevFontStyleNames.m
plotResults
edit getNoisyLetterOptsStr.m
plotResults
allWiggles
allWiggles_S
[i,j] = ind2sub([10, 2], 1)
[i,j] = ind2sub([10, 2], 2)
[i,j] = ind2sub([10, 2], 3)
[i,j] = ind2sub([10, 2], 4)
edit plotResults
plotResults
edit measurePsychCurves_together.m
measurePsychCurves_together
[rawFontName, fontAttrib] = getRawFontName(fontName);
measurePsychCurves_together
1
close all
edit plotResults
plotResults
edit getNoisyLetterOptsStr.m
edit getLetterOptsStr.m
edit getNoisyLetterOptsStr.m
edit getNoisyLetterFileName.m
edit getNetworkStr.m
plotResults
edit plotResults
plotResults
close all
measurePsychCurves_together
letterOpts.noiseFilter
measurePsychCurves_together
getWiggleList('orientation', [10,20])
getWiggleList(struct('orientation', [10,20]))
allWiggles_ori    = [0, 10:5:90];
allWiggles_offset = [0, 10:5:60];
allWiggleTypes = {'orientation', 'offset'};
allWiggleAngles = {allWiggles_ori, allWiggles_offset};
allWiggles = getWiggleList('orientation', allWiggles_ori, 'offset', allWiggles_offset);
allFontNames = arrayfun(@(w) abbrevFontStyleNames(  struct('fonts', 'Snakes', 'wiggles', w) ), allWiggles)
allFontNames = arrayfun(@(w) abbrevFontStyleNames(  struct('fonts', 'Snakes', 'wiggles', w) ), allWiggles, 'un', 0)
edit createNoisyLettersDatafile
getSnakeWiggleStr(allWiggles(1))
getSnakeWiggleStr(allWiggles(2))
getSnakeWiggleStr(allWiggles(10))
allWiggles(10)
allWiggles{10}
getSnakeWiggleStr(allWiggles{10})
allFontNames = cellfun(@(w) getSnakeWiggleStr(w), allWiggles, 'un', 0)
allWiggles
length(allWiggles_ori)
length(allWiggles_offset)
allWiggles_ori    = [0, 10:5:90];
allWiggles_offset = [0, 10:5:60];
allWiggleTypes = {'orientation', 'offset'};
allWiggleAngles = {allWiggles_ori, allWiggles_offset};
allWiggles = getWiggleList('orientation', allWiggles_ori, 'offset', allWiggles_offset);
allWiggles = getWiggleList(struct('orientation', allWiggles_ori, 'offset', allWiggles_offset));
length(allWiggles)
allFontNames
allWiggles = getWiggleList(struct('orientation', allWiggles_ori, 'offset', allWiggles_offset));
length(allWiggles)
allFontNames = cellfun(@(w) getSnakeWiggleStr(w), allWiggles, 'un', 0);
allFontNames
edit createNoisyLettersDatafile
edit measurePsychCurves_together.m
pwd
close all
clear all
medVisits_idxs
rp_i = 2
row_i = allData_par(rp_i,:);
size(row_i)
row_i
isnan(row_i{2})
row_i = allData_par(3,:);
row_i
row_i{2}
datestr(row_i{2})
datenum(row_i{2})
datenum(str2double(row_i{2}))
datestr(str2double(row_i{2}))
datenum('5/31/2010')
datenum('5/31/2010') - 40329
X = datenum('5/31/2010') - 40329
datestr(str2double(row_i{2})+X)
row_i
row_i{1}
str2double(row_i{1})
str2double(row_i{3})
(row_i{3})
row_i
txtData_par(3,:)
t = txtData_par(3,:);
t{1}
t{2}
t{3}
row_i
size(ndata_par)
size(allData_par)
size(txtData_par)
doc padarray
ndata_par2 = padarray(ndata_par, 1, 0, 'pre');
size(ndata_par2)
size(allData_par)
allData_par(3,:)
ndata_par2(3,:)
%-- 01/25/2015 04:38:00 AM --%
16*4
edit createNoisyLettersDatafile
createNoisyLettersDatafile
[fontSize, fontXheight, fontKheight] = getFontSize(fontNameStr, fontSizeStyle);  %#ok<NASGU>
createNoisyLettersDatafile
edit plotResults
log(20.6)
log10(20.6)
plotResults
edit plotResults
plotResults
letterOpt_use_ideal.fontName
letterOpt_use_ideal.fontName.wiggles
getSNRthreshold(allSNRs_test,  pCorr_ideal_i)
close all
%-- 01/25/2015 10:43:45 PM --%
medVisits_idxs{1}(1:10)
extractVisits
length(medVisits_colNames)
extractVisits
parCols_toRemove = cellfun(@(fld) any(strcmp(fld, parColsToIgnore)), parColsNewOrder);
nnz(parCols_toRemove)
parColIdxs = cellfun(@(fld) find(strcmp(fld, parColNames)), parColsNewOrder);
assert(isempty(setdiff(parColNames, parColsNewOrder)))
parCols_toRemove = cellfun(@(fld) any(strcmp(fld, parColsToIgnore)), parColsNewOrder);
parColsNewOrder(parCols_toRemove) = [];
assert(isempty(setdiff(parColNames, parColsNewOrder)))
assert(isempty(setdiff(parColsNewOrder, parColNames)))
parColIdxs = cellfun(@(fld) find(strcmp(fld, parColNames)), parColsNewOrder);
allData_new(1:5,1:5)
medCols_visit_i = cellfun(@(nm) sprintf('%s_%d', nm, visit_i), medColsNewOrder, 'un', 0);
allData_new(1, medVisitIdxs_remerge{visit_i}) = medCols_visit_i;
visit_i = 1
medCols_visit_i = cellfun(@(nm) sprintf('%s_%d', nm, visit_i), medColsNewOrder, 'un', 0);
allData_new(1, medVisitIdxs_remerge{visit_i}) = medCols_visit_i;
parColNames_orig = allData_par(1,:);
medColNames_orig = allData_med(1,:);
sort(medColNames_orig(4:end))
sort(parColNames_orig(4:end))
parHeaders_orig = allData_par(1,:);
medHeaders_orig = allData_med(1,:);
parColNames_orig = parColNames_orig(5,:);
medColNames_orig = medHeaders_orig(5,:);
setdiff(medColsNewOrder, medColNames_orig)
medColsNewOrder
extractVisits
idx_wide'
isequal(idx_wide', 1:length(idx_wide))
rp_i = 1
rp_i = 2
wide_idxs = visit_idxs_remerged{visit_id};
rawdata_orig = orig_row_i(idx_orig);
%                 ndata_orig = ndata_orig_row_i(idx_orig);
wide_row_idx = find(pat_id == allPatientIds_wide, 1);
doc xlsread
extractVisits
rp_i = 2217
rp_i = 6041
extractVisits
edit xlswrite.m
%-- 01/27/2015 03:45:39 AM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
edit recalculateAllTuningStats
recalculateAllTuningStats
sprintf('%.6f', now)
now
sprintf('%.6f', now)
recalculateAllTuningStats
allSpkStimHists.(psthType)
exist(histsFileName, 'file')
histsFileName = [CatV1Path 'MatLabDB_avi' filesep 'allSpkStimHists_' psthType '.mat'];
exist(histsFileName, 'file')
recalculateAllTuningStats
exist(ospWindowDataFile)
exist(bckgSpikes_file)
bckgSpikes_file = [CatV1Path 'MatLabDB_avi' filesep 'allBckgSpikes' curMatchDB('') '.mat'];
exist(bckgSpikes_file)
recalculateAllTuningStats
%-- 01/27/2015 12:20:49 PM --%
edit plotResults
plotResults
th_ideal
mean(th_ideal(:))
log10(th_ideal(:))
10^mean(log10(th_ideal(:)))
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
edit curDegreeOEmode.m
curDegreeOEmode
curDegreeOEmode('oe_diff')
curDegreeOEmode('aa')
profilePath('load', 'nyu')
cd(lettersPath)
edit measurePsychCurves_together
measurePsychCurves_together
strcmp(expName, 'Grouping')
measurePsychCurves_together
edit generateSnakesFonts.m
allLetterChars = 'CDHKNORSVZ'
lettersInDataset = arrayfun(@(let) any(allLetterChars == let), double('A':'Z'), 1, 0)
lettersInDataset = arrayfun(@(let) any(allLetterChars == let), double('A':'Z'))
measurePsychCurves_together
10:30:90
measurePsychCurves_together
measurePsychCurves_together(1)
eecdd
measurePsychCurves_together(1)
find(lettersInDataset)
binarySearch(find(lettersInDataset), response_label, 1, 0)
measurePsychCurves_together(1)
measurePsychCurves_together
targetDegPerLetter/degPerLetter
roundToNearest( targetDegPerLetter/degPerLetter, 1)
edit generateSnakesFonts.m
1/.019
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
edit generateSnakesFonts.m
generateSnakesFonts
profilePath('load', 'nyu')
profilePath('save', 'nyu')
generateSnakesFonts
profilePath('save', 'nyu')
generateSnakesFonts
64/55 * 11
generateSnakesFonts
12.8*2
generateSnakesFonts
32*4
generateSnakesFonts
rad2deg( (3/4)/24 )
generateSnakesFonts
25.7*2
generateSnakesFonts
(3/4)/24
rad2deg( (3/4)/24 )
2 / rad2deg( (3/4)/24 )
generateSnakesFonts
51.8/2
generateSnakesFonts
51.8/4
generateSnakesFonts
imageToScale([], 4)
generateSnakesFonts
createNoisyLettersDatafile
generateSnakesFonts
S_fonts
nNewFields
generateSnakesFonts
loadLetters('save')
S_fonts
S_fonts.SnakesN
edit addSummaryOfFontSizesToFontFile.m
addSummaryOfFontSizesToFontFile('SnakesN')
idx_sizes = [allS.fontsize];
idx_sizes = [allS.fontsize]
fontSizes_thisFont = [allS.fontsize];
[~, idx_sortBySize] = sort(fontSizes_thisFont);
allS = allS(idx_sortBySize);
addSummaryOfFontSizesToFontFile('SnakesN')
edit loadLetters
edit addSummaryOfFontSizesToFontFile.m
loadLetters('save')
S = loadLetters
edit measurePsychCurves_together
[a,b] = loadLetters('SnakesN', 'k128')
[a,b] = loadLetters('SnakesN', 'k128');
b
measurePsychCurves_together
edit measurePsychCurves_together
edit testIdealObserver.m
edit measurePsychCurves_together
measurePsychCurves_together
allParams{xi}
measurePsychCurves_together
[propCorrectLetter(snr_i)] = calcIdealPerformanceForNoisySet(noisySet);
measurePsychCurves_together
allSignals{xi}
size(allSignals{xi})
measurePsychCurves_together
inputNoiseMatrix = allNoiseImages{xi}(:,:, randi(nNoiseSamplesTot, 1, nSamplesTest));
nNoiseSamplesTot = size(allNoiseImages{xi}, 3);
inputNoiseMatrix = allNoiseImages{xi}(:,:, randi(nNoiseSamplesTot, 1, nSamplesTest));
inputSignalMatrix = cat(3, allSignals{xi}(noisySet.labels).image);
measurePsychCurves_together
nNoiseSamplesTot = size(allNoiseImages{xi}, 3);
measurePsychCurves_together
ideal_threshold = getSNRthreshold(idealObserverSNRs, propCorrectLetter);
[ideal_file_name, ideal_folder] = getIdealObserverFileName(fontName_i, nan, noisyLetterOpts);
measurePsychCurves_together
edit measurePsychCurves_together
edit plotResults
edit measurePsychCurves_together
measurePsychCurves_together
set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(allX_plot(curve_idxs{1}), .05, 1, 1), 'xtick', allX_plot(curve_idxs{1}), 'xticklabel', arrayfun(@(x) sprintf('%.1f', x), allX(curve_idxs{1}), 'un', 0));
allX_plot(curve_idxs{1})
set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(allX_plot(curve_idxs{1}), .05, 1, 1), 'xtick', allX_plot(curve_idxs{1}), 'xticklabel', arrayfun(@(x) sprintf('%.1f', x), allX(curve_idxs{1}), 'un', 0));
set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(allX_plot(curve_idxs{1}), .05, [], 1), 'xtick', allX_plot(curve_idxs{1}), 'xticklabel', arrayfun(@(x) sprintf('%.1f', x), allX(curve_idxs{1}), 'un', 0));
set(h_threshold_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(allX_plot(curve_idxs{1}), .05, [], 1), 'xtick', allX_plot(curve_idxs{1}), 'xticklabel', arrayfun(@(x) sprintf('%d', x), allX(curve_idxs{1}), 'un', 0));
measurePsychCurves_together
set(h_efficiency_ax, 'xscale', 'log', 'yscale', 'log', 'xlim', lims(allX_plot(curve_idxs{1}), .05, [], 1), 'xtick', allX_plot(curve_idxs{1}), 'xticklabel', arrayfun(@(x) sprintf('%d', x), allX(curve_idxs{1}), 'un', 0));
logspace(10, 90, 5)
logspace(log10(10), log10(90), 5)
logspace(log10(10), log10(90), 6)
logspace(log10(10), log10(90), 7)
roundToNearest( logspace(log10(10), log10(90), 7), 10)
roundToNearest( logspace(log10(10), log10(90), 6), 10)
roundToNearest( logspace(log10(10), log10(90), 5), 10)
roundToNearest( logspace(log10(10), log10(90), 5), 5)
roundToNearest( logspace(log10(10), log10(90), 6), 5)
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit generateSnakesFonts
edit measurePsychCurves_together
measurePsychCurves_together
edit generateSnakesFonts
generateSnakesFonts
edit generateSnakesFonts
generateSnakesFonts
addSummaryOfFontSizesToFontFile
loadLetters('save')
S_fonts
measurePsychCurves_together
[curve_idxs{:}]
measurePsychCurves_together
%-- 02/04/2015 02:14:44 AM --%
[a,b] = loadLetters('SnakesN', 'k32');
b
edit createNoisyLettersDatafile
find(b.orientations == 15)
b.size_rotated
b.size_rotated(4,:)
64-39
log2([64, 128])
log2([64, 96, 128])
8:8:128
16:16:128
32:32:128
96/2
[a,s] = loadLetters('SnakesN', 'k64');
s
s.size_rotated(4,:)
128-78
edit generateSnakesFonts
polyval(p, x_new)
generateSnakesFonts
imageToScale([], 4)
generateSnakesFonts
imageToScale([], 4)
createFontSizesFile
[a,s] = loadLetters('SnakesN', 'k48');
s
s.size_rotated(4,:)
96-58
[a,s] = loadLetters('SnakesN', 'k64');
s
s.orientations == 20
find(s.orientations == 20)
s.size_rotated(5,:)
128-80
18*2
20*2
length([0:2:40])
21*21*21
createNoisyLettersDatafile
634*13*120
(634*13*120)/1024^2
[a,s] = loadLetters('SnakesN', 'k48');
s.size_rotated(5,:)
96-60
18*1.5
length(0:28)
[a,s] = loadLetters('SnakesN', 'k32');
s.size_rotated(5,:)
39-64
length(0:29)
createNoisyLettersDatafile
imageToScale([], 1)
imageToScale([], 2)
edit runIdealObserverTests.m
edit createNoisyLettersDatafile
runIdealObserverTests
all_lower_snrs = snr-0.5 : -.5 : lowest_snr;
snr_chk = all_lower_snrs
runIdealObserverTests
%-- 02/04/2015 11:25:10 PM --%
%-- 02/05/2015 11:26:47 PM --%
profilePath('load', 'CatV1Exp')
cd(lettersPath)
cd(CatV1Path)
curCmpType('')
curCmpType('phase')
edit generateGratingComparisonsDatafile.m
curGratingType
curGratingType(2)
gen3
edit generateGratingCellsDatafile.m
curSubtractSpont
curSubtractSpont(0)
gcmp
which shiftMtx
mex shiftMtx.c
mex -setup
mex shiftMtx.c
which shiftMtx
gcmp
printPhaseTuningComparisons
curGratingType(1)
edit generateGratingComparisonsDatafile.m
edit tmp_testJackknifeStdErr
edit calcDegreeOfTuningStats.m
tmp_testJackknifeStdErr
jack_std = getJackknifeStdErr(ccs_jacks, cc_i);
tmp_testJackknifeStdErr
figure
plot(ccs, jack_stds)
plot(ccs, jack_stds, '.')
tmp_testJackknifeStdErr
plot(ccs, jack_stds, 'o')
plot(abs(ccs), jack_stds, 'o')
[cc, p] = corr(abs(ccs), jack_stds)
[cc, p] = corr(abs(ccs(:)), jack_stds(:))
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'spearman')
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'spearman')
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'pearson')
xlabel('abs(cc)'); ylabel('jackknife std err')
tmp_testJackknifeStdErr
figure
plot(abs(ccs), jack_stds, 'o')
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'pearson')
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'spearman')
tmp_testJackknifeStdErr
plot(abs(ccs), jack_stds, 'o')
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'spearman')
tmp_testJackknifeStdErr
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'spearman')
plot(abs(ccs), jack_stds, 'o')
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'spearman')
[cc, p] = corr(abs(ccs(:)), jack_stds(:), 'type', 'pearson')
edit generateGratingComparisonsDatafile.m
edit generateGratingCellsDatafile.m
curGratingType
gc
curTimeWindow
curGratingType(2)
gc
size(R_full)
edit getGratingStimType
Gid
siteDataFor(Gid)
edit tmp_testJackknifeStdErr
m = 3; n = 5
idx
m = 5
n = 5
idx
n = 4
n = 5
idxs_n
reshape( idxs_n(eye(n) == 0), [n-1, n])
(eye(n) == 0)
reshape( idxs_n(eye(n) == 0), [n, n-1])
reshape( idxs_n(eye(n) == 0), [n-1, n])
sum(sum(reshape( idxs_n(eye(n) == 0), [n-1, n])))
sum(sum(idx_n))
sum(sum(idxs_n))
X = [1:10];
jackknifeSelect(X)
X = [10:20];
jackknifeSelect(X)
doc jackknife
load lawdata
size(lsat)
size(gpa)
plot(lsat, gpa, 'o')
edit recalculateAllTuningStats
sprintf('%.6f', now)
recalculateAllTuningStats
recalculateAllTuningStats('f', 1, 1)
figure
imagesc(sum(sum(R_full,3),4))
axis equal
axis equal tight
imagesc(phaseTC_atPref_trials)
ais equal tight
axis equal tight
colorbar
phaseTC_atPref_trials = squeeze( R_full(ori_pref_idx, spf_pref_idx, :, :) )';
assert(isequal(size(phaseTC_atPref_trials), [nTrials, nPh]));
phaseTC_atPref = mean( phaseTC_atPref_trials, 1);
F1oDC = getF1oDC(phs, phaseTC_atPref(:), 360);
phaseTC_atPref_jacks = arrayfun(@(i) mean(  phaseTC_atPref_trials(setdiff(1:nTrials, i), :)  ,1), 1:nTrials, 'un', 0);
cat(1, phaseTC_atPref_jacks{:})
doc mat2cell
which jackknifeAverageTrials.m
phaseTC_atPref_jacks2 = jackknifeAverageTrials( phaseTC_atPref_trials );
jackSelectIdxs_C{nTrials} = mat2cell(idxs_n, n-1, ones(1, n));
jackSelectIdxs_C{nTrials} = mat2cell(idxs_n, nTrials-1, ones(1, nTrials));
jackSelectIdxs_C{nTrials}
jackSelectIdxs_C{nTrials}{1}
jackSelectIdxs_C{nTrials}{2}
jackSelectIdxs_C{nTrials}{3}
dbquit
phaseTC_atPref_jacks2 = jackknifeAverageTrials( phaseTC_atPref_trials );
X_jack_C = cellfun(@(trial_idxs) mean(X(trial_idxs, :),1), idxsSelect_C, 'un', 0);
dbquit
phaseTC_atPref_jacks2 = jackknifeAverageTrials( phaseTC_atPref_trials );
isequal(phaseTC_atPref_jacks, phaseTC_atPref_jacks2)
phaseTC_atPref_jacks = arrayfun(@(i) mean(  phaseTC_atPref_trials(setdiff(1:nTrials, i), :)  ,1), 1:nTrials, 'un', 0);
phaseTC_atPref_jacks2 = jackknifeAverageTrials( phaseTC_atPref_trials );
isequal(phaseTC_atPref_jacks, phaseTC_atPref_jacks2)
R_ori_tr = reshape(mean( R_full_prefSpf, 3), [nDir, nTrials]);
r_k_dir = mean(R_ori_tr, 2);
r_k_dir_std = std(R_ori_tr, [], 2);
recalculateAllTuningStats('f', 1, 1)
clear all
edit recalculateAllTuningStats
recalculateAllTuningStats('f', 1, 1)
tmp_testJackknifeStdErr
curGratingType
curGratingType(2)
edit generateGratingCellsDatafile.m
generateGratingCellsDatafile
edit generateGratingComparisonsDatafile.m
gp
gcmp
allCells(3)
size(allCells(3).R_full)
size(allCells(10).R_full)
size(allCells(20).R_full)
size(allCells(40).R_full)
size(allCells(50).R_full)
ci = 50
R_full = allCells(ci).R_full;
[n_ori, n_spf, n_ph, n_trials] = size(R_full);
R_full_stim_ph_trial = reshape(R_full, [n_ori*n_spf, n_ph, n_trials]);
gcmp
R_full_jackknifeTrials = jackknifeAverageTrials(R_full_stim_ph_trial, 3);
allCells(ci).R_stim_jackTrials = R_full_jackknifeTrials;
gcmp
pairInfo.Cell1.
pairInfo.Cell1
pairInfo.Cell1.R_stim_jackTrials
gcmp
R_full_jackknifeTrials
gcmp
profile on
gcmp
profile viewer
gcmp
cellfun(@(x) x(1,:), R_full_jackknifeTrials_2, 'un', 0);
cellfun(@(x) x(1,:), R_full_jackknifeTrials_2, 'un', 0)
R_full_jackknifeTrials2(jj,:) = cellfun(@(x) x(jj,:), R_full_jackknifeTrials_2, 'un', 0);
gcmp
isequal(R_full_jackknifeTrials, R_full_jackknifeTrials2)
profile on
gcmp
profile viewer
gcmp
edit runIdealObserverTests.m
edit generateGratingComparisonsDatafile.m
curPhaseOEmode
curPhaseOEmode('oe_diff_k12')
curPhaseOEmode('aa')
gcmp
cc_jackknives = cellfun(@pearsonFunc, ph1_jackknives, ph2_jackknives)
cc_jackknives = cellfun(pearsonFunc, ph1_jackknives, ph2_jackknives)
cellfun(pearsonFunc, ph1_jackknives, ph2_jackknives)
phaseTuningStats.cc
cat(1, ph1_jackknives{:))
cat(1, ph1_jackknives{:})
mean( cat(1, ph1_jackknives{:}) )
ph1'
figure
plot( mean( cat(1, ph1_jackknives{:}) ), ph1, '.')
plot( mean( cat(1, ph1_jackknives{:}) ), ph1, 'o')
which pearsonR
edit pearsonR
edit pearsonR.c
edit pearsn.c
mex pearsonR.c pearsn.c erfcc.c betai.c betacf.c gammln.c nrutil.c
dphi = bestCircShift_Matlab(phs, ph1, ph2, [], opt.usePosNegDphi);
dphi_jackknives = cellfun(@(x1, x2) bestCircShift_Matlab(phs, x1, x2, [], opt.usePosNegDphi), ph1_jackknives, ph2_jackknives);
cellfun(@(x1, x2) bestCircShift_Matlab(phs, x1, x2, [], opt.usePosNegDphi), ph1_jackknives, ph2_jackknives)
dbquit
dphi_jackknives = cellfun(@(x1, x2) bestCircShift_Matlab(phs, x1(:), x2(:), [], opt.usePosNegDphi), ph1_jackknives, ph2_jackknives);
cellfun(@(x1, x2) bestCircShift_Matlab(phs, x1(:), x2(:), [], opt.usePosNegDphi), ph1_jackknives, ph2_jackknives)
gcmp
X = mean(cat(3, R_full_jackknifeTrials_stim{:}),3)
global X
X = mean(cat(3, R_full_jackknifeTrials_stim{:}),3)
global Xm
Xm = mean(R_full_stim_ph_trial, 3);
plot(Xm(:), X(:), 'o')
Xm*54/55 - X
max(max(abs(Xm*54/55 - X)))
Xm(1:5)/X(1:5)
Xm(1:5)./X(1:5)
max(max(abs(Xm - X)))
R_full_jackknifeTrials
X = mean(cat(3, R_full_jackknifeTrials_stim{:,:}),3);
size(X)
plot(Xm(:), X(:), 'o')
X
Xm
X
Xm
X
Xm
cat(1, ph1_jackknives{:})
mean(cat(1, ph1_jackknives{:}), 1)
ph1
ph1'
gcmp
figure
subplot(1,2,1)
imagesc(squeeze(Cell1.R))
subplot(1,2,2)
Cell1.R_stim_jackTrials
X = mean(cat(3, R_full_jackknifeTrials_stim{:,:}),3);
global
global X
X = mean(cat(3, R_full_jackknifeTrials_stim{:,:}),3);
imagesc(X)
X = mean(cat(3, Cell1.R_stim_jackTrials{:,:}),3);
imagesc(X)
X
plot(squeeze(Cell1.R(1,7,:)))
Cell1.R_stim_jackTrials{7,:}
cat(2, Cell1.R_stim_jackTrials{7,:})
cat(1, Cell1.R_stim_jackTrials{7,:})
mean(cat(1, Cell1.R_stim_jackTrials{7,:}),1)
plot( mean(cat(1, Cell1.R_stim_jackTrials{7,:}),1) )
plot(squeeze(Cell1.R(1,7,:)))
curGratingType(1)
gen3
ph1'
ph1_jackknives
mean(cat(1, ph1_jackknives{:}))
phaseTuningStats.cc_jackStd = jackknifeStdErr(phaseTuningStats.cc, cc_jackknives);
phaseTuningStats.cc_jackStd = jackknifeStdErr(cc_jackknives, phaseTuningStats.cc)
dphi_jackknives = cellfun(@(x1, x2) bestCircShift_Matlab(phs, x1(:), x2(:), [], opt.usePosNegDphi), ph1_jackknives, ph2_jackknives);
phaseTuningStats.dphi_jackStd = jackknifeStdErr(dphi_jackknives, dphi);
dphi = bestCircShift_Matlab(phs, ph1, ph2, [], opt.usePosNegDphi);
dphi_jackknives = cellfun(@(x1, x2) bestCircShift_Matlab(phs, x1(:), x2(:), [], opt.usePosNegDphi), ph1_jackknives, ph2_jackknives);
phaseTuningStats.dphi_jackStd = jackknifeStdErr(dphi_jackknives, dphi);
69-23+1
%-- 02/09/2015 10:08:52 AM --%
edit runIdealObserverTests.m
%-- 02/09/2015 09:14:46 PM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
edit generateGratingComparisonsDatafile.m
curPairTypes
curPairTypes('')
edit curPairTypes.m
edit generateGratingPairsDatafile.m
gp
Bmm_pairs_later   = [ones(nMUsLater,1)* muIdx,  muIdxsOfLaterSites  ];
Bmm_Pairs_i(Bmm_idx : Bmm_idx+nPairs-1, :) = [Bmm_pairs_earlier; Bmm_pairs_later];
Bmm_idx = Bmm_idx + nPairs;
Bmm_Pairs_i(Bmm_idx : Bmm_idx+nPairs-1, :) = [Bcm_pairs_earlier; Bmm_pairs_later];
nPairs = nMUsLater;
Bmm_pairs_later   = [ones(nMUsLater,1)* muIdx,  muIdxsOfLaterSites  ];
Bmm_Pairs_i(Bmm_idx : Bmm_idx+nPairs-1, :) = [Bmm_pairs_later];
Bmm_idx = Bmm_idx + nPairs;
gp
colobar
colorbar
h_col = colobar;
h_col = colorbar;
get(h_col, 'yTick')
struct2cell(tk)
fieldnames(tk)
cell2mat({1, 2, 3})
colormap(jet(10))
colormap(jet(20))
colormap(jet(30))
figure
a = colormap;
size(a)
colormap(jet)
h_col = colorbar;
colormap(jet(64))
[Wcc_idxs, Wcm_idxs, Bcc_idxs, Bcm_idxs, Bmm_idxs] = generateListOfCellPairs(cellinfo, 1, subRanges, 'originalOrder');
edit generateGratingCellsDatafile.m
gc
curGratingType(1); gc; curGratingType(2); gc;
edit recalculateAllTuningStats
getOspDataForPsthWindow('save');
curGratingType(1);
gp
edit generateGratingComparisonsDatafile.m
gp
curPairTypes
curPairTypes('')
curPairTypes({'Wcc', 'Wscc', 'Bcc', 'Bmm'})
curPairTypes
curPairTypes({'Wcc', 'Wcm', 'Bcc', 'Bcm', 'Bmm', 'Wscc'})
curPairTypes
edit curPairTypes.m
curPairTypes
gcmp
jackStd_flds = {iff(doCC, {'cc_jackStd', []}, {}), iff(doDPhi, {'dphi_jackStd', []}, {}) }
global jackStd_flds
jackStd_flds = {iff(doCC, {'cc_jackStd', []}, {}), iff(doDPhi, {'dphi_jackStd', []}, {}) }
jackStd_Flds{:}
jackStd_flds{:}
[jackStd_flds{:}]
jackStd_flds = {iff(doCC, {'cc_jackStd'}, {}), iff(doDPhi, {'dphi_jackStd'}, {}) };
jackStd_flds
[jackStd_flds{:}]
cellfun(@(s) [s '_jack'], measure_flds, 'un', 0)
allFields = [measure_flds, F1oDC_flds, frac1ofMax_flds, ccMaxDphi_flds, lowerSumPhs_flds, ptcOEcorr_flds, jackStd_flds];
blankPhaseTuningStatStruct = structFromFieldNames(allFields, nan);
jackStd_flds = cellfun(@(s) [s '_jack'], measure_flds, 'un', 0);
allFields = [measure_flds, F1oDC_flds, frac1ofMax_flds, ccMaxDphi_flds, lowerSumPhs_flds, ptcOEcorr_flds, jackStd_flds];
blankPhaseTuningStatStruct = structFromFieldNames(allFields, nan);
global jackStd_flds
jackStd_flds = cellfun(@(s) [s '_jack'], measure_flds, 'un', 0);
allFields = [measure_flds, F1oDC_flds, frac1ofMax_flds, ccMaxDphi_flds, lowerSumPhs_flds, ptcOEcorr_flds, jackStd_flds];
blankPhaseTuningStatStruct = structFromFieldNames(allFields, nan)
gcmp
curGratingType(2);
gcmp
gp
gcmp
whos
who
whos
166725449/1024^2
whos
317874121/1024^2
curPhaseOEmode
curPhaseOEmode('oe_diff_k12')
gcmp
imagesc(squeeze(R_full_stim_ph_trial(1,:,:)))
imagesc(squeeze(R_full_stim_ph_trial(2,:,:)))
imagesc(squeeze(R_full_stim_ph_trial(3,:,:)))
imagesc(squeeze(R_full_stim_ph_trial(4,:,:)))
imagesc(squeeze(R_full_stim_ph_trial(5,:,:)))
imagesc(squeeze(R_full_stim_ph_trial(6,:,:)))
imagesc(squeeze(sum(R_full_stim_ph_trial(:,:,:),1)))
mean(  R_full_stim_ph_trial(:,:,end-1:end) )
R_full_stim_ph_trial(:,:,end-1:end)
mean(  R_full_stim_ph_trial(:,:,end-1:end), 3 )
R_full_stim_ph_trial(:,:,end-1) = mean(  R_full_stim_ph_trial(:,:,end-1:end), 3 );
R_full_stim_ph_trial(:,:,end-1)
R_full_stim_ph_trial(:,:,end)
R_full_stim_ph_trial(:,:,end) = [];
size(R_full_stim_ph_trial )
gcmp
R_full_jackknifeTrials = cell(n_stim, n_trials/2, 2);
for jj = 1:n_stim
R_full_jackknifeTrials(jj,:,1) = cellfun(@(x) x(jj,:), R_full_jackknifeTrials_stim_odd, 'un', 0);
R_full_jackknifeTrials(jj,:,2) = cellfun(@(x) x(jj,:), R_full_jackknifeTrials_stim_even, 'un', 0);
end
gcmp
s = whos('allCel*')
whos('allCel*')
317331177/1024^2
edit generateGratingComparisonsDatafile.m
curGratingType(1)
edit generateGratingCellsDatafile.m
edit generateGratingComparisonsDatafile.m
gcmp
whos('allCel*')
217350527/1024^2
gcmp
curDegreeOEmode
curPhaseOEmode
curPhaseOEmode('aa')
gcmp
s = whos('allCel*')
whos('allCel*')
459408911/1024^2
gcmp
whos('allCel*')
520487951/1024^2
tic; S1 = load(getFileName('osps', filename_ext)); toc;
edit generateGratingCellsDatafile.m
edit generateGratingComparisonsDatafile.m
edit generateGratingCellsDatafile.m
curGratingType(1)
gc
S_mid
S_mid.allMIDs
S_mid.allMIDs(1)
S_mid.allMIDs(2)
S_mid.allMIDs(3)
S_mid.allMIDs(4)
edit gatherMIDs
gatherMIDs
experimentDBPath = '/media/avi/Storage/ExperimentDB';
baseDir = [experimentDBPath filesep 'MID' filesep];
name = [baseDir Cells filesep 'MID_' cellName_detailed '.mat'];
name = [baseDir 'Cells' filesep 'MID_' cellName_detailed '.mat'];
gatherMIDs
S
S.allMIDs(1)
S.allMIDs_even(1)
S.allMIDs_even(2)
S.allMIDs_even(10)
S.allMIDs_even(14)
S.allMIDs_even(17)
S.allMIDs_even(30)
S.allMIDs_even(50)
edit CatV1Path.m
gatherMIDs
S
S.allMIDs(4)
gatherMIDs
length(S_mid.v_MID)
Si.MID_jacks = single( S_mid.v_MID{1} );
gatherMIDs
S.allMIDs(4)
S.allMIDs(10)
S.allMIDs(30)
S.allMIDs_even(30)
edit generateGratingCellsDatafile.m
gc
CatV1Path
gc
MID_data
MID_data.MID
MID_data.MID_even
STA_1 = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA'})
[fileId_i, message] = fopen(movieFileName, 'r');  error(message);
movieFileName
[fileId_i, message] = fopen(lower(movieFileName), 'r');  error(message);
exist(movieFileName, 'file')
movieFileName = [fgMoviePath, lower(uMovieFileNames{mi})];
exist(movieFileName, 'file')
[fileId_i, message] = fopen(lower(movieFileName), 'r');  error(message);
[fileId_i, message] = fopen(movieFileName, 'r');  error(message);
fopen
fopen('all')
STA_1 = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA'})
STA_1 = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA'});
size(STA_1)
STA_1 = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA_even'});
STA_1 = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA_oe'});
size(STA_1)
[STA_aa, STA_oe] = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA', 'STA_oe'});
STA = single(STA_aa);
STA_oe = single(STA_oe);
STA_odd = STA_oe(:,:,1); STA_even = STA_oe(:,:,2);
STA_all = (STA_odd + STA_even)/2;
max(abs(STA(:)-STA_all(:)))
[r_oe_STA, pval_oe_STA] = pearsonR(STA_odd, STA_even);
nTrials = 16
(1:nTrials)
floor((1:nTrials)/3)
floor((1:nTrials)/4)
floor(([1:nTrials]-1)/4)
floor(([1:nTrials]-1)/4)+1
nTrials = 12; floor(([1:nTrials]-1)/4)+1
mod([1:20], 4)
(mod([1:20], 4)+1)==1
(mod([1:20], 4)+1)
(mod([1:20]-1, 4)+1)
jack_idxs = arrayfun(@(i) find( (mod([1:nTrials]-1, nJackSegments)+1) == i), 'un', 0)
nJackSegments = 4;
jack_idxs = arrayfun(@(i) find( (mod([1:nTrials]-1, nJackSegments)+1) == i), 1:nJackSegments, 'un', 0)
jack_idxs{:}
nTrials = 10
jack_idxs = arrayfun(@(i) find( (mod([1:nTrials]-1, nJackSegments)+1) == i), 1:nJackSegments, 'un', 0); jack_idxs{:}
jack_idxs{:}
segment_idxs = arrayfun(@(i) find( (mod([1:nTrials]-1, nJackSegments)+1) == i), 1:nJackSegments, 'un', 0);
jack_idxs = arrayfun(@(i) [segment_idxs{ setdiff(1:nJackSegments, i) }], 1:nJackSegments, 'un', 0);
segment_idxs{:}
jack_idxs{:}
jack_idxs = arrayfun(@(i) [sort(segment_idxs{ setdiff(1:nJackSegments, i)) }], 1:nJackSegments, 'un', 0);
jack_idxs = arrayfun(@(i) sort( [segment_idxs{ setdiff(1:nJackSegments, i) }] ), 1:nJackSegments, 'un', 0);
jack_idxs{1}
jack_idxs{:}
nTrials = 16
nTrials = 4
segment_idxs
jack_idxs{:}
nTrials = 16
segment_idxs{:}
jack_idxs{:}
S = load('cellsGroups_GLFcuw8_movie_fg.mat');
S
S.movieGroups_fg(1)
varBreakdown( {S.movieGroups_fg.stimType} )
gc
[STA_aa_jack, STA_oe_jack] = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA_jack', 'STA_oe_jack'});
size(r_full)
frameIds = getStimulusFrameSequence(Gid);
numel(r_full)
figure
max(frameIds)
plot(frameIds)
[frameStimIds, uOri, uSp, uPh, stim_RepeatId] = getStimulusFrameSequence(Gid);
plot(stim_RepeatId)
Gid
mid_generateSpikeFile(1648, 1, 'best', 'odd', 'all')
mid_generateSpikeFile(1648, 1, 'best', 'odd', '1rep')
mid_generateSpikeFile(1648, 1, 'best', 'odd', '1rep');
edit mid_generateSpikeFile
frameIds = getStimulusFrameSequence(Gid);
i = randperm(10)
j = 1:10
j(i)
i(j)
i = randperm(20)
j = 1:20
i(j)
j(i)
length(unique(frameIds))
frameIds = getStimulusFrameSequence(Gid);
frameIds2 = getStimulusFrameSequence(Gid, 'OSP');
isequal(frameIds, frameIds2)
frameIds2 = getStimulusFrameSequence(Gid, 'OSPt');
isequal(frameIds, frameIds2)
length(unique(frameIds2))
edit generateGratingCellsDatafile.m
gc
firstFields = {'l_bins', 'r_bins', 'windowProfile'}; lastFields = {'STA', 'STA_oe', 'STA_jack', 'STA_odd_jack', 'STA_even_jack', 'meanRate', clustIdFld{:}, 'lastUpdated'}; %#ok<CCAT>
otherFields = setdiff(fieldnames(s), [firstFields, lastFields]);
fieldOrder = [firstFields, sort(otherFields(:)'), lastFields]; %#ok<TRSRT>
s = orderfields(s, fieldOrder);
gc
j = s.STA_jack{w_idx};
size(j)
figure
imagesc(tileImages(j))
colormap(gray)
image square
colormap(gray)
imagesc(tileImages(j))
axis square
edit generateGratingCellsDatafile.m
gc
r_full = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, 'osp_full');
jj = 1
tril(ccs, 1)
triu(ccs, 1)
triu(ones(4), 1)
find( triu(ones(4), 1) )
ccs ( find( triu(ones(4), 1) ) )
profile on
profile viewer
profile on
profile viewer
gc
mean_jack_STA_ccs(1:5, :)
profile on
profile viewer
profile off
gc
S = load('cellsGroups_GLFcuw8_movie_fg.mat');
varBreakdown( {S.movieGroups_fg.stimType} )
gc
Gid = 4470
nJackSegments_STA = 4; jackknifeMethods_STA = {'stimuli', 'stimuli_and_trials', 'trials'};
r_full = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, 'osp_full');
jj = 1
size(r_full)
jj = 2
jj = 3
mean_jack_STA_ccs(cell_idx, :)
STA_jacks = getJackknifedSTA(r_full, Gid, 'odd', nJackSegments_STA, jackknifeMethods_STA{jj});
jackIdxs{:}
gc
meanCC = mean(ccs_offDiag);
gc
size(r_full)
frameIds = reshape(frameIds, [nOri*nSpf*nPh, nTrials_orig]);
frameIds = getStimulusFrameSequence(Gid, 'OSPt');
if any(strcmp(trial_mode, {'odd', 'even'}))
frameIds = reshape(frameIds, [nOri*nSpf*nPh, nTrials_orig]);
frameIds = frameIds(trial_idxs_use, :);
frameIds = frameIds(:);
end
frameIds = getStimulusFrameSequence(Gid, 'OSPt');
frameIds = reshape(frameIds, [nOri*nSpf*nPh, nTrials_orig]);
frameIds = frameIds(:,trial_idxs_use);
frameIds = frameIds(:);
edit generateGratingCellsDatafile.m
gc
edit generateGratingCellsDatafile.m
gc
figure
plot(mean_jack_STA_ccs(:,1), mean_jack_STA_ccs(:,2))
plot(mean_jack_STA_ccs(:,1), mean_jack_STA_ccs(:,2), ')
plot(mean_jack_STA_ccs(:,1), mean_jack_STA_ccs(:,2), '.')
mean(mean_jack_STA_ccs, 1)
nanmean(mean_jack_STA_ccs, 1)
nanstd(mean_jack_STA_ccs, 1)
plot(mean_jack_STA_ccs(:,1), mean_jack_STA_ccs(:,2), '.')
axis equal
axis square
hold on
fplot(@(x) x, xlim, 'r:')
fplot(@(x) x, xlim, 'r-')
plot(mean_jack_STA_ccs(:,2), mean_jack_STA_ccs(:,3), '.')
plot(mean_jack_STA_ccs(:,2), mean_jack_STA_ccs(:,3), 'r.')
plot(mean_jack_STA_ccs(:,2), mean_jack_STA_ccs(:,3), 'go')
save('STA_jacks_aa.mat', 'STA_jacks', 'mean_jack_STA_ccs')
SS = load('STA_jacks_aa.mat')
save('STA_jacks_aa.mat', 'allSTAs_jacks', 'mean_jack_STA_ccs')
save('STA_jacks_aa.mat', 'allSTAs_jacks', 'mean_jack_STA_ccs', '-v6')
SS = load('STA_jacks_aa.mat')
gc
size(r)
size(r_jack_i)
nStims
nStims*4/5
nStims*3/4
uStimIds( jackIdxs{jack_i} );
max( uStimIds( jackIdxs{jack_i} ) )
[frameIds, ~, ~, ~, stimTrialId] = getStimulusFrameSequence(Gid, 'OSP');
max(frameIds)
[frameIds, ~, ~, ~, stimTrialId] = getStimulusFrameSequence(Gid, 'OSP');
frameIds = reshape(frameIds, [nOri*nSpf*nPh, nTrials_orig]);
max(frameIds(:))
frameIds = bsxfun(@plus, frameIds, [1:length(trial_idxs_use)]);
frameIds = frameIds(:,trial_idxs_use);
frameIds = bsxfun(@plus, frameIds, [1:length(trial_idxs_use)]);
max(frameIds(:))
[frameIds, ~, ~, ~, stimTrialId] = getStimulusFrameSequence(Gid, 'OSP');
frameIds = reshape(frameIds, [nOri*nSpf*nPh, nTrials_orig]);
frameIds = frameIds(:,trial_idxs_use);
frameIds = bsxfun(@plus, frameIds, [0:length(trial_idxs_use)-1]*(nOri*nSpf*nPh) );
max(frameIds(:))
gc
mean(mean_jack_STA_ccs, 1)
nanstd(mean_jack_STA_ccs, 1)
nanmean(mean_jack_STA_ccs, 1)
clf
plot(mean_jack_STA_ccs(:,1), mean_jack_STA_ccs(:,2), '.')
hold on
axis square
fplot(@(x) x, xlim, 'r-')
plot(mean_jack_STA_ccs(:,1).^2, mean_jack_STA_ccs(:,2).^2, '.')
clf; plot(mean_jack_STA_ccs(:,2).^2, mean_jack_STA_ccs(:,3).^2, '.')
axis square
hold on
fplot(@(x) x, xlim, 'r-')
clf
plot(mean_jack_STA_ccs(:,1).^2, mean_jack_STA_ccs(:,2).^2, '.')
axis square
plot(mean_jack_STA_ccs(:,2).^2, mean_jack_STA_ccs(:,3).^2, '.')
axis square
edit generateGratingCellsDatafile.m
varBreakdown( {S.movieGroups_fg.stimType} )
switchh(4, {[4, 16], 10}, [4, 5])
switchh(4, [4, 16, 10], [4, 4, 5])
switchh(10, [4, 16, 10], [4, 4, 5])
switchh(16, [4, 16, 10], [4, 4, 5])
switchh(14, [4, 16, 10], [4, 4, 5])
nTrials = 8; floor([1:2:nTrials]/2)
nTrials = 8; floor([1:1:nTrials]/2)
nTrials = 8; ceil([1:1:nTrials]/2)
nTrials = 8; odd( ceil([1:1:nTrials]/2) )
gc
idx_order1(1:10, :)
figure
plot(uStimIds)
plot(uStimIds, '.')
nTrials = 8;
plot(uStimIds, '.')
idx_alternating(1:12, :)
gc
mean(mean_jack_STA_ccs, 1)
nanmean(mean_jack_STA_ccs, 1)'
nanmean(mean_jack_STA_ccs, 1)
plot(mean_jack_STA_ccs(:,1).^2, mean_jack_STA_ccs(:,2).^2, '.')
axis square; hold on; fplot(@(x) x, xlim, 'r-')
plot(mean_jack_STA_ccs(:,3).^2, mean_jack_STA_ccs(:,2).^2, '.')
clf; plot(mean_jack_STA_ccs(:,3).^2, mean_jack_STA_ccs(:,2).^2, '.')
axis square; hold on; fplot(@(x) x, xlim, 'r-')
clf; plot(mean_jack_STA_ccs(:,3).^2, mean_jack_STA_ccs(:,2).^2, '.')
clf; plot(mean_jack_STA_ccs(:,2).^2, mean_jack_STA_ccs(:,4).^2, '.')
axis square; hold on; fplot(@(x) x, xlim, 'r-')
clf; plot(mean_jack_STA_ccs(:,4).^2, mean_jack_STA_ccs(:,2).^2, '.')
axis square; hold on; fplot(@(x) x, xlim, 'r-')
mean_jack_STA_ccs
mean_jack_STA_ccs(:,4) == 0
find(mean_jack_STA_ccs(:,4) == 0)
mean_jack_STA_ccs(:,4)
mean_jack_STA_ccs
mean_jack_STA_ccs( isnan(mean_jack_STA_ccs(:,1)) ,4) = nan
nanmean(mean_jack_STA_ccs, 1)
clf; plot(mean_jack_STA_ccs(:,2).^2, mean_jack_STA_ccs(:,3).^2, '.')
axis square; hold on; fplot(@(x) x, xlim, 'r-')
edit gcmp
curPairTypes
edit gcmp
edit generateGratingComparisonsDatafile.m
gcmp
lims([groupCellCount; cellCellIds])
diff( lims([groupCellCount; cellCellIds]) )
maxNCell = diff(lims([groupCellCount; cellCellIds]))+1;
gcmp
edit generateGratingCellsDatafile.m
edit mid_findMostInfoDim
Cell1.STAdata
Cell2.STAdata
edit getOspDataForPsthWindow.m
dbquit
gc
s = siteDataFor(Gid)
getGratingStimType(Gid)
edit getGratingStimType
stimInfo = getGratingStimType(Gid);
nJackSegments_STA = switchh(stimInfo.nTrials, [4, 16,   10], [4, 4,  5]);
r_full = decompress (s.osp_full{w_idx});
s.STA_jack{w_idx} = getJackknifedSTA(r_full, Gid, 'all', nJackSegments_STA, jackknifeMethod_STA);
gc
s.STA_jack{w_idx}
size(s.STA_jack{w_idx})
figure
imagesc(tileImages(s.s.STA_jack{w_idx}))
imagesc(tileImages(s.STA_jack{w_idx}))
colormap(gray)
V = reshape(s.STA_jack{w_idx}, [128*128, 4]);
size(s.STA_jack{w_idx})
V = reshape(s.STA_jack{w_idx}, [128*128, 5]);
pearsonRm(V)
figure
subplot(1,2,1);
imagesc ( mean(s.STA_jack{w_idx}, 3) )
subplot(1,2,2);
imagesc ( STA_aa )
figure
imagesc ( mean(STA_oe,3) )
imagesc ( STA_aa )
colorbar
imagesc ( mean(STA_oe,3) ); colorbar;
imagesc ( STA_aa ); colorbar;
colorbar
gc
figure
imagesc ( STA_aa ); colorbar;
imagesc ( mean(s.STA_jack{w_idx}, 3) )
1000/30
10000*30
1e6/(10000*30)
3*61/12
4*61/12
sqrt(2)
1/sqrt(2)
.7*.7*2
.6*700
700+420
(700+420)*5
4*4*30
(1e6)^3
(1e6)^3 / 480
((1e6)^3 / 480)/1024^4
((1e6)^3 / 480)/1024^5
((1e6)^3 / 480)
edit mid_findMostInfoDim
edit runIdealObserverTests.m
%-- 02/17/2015 08:27:18 PM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
gc
profilePath('save', 'CatV1Exp')
profilePath('load', 'CatV1Exp')
gc
edit gatherMIDs.m
edit compareDownSampNrep.m
compareDownSampNrep
dirName = [experimentDBPath 'MID' filesep 'Cells' filesep];
compareDownSampNrep
sscanf(fnames(i).name, 'MID_Group_%d__cell_%d_%drep_d%d')
fnames(i).name
compareDownSampNrep
fnames(1:20).name
any(allGids)
compareDownSampNrep
fnames(i).name
compareDownSampNrep
fn = getName('MID_file', Gid, cellId, downSampFactors(di), nrep, timeWindow, trialMode);
trialMode = 'all';
fn = getName('MID_file', Gid, cellId, downSampFactors(di), nrep, timeWindow, trialMode);
compareDownSampNrep
v_MIDv = reshape(S.v_MID, [numel(S.MID), 4]);
v_MIDv = reshape(S.v_MID{1}, [numel(S.MID), 4]);
allCCs = pearsonRm(v_MIDv);
tril(ones(5,5), -1)
meanCC = getMeanMIDcc(S.v_MID{1});
compareDownSampNrep
x = [1:nnreps];
plot(x, allMeanCCs, 'o-')
compareDownSampNrep
gc
[STA_aa, STA_oe] = getOspDataForPsthWindow(Gid, cellId, [], [], L_bin, R_bin, windowProfile, {'STA', 'STA_oe'});
isAvailable = cellfun(@(dn) isfield(s, dn) && (length(s.(dn)) >= w_idx) && ~isempty(s.(dn){w_idx}), dataToCalculate) ;
gc
isAvailable = cellfun(@(dn) isfield(s, dn) && (length(s.(dn)) >= w_idx) && ~isempty(s.(dn){w_idx}), dataToCalculate) ;
gc
%-- 02/17/2015 10:01:40 PM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
edit printPhaseTuningComparisons.m
curGratingType
curGratingType(2)
gc
gp
gcmp
printPhaseTuningComparisons
edit generateGratingComparisonsDatafile.m
printPhaseTuningComparisons
allPairTypes = {'Wcc', 'Wrcc', 'Bcc',   'Wcm', 'Wrcm', 'Bcm', 'Bmm',   'Wscc'};
pairTypes = pairTypes(  ord(cellfun(@(s) find(strcmp(s, allPairTypes)), pairTypes)) );
printPhaseTuningComparisons
edit printDegreeOfTuningComparisons.m
S{cc_idx, loc_idx}
cc_idx = find(strcmp(measures, 'cc'), 1);
S{cc_idx, loc_idx}
loc_idx = 1;
S{cc_idx, loc_idx}
max(Wcc_idxs)
max(Bcc_idxs)
cc_all = S{cc_idx, loc_idx}.val;
cc_bcc = cc_all(Bcc_idxs);
cc_wcc = cc_all(Wcc_idxs);
S
S{1}
S{2}
S{1,2}
S{2,2}
S{1,1}
S{2,1}
edit generateGratingPairsDatafile.m
gp
S2 = load(pairDatafile);
S2.Wrcc_details
printPhaseTuningComparisons
edit printPhaseTuningComparisons.m
printPhaseTuningComparisons
varBreakdown(sameAnimal_bcc)
varBreakdown(samePen_bcc)
printPhaseTuningComparisons
showDistributions + showWP + double(showWA)
showDistributions + showWP + showWA
printPhaseTuningComparisons
get(get(gca, 'title'), 'fontsize')
clf
printPhaseTuningComparisons
edit curPhaseOEmode.m
curPhaseOEmode
printPhaseTuningComparisons
S{1}
printPhaseTuningComparisons
edit generateGratingComparisonsDatafile.m
gcmp
%-- 02/18/2015 01:30:39 AM --%
edit plotResults
plotResults
edit createNoisyLettersDatafile
plotResults
letterOpt_use_ideal.fontName
plotResults
edit plotResults
plotResults
%-- 02/18/2015 01:53:28 AM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
edit printPhaseTuningComparisons.m
curGratingType
printPhaseTuningComparisons
curGratingType(1)
gc
gp
edit generateGratingComparisonsDatafile.m
generateGratingComparisonsDatafile
Cell1.STAdata
Cell2.STAdata
generateGratingComparisonsDatafile
[RF_curPairStats, RF_shuffPairStats, RF_stats] = getReceptiveFieldCorrelationsFor2Cells(Cell1, Cell2);
generateGratingComparisonsDatafile
curMinR_oe
edit curMinR_oe
curMinR_oe('hoe', 0.25)
curMinR_oe(0.25, 'hoe')
curMinR_oe
curMinR_oe('')
generateGratingComparisonsDatafile
curGratingType(2)
gcmp
%-- 02/18/2015 02:19:28 AM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
edit generateGratingComparisonsDatafile.m
curMinR_oe('')
curMinR_oe(nan)
curMinR_oe('')
curGratingType
gcmp
edit printPhaseTuningComparisons.m
printPhaseTuningComparisons
edit generateGratingComparisonsDatafile.m
gcmp
printPhaseTuningComparisons
curGratingType(1)
gcmp
printPhaseTuningComparisons
edit generateGratingComparisonsDatafile.m
edit printPhaseTuningComparisons.m
curGratingType(2)
printPhaseTuningComparisons
showDistributions = 0
printPhaseTuningComparisons
any(tf_bcm)
any(tf_bmm)
curPairTypes
curPairTypes('')
any(tf_bmm)
any(tf_bcm)
tf_sameGrp = pairData.Gids(:,1) == pairData.Gids(:,2);
isequal(find(tf_sameGrp), Wcc_pairIdxs)
find(tf_sameGrp, 20)
Wcc_pairIdxs(1:20)
Wcc_pairIdxs(1:20)'
find(tf_sameGrp, 20)'
W_pairIdxs = find( pairData.Gids(:,1) == pairData.Gids(:,2) );
B_pairIdxs = find( pairData.Gids(:,1) ~= pairData.Gids(:,2) );
any(tf_bcm)
edit plotResults
edit nCellsInBallOfCortex
.1*.1*.1 * 50000
8000 * .03
8000 * .03 * 1000
edit printPhaseTuningComparisons.m
%-- 03/08/2015 12:10:17 AM --%
%-- 03/08/2015 12:11:09 AM --%
edit plotResults
plotResults
edit plotResults
plotResults
edit plotResults
edit linestyle
linestyle([1,2,3])
marker([1,2,3])
linestyle([1,2,3])
s = allstyles(linestyle_index);
linestyle([1,2,3])
plotResults
4.5*14
4.5*14.5
4.5*15
edit generateSnakesFonts.m
edit measurePsychCurves_together
generateSnakesFonts
colorbar
imageToScale
generateSnakesFonts
figure
imagesc(S.D)
colormap(gray)
imageToScale([], 2)
colorbar
imageToScale([], 2)
generateSnakesFonts
imagesc(S.D)
colorbar
edit generateSnakesFonts
generateSnakesFonts
opts.useModifiedLetters > 0
L = max(abs(lims(gabor)));
generateSnakesFonts
figure
imagesc(canvas)
generateSnakesFonts
imagesc(canvas)
imagesc(canvas')
colorbar
colormap
colormap(gray)
imagesc(let_i)
imageToScale([], 2)
imagesc(tileImages(allLetters))
imageToScale([], 2)
imageToScale([], 1)
S_noWiggle
S_noWiggle.C
S_noWiggle
imageToScale([], 1)
generateSnakesFonts
[let_i, t] = DrawLetter(t,allSloanLetters(i), opts.useModifiedLetters);
generateSnakesFonts
max(gaborMaxAmplitude, max(abs(allLetters(:))) )
generateSnakesFonts
[a,b] = loadLetters('Snakesp', 'k126');
edit loadLetters.m
edit addSummaryOfFontSizesToFontFile.m
generateSnakesFonts
s = loadLetters('Snakesp');
S_fonts
s = loadLetters('SnakespN');
[a,b] = loadLetters('SnakespN', 'k126');
b
imagesc(tileImages(b))
imagesc(tileImages(b.letters))
imagesc(tileImages(b.letters), 2, 5)
imagesc(tileImages(b.letters, 2, 5))
imageToScale([], 1)
edit measurePsychCurves_together
measurePsychCurves_together
measurePsychCurves_together(1)
4.5*
4.5*15
4.5*14
4.5*14.5
4.5*15
5*15
5*14
5*14.5
5*15
edit plotResults
%-- 03/09/2015 01:56:00 AM --%
[6,16]*4
11*6*6
7*4*4
21*6*5
edit createNoisyLettersDatafile\
edit createNoisyLettersDatafile
edit measurePsychCurves_together
edit createNoisyLettersDatafile
edit plotResults
plotResults
edit plotResults
decades_equal
edit measurePsychCurves_together
edit createNoisyLettersDatafile
edit measurePsychCurves_together
measurePsychCurves_together
edit generateSnakesFonts
generateSnakesFonts
edit generateSnakesFonts
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
doc isfloat
isa(inputMatrix, 'double') && ~isa(signalTemplates, 'double')
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
figure
imagesc(noisySet.inputMatrix(:,:,1))
colorbar
colormap(gray)
imageToScale([], 2)
imageToScale([], 1)
D = noisySet.inputMatrix - (double(inputSignalMatrix * signalContrast) + inputNoiseMatrix * noiseContrast);
imagesc(D)
imagesc(D(:,:,1))
colorbar
imagesc(D(:,:,2))
imagesc(D(:,:,2)); colorbar
plot(sumSqrErrs)
sumSqrErrs2 = sumSqrErrors(double(signalTemplates), double(inputMatrix(:,stim_i)));
clf; plot(sumSqrErrs); hold on; plot(sumSqrErrs2, 'r')
clf; plot(sumSqrErrs/sumSqrErrs(1)); hold on; plot(sumSqrErrs2/sumSqrErrs2(1), 'r')
drawVerticalLine(noisySet.labels(stim_i))
noisySet.labels(stim_i)
drawVerticalLine(noisySet.labels(stim_i)); xlim([.9, 10.1])
max(signalTemplates(:))
max(inputMatrix(:))
max(abs(inputMatrix(:)))
doc single
2^22
max(abs(inputMatrix(:)))^2
round(max(abs(inputMatrix(:)))^2)
clf; plot(sumSqrErrs); hold on; plot(sumSqrErrs2, 'r')
(sumSqrErrs - sumSqrErrs2)./sumSqrErrs2
((sumSqrErrs - sumSqrErrs2)./sumSqrErrs2)*100
figure; plot( signalTemplates(:,5) - inputMatrix(:,stim_i) )
figure; plot( signalTemplates(1:200,5) - inputMatrix(1:200,stim_i) )
clf; idx = 1:200; plot( signalTemplates(idx,5) - inputMatrix(idx,stim_i) ); hold on;
clf; idx = 1:200; plot( signalTemplates(idx,5) - inputMatrix(idx,stim_i) ); hold on; plot( double( signalTemplates(idx,5)) - double(inputMatrix(idx,stim_i)), 'r' );
clf; idx = 1:200; plot( (signalTemplates(idx,5) - inputMatrix(idx,stim_i)).^2 ); hold on; plot( double( signalTemplates(idx,5)) - double(inputMatrix(idx,stim_i)), 'r' );
clf; idx = 1:200; plot( (signalTemplates(idx,5) - inputMatrix(idx,stim_i)).^2 ); hold on; plot( (double( signalTemplates(idx,5)) - double(inputMatrix(idx,stim_i))).^2, 'r' );
idx = 1:160000; [ (signalTemplates(idx,5) - inputMatrix(idx,stim_i)).^2,   double( signalTemplates(idx,5)) - double(inputMatrix(idx,stim_i))).^2 ]
idx = 1:160000; [ (signalTemplates(idx,5) - inputMatrix(idx,stim_i)).^2,   (double( signalTemplates(idx,5)) - double(inputMatrix(idx,stim_i))).^2 ]
idx = 1:160000; [ sum( (signalTemplates(idx,5) - inputMatrix(idx,stim_i)).^2),  sum( (double( signalTemplates(idx,5)) - double(inputMatrix(idx,stim_i))).^2 ) ]
diff(ans)
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together(1)
edit measurePsychCurves_together
edit generateSnakesFonts
edit generateLetterSignals.m
which rms
edit rms
rms (randn(1,1e5) )
rms (randn(1,1e6) )
rms (randn(1,1e7) )
edit measurePsychCurves_together
edit generateLetterSignals.m
edit generateSnakesFonts
edit measurePsychCurves_together
measurePsychCurves_together
measurePsychCurves_together(1)
edit measurePsychCurves_together
measurePsychCurves_together(1)
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
set(gca, 'xscale', 'linear', 'yscale', 'linear')
set(gca, 'xscale', 'linear', 'yscale', 'linear', 'ylim', [0, .1])
set(gca, 'xtickLabelMode', 'auto')
set(gca, 'xtick', [0:10:90])
edit plotResults
x_wiggle_pts = x_wiggle_paper; y_efficiency_pts = y_eff_paper;
clippedLine_func = @(c, x) clippedLine(c, x);
%              clippedLine90 = @(c, x) clippedLine([c(1), 90, c(2), c(3)], x);
beta_clipped0 = [5, 45, .01, .08];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
y_efficiceny_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
beta_clipped0 = [5, 45, .1, .08];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
x_wiggle_fit = 1:1:100;
beta_clipped0 = [5, 45, .01, .08];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
y_efficiceny_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
clippedLine_func = @(c, x) clippedLine(c, x);
%              clippedLine90 = @(c, x) clippedLine([c(1), 90, c(2), c(3)], x);
beta_clipped0 = [5, 45, .01, .08];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
y_efficiency_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
j = 1
y_efficiency_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
beta_clipped0 = [5, 45, .07, .02];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
y_efficiency_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
beta_clipped0 = [5, 45, .1, .01];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
y_efficiency_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
beta_clipped0 = [5, 45, .08, .02];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
y_efficiency_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
beta_clipped0 = [5, 45, .07, .02];
beta_clipped = nlinfit(x_wiggle_pts, y_efficiency_pts, ...
clippedLine_func, beta_clipped0);
y_efficiency_fit(:,j) = clippedLine_func(beta_clipped, x_wiggle_fit); %#ok<AGROW>
edit measurePsychCurves_together
edit plotResults
beta_clipped
edit measurePsychCurves_together
beta_clipped0 = [9.1501   43.9847    0.0710    0.0189];
y_func = @(w) clippedLine(beta_clipped0, w);
xtick_wig0 = 0
x_wiggle_fit = xtick_wig0:1:100;
beta_clipped0 = [9.1501   43.9847    0.0710    0.0189];
y_func = @(w) clippedLine(beta_clipped0, w);
y_efficiency_fit = y_func(x_wiggle_fit);
plot(x_wiggle_fit, y_efficiency_fit, 'r-');
y_efficiency_fit = y_func(x_wiggle_fit);
plot(x_wiggle_fit, y_efficiency_fit, 'r-');
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
sprintf('{%s}', allLetterChars(find(lettersInDataset, curLabel)))
allLetterChars_full = 'A':'Z';
correct_char_str = sprintf('{%s}', allLetterChars_full(find(lettersInDataset, curLabel)));
correct_char_str = sprintf('{%s}', allLetterChars_full(find(lettersInDataset, curLabel)))
allLetterChars_full(idx(curLabel))
idx = find(lettersInDataset);
allLetterChars_full(idx(curLabel))
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit plotResults
plotResults
edit plotResults
plotResults
430/320
plotResults
3645/320
plotResults
edit createNoisyLettersDatafile
edit plotResults
plotResults
edit createNoisyLettersDatafile
edit filterStr.m
edit createNoisyLettersDatafile
sprintf('%.0f', 1.0)
sprintf('%.0f', 1.0 * 10)
sprintf('%.0f', 1.5 * 10)
edit generateSetOfNoisyLetters.m
edit createNoisyLettersDatafile
edit measurePsychCurves_together
plotResults
close all
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
measurePsychCurves_together(1)
edit measurePsychCurves_together
measurePsychCurves_together(1)
edit measurePsychCurves_together
measurePsychCurves_together
imageToScale
figure
imagesc(abs(fftshift(fft2(curStim))))
colormap(gray)
axis square
imagesc(log10( abs(fftshift(fft2(curStim)))) )
edit measurePsychCurves_together
measurePsychCurves_together
S{noise_idx}
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
figure
imagesc(log10( abs(fftshift(fft2(curStim)))) )
colormap(gray)
axis square
colorbar
imagesc(( abs(fftshift(fft2(curStim)))) )
axis square
edit measurePsychCurves_together
measurePsychCurves_together
allThresholds_quest
measurePsychCurves_together
allSignals{xi}
size( cat(3, allSignals{xi}.image) )
allLetterTemplates{xi} = tileImages(allLetters, tmp_m, tmp_n, 1, 0);
figure
imagesc(allLetterTemplates{xi})
edit tileImages.m
colormap(gray)
imageToScale
measurePsychCurves_together
edit extractFontFromPNG.m
[~, ~, ~, ~, allLetters] = findLetterBounds( cat(3, allSignals{xi}.image) );
allLetterTemplates{xi} = allLetters;
measurePsychCurves_together
colormap(cmap)
measurePsychCurves_together
imageToScale
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
allThresholds_quest
allCCs = pearsonRm(v_MIDv);
allCycPerLet
edit measurePsychCurves_together
measurePsychCurves_together
S = loadLetters('Braille')
S.sizes
S.k_heights
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
get(h_tmp_title(1), 'fontSize')
set(h_tmp_title(1), 'fontSize', 30)
set(h_tmp_title(1), 'fontWeight', 'bold')
edit measurePsychCurves_together
measurePsychCurves_together
edit createNoisyLettersDatafile
createNoisyLettersDatafile
fourierMaskCorrectionFactor(maskSum)
figure
imagesc(pinkMask)
imagesc(pinkMask); colorbar;
imagesc(log10(pinkMask)); colorbar;
imagesc(log10(maskSum)); colorbar;
imagesc(log10(maskSum_rescaled)); colorbar;
sum(maskSum_rescaled(:))
round( sum(maskSum_rescaled(:)) )
round( sum(pinkSum(:)) )
round( sum(pinkMask(:)) )
round( sum(pinkMask(:).^2) )
round( sum(maskSum_rescaled(:).^2) )
round( sum(whiteMask(:).^2) )
edit filterStr.m
filtStr = sprintf('N%spink%s%sw%s', pinkExtraStr, f_exp_str, plus_or_str, whiteExtraStr);
whiteExtraStr = sprintf('%.0f', (1/pinkWhiteRatio)*10 );
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
imageToScale
edit createNoisyLettersDatafile
createNoisyLettersDatafile
imageToScale
edit createNoisyLettersDatafile
createNoisyLettersDatafile
imageToScale
createNoisyLettersDatafile
imageToScale
createNoisyLettersDatafile
imageToScale
createNoisyLettersDatafile
figure
imagesc( tileImages(cat(3, noiseMasks{:}), 1, 5) )
colormap(cmap)
colormap(gray)
createNoisyLettersDatafile
figure
imagesc( tileImages( noisySet.inputMatrix(:,:,100) , 10, 10) )
imagesc( tileImages( noisySet.inputMatrix(:,:,1:100) , 10, 10) )
colormap(gray)
figure
colormap(gray)
imagesc( tileImages( noisySet.inputMatrix(:,:,1:100) , 10, 10) )
1/0.4
edit switchh
measurePsychCurves_together
edit measurePsychCurves_together
permOrders_C = arrayfun(@() randperm(5), 1:3, 'un', 0)
permOrders_C = arrayfun(@(i) randperm(5), 1:3, 'un', 0)
permOrders_C{:}
measurePsychCurves_together(1)
permOrders_C = arrayfun(@(i) randperm(nClasses), 1:100, 'un', 0);
permOrders = [permOrders{:}];
measurePsychCurves_together(1)
edit measurePsychCurves_together
measurePsychCurves_together(1)
S = load('PowerSpectrumSlopes.mat')
figure
hist(S.train)
hist(S.train, 50)
hist(S.train/2, 50)
[~, order_hi] = sort(S.train, 'descend');
order_hi(1:5)
[slopes_lowest, order_lo] = sort(S.train, 'ascend');
[slopes_highest, order_hi] = sort(S.train, 'descend');
slopes_highest(1:5)
order_hi(1:5)
hist(S.test/2, 50)
[slopes_highest, order_hi] = sort(S.test, 'descend');
[slopes_lowest, order_lo] = sort(S.test, 'ascend');
order_hi(1:5)
S
figure
s = imread('10124.png');
size(s)
image(s)
for i = 1:10, subplot(2,5,i); s = imread(sprintf('%d.png', order_hi(i))); image(s); end
imageToScale
for i = 1:10, subplot(2,5,i); s = imread(sprintf('%d.png', order_lo(i))); image(s); end
clf
clf; for i = 1:10, subplot(2,5,i); s = imread(sprintf('%d.png', order_lo(i))); image(s); end; imageToScale
edit plotResults
getPowerSpectrumSlope(s)
S = load('../PowerSpectrumSlopes.mat')
[slopes_lowest, order_lo] = sort(S.test, 'ascend');
[slopes_highest, order_hi] = sort(S.test, 'descend');
clf; for i = 1:10, subplot(2,5,i); s = imread(sprintf('%d.png', order_lo(i))); image(s); end; imageToScale
figure(3); clf; for i = 1:10, subplot(2,5,i); s = imread(sprintf('%d.png', order_lo(i))); image(s); end; imageToScale
getPowerSpectrumSlope(s)
s
getPowerSpectrumSlope(s)
class ( rgb2gray(s) )
getPowerSpectrumSlope(rgb2gray(s))
clf
getPowerSpectrumSlope(rgb2gray(s))
image(X_orig)
figure(3); clf; for i = 1:10, subplot(2,5,i); image_i = imread(sprintf('%d.png', order_lo(i))); image(image_i); end; imageToScale
image(image_i)
imagesc(rgb2gray( image_i) )
getPowerSpectrumSlope(rgb2gray(image_i))
imageToScale
figure(3); clf; for i = 1:10, subplot(2,5,i); image_i = imread(sprintf('%d.png', order_lo(i))); image(image_i); slp = getPowerSpectrumSlope(rgb2gray(image_i)); title(sprintf('%.1f', slp)); end; imageToScale
figure(3); clf; for i = 1:10, subplot(2,5,i); image_i = imread(sprintf('%d.png', order_hi(i))); image(image_i); slp = getPowerSpectrumSlope(rgb2gray(image_i)); title(sprintf('%.1f', slp)); end; imageToScale
figure(3); clf; for i = 1:10, subplot(2,5,i); image_i = imread(sprintf('%d.png', order_hi(i))); image(image_i); slp = getPowerSpectrumSlope(rgb2gray(image_i)); title(sprintf('%.1f', slp/2)); end; imageToScale
[slopes_highest, order_hi] = sort(S.test, 'descend');
[slopes_lowest, order_lo] = sort(S.test, 'ascend');
figure(3); clf; for i = 1:10, subplot(2,5,i); image_i = imread(sprintf('%d.png', order_hi(i))); image(image_i); slp = getPowerSpectrumSlope(rgb2gray(image_i)); title(sprintf('%.1f', slp/2)); end; imageToScale
i
dbquit
figure
hist(all_slopes)
hist(all_slopes, 50)
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
allCycPerLet
allThresholds_quest
mea
measurePsychCurves_together
allThresholds_quest
allCycPerLet
i = 1
logspace(1,5,5)
y_fit = 10.^polyval(p, log10(x_fit));
x_mid = -b/(2*a);
[a,fontData] = loadLetters(fontNames{i}, 'k32');
dbquit
[a,fontData] = loadLetters(fontNames{i}, 'k32');
[a,fontData] = loadLetters(fontNames{i}, 'k32', 'minSize');
%-- 03/12/2015 12:18:51 AM --%
profilePath('load', 'CatV1Exp')
cd(lettersPath)
cd(CatV1Path)
dir
barGraphOfDegreeTuningResults
h_saved(i) = hgload( sprintf('%sFig12%s%s.fig', figureFolder, filesep, fileNames{i}) );
barGraphOfDegreeTuningResults
edit barGraphOfDegreeTuningResults
barGraphOfDegreeTuningResults
S_stat_ss.(fld_i_nm)
barGraphOfDegreeTuningResults
curGratingType
curGratingType('')
barGraphOfDegreeTuningResults
filename_d_diff
filename_f_diff
filename_d_stat
filename_f_stat
which export_fig.m
edit barGraphOfDegreeTuningResults
barGraphOfDegreeTuningResults
filename_f_stat_sc = getFileName('scPairStats', [], [], struct('gratingType', 'flashed', 'cmpType', cmpType, 'subtractSpont', subtractSpont, 'preserveSimpleComplex', true));
filename_f_stat_sc
which adjustPositionOfBar.m
which ds2nfu.m
which importToPanel.m
cd ..
cd fhwa/
edit showFrames.m
doc textread
A = dlmread('test.txt', ' ')
s = dir('./scratch/test.avi*')
s = dir('./scratch/%s*', video_name);
pth = ['./scratch/' s.name '/'];
pth
allImages_files = dir(pth);
allImages_files = dir([pth '*.png']);
[pth '*.png']
dir([pth '*.png'])
dir([pth])
dir(pth)
text_name = strrep([basePath video_name], '.avi', '.txt');
[pth allImages_filenames{i}]
i = 1
[pth allImages_filenames{i}]
im = imread([pth allImages_filenames{i}]);
figure
image(im)
image(im(:,:,1))
image(im(:,:,2))
image(im(:,:,3))
imagesc(im(:,:,3))
colormap(gray)
imagesc(im(:,:,1))
imagesc(im(:,:,2))
imagesc(im(:,:,3))
imageToScale([], 2)
xi = reshape( X(i,:), 2, 8);
h_func( xi(1,j))
xi = reshape( X(i,:), 2, 8);
x = w_func(xi(1,:));
y = h_func(xi(2,:));
h_func = @(h_frac)  round ( mid_h + h_frac*h  );
w_func = @(w_frac) round ( mid_w + w_frac*w  );
x = w_func(xi(1,:));
y = h_func(xi(2,:));
i = 100
clear all
edit barGraphOfDegreeTuningResults
%-- 03/17/2015 01:41:10 AM --%
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit fig_makeSampleImage.m
fig_makeSampleImage
edit fig_sampleSnakeLetters.m
lettersPath
edit codePath.m
load('SnakesN_k32-1oxy-[64x64]-30SNR.mat')
S = load('SnakesN_k32-1oxy-[64x64]-30SNR.mat')
imagesc(S.inputMatrix(:,:,1)); colormap('gray'); axis image;
S = load('SnakesN_k32-1oxy-[64x64]-40SNR.mat')
imagesc(S.inputMatrix(:,:,1)); colormap('gray'); axis image;
S = load('SnakesN_k32-1oxy-[64x64]-35SNR.mat')
imagesc(S.inputMatrix(:,:,1)); colormap('gray'); axis image;
load('SnakesN_55-1oxy-[64x64]-35SNR.mat')
S = load('SnakesN_55-1oxy-[64x64]-35SNR.mat')
imagesc(S.inputMatrix(:,:,1)); colormap('gray'); axis image;
imagesc(S.inputMatrix(:,:,2)); colormap('gray'); axis image;
imagesc(S.inputMatrix(:,:,2)); colormap('gray'); axis image; imageToScale([], 1)
imagesc(S.inputMatrix(:,:,2)); colormap('gray'); axis image; imageToScale([], 2)
imagesc(S.inputMatrix(:,:,2)); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
S = load('SnakesN_k32-1oxy-[64x64]-35SNR.mat')
imagesc(S.inputMatrix(:,:,2)); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
imagesc(S.inputMatrix(:,:,1)); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
imagesc(S.inputMatrix(:,:,find(S.labels==1,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=2; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=3; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=4; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=5; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=6; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=7; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=8; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=9; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=10; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=8; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
i=5; imagesc(S.inputMatrix(:,:,find(S.labels==i,1))); colormap('gray'); axis image; imageToScale([], 2); ticksOff;
linspace(0, 90, 4)
linspace(0, 90, 5)
linspace(0, 90, 6)
linspace(0, 90, 7)
S
edit generateSnakesFonts
edit createNoisyLettersDatafile
createNoisyLettersDatafile
dbquit
L = lims([im{:}]);
imageToScale([], 2)
edit plotResults
plotResults
edit plotResults
plotResults
Y_vals_M_sm = gaussSmooth(Y_vals_M, smoothChannels_w, 1);
figure
plot(Y_vals_M_sm(:,:,1))
Y_vals_M_sm = gaussSmooth(Y_vals_M, smoothChannels_w, .5); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .5, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .7, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .8, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .7, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .6, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .65, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .7, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .75, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .8, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .75, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
Y_vals_M_sm = gaussSmooth(Y_vals_M, .8, 1); plot(Y_vals_M_sm(:,:,1), 'o-')
plot(Y_vals_M_sm(:,:,1))
plotResults
edit plotResults
plotResults
%-- 03/17/2015 09:46:46 AM --%
edit plotResults
edit createNoisyLettersDatafile
createNoisyLettersDatafile
sprintf('%.6f', rand_seed)
createNoisyLettersDatafile
%-- 03/25/2015 01:35:31 AM --%
version
help
VER
ver
load woman
imagesc(X)
colormap('gray')
axis image
[c,s] = wavedec2(X,2,'db1');
hist(c)
hist(log10(c))
hist(c)
hist(c, 50)
set(gca, 'yscale', 'log')
50*1000/5
%-- 05/22/2015 01:02:42 AM --%
profilePath
profilePath('load', 'nyu')
edit createNoisyLettersDatafile
edit profilePath.m
profilePath('load', 'nyu')
edit createNoisyLettersDatafile
createNoisyLettersDatafile
%-- 05/22/2015 09:06:36 AM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
edit mid_findMostInfoDim
curResponseType
findAllMIDs
curResponseType(2)
findAllMIDs
lock_dir
findAllMIDs
computer
arch = switchh(computer, {'PCWIN', 'PCWIN64', 'GLNXA64'}, {'win32', 'win64', 'linux64'});
findAllMIDs
hostname
getenv('hostname')
funcName = ['~/Local/MID/' funcName_base];
findAllMIDs
%-- 05/25/2015 11:15:06 PM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
which findAllMIDs
profilePath
profilePath('load', 'builtin')
findAllMIDs
which iff
findAllMIDs
edit codePath
findAllMIDs
edit codePath
%-- 05/26/2015 08:58:24 PM --%
profilePath('load', 'CatV1Exp')
cd(CatV1Path)
%-- 07/31/2015 01:33:10 AM --%
edit getNoisyLetterOptsStr.m
edit generateSetOfNoisyLetters.m
edit generateSetOfLetters.m
createNoisyLettersDatafile
profilePath('load', 'nyu')
userpath
ispc
cd(userpath)
startup
lettersCodePath
%-- 07/31/2015 02:28:39 AM --%
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit onNYUserver.m
edit generateSetOfNoisyLetters.m
edit generateSetOfLetters.m
edit createNoisyLettersDatafile
createNoisyLettersDatafile
ticksOff
edit createNoisyLettersDatafile
createNoisyLettersDatafile
filename_image
edit createNoisyLettersDatafile
createNoisyLettersDatafile
set(gca, 'tickDir', 'out')
get(gca, 'tickLength')
set(gca, 'tickLength', [0.01 0.025])
set(gca, 'tickLength', [0.001 0.0025])
edit filterStr.m
createNoisyLettersDatafile
startup
S = load('PowerSpectrumSlopes.mat')
figure
hist(S.train/2, 30)
hist(S.train/2, 60)
mean(S.train/2, 60)
mean([S.train/2])
std([S.train/2])
std([S.test/2])
createNoisyLettersDatafile
figure
hist(all_f_exp, 30)
hist(-all_f_exp, 30)
createNoisyLettersDatafile
S = load('PowerSpectrumSlopes.mat')
figure
filename_image
edit generateSetOfLetters.m
edit createNoisyLettersDatafile
edit plotResults
createNoisyLettersDatafile
profilePath('load', 'CatV1Exp')
edit profilePath.m
codePath
profilePath('load', 'CatV1Exp')
edit profilePath.m
profilePath('load', 'CatV1Exp')
edit gatherMIDs
gatherMIDs
%-- 08/08/2015 10:53:31 PM --%
edit plotResults
plotResults
8+8+6+8+2
plotResults
warning('Don''t have human data for font %s. Using Bookman instead', fontName);
plotResults
s.allSNRs(:))
s.allSNRs(:)
plotResults
edit createNoisyLettersDatafile
[imageHeight, imageWidth] = getBestImageSize(0, 0, 0, {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}, 'k16', 0)
fontSize = getFontSize(fontName, sizeStyle, 'minSize');
[imageHeight, imageWidth] = getBestImageSize(0, 0, 0, {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}, 'k16', 0)
[imageHeight, imageWidth] = getBestImageSize(0, 0, 0, {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}, 'k14', 0)
[imageHeight, imageWidth] = getBestImageSize(0, 0, 0, {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}, 'k15', 0)
viewAllFontsForOneSize('k16')
[imageHeight, imageWidth] = getBestImageSize(0, 0, 0, {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}, 'k14', 0)
edit viewAllFontsForOneSize.m
edit createNoisyLettersDatafile
viewAllFontsForOneSize('k16')
edit createNoisyLettersDatafile
viewAllFontsForOneSize('k32')
createNoisyLettersDatafile
imageToScale([], 2)
imageToScale([], 4)
createNoisyLettersDatafile
imageToScale([], 4)
imageToScale([], 2)
viewAllFontsForOneSize('k16')
viewAllFontsForOneSize('k32')
34/23
1/(34/23)
1/1.5
viewAllFontsForOneSize('k14')
viewAllFontsForOneSize('k15')
viewAllFontsForOneSize('k16')
viewAllFontsForOneSize('k15')
[imageHeight, imageWidth] = getBestImageSize(0, 0, 0, {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}, 'k15', 0)
viewAllFontsForOneSize('x10')
viewAllFontsForOneSize('k15')
createNoisyLettersDatafile
getFontComplexity('Bookman', 'k15')
cellfun(@(f) getFontComplexity(f, 'k15'), {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'})
cellfun(@(f) getFontComplexity(f, 'k16'), {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'})
cellfun(@(f) getFontComplexity(f, 'k16', 'minSize'), {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'})
cellfun(@(f) getFontComplexity(f, 'k14', 'minSize'), {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'})
%-- 08/14/2015 03:10:52 AM --%
edit createNoisyLettersDatafile
viewAllFontsForOneSize('k32')
viewAllFontsForOneSize('k14')
viewAllFontsForOneSize('k15')
viewAllFontsForOneSize('k30')
createNoisyLettersDatafile
%-- 08/28/2015 07:04:50 PM --%
plotResults
edit fileExistsInPreferredSubdir.m
fileparts('/media/avi/Storage/Users/Avi/Code/nyu/letters/')
[a,b,c] = fileparts('/media/avi/Storage/Users/Avi/Code/nyu/letters/a.txt')
parentdir('/media/avi/Storage/Users/Avi/Code/nyu/letters/a.txt')
parentdir('/media/avi/Storage/Users/Avi/Code/nyu/letters/')
parentdir('/media/avi/Storage/Users/Avi/Code/nyu/letters')
parentdir('/media/avi/Storage/Users/Avi/Code/nyu/lett')
parentdir('/media/avi/Storage/Users/Avi/Code/nyu')
plotResults
measurePsychCurves_together
edit measurePsychCurves_together
measurePsychCurves_together
hold on
10^p(2)
plot(comp_xs, 0.97 * comp_xs.^(-0.51), 'g*')
plot(comp_xs, 1 * comp_xs.^(-0.51), 'mo')
set(h_eff_title, 'string', sprintf('slope = %.2f. C = %.2f', p(1)), 10^p(2));
set(h_eff_title, 'string', sprintf('slope = %.2f. C = %.2f', p(1), 10^p(2)));
edit plotResults
edit createNoisyLettersDatafile
createNoisyLettersDatafile
plotResults
clf
plotResults
edit runIdealObserverTests.m
runIdealObserverTests
edit plotResults
plotResults
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
title(file_name_base_str, 'interpreter', 'none');
createNoisyLettersDatafile
which filedate
%-- 09/01/2015 11:48:17 AM --%
S = load('SVHN_train_32x32_gray_gnorm.mat')
imagesc( tileImages( S.inputMatrix(:,:,1:100)) )
colormap('gray')
colorbar
Sn = load('SVHN_train_32x32_gray_gnorm_lcnorm.mat')
figure
imagesc( tileImages( Sn.inputMatrix(:,:,1:100)) )
colormap('gray')
colorbar
Sng = load('SVHN_train_32x32_gray.mat')
figure
imagesc( tileImages( Sng.inputMatrix(:,:,1:100)) )
colormap('gray')
colorbar
8947.50-5368.5
5368.5/8947.50
8947.50  - 5368.5
edit plotResults
plotResults
mainExperimentDir
parentdir('/media/avi/Storage/Users/Avi/Code/nyu/letters/data/Results/Complexity/')
parentdir('/media/avi/Storage/Users/Avi/Code/nyu/letters/data/Results/Complexity')
parentdir('/media/avi/Storage/Users/Avi/Code/nyu/letters/data/Results/Complexit')
plotResults
noisyLetterOpts.trainingNoise
plotResults
axis auto
plotResults
[haveFile, filename, foldersChecked] = fileExistsInSisterSubdirs(mainFolder, preferredSubdir, file_name);
foldersChecked'
[haveFile, filename, foldersChecked] = fileExistsInSisterSubdirs(mainFolder, preferredSubdir, file_name);
foldersChecked'
[haveFile, filename, foldersChecked] = fileExistsInSisterSubdirs(mainFolder, preferredSubdir, file_name);
foldersChecked'
plotResults
filename
plotResults
filename
plotResults
filename
[haveFile, filename, foldersChecked] = fileExistsInSisterSubdirs(mainFolder, preferredSubdir, file_name);
plotResults
edit measurePsychCurves_together
plotResults
edit createNoisyLettersDatafile
letterOpts = letterOpt_use;
letterOpts.noiseFilter
freq_i = 1
letterOpts.noiseFilter = struct('filterType', 'band',   'cycPerLet_centFreq', allNoiseFreqs(freq_i), 'applyFourierMaskGainFactor', 1);
letterOpts.noiseFilter
file_name_base_str = getFileName(letterOpts.fontName, 0, letterOpts)
letterOpts.trainingFonts = [];
file_name_base_str = getFileName(letterOpts.fontName, 0, letterOpts)
letterOpts.trainingFonts = 'same';
file_name_base_str = getFileName(letterOpts.fontName, 0, letterOpts)
datasetsPath
noisyLettersPath = [datasetsPath stimType filesep letterOpts.fontName filesep ]; % 'sz32x32' filesep]
noisyLettersPath = [datasetsPath stimType filesep letterOpts.fontName filesep ]
fn_i_im  = [noisyLettersPath file_name_base_str ];
imageFileExists = exist(fn_i_im, 'file')
S_stim = load(stimFile);
stimFile = [noisyLettersPath file_name_base_str ];
imageFileExists = exist(v, 'file') ;
S_stim = load(stimFile);
edit createNoisyLettersDatafile
createNoisyLettersDatafile
plotResults
fullModel = fullModels{xi, line_i, plot_i};
plotResults
S_model
fn{i}
A = sscanf('m%d_str', fn{i});
fn{i}
sscanf('m%d', fn{i})
A = sscanf('m%d', fn{i})
A = sscanf('m%d_', fn{i})
A = sscanf(fn{i}, 'm%d_')
plotResults
fn{i}
plotResults
S_model.moduleNames
fullModels{1}
ls *.c
mex
mex nn_spatialConvolutionMap_c.c
mex nn_spatialConvolution_c.c
ls *.c
mex nn_spatialPooling_c.c
edit nn_spatialPooling_c.c
allModules = loadTrainedModel(letterOpt_use, network_use, trial_i, opt_copy);
fullModel = recreateModel(allModules);
plotResults
fullModel
fullModel.modules{1}
fullModel.modules{2}
edit recreateModel.m
fullModel = recreateModel(allModules);
fullModel.moduleNames
plotResults
size(m.weight)
m
assert(isequal(size(m.weight), [m.kH, m.kW, m.nInputPlane m.nOutputPlane]))
dbquit
plotResults
edit nn_spatialConvolution_c.c
plotResults
edit nn_spatialConvolution_c.c
mex nn_spatialConvolution_c.c
y_out  = nn_spatialConvolution_c(y, bias, weight, dH, dW);
bias
size(bias)
size(weight)
edit nn_spatialConvolution_c.c
mex nn_spatialConvolution_c.c
y_out  = nn_spatialConvolution_c(y, bias, weight, dH, dW);
size(y)
size(y_out)
plotResults
fullModel.moduleNames
nModulesMax = 1;
edit createNoisyLettersDatafile
createNoisyLettersDatafile
plotResults
letterOpts
[fontPointSize, fontXheight, fontKheight] = getFontSize(letterOpts.fontName, letterOpts.sizeStyle);
plotResults
[fontPointSize, fontXheight, fontKheight] = getFontSize(letterOpt_use.fontName, letterOpt_use.sizeStyle);
fontKheight
fullModel.moduleNames
30/1.5
plotResults
1.68*2
edit createNoisyLettersDatafile
imagesc( tileImages( Sng.inputMatrix(:,:,1:100)) )
imagesc( tileImages( Sng.inputMatrix(:,:,1:400)) )
Sn
i = randperm(1,70000); imagesc( tileImages( Sng.inputMatrix(:,:, i(1:400) )) );
idx = randperm(70000); imagesc( tileImages( Sng.inputMatrix(:,:, idx(1:400) )) );
idx = randperm(70000); imagesc( tileImages( Sng.inputMatrix(:,:, idx(1:400) )) ); imageToScale
idx = randperm(70000); imagesc( tileImages( Sng.inputMatrix(:,:, idx(1:600) ), 200, 300) ); imageToScale
idx = randperm(70000); imagesc( tileImages( Sng.inputMatrix(:,:, idx(1:600) ), 20, 30) ); imageToScale
idx = randperm(70000); imagesc( tileImages( Sng.inputMatrix(:,:, idx(1:600) ), 20, 30, 5) ); imageToScale
idx = randperm(70000); imagesc( tileImages( Sng.inputMatrix(:,:, idx(1:600) ), 20, 30, 4) ); imageToScale
28 / 1.5
30 / 1.5
26 / 1.5
25 / 1.5
24 / 1.5
27 / 1.5
plotResults
imagesc( tileImages( Sg.inputMatrix(:,:,1:400)) )
30 / 1.5
edit createNoisyLettersDatafile
edit plotResults
plotResults
edit getNoisyLetterOptsStr.m
plotResults
viewAllFontsForOneSize('k30')
edit viewAllFontsForOneSize
viewAllFontsForOneSize('k15')
getBestImageSize(0,0,0,'Bookman', 'k15', 2)
[w,h] = getBestImageSize(0,0,0,'Bookman', 'k15', 2)
edit getBestImageSize.m
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k18', 2)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k18')
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k18', 0)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k18', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k19', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k19', 0)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k20', 0)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k21', 0)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k22', 0)
viewAllFontsForOneSize('k22')
viewAllFontsForOneSize('k15')
viewAllFontsForOneSize('k20')
getBestImageSize(0,0,0,'Bookman', 'k22', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k22', 0)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k20', 0)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k20', 2)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k20', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k21', 1)
[a,b] = loadLetters('Bookman')
S = loadLetters('Bookman')
[S.sizes; S.x_heights; S.k_heights]
viewAllFontsForOneSize('k20')
getBestImageSize(0,0,0,'Bookman', 'k22', 1)
getBestImageSize(0,0,0,'Bookman', 'k20', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k20', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k22', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k21', 1)
edit getFontSize
[fontPointSize, fontXheight, fontKheight] = getFontSize('Bookman', 'k20')
[fontPointSize, fontXheight, fontKheight] = getFontSize('Bookman', 'k20', 'closest')
[fontPointSize, fontXheight, fontKheight] = getFontSize('Bookman', 'k21', 'closest')
[fontPointSize, fontXheight, fontKheight] = getFontSize('Bookman', 'k22', 'closest')
viewAllFontsForOneSize('k20')
viewAllFontsForOneSize('k15')
viewAllFontsForOneSize('k20')
getBestImageSize(0,0,0,'Bookman', 'k20', 1)
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit plotResults
plotResults
edit createNoisyLettersDatafile
viewAllFontsForOneSize('k20')
edit createNoisyLettersDatafile
32*32
(32*32) / (36*36)
(36^2)/(32^2)
(34^2)/(32^2)
(36^2)/(32^2)
%-- 09/04/2015 09:47:54 AM --%
edit plotResults
plotResults
edit createNoisyLettersDatafile
edit plotResults
plotResults
viewAllFontsForOneSize('k48')
getBestImageSize(0,0,0,'Bookman', 'k48', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k48', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k40', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k42', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k15', 1)
viewAllFontsForOneSize('k15')
edit plotResults
plotResults
edit plotResults
plotResults
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
viewAllFontsForOneSize('k30')
getBestImageSize(0,0,0,'Bookman', 'k30', 1)
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k30', 1)
edit createNoisyLettersDatafile
createNoisyLettersDatafile
plotResults
viewAllFontsForOneSize('k30')
3.5 / 2.83
(3.5 / 2.83)*30
clear all
plotResults
viewAllFontsForOneSize('k30')
plotResults
viewAllFontsForOneSize('k38')
viewAllFontsForOneSize('k35')
viewAllFontsForOneSize('k32')
plotResults
edit plotResults
plotResults
edit createNoisyLettersDatafile
viewAllFontsForOneSize('k30')
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k30', 1)
edit createNoisyLettersDatafile
4*4*7
2*2*5
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k30', 1)
64-45
2*2*5
2*2*3
createNoisyLettersDatafile
=4*4*7
4*4*7
2*2*3
profilePath('load', 'CatV1Exp')
edit read_vec_pxpxt_file.m
%-- 09/10/2015 08:59:31 AM --%
S = load('SVHN_train_32x32_gray_gnorm_lcnorm.mat')
imagesc( tileImages( S.inputMatrix(:,:,1:400)) )
colormap('gray')
imageToScale([], 1)
i = randperm(length(S.labels)); imagesc( tileImages( S.inputMatrix(:,:, i(1:400)) ) ); imageToScale
i = randperm(length(S.labels)); imagesc( tileImages( S.inputMatrix(:,:, i(1:100)) ) ); imageToScale
i = randperm(length(S.labels)); imagesc( tileImages( S.inputMatrix(:,:, i(1: 15^2)) ) ); imageToScale
i = randperm(length(S.labels)); imagesc( tileImages( S.inputMatrix(:,:, i(1: 12^2)) ) ); imageToScale
S = load('SVHN_train_32x32_gray_gnorm.mat')
i = randperm(length(S.labels)); imagesc( tileImages( S.inputMatrix(:,:, i(1: 12^2)) ) ); imageToScale
%-- 09/10/2015 09:12:56 PM --%
%-- 09/11/2015 12:49:28 AM --%
plotResults
createNoisyLettersDatafile
%-- 09/11/2015 05:07:29 PM --%
viewAllFontsForOneSize('k30')
[h,w] = getBestImageSize(0,0,0,'Bookman', 'k30', 1)
edit getBestImageSize.m
allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'KuenstlerU'}
[h,w] = getBestImageSize(0,0,0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize(0,[0,4],0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize(0,[0,3],0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([0 4],[0,3],0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([0 10],[0,3],0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([0 1],[0,3],0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-3 : 3],[0,3],0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-3 : 3],0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-3 : 3],0,0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize(0,0,0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-2 : 2],0,0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-1 : 1],0,0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-2 : 2],0,0,allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-2 : 2],0,[0:4],allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-2 : 2],0,[0:10],allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-2 : 2],0,[0:20],allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-2 : 2],0,[0:14],allFontNames, 'k30', 1)
5*14
[h,w] = getBestImageSize([-2 : 2],0,[0:14],allFontNames, 'k28', 1)
[h,w] = getBestImageSize([-2 : 2],0,[0:14],allFontNames, 'k29', 1)
[h,w] = getBestImageSize([-2 : 2],[0 1],[0:14],allFontNames, 'k29', 1)
[h,w] = getBestImageSize([-2 : 2],[0 1],[0:14],allFontNames, 'k28', 1)
[h,w] = getBestImageSize([-3 : 3],[0 1],[0:14],allFontNames, 'k28', 1)
[h,w] = getBestImageSize([-5 : 5],[0 1],[0:14],allFontNames, 'k28', 1)
[h,w] = getBestImageSize([-6 : 6],[0 1],[0:14],allFontNames, 'k28', 1)
[h,w] = getBestImageSize([-5, 0, 5],[0:2:4],[0:2:10],allFontNames, 'k30', 1)
[h,w] = getBestImageSize([-5, 0, 5],[0:2:4],[0:2:10],allFontNames, 'k30', 1); 3*3*6
oris = [-15:5:15]; xs = [0:2:6]; ys = [0:2:10]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); length(oris)*length(xs)*length(ys)
oris = [-15:5:15]; xs = [0:2:6]; ys = [0:2:10]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); [h,w,length(oris)*length(xs)*length(ys)]
oris = [-15:5:15]; xs = [0:2:6]; ys = [0:2:10]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys));
oris = [-15:5:15]; xs = [0:2:6]; ys = [0:2:10]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
2^3
2^4
16*[1:5]
textureAnalysis(randn(80,80), 4,4,7);
textureAnalysis(randn(64,64), 4,4,7);
textureAnalysis(randn(96,96), 4,4,7);
textureAnalysis(randn(80,80), 4,4,7);
textureAnalysis(randn(80,80), 3,4,7);
textureAnalysis(randn(96,96), 4,4,7);
[h,w] = getBestImageSize([-5, 0, 5],[0:4:12],[0:2:10],allFontNames, 'k30', 1); 3*3*6
oris = [-15:5:15]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0:5:15]; ys = [0:5:15]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0:5:20]; ys = [0:5:20]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [0:5:15]; ys = [0:5:15]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [0,5]; ys = [0,5]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit createNoisyLettersDatafile
oris = [-15:5:15]; xs = [0,5]; ys = [0:4:`6]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0,5]; ys = [0:4:16]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0,5]; ys = [0:4:20]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0,4,8]; ys = [0:4:20]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [0,4]; ys = [0:4]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [0,4]; ys = [0,4]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5, 5]; xs = [0,4]; ys = [0,4]; [h,w] = getBestImageSize(oris, xs, ys,allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
[h,w] = getBestImageSize(0,0,0,,allFontNames, 'k30', 1)
[h,w] = getBestImageSize(0,0,0,allFontNames, 'k30', 1)
edit createNoisyLettersDatafile
createNoisyLettersDatafile
%-- 09/12/2015 10:55:24 PM --%
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit plotResults
%-- 09/13/2015 04:58:37 PM --%
edit plotResults
plotResults
edit runIdealObserverTests.m
runIdealObserverTests
edit plotResults
plotResults
letterOpt_use.OriXY
plotResults
edit getNoisyLetterOptsStr.m
plotResults
noisyLetterOpts.trainingFonts
noisyLetterOpts.trainingFontsnoisyLetterOpts.trainingFonts
noisyLetterOpts.trainingFonts
letterOpt_use
plotResults
edit plotResults
plotResults
edit plotResults
plotResults
edit runIdealObserverTests.m
runIdealObserverTests
plotResults
[h_model_pts(plot_i,:), h_human_pts(1:min(end,1)), h_human_line, h_ideal]
h_legend = legend([h_model_pts(plot_i,:), h_human_pts(1:min(end,1)), h_human_line(:)', h_ideal], legend_strs_plot_i, ...
'location', leg_location, 'interpreter', 'none', 'fontsize', legend_fontSize, 'edgecolor', 'w', 'interpreter', 'tex');
human_line_str = cellfun(@(s) ['Human performance (fit) ' s], grouping_data, 'un', 0);
human_line_str = cellfun(@(s) ['Human performance (fit) (' s ')'], grouping_data, 'un', 0);
plotResults
edit createNoisyLettersDatafile
createNoisyLettersDatafile
21*10*10
21*10*1
oris = [-20, 20]; xs = [0:4:20]; ys = [0:4:20]; [h,w] = getBestImageSize(oris, xs, ys,{'Snakes'}, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20, 20]; xs = [0:4:20]; ys = [0:4:20]; [h,w] = getBestImageSize(oris, xs, ys,{'SnakesN'}, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [0:2:18]; ys = [0:2:18]; [h,w] = getBestImageSize(oris, xs, ys,{'SnakesN'}, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:4:20]; xs = [0:4:18]; ys = [0:4:18]; [h,w] = getBestImageSize(oris, xs, ys,{'SnakesN'}, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
length(oris)
edit runIdealObserverTests.m
runIdealObserverTests
clear all
%-- 09/17/2015 10:32:24 AM --%
edit plotResults
plotResults
ylim([0 0.08])
plotResults
ylim([0 0.08])
plotResults
ylim([0 0.08])
plotResults
edit plotResults
plotResults
ylim([0 .2])
ylim([0 .3])
plotResults
edit plotResults
plotResults
ylim([0 .3])
ylim([0 0.08])
edit generateSnakesFonts
generateSnakesFonts
imageToScale([], 3)
imageToScale([], 4)
generateSnakesFonts
plotResults
ylim([0 0.08])
11*5*5
edit createNoisyLettersDatafile
oris = [-20:4:20]; xs = [0:4:16]; ys = [0:4:16]; [h,w] = getBestImageSize(oris, xs, ys,{'SnakesN'}, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
oris = [-20:4:20]; xs = [0:4:16]; ys = [0:4:16]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-10:4:10]; xs = [0:4:16]; ys = [0:4:16]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-10:4:10]; xs = [0:4:8]; ys = [0:4:8]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit createNoisyLettersDatafile
createNoisyLettersDatafile
signal
size(signal)
size( cat(3, signal(:,3,3,0).image) )
size( cat(3, signal(:,3,3,1).image) )
imagesc(tileImages( size( cat(3, signal(:,3,3,1).image) ) ))
clf
imagesc(tileImages( size( cat(3, signal(:,3,3,1).image) ) ))
imagesc(tileImages( cat(3, signal(:,3,3,1).image) ))
imagesc(tileImages( cat(3, signal(:,3,3,1).image) )); imageToScale([], 2)
imagesc(tileImages( cat(3, signal(:,3,3,2).image) )); imageToScale([], 2)
imagesc(tileImages( cat(3, signal(:,3,3,3).image) )); imageToScale([], 2)
imagesc(tileImages( cat(3, signal(:,3,3,4).image) )); imageToScale([], 2)
imagesc(tileImages( cat(3, signal(:,3,3,5).image) )); imageToScale([], 2)
imagesc(tileImages( cat(3, signal(:,3,3,6).image) )); imageToScale([], 2)
imagesc(tileImages( cat(3, signal(:,3,3,7).image) )); imageToScale([], 2)
imagesc(tileImages( cat(3, signal(:,3,3,8).image) )); imageToScale([], 2)
length(0:2:16)
length(0:2:8)
length(0:2:10)
length(0:2:12)
edit createNoisyLettersDatafile
createNoisyLettersDatafile
allSetsToDo(1)
allSetsToDo(1).fontName
abbrevFontStyleNames( allSetsToDo(1).fontName )
abbrevFontStyleNames( allSetsToDo(2).fontName )
abbrevFontStyleNames( allSetsToDo(3).fontName )
createNoisyLettersDatafile
edit runIdealObserverTests.m
edit plotResults
plotResults
edit plotResults
plotResults
fullModel
fullModel.moduleNames
fullModel.modules
fullModel.modules{1}
fullModel.modules{2}
fullModel.modules{3}
fullModel.modules{4}
size(fullModel.modules{4}.weight)
size(fullModel.modules{1}.weight)
size(fullModel.modules{4}.weight)
f = fullModel.modules{4}.weight;
figure
imagesc(tileImages(resize(f, [5 5, 6*16]), 6, 16))
imagesc(tileImages(reshape(f, [5 5, 6*16]), 6, 16))
colormap('gray')
edit runIdealObserverTests.m
edit createNoisyLettersDatafile
edit plotResults
plotResults
find(strcmp(moduleSeq, 'Conv'))
opt_copy = opt; opt_copy.convNetFilterLayer = [];
allModules = loadTrainedModel(letterOpt_use, network_use, trial_i, opt_copy);
fullModel = recreateModel(allModules);
plotResults
setTitles_withoutSize{set_i} = {plotTitle{plot_i}};
setTitles_withoutSize{set_i} = [plotTitle{plot_i}];
plotResults
letterOpt_use
letterOpt_use.trainingFonts
letterOpt_use.trainingFonts.svhn_opts
plotResults
trainingFonts
trainingFonts.svhn_opts
plotResults
letterOpt_use.trainingFonts.svhn_opts
plotResults
letterOpt_use.fontName
abbrevFontStyleNames( letterOpt_use.fontName )
plotResults
all_filterGains_show_C = cellfun(@(x) x(:), all_filterGains_show_C, 'un', 0);
all_filterGains_show_C = cellfun(@(x) x(:)', all_filterGains_show_C, 'un', 0);
all_filterGains_show = [all_filterGains_show_C{:}];
edit plotResults
plotResults
edit createNoisyLettersDatafile
plotResults
ylim([0 0.2])
plotResults
ylim([0 0.2])
plotResults
ylim([0 0.2])
plotResults
x_vals_C = cell(1,3);
x_vals_C(1:3) = zeros(1,3)
x_vals_C(1:3) = {zeros(1,3)}
x_vals_C2(1:3) = {zeros(1,3)}
plotResults
ylim([0 0.2])
ylim([0 0.4])
ylim([0 0.3])
plotResults
edit runIdealObserverTests.m
runIdealObserverTests
plotResults
letterOpt_use.trainingFonts
letterOpt_use.trainingFonts.svhn_opts
edit getNoisyLetterOptsStr.m
plotResults
edit fixConvNetParams
edit plotResults
plotResults
differentTrainTestFonts = opt.trainingFonts && ~strcmp(opt.trainingFonts, 'same') && ~strcmp(abbrevFontStyleNames(opt.trainingFonts), abbrevFontStyleNames(opt.fontName) );
opt.trainingFonts && ~strcmp(opt.trainingFonts, 'same') && ~strcmp(abbrevFontStyleNames(opt.trainingFonts), abbrevFontStyleNames(opt.fontName) )
differentTrainTestFonts = isfield(opt, 'trainingFonts') && ~strcmp(opt.trainingFonts, 'same') && ~strcmp(abbrevFontStyleNames(opt.trainingFonts), abbrevFontStyleNames(opt.fontName) );
plotResults
OriXY = letterOpt_use.OriXY;
plotResults
edit runIdealObserverTests.m
plotResults
edit plotResults
viewAllFontsForOneSize('k20')
viewAllFontsForOneSize('k15')
viewAllFontsForOneSize('k20')
oris = [-10:4:10]; xs = [0:4:8]; ys = [0:4:8]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k20', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit runIdealObserverTests.m
%-- 09/20/2015 04:55:15 AM --%
viewAllFontsForOneSize('k20')
oris = [-15:5:15]; xs = [0:4:8]; ys = [0:4:8]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k20', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
oris = [-15:5:15]; xs = [0:4:8]; ys = [0:4:8]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0:4:8]; ys = [0:4:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit plotResults
(55-5+1)
(55-5+1)/4
(64-4)/4
( (64-4)/4 )-4
(( (64-4)/4 )-4)/4
((3)*4 + 4)*4 + 4
((2)*4 + 4)*4 + 4
(( (64-4)/2 )-4)/2
((13)*2 + 4)*2 + 4
((11)*2 + 4)*2 + 4
((10)*2 + 4)*2 + 4
(( (64-4)/3 )-4)/3
((6)*3 + 4)*3 + 4
((5)*3 + 4)*3 + 4
((4)*3 + 4)*3 + 4
(( (56-4)/2 )-4)/2
3*6*7
2*2*3
[0:4:20]/2
oris = [-15:5:15]; xs = [0:2:4]; ys = [0:2:10]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
runIdealObserverTests
edit plotResults
plotResults
axis auto
axis normal
plotResults
2*2*3
plotResults
3*6*7
plotResults
[-15:5:15]
length([-15:5:15])
length([-20:4:20])
length([-20:2:20])
createNoisyLettersDatafile
edit plotResults
plotResults
[h,w] = getBestImageSize(0,0,0,allFontNames, 'k15', 1)
allFontNames
[h,w] = getBestImageSize(0,0,0,allFontNames, 'k15', 1)
[a,b] = loadLetters('Bookman', 'k15')
b
sprintf('%.6f', now)
extractFontFromPNG
extractFontFromPNG('Bookman')
clf
close(2)
extractFontFromPNG('Bookman')
[a,b] = loadLetters('Bookman', 'k15')
[a,b] = loadLetters('Bookman', 'k15');
b
extractFontFromPNG
edit plotResults
plotResults
extractFontFromPNG
plotResults
edit createNoisyLettersDatafile
extractFontFromPNG
isfield(S_fonts, font_fld_curFontSize_italic)
deslantLettersNow = strcmp(rawFontName, 'Kuenstler') && fontName(end) == 'I' && opt.useDeslantedKuenstlerAsItalic;
if deslantLettersNow
fontAttrib_nonItalic = fontAttrib.italic_tf;
fontAttrib_nonItalic.italic_tf = 0;
fontName_nonItalic = getFullFontName(rawFontName, fontAttrib_nonItalic);
font_descrip = sprintf('%s_%02d', fontName_nonItalic, fontSize);
end
fontAttrib_nonItalic = fontAttrib;
fontAttrib_nonItalic.italic_tf = 0;
fontName_nonItalic = getFullFontName(rawFontName, fontAttrib_nonItalic);
fontAttrib_nonItalic = fontAttrib;
fontAttrib_nonItalic.italic_tf = 0;
fontName_nonItalic = getFullFontName(rawFontName, fontAttrib_nonItalic);
font_descrip = sprintf('%s_%02d', fontName_nonItalic, fontSize);
fontName_save = fontName; % [rawFontName, upper_str, bold_str, italic_str];
%     file_ext = '.bmp';
file_fullname = [fontsFolder font_descrip file_ext];
allLetters_raw = extractLettersFromImageFile(file_fullname, opt);
extractFontFromPNG
fontName_nonItalic = getFullFontName(rawFontName, fontAttrib_nonItalic);
clear all
extractFontFromPNG
edit extractFontFromPNG.m
sprintf('%.6f', now)
extractFontFromPNG
clear all
extractFontFromPNG
clear all
extractFontFromPNG
createFontSizesFile
extractFontFromPNG
generateSnakesFonts
edit generateSnakesFonts
generateSnakesFonts
createFontSizesFile
edit createNoisyLettersDatafile
length([-45:5:45])
length([-90:5:90])
length([-60:5:60])
length([-30:5:30])
45/4
45/3
180/30
length([-45:5:45])
length([-30:5:30])
createNoisyLettersDatafile
close all
edit generateCheckersFonts
generateSnakesFonts
generateCheckersFonts
close(12)
generateCheckersFonts
[a,b] = loadLetters('SnakesN', 'k32');
createFontSizesFile
generateCheckersFonts
S = loadLetters
createFontSizesFile
loadLetters('save')
37*5
25*5
[h,w] = getBestImageSize(0,0,0,allFontNames, 'k15', 1)
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
edit getBestImageSize.m
oris = [-90:5:90]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0:90]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0:80]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0,75]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0,45]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit getBestImageSize.m
oris = [0,45]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
plotResults
convNetworkScale
showConvNetDiagram
convNetworkScale
3 x 3
convNetworkScale
%-- 09/25/2015 12:24:26 PM --%
edit convNetworkScale
convNetworkScale
512*4*4
convNetworkScale
512*4*4
im_gray_enlarged = fourierInterpImage(single(im_gray), 'mult', scaleFactor);
convNetworkScale
(70000*64*64*8)/(1024^2)
round( (70000*64*64*8)/(1024^2) )
edit createNoisyLettersDatafile
plotResults
createNoisyLettersDatafile
im_size = [32, 32]
opt_gray = struct('imageSize', im_size);
[gray_fileBase, gray_path] = getSVHNdataFile(opt_gray);
gray_fileName = [gray_path, gray_fileBase];
opt_gray = struct('imageSize', im_size(1));
[gray_fileBase, gray_path] = getSVHNdataFile(opt_gray);
gray_fileName = [gray_path, gray_fileBase];
edit getNoisyLetterOptsStr.m
edit createNoisyLettersDatafile
createNoisyLettersDatafile
which createNoisyLettersDatafile.m
delete createNoisyLettersDatafile.m
which createNoisyLettersDatafile.m
createNoisyLettersDatafile
edit plotResults
createNoisyLettersDatafilealse
createNoisyLettersDatafile
setToSave
generateSVHNTextureDataFiles
[h, w, n3, nSamples] = size(S_im.inputMatrix);
assert(n3 == 3);
[h, w, nSamples] = size(S_im.inputMatrix);
nTex = nTextureStatisticsForParams(N, M, K, 1)
nTexParams = nTextureStatisticsForParams(N, M, K, 1)
[h, w, nSamples] = size(S_im.inputMatrix);
nTexParams = nTextureStatisticsForParams(N, M, K, 1);
X_texture = zeros(nTexParams,1, nSamples, 'single');
si = 1
xi_image = S_im.inputMatrix(:,:,si);
xi_texture = textureAnalysis(xi_image, N, M, K);
xi_image = double( S_im.inputMatrix(:,:,si) );
xi_texture = textureAnalysis(xi_image, N, M, K);
xi_texture_vec = textureStruct2vec(xi_texture);
xi_texture_vec = textureStruct2vec(xi_texture, [], 1);
edit generateSetOfLetters.m
[textureStatistics_vector, idx_textureStats_use_i] = textureStruct2vec(xi_texture, [], 1);
xi_texture_vec = textureStruct2vec(xi_texture, idx_textureStats_use, 1);
[textureStatistics_vector, idx_textureStats_use] = textureStruct2vec(xi_texture1, [], 1);
xi_image1 = double( S_im.inputMatrix(:,:,1) );
xi_texture1 = textureAnalysis(xi_image1, Nscl, Nori, Na);
[textureStatistics_vector, idx_textureStats_use] = textureStruct2vec(xi_texture1, [], 1);
textureSettings = allTextureSettings{txt_i};
Nscl = textureSettings.Nscl_txt;
Nori = textureSettings.Nori_txt;
Na = textureSettings.Na_txt;
xi_image1 = double( S_im.inputMatrix(:,:,1) );
xi_texture1 = textureAnalysis(xi_image1, Nscl, Nori, Na);
[textureStatistics_vector, idx_textureStats_use] = textureStruct2vec(xi_texture1, [], 1);
generateSVHNTextureDataFiles
convertSVHNtoGrayscale
generateSVHNTextureDataFiles
S_text.inputMatrix = X_texture;
S_text.labels = single(S_im.labels);
S_text.nClasses = 10;
S_text.xs = 0;
S_text.ys = 0;
S_text.orientations = 0;
save(svhn_texture_fileName, '-struct', 'S_text');
generateSVHNTextureDataFiles
plotResults
allNetworks(1)
plotResults
allNetworks(1)
plotResults
convNetworkScale
edit convNetworkScale
convNetworkScale
n_pool_h_cover_ext =   (nOut_pool_h(layer_i) - 1) * strides(layer_i) + poolsizes(layer_i);
n_pool_w_cover_ext =   (nOut_pool_w(layer_i) - 1) * strides(layer_i) + poolsizes(layer_i);
convNetworkScale
edit convertSVHNtoGrayscale;
convertSVHNtoGrayscale; generateSVHNTextureDataFiles
sprintf('%.6f', now)
convertSVHNtoGrayscale; generateSVHNTextureDataFiles
plotResults
%-- 09/30/2015 12:30:30 AM --%
datestr(now)
%-- 10/02/2015 12:46:49 PM --%
profilePath('load', 'CatV1Exp')
edit mid_generateSpikeFile
mid_generateSpikeFile('all')
cd(CatV1Path)
mid_generateSpikeFile('all')
S = load(spkFileName)
fileId = fopen(spkFileName, 'r');
spksPerFrame_uint8 = fread(fileId);
mid_generateSpikeFile('all')
spkFileName = mid_getSpikeFileName(Gid, cellId, windowMode, trialMode, frameMode, responseType);
mid_generateSpikeFile('all')
edit mid_findMostInfoDim.m
gatherMIDs
edit gatherMIDs
responseType = curResponseType('')
edit curResponseType
responseTypeStr = getResponseTypeStr(curResponseType, 1)
gatherMIDs
profilePath('load', 'nyu')
cd(lettersPath)
cd(lettersCodePath)
edit plotResults
plotResults
convNetworkScale
edit convNetworkScale
convNetworkScale
20/1.5
15*1.5
16*1.5
convNetworkScale
viewAllFontsForOneSize('k15')
[0, 4, 8, 12]
[0:2:12]
21*3*7
21*3*7*4
21*3*7*4*5
convNetworkScale
edit createNoisyLettersDatafile
oris = [-20:2:20]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
oris = [-20:2:20]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
edit runIdealObserverTests.m
56*56 / 64*64
(56*56) / (64*64)
1/ ((56*56) / (64*64) )
41*44
45*49
(45*49)/(56*56)
47/56
(45*49)/(64*64)
runIdealObserverTests
oris = [-20:2:20]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
242*1.3
242*1.3*2
22^2+14^2+9^2
sqrt(22^2+14^2+9^2)
edit plotResults
plotResults
runIdealObserverTests
plotResults
close all
plotResults
oris = [0]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:2:4]; ys = [0:2:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:2:4]; ys = [0:2:6]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
viewAllFontsForOneSize('x30')
viewAllFontsForOneSize('x25')
viewAllFontsForOneSize('x20')
S = load('SVHN_test_32x32_gray.mat');
S
figure;
imagesc( tileImages( S.inputMatrix(:,:,1:100)));
imagesc( tileImages( S.inputMatrix(:,:,1:100))); colormap('gray'); imageToScale
viewAllFontsForOneSize('x20')
imageToScale
imagesc( tileImages( S.inputMatrix(:,:,randi(20000, 1,100))); colormap('gray'); imageToScale
imagesc( tileImages( S.inputMatrix(:,:,randi(20000, 1,100)))); colormap('gray'); imageToScale
imagesc( tileImages( S.inputMatrix(:,:,randi(20000, 1,100)))); colormap('gray'); imageToScale([], 2)
imageToScale([], 2)
imageToScale([], 4)
viewAllFontsForOneSize('x30')
imageToScale([], 4)
imageToScale([], 2)
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
26/20
26/20 * 2
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x30', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
28/20 * 2
3/20 * 2
30/20 * 2
oris = [0]; xs = [0:5]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:1]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:5]; ys = [0:4]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:6]; ys = [0:4]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:8]; ys = [0:4]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
28/20 * 2
26/20 * 2
edit plotResults
plotResults
oris = [0]; xs = [0:4]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit createNoisyLettersDatafile
5*13
oris = [0]; xs = [0:4]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:10]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
oris = [0]; xs = [0:10]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:10]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:2:10]; ys = [0:2:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:10]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:4]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:50]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 2); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 2); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
[64,64]-[26,34]
oris = [0]; xs = [0:30]; ys = [0:38]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 2); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
log10([65, 1209])
log2([65, 1209])
2.^[6:10]
round( [5,13]*sqrt(2) )
7*18
round( [5,13]*2 )
round( [5,13]*2*sqrt(2) )
14*37
round( [5,13]*2*2 )
createNoisyLettersDatafile
runIdealObserverTests
allLetterOpts(1)
allLetterOpts(2)
allLetterOpts = expandOptionsToList( allLetterOpts_S, {'OriXY', 'fontName'} );
allLetterOpts(2)
allLetterOpts(1)
allLetterOpts(2)
runIdealObserverTests
oris = [0]; xs = [0:10]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
viewAllFontsForOneSize('x26')
viewAllFontsForOneSize('x28')
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x28', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
[64,64]-[54,52]
edit createNoisyLettersDatafile
oris = [0]; xs = [0:11]; ys = [0:9]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:12]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:12]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 2); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:10]; ys = [0:8]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 2); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:12]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
4*sqrt(2)
32
sqrt(32)
5*6
38/30
viewAllFontsForOneSize('x28')
viewAllFontsForOneSize('k30')
28/21 * 2
viewAllFontsForOneSize('k28')
viewAllFontsForOneSize('k38')
viewAllFontsForOneSize('k28')
viewAllFontsForOneSize('x28')
viewAllFontsForOneSize('k38')
26/21 * 2
viewAllFontsForOneSize('k26')
viewAllFontsForOneSize('x26')
viewAllFontsForOneSize('k38')
viewAllFontsForOneSize('k30')
viewAllFontsForOneSize('x20')
viewAllFontsForOneSize('k30')
viewAllFontsForOneSize('k38')
viewAllFontsForOneSize('x26')
[ptSize, kHeight, xHeight] = getFontSize('Bookman', 'k28')
edit getFontSize.m
[ptSize, xHeight, kHeight] = getFontSize('Bookman', 'k28')
[ptSize, xHeight, kHeight] = getFontSize('Bookman', 'x26')
[ptSize, xHeight, kHeight] = getFontSize('Bookman', 'k36')
26*1.5
oris = [0]; xs = [0:12]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'x26', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
26/21 * 2
26/20 * 2
[ptSize, xHeight, kHeight] = getFontSize('Bookman', 'k30')
edit plotResults
letterSizeUse = 'k30';
%             fontNameUse = letterOpt_use.fontName;
fontNameUse = 'Bookman';
[fontPointSize, fontXheight, fontKheight] = getFontSize(fontNameUse, letterSizeUse);
26/20 * 2.3
createNoisyLettersDatafile
all_SNRs_norm
-1:.5:5
length(-1:.5:5)
createNoisyLettersDatafile
13*9
13*11
edit createNoisyLettersDatafile
createNoisyLettersDatafile
allSetsToDo(1)
allSetsToDo(1).noiseFilter
allSetsToDo(1).noiseFilter.cycPerLet_centFreq
allSetsToDo(2).noiseFilter.cycPerLet_centFreq
allSetsToDo(3).noiseFilter.cycPerLet_centFreq
oris = [0]; xs = [0:12]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesOf60', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:12]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
S_fonts
edit generateSnakesFonts
generateSnakesFonts
edit loadLetters.m
createFontSizesFile
edit createFontSizesFile
oris = [0]; xs = [0:12]; ys = [0:10]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
[64,64]-[39,39]
25*25
edit createNoisyLettersDatafile
16*16
oris = [0]; xs = [0:24]; ys = [0:24]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:23]; ys = [0:23]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
22*22
23*23
oris = [0]; xs = [0:23]; ys = [0:23]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 4); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:23]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 3); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 3); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:21]; ys = [0:21]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 3); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
datestr(735865.504580)
sprintf('%.6f', now)
sprintf('%.6f', 736248.540042)
datestr(736248.540042)
datestr(736218.540042)
datestr(736210.540042)
createNoisyLettersDatafile
allSetsToDo(1).fontName
allSetsToDo(1).fontName.wiggles
allSetsToDo(2).fontName.wiggles
createNoisyLettersDatafile
allSetsToDo(1).fontName.wiggles
allSetsToDo(2).fontName.wiggles
lock_removeMyLocks
runIdealObserverTests
33*22
22*22
edit createNoisyLettersDatafile
oris = [0]; xs = [0:21]; ys = [0:21]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:21]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:30]; ys = [0:30]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
runIdealObserverTests
%-- 10/12/2015 03:33:01 PM --%
edit getSVHNOptsStr.m
edit generateSVHNTextureDataFiles.m
generateSVHNTextureDataFiles.m
generateSVHNTextureDataFiles
convertSVHNtoGrayscale
edit getNoisyLetterOptsStr.m
plotResults
names_orig.svhn_opts
plotResults
generateSVHNTextureDataFiles
edit testIdealObserver.m
generateSVHNTextureDataFiles
S = load('SVHN_test_32x32_gray.mat');
S
im1 = double(S.inputMatrix(:,:,1));
textureAnalysis(im1, 3,4,7);
v1 = textureStruct2vec(im1, [], 1);
s1 = textureAnalysis(im1, 3,4,7);
v1 = textureStruct2vec(s1, [], 1);
plot(v1)
plot( abs(log10(v1) )
plot( abs(log10(v1) ) )
Sn = load('SVHN_test_32x32_gray_gnorm.mat');
im2 = double(Sn.inputMatrix(:,:,1));
s2 = textureAnalysis(im2, 3,4,7);
v2 = textureStruct2vec(s2, [], 1);
hold on
plot( abs(log10(v2) ), 'r' )
figure
imagesc(im1)
colorma('gray');
colormap('gray');
imagesc(im2)
imagesc(im1)
edit testIdealObserver.m
St_l = load('SVHN_test_32x32_gray_gnorm_lcnorm_N3_K4_M7.mat')
St = load('SVHN_test_32x32_gray_gnorm_N3_K4_M7.mat')
figure
plot( abs(log10( St.inputMatrix(:,1,1) ) ) )
hold on
plot( abs(log10( St_l.inputMatrix(:,1,1) ) ), 'r' )
Si = load('SVHN_test_32x32_gray_gnorm.mat')
Si_l = load('SVHN_test_32x32_gray_gnorm_lcnorm.mat')
figure
imagesc(Si.inputMatrix(:,:,1))
colormap('gray');
imagesc(Si_l.inputMatrix(:,:,1))
s_i = textureStruct2vec( textureAnalysis(Si.inputMatrix(:,:,1), 3,4,7), [], 1);
s_i_l = textureStruct2vec( textureAnalysis(Si_l.inputMatrix(:,:,1), 3,4,7), [], 1);
figure
plot( abs(log10( s_i ) ), 'b' );
hold on
plot( abs(log10( s_i_l ) ), 'r' );
edit generateSVHNTextureDataFiles.m
edit generateSVHNTextureDataFiles
generateSVHNTextureDataFiles
sprintf('%.6f', 736248.540042)
generateSVHNTextureDataFiles
fprintf('\nMatlab texture file (%s : %s) is older than cutoff(%s)\n', ...
svhn_texture_fileName, datestr( filedate(svhn_texture_fileName)), datestr(redoIfOlderThan) )
fprintf('\nMatlab texture file (%s : %s) is older than matlab image file (%s:%s) \n', ...
svhn_texture_fileName, datestr( filedate(svhn_texture_fileName)), svhn_image_fileName,  datestr(filedate(svhn_image_fileName) ) );
fprintf('\nMatlab texture file (%s : %s) is older than matlab image file (%s:%s) \n', ...
svhn_texture_fileName, datestr( filedate(svhn_texture_fileName)), svhn_image_fileName,  datestr(filedate(svhn_image_fileName) ) );
fprintf('\nMatlab texture file (%s : %s)\n is older than matlab image file (%s:%s) \n', ...
svhn_texture_fileName, datestr( filedate(svhn_texture_fileName)), svhn_image_fileName,  datestr(filedate(svhn_image_fileName) ) );
generateSVHNTextureDataFiles
fprintf('\nMatlab texture file (%s : %s)\n is older than matlab image file (%s:%s) \n', ...
svhn_texture_fileName, datestr( filedate(svhn_texture_fileName)), svhn_image_fileName,  datestr(filedate(svhn_image_fileName) ) );
datestr( filedate(svhn_texture_fileName))
exist(svhn_texture_fileName, 'file')
datestr(filedate(svhn_image_fileName)
datestr(filedate(svhn_image_fileName))
edit runIdealObserverTests.m
runIdealObserverTests
edit plotResults
plotResults
5*13
7*18
oris = [0]; xs = [0:4]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, 'Bookman', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'}
oris = [0]; xs = [0:4]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
plotResults
generateSVHNTextureDataFiles
Sorig = load('train_32x32')
size(Sorig.X)
load('SVHN_test_32x32_gray.mat')
edit convertSVHNtoGrayscale
convertSVHNtoGrayscale
load('SVHN_test_32x32_gray.mat')
size(inputMatrix)
convertSVHNtoGrayscale
sprintf('%.6f', 736248.540042)
sprintf('%.6f', now)
convertSVHNtoGrayscale
load('SVHN_test_32x32_gray.mat')
size(inputMatrix)
figure; imagesc(inputMatrix(:,:,1,1))
colormap('gray');
sprintf('%.6f', now)
convertSVHNtoGrayscale
S = load('Bookman_k15-1oxy-[64x64]-10SNR.mat')
S = load('Bookman_k15-1oxy-[64x64]-40SNR.mat')
S = load('Bookman_k30-1oxy-[64x64]_Nband5N-30SNR.mat')
imagesc(S.inputMatrix(:,:,1))
imageToScale
sprintf('%.6f', now)
load('SVHN_test_32x32_gray.mat')
figure
convertSVHNtoGrayscale
sprintf('%.6f', now)
convertSVHNtoGrayscale
sprintf('%.6f', now)
convertSVHNtoGrayscale
edit generateSVHNTextureDataFiles
generateSVHNTextureDataFiles
load('SVHN_train_32x32_gray_gnorm.mat')
plotResults
edit plotResults
plotResults
edit tmp_renameFilesInFolder.m
plotResults
getOriXYStr(USet)
plotResults
axis auto
plotResults
edit plotResults
plotResults
clf
plotResults
ylim
ylim auto
set(gca, 'ytickLabelMode', 'auto')
setLogAxesDecimal
set(gca, 'yTickMode', 'auto')
set(gca, 'ytickLabelMode', 'auto')
edit createNoisyLettersDatafile
plotResults
clf
plotResults
5*13
plotResults
viewAllFontsForOneSize('k36')
plotResults
ylim auto
edit createNoisyLettersDatafile
15*15
0:14
0:2:14
1:2:15
createNoisyLettersDatafile
runIdealObserverTests
120*4
120*8
generateSVHNTextureDataFiles
edit createNoisyLettersDatafile
createNoisyLettersDatafile
allSetOptions(1)
allSetsToDo(1)
allSetsToDo(1).noiseFilter
allSetsToDo(2).noiseFilter
createNoisyLettersDatafile
allSetsToDo(2).noiseFilter
allSetsToDo(1).noiseFilter
createNoisyLettersDatafile
allSetsToDo(1).noiseFilter
allSetsToDo(2).noiseFilter
createNoisyLettersDatafile
edit generateSVHNTextureDataFiles
%-- 10/15/2015 12:36:42 AM --%
S = randn(32,32);
x = randn(32,32);
t = textureAnalysis(x, 3,4,7);
v = textureStruct2vec(t, [], 1);
edit createNoisyLettersDatafile
createNoisyLettersDatafile
v2 = textureStruct2vec(t);
createNoisyLettersDatafile
X = randn(64, 64)
X = randn(64, 64);
T = textureAnalysis(X, 3,4,7);
t
T
size(t.autoCorrMag)
size(T.autoCorrMag)
v = textureStruct2vec(t, [], 1);
V = textureStruct2vec(T, [], 1);
edit textureStruct2vec
nTextureStatisticsForParams(3,4,7)
nTextureStatisticsForParams(3,4,7, 1)
Vr = textureStruct2vec(T);
vr = textureStruct2vec(t);
v = textureStruct2vec(t, [], 1);
Sv.autoCorrReal
S = ones(32,32);
x1 = ones(32,32);
t1 = textureAnalysis(x1);
t1 = textureAnalysis(x1, 3, 4, 7);
t1
v1 = textureStruct2vec(t1);
x1 = reshape(1:(32*32), 32, 32);
t1 = textureAnalysis(x1, 3, 4, 7);
v1 = textureStruct2vec(t1, [], 1);
T = textureAnalysis(X, 3,4,7);
V = textureStruct2vec(T, [], 1);
V = textureStruct2vec(T, [], 1, [32, 32]);
V = textureStruct2vec(T, [], 1, [64, 64]);
V = textureStruct2vec(T, [], 1, [32, 32]);
[V, idx_use] = textureStruct2vec(T, [], 1, [32, 32]);
[V, idx_use] = textureStruct2vec(T, [], 1, [64, 64]);
edit createNoisyLettersDatafile
createNoisyLettersDatafile
fprintf('   => Saving Noisy Image data to : %s (%d inputs of size %dx%d) ... ', filename_image_base, size(setToSave, 3), size(setToSave,1), size(setToSave,2) )
sz = size(setToSave.inputMatrix);
fprintf('   => Saving Noisy Image data to : %s (%d inputs of size %dx%d) ... ', filename_image_base, sz(3), sz(1), sz(2) )
sprintf('%.6f', now)
64*64
64*64*10000
(64*64*10000)/1024^2
(32*32*10000)/1024^2
edit generateSVHNTextureDataFiles
edit plotResults
plotResults
preferredFileName_NYU
exist(preferredFileName_NYU)
preferredFileName_NYU
ls NoisyLettersTextureStats_Bookman-k36_SNR1h3__1oxy-[64x64]_tr32x32_trfSVHN_Nband5N_N4_K4_M7_rtLin-2__MLP_120.mat
ls NoisyLettersTextureStats_Bookman-k36_SNR1h3__1oxy*
plotResults
ylim([.1 1e5])
ylim([1 1e5])
ylim([1 1e4])
ylim([.1 1e3])
ylim([.1 2e3])
axis auto normal
plotResults
edit convertSVHNtoGrayscale
doc padarray
generateSVHNTextureDataFiles
allSvhnOpts
allSvhnOpts(1)
allSvhnOpts{1}
allSvhnOpts{2}
generateSVHNTextureDataFiles
allSvhnOpts{1}
allSvhnOpts{2}
generateSVHNTextureDataFiles
displayOptions(allSvhnOpts_tbl)
generateSVHNTextureDataFiles
[textureStatistics_vector, idx_textureStats_use] = textureStruct2vec(xi_texture1, [], 1);
generateSVHNTextureDataFiles
figure
imagesc(xi_image)
colormap('gray');
imageToScale
imagesc(xi_image); imageToScale;
imageToScale
generateSVHNTextureDataFiles
imagesc(im_gray); imageToScale;
imagesc(im_gray_enlarged); imageToScale;
figure
imagesc( mean(S_im.inputMatrix,3) )
colormap('gray');
colorbar
imagesc( median(S_im.inputMatrix,3) )
colorbar
mean(S_im.inputMatrix(:))
generateSVHNTextureDataFiles
imagesc(im_gray); imageToScale;
imagesc(im_gray_enlarged); imageToScale;
colorbar
imagesc(im_gray_enlarged); colorbar; imageToScale;
generateSVHNTextureDataFiles
imagesc(im_gray_enlarged); colorbar; imageToScale;
which padding
which pade
imagesc(im_gray_enlarged); colorbar; imageToScale;
generateSVHNTextureDataFiles
imagesc(im_gray_enlarged); colorbar; imageToScale;
generateSVHNTextureDataFiles
edit createNoisyLettersDatafile
createNoisyLettersDatafile
sprintf('%.6f', now)
createNoisyLettersDatafile
allSetsToDo(1).noiseFilter
allSetsToDo(2).noiseFilter
allSetsToDo(4).noiseFilter
allSetsToDo(1)
allSetsToDo(1).textureSettings
allSetsToDo(2).textureSettings
edit expandOptionsToList.m
expandOptionsToList(  struct('tbl_AA', {11,12}, 'tbl_BB', {21,22}, 'tbl_CC', {31, 32} }, {'', 'AA'} )
expandOptionsToList(  struct('tbl_AA', {11,12}, 'tbl_BB', {21,22}, 'tbl_CC', {31, 32}), {'', 'AA'} )
expandOptionsToList(  struct('tbl_AA', {{11,12}}, 'tbl_BB', {{21,22}}, 'tbl_CC', {{31, 32}}), {'', 'AA'} )
S = expandOptionsToList(  struct('tbl_AA', {{11,12}}, 'tbl_BB', {{21,22}}, 'tbl_CC', {{31, 32}}), {'', 'AA'} ); arrayfun(@display, S);
S
S(1)
S(:)
display(S(1))
x = [display(S(1))]
[display(S(1)); fprintf('\n')]
tostring(S(1))
S = expandOptionsToList(  struct('tbl_AA', {{11,12}}, 'tbl_BB', {{21,22}}, 'tbl_CC', {{31, 32}}), {'', 'AA'} ); arrayfun(@(x) fprintf('%s\n', tostring(x)), S);
edit expandOptionsToList.m
S = expandOptionsToList(  struct('tbl_AA', {{11,12}}, 'tbl_BB', {{21,22}}, 'tbl_CC', {{31, 32}}), {'', 'AA'} ); arrayfun(@(x) fprintf('%s\n', tostring(x)), S);
S = expandOptionsToList(  struct('tbl_AA', {{11,12}}, 'tbl_BB', {{21,22}}, ), {'', 'AA'} ); arrayfun(@(x) fprintf('%s\n', tostring(x)), S);
S = expandOptionsToList(  struct('tbl_AA', {{11,12}}, 'tbl_BB', {{21,22}} ), {'', 'AA'} ); arrayfun(@(x) fprintf('%s\n', tostring(x)), S);
S = expandOptionsToList(  struct('tbl_AA', {{11,12}}, 'tbl_BB', {{21,22}} ), {'AA', 'BB'} ); arrayfun(@(x) fprintf('%s\n', tostring(x)), S);
edit createNoisyLettersDatafile
%-- 10/15/2015 09:50:34 PM --%
edit getSVHNOptsStr.m
edit plotResults
plotResults
axis auto normal
plotResults
axis auto normal
edit expandOptionsToList.m
72/8
%-- 10/16/2015 09:22:25 AM --%
edit plotResults
plotResults
edit plotResults
plotResults
allTrainingFonts(1)
allTrainingFonts(2)
allTrainingFonts(2).svhn_opts
allTrainingFonts(3).svhn_opts
plotResults
edit plotResults
[layerStr, num] = stringAndNumber('linear1');
[layerStr, num] = stringAndNumber('linear1')
[layerStr, num] = stringAndNumber('linear-1')
[layerStr, num] = stringAndNumber('linear-2')
plotResults
expSubtitle = getExpSubtitle(letterOpts, network, trial_i);
noisyLetterOpts.retrainFromLayer
plotResults
axis auto normal
plotResults
axis auto normal
plotResults
=11*20000
11*20000
11*2000
5*8000
edit plotResults
plotResults
axis auto normal
edit createNoisyLettersDatafile
edit plotResults
edit createNoisyLettersDatafile
createNoisyLettersDatafile
datestr(736252.049851)
datestr(736210.540042)
edit plotResults
plotResults
edit plotResults
plotResults
[ptsize, kheight, xheight] = getFontSize('Bookman', 'x28')
[ptsize, kheight, xheight] = getFontSize('Bookman', 'k36')
plotResults
edit plotResults
plotResults
edit plotResults
plotResults
%-- 11/03/2015 09:46:14 PM --%
plotResults
28 * 12
336/120
52*5
336 / 260
(336 / 260)/8
336 / 10
4*52*2
75728 / 416
72197 / 416
%-- 11/04/2015 09:34:36 PM --%
edit createNoisyLettersDatafile
createNoisyLettersDatafile
sec2hms(160*13*120)
sec2hms(160*13*120/20)
sec2hms(160*13*120/40)
sec2hms(160*13*120/43)
sec2hms(160*13*120/53)
sec2hms(160*13*120/43)
edit createNoisyLettersDatafile
edit createCrowdedLettersDatafile.m
%-- 11/04/2015 11:03:01 PM --%
edit createNoisyLettersDatafile
edit runIdealObserverTests.m
runIdealObserverTests
dbquit
createNoisyLettersDatafile
dbquit
createNoisyLettersDatafile
Cr = S.crowdingSettings;
num2str(Cr.trainPositions)
num2str([1 2])
createNoisyLettersDatafile
hashvariable(crowdingSettings)
createNoisyLettersDatafile
edit getCrowdedLetterOptsStr.m
edit getCrowdedLetterFileName.m
createNoisyLettersDatafile
dbquit
edit getNoisyLetterOptsStr.m
edit getLetterOptsStr
edit getNoisyLetterOptsStr.m
edit getCrowdedLetterOptsStr.m
createNoisyLettersDatafile
-16:12:176
createNoisyLettersDatafile
edit testIdealObserver.m
createNoisyLettersDatafile
edit plotResults
plotResults
ylim([0 .03])
edit plotResults
plotResults
ylim([0 .05])
plotResults
ylim([0 .05])
edit plotResults
plotResults
edit makePlots.m
makePlots
edit createNoisyLettersDatafile
-16:12:176
length(-16:12:176)
textureAnalysis(randn(32, 160), 3, 4, 7);
createNoisyLettersDatafile
testing_filename = getFileName(fontNameStr, logSNR, noisy_letter_opts_image);
createNoisyLettersDatafile
exist([noisyLettersPath_thisFont testing_filename], 'file')
createNoisyLettersDatafile
assert(isequal(textureVec_full(idx_use), nonnans(textureVec)));
createNoisyLettersDatafile
figure
imagesc(signal(1).image)
skew( zeros(1,100) )
kurtosis ( zeros(1,100) )
edit textureAnalysis.m
kurt2( zeros(1,100) )
createNoisyLettersDatafile
profile on
createNoisyLettersDatafile
profile viewer
createNoisyLettersDatafile
450/.9
plotResults
edit makePlots.m
makePlots
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit plotResults
%-- 11/05/2015 01:41:57 PM --%
edit plotResults
plotResults
edit plotResults
plotResults
edit plotResults
plotResults
NoisyLetters_Bookman-k15_SNR1h3__[32x160]_tr32x32_trfSVHN_rtLin1__x-16-12-176_T9__2let_d24_DNR29_trT3t15__Conv_f16_64_512_F120_fs5_5_3_psz2_2_2_ptMAX__SGD_m95.mat
plotResults
vector(1:4)
x_vals_C{plot_i} = [vector(x_vals_C{plot_i}); vector(x_vals_C{plot_i}(end) + dx*[1:extendSpacingN]')];
plotResults
axis auto normal
edit createNoisyLettersDatafile
viewAllFontsForOneSize('k15')
oris = [0]; xs = [0:4]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allFontNames = {'Bookman'};
oris = [0]; xs = [0:4]; ys = [0:12]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:12:160]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [-12:12:176]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
-16:12:176
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
-16:12:176
length(-16:12:176)
length(3:15)
length(8:3:152)
length(8:2:152)
length(8:3:152)
1:3:6
1:3:7
0:3:6
length(12:3:148)
logspace(3,45,6)
logspace(log10(3),log10(45),6)
logspace(log10(3),log10(45),7)
3* 2.^[0:.5:3]
3* 2.^[0:.5:4]
edit plotResults
plotResults
ylim
ylim auto
plotResults
ylim([.1 1])
ylims = [.1 1]
edit createNoisyLettersDatafile
createNoisyLettersDatafile
allFontNames = {'SnakesN'};
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:21]; ys = [0:21]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-6:2:6]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-6:3:6]; xs = [0:20]; ys = [0:20]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit plo
edit plotResults
plotResults
edit plotResults
plotResults
7*18
7*18 * 26
plotResults
5*5
4*4
allFontNames = {'Bookman'};
oris = [0]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5, 0, 5]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};
oris = [-5, 0, 5]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit generateSnakesFonts
generateSnakesFonts
imageToScale([], 1)
imageToScale([], 2)
imageToScale([], 3)
edit createNoisyLettersDatafile
[ptsize, kheight, xheight] = getFontSize('Bookman', 'k15')
[ptsize, kheight, xheight] = getFontSize('Bookman', 'k24')
[ptsize, xheight, kheight] = getFontSize('Bookman', 'k24')
[ptsize, xheight, kheight] = getFontSize('Bookman', 'x24')
[ptsize, xheight, kheight] = getFontSize('Bookman', 'k24')
oris = [-5, 0, 5]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-30:5:30]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:7]; ys = [1:17]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:7]; ys = [1:17]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:7]; ys = [1:17]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:7]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k24', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
edit runIdealObserverTests.m
runIdealObserverTests
length(-15 : 3 : 15)
length(-20 : 3 : 20)
length(-20 : 4 : 20)
edit createNoisyLettersDatafile
allFontNames = {'Bookman'};
oris = [0]; xs = [1:4]; ys = [1:4]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k36', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [1:4]; ys = [1:4]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k36', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:4]; ys = [1:4]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k36', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:4]; ys = [1:4]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k36', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
length(-15 : 5 : 15)
length(-5 : 1 : 5)
createNoisyLettersDatafile
allFontNames = {'SnakesN'};
oris = [0]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-10:1:10]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:1:5]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:4:20]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
length([-15:5:15])
length([-20:2:20])
length([-5:1:5])
runIdealObserverTests
createNoisyLettersDatafile
runIdealObserverTests
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
length([-15:3:15])
length([-20:4:20])
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
[1  : 3 : 3*3]
oris = [0:]; xs = [0:3:45*3]; ys = [1]; [h,w] = getBestImageSize(oris, xs, ys, {'Bookman', 'Sloan', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:3:45*3]; ys = [1]; [h,w] = getBestImageSize(oris, xs, ys, {'Bookman', 'Sloan', 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [0:3:45*3]; ys = [1]; [h,w] = getBestImageSize(oris, xs, ys, {'Bookman', 'Sloan'}, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:3:45*3]; ys = [1]; [h,w] = getBestImageSize(oris, xs, ys, {'Bookman', 'Sloan'}, 'k15', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
45/3
3* 2.^[0:.5:4]
3* 2.^[0:.4:4]
3* 2.^[0:.7:4]
3* 2.^[0:.7:4.5]
3* 2.^[0:.6:4.5]
3* 2.^[0:.5:4.5]
3* 2.^[0:.45:4.5]
3* 2.^[0:.44:4.5]
3* 2.^[0:.43:4.5]
3* 2.^[0: (.43)*2 :4.5]
logspace(log10(3),log10(45),7)
round( logspace(log10(3),log10(45),7) )
round( logspace(log10(3),log10(45),6) )
( logspace(log10(3),log10(45),6) )
( logspace(log10(3),log10(45),8) )
createNoisyLettersDatafile
runIdealObserverTests
edit plotResults
allOriWiggles = [0, dWiggle:dWiggle:90];
allOffsetWiggles = [0, dWiggle:dWiggle:60];
allPhaseWiggles = [0, 1];
allWiggles_S_ori = struct('orientation', allOriWiggles);
allWiggles_S_offset = struct('offset', allOffsetWiggles);
allWiggles_S_phase = struct('phase', allPhaseWiggles);
dWiggle = 5
allOriWiggles = [0, dWiggle:dWiggle:90];
allOffsetWiggles = [0, dWiggle:dWiggle:60];
allPhaseWiggles = [0, 1];
allWiggles_S_ori = struct('orientation', allOriWiggles);
allWiggles_S_offset = struct('offset', allOffsetWiggles);
allWiggles_S_phase = struct('phase', allPhaseWiggles);
allWiggles = getWiggleList(allWiggles_S_ori)
allWiggles{1}
allSnakeFontNames = ['SnakesN', cellfun(@(w) sprintf('SnakesOr%d', w), 0:5:90, 'un', 0)]
allSnakeFontNames = ['SnakesN', arrayfun(@(w) sprintf('SnakesOr%d', w), 0:5:90, 'un', 0)]
allSnakeFontNames = ['SnakesN', 'SnakesPh', arrayfun(@(w) sprintf('SnakesOr%d', w), 0:5:90, 'un', 0), arrayfun(@(w) sprintf('SnakesOf%d', w), 0:5:60, 'un', 0)]
oris = [-20:2:20]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesN', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allSnakeFontNames = ['SnakesN', 'SnakesPh', arrayfun(@(w) sprintf('SnakesOr%d', w), 5:5:90, 'un', 0), arrayfun(@(w) sprintf('SnakesOf%d', w), 5:5:60, 'un', 0)]
oris = [-20:2:20]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames(1), 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:20]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:20]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:20]; ys = [1:21]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:18]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:19]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:18]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:19]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:18]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:18]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:18]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:18]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:22]; ys = [1:22]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:18]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:18]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:3:15]; xs = [1:17]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:3:20]; xs = [1:17]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:4:20]; xs = [1:17]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:1:15]; xs = [1:17]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:1:15]; xs = [1:17]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:17]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:16]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:15]; ys = [1:18]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
15*18
oris = [-20:2:20]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
runIdealObserverTests
oris = [-15:5:15]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allSnakeFontNames
oris = [-5:5:5]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allSnakeFontNames
oris = [-5:5:5]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit generateLetterSignals.m
createNoisyLettersDatafile
oris = [-15:5:15]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesOr60', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesOr60', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesOr0', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [0]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, 'SnakesOr5', 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
[a,b] = loadLetters('SnakesOr60', 'k32')
b
[a,b] = loadLetters('SnakesOr60', 'k32')
b.size_rotated
edit generateSnakesFonts
generateSnakesFonts
figure
imagesc(tileImages(allLetters))
colormap('gray');
imagesc(tileImages(allLetters))
imagesc(tileImages(abs(allLetters)))
[nH_rot, nW_rot] = getBoundOfRotatedLetters(abs(allLetters), oris_rotated, fontOpts.margin_pixels_rotated);
imagesc(tileImages((allLetters)))
imagesc(lettersUse)
imagesc(allLetters_rotated{1})
imagesc(tileImages((allLetters)))
[nH_rot, nW_rot] = getBoundOfRotatedLetters(abs(allLetters), 0, 0)
imagesc(lettersUse)
imagesc(log10(lettersUse))
colormap
colorbar
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
imagesc(tileImages((allLetters)))
imagesc(tileImages((log10(allLetters))))
colorbar
imagesc(tileImages((log10(allLetters(:,:,1)))))
surf((log10(allLetters(:,:,1))))
surf(((allLetters(:,:,1))))
surf((log10(allLetters(:,:,1))))
allLetters(:,:,1)
lims(allLetters(:,:,1))
surf(((allLetters(:,:,1))))
surf(((abs(allLetters(:,:,1)))))
surf((((allLetters(:,:,1)))))
surf((log10(allLetters(:,:,1))))
imagesc(tileImages((log10(allLetters(:,:,1)))))
imagesc(allLetters(:,:,1))
allLetters(:,:,1)
imagesc(S.C)
S.C(1:10, 1:10)
imagesc(S.C)
imagesc(log10(S.C))
imagesc(log10(abs(S.C)))
generateSnakesFonts
imagesc(log10(abs(S.C)))
imagesc(log10(abs(allLetters(:,:,1))))
imagesc(log10(abs(allLetters_orig(:,:,1))))
allLetters(1:10, 1:10, 1)
imagesc(log10(abs(allLetters_orig(:,:,1))))
imagesc(log10(abs(allLetters(:,:,1))))
allLetters(1:10, 1:10, 1)
imagesc(log10(abs(allLetters(:,:,1))))
imagesc(log10(abs(let_rotated(:,:,1))))
let_rotated = rotateLetters(double(allLetters), orientations(ori_i));
imagesc(log10(abs(let_rotated(:,:,1))))
let_rotated(1:10, 1:10, 1)
let_rotated(1:15, 1:15, 1)
let_rotated(1:15, 1:14, 1)
[nH_rot, nW_rot] = getBoundOfRotatedLetters(abs(allLetters), oris_rotated, fontOpts.margin_pixels_rotated);
imagesc(allLetters_rotated(:,:,1))
imagesc(allLetters_rotated{1}(:,:,1))
imagesc(log10(allLetters_rotated{1}(:,:,1)))
let_rotated = rotateLetters(double(allLetters), orientations(ori_i));
imagesc(let_rotated(:,:,1))
imagesc(abs(let_rotated(:,:,1)))
imagesc(log10(abs(let_rotated(:,:,1))))
let_rotated = rotateLetters(double(allLetters), orientations(ori_i));
figure
subplot(1,2,1)
imagesc(allLetters(:,:,1))
colormap('gray');
imagesc(abs(allLetters(:,:,1)))
imagesc(log10(abs(allLetters(:,:,1))))
subplot(1,2,2)
imagesc(log10(abs(let_rot1(:,:,1))))
imagesc((abs(let_rot1(:,:,1))))
imagesc(log10(abs(let_rot1(:,:,1))))
let_rot1 = imrotate(abs(allLetters(:,:,1)), ori, 'bilinear');
imagesc(log10(abs(let_rot1(:,:,1))))
let_rot1 = imrotate(sum(abs(allLetters),3), ori, 'bilinear');
imagesc(log10(abs(let_rot1(:,:,1))))
let_rot1(1:20, 1:20)
imagesc(log10(abs(let_rot1(:,:,1))))
global imX
imX = allLetters(:,:,1);
global imG
imG = allLetters(:,:,1);
figure
tryRotate(imX)
tryRotate(imG)
global imX
global imG
tryRotate(imG)
tryRotate(imX)
tryRotate(imG)
tryRotate(imX)
tryRotate(imG)
tryRotate(imX)
figure
imagesc(imG-imX)
imagesc(imG); colorbar; colormap('gray')
imagesc(imX); colorbar; colormap('gray')
imagesc(imG); colorbar; colormap('gray')
class(imG)
class(imX)
tryRotate(imG)
class(imX)
tryRotate(imX)
tryRotate(imX*100)
tryRotate(imX*127)
figure
imagesc(imG ./ imX)
colorbar
imagesc(log10(abs(imG)))
imagesc(log10(abs(imX)))
imagesc(log10(abs(imG)))
imagesc(log10(abs(imX)))
imagesc(log10(abs(imG)))
imagesc(log10(abs(imX)))
imagesc(log10(abs(imG)))
edit tryRotate
tryRotate(imX*127)
tryRotate(imG)
dbquit
edit tryRotate
tryRotate(imG)
tryRotate(imX)
tryRotate(imG)
tryRotate(imX)
tryRotate(imG)
tryRotate(imX)
tryRotate(imG)
tryRotate(imX)
tryRotate(imG)
tryRotate(imX)
tryRotate(imX, 5)
tryRotate(imG, 6)
tryRotate(imX, 5)
imageToScale([], 3)
imageToScale([], 4)
tryRotate(imX, 5); tryRotate(imG, 6)
tryRotate(imX*100, 5); tryRotate(imG, 6)
tryRotate(imX*1000, 5); tryRotate(imG, 6)
tryRotate(imX*100, 5); tryRotate(imG, 6)
tryRotate(imX*200, 5); tryRotate(imG, 6)
tryRotate(imX*130, 5); tryRotate(imG, 6)
global imG imX
tryRotate(imX*130, 5); tryRotate(imG, 6)
figure
global imGX
imGX = [imX*130 imG];
tryRotate(imGX)
figure
imagesc(imGX)
colorbar
imGX(1,:)
tryRotate(imGX)
imGX = [imG imX*130];
tryRotate(imGX)
imX(1:10, 1:10)
allLetters(1:10, 1:10, 1)
[allLetters, fontData] = loadLetters(fontName, fontSizeStyle, sizeSpec);
allLetters(1:10, 1:10, 1)
generateSnakesFonts
fontData.letters(1:10, 1:10)
loadLetters(fontName, fontData.fontsize, [], fontData);
[allLetters, fontData] = loadLetters('SnakesOr60', 'k32');
allLetters(1:10, 1:10, 1)
allLetters = single( fontData.letters);
allLetters = rescaleToRangeWithoutOffset( allLetters, scale_range );
allLetters(1:10, 1:10, 1)
allLetters = rescaleToRangeWithoutOffset( allLetters, scale_range );
allLetters(1:10, 1:10, 1)
createNoisyLettersDatafile
oris = [-5:5:5]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-15:5:15]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:15]; ys = [1:20]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
sprintf('%.6f', now)
createNoisyLettersDatafile
uncertaintyStrs = cellfun(@getOriXYStr, allUncertaintySets, 'un', 0);
createNoisyLettersDatafile
createNoisyLettersDatafile('ChannelTuning')
runIdealObserverTests('all')
runIdealObserverTests('Grouping')
runIdealObserverTests({'Grouping', 'Complexity'})
runIdealObserverTests
createNoisyLettersDatafile('all')
%-- 11/14/2015 11:03:16 PM --%
edit plotResults
edit createNoisyLettersDatafile
plotResults
11*4*4
7*18
edit plotResults
plotResults
ylim([0 .3])
ylim([0 .2])
plotResults
length(0:5:90)
length(0:15:90)
length(0:25:90)
0:25:90
0:20:90
0:45:90
0:30:90
0:45:90
0:30:90
17/4
0:45:90
edit generateSnakesFonts
generateSnakesFonts
imageToScale([], 5)
generateSnakesFonts
%-- 11/18/2015 04:27:38 PM --%
edit generateSnakesFonts
generateSnakesFonts
%-- 11/19/2015 08:27:29 AM --%
edit generateSnakesFonts
generateSnakesFonts
%-- 11/20/2015 03:29:14 AM --%
[a,b] = loadLetters('SnakesN', 'k27');
b
allSnakeFontNames = ['SnakesN', 'SnakesPh', arrayfun(@(w) sprintf('SnakesOr%d', w), 5:5:90, 'un', 0), arrayfun(@(w) sprintf('SnakesOf%d', w), 5:5:60, 'un', 0)]
oris = [-20:5:20]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit plotResults
plotResults
ylim([0 .2])
oris = [-20:5:20]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:19]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:22]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:5:20]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:1:20]; xs = [1:15]; ys = [1:19]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:1:20]; xs = [1:21]; ys = [1:25]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:1:20]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
length([-20:2:20])
length([-20:1:20])
length([-15:1:15])
length([-20:1:20])
plotResults
oris = [-20:1:20]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
plotResults
oris = [-20:1:20]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-25:1:25]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:1:20]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-10:1:10]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile('all')
createNoisyLettersDatafile('Grouping')
sprintf('%.6f', now)
edit runIdealObserverTests.m
runIdealObserverTests
oris = [-10:1:10]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:1:20]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
global ID
ID
startup
edit lock_removeMyLocks
createNoisyLettersDatafile('Grouping')
sizeOfSignalData_MB = numel(signal(1).image)*numel(signal) *4/(1024^2);
numel(allSignalImages)*4/(1024^2)
allSignalImages= cat(3, signal.image);
numel(allSignalImages)*4/(1024^2)
createNoisyLettersDatafile('Grouping')
sizeOfSignalData_MB = numel(signal(1).image)*numel(signal) *4/(1024^2);
numel(allSignalImages)*4/(1024^2)
%-- 11/22/2015 11:43:18 PM --%
plotResults
edit plotResults
plotResults
ylim([.08 .14])
ylim([.07 .14])
1633-1923
145*2
edit plotResults
plotResults
USet
plotResults
x_vals_C{plot_i}
plotResults
ylim([0.001 1])
textureAnalysis(randn(64, 64), 3, 4, 7);
textureAnalysis(randn(64, 64), 4, 4, 7);
textureAnalysis(randn(96, 96), 4, 4, 7);
8*[1:2:20]
8*[2:2:20]
textureAnalysis(randn(80, 80), 4, 4, 7);
textureAnalysis(randn(96, 96), 4, 4, 7);
allSnakeFontNames = ['SnakesN', 'SnakesPh', arrayfun(@(w) sprintf('SnakesOr%d', w), 5:5:90, 'un', 0), arrayfun(@(w) sprintf('SnakesOf%d', w), 5:5:60, 'un', 0)]
oris = [-20:1:20]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k27', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:1:20]; xs = [1:22]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:30]; ys = [1:30]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:34]; ys = [1:30]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:2:20]; xs = [1:30]; ys = [1:34]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-25:5:25]; xs = [1:30]; ys = [1:34]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-25:5:25]; xs = [1:35]; ys = [1:39]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-25:5:25]; xs = [1:45]; ys = [1:49]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-25:5:25]; xs = [1:45]; ys = [1:47]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit createNoisyLettersDatafile
oris = [0]; xs = [1:45]; ys = [1:47]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
[22, 26]*2
[22, 26]*sqrt(2)
oris = [-10:1:10]; xs = [1:45]; ys = [1:47]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20:1:20]; xs = [1:45]; ys = [1:47]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile('Grouping')
edit runIdealObserverTests.m
runIdealObserverTests
createNoisyLettersDatafile
oris = [-20:1:20]; xs = [1:45]; ys = [1:47]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit createNoisyLettersDatafile
createNoisyLettersDatafile
nLet = size(allLetters{1}, 3);
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
mem
pmem
memory
system( 'echo `free -m | grep "buffers/cache"` | cut -d " " -f 4' )
a = system( 'echo `free -m | grep "buffers/cache"` | cut -d " " -f 4' )
[a,b] = system( 'echo `free -m | grep "buffers/cache"` | cut -d " " -f 4' )
str2double(b)
n = memoryAvailable_MB
createNoisyLettersDatafile
checkIfEnoughMemory(100)
checkIfEnoughMemory(1000)
checkIfEnoughMemory(10000)
createNoisyLettersDatafile
memRequired_MB/1024
memRequired_MB = (nX*nY*nOris * nLetters*imageHeight*imageWidth*8)/1024^2;
createNoisyLettersDatafile
clear all
pack
createNoisyLettersDatafile
who
whos
6198516500/1024^2
letterSignals(1
letterSignals(1)
whos
createNoisyLettersDatafile
whos
16763317820/(1024^2)
round( 16763317820/(1024^2) )
clear all
nX
45*49
createNoisyLettersDatafile
edit runIdealObserverTests.m
round( 16763317820/(1024^2) )
runIdealObserverTests
edit plotResults
edit createNoisyLettersDatafile
[-16 : 12 : 176]
length([-16 : 12 : 176])
[a,b] = loadLetters('Bookman', 'k15');
b
-10:10:170
length(-10:10:170)
length(-14:8:180)
[-14:8:180]
[-16:8:180]
length([-16:8:180])
length([-16:12:180])
[-16:12:180]
length([-16:8:180])
[-16:8:180]
xx = [-16:8:180]
find(xx == 80)
find(xx == 160)
xx(3:23)
b
xx = [-16:15:180]
xx = [-16:16:180]
xx = [-16:18:180]
xx = [-10:18:180]
xx = [-16:8:180]
xx(3:23)
createNoisyLettersDatafile
edit fig_groupingDemo.m
edit createNoisyLettersDatafile
createNoisyLettersDatafile
32*32
160/32
%-- 11/25/2015 04:35:47 PM --%
edit plotResults
plotResults
edit runIdealObserverTests.m
edit plotResults
edit runIdealObserverTests.m
runIdealObserverTests
filt
filt{1}
runIdealObserverTests
allLetterOpts(1)
allLetterOpts(1).noiseFilter
allLetterOpts(2).noiseFilter
allLetterOpts(3).noiseFilter
edit plotResults
plotResults
letterOpt_use_ideal.trainingNoise = whiteNoiseFilter{1};
[pCorr_ideal_i, pCorr_ideal_i_indiv] = getIdealPerformance(letterOpt_use_ideal, allSNRs_test, opt);
plotResults
[a, b] = loadIdealPerformance(file_fontName, snrs(si), letterOpts, opt)
plotResults
runIdealObserverTests
plotResults
letterOpts
letterOpts.noiseFilter
plotResults
edit plotResults
plotResults
edit makePlots.m
makePlots
edit makePlots.m
edit plotResults
plotResults
th_ideal_M = nanmean(nanmean(th_ideal, 2), 4);
th_ideal_use = th_ideal(:,1,plot_i,1); %take data for this plot, 1st set, 1st trial
plotResults
th_ideal_use = th_ideal_M(:,1,plot_i); %take data for this plot, 1st set, 1st trial
th_ideal_use  = th_ideal_use/th_ideal_use(1)*.25;
h_ideal = plot(x_vals_C{plot_i}, th_ideal_use, 'ko-', 'linewidth', 2, 'color', .2*[1,1,1]);
plotResults
edit makePlots.m
makePlots
ylim([0 .052])
ylim([0 .051])
ytickslabels = arrayfun(@num2str, yticks, 'un', 0);
edit convertSVHNtoGrayscale.m
s = load('batches.meta')
s = load('batches.meta.mat')
s.label_names{1}
s
s.label_names
s = load('data_batch_1.mat')
x = data(:,1);
x = s.data(:,1);
size(x)
x = s.data(1,:);
size(x)
3072/3
sqrt(3072/3)
x2 = reshape(x, [1024, 1024, 3]);
x2 = reshape(x, [32, 32, 3]);
figure
image(x2)
imageToScale
x = s.data(10,:);
x2 = reshape(x, [32, 32, 3]);
image(x2)
imageToScale([], 2)
image(x2')
image( reshape( s.data(10,:), [32, 32, 3] ) )
i = 4; image( reshape( s.data(i,:), [32, 32, 3] ) )
i = 5; image( reshape( s.data(i,:), [32, 32, 3] ) )
i = 6; image( reshape( s.data(i,:), [32, 32, 3] ) )
i = 7; image( reshape( s.data(i,:), [32, 32, 3] ) )
i = 8; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [1, 2] ) )
i = 8; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 9; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 10; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 11; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 12; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 13; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 16; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 13; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
i = 130; image( permute( reshape( s.data(i,:), [32, 32, 3] ), [2, 1, 3] ) )
s
XX = permute( reshape( s.data, [32, 32, 3, 10000] ), [2, 1, 3, 4] );
size(XX)
image(XX(:,:,:,40))
XX = permute( reshape( s.data', [32, 32, 3, 10000] ), [2, 1, 3, 4] );
image(XX(:,:,:,40))
image(XX(:,:,:,41))
image(XX(:,:,:,42))
image(XX(:,:,:,43))
image(XX(:,:,:,44))
image(XX(:,:,:,45))
image(XX(:,:,:,46))
imageToScale([], 2)
imageToScale([], 4)
imageToScale([], 1)
imageToScale([], 2)
convertSVHNtoGrayscale
size(X)
image(X(:,:,:,46))
convertSVHNtoGrayscale
size(X)
image(X(:,:,:,46))
image(X(:,:,:,146))
image(X(:,:,:,40146))
s = load('batches.meta.mat')
s.label_names
convertSVHNtoGrayscale
varBreakdown(labels)
idx1 = find(labels == 1);
nnz(idx1)
convertSVHNtoGrayscale
idx1 = find(labels == 1);
clf
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx1(v(1:100))), 10, 10))
colormap('gray');
imageToScale([], 1)
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx1(v(1:200))), 10, 20))
imageToScale([], 1)
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx1(v(1:200))), 10, 20))
20*10
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx1(v(1: (15*25) ))), 15, 25))
imageToScale([], 1)
idx2 = find(labels == 2);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx2(v(1: (15*25) ))), 15, 25))
idx3 = find(labels == 3);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx3(v(1: (15*25) ))), 15, 25))
idx4 = find(labels == 4);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx3(v(1: (15*25) ))), 15, 25))
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx4(v(1: (15*25) ))), 15, 25))
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx3(v(1: (15*25) ))), 15, 25))
idx5 = find(labels == 5);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx5(v(1: (15*25) ))), 15, 25))
idx6 = find(labels == 6);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx5(v(1: (15*25) ))), 15, 25))
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx6(v(1: (15*25) ))), 15, 25))
idx7 = find(labels == 6);
idx7 = find(labels == 7);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx7(v(1: (15*25) ))), 15, 25))
idx8 = find(labels == 8);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx8(v(1: (15*25) ))), 15, 25))
idx9 = find(labels == 9);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx9(v(1: (15*25) ))), 15, 25))
idx0 = find(labels == 0);
v = randperm(5000); imagesc(tileImages(X_gray(:,:, idx0(v(1: (15*25) ))), 15, 25))
convertSVHNtoGrayscale
allSettings(i)
scaleFactor = allSettings(i).scaleFactor;
scaleMethod = allSettings(i).scaleMethod;
convertSVHNtoGrayscale
colorbar
edit getSVHNOptsStr.m
edit convertRealDatasetToGrayscale.m
convertSVHNtoGrayscale
convertRealDatasetToGrayscale
edit convertRealDatasetToGrayscale.m
generateRealDataTextureFiles
[~, ~, svhn_opt_fileStr] = getRealDataOptsStr(opts);
generateRealDataTextureFiles
edit convertRealDatasetToGrayscale.m
convertRealDatasetToGrayscale
load('CIFAR10_test_32x32_gray.mat')
S = load('CIFAR10_test_32x32_gray.mat')
S2 = load('CIFAR10_test_32x32_gray_gnorm.mat')
S3 = load('CIFAR10_test_32x32_gray_gnorm_lcnorm.mat')
imagesc( tileImages(S.inputMatrix(:,:,15*25), 15, 25) )
imagesc( tileImages(S.inputMatrix(:,:,1:15*25), 15, 25) )
imagesc( tileImages(S.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S2.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S3.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S2.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S3.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S3.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S2.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S2.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S2.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
imagesc( tileImages(S2.inputMatrix(:,:,1:15*25), 15, 25) ); colorbar;
edit getNoisyLetterOptsStr.m
edit getLetterOptsStr.m
edit getExpSubtitle.m
edit getLetterOptsStr.m
edit plotResults
edit runIdealObserverTests.m
runIdealObserverTests
dbquit
edit runIdealObserverTests.m
runIdealObserverTests
edit createNoisyLettersDatafile
allSnakeFontNames = ['SnakesN', 'SnakesPh', arrayfun(@(w) sprintf('SnakesOr%d', w), 5:5:90, 'un', 0), arrayfun(@(w) sprintf('SnakesOf%d', w), 5:5:60, 'un', 0)]
oris = [0]; xs = [1:2:45]; ys = [1:2:47]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:2:32]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:1:28]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:1:24]; ys = [0]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
edit runIdealObserverTests.m
96/64
(96/64)^2
edit plotResults
plotResults
letterOpts.fontName
tf = any(  cellfun(@(f) ~isempty(strfind(font_str, f)), realDataFontList) );
plotResults
set(gca, 'xscale', 'log', 'yscale', 'log')
set(gca, 'xscale', 'log', 'yscale', 'linear')
xlim
ylim([0 .051])
Y_C{end}
median(Y_C{end})
logx = log(xvals);
p = polyfit(logx(3:end), y_med(3:end), 1);
oris = [0]; xs = [1:25]; ys = [1:25]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:26]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-5:5:5]; xs = [1:26]; ys = [1:26]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit createNoisyLettersDatafile
createNoisyLettersDatafile
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 1); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit createNoisyLettersDatafile
createNoisyLettersDatafile
allSnakeFontNames_ori = ['SnakesN', 'SnakesPh', arrayfun(@(w) sprintf('SnakesOr%d', w), 5:5:90, 'un', 0)]
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames, 'k32', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames_ori, 'k32', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames_ori{1}, 'k32', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames_ori(1), 'k32', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
allSnakeFontNames_ori(1)
[a,b] = loadLetters('SnakesN', 'k32');
b
b.size_rotated
edit getBestImageSize
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames_ori(1), 'k32', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createFontSizesFile
addSummaryOfFontSizesToFontFile
oris = [0]; xs = [1:28]; ys = [1:28]; [h,w] = getBestImageSize(oris, xs, ys, allSnakeFontNames_ori(1), 'k32', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
edit addSummaryOfFontSizesToFontFile
addSummaryOfFontSizesToFontFile
28/2
28/3
28/4
1 : 28
1 : 2 : 28
1 : 4 : 28
[1 : 4 : 28] + 2
length(1:4:28)
26/2
1:2:26
1:3:26
length(1:3:26)
length([1 : 2 : 24])
length([1 : 1 : 24])
length([1 : 3 : 24])
length([1 : 4 : 24])
length([1 : 6 : 24])
createFontSizesFile
createNoisyLettersDatafile
runIdealObserverTests
edit getRealDataOptsStr.m
edit getDataOptsStr.m
edit generateRealDataTextureFiles.m
edit convertRealDatasetToGrayscale.m
convertRealDatasetToGrayscale
figure
imagesc(im_gray_enlarged)
imageToScale([], 1)
colormap('gray');
im_gray_enlarged = repmat(im_gray, scaleFactor);
imagesc(im_gray_enlarged)
convertRealDatasetToGrayscale
imagesc(im_gray_enlarged)
%-- 11/28/2015 10:33:18 PM --%
edit plotResults
plotResults
edit makePlots.m
edit plotResults
plotResults
line_legends_orig
line_legends_orig{1}
line_legends_orig{2}
plotResults
edit makePlots.m
edit plotResults
edit extractFontFromPNG.m
S = loadLetters;
S
edit addSummaryOfFontSizesToFontFile
addSummaryOfFontSizesToFontFile
allFonts
edit extractFontFromPNG.m
extractFontFromPNG
extractFontFromPNG('Devanagari')
[rawFontName, fontAttrib] = getRawFontName(fontName);
any(rawFontName(end) == ['U', 'B', 'I'])
|| (isKuenstler && (rawFontName(end) == 'i') ) || (~isnan(str2double(rawFontName(end))) && ~isSnakes)
(isKuenstler && (rawFontName(end) == 'i') ) || (~isnan(str2double(rawFontName(end))) && ~isSnakes)
(~isnan(str2double(rawFontName(end))) && ~isSnakes)
str2double(rawFontName(end))
((~isnan(str2double(rawFontName(end))) && isreal(str2double(rawFontName(end)))) && ~isSnakes)
extractFontFromPNG('Devanagari')
viewAllFontsForOneSize('k15')
edit viewAllFontsForOneSize
viewAllFontsForOneSize('k15')
addSummaryOfFontSizesToFontFile
viewAllFontsForOneSize('k15')
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit runIdealObserverTests.m
runIdealObserverTests
allFontNames      = {'Bookman', 'Sloan', 'Helvetica', 'KuenstlerU', 'Braille', 'Yung'};
oris = [0]; xs = [1:5]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-20,0,20]; xs = [1:5]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-30,0,30]; xs = [1:5]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-40,0,40]; xs = [1:5]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-90,0,90]; xs = [1:5]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [-30,0,30]; xs = [1:5]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
edit runIdealObserverTests.m
addSummaryOfFontSizesToFontFile
createFontSizesFile
edit loadLetters
loadLetters('save')
7*18
5*13
65*3
oris = [0]; xs = [1:5]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:6]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
oris = [0]; xs = [1:7]; ys = [1:13]; [h,w] = getBestImageSize(oris, xs, ys, allFontNames, 'k15', 0); sprintf('%dx%d.  %d x %d x %d = %d\n', h,w, length(oris), length(xs), length(ys), length(oris)*length(xs)*length(ys))
createNoisyLettersDatafile
allSetsToDo(1)
allSetsToDo(2)
allSetsToDo(3)
allSetsToDo(4)
allSetsToDo(5)
allSetsToDo(6)
allSetsToDo(7)
allSetsToDo(8)
runIdealObserverTests
edit getRawFontName.m
getRawFontName('Checkers4x4')
edit createNoisyLettersDatafile
createNoisyLettersDatafile
edit loadLetters
%-- 11/29/2015 09:54:18 PM --%
%-- 11/29/2015 10:41:02 PM --%
190+184-28
190+184-28+10
1861/26579
23900*1.07
23900*1.07 + 169
23900*1.07 + 269
%-- 12/01/2015 11:40:41 PM --%
edit plotResults