function plotEfficiencyVsComplexity_reducedNet

%%

    S_mod = load('modelPerformance.mat');

    S_red = load([torchPath 'Results' filesep 'ReducedNetwork' filesep 'ReducedModels.mat']);
    %%
    all_n1 = S_red.allNHiddenUnits1; nn1 = length(all_n1);
    all_n2 = S_red.allNHiddenUnits2; nn2 = length(all_n2);
    fontNames = {'Braille', 'Sloan', 'Georgia', 'Yung', 'Kuenstler'};
    nFonts = length(fontNames);
    allSNRs = S_red.all_snrs_test;

    
    model_efficiences = zeros(nn1, nn2, nFonts);
    font_complexities = zeros(1, nFonts);

    for fi = 1:nFonts
        pctCorrect_v_H1_H2_snr = S_red.(fontNames{fi});
        pctCorrect_v_snr_ideal_i = S_mod.pctCorrect_vs_snr_ideal.(fontNames{fi});
        
        for i1 = 1:nn1
            for i2 = 1:nn2
                pctCorrect = squeeze(pctCorrect_v_H1_H2_snr(:, i2,i1));
                model_efficiences(i1, i2, fi) = ...
                getModelEfficiency(allSNRs, pctCorrect, pctCorrect_v_snr_ideal_i(:));
                
            end
        end
        
        font_complexities(fi) = S_mod.fontComplexities.(fontNames{fi});
        
    end
    %%
    figure(5); clf; hold on; box on;
    
%     cols = get(gca, 'colorOrder');
    col_idx = 1;
    leg_arr = {};
        
    for i2 = 1:nn2
        for i1 = 1:nn1
            
            h_line(i1, i2) = plot(font_complexities, squeeze(model_efficiences(i1, i2,:)), [color_s(col_idx) 'o' linestyle(i2) ], 'linewidth', 2);
            col_idx = col_idx + 1;
            leg_arr = [leg_arr, sprintf('%d => %d', all_n1(i1), all_n2(i2))];
        end
    end

%     set(h_line(1), 'color', 'r', 'linestyle', ':', 'marker', 's', 'linewidth', 2, 'markersize', 8)
    efficiencies_human = 9./font_complexities;
    plot(font_complexities, efficiencies_human, 'k^:', 'linewidth', 2, 'markersize', 8)
    leg_arr = [leg_arr, 'Human'];
    legend(leg_arr, 'location', 'best')
    
    set(gca, 'xscale', 'log', 'yscale', 'log');
%     set(gca, 'ylim', [.02, 1], 'xlim', [20, 100]);
    % set(gca, 'ylim', [.01, 1], 'xlim', [10, 100]);
    xlabel('Complexity', 'fontsize', 13)
    ylabel('Efficiency', 'fontsize', 13)

    title('Reduced Network (with retraining)', 'fontsize', 15)
    %%


% end


