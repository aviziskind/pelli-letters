function plotCrowdingVsPoolSize

%%
%     allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Courier', 'Bookman', 'GeorgiaUpper', 'Yung', 'Kuenstler'};
	fontName      = 'Sloan';
% 	allFontNames      = {'Braille'};
    allTDRs = [-2, -1, -0.5, 0];

    expTitle = 'CrowdedLetters';
    netType = 'ConvNet';
    sizeStyle = 'med';
    
    sizeStyle_full = switchh(sizeStyle, {'sml', 'med', 'big', 'dflt'}, {'Small', 'Medium', 'Large', 'Default'});
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
                
        let_opts = {{2, '30pix' }, ...
                    {2, '40pix' }, ...
                    {2, '60pix' }  ...
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
        let_opts = let_opts{1};

    crowdedLetterOpts.Nx = let_opts{1};
    crowdedLetterOpts.spacing = let_opts{2};
    crowdedLetterOpts.expTitle = 'Crowded';
    crowdedLetterOpts.sizeStyle = sizeStyle;

    crowdedLetters_str = getCrowdedLetterOptsStr(crowdedLetterOpts);
    
%     crowdedLetterOpts.tf_pca = tf_pca;

    %%

    allNStates = { {6, 30}, {6, 120} };
%     allNStates = { {6,15}, {6, 120}, {12, 240}, {24, 480} };

    allPoolSizes = [0,2,4,8,12,16,20,24,28 32];
%     allPoolSizes = [0,2,4,8,12,16,20,24,28 32];
    allPoolSizes_C = num2cell(allPoolSizes);

    if iscell(allNStates(1))
        allNStates = cellcell2cellarray(allNStates);
    end


    %%%%
    filtSizes = [5,4];
    allFiltSizes = {2,4,5,10,20};
    
    doPooling = 1;
    
    poolStrides = 2;
    
    poolType = 2;
    allPoolTypes = {1,2,'MAX'};

    allPoolSizes_use = allPoolSizes(allPoolSizes == 0 | allPoolSizes >= poolStrides);
    allPoolSizes_use_C = num2cell(allPoolSizes_use);

    
    nNetworks = length(allNStates);
    nPoolSizes = length(allPoolSizes_use);

    all_pCorr1 = zeros(nPoolSizes, nNetworks);
    all_pCorr2 = zeros(nPoolSizes, nNetworks);
    
    for net_i = 1:nNetworks

            
%             poolStrides = 'auto';

            allNetworks_i = struct('netType', 'ConvNet', ...
                                    'nStates', allNStates{net_i}, ...
                                    'filtSizes', filtSizes,...
                                    ...'tbl_filtSizes', {allFiltSizes}, ...
                                    ...
                                    'doPooling', doPooling, ...
                                    ...,'poolSizes', poolSize, ...
                                    'poolSizes', allPoolSizes_use_C, ...
                                    'poolType', poolType, ...
                                    ...'tbl_poolType', {allPoolTypes}, ...
                                    'poolStrides', poolStrides ... 
                                  );
    
            allNetworks_leg(net_i) = allNetworks_i(2); %#ok<AGROW>

        [pCorr1, pCorr2_v_tdr] = loadCrowdingResults(expTitle, fontName, allTDRs, allNetworks_i, crowdedLetterOpts);
        pCorr2 = pCorr2_v_tdr(:,end);

        all_pCorr1(:,net_i) = pCorr1;
        all_pCorr2(:,net_i) = pCorr2;

    
    end

%%
    figure(7); clf; hold on; box on;
    
%     niceLegendFields = {'filtSizes', 'poolSizes', 'doPooling'};
    niceLegendFields = {'poolStrides'}; %'doPooling', 'poolSizes', 'poolStrides'}; %'filtSizes', 'doPooling'};
    [~, legend_str_nice] = arrayfun(@(n) getNetworkStr(n, niceLegendFields), allNetworks_leg, 'un', 0);        

    
%     cols = ['bgrk'];
    lineSt = {'-', '--'};
    mkrs = ['os*v'];
    colors_use = 'brgcm';
    markers_use = 'oxs*dph';
    c_ord = get(gca, 'colorOrder');
    c_ord = c_ord([1,3,2,4:end], :);
    set(gca, 'colorOrder', c_ord);
%     for net_i = 1:nNetworks
%         line_s = lineSt{ floor(net_i/6)+1};
        line_s = '-'; %linestyle( floor(net_i/6) );
        mkr_s = marker(net_i, markers_use);   % marker( floor(net_i/6)+2);
%         mkr_s = marker( net_i+1 );
        clr_s = color_s(net_i, colors_use);
        h(1,:) = plot(allPoolSizes_use, all_pCorr1, [mkr_s '-']);
        h(2,:) = plot(allPoolSizes_use, all_pCorr2, [mkr_s '--']);
%         set(h_line1(net_i), 'markersize', 8)
        

    xlabel('Pooling Size')
    ylabel('% Correct');
    
    legend_str_nice_1_let = cellfun(@(s) [s ' (1 let)'], legend_str_nice, 'un', 0);
    legend_str_nice_2_let = cellfun(@(s) [s ' (2 let)'], legend_str_nice, 'un', 0);
    leg_strs = [legend_str_nice_1_let; legend_str_nice_2_let];
    
    legend(h(:), leg_strs(:), 'fontsize', 10, 'location', 'SW');

    set(gca, 'xtick', allPoolSizes_use);
    guessRate = 1/26 * [1/26]   + 25/26 * [ 1/13 ];

    drawHorizontalLine(guessRate*100, 'linestyle', ':', 'color', 'k');
%     drawHorizontalLine(1/13, 'linestyle', ':', 'color', 'r');
    
    ylim([0 101]);
    xlim([-.05, max(allPoolSizes_use)])

%     end
    
    
    3;
    %set(h_line(1), 'color', 'r', 'linestyle', ':', 'marker', 's', 'linewidth', 2, 'markersize', 8)
%     set(h_line(6), 'color', 'k')
    
    
    title({' Performance vs. Pooling size' , [strrep(crowdedLetters_str, '_', ', ')  ' (Size = ' sizeStyle_full ')'] }, 'fontsize', 14, 'interp', 'none')
    
%     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  664.9500  430.0000]);
%     set(gca, 'units', 'pixels', 'position', [112.5400   73.0000  670  430.0000]); % too wide, too short
    if ~strcmp(get(gcf, 'windowStyle'), 'docked')
        set(gca, 'units', 'pixels', 'position', [116   54  688  384]); 
        set(gcf, 'units', 'pixels', 'position', [426   343   889   486])
    end
    
        3;
    %%
    3;

    
    %%


end


function log_slope = getLogSlope(x, y)

%     logy = log10(y);
    p = polyfit(log10(x),log10(y), 1);
    log_slope = p(1);
    

end
