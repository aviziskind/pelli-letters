function generateSnakesFonts

%     dWiggle = 10;
    dWiggle = 5;
    wiggleAngles.orientation = [dWiggle:dWiggle:90];
%     wiggleAngles.orientation = [60];
    wiggleAngles.offset = [dWiggle:dWiggle:60];
    wiggleAngles.phase = [1];
    wiggleAngles.none = 0;
    
%     allWiggleTypes = {'none', 'offset'};
%     allWiggleTypes = {'none', 'offset', 'orientation', 'phase'};
    allWiggleTypes = {'none', 'orientation', 'none', 'offset', 'none', 'phase'};
%     allWiggleTypes = {'none'};
%     allWiggleTypes = {'orientation'};
    
%     height_deg = 4;
%     allKHeights = [40, 50, 60];
    
%     saveFontsToFile = false;
    saveFontsToFile = true;

%     opts.pixPerDegree = 7; % k32
    opts.pixPerDegree = 9;
    opts.f_cycPerDeg = 1;
    opts.lambda_deg = 0.3; % space constant of gaussian envelope    
    opts.markSpacing_deg = 0.91;
    opts.numGaborsPerLetterHeight = 4.17;
    opts.extraMultForOffsetBorder = 1.25;

%     opts.useModifiedLetters = 0; Same Letters used in 2009 paper
    opts.useModifiedLetters = 2; % modified letters to make letters look nicer, and remove overlapping gabors...
    
    fontOpts.orientations = [0:5:45];    
    fontOpts.margin_pixels = 0;
    fontOpts.margin_pixels_rotated = 0;
    fontOpts.trimLettersMargin = 0;
    fontOpts.trimLettersAmplitude = opts.useModifiedLetters > 0;
    
    
    % N - [4.12, 4.18]
    % C - [4.15, 4.18]
    % R - [4.14, 4.18]
    % Z - [4.17, 4.18]
    % R - [    
    
    %%
%     S_ori = DrawAlphabet_az('orientation', -22.5, opts);
%     S_offset = DrawAlphabet_az('offset', .4 * .6, opts);
%     S_phase = DrawAlphabet_az('phase', 3, opts);
    

%     fontSize

    allFontData = {};
    fig_id = 201;
    allPixPerDegree = [5.5]; % kheight = 27;
%     allPixPerDegree = [5.5]; % kheight = 27;
%     allPixPerDegree = [6]; % kheight = 30;
% 
%     allPixPerDegree = [5.5, 6.5]; % kheight = 32;
    allPixPerDegree = [9.6];  %kheight = 48;
%     allPixPerDegree = [11];  %kheight = 55;
%     allPixPerDegree = [12.9]; % kheight = 64
%     allPixPerDegree = [25.9]; % kheight = 128
%     allPixPerDegree = [51.8]; % kheight = 256

%     allPixPerDegree = [10];
%     allPixPerDegree = [6.5, 9.6, 12.9, 25.9];
%     allPixPerDegree = [6.5, 9.6, 12.9];
    
    if 0 && 0
       %%
        x = [6.5,  11];
        y = [32,   55];
        plot( x,y, 'o-')
        p = polyfit(x, y, 1);

        y_new = 48;
        x_new = fzero(@(x) polyval(p, x)-y_new, 10); 
    end


    
    
                
    
    for size_i = 1:length(allPixPerDegree)
        opts.pixPerDegree = allPixPerDegree(size_i);
        ppd = opts.pixPerDegree;
        
    %                 opts.f_cycPerDeg = 1;
    %                 opts.pixPerDegree = 40;
    %                 opts.lambda_deg = .3;
    %                 opts.markSpacing_deg = .91;
%     opts.numGaborsPerLetterHeight = 4.2;
        if ibetween(ppd, 5.0, 5.49)
            opts.numGaborsPerLetterHeight = 4.25;
        elseif ibetween(ppd, 5.5, 5.99)
            opts.numGaborsPerLetterHeight = 4.2;
        elseif ibetween(ppd, 6.0, 6.49)
            opts.numGaborsPerLetterHeight = 4.19;
        elseif ppd >= 6.5;
            opts.numGaborsPerLetterHeight = 4.17;
        end
    %                 opts.extraMultForOffsetBorder = 1;
    
    
        
        
        S_noWiggle = DrawAlphabet_az('none', [], opts);
        [~, fontData_noWiggle] = processSnakeLetters(S_noWiggle, fontOpts);
        
        
        for i = 1:length(allWiggleTypes)
            wiggleType = allWiggleTypes{i};
            allAngles = wiggleAngles.(wiggleType);

            for angle_i = 1:length(allAngles)
                wiggleAngle = allAngles(angle_i);
                wiggle_str = getSnakeWiggleStr( struct(wiggleType, wiggleAngle) );

                wiggleAmount = getWiggleAmount(wiggleType, wiggleAngle, opts);

                %%

                
                S = DrawAlphabet_az(wiggleType, wiggleAmount, opts);
    %             fprintf('%d - %dx%d\n', opts.pixPerDegree, size(S.signals,1), size(S.signals,2) )
            
                [allLetters, fontData] = processSnakeLetters(S, fontOpts);

                
                
                fontData.k_height = fontData_noWiggle.k_height;
                fontData.x_height = fontData_noWiggle.x_height;
                fontData.fontsize = fontData_noWiggle.fontsize;
                
                rawFontName = 'Snakes';
                if (opts.useModifiedLetters == 0)
                    rawFontName = 'Snakesp';  % = Snakes from "p"aper.
                end
                
                fontName = [rawFontName wiggle_str];

                fontData.rawFontName = rawFontName;
                fontData.fontName = fontName;
                
                show = 1;
                if show
                    %%
                    figure(fig_id);

                    allLetters_show = allLetters;
    %                 allLetters_show = allLetters_orig;
    %                 allLetters_show(abs(allLetters_show) > 0.69 & allLetters_show > 0) = 5;
    %                 allLetters_show(abs(allLetters_show) > 0.69 & allLetters_show < 0) = -5;


                    clf; imagesc(tileImages((allLetters_show), 2, 5)); axis image; ticksOff;  imageToScale([], 2);  
                    colormap(gray(250));
                    ticksOff;   
                    imageToScale([], 5);
                    drawnow;
                    
                    
                    simpleTitle = false;
                    if simpleTitle
                        if strcmp(wiggleType, 'none')
                            title('No wiggle');
                        elseif strcmp(wiggleType, 'phase')
        %                     title(sprintf('Phase wiggle = %d\\circ', wiggleAngle ));
                            title(sprintf('Phase wiggle '));
                        else
                            title(sprintf('%s wiggle = %d\\circ', titleCase(wiggleType), wiggleAngle ));
                        end
                        
                    else
                        title(sprintf('%s : %d x %d (sz = %s. k = %d)', fontName, size(allLetters(:,:,1)), num2str(opts.pixPerDegree), fontData_noWiggle.k_height ), 'interpreter', 'none');
                    end
    %                 caxis([-5, 5]);

    %                 colorbar;


                end

                fig_id = fig_id + 1;
                3;
                drawnow; pause(.2);
                allFontData{end+1} = fontData;
                if saveFontsToFile
                    loadLetters(fontName, fontData.fontsize, [], fontData); 
                end
            end

        end
    end

    if saveFontsToFile
        addSummaryOfFontSizesToFontFile;
        loadLetters('save');
    end
end


function [allLetters, fontData] = processSnakeLetters(S, fontOpts)

    [lettersSorted, idx_sorted] = sort(S.letters);
    allLetters_orig = S.signals(:,:,idx_sorted);

    allLetters = allLetters_orig;

    th = 0.01;
    allLetters(abs(allLetters) < th) = 0;

    if fontOpts.trimLettersMargin
        margin_pixels= 0;

%         [idxT1, idxB1, idxL1, idxR1] = findLetterBounds(allLetters, margin_pixels);

        allLetters = bottomAlignLetters(allLetters);
        allLetters = leftAlignLetters(allLetters);

        [idxT, idxB, idxL, idxR] = findLetterBounds(abs(allLetters), margin_pixels);
        allLetters = allLetters(idxT:idxB, idxL:idxR, :);
    end
    %             L = lims(allLetters);
    %             assert(diff(abs(L)) < 1e-3);
    %             L = max(abs(L));
    
    gaborMaxAmplitude = S.gaborMax;
    if ~fontOpts.trimLettersAmplitude
        gaborMaxAmplitude = max(gaborMaxAmplitude, max(abs(allLetters(:))) );
    end
    
%     L = 0.6240;
    maxInt8Value = 127;
    scale_margin_pct = 0;

    scale_factor = maxInt8Value / (gaborMaxAmplitude * (1 + (scale_margin_pct/100) ));
    allLetters = ( allLetters * scale_factor);


    allLetters(allLetters > maxInt8Value) = maxInt8Value;
    allLetters(allLetters < -maxInt8Value) = -maxInt8Value;


    %%
    [nH, nW] = size(allLetters(:,:,1));
    [idxT_each, idxB_each, idxL_each, idxR_each] = findLetterBounds(abs(allLetters), fontOpts.margin_pixels, 1);
    allHeights = idxB_each-idxT_each+1;
    allWidths = idxR_each-idxL_each+1;
    nH_av = mean(allHeights);
    nW_av = mean(allWidths);

    x_height_factor = 2/3;


    k_height = allHeights ( find(lettersSorted == 'K', 1) );
    x_height = k_height*x_height_factor;

    fontSize = k_height;

    oris_rotated = fontOpts.orientations;
    [nH_rot, nW_rot] = getBoundOfRotatedLetters(abs(allLetters), oris_rotated, fontOpts.margin_pixels_rotated);


    %             snakeLetters = struct('name', 'Snakes',
    %                                   'bol
    %
    fontData = struct('fontName', [], 'rawFontName', [], 'fontsize', fontSize, ...
        'bold', 0, 'italic', 0, 'uppercase', 0, 'letters_char', lettersSorted, 'letters', int8(allLetters), ...
        'size', [nH, nW], 'size_av', [nH_av, nW_av], 'orientations', oris_rotated, 'size_rotated', [nH_rot, nW_rot], ...
        'k_height', k_height, 'x_height', x_height, 'datenum', now);
    %

end


    % 51.6: [274], 255
    % 51.7: [274], 256
    % 51.8: [275], 256
    % 51.9: [275]  256
    % 52.0: [276]  258]
    
    
    