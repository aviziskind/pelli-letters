
%%
% cf_sizes = [1,2,4,8,16];
cf_sizes = [1, sqrt(2), 2];
cf_sizes = [1, 2, 4];
nSizes = length(cf_sizes);


doCircles = true;

applyEccLimits = true;
    
applyGlobLimits = true;
    globCircLimits = true;
    
globMaxEcc = 7;
figure(1); clf; hold on;

cols = get(gca, 'colorOrder');
% cols = { 'brbk'};
linewidths = [ 2 2 2 ];
for i = 1:nSizes
    cf_size = cf_sizes(i);
    stepSize = cf_size * 1;
    
    if applyEccLimits
        maxEcc = cf_size / 0.4;  % cf_size = ecc * 0.4
    else
        maxEcc = globMaxEcc;
    end
    
    xR = [0 : stepSize : maxEcc];
    x_cent = [fliplr(-xR(2:end)), xR];
    
%     x_cent = -maxEcc : stepSize : maxEcc;
%     x_cent = x_cent - mean(x_cent) + ;
    y_cent = x_cent;
    
    [x_g, y_g] = meshgrid(x_cent, y_cent);
%     plot(x_cent, y_cent, 'bo');
%     plot(x_g(:), y_g(:), 'ro');
    for j = 1:length(x_g(:))
        x = x_g(j);
        y = y_g(j);
        if globCircLimits
            R = sqrt( x.^2 + y.^2 );
        else
            R = max(abs(x),abs(y));
        end
        if (R < maxEcc || ~applyEccLimits) && (R < globMaxEcc || ~applyGlobLimits)
            if doCircles
                h = drawCircle(cf_size/2, [x, y], 'color', cols(i,:), 'linewidth', linewidths(i));
            else
                LB = [x,y] - (cf_size/2)*[1,1];
                UR = [x,y] + (cf_size/2)*[1,1];
                
                h = drawSquare(LB, UR, 'color', cols(i));
            end
        else
            
%             plot(x_g(i), y_g(i), 'k.');
        end
        
    end
    
    axis(7.7*[-1, 1, -1, 1])
    axis off;
    
        3;
end

axis equal;


