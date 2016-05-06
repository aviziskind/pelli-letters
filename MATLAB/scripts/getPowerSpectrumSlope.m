function [slope_av, slope_noAv] = getPowerSpectrumSlope(X)
    X_orig = X;
    X = double(X);
    applyWindowToEdges = false;
    
    L = min(size(X));
    X = X(1:L, 1:L);

%{
    borderFrac = 0.02;
    
    borderN = round(borderFrac*L);
    %%
%     X_ext = repmat(X, [3,3]);
%     X_copy = X;
    w = 5;
    X_sm = gaussSmooth( gaussSmooth(X, w, 1, 1), w, 2, 1);
    %%
    ramp = [1:borderN]/borderN;
    rampLR = ones(L,1)*ramp;
    rampRL = fliplr(rampLR);
    rampUD = rampRL';
    rampDU = flipud(rampUD);
    
    %%
    X_new = X;
%     X_new(:, 1:borderN) = X(:, 1:borderN) .* rampLR     + (1-rampLR) .* X_sm(:, 1:borderN);
%     X_new(:, L-borderN+1:L) = X(:, L-borderN+1:L) .* rampRL + (1-rampRL) .* X_sm(:, L-borderN+1:L);
%     
%     X_new(1:borderN,   :)  = X(1:borderN,    :) .* rampUD  +  (1-rampUD) .* X_sm(1:borderN,:);
%     X_new(L-borderN+1:L,:) = X(L-borderN+1:L,:) .* rampDU  +  (1-rampDU) .* X_sm(L-borderN+1:L,:);
       
  %}  
    if applyWindowToEdges
  
        [x_idx, y_idx] = meshgrid(1:L, 1:L);
        [~, r] = cart2pol((x_idx - L/2), (y_idx - L/2));
        Wind = cosineDecay(r, (L/2)*.8, 20);
        X = X.*Wind;
    end
    
%     X_orig = X;    
    [rps_av, freqs_av] = radialPowerSpectrum(X, 1);
    
    rps_av = rps_av(2:end);
%     rps_av = rps_av/rps_av(1);
    rps_av = rps_av/max(rps_av);
    freqs_av = freqs_av(2:end);

    [rps_noav, freqs_noav] = radialPowerSpectrum(X, 0);
    rps_noav = rps_noav(2:end);
%     rps_noav = rps_noav/rps_noav(1);
    rps_noav = rps_noav/max(rps_noav);
    freqs_noav = freqs_noav(2:end);
    
    freq = 1:length(rps_av);
    
    idx_use = rps_av > 0 & ~isnan(rps_av);
    p_fit_av = polyfit(log10(freq(idx_use)), log10(rps_av(idx_use)), 1);
    
    slope_av = p_fit_av(1);
    
    show = 1;
    if show
%%
        Xm = X; %(X-mean(X(:))) / std(X(:));
        figure(6); clf; imagesc(Xm); axis image; 
        %%
        colormap(gray);
        ticksOff;
        imageToScale;
        %%
        Xf = fftshift(abs(fft2(double(Xm))));
        figure(7); clf; imagesc(log10(Xf)); axis image; ticksOff; colorbar;
        title('log10( abs( fft(image) ) )')

        
        figure(8); clf; hold on;
        
        plot(freq, rps_av, 'o-');
        plot(freq, rps_noav, 'ro-');
        set(gca, 'xscale', 'log', 'yscale', 'log');

        
        all_exps = [1,2,3,4];
        colors_use = 'rgmc';
        for e = all_exps
            %         p = polyfit(log10(freqs_av), log10(rps_av)),
            
            hypFunc = @(b, x) b(1)./(x.^e);
            %         b_fit = nlinfit(freqs_av, rps_av, hypFunc, [1]);
            b_fit = 1;
            fplot(@(x) hypFunc(b_fit, x), lims(freq), colors_use(e))
            
        end
        
        rps_fit_av = polyval(p_fit_av, log10(freq));
        hh = plot(freq, 10.^(rps_fit_av), 'k-', 'linewidth', 2);

        
        legend_str = legendarray('1/x^', all_exps);
        set(gca, 'xscale', 'log', 'yscale', 'log');
        xlabel('Frequency'); ylabel('Relative Power');
        box on;
        
        legend(['Radial Power Spectrum (average)', 'Radial Power Spectrum (sum)', legend_str', sprintf('slope = %.1f', slope_av)], 'location', 'SW', 'fontsize', 8);
        3;
    end
    
    3;
      
end
    

%{

S = load('SVHN_test_32x32_gray_gnorm.mat');
nIm = length(S.labels);
all_slopes = zeros(1, nIm);
progressBar('init-', nIm)
for i = 1:nIm;
    all_slopes(i) = getPowerSpectrumSlope(S.inputMatrix(:,:,i));
    progressBar(i);
end






%}