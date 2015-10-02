%%
% test BOLD

letR = loadLetters('Sloan', 'k16');
letB = loadLetters('SloanB', 'k16');

letR = letR(:,:,1);
letB = letB(:,:,1);
figure(5); clf;

subplot(1,3,1);
% imagesc(tileImages(letR, 6, 4));
imagesc(letR);
colormap('gray')

subplot(1,3,2); cla;
imagesc(letB);
colormap('gray')
%%

letR_bold = makeFontBold(letR, 1, letB);
subplot(1,3,3);
imagesc(tileImages(letR_bold, 6, 4));

imageToScale([], 2);

% subplot(1,2,2);