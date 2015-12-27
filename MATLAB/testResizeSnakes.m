
%%
x = allLetters(1:56,1:56,1);


sigs = [0:.1:2];
xr = imresize(x, 0.5);

% for i = 1:length(sigs)

g = fspecial('gauss', [11 11], .9); 

xg = conv2(x, g, 'same');
xgd = xg(2:2:end, 2:2:end);

% xgd = xgd([2:end, 1],[2:end, 1]);
% xgd = xgd([2:end, 1],:);
% xgd = xgd([2:end, 1],:);

% xgd = xgd(:, [2:end, 1]);
% xgd = xgd(:, [end, 1:end-1]);


% end

figure(5); clf;
subplot(2,5,1); imagesc(x); axis square;
subplot(2,5,2); imagesc(xg); axis square;
subplot(2,5,3); imagesc(xgd); axis square;
subplot(2,5,4); imagesc(xr); axis square;
subplot(2,5,5); imagesc(xr-xgd); axis square; colorbar;


% fr = @(y) log10(abs(fftshift(fft2(y)))) ;
fr = @(y) (abs(fftshift(fft2(y)))) ;

subplot(2,5,6); imagesc(fr(x)); axis square;
subplot(2,5,7); imagesc(fr(xg)); axis square;
subplot(2,5,8); imagesc(fr(xgd)); axis square;
subplot(2,5,9); imagesc(fr(xr)); axis square;
