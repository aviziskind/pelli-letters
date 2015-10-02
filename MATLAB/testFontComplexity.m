function testFontComplexity

    w = 64;
    
%     Ls = [2,3,4,5:20]; 
%     Ls = [32:32 : 20 : 400]; 
    Ls = 16*2.^[1:5];
%     Ls = [2, 20]; 
%     Ls = [100:100:1000];
%     Ls = [0:1:90];
% %     Ls = [0, .5];
%     Ls = [100];
    n = length(Ls);
    
    testMode = 'square';
    testMode = 'square_inSpace';
%     testMode = 'two squares';
%     testMode = 'rectangle';
%     testMode = 'rotatedSquare_varySize';
%     testMode = 'rotatedSquare_varyAngle';
%      testMode = 'two_lines';
%      testMode = 'diamond'
%     testMode = 'L';
    
    comps_bw = zeros(1,n);
    comps_plus = zeros(1,n);
    comps_grey = zeros(1,n);
    comps_grey2 = zeros(1,n);

   [areas_bw, perims_bw,  areas_plus, perims_plus,  areas_grey, perims_grey,  areas_grey2, perims_grey2] = deal(zeros(1, n));

    
    bkg = 0;
    fg = 1;
    
    margin = 16;
    predicted = nan;
    
    for i = 1:n
        
       
        
        switch testMode
            case 'square',
                
                hidxs = margin + [0:Ls(i)-1]; 
                widxs = margin + [0:Ls(i)-1]; 
                
                N = margin * 2 + max(Ls);
                X = ones(N,N)*bkg;
                
                X( hidxs, widxs ) = fg; 
                predicted = 16;
                
                X(64, 64) = 0;
                
                xlabel_str = 'Length of side of square';
                
                Y{i} = X;
                2;
                
            case 'square_inSpace';
                L = 10;
                margin = 5;
                X = ones(Ls(i), Ls(i))*bkg;
                
                hidxs = round( Ls(i)/2- L/2) + [0:L-1]; 
                widxs = round( Ls(i)/2- L/2) + [0:L-1]; 
                
                X( hidxs, widxs ) = fg; 
                predicted = 16;
                                
                xlabel_str = 'Length of side of square';
                
                Y{i} = X;
                2;
                
            case 'two squares'
                hidxs = margin + [0:Ls(i)-1]; 
                widxs = margin + [0:Ls(i)-1]; 
                
                N = margin * 2 + max(Ls)*3;
                X = zeros(2*N,2*N+20);
                
                X( hidxs, widxs ) = 1; 
                X( hidxs, widxs+Ls(i)*2+3 ) = 1; 
                xlabel_str = 'Length of side of each square';
            case 'rectangle',
                
                a = 3;
                hidxs = margin + [0:Ls(i)-1]; 
                widxs = margin + [0:(Ls(i)*a)-1]; 
                
                N = margin * 2 + max(Ls)*a;
                X = ones(N,N)*bkg;
                
                X( hidxs, widxs ) = fg; 
                
                predicted = 4*a + 8 + 4/a;
                xlabel_str = 'Width of rectangle';
            case 'rotatedSquare_varySize'
                a = 1;
                
                rotateHoriz = true;
                if rotateHoriz
                    
%                     L_side = Ls(i);
                    
                    L_side = Ls(i);
                    angle = 45;
                    
                    hidxs = margin + [0:L_side-1]; 
                    widxs = margin + [0:(L_side*a)-1]; 

                    N = margin * 2 + max(Ls)*a;
                    X = ones(N,N)*bkg;
                
                    X( hidxs, widxs ) = fg; 
                    X_orig = X;
                    X = imrotate(X, angle, 'bilinear');
                    
%                     X(X>0) = 1;
%                     X(X<0) = 0;
                    
                else
                    
                end
                    
                
                predicted = 4*a + 8 + 4/a;
                xlabel_str = 'Width of rectangle';
                 
            case 'rotatedSquare_varyAngle'
                a = 1;
                
                L_side = 100;
                angle = Ls(i);
                
                              
                N = margin * 2 + round( L_side*a*(sqrt(2)) );
                X = ones(N,N)*bkg;

                hidxs = [0:L_side-1]; 
                widxs = [0:(L_side*a)-1]; 

                hidxs = ceil(N/2) +hidxs -ceil(mean([0:L_side-1])); 
                widxs = ceil(N/2) +widxs -ceil(mean([0:L_side*a-1])); %  [0:(L_side*a)-1]; 

                

                X( hidxs, widxs ) = fg; 
                X_orig = X;
                X = imrotate(X, angle, 'bilinear', 'crop');
                
%                 X = X/sum(X(:))*(L_side^2);

%                     X(X>0) = 1;
%                     X(X<0) = 0;
                    
                    
                
                predicted = 4*a + 8 + 4/a;
                 xlabel_str = 'Width of rectangle';
                 
            case 'L',
                
                a = 3;
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

                X(idx_top_h, idx_top_w) = 1;
                %         X(idx_bot_h, idx_bot_w) = 1;
                X(idx_left_h, idx_left_w) = 1;
                xlabel_str = 'Size of L-shape';
                %         X(idx_right_h, idx_right_w) = c;
                
            case 'two_lines'
                % lines have aspect ratio of 1xa
                a = 4;
                M = margin * 2 + max(Ls)*3+1;
                N = margin * 2 + (max(Ls))*a+1;
                X = zeros(M,N);
                
                
                start = 5;
                idxh1 = start + [0:(Ls(i)-1)];
                idxw1 = start + [0:(Ls(i)*a-1)];
                
                idxh2 = start + Ls(i)*2 + [0:Ls(i)-1];
                idxw2 = start + [0:(Ls(i)*a-1)];
                
                X(idxh1, idxw1) = 1;
                X(idxh2, idxw2) = 1;
                
                xlabel_str = 'Width of lines';
        end
        %%
        figure(44); clf;
        imagesc(X);
        axis equal tight;
        drawnow;
        3;
        %%
        [comps_bw(i), ~, areas_bw(i), perims_bw(i)] = calculateFontComplexity(X, 0);
        [comps_plus(i), ~, areas_plus(i), perims_plus(i)] = calculateFontComplexity(X, 1);
        [comps_grey(i), ~, areas_grey(i), perims_grey(i)] = calculateFontComplexity(X, 2);
        [comps_grey2(i), ~, areas_grey2(i), perims_grey2(i)] = calculateFontComplexity(X, 3);
        %%
    end
    %%
    3;
    figure(45); clf; hold on; box on;
    plot(Ls, comps_bw, 'bo-');
    plot(Ls, comps_plus, 'gs-');
    plot(Ls, comps_grey, 'rs:');
    plot(Ls, comps_grey2, 'm*:');
    
    if ~isnan(predicted)
        drawHorizontalLine(predicted, 'color', 'k', 'linestyle', '-', 'linewidth', 2)
        pred_str = {'predicted'};
    else
        pred_str = {};
    end
    
    
%     ylim([15, 20]);
    legend('OR-shifted', 'Plus-shifted', 'Grey-scale', 'Fourier', pred_str{:});
    xlabel(xlabel_str);
    ylabel('Complexity Measure')
    3;
%%
%     figure(46); clf; hold on; box on;
%     plot(Ls, areas_bw, 'bo-');
%     plot(Ls, areas_plus, 'gs-');
%     plot(Ls, areas_grey, 'rs:');
%     plot(Ls, areas_grey2, 'm*:');
% 
%     figure(47); clf; hold on; box on;
%     plot(Ls, perims_bw, 'bo-');
%     plot(Ls, perims_plus, 'gs-');
%     plot(Ls, perims_grey, 'rs:');
%     plot(Ls, perims_grey2, 'm*:');
    
3;


end