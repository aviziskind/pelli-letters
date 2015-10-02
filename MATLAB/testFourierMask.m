%%

do1D_test = 0;
do2D_test = 1;

if do1D_test
%%
        N = 100;
        a = 0;
        b = 1;
%         t = linspace(0, 2*pi, N+1);  
        t = 1:N;
        t = t(1:N);
        X = randn(1, N); %a + b*cos(5*t);
        col = 'k';
        Xf = fftshift( fft(X) );
        
%         pixPerCycle_range = [5, 10];  maskType = 'band_pixPerCycle';
        pixPerCycle_range = [0.5];  maskType = '1/f';
        

        mask = fourierMask(N, pixPerCycle_range, maskType);
        X_filt = fourierMask(X, pixPerCycle_range, maskType);
        Xf_filt = fftshift(fft(X_filt));

        figure(1); clf; plot(t,X, 'o-', t, X_filt, 'ro-');

        figure(2); clf; plot(1:N, abs(Xf), 'bo-', 1:N, abs(Xf_filt), 'gs:', 1:N, mask*10, 'ro-');

% clf;
% subplot(2,1,1);
% hold on; box on;
% plot(abs(Xf), [col 'o-'])
% xlim([1, N]);
% title('FFT(x)')
% subplot(2,1,2);
% hold on; box on;
% plot(fftshift(abs(Xf)), [col 'o-'])
% xlim([1, N]);
% title('shift ( FFT(x) )')


end



if do2D_test
    %%
%     M = 768; N = 768;
    M = 500; N = 500;
    a = 0;
    b = 1;
    tx = linspace(0, 2*pi, N+1);
    tx = tx(1:N);
    ty = tx;
    % [xg, yg] = meshgrid(tx, ty);
    % Z = cos(xg) + sin(4*yg);
    Z = randn(M, N);
    P_orig = sum(Z(:).^2);
    v_orig = var(Z(:));
    
    Zf = fftshift( fft2(Z) );
    
    doFig1 = 0;
    if doFig1
        figure(1); clf;
    %     subplot(1,2,1);
        imagesc(Z);
        colormap('gray'); axis equal tight;
        title(sprintf('Original Image. P = %.0f. v = %.2f', P_orig, v_orig));
        colorbar('SouthOutside');
    end    
    
    doFig2 = 0;
    if doFig2
        figure(2); clf;
    %     subplot(1,2,1);
        imagesc(abs(fftshift(Zf)));
        colormap('gray'); axis equal tight;
        title('abs(fft(Z))');
        colorbar('SouthOutside');
    end    
    
    pixPerCycle_range = [5, 30];  
%     freqRange = pixPerCycle_range; freqRangeType = 'band_pixPerCycle';
%     freqRange = 1./pixPerCycle_range; freqRangeType = 'band_cycPerPix';
    freqRange = sqrt(3); freqRangeType = '1/f';
    mask = fourierMask([M,N], freqRange, freqRangeType);
%     freqRange = 2; freqRangeType = '1/faw';
    
    
%     freqS = struct('filterType', '1/f', 'f_exp', 2);
%     freqS = struct('filterType', '1/fwhite', 'f_exp', 2);
    
        
%     gain_factor = sqrt( 1/ (sum(mask(:))/numel(mask)) );
%     gain_factor = 1; %sqrt( 1/ (sum(mask(:))/numel(mask)) );
    addSecondMask = 0;
    if addSecondMask
        freqRange2 = 0; freqRangeType2 = '1/f';
    
        mask2 = fourierMask([M,N], freqRange2, freqRangeType2);
    
        mask_sum = (mask+mask2);
        mask_correctionFactor = fourierMaskCorrectionFactor(mask_sum);
        mask_sum = mask_sum * mask_correctionFactor;
    end

    
%     maskWhite = fourierMask([M,N], freqRange, freqRangeType);
%     mask = mask * gain_factor

%     Z_filtered = fourierMask(Z, freqRange, freqRangeType);
    if addSecondMask
        Z_filtered = ifft2( ifftshift( Zf .* mask_sum), 'symmetric');
    else
        Z_filtered = ifft2( ifftshift( Zf .* mask), 'symmetric');
    end
           
    

    P_filt = sum(Z_filtered(:).^2);
    v_filt = var(Z_filtered(:));
    
    %     %%
%     subplot(1,2,1);
%     imagesc( abs(fftshift(fft2(Z_filtered) )) ); colormap('gray'); axis equal tight;
%     
%     subplot(1,2,2);
%     Z_cut = abs(fftshift(fft2(Z_filtered(1:40, 1:40)) ));
%     Z_cut = gaussSmooth(    gaussSmooth(Z_cut, 1, 1), 1, 2);
%     imagesc( Z_cut  ); colormap('gray'); axis equal tight;
    
    
    
    
    
    % figure(1); clf; plot(t,X, 'o-', t, X_filt/max(X_filt), 'ro-');
    figure(3); clf;
%     subplot(1,2,2);
    imagesc(Z_filtered);

    
    
    colormap('gray'); axis equal tight;
%     title(sprintf('Z-filtered. P = %.0f. v = %.2f', P_filt, v_filt));
    title(sprintf('Z-filtered. n = %.1f', freqRange));
    
%     title('White + 1/f Noise');
    ticksOff;
%     imageToScale;
%     colorbar('SouthOutside');
%     imageToScale([], 4);


    doFig4 = 0;
    if doFig4
        figure(4);
    %     subplot(1,2,2);
        imagesc((abs(mask)));
        colormap('gray'); axis equal tight;
        colorbar('SouthOutside');
    %     imageToScale([], 4);
    end

    
    figure(5); clf; hold on;
    [rps, freqs] = radialPowerSpectrum(Z_filtered, 1);
    [rps_sum, freqs_sum] = radialPowerSpectrum(Z_filtered, 0);
    rps = rps(2:end);
    rps_sum = rps_sum(2:end);
    
    rps = rps/rps(1);
    rps_sum = rps_sum/rps_sum(1);
%     freqs = freqs(2:end);
    freq = 1:length(rps);
    plot(freq, rps, '.-');
    plot(freq, rps_sum, 'r.-');
    hypFunc1 = @(b, x) b(1)./(x);
    hypFunc2 = @(b, x) b(1)./(x.^2);
    hypFunc3 = @(b, x) b(1)./(x.^3);
    hypFunc4 = @(b, x) b(1)./(x.^4);

    b_fit1 = nlinfit(freq, rps, hypFunc1, [1]);
    b_fit2 = nlinfit(freq, rps, hypFunc2, [1]);
    b_fit3 = nlinfit(freq, rps, hypFunc3, [1]);
    b_fit4 = nlinfit(freq, rps, hypFunc4, [1]);
    [b_fit1, b_fit2, b_fit3, b_fit4] = deal(1);
    hold on;
    fplot(@(x) hypFunc1(b_fit1, x), [1, length(rps)], 'r')
    fplot(@(x) hypFunc2(b_fit2, x), [1, length(rps)], 'g')
    fplot(@(x) hypFunc3(b_fit3, x), [1, length(rps)], 'm')
    fplot(@(x) hypFunc4(b_fit4, x), [1, length(rps)], 'c')
    set(gca, 'xscale', 'log', 'yscale', 'log');
    
    legend({'Radial Power Spectrum (average)', 'Radial Power Spectrum (sum)', '1/x', '1/x^2', '1/x^3', '1/x^4'}, 'location', 'SW', 'fontsize', 8)
    box on;
    %%
%     pfit
    figure(3);
    %%



    %%
    pix_per_cycle_range1 = [3, 5];
    pix_per_cycle_range2 = [4, 14];
    
    mask1 = fourierMask([M,N], pix_per_cycle_range1);
    mask2 = fourierMask([M,N], pix_per_cycle_range2);
    
    figure(4); clf;
    imagesc(abs(mask1 + mask2));
    colormap('gray'); axis equal tight;
%     imageToScale([], 5);


        
        
end