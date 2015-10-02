function plotPCAcoeffsNeededForUncertainty

        allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'GeorgiaUpper', 'Yung', 'Courier', 'Kuenstler'};
        nFonts = length(allFontNames);
        
        allSNRs = [0, 1, 2, 2.5, 3, 4];
        nSNRs = length(allSNRs);
        
        % fontData = ([lettersPath 'fonts.mat']);
        fontData = loadLetters;
        
%         ori_x_y = {[0], [0],  [0]};
%         ori_x_y = {[0], [0,3], [0]};   % 2x1
%         ori_x_y = {[0], [0,3,6], [0]}; % 3x1
%         ori_x_y = {[0], [0:6], [0]};    % 7x1
%         ori_x_y = {[0], [0:6], [0:6]};  % 7x7
%         ori_x_y = {[0], [0:9], [0:9]};  % 10x10
%          ori_x_y = {[-4:2:4], [0], [0]};   % 5 x 1x1
%         ori_x_y = {[-4:2:4], [0:4], [0:4]};   % 5 x 5 x 5
         ori_x_y = {[-4:2:4], [0:9], [0:9]};   % 5 x 10 x 10
        
        
%         oris = [0]; xs = [0:6]; ys = [0];
        [oris, xs, ys] = ori_x_y{:};

        [pca_eff_C, im_th_C, pca_th_C] = deal( cell(1, nFonts) );
        fontComplexities = zeros(1,nFonts);
        nPcaScoresToTest = [1,2,4,10,20,40,100,200,400,1000];
        
        sizeStyle = 'large';
        for fi = 1:nFonts
%%            
            fontName = allFontNames{fi};            
            fd = fontData.(fontName);
            fontComplexities(fi) = fd.fontComplexities_grey(fd.fontSizes == getFontSize(fontName, sizeStyle));

%             folder = [lettersPath 'NoisyLetters' filesep fontName filesep];

            pCorr_im = zeros(1, nSNRs);
            pCorr_pca_C = cell(1, nSNRs);
            
            for si = 1:nSNRs
                
                snr = allSNRs(si);

                pCorr_im(si)    = getIdealPerformance(fontName, snr, oris, xs, ys, 0);
                pCorr_pca_C{si} = getIdealPerformance(fontName, snr, oris, xs, ys, 1);
                
            end
%             nPcaScoresToTest = S_pca.nPcaScoresToTest;

%             nPCAs_use = min(cellfun(@length, pCorr_pca_C));
%             pCorr_pca_C = cellfun(@(x) x(1:nPCAs_use), pCorr_pca_C, 'un', 0);
%%
            pCorr_pca = catCell(pCorr_pca_C);
            nPCAs_use = size(pCorr_pca, 2);

            pca_eff_C{fi} = zeros(1, nPCAs_use);
            im_th_C{fi}   = zeros(1, nPCAs_use);
            pca_th_C{fi}  = zeros(1, nPCAs_use);
            for pca_i = 1:nPCAs_use
                [pca_eff_C{fi}(pca_i), pca_th_C{fi}(pca_i), im_th_C{fi}(pca_i)] = getModelEfficiency(allSNRs, pCorr_pca(:,pca_i), pCorr_im);
            end
                            
            3;
            
        end

        %%
        nPCAs_use_all = min(cellfun(@length, pca_eff_C));
        
        
        pca_eff = catCell(pca_eff_C);
        im_th = catCell(im_th_C);
        pca_th = catCell(pca_th_C);
                
        idx_nPCAs_used = find( all(~isnan(pca_eff),1));

        nPcaScoresToTest_used = nPcaScoresToTest(idx_nPCAs_used);
        
        [fontComplexities_srt, idx_order] = sort(fontComplexities, 'ascend');
        pca_eff_srt = pca_eff(idx_order,:);
        
        figure(44); clf;
%         subplot(1,2,1);
        plot(fontComplexities_srt, pca_eff_srt(:,idx_nPCAs_used), 'o-');
        set(gca, 'xscale', 'log', 'yscale', 'log');
        hold on;
        human_y = 9./fontComplexities_srt;
        plot(fontComplexities_srt, human_y, 'kv:');
        
        legend(legendarray('nPCA = ', nPcaScoresToTest_used));
        
        title(sprintf('Nori = %d,   Nx = %d,   Ny = %d', length(oris), length(xs), length(ys)));
        ylabel('Efficiency');
        xlabel({'Complexity', cellstr2csslist(allFontNames(idx_order), ', ')}, 'fontsize', 8)
%%
%         subplot(1,2,2);
        th_ideal_full = im_th(:,1);
        figure(45); clf;
        plot(fontComplexities_srt, th_ideal_full, 'ks:', 'linewidth', 2); hold on;
        plot(fontComplexities_srt, pca_th(:,idx_nPCAs_used), 'o-'); hold on;
        set(gca, 'xscale', 'log', 'yscale', 'log');
        hold on;
        human_y =  th_ideal_full + log10(fontComplexities_srt(:)/9);
        plot(fontComplexities_srt, human_y, 'kv:');
        
        legend(['Full Image'; legendarray('nPCA = ', nPcaScoresToTest_used); 'Human']);
        
        title(sprintf('Nori = %d,   Nx = %d,   Ny = %d', length(oris), length(xs), length(ys)));
        ylabel('Energy');
        xlabel({'Complexity', cellstr2csslist(allFontNames(idx_order), ', ')}, 'fontsize', 8)

        
        3;
        %%
%         eff_vs_nPCA = zeros(nFonts, nPCAs_use_all);
%         
%         for pca_i = 1:nPCAs_use_all            
%             
%             for fi = 1:nFonts
%          
%                 X = catCell(C)
%             pca_eff_C
%             end
%             
%             
%         end
        3;
        


end


function X = catCell(C)

    min_n = min(cellfun(@length, C));
    C = cellfun(@(x) x(1:min_n), C, 'un', 0);
    X = vertcat(C{:});

end


