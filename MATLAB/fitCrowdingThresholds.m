function [func, xx, yy_fit] = fitCrowdingThresholds(x, y, fit_method)
    
    if nargin < 3
%         fit_method = 'ClippedLine';
        fit_method = 'Sigmoid';
    end

    [uX, x_index] = uniqueList(x);
    if length(uX) < length(x)
        X = uX;
        Y = cellfun(@(lst) mean(y(lst)), x_index);
    else
        X = x;
        Y = y;
    end
    dx = median(diff(X));
    smY = gaussSmooth_nu(X(:), Y(:), mean(diff(X)));
    logSmY = log(smY);
    maxY = max(logSmY);
    minY = min(logSmY);
    idx_th_est = indmin( abs( logSmY - (maxY+minY)/2 ) );
    X_th_est = X(idx_th_est);
    

    switch fit_method
        case 'ClippedLine',
       
            beta0 = [X_th_est + [-dx*2, dx*2], maxY, minY];
            
            beta = nlinfit(X, Y, @clippedLine, beta0);

            func = @(x) clippedLine(beta, x);
            
            xx = linspace(X(1), X(end), 100);
            yy_fit = func(xx);
            
            % h2 = plot(0, 0, 'r-');
%             set(h2, 'xdata', [cf_top_x, cf_bot_x], 'ydata', [cf_top_y cf_bot_y]);

            
        case 'Sigmoid',
            %%
            xx = linspace(X(1), X(end), 100);
            
            sigmoideWithOffset_hnd = @(beta, x) sigmoidWithOffset(x, beta(1), beta(2), beta(3), beta(4));

            beta0 = [maxY, minY, dx*2, X_th_est];
            
            yy0 = sigmoideWithOffset_hnd(beta0, xx);
            %%
            3;
%             sigmoidWithOffset(X, minY, maxY, X_th_est, dx*2)
            
%             beta0 = [X_th_est + [-dx*2, dx*2], maxY, minY];
            
            beta = nlinfit(X, Y, sigmoideWithOffset_hnd, beta0);

            func = @(x) sigmoideWithOffset_hnd(beta, x);
            
            yy_fit = func(xx);
            
            figure(56); clf; hold on;
            plot(X, Y, 'ro');
            plot(xx, exp(yy0), 'g');
            plot(xx, yy_fit, 'r');
            
        
    end
    
    



end


