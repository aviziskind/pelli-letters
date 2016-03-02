
%%
% cf_sizes = [1,2,4,8,16];
% cf_sizes = [1, sqrt(2), 2];
% cf_sizes = [1, 2, 4, 8];
cf_sizes = [8,4,2,1];
nCFs = length(cf_sizes);
nSizes = length(cf_sizes);


doCircles = true;

applyEccLimits = true;
    
applyGlobLimits = true;
    globCircLimits = true;
    

lowerLeftQuadOnly = false;
    
globMaxEcc = max(cf_sizes)*1.4;
figure(1); clf; hold on;

alignCenterCombiningField = false;

cols = get(gca, 'colorOrder');
cols(4,:) = 0;
cols(1:4,:) = cols(4:-1:1, :);

% curvs = [.6, .7, .8, .9];
curvs = [1, 1, 1, 1]*.7;

% cols = { 'brbk'};
linewidths = 2*[ 1,1,1,1];
for i = 1:nSizes
    cf_size = cf_sizes(i);
    stepSize = cf_size * 1;
    
    if applyEccLimits
        maxEcc = cf_size / 0.4;  % cf_size = ecc * 0.4
    else
        maxEcc = globMaxEcc;
    end
    
    if i == 1
        continue;
    end
    
    if alignCenterCombiningField
        xR = [0 : stepSize : maxEcc];
        x_cent = [fliplr(-xR(2:end)), xR];
    else
        %%
        xR = [stepSize/2 : stepSize : maxEcc];
        if lowerLeftQuadOnly
            x_cent = [fliplr(-xR(1:end))];
        else
            x_cent = [fliplr(-xR(1:end)), xR];
        end
            
    end
    
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
            rect_LB = [x,y] - (cf_size/2)*[1,1];
            rect_UR = [x,y] + (cf_size/2)*[1,1];
            rect_WH = (cf_size)*[1,1];
            
            if doCircles
                h = drawCircle(cf_size/2, [x, y], 'color', cols(i,:), 'linewidth', linewidths(i));
%                  h = rectangle('position', [rect_LB, rect_WH], 'curvature', curvs(i), 'edgecolor',  cols(i,:));
            else
%                 h = drawCircle(cf_size/2, [x, y], 'color', cols(i,:), 'linewidth', linewidths(i));
                h = rectangle('position', [rect_LB, rect_WH], 'curvature', curvs(i), 'edgecolor',  cols(i,:));
%                 h = drawSquare(LB, UR, 'color', cols(i,:));
                set(h, 'linewidth', linewidths(i));
            end
        else
            
%             plot(x_g(i), y_g(i), 'k.');
        end
        
    end
    
    axis(globMaxEcc*1.1*[-1, 1, -1, 1])
    axis off;
    
        3;
end

axis equal;


