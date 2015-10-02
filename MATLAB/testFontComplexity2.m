function testFontComplexity2

    w = 64;
    
%     Ls = [1,2,3,4,5]; 
    Ls = [6];
    n = length(Ls);
    
    testMode = 'square';
%     testMode = 'two squares';
%     testMode = 'rectangle';
%      testMode = 'two_lines';
%      testMode = 'diamond'
    
    comps_bw = zeros(1,n);
    comps_grey = zeros(1,n);
    
    margin = 6;
    i = 1;
%     
%     for i = 1:1
%                
%         
%         hidxs = margin + [0:Ls(i)-1]; 
%         widxs = margin + [0:Ls(i)-1]; 
% 
%         N = margin * 2 + max(Ls);
%         X = ones(N,N);
% 
%         X( hidxs, widxs ) = 2; 
%                 
% %         comps_bw(i) = calculateFontComplexity(X, 0);
%         comps_grey(i) = calculateFontComplexity(X, 1);
%         %%
%     end

        a = 4;
        wid = Ls(i);
        len = Ls(i)*a;
        M = margin * 2 + wid*2+len;
        N = margin * 2 + len;
        X = zeros(M,N);

        
        idx_top_h = margin + [0:wid-1];
        idx_top_w = margin + [0:len-1];

        idx_left_h = margin + [0:len-1]+wid;
        idx_left_w = margin + [0:wid-1];

        idx_bot_h = margin + len + wid + [0:wid-1];
        idx_bot_w = margin + [0:(len-1)];

        idx_right_h = margin + [0:len-1]+wid;
        idx_right_w = margin + [0:wid-1]+len-wid;
       
        c = 0;
        X(idx_top_h, idx_top_w) = 1;
        X(idx_bot_h, idx_bot_w) = 1;
        X(idx_left_h, idx_left_w) = 1;
%         X(idx_right_h, idx_right_w) = c;
        
        X_0 = X;
        X_05 = X; X_05(idx_right_h, idx_right_w) = 0.5;
        X_1 = X; X_1(idx_right_h, idx_right_w) = 1;
        [cmp_c0, a0, p0] = calculateFontComplexity(X_0, 2, 0);
        [cmp_c0_5, a0_5, p0_5] = calculateFontComplexity(X_05, 2, 0);
        [cmp_c1, a1, p1] = calculateFontComplexity(X_1, 2, 0);
        %%
        
        [cmp_c_eps, a_eps, p_eps] = calculateFontComplexity(X_0, 2, 1);
        %%
        all_cs = [0:.05:1];
        cmps_cs = zeros(size(all_cs));
        for i = 1:length(all_cs)
            X_05(idx_right_h, idx_right_w) = all_cs(i);
            cmps_cs(i) = calculateFontComplexity(X_05, 2);
        end
        
        figure(87); clf;
        plot(all_cs, cmps_cs, '.-');
        hold on;
        plot([0 1], [cmp_c0, cmp_c1], 'ro');
        xlabel('Value of c'); ylabel('Complexity');
        %%
        figure(11); clf;
%         subplot(1,3,1); pcolor(X_0);  axis square; title(sprintf('c=0: a = %.1f, p = %.1f, cmp = %.1f', a0, p0, cmp_c0) );
%         subplot(1,3,2); pcolor(X_05); axis square; title(sprintf('c=0: a = %.1f, p = %.1f, cmp = %.1f', a0_5, p0_5, cmp_c0_5) );
%         subplot(1,3,3); pcolor(X_1);  axis square; title(sprintf('c=1: a = %.1f, p = %.1f, cmp = %.1f', a1, p1, cmp_c1) );
        
        subplot(1,3,1); pcolor(X_0);  axis square; title(sprintf('c=0  : cmp = %.1f', cmp_c0) );
        subplot(1,3,2); pcolor(X_05); axis square; title(sprintf('c=0.5: cmp = %.1f', cmp_c0_5) ) ;
        subplot(1,3,3); pcolor(X_1);  axis square; title(sprintf('c=1  : cmp = %.1f', cmp_c1) );
        colormap(gray);
        
%         title({sprintf('c=0: cmp = %.1f', cmp_c0), sprintf('c=0: cmp = %.1f', cmp_c0)} );

        
    figure(12); clf; hold on;
    image_func = @imagesc;
    shft_name = 'Plus-shifted';
        btclr_name = 'abs(Subtract Orig*5)';
%         image_func = @pcolor;
%         doColorbar = 0;
    h_ax(1) = subplot(1,4,1); h_im(1) = image_func( X  );                  
%                 title({'Original', s(origLetterImage)});   
                    h_t = title('Original');   
                    axis square;  colorbar('location', 'southoutside')
        h_ax(2) = subplot(1,4,2); h_im(2) = image_func(X);                    
%                     title({shft_name, s(imageShifted)});
                    title(shft_name);
                    axis square;colorbar('location', 'southoutside')
        h_ax(3) = subplot(1,4,3); h_im(3) = image_func(X);         
%                     title({btclr_name, s(image_bitCleared)}); 
                    title(btclr_name); 
                    axis square; colorbar('location', 'southoutside')
        h_ax(4) = subplot(1,4,4); h_im(4) = image_func(X); 
%                     title({[shft_name ' again'], s(image_bitCleared_shifted)}); 
                    title([shft_name ' again']); 
                    axis square;colorbar('location', 'southoutside')
%         xlabel(sprintf('c = %.1f', c))
        3;
        set(h_ax, 'xtick', [], 'ytick', []);
        colormap(gray);

        
    function updateImages(c)
        X_05(idx_right_h, idx_right_w) = c;
        set(h_t, 'string', sprintf('Original (c = %.2f)', c)) 
        [~, ~, ~, calc_images] = ...
            calculateFontComplexity(X_05, 2);
        
        [imageShifted1, image_bitCleared1, image_bitCleared_shifted1] = calc_images{:};
        set(h_im(1), 'cdata', X_05);
        set(h_im(2), 'cdata', imageShifted1);
        set(h_im(3), 'cdata', image_bitCleared1);
        set(h_im(4), 'cdata', image_bitCleared_shifted1);
        
        
    end
    
    
    manipulate(@updateImages, {'c', [0:.05:1]}, 'FigId', 20);
    %%
    figure(12);
    for i = 1:length(all_cs)
        updateImages(all_cs(i))
        F(i) = getframe(12);
    end
    % 
    nExtraFrames = 5;
    for i = length(all_cs)+ [1:nExtraFrames]
        F(i) = getframe(12);
    end

    
    %%
    movie2gif(F, 'CtoO.gif');
    3;
    3
    figure(13)
%     movie2
%%
%     figure(45); clf; hold on; box on;
%     plot(Ls, comps_bw, 'bo-');
%     plot(Ls, comps_grey, 'rs:');
% %     ylim([15, 20]);
%     legend('OR-shifted', 'Plus-shifted');
% %     xlabel(xlabel_str);
%     ylabel('Complexity Measure')

3;


end