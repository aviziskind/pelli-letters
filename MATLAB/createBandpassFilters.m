function createBandpassFilters
    %%
    nPixPerCycle = 20;
%     cycPerPix = 1/pixPerCycle;
    nFilters = 4;
    
    filterSize = 10;
    useGabors = 1;
    
    oris = linspace(0, pi, nFilters+1);
    oris = oris(1:end-1);
    
    fontHeight = 10;
    
    if useGabors

        A = 1;
        mu_x = (filterSize-1)/2;
        mu_y = mu_x;
        sigma = 5;
        k = 2*pi / nPixPerCycle; %
        phi = pi/2;
        C = 0.00;
        
        x = [0 : filterSize-1];
        y = [0 : filterSize-1];
        [xg, yg] = meshgrid(x,y);
        
        filters = zeros(filterSize, filterSize, nFilters);
        for fi = 1:nFilters
            theta = oris(fi);

            Z = gabor(A, mu_x, mu_y, sigma, sigma, theta, k, phi, C, [xg(:), yg(:)]);
            Z = reshape(Z, [filterSize, filterSize]);
            
%             Z = Z / max(abs(Z(:)));
            
            [freq_cycPerPix, gain_j] = filterGain(Z, 50);
            all_filterGains(fi,:) = gain_j;
            freq_cycPerLet = freq_cycPerPix * (fontHeight);
            
            filters(:,:,fi) = Z;            
        end
                
    end
    
    figure(93); 
    subplot(1,2,1); 
    imagesc( tileImages(filters, 2, 2, 1, .2)  );
    colormap('gray');
    axis image;
    colorbar;
    
    idx_use = freq_cycPerLet > 0;
    subplot(1,2,2);                     
    plot(freq_cycPerLet(idx_use), all_filterGains(:,idx_use)', '.-', 'linewidth', 2);
    set(gca, 'xscale', 'log', 'yscale', 'log');
    xlabel('Cycles per Letter')
    axis tight;
    3;
    %             log_ylims{set_i} = ylim;

    
    
    
    
    
    
end