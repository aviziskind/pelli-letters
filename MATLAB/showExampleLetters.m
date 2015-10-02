function showExampleLetters

    allFontNames      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'Kuenstler'};


    snrs = [0:4];
    snrs = 4;
    sizeStyle = 'med';
    
    nFonts = length(allFontNames);
    
    noisyLetterOpts = struct('sizeStyle', sizeStyle, 'oris', 0, 'xs', 0, 'ys', 0, 'tf_pca', 0);

    showSingleLetters = 0;
    
    if showSingleLetters

        for fi = 1:nFonts
            fontName = allFontNames{fi};
            fn = getNoisyLetterFileName(fontName, snrs, noisyLetterOpts);

            S = load( [datasetsPath 'NoisyLetters' filesep fontName filesep fn]);

            3;
    %         imagesc(
            %%
            fig_id = 200+fi;
            figure(fig_id); clf;
            let_id = iff(strcmp(fontName, 'Braille'), 4, 1);
            imagesc(S.signalMatrix(:,:,let_id));
            colormap('gray');
            axis square; set(gca, 'xtick', [], 'ytick', []);
            imageToScale;
            p = get(gca, 'position');
            set(gca, 'position', [5, 5, p(3:4)]);
            set(fig_id, 'windowStyle', 'normal');
            print(fig_id, [lettersPath 'Figures' filesep 'example_' fontName '.eps'], '-deps');
            3;

        end

    end

    showGridOfDifferentSizes = 1;
    if showGridOfDifferentSizes
        %%
        h = 10;
        w = nFonts;
        allSizes = {'sml', 'med', 'big', 'dflt'};
        allSizes_nice = {'Small', 'Medium', 'Big', 'Original'};
        nTot = h*w;
        allRandom = false;
        if allRandom
            let_idx = randi(26, 1, nTot);
            font_idx = randi(nFonts, 1, nTot);
        else
            let_i = 1:h;% randi(26, 1, nTot);
            font_i = 1:w;%randi(nFonts, 1, nTot);
            [font_idx, let_idx] = meshgrid(font_i, let_i);
            
        end
        %%
        for sz = 1:length(allSizes)
           %%
            noisyLetterOpts.sizeStyle = allSizes{sz};
            signal = cell(1,nFonts);
            for fi = 1:nFonts
                fontName = allFontNames{fi};
                fn = getNoisyLetterFileName(fontName, snrs, noisyLetterOpts);

                S = load( [lettersPath 'NoisyLetters' filesep fontName filesep fn]);
                signal{fi} = S.signalMatrix;
            end
            imSize = S.imageSize;
            imageStack = zeros([imSize, nTot]);
            
            if allRandom
                for i = 1:nTot
                    imageStack(:,:,i) = signal{font_idx(i)}(:,:,let_idx(i));
                end
            else
                for i = 1:nTot
                    imageStack(:,:,i) = signal{font_idx(i)}(:,:,let_idx(i));
                end
                
            end
%%  
            fig_id = 300+sz;
            figure(fig_id); clf;
            im_tiled = tileImages(imageStack, w, h);
            imagesc(im_tiled);
            
            ytks = [1:nFonts]*(imSize(1)+1) - imSize(1)*(2/5);
            colormap('gray');
            set(gca, 'xtick', [], 'ytick', ytks, 'ytickLabel', allFontNames);
            axis equal tight; 
            
            imageToScale;
            title(allSizes_nice{sz});
%             set(gca, 'ytick', 
%             p = get(gca, 'position');
%             set(gca, 'position', [5, 5, p(3:4)]);
%             set(fig_id, 'windowStyle', 'normal');
            
            3;
            print(fig_id, [lettersPath 'Figures' filesep 'examples_' allSizes{sz} '.eps'], '-deps');
        
        end
        
    end
3;


end