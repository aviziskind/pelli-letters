function plotCrowding

%%
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'GeorgiaUpper', 'Yung', 'Kuenstler'};
% 	allFontNames      = {'Braille'};
%     allTDRs = [-2, -1, -0.5, 0];

% 	fontName      = 'CourierU';
	fontName      = 'Sloan';
    allTDRs = [0];

    expTitle = 'CrowdedLetters';
    netType = 'ConvNet';
    

    opt.skipIfDontHaveFile = 1;    
    showErrorBarsForMultipleTrials = 1;

    %{
    switch netType
        case 'ConvNet',
            

%             allNStates = {  {3, 8, 60}, {6, 16, 120}, {6, 16, 30}, {6,16, 15}, {6,16,8}, {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };
%             allNStates = {  {3, 8, 60}, {6, 16, 120}, {6, 16, 30}, {6,16, 15}, {6,16,8}, {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };

%             allNStates = {   {6,16, 30}, {6,16,60}, {6,16,120}, {6,16,240}, {6,16,480}, {6,16,960} } ;%, {12,32,240},  {3,8,10}, {3,8,5}, {3,8,3}, {3,8,30}, {6,8,10}, {12,8,10} };

            
            allConvNetOptions = struct('netType', 'ConvNet', ...
                                        'tbl_nStates', {allNStates}, ...
                                        'filtSizes', filtSizes,...
                                        ...'tbl_filtSizes', {allFiltSizes}, ...
                                        ...
                                        'doPooling', doPooling, ...
                                        'poolSizes', poolSize, ...
                                        ...'tbl_poolSizes', {allPoolSizes}, ...
                                        'poolType', poolType, ...
                                        ...'tbl_poolType', {allPoolTypes}, ...
                                        'poolStrides', poolStrides ... 
                                      );
            allNetworks = expandOptionsToList(allConvNetOptions);

%             network_noPooling = struct('netType', 'ConvNet', ...
%                                         'nStates', allNStates{1}, ...
%                                         'filtSizes', filtSizes,...
%                                         'doPooling', false, ...
%                                         'poolType', poolType, ...
%                                         'poolSizes', 0, ...
%                                         'poolStrides', poolStrides ...
%                                         ...'tbl_filtSizes', {allFiltSizes}, ...
%                                       );
%             allNetworks = [network_noPooling, allNetworks];

            
        case 'MLP',
           
           allNHiddenUnits = { {6}, {12}, {24}, {48}, {96},   {6, 16}, {6, 32}, {6, 64},   {12, 16}, {12, 32}, {12, 64} };
           allMLPoptions = struct('netType', 'MLP', ...
                                        'tbl_nHiddenUnits', {allNHiddenUnits} ...
                                      );
            allNetworks = expandOptionsToList(allMLPoptions);
    end
    nNetworks = length(allNetworks);

        
    nFonts = length(allFontNames);
%}
            
%   
%         let_opts = {{2, '1.0let' }, ...
%                     {2, '1.5let' }, ...
%                     {2, '2.0let' }, ...
%                     {2, '3.0let' } ...
%                     };
%                 


    sizeStyle = 'med';
    all_LetterOpts =  {  ...
                         { {15,5,60}, 1,     0}, ...
                         { {15,5,60}, 'all', 0}, ...
                         ...
                         { {15,5,60}, 1,     4}, ...
                         { {15,5,60}, 'all', 4}, ...
                         ...   
                         { {15,30,45}, 'all', 0}, ...
                         { {15,30,45}, 'all', 4} ...
                         ...
                         { {12,25,62}, 'all', 0}, ...
                         { {12,25,62}, 'all', 4} ...
                         };
                                
                
%         ori_x_y = {[0], [0,3], [0]};   % 2x1
%         ori_x_y = {[0], [0,3,6], [0]}; % 3x1
%         ori_x_y = {[0], [0:6], [0]};    % 7x1
%         ori_x_y = {[0], [0:6], [0:6]};  % 7x7
%         ori_x_y = {[0], [0:9], [0:9]};  % 10x10
%          ori_x_y = {[-4:2:4], [0], [0]};   % 5 x 1x1
%         ori_x_y = {[-4:2:4], [0:4], [0:4]};   % 5 x 5 x 5
%          ori_x_y = {[-4:2:4], [0:9], [0:9]};   % 5 x 10 x 10
        
        
%         oris = [0]; xs = [0:6]; ys = [0];
        let_opts = all_LetterOpts{4};
%         all_nDistractors = [1,2];
        all_nDistractors = [1];


    crowdedLetterOpts.xrange = let_opts{1};
    crowdedLetterOpts.targetPosition = let_opts{2};
    crowdedLetterOpts.SNR = let_opts{3};
    crowdedLetterOpts.sizeStyle = sizeStyle;
    crowdedLetterOpts.expTitle = 'Crowded';

    crowdedLetters_str = getCrowdedLetterOptsStr(crowdedLetterOpts);
%     crowdedLetterOpts.tf_pca = tf_pca;

    %%

%     allNStates = {  {6, 120}, {12, 240}, {24, 480} };
%     allNStates = { {6,15}, {6, 120}, {12, 240}, {24, 480} };
%     allNStates = {  {6, 120}, {24, 480}  };
%      allNStates = { {6,15}, {6,30}, {6,60}, {6,120}, {12, 60}, {24,120}, {48,120}  };
%      allNStates = { {6,15}, {6,30}, {6,60}, {6,120} };

%      allNStates = { {6,15} }; %, {6,30}, {6,60}, {6,120} };
    allNStates = {  {6,120}, }; % {6,30}, {6,60}, {6,120} };


%     allNStates = { {6,120}, {12,120}, {24,120} };
%     allNStates = { {6,15}, {6,30}, {6,60}, {6,120} };
%     allNStates = { {12,60}, {6,120}, {12, 120}, {24, 120} };

%     allPoolSizes = [0,2,4,8,12,16,20,24,28 32];
%     allPoolSizes = [0,2,4,6,8,10,12,16];
    allPoolSizes = [2,4,8];
%     allPoolSizes = [0,2,4,8,12,16,20,24,28 32];
    allPoolSizes_C = num2cell(allPoolSizes);

    if iscell(allNStates(1))
        allNStates = cellcell2cellarray(allNStates);
    end
    

    %%%%%%%
    filtSizes = [5,4];
    allFiltSizes = {2,4,5,10,20};
    
    doPooling = 1;
    poolSize = 4;
    
    poolStrides = 2;
%     poolStrides = 'auto';
    
    poolType = 2;
    allPoolTypes = {1,2,'MAX'};

    nTrials = 10;
    %%%%%%%%
    
    if strcmp(poolStrides, 'auto')
        allPoolSizes_use = allPoolSizes;
    else
        allPoolSizes_use = allPoolSizes(allPoolSizes == 0 | allPoolSizes >= poolStrides);
    end
    allPoolSizes_use_C = num2cell(allPoolSizes_use);

    xrange = [crowdedLetterOpts.xrange{:}];
    allSpacings_pix =  (xrange(1) : xrange(2) : xrange(3))-xrange(1); 
%     allSpacings_pix = [xrange(2): xrange(2) : xrange(3)-xrange(1)]; 
%     diff( linspace(xrange(1), xrange(2), xrange(3)) )
%     allSpacings_pix = allSpacings_pix(1);
    
     
    
    
    switch sizeStyle
        case 'sml', allSpacings_pix = allSpacings_pix(allSpacings_pix >= 15);
        case 'med', allSpacings_pix = allSpacings_pix(allSpacings_pix >= 25);
        case 'big', allSpacings_pix = allSpacings_pix(allSpacings_pix >= 25);
    end
    
    allSpacings_C = arrayfun(@(npix) sprintf('%dpix', npix), allSpacings_pix, 'un', 0);
            
    
    x_name = 'poolsize';  
%     x_name = 'spacing';   

%     multiple_lines = 'networks';
    multiple_lines = '';



    multiple_networks = '';
%     multiple_networks = 'poolSizes';



    switch x_name
        case 'poolsize', x_vals = allPoolSizes_use;
            x_name_nice = 'Size of Pooling Window';
        case 'spacing',  x_vals  = allSpacings_pix;
            x_name_nice = 'Spacing Between Letters (pixels)';
    end
    nX = length(x_vals);
        
    switch multiple_networks
        case 'poolSizes', nNetworks = length(allPoolSizes_use);
        case 'nStates',   nNetworks = length(allNStates);
        case '', nNetworks = 1;
    end
    
    
    nPoolSizes = length(allPoolSizes_use);

    
    nStates_default = allNStates{1};
    poolSize_default = 4;
    
    switch multiple_lines
        case 'networks', nLines = nNetworks;  
        case 'poolsize', nLines = nPoolSizes;  assert(~strcmp(x_name, 'poolsize'));
        case '', nLines = 1;
    end
    
%     multiple_plots = '
    
    
%     nPoolSizes = length(allPoolSizes_use);

    
    doFigs = 1;
    
    if any(doFigs == 1) % look at pct correct vs spacing, for different pool sizes.
    
        all_pCorr1 = nan(nX, nLines, nTrials);
        all_pCorr2 = nan(nX, nLines, nTrials);
%         if max(all_nDistractors) == 2
            all_pCorr3 = nan(nX, nLines, nTrials);
%         end


        for line_i = 1:nLines
            

            for xi = 1:nX
                

            %             poolStrides = 'auto';

                network_i = struct('netType', 'ConvNet', ...
                    'nStates', nStates_default, ... 
                    'filtSizes', filtSizes,...
                    ...'tbl_filtSizes', {allFiltSizes}, ...
                    ...
                    'doPooling', doPooling, ...
                    ...
                    ...,'poolSizes', poolSize, ...
                    'poolSizes', poolSize_default, ...
                    ...
                    'poolType', poolType, ...
                    ...'tbl_poolType', {allPoolTypes}, ...
                    ...
                    'poolStrides', poolStrides ... 
                );

                switch x_name
                    case 'poolsize', network_i.poolSizes = allPoolSizes_use_C{xi};
                    case 'spacing',  crowdedLetterOpts.spacing = allSpacings_C{xi};
                end

                switch multiple_lines
                    case 'networks', 
                        switch multiple_networks
                            case 'poolSizes', network_i.poolSizes = allPoolSizes_use_C{line_i};
                            case 'nStates',   network_i.nStates = allNStates{line_i};
                        end
                        
                    case 'poolsize', network_i.poolSizes = allPoolSizes_use(line_i);
                end

                if xi == 1
                    allNetworks_leg(line_i) = network_i; %#ok<AGROW>
                end


                [pCorr1, pCorr2_v_nDist_spacing_tdr] = loadCrowdingResults(expTitle, fontName, all_nDistractors, allSpacings_pix, allTDRs, network_i, crowdedLetterOpts, opt, nTrials);
                % size(pCorr1) = [nNetworks, 1];
                % size(pCorr2) = [nNetworks, nNDistractors, nSpacings, nTDRs];

                if strcmp(x_name, 'spacing')
                    all_pCorr1(1,line_i, :)  = pCorr1(:);
                    all_pCorr2(:,line_i, :) = pCorr2_v_nDist_spacing_tdr(1,:,1,:);    
                    if max(all_nDistractors) == 2
                        all_pCorr3(:,line_i, :) = pCorr2_v_nDist_spacing_tdr(2,:,1,:);    
                    end
                    break;
                elseif strcmp(x_name, 'poolsize')
                    3;
%                 pCorr2 = pCorr2_v_spacing_tdr(end); %(:,end);

%                 pCorr2 = pCorr2_v_spacing_tdr(1); %(:,end);
%                         pCorr2 = mean(pCorr2_v_nDist_spacing_tdr); %(:,end);
        %%
                    all_pCorr1(xi,line_i,:) = pCorr1;
                    all_pCorr2(xi,line_i,:) = pCorr2_v_nDist_spacing_tdr(1,1,:,:);    
                    if max(all_nDistractors) == 2
                        all_pCorr3(xi,line_i, :) = pCorr2_v_nDist_spacing_tdr(1,2,:,:);    
                    end

                  
                end
            end

        end


    %%
        all_pCorr1_M = nanmean(all_pCorr1, 3);
        all_pCorr1_S = nanstderr(all_pCorr1, 3);   
        
        all_pCorr2_M = nanmean(all_pCorr2, 3);
        all_pCorr2_S = nanstderr(all_pCorr2, 3);   
        
        all_pCorr3_M = nanmean(all_pCorr3, 3);
        all_pCorr3_S = nanstderr(all_pCorr3, 3);   
            
        figure(7); clf; hold on; box on;
            sizeStyle_full = switchh(sizeStyle, {'sml', 'med', 'big', 'dflt'}, {'Small', 'Medium', 'Large', 'Default'});


    %     niceLegendFields = {'filtSizes', 'poolSizes', 'doPooling'};
        niceLegendFields = {'poolSizes'}; %'doPooling', 'poolSizes', 'poolStrides'}; %'filtSizes', 'doPooling'};
        [~, legend_str_nice] = arrayfun(@(n) getNetworkStr(n, niceLegendFields), allNetworks_leg, 'un', 0);        


    %     cols = ['bgrk'];
        lineSt = {'-', '--'};
        mkrs = ['os*v'];
        colors_use = 'brgcm';
        markers_use = 'oxs*dph';
        c_ord = get(gca, 'colorOrder');
        c_ord = c_ord([1,3,2,4:end], :);
        set(gca, 'colorOrder', c_ord);
        for line_i = 1:nLines
    %         line_s = lineSt{ floor(line_i/6)+1};
            line_s = '-'; %linestyle( floor(line_i/6) );
            mkr_s = marker(line_i, markers_use);   % marker( floor(line_i/6)+2);
    %         mkr_s = marker( line_i+1 );
            clr_s = color_s(line_i, colors_use);
            line_w = 2;
            if (nTrials > 1) && any(all_pCorr1_S(:,line_i) > 0) || any(all_pCorr2_S(:,line_i) > 0) && showErrorBarsForMultipleTrials
                h(1,line_i) = errorbar(x_vals, all_pCorr1_M(:,line_i), all_pCorr1_S(:,line_i), [mkr_s clr_s '-'], 'markersize', 8);
                h(2,line_i) = errorbar(x_vals, all_pCorr2_M(:,line_i), all_pCorr2_S(:,line_i), [mkr_s clr_s '--'], 'markersize', 8);
                h(3,line_i) = errorbar(x_vals, all_pCorr3_M(:,line_i), all_pCorr3_S(:,line_i), [mkr_s clr_s ':'], 'markersize', 8);
            else
                h(1,line_i) = plot(x_vals, all_pCorr1(:,line_i), [mkr_s clr_s '-'], 'markersize', 8);
                h(2,line_i) = plot(x_vals, all_pCorr2(:,line_i), [mkr_s clr_s '--'], 'markersize', 8);
                h(3,line_i) = plot(x_vals, all_pCorr3(:,line_i), [mkr_s clr_s ':'], 'markersize', 8);
            end
    %         set(h_line1(line_i), 'markersize', 8)
        end
        set(h, 'linewidth', 2);
        xlabel(x_name);


        onlyShowLegendFor2Let = true;
        
        ylabel('% Correct');

        legend_str_nice_1_let = cellfun(@(s) [s ' (1 let)'], legend_str_nice, 'un', 0);
        legend_str_nice_2_let = cellfun(@(s) [s ' (2 let)'], legend_str_nice, 'un', 0);
        leg_strs = [legend_str_nice_1_let; legend_str_nice_2_let];

        h_forLeg = h;
        if onlyShowLegendFor2Let
            h_forLeg = h_forLeg(2,:);
            leg_strs = legend_str_nice;
        end
            
        
        legend(h_forLeg(:), leg_strs(:), 'fontsize', 10, 'location', 'NE');

        switch x_name
            case 'poolsize', x_ticks = allPoolSizes_use;
            case 'spacing', x_ticks  = allSpacings_pix;
        end
%%
        set(gca, 'xtick', x_ticks);
        guessRate = 1/26 * [1/26]   + 25/26 * [ 1/13 ];

        drawHorizontalLine(guessRate*100, 'linestyle', ':', 'color', 'k');
    %     drawHorizontalLine(1/13, 'linestyle', ':', 'color', 'r');

        ylim([0 101]);
        xlim(lims(x_vals, .05))

    %     end


        3;
        %set(h_line(1), 'color', 'r', 'linestyle', ':', 'marker', 's', 'linewidth', 2, 'markersize', 8)
    %     set(h_line(6), 'color', 'k')


%         title({' Performance vs. Pooling size' , [strrep(crowdedLetters_str, '_', ', ')  ' (Size = ' sizeStyle_full ')'] }, 'fontsize', 14, 'interp', 'none')
%         title({' Performance vs. Pooling size' , }, 'fontsize', 14, 'interp', 'none')
        title({sprintf(' Performance vs. %s', titleCase(x_name)  ) , }, 'fontsize', 14, 'interp', 'none')
        xlabel(x_name_nice)
        
        if 0 
            %%
            set(h(2), 'color', [0 .7 0]);
            set(h(3), 'color', 'r');
            set(h, 'linestyle', '-', 'linewidth', 2)
            legend({'1 Letter', '2 Letters', '3 Letters'}, 'location', 'SW');
        end

    %     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  664.9500  430.0000]);
    %     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  670  430.0000]); % too wide, too short
        if ~strcmp(get(gcf, 'windowStyle'), 'docked')
%             set(gca, 'units', 'pixels', 'position', [116   54  688  384]); 
%             set(gcf, 'units', 'pixels', 'position', [426   343   889   486])
        end

            3;
        %%
        3;

    end
    %%
    doNicePlot = 1;
    
    
    if doNicePlot
        
        col_ord = [...
                 0     0    1
                 1     0    0
                 0     0.5  0
                 0     0.75 0.75
                 0.75  0    0.75
                 0.75  0.75 0
                 0.25  0.25 0.25];
        
        showModelErrorbars = 0;
        allPoolings_show = [0, 4, 12];
        allPoolings_use  = [0, 4, 12];
        allPoolings_show_str = arrayfun(@(s) sprintf('%dx%d', s, s), allPoolings_show, 'un', 0);
        idx_use = binarySearch(allPoolSizes, allPoolings_use);

        figure(49); clf; hold on; box on;

        set(gca, 'colorOrder', col_ord);
        spacings = [0 1]';
        line_w = 2;
       
%        h_pcorr_M = [32, 100];  % actual value
       h_pcorr_M = [40, 100];
       h_pcorr_S = [4, 1];
       
       m_pcorr_1let_pool = all_pCorr1_M(idx_use,1);
       m_pcorr_3let_pool = all_pCorr3_M(idx_use,1);
       
       m_pcorr_pool_M = [all_pCorr3_M(idx_use,1), all_pCorr1_M(idx_use,1)]';
       m_pcorr_pool_S = [all_pCorr3_S(idx_use,1), all_pCorr1_S(idx_use,1)]';
       errorbar(spacings, h_pcorr_M, h_pcorr_S, 'ks-', 'markersize', 10, 'linewidth', 2);
       if showModelErrorbars
           errorbar(repmat(spacings, 1, length(idx_use)), m_pcorr_pool_M, m_pcorr_pool_S, 'o--', 'markersize', 10, 'linewidth', line_w);
       else
           plot(spacings, m_pcorr_pool_M, 'o--', 'markersize', 10, 'linewidth', line_w);
       end
       
       set(gcf, 'position', [1306  399   501  464]);
               
       xlim(lims(spacings, .1));
       ylim([0, 102]);
%         title('A model of crowding', 'fontsize', 18)       
       xlabel('Letter spacing / letter width', 'fontsize', 14)
       ylabel('% correct', 'fontsize', 16);
        legend_str = ['Human performance'; 'ConvNet: No pooling'; legendarray('ConvNet: Pooling size = ', allPoolings_show_str(2:end)); ];
        legend(legend_str, 'location', 'SE');
        ax1 = gca;
        set(ax1, 'xtick', spacings, 'xticklabel', {'', ''});
        p = get(ax1, 'position');
        new_ax = axes('position', [p(1:3) + [0 -.002, 0], .0001], 'xlim', get(ax1, 'xlim'), 'xtick', [], 'fontsize', 11);
%         h_xlab_new = xlabel(new_ax, '    0                                                                            \infty   ');
        
        
%         set(gca, 'xtick', spacings, 'fontname', 'symbol', 'xticklabel', {'1', char(165)});

        3;
        
    end

    3;
    %%


end


function log_slope = getLogSlope(x, y)

%     logy = log10(y);
    p = polyfit(log10(x),log10(y), 1);
    log_slope = p(1);
    

end


        %{
        adjustPCorr2 = 0;
        if adjustPCorr2
            pCorr2_shouldBe = [70, 48, 42];
            all_pCorr2_M_av = mean(all_pCorr2_M,1);
            all_pCorr2_adj = pCorr2_shouldBe - all_pCorr2_M_av;
            all_pCorr2_M = bsxfun(@plus, all_pCorr2_M, all_pCorr2_adj);
            all_pCorr2 = all_pCorr2_M;
        end
        %}