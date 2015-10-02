
     
          
     %%     
     
     x_wiggle_ori_CJC = [ 5.2,    15,  30,  35,   40,  45,  60, 90 ];
     y_eff_ori_CJC = [ .075, .08, .045,.035, .039, .0207, .0203, .0166 ];
     
     x_wiggle_ori_AS = [ 5.2,    15,  30,     62,];
     y_eff_ori_AS = [ .065, .065, .034,  .018];
     
     x_wiggle_offset_CJC = [ 20.5, 29, 43];
     y_eff_offset_CJC = [ .05, .03, .0265];
     
     x_wiggle_offset_AS = [ 10.5, 25, 43];
     y_eff_offset_AS = [ .07, .03, .0165];
     
     x_wiggle_phase_CJC = [ 5.5, 29];
     y_eff_phase_CJC = [ .073, .034 ];
     

     x_wiggle_ori = [x_wiggle_ori_CJC, x_wiggle_ori_AS];
     y_eff_ori = [y_eff_ori_CJC, y_eff_ori_AS];
     
     x_wiggle_offset = [x_wiggle_offset_CJC, x_wiggle_offset_AS];
     y_eff_offset   = [y_eff_offset_CJC, y_eff_offset_AS];
     
     x_wiggle_phase = [x_wiggle_phase_CJC];
     y_eff_phase = [y_eff_phase_CJC];
     
     
     
     x_wiggle_paper = [x_wiggle_ori, x_wiggle_offset, x_wiggle_phase];
     y_eff_paper = [y_eff_ori,     y_eff_offset , y_eff_phase];
                     
                     
                     %%
    y_eff_avi = [0.0324 0.0318 0.0296 0.0274 0.0242 0.0238 0.0187 0.0167 0.0130 0.0128 0.0128 0.0107 0.0127 0.0113 0.0109 0.0099 0.0092 0.0092 ...
     0.0090 0.0351 0.0323 0.0281 0.0239 0.0185 0.0211 0.0137 0.0124 0.0138 0.0100 0.0130];
 
    idx_curves = {[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19],  [20 21 22 23 24 25 26 27 28 29], 30};
    x_wiggle_avi = [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 5 10 15 20 25 30 35 40 45 50 40.8];
    
    x_wiggle_ori_avi = x_wiggle_avi(idx_curves{1});
    x_wiggle_offset_avi = x_wiggle_avi(idx_curves{2});
    x_wiggle_phase_avi = x_wiggle_avi(idx_curves{3});
    
    y_eff_ori_avi = y_eff_avi(idx_curves{1});
    y_eff_offset_avi = y_eff_avi(idx_curves{2});
    y_eff_phase_avi = y_eff_avi(idx_curves{3});

    %%
     xtick_wig0 = 3;
     x_wiggle_fit = 1 :1:100;
%      n0 = 0.074;   w0 = 15;  % parameters from paper
     n0 = 0.0409;  w0 = 14.1067;  % parameters from my experiments
     
%      y_func = @(w) max(1, n0 ./ (w/w0) ); 
     bentLine = @(b, x) b(1) ./ max(1, x./b(2)); 
     
     b_paper = [0.074, 15];
         
     y_bentFit_paper = bentLine(b_paper, x_wiggle_fit);
     
     b_avi = nlinfit(x_wiggle_avi, y_eff_avi, bentLine, b_paper);
     y_bentFit_avi = bentLine(b_avi, x_wiggle_fit);
     

     clippedLine = @(c, x) clippedLine([c(1), c(2), c(3), c(4)], x); 
     clippedLine90 = @(c, x) clippedLine([c(1), 90, c(2), c(3)], x); 
%      y_func = @(w) min(1, w/w0); 

     c0 = [0, 45, lims(y_eff_paper)'];
     c_paper = nlinfit(x_wiggle_paper, y_eff_paper, ...
         clippedLine, c0);
     
     c_avi = nlinfit(x_wiggle_avi, y_eff_avi, ...
         clippedLine, c0);
     
     y_clippedFit_paper = clippedLine(c_paper, x_wiggle_fit);
     y_clippedFit_avi   = clippedLine(c_avi, x_wiggle_fit);
     
     
     %%
     for i = 1:2
         
         figure(84+i); clf; hold on; box on;
     
%          set(gca, 'xlim', [8, 100], 'yscale', 'log', 'xscale', 'log', 'xtick', [1, 10:10:90], 'ylim', [.01, .1])
         x_wiggle_ori_use = x_wiggle_ori;
         x_wiggle_phase_use = x_wiggle_phase;
         x_wiggle_ori_avi_use = x_wiggle_ori_avi;

         if i == 1  % log-log plot
            
             wiggle_ticks = [xtick_wig0, 5, 10, 15, 25, 40, 60, 90];
             wiggle_ticks_show = wiggle_ticks; wiggle_ticks_show(wiggle_ticks_show == xtick_wig0) = 0;

             wiggle_tick_labels = arrayfun(@(x) sprintf('%d', x), wiggle_ticks_show, 'un', 0);
             wiggle_lims = lims(wiggle_ticks, .05, [], 1);

            set(gca, 'xscale', 'log', 'yscale', 'log', 'xlim', wiggle_lims);
             
             
             x_wiggle_ori_use(x_wiggle_ori_use < 10) = xtick_wig0;
             x_wiggle_phase_use(x_wiggle_phase_use < 10) = xtick_wig0;
             x_wiggle_ori_avi_use(x_wiggle_ori_avi_use < 5) = xtick_wig0;
         elseif i == 2  % linear plot
             set(gca, 'xscale', 'linear', 'yscale', 'linear', ...
                 'xtick', 0:10:90, 'xlim', [-1, 91], 'ylim', [0, .09]);
             
             
         end
         
         mk_size = 8;
         mk_width = 2;
         
    %      plot(x_wiggle_pts, y_eff_pts, 'ro')
         plot(x_wiggle_ori_use, y_eff_ori, 'ko', 'markersize', mk_size, 'linewidth', mk_width)
         plot(x_wiggle_offset, y_eff_offset, 'ks', 'markersize', mk_size, 'linewidth', mk_width)
         plot(x_wiggle_phase_use, y_eff_phase, 'kv', 'markersize', mk_size, 'linewidth', mk_width)


         plot(x_wiggle_ori_avi_use, y_eff_ori_avi, 'bo', 'markersize', mk_size, 'linewidth', mk_width)
         plot(x_wiggle_offset_avi, y_eff_offset_avi, 'bs', 'markersize', mk_size, 'linewidth', mk_width)
         plot(x_wiggle_phase_avi, y_eff_phase_avi, 'bv', 'markersize', mk_size, 'linewidth', mk_width)

         line_w = 2;
         if i == 1
             plot(x_wiggle_fit, y_bentFit_paper, 'k-', 'linewidth', line_w);
             plot(x_wiggle_fit, y_bentFit_avi, 'b-', 'linewidth', line_w);
             leg_loc = 'SW';
             setLogAxesDecimal;
            set(gca, 'xtick', wiggle_ticks, 'ylim', [0.005, .1] ...
                 , 'xticklabel', wiggle_tick_labels ...
             ...
                 );

             
         elseif i == 2
             plot(x_wiggle_fit, y_clippedFit_paper, 'k-', 'linewidth', line_w);
             plot(x_wiggle_fit, y_clippedFit_avi, 'b-', 'linewidth', line_w);
            
             leg_loc = 'NE';
         end
         
         xlabel('Wiggle'); ylabel('Efficiency');
         legend({'Orientation (paper)', 'Offset (paper)', 'Phase (paper)' ...
                 'Orientation (Avi)', 'Offset (Avi)', 'Phase (Avi)'}, ...
             'location', leg_loc, 'fontsize', 10)
         3;
     end    
    
    