%%
% test BOLD

letR = loadLetters('Braille', 'k16');
% letB = loadLetters('SloanB', 'k16');

% letR = letR(:,:,2);
% letB = letB(:,:,2);
figure(5); clf;

subplot(1,2,1);
imagesc(tileImages(letR, 5, 6, 1, 0));
% imagesc(letR);
colormap('gray');
axis image;

% imagesc(letB);
colormap('gray')
%%
boldFactor = 1.2;
letR_bold = makeCheckersFontBold(letR, boldFactor);

% letR_bold = makeFontBold(letR, 1, letB);
% subplot(1,3,3);
subplot(1,2,2); 
imagesc(tileImages(letR_bold, 5, 6, 1, 0));
axis image;

imageToScale([], 3);

% subplot(1,2,2);