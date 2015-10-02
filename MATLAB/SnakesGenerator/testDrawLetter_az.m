function testDrawLetter_az

%%
    opts.pixPerDegree = 7;

    opts.f_cycPerDeg = 1;
    opts.lambda_deg = 0.3; % space constant of gaussian envelope    
    opts.markSpacing_deg = 0.91;

    opts.numGaborsPerLetterHeight = 4.17;
    opts.useModifiedLetters = 2;
    % N - [4.12, 4.18]
    % C - [4.15, 4.18]
    % R - [4.14, 4.18]
    % Z - [4.17, 4.18]
    % R - [
    
    
    S_normal = DrawAlphabet_az('none', [], opts);
    S_ori = DrawAlphabet_az('orientation', -22.5, opts);
    S_offset = DrawAlphabet_az('offset', .4 * .6, opts);
    S_phase = DrawAlphabet_az('phase', 3, opts);
    
    
    cbar_location = 'eastoutside';
    fig_id = 1;
    figure(fig_id); clf;
    colormap(gray(256));
    
    Let = sort(S_normal.letters);
%     LetsToShow = {S_normal.N, S_normal.C, S_normal.R; S_ori.Z, S_offset.R, S_phase.S};
    LetsToShow = arrayfun(@(i) S_normal.(Let(i)), [1 2 3 4 5; 6 7 8 9 10], 'un', 0);
%     LetsToShow = arrayfun(@(i) S_phase.(Let(i)), [1 2 3 4 5; 6 7 8 9 10], 'un', 0);
%     LetsToShow = arrayfun(@(i) S_ori.(Let(i)), [1 2 3 4 5; 6 7 8 9 10], 'un', 0);
%     LetsToShow = arrayfun(@(i) S_offset.(Let(i)), [1 2 3 4 5; 6 7 8 9 10], 'un', 0);

    
    
    [M,N] = size(LetsToShow);
    for i = 1:M
        for j = 1:N
            L = max(abs(lims(LetsToShow{i,j})));
            LetsToShow{i,j} = LetsToShow{i,j} / L;
        end
    end
    LetsToShow_stack = reshape(LetsToShow', 1, 1, numel(LetsToShow));
    LetsToShow_stack = cat(3, LetsToShow_stack{:});
    mergeLetsToShow = tileImages(  LetsToShow_stack, M, N, 0, .5);
    
    nScl = 3;
    margn = 20;
    figure(1); clf;
    imagesc(mergeLetsToShow);
    h_ax = gca;
    
        imageToScale(fig_id, nScl);

    ticksOff;
    p_fig = get(gcf, 'position');
    set(gcf, 'position', [p_fig(1), p_fig(2), fliplr(size(mergeLetsToShow)*nScl) + [margn, margn]*2]);
    p_ax = get(h_ax, 'position');
    set(gca, 'position', [margn, margn, p_ax(3:4)]);
    
    %%
    %%
    
%     m_spc = [0.05,0,0];
%     n_spc = [0,0,.05];
%     for i = 1:M
%         for j = 1:N
%             h_ax(i,j) = subplotGap(M,N,i,j, m_spc, n_spc); 
%             X = LetsToShow{i,j};
%             imagesc(X); 
%             axis image; 
%             ticksOff; 
%             L = max(abs(lims(X)));
%             allL(i,j) = L;
%             caxis([-L, L]);
% 
% %             colorbar(cbar_location);
%         end
%     end
%     set(h_ax, 'cLim', max(abs(allL(:)))*[-1, 1]*.9);
    colormap(gray(256));

%         S.turtle=t;
%         X = S.signal7;
%         X = S.signal10;

    imageToScale(fig_id, 1);

        
        
end