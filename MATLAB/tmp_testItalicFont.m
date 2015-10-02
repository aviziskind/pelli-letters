%%
%% test ITALIC

letR = loadLetters('Bookman', 'k16');
% letI = loadLetters('KuenstlerUBI', 'k16');
figure(5); clf;
letR = letR(:,:,1);

[~, ~, ~, ~, letR_cropped] = findLetterBounds(letR);

[tileM, tileN] = deal(1,1);
% [tileM, tileN] = deal(6,4);
subplot(1,3,1);
imagesc(tileImages(letR_cropped, tileM, tileN));
colormap('gray')

subplot(1,3,2); cla;

theta = -70;
letR_sheared = makeFontItalic(letR, theta);
letR_sheared_desheared = makeFontItalic(letR_sheared, -theta);
% imagesc(tileImages(letI, tileM, tileN));
imagesc(tileImages(letR_sheared, tileM, tileN));
colormap('gray')

% letR_sheared = makeFontItalic(letR, -20);
subplot(1,3,3);
imagesc(tileImages(letR_sheared_desheared, tileM, tileN));

% imageToScale([], );

% subplot(1,2,2);