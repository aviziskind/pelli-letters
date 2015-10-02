%%
x = -2:2;
y = -2:2;
[xg, yg] = meshgrid(x,y);


% function Z = gabor(A, mu_x, mu_y, sig_x, sig_y, theta, k, phi, C, XY) 
k = pi/2;  phi = pi/2; %  half nyquist:  0.25 cyc/pix
% k = pi;  phi = 0;   % nyquist freq: 0.5 cyc/pix

sig = 1; theta = 0; 
Zv = gabor(1, 0, 0, sig, sig, theta, k, phi, 0, [xg(:), yg(:)]);
Z = reshape(Zv, size(xg));

figure(40); imagesc(Z); colormap('gray');
plot(Z(x==0,:), 'o-')
% 
%%
N = 80;
im0 = randn(N,N);

im0c = conv2(im0, Z, 'same');
%%
figure(45); clf;
imagesc(abs(fftshift(fft2(im0c)))); colormap('gray'); axis equal tight;

% filterGain(Zfilt, 

%%
[filterGain_x, filterGain_y] = filterGain(Z, N);

%%
[fx_cycPerPix1, fy1] = filterGain(Z, 50);
[fx_cycPerPix2, fy2] = filterGain(Z, 100);

% 4 pix per cyc =   0.25 cycPerPix = 0.5 freq / Nyquist 

% 4 pix per cyc =   0.25 cycPerPix = 0.5 * ( 0.5 cycPerPix) =    0.5 freq / Nyquist  = 


% 0.5 


figure(55); clf;
hold on;
plot(fx_cycPerPix1, fy1, 'bo-')
plot(fx_cycPerPix2, fy2, 'r-')
xlabel('cyc/pix');
ylabel('Filter Gain');
% set(gca, 'xscale', 'log', 'yscale', 'log')


        
%%
imagesc(b); colormap('gray'); axis equal tight;



%{
want: cycPerLet

have: freq / nyquistFreq =   cyc/(2pix);

cyc/Let = cyc/(2pix) *  ?

cycPerLet /  cycPer2Pix  ?

let / 2pix


cyc/2pix  / let/2pix = 
cyc/2pix  * 2pix/let = 



    fontHeight = letPerPix;; 1/fontHeight = pixPerLet

        cycPerPix = cycPerLet / fontHeight;
        cycPerPix = cycPerLet / fontHeight;

        noiseFilter.cycPerPix_range = filterBand_cycPerPix_range;

%}
