%%    

    idx = [1     6     2     7     3     8     4     9     5    10];
 
    savedLetsToShow = cell(2,5);
    idxs_main = 1:10;
    for i = idxs_main
        s = sprintf('signal%d', idx(i));
        fprintf(s);
        savedLetsToShow{i} = eval(s);
    end
    
    [M,N] = size(savedLetsToShow);
    for i = 1:M
        for j = 1:N
            L = max(abs(lims(savedLetsToShow{i,j})));
            savedLetsToShow{i,j} = savedLetsToShow{i,j} / L;
        end
    end
    LetsToShow_stack = reshape(savedLetsToShow', 1, 1, numel(savedLetsToShow));
    LetsToShow_stack = cat(3, LetsToShow_stack{:});
    mergeLetsToShow = tileImages(  LetsToShow_stack, M, N, 0, .5);
    
%     LetsToShow = {S_normal.N, S_normal.C, S_normal.R; S_ori.Z, S_offset.R, S_phase.S};
%     savedLetsToShow = arrayfun(@(i) S_normal.(Let(i)), [1 2 3 4 5; 6 7 8 9 10], 'un', 0);

    cbar_location = 'eastoutside';
    fig_id = 10;
    figure(fig_id); clf;
%     Let = S_normal.letters;

    margn = 20;
    figure(20); clf;
    imagesc(mergeLetsToShow);
    h_ax = gca;
    imageToScale;
    colormap(gray(256));
    ticksOff;
    p_fig = get(gcf, 'position');
    set(gcf, 'position', [p_fig(1), p_fig(2), fliplr(size(mergeLetsToShow)) + [margn, margn]*2]);
    p_ax = get(h_ax, 'position');
    set(gca, 'position', [margn, margn, p_ax(3:4)]);
    
    %%


    [M,N] = size(savedLetsToShow);
    for i = 1:M
        for j = 1:N
            h_ax(i,j) = subplotGap(M,N,i,j); 
            X = savedLetsToShow{i,j};
            imagesc(X); 
            axis image; 
            ticksOff; 
            L = max(abs(lims(X)));
            allL(i,j) = L;
            caxis([-L, L]);

%             colorbar(cbar_location);
        end
    end
%     set(h_ax, 'cLim', max(abs(allL(:)))*[-1, 1]*.9);
    colormap(gray(256));

%         S.turtle=t;
%         X = S.signal7;
%         X = S.signal10;

    imageToScale(fig_id, 1);

        
        
