%%
% global X1 Y1 X2 Y2 X3 Y3

X1 = [0    0.3010    0.4771    0.6990    1.0414    1.3979    1.3979    1.7404    2.0969    2.4393    2.7896    3.1364];
Y1 = [12.6121   14.5050   15.9771   17.7095   19.2126   20.6210   21.1752   22.7116   23.9481   25.5211   26.5863   27.3053];
   
X2 = [0    0.3010    0.4771    0.6990    1.0792    1.0792    1.7404    2.0828];
Y2 = [12.6121   14.7643   15.8476   17.0631   18.2989   18.8386   21.2817   22.3641];
X3 = [0    0.3010    0.4771    0.6990    1.0792    1.0792    1.7404    2.0828];
Y3 = [12.6121   14.3162   15.4327   16.1555   17.3349   17.8918   19.8929   21.1449];
   
figure(51); clf; hold on; box on;
plot(10.^X1, Y1, 'bo-');
plot(10.^X2, Y2, 'ro-');
plot(10.^X3, Y3, 'go-');
set(gca, 'xscale', 'log', 'yscale', 'log');

all_labels1 = {'1x1', '2x1[1]', '3x1[1]', '5x1[1]', '11x1[1]', '25x1[1]', '5x5[1]', '11x5[1]', '25x5[1]', '25x11[1]', '22x28[1]', '37x37[1]'};

all_labels2 = {'1x1', '2x1[2]', '3x1[2]', '5x1[2]', '12x1[2]', '4x3[2]', '11x5[2]', '11x11[2]'};

all_labels3 = {'1x1', '2x1[3]', '3x1[3]', '5x1[3]', '12x1[3]', '4x3[3]', '11x5[3]', '11x11[3]'};
for i = 2:length(X1)
    text(10.^X1(i), Y1(i), [all_labels1{i} ' \rightarrow'], 'horiz', 'right');
end

for i = length(X2):length(X2)
    text(10.^X2(i), Y2(i), ['\leftarrow', all_labels2{i}]);
end

for i = 1:length(X3)
    text(10.^X3(i), Y3(i), ['\leftarrow', all_labels3{i}]);
end

xlim([0 1500]);

legend({'1 pixel spacing', '2 pixel spacing', '3 pixel spacing'}, 'location', 'NW')

ylim([12, 30]);
xlabel('Number of positions'); ylabel('Threshold'); title('Ideal observer threshold vs uncertainty');


 p_log = [.0842, 1.0867]; 
 n_fit = 1:1000;
 th_fit = 10.^polyval(p_log, log10(n_fit));
    
 plot(n_fit, th_fit, 'k-');
   

%%


   with spacing = 25       
    allUncertaintySets = { getXYset(1,1, 25),  getXYset(1,2, 25), getXYset(2,1, 25), ...
                         getXYset(1,3, 25),  getXYset(3,1, 25), ...
                         getXYset(2,2, 25),  getXYset(2,3, 25), getXYset(3,2, 25),  getXYset(3,3, 25) };

    yy  = [12.1714886,    12.9681781,    13.2348854,    13.4053650,    13.4593395,    13.8274493,    14.0797051,    13.7426773,    14.7009482];
   
    n        = [1 2 3 4 6 9];
    th_x_idx = [1 2 4 6 7 9];
    th_y_idx = [1 3 5 6 8 9];
    th_x = yy(th_x_idx);
    th_y = yy(th_y_idx);
    
    figure(92); clf; hold on; box on;
    plot(n, th_x, 'bo-', 'linewidth', 2);
    plot(n, th_y, 'rs-', 'linewidth', 2);

    
       plot(n_fit, th_fit, 'k^:', 'linewidth', 2);
   
    p_log = polyfit(log10(n), log10(th_x), 1);
    n_fit = 1:10;
    th_fit = 10.^polyval(p_log, log10(n_fit));

    
    set(gca, 'xscale', 'log', 'yscale', 'linear')
   legend({'horizontal (1x1, 1x2, 1x3, 2x3, 3x3)', 'vertical (1x1, 2x1, 3x1, 3x2, 3x3)', ...
       sprintf('best fit : log(y) = %.2f log(x) + %.2f', p_log)}, 'location', 'best');
   title('Thresholds for 1-9 letters (fixed 25 pixel spacing)');

    
    
   %%

%%% sample 1

spc = [1, 2, 4, 6, 8, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20];

samp_id = 3;
if samp_id == 1
    th_horiz =[14.8210   15.2119   14.0723   13.8020   13.5544   13.1772   13.5305   13.2664   13.1167   13.4392   12.7160   12.9849   13.3878   13.5205  13.2976];
    th_vert = [13.9610   13.5846   13.8408   13.9955   13.6485   13.2575   12.9460   12.9583   12.8766   12.5006   13.0478   12.9198   13.4509   13.2614  13.1421];
elseif samp_id == 2    
    th_horiz =[14.6098   14.4468   14.2629   13.5995   13.6043   13.3933   12.9652   13.5287   13.5108   12.8955   13.0029   13.3153   13.2834   13.1224  12.9094];  
    th_vert = [13.9091   14.5106   13.4575   13.8480   13.5864   13.4379   13.4523   13.4666   13.3279   13.1553   13.1074   12.9164   13.2467  13.5690   13.7181];      
elseif samp_id == 3
    th_horiz =[14.6881   14.7765   14.0850   13.1335   12.7966   12.9753   12.8109   12.8156   12.9189   12.6078   12.5990   13.1236   13.1483   12.8507 12.5070];
    th_vert =[13.6246   13.6755   13.6136   13.6970   13.5727   13.3094   13.1311   13.0881   13.2730   12.8741   12.4163   13.0970   12.8566   13.0459    13.1994];
end

th_exp_2 = 10.^polyval(p_log, log10(2));

    
figure(56); clf;hold on; box on;
plot(spc, th_horiz, 'bo-', 'linewidth', 2); 
plot(spc, th_vert, 'rs-', 'linewidth', 2); 
  drawHorizontalLine(th_exp_2, 'linewidth', 2)

xlabel('Spacing'); ylabel('Threshold'); title('Threshold of ideal observer for 2 letters vs spacing, Bookman k15'); 
legend('Horizontal spacing', 'Vertical spacing', '(expected from fit)')
ylim([12 16]);



%%

% th_4 = [17.0944435,    15.4407937,    15.8221125;
%         14.4658834,    14.4137451,    14.3082554;
%         13.7669591,    14.2864438,    13.9153009;
%         13.9214147,    13.7997505,    13.9939090];

  th_4 = [16.8007   15.0022   15.5192;
          13.7975   14.1593   14.4381;
          13.5141   14.1501   13.6934;
          13.7688   13.8443   13.5928];
th_x = th_4(:,1);
th_y = th_4(:,2);
th_xy = th_4(:,3);
spc = [1, 8, 10, 12];    
    
figure(57); clf; hold on; box on;
plot(spc, th_x, 'bo-', 'linewidth', 2);
plot(spc, th_y, 'gs-', 'linewidth', 2);
plot(spc, th_xy, 'r*-', 'linewidth', 2);

th_exp_4 = 10.^polyval(p_log, log10(4));

  drawHorizontalLine(th_exp_4, 'linewidth', 2)

xlabel('spacing'); ylabel('Threshold'); legend({'1 x 4', '4 x 1', '2 x 2', 'expected from fit'});
title({'Threshold for ideal observer for 4 letters', 'Bookman k15 [Image = 75x75]'});
    
%%
snrs = [0    0.5000    1.0000    1.5000    2.0000    2.5000    3.0000    3.5000    4.0000    4.5000    5.0000];

th_1pos =   [13.1200   26.2000   56.8500   90.1400   99.4200  100.0000  100.0000  100.0000  100.0000  100.0000  100.0000];
   th_1000pos = [    3.8900    5.4400   17.9000   73.3500   98.8000  100.0000  100.0000  100.0000  100.0000  100.0000  100.0000];
   figure(84); clf; hold on; box on;
   plot(10.^snrs, th_1pos, 'bo-');
   plot(10.^snrs, th_1000pos, 'ro-');
   xlabel('E/N'); ylabel('pct correct');
   xlim(10.^[0, 3]);
   set(gca, 'xscale', 'log')
   legend('1 position', '1369 positions');
   title('Psychometric curves for ideal observer');
   
   
  %%
%
    
    
    
    
%%
  
  allUncertaintySets = { ...
      getXYset(12,2, 1),  getXYset(6,4, 1), getXYset(4,6, 1), getXYset(2,12, 1),  ...
     getXYset(12,2, 5),  getXYset(6,4, 5), getXYset(4,6, 5), getXYset(2,12, 5),  ...
     getXYset(12,2, 8),  getXYset(6,4, 8), getXYset(4,6, 8), getXYset(2,12, 8),  ...
     getXYset(12,2, 10),  getXYset(6,4, 10), getXYset(4,6, 10), getXYset(2,12, 10),  ...
     getXYset(12,2, 12),  getXYset(6,4, 12), getXYset(4,6, 12), getXYset(2,12, 12),  ...
     getXYset(12,2, 14),  getXYset(6,4, 14), getXYset(4,6, 14), getXYset(2,12, 14),  ...
    };
   

th_24 = [...
    20.5564   20.9899   20.6735   19.9858
    16.8496   17.5561   17.6342   16.9052
    16.3924   16.5418   16.7419   16.6236
    16.4640   16.2509   16.5402   16.0458
    16.2850   16.1016   15.9814   16.0771
    15.9756   16.0709   15.3789   16.1202
    15.8622   16.1807   15.7485   15.8176
    16.0586   16.1519   16.1875   15.2064
    ];

       
   th_12_2 = th_24(:,1);
   th_6_4 = th_24(:,2);
   th_4_6 = th_24(:,3);
   th_2_12 = th_24(:,4);
    spc = [1, 5, 6, 7, 8, 10, 12, 14];    
    
    figure(58); clf; hold on; box on;
    plot(spc, th_12_2, 'bo-', 'linewidth', 2);
    plot(spc, th_6_4, 'gs-', 'linewidth', 2);
    plot(spc, th_4_6, 'r*-', 'linewidth', 2);
    plot(spc, th_2_12, 'm^-', 'linewidth', 2);
   th_exp_24 = 10.^polyval(p_log, log10(24));
   drawHorizontalLine(th_exp_24, 'linewidth', 2);

xlabel('spacing'); ylabel('Threshold'); legend({'12 x 2', '6 x 4', '4 x 6', '2 x 12', 'expected from fit'});
title({'Threshold for ideal observer for 24 letters', 'Bookman k15 [Image = 195x195]'});

   
   
%%

                sizeStyle = 'k15';  imageSize = [95, 95];
             spc = 8;
              allUncertaintySets = { getXYset(1,1, spc),  getXYset(2,2, spc), getXYset(3,3, spc),  ...
                                     getXYset(4,4, spc),  getXYset(6,6, spc), getXYset(8,8, spc),  ...
                                     getXYset(10,10, spc),  getXYset(1,9, spc), getXYset(9,1, spc), ...
                                     };

    th_spc8_all = [12.4830   14.4012   15.2467   15.8259   16.2891   17.6307   18.2181   14.7396   14.7468];
    
    n_spc8 = [1, 4, 9, 16, 36, 64, 100];
    th_spc8 = th_spc8_all(1:7);
    th_x9 = th_spc8_all(8);
    th_y9 = th_spc8_all(9);
    
    
   figure(93); clf; hold on; box on;
    plot(n_spc8, th_spc8, 'bo-', 'linewidth', 2);
%     plot(9, th_x9, 'rs-');
%     plot(9, th_y9, 'ks-');
   set(gca, 'xscale', 'log', 'yscale', 'log')
   title({'Ideal observer threshold for square blocks of letters, 8 pixel spacing', 'Bookman k15, image size 95x95'});
  

all_labels_spc8 = {'1x1', '2x2[8]', '3x3[8]', '4x4[8]', '6x6[8]', '8x8[8]', '10x10[8]'};

for i = 1:length(all_labels_spc8)
    text(n_spc8(i), th_spc8(i), ['\leftarrow ' all_labels_spc8{i}], 'horiz', 'left');
end



    p_log_8 = polyfit(log10(n_spc8), log10(th_spc8), 1);
    n_fit_8 = n_spc8;
    th_fit_8 = 10.^polyval(p_log_8, log10(n_fit_8));
    th_fit_1 = 10.^polyval(p_log, log10(n_fit_8));
      
    
    plot(n_fit_8, th_fit_8, 'r^-', 'linewidth', 2);
    plot(n_fit_8, th_fit_1, 'kv-', 'linewidth', 2);

    legend({'data with 8 pixel spacing', ['fit (8 pixel spacing) : ' sprintf('best fit : log(y) = %.3f log(x) + %.3f', p_log)],...
        ['fit (25 pixel spacing) : ' sprintf('best fit : log(y) = %.3f log(x) + %.3f', p_log_8)]}, 'location', 'best');
%     xlim(lims(n_spc8, .1, [], 1));
    xlim([1 max(n_spc8)*2]);
    ylim(lims(th_spc8, .07, [], 1));

    
%%
   
   
  th_spc5 = [12.1761395,    15.1178810,    16.2975550,    17.0850869,    17.9849669,    18.8244933,  18.5629850];
   
   sizeStyle = 'k15';  imageSize = [75, 75];
 spc = 5;
  allUncertaintySets = { getXYset(1,1, spc),  getXYset(2,2, spc), getXYset(3,3, spc),  ...
             getXYset(4,4, spc),  getXYset(6,6, spc), getXYset(8,8, spc), getXYset(10,10, spc), };

   
    n_spc5 = [1, 4, 9, 16, 36, 64, 100];    
    
   figure(94); clf; hold on; box on;
    plot(n_spc5, th_spc5, 'bo-', 'linewidth', 2);
%     plot(9, th_x9, 'rs-');
%     plot(9, th_y9, 'ks-');
   set(gca, 'xscale', 'log', 'yscale', 'log')
   title({'Ideal observer threshold for square blocks of letters, 5 pixel spacing', 'Bookman k15, image size 95x95'});
  

all_labels_spc5 = {'1x1', '2x2[5]', '3x3[5]', '4x4[5]', '6x6[5]', '8x8[5]', '10x10[5]'};

for i = 1:length(all_labels_spc5)
    text(n_spc5(i), th_spc5(i), ['\leftarrow ' all_labels_spc5{i}], 'horiz', 'left');
end



    p_log_5 = polyfit(log10(n_spc5), log10(th_spc5), 1);
    n_fit_5 = n_spc5;
    th_fit_5 = 10.^polyval(p_log_5, log10(n_fit_5));
%     th_fit_1 = 10.^polyval(p_log, log10(n_fit_5));
      
    
    plot(n_fit_5, th_fit_5, 'r^-', 'linewidth', 2);
    plot(n_fit_5, th_fit_1, 'kv-', 'linewidth', 2);

    legend({'data with 5 pixel spacing', ['fit (5 pixel spacing) : ' sprintf('best fit : log(y) = %.3f log(x) + %.3f', p_log)],...
        ['fit (25 pixel spacing) : ' sprintf('best fit : log(y) = %.3f log(x) + %.3f', p_log_5)]}, 'location', 'best');
%     xlim(lims(n_spc5, .1, [], 1));
    xlim([1 max(n_spc5)*2]);
    ylim(lims(th_spc5, .07, [], 1));                                 
   