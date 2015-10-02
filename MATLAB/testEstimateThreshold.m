function testEstimateThreshold
    %%
    allLogSNRs = [0, 1, 2, 3, 4];
    pcorrect = [4.3, 7.8, 58.9, 97.2, 98.2];
    pcorrect = [6.1, 26.6, 96.6, 100, 100];
    pcorrect = [10.6, 37, 63, 64.9];
    
    gamma = 1/26;
    
    [snr_th, bestFitFunc, snr_th_ci, b_best_fit] = getSNRthreshold(allLogSNRs, pcorrect);
    %%
    nSNRs_try = 200;
    nSlopes_try = 15;
    logSNRs_try = linspace(0, 4, nSNRs_try);
    allBetas_try = linspace(1, 3, nSlopes_try);
    err = zeros(nSlopes_try, nSNRs_try);

    for bi = 1:nSlopes_try
        for si = 1:nSNRs_try
            %%
            beta_i = b_best_fit;
            beta_i(2) = 10.^(logSNRs_try(si));
            beta_i(3) = allBetas_try(bi);
            p_corr_i = weibull(beta_i, 10.^allLogSNRs, gamma)*100;
    %         err1(si) = sum( (p_corr_i(:) - pcorrect(:)).^2 );

            err(bi, si) = sum( (p_corr_i(:) - pcorrect(:)).^2 );

        end
    

    end

    %%
    [x, idx_min] = minElement(err);
    idx_min_slope = idx_min(1);
    idx_min_snr = idx_min(2);
    c_est = 2;
    
    th = 64;
    beta_i_best = [1, 10.^logSNRs_try(idx_min_snr), allBetas_try(idx_min_slope)];
    p_corr_i = weibull(beta_i_best, 10.^logSNRs_try, gamma)*100;
    for i = 1:nSNRs_try-1
        x1 = logSNRs_try(i);
        x2 = logSNRs_try(i+1);
        y1 = p_corr_i(i);
        y2 = p_corr_i(i+1);
        if y1 < th && y2 >= th
            frac = (y2-th)/(y2-y1);
            snr_th_est = x1 + (x2-x1)*frac;
            
        end
        
    end
        %%
    figure(4); clf;
    plot(err');
    drawVerticalLine(idx_min);
    
    estFunc = @(x) weibull(beta_i_best, x, gamma)*100;
%     weibull_func = @(beta, x) weibull(beta, x, gamma);
    
    
    figure(5); clf;
    plot(allLogSNRs, pcorrect, 'bo-'); hold on;
    fplot(@(x) estFunc(10.^x), lims(allLogSNRs), 'r-');
    fplot(@(x) bestFitFunc(10.^x), lims(allLogSNRs), 'g-');
    plot(snr_th_est, th, 'kx', 'markersize', 15);
    title(sprintf('th = %.2f', snr_th_est))
    
    %%
    
    
    
    
end