function [eff, th_model, th_ideal, weibull_slope_model] = getModelEfficiency(allLogSNRs, modelPerformance_v_SNR, idealPerformance_v_SNR, th_ideal_prev, threshold_opts)
    % calculate efficiency for multiple models (comparing all with a single ideal observer )
    
    [nCurves, nSNRs] = size(modelPerformance_v_SNR);
    assert(isequal(size(idealPerformance_v_SNR), [1, nSNRs]));
    
    if nSNRs ~= length(allLogSNRs)
        error('Lengths must match');
    end
    if ~exist('th_ideal_prev', 'var')  || isempty(th_ideal_prev)
        th_ideal_prev = nan;
    end

    [eff, th_model, weibull_slope_model] = deal( zeros(nCurves, 1) );
    
    for ci = 1:nCurves
        [eff(ci), th_model(ci), th_ideal, weibull_slope_model(ci)] = getModelEfficiency_helper(allLogSNRs, modelPerformance_v_SNR(ci,:), idealPerformance_v_SNR, th_ideal_prev, threshold_opts);
        
        th_ideal_prev = th_ideal;
    end
    
%     assert(all(nonnans(eff) < 1))
        
%     eff = 10^(th_ideal - th_model);
    
end

function [eff, th_model, th_ideal, weibull_slope_model] = getModelEfficiency_helper(allLogSNRs, modelPerformance_v_SNR, idealPerformance_v_SNR, th_ideal_prev, threshold_opts)
    global plotThresholds
    plotThresholds = false;
    global plotThresholds_fig
    if isempty(plotThresholds_fig)
        plotThresholds_fig = 201;
    end
    
    if all(isnan(modelPerformance_v_SNR))
        th_model = nan;
    else
        [th_model, func_model, ~, weibull_slope_model] = getSNRthreshold(allLogSNRs, modelPerformance_v_SNR, threshold_opts);
    end

    if ~isnan(th_ideal_prev) 
        th_ideal = th_ideal_prev;
%         [th_ideal, func_ideal] = getSNRthreshold(allLogSNRs, idealPerformance_v_SNR);
    else
        if all(isnan(idealPerformance_v_SNR))
            th_ideal = nan;
        else
            [th_ideal, func_ideal] = getSNRthreshold(allLogSNRs, idealPerformance_v_SNR, threshold_opts);
        end
    end

    if isnan(th_model) || isnan(th_ideal)
        eff = nan;
    else
        eff = (th_ideal) / (th_model);    
    end

    if plotThresholds && ~isnan(th_ideal) && ~isnan(th_model)
        %%
        figure(plotThresholds_fig); clf; hold on;
        plot(10.^(allLogSNRs), modelPerformance_v_SNR, 'bo');
        plot(10.^(allLogSNRs), idealPerformance_v_SNR, 'ro');
        xx = logspace(allLogSNRs(1), allLogSNRs(end), 100);
        yy_model = func_model(xx);
        yy_ideal = func_ideal(xx);
        plot(xx,yy_model, ['b-'], 'linewidth', 1)
        plot(xx,yy_ideal, ['r-'], 'linewidth', 1)
        set(gca, 'xscale', 'log');
        drawHorizontalLine(64, 'color', 'k', 'linestyle', '--');
        drawVerticalLine(th_ideal, 'color', 'r', 'linestyle', '--');
        drawVerticalLine(th_model, 'color', 'b', 'linestyle', '--');
        
        title(sprintf('Ideal threshold = %.1f. Model threshold = %.1f. Efficiency = %.2g', th_ideal, th_model, eff))
%         plotThresholds_fig = plotThresholds_fig + 1;
        3;
    end

        
end