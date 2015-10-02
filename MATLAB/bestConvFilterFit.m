function chGain = bestConvFilterFit(allFreq, th, boxWidth_oct)
   
    
    logFreq = log10(allFreq);
    
    dFreq = diff(logFreq(1:2));
    
    
%     x_box = 0:dFreq:boxWidth_oct;
    
    x_box = 0:dFreq:log10(2)*boxWidth_oct;
    
    
    
    convBox = ones( 1, length(x_box)+5 );
    convBox = convBox/ sum(convBox);
%     plot(x_box, octaveBox, 'rs:');

    
    assumeParabola = 1 && 1;

    centFreq0 = 3;
    centFreqWidth_oct0 = 1;
    parabolaMaxN = 7;
    
    show = 1;
    if show
        %%
        figure(58); clf; hold on;
        plot(allFreq, th, '.-');
        set(gca, 'xscale', 'log')
    end
    
    if assumeParabola
        params0 = zeros(1, parabolaMaxN);
        a0 = -1;
        b0 = -centFreq0 / 2*a0;
        c0 = 0;
        params0(end-2) = a0;
        params0(end-1) = b0;
        params0(end)   = c0;
        
        costFunc = @(parabola_params) costFunctionParabola(logFreq, parabola_params, th, convBox);
        params_fit = fminsearch(costFunc, params0);
        
%         show = 0;
        if show
            %%
            [c, th_sim] = costFunctionParabola(logFreq, params_fit, th, convBox);
            th_sim = th_sim/max(th_sim);
            
            gain = getGainFromParabola(logFreq, params_fit);
            gain = gain/max(gain);
            plot(allFreq, gain, 'ro-');
            plot(allFreq, th_sim, 'gs-');
%             set(gca, 'yscale', 'log')
            
            
            3;
        end
        
    else
                
        gain0 = ones(size(allFreq)) * 1e-4;
        gain0( ibetween(allFreq, centFreq0*[1/(sqrt(2)*centFreqWidth_oct0), sqrt(2)*centFreqWidth_oct0] ) ) = 1;
        logGain0 = log10(gain0);
        
        costFunc = @(logGain) costFunctionFull(logGain, th, convBox);
        chGain = fminsearch(costFunc, logGain0);
    end
    
    
    3;
    
    
    
end


function c = costFunctionFull(logGain, th, convBox)

    gain = 10.^(logGain);
    
    th_sim = conv(gain, convBox, 'same');
    log_th_sim = log(th_sim);
    log_th_observed = log(th);
    
    c = sum( (log_th_sim - log_th_observed).^2 );
    

end


function [c, th_sim] = costFunctionParabola(logFreq, params, th, convBox)
    gain = getGainFromParabola(logFreq, params);
    
    th_sim = conv(gain, convBox, 'same');
    log_th_sim = log10(th_sim);
    log_th_observed = log10(th);
    
    c = sum( (log_th_sim - log_th_observed).^2 );
    

end

function gain = getGainFromParabola(logFreq, params)

%     a = params(1);
%     b = params(2);
%     c = params(3);
%     logGain = a* (logFreq).^2  + b * (logFreq) + c; 
    logGain = polyval(params, logFreq);

    gain = 10.^(logGain);
    
    
end

