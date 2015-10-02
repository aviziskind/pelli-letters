%%
figure(56); clf; hold on; box on;

doAverageWithoutError = 1;
%{
x  = [ 0.41, 0.82, 1.65, 3.3, 6.7, 13];
y_av = [0.1000   19.2841   23.7789   11.0397    0.1000];

y1 = [.0031, .019, .035, .083, .065, .001];
y2 = [.001, .001, .17, .109, .03, .001];
y1u = [.0075,   .009,  .008,  .06,   .035,   .003 ];
y1l = [.002,   .009,  .009,  .029,   .046,   .0 ];
y2u = [.0,   .0,      .14,  .03,   .01,   .014 ];
y2l = [.0,   .0,      .15,  .05,   .012,   .0 ];





if doAverageWithoutError
    factor = 1300;
    min_val_old = 0.001;
    min_val_new = 0.1;
    y1f = y1*factor;
    y2f = y2*factor;
    y1f(y1 == min_val_old | y2 == min_val_old) = min_val_old;
    y2f(y1 == min_val_old | y2 == min_val_old) = min_val_old;    
    
%     y_av = 10.^((log10(y1f) + log10(y2f))/2);
    y_av = y1; %10.^((log10(y1f) + log10(y2f))/2);
    y_av(y_av == min_val_old) = min_val_new;
%     y_av = 10.^(log10(y1)); % + log10(y2))/2;

%     x = x(2:end);
%     y_av = y_av(2:end);

%     y_av
     
%     x =   [0.5,  0.8, 1.3, 2.0, 3.2, 5.1, 8.1, 13];
%     y_av = [0.17, 0.9,  1.4, 16, 107, 101, 14, 10];
    
    hnd = plot(x, y_av);
    
   

    
    
else
    hnd(1) = errorbar(x, y1, y1l, y1u, 'bo-');
    hnd(2) = errorbar(x, y2, y2l, y2u, 'ro-');
end
%}

     x_noiseFreq_raw= [0.5,   0.8,   1.3,   2.0,    3.2,   5.1,   8.1,  13];
    y_threshold_raw= [1,     1.5    5.7    11.5   48.7    366.1  116,  11.2 ]; % actual values
    
    plot(x_noiseFreq_raw, y_threshold_raw, 'o', 'markersize', 12, 'linewidth', 2, 'color', .5*[1, 1, 1])
    
    x_noiseFreq = x_noiseFreq_raw;
    y_threshold = y_threshold_raw;
%     y_threshold= [1.0000    2.14    6.06   17.58   95.14  270.34  139.6084   11.2 ]; % slightly smoothed
    
    itp_factor = 10;
    if itp_factor > 1
%     x_noiseFreq = interp1(x_noiseFreq, y_threshold, 
        log_x_itp = linspace(log10(x_noiseFreq(1)), log10(x_noiseFreq(end)), length(x_noiseFreq)*itp_factor);
       
        log_y_th_itp = interp1(log10(x_noiseFreq), log10(y_threshold), log_x_itp, 'pchip');
    %     [log_x_itp, log_y_th_itp] = fourierInterp(log10(x_noiseFreq), log10(y_threshold), itp_factor, lims(log10(x_noiseFreq)));

        x_itp = 10.^log_x_itp;
        y_th_itp = 10.^log_y_th_itp;
        show = 0;
        if show
            %%
            figure(1); clf; hold on;
            plot(x_noiseFreq, y_threshold, 'ro')
            plot(x_itp, y_th_itp, 'k.-');
            set(gca, 'xscale', 'log', 'yscale', 'log')

        end
        
        x_noiseFreq = x_itp;
        y_threshold = y_th_itp;
        
    end

    hnd = plot(x_noiseFreq, y_threshold);
    
    
xlims = [.1, 100];
ylims = [1, 10000];

set(gca, 'xscale', 'log', 'yScale', 'log', 'xlim', xlims, 'ylim', ylims);
setLogAxesDecimal;

% yticks = [.001, .01, .1, 1];
% ytickLabels = {'0.001', '0.01', '0.1', '1'};
% 
% xticks = [0.1, 1, 10, 100];
% xtickLabels = {'0.1', '1', '10', '100'};
% set(gca, 'ytick', yticks, 'ytickLabel', ytickLabels, 'xtick', xticks, 'xtickLabel', xtickLabels, 'ylim', ylims);


line_w = 6;
fontsize = 18;
% line_w = 2;
set(hnd, 'linewidth', line_w, 'markersize', 8)
xlabel('Noise frequency (c/letter)', 'fontsize', fontsize);
% ylabel('Gain', 'fontsize', fontsize);
ylabel('Threshold', 'fontsize', fontsize);
set(hnd(1), 'color', 'k')
if ~doAverageWithoutError
    set(hnd(2), 'color', .6*[1,1,1])
end

        set(gcf, 'position', [1197         338         536         412]);
        set(gca, 'units', 'pixels', 'position', [101    55   348   327]);



        
%{        
        
        % [ 0.41, 0.82, 1.65, 3.3, 6.7, 13]
%%
x = [.5, 1, 2, 4, 8, 16];

for i = 1:length(x)-1
   
    x2(i) = sqrt( (x(i+1).^2 + x(i).^2)/2 );
end

        
        %}