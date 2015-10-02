%%
allFontNames_std      = {'Braille', 'Sloan', 'HelveticaU', 'BookmanU', 'Yung', 'CourierU', 'KuenstlerU'};    
% allFontNames_std      = {'Braille', 'Sloan', 'Helvetica', 'Bookman', 'Yung', 'Courier', 'KuenstlerU'};    
nFonts = length(allFontNames_std);
N = length(allFontNames_std);
all_rps = [];
font_means = [];
fontHeight = 18;
fontKheight = sprintf('k%d', fontHeight);
imSize = 52;
[imSize_best] = getBestImageSize(0, 0, 0, allFontNames_std, fontKheight, 5, 1);
%%
for i = 1:length(allFontNames_std);
%    subplot(3,3,i);
   %%
   [allLet, fd] = loadLetters(allFontNames_std{i}, fontKheight);
   fontCmp(i) = fd.complexity_2;
   sample_idx = iff(strcmp(allFontNames_std{i}, 'Braille'), 4, 1);
   
%    allLet = allLet/
   mrgn = [imSize-size(allLet,1), imSize-size(allLet,2)];
   allLet_ext = addMargin(allLet, mrgn, 0);
   allIm{i} = allLet_ext(:,:,sample_idx);
   
%    for j = 1:size(allLet,3);    
%        all_rps(j,:) = radialPowerSpectrum(allLet_ext(:,:,j));
%    end
   for j = 1:size(allLet,3);    
       [freq_cycPerPix, rps_j] = filterGain(allLet_ext(:,:,j));
       all_rps(j,:) = rps_j;
   end
   font_means(i,:) = mean(all_rps,1);
   
%    [freq_cycPerPix, fg] = filterGain(
   
end

%%

figure(63); clf; hold on; box on;
freq_cycPerLet = freq_cycPerPix * (fontHeight);
   h_lines = plot(freq_cycPerLet, font_means', '-', 'linewidth', 2);
%    plot(all_rps')
   set(gca, 'yscale', 'log', 'xscale', 'log');

allFontNames_std_withCmp = cellfun(@(nm, cmp) sprintf('%s (%d)', nm, round(cmp)), allFontNames_std, num2cell(fontCmp), 'un', 0);
   
legend(allFontNames_std_withCmp)
xlabel('Cycles Per Letter');
xlim([.3, 10]);
ylabel('Radial Power Spectral Density')
%%
title(sprintf('Power Spectrum for different fonts (k-height = %d)', fontHeight));
%%
h_ax = gca;
% S_ex = load('exampleLetters.mat');
%             allIm = S_ex.allIm;
%             tic;
%             allIm = cell(1,nFonts);
%             for fi = 1:nFonts
%                 allLetters = loadLetters(allFontNames{fi}, 'big');
%                 if strcmp(allFontNames{fi}, 'Braille')
%                     let_idx = 4;
%                 else
%                     let_idx = 1;
%                 end
%                 allIm{fi} = allLetters(:,:,let_idx);
%             end
%             %%
%             maxH = max(cellfun(@(x) size(x,1), allIm));
%             maxW = max(cellfun(@(x) size(x,2), allIm));
%             for i = 1:length(allIm)
%                 allIm{i} = symmetricPad(allIm{i}, [maxH, maxW]);
%             end
            
                %%
                [example_imH, example_imW] = size(allIm{1});

%             ax_pos = getModifiedLogAxPosition(h_ax);
%             set(gca, 'units', 'pixels');
%             ax_pos = get(h_ax, 'position');
            set(gca, 'units', 'normalized');
            ax_pos = get(h_ax, 'position');
            
            fig_pos = get(gcf, 'position');
            fig_ar = fig_pos(4)/fig_pos(3);
            
            ax_log_xlim = log10(get(h_ax, 'xlim'));
%             ax_log_ylim = log10(get(h_ax, 'ylim'));
                                    
%             log_cmp = log10(font_complexities_model);
            
            %%
            
            log_lims = log10(lims(nonzeros(freq_cycPerLet), -.1, [], 1));
            font_cyc_spaced = logspace(log_lims(1), log_lims(2), nFonts+3);            
            log_cmp_spaced = log10(font_cyc_spaced);
            
            %%
            for fi = 1:nFonts
                %%
                pos_i_cent = (log_cmp_spaced(fi)-ax_log_xlim(1))/diff(ax_log_xlim);
                pos_i_cent_all(fi) =pos_i_cent;
                w = .06;
                h = w * example_imH/example_imW / fig_ar;
                pos_i_cent_fig = ax_pos(1) + ax_pos(3)*pos_i_cent;
%                 pos_i = [(pos_i_cent_fig - w/2), ax_pos(2)+ax_pos(4)-h*1.5, w, h];
                pos_i = [(pos_i_cent_fig - w/2)-.05, ax_pos(2)+ h*1.5, w, h];
                
                h_ax_let(fi) = axes('position', pos_i);
                image_fi = 1-allIm{fi};
                smooth_w = 0.5;
%                 image_fi = gaussSmooth( gaussSmooth(image_fi, smooth_w, 1), smooth_w, 2);
                
                h_im_let(fi) = imagesc(image_fi);
                ticksOff(h_ax_let(fi))
                colormap(h_ax_let(fi), 'gray');
%                 set(h_ax_let(fi), 'visible', 'off')
                
                col_i = get(h_lines(fi), 'color');
                set(h_ax_let(fi), 'visible', 'on', 'xcolor', col_i, 'yColor', col_i)
                
            end
% xlim([.3, 10])

%%


