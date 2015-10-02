%%
allFontNames_human = fieldnames(getStatsFromPaper);
allFontNames_human = setdiff(allFontNames_human, 'words5_many');
allFontNames_human = setdiff(allFontNames_human, {'Arabic', 'Armenian', 'Devanagari', 'Checkers4x4'});
% allFontNames_human = setdiff(allFontNames_human, {'Checkers4x4', 'words3', 'words5', 'words5_many'});


nFonts_human = length(allFontNames_human);
[human_efficiencies, human_efficiencies_stderr, font_complexities_human] = deal( zeros(1, nFonts_human) );


for fi = 1:nFonts_human
    human_efficiencies(fi) = getStatsFromPaper(allFontNames_human{fi}, 'efficiency');
    font_complexities_human(fi) = getStatsFromPaper(allFontNames_human{fi}, 'complexity');
end

    
figure(57); clf; hold on; box on;
h_ax_main = gca;

% log_complexity_lims = lims(log10(font_complexities_human));
complexity_lims = [10, 1000];
log_complexity_lims = log10(complexity_lims);
p = polyfit(log10(font_complexities_human), log10(human_efficiencies), 1);
log_eff_lims_fit = 9.1./complexity_lims; %10.^polyval(p, log_complexity_lims);


h_fit = plot(10.^log_complexity_lims, log_eff_lims_fit, 'k-');
% h_points = plot(font_complexities_human, human_efficiencies, 'go');


xlims = [10, 1000];
ylims = [.01, 1];

set(h_ax_main, 'xscale', 'log', 'yScale', 'log', 'xlim', xlims, 'ylim', ylims);


setLogAxesDecimal;

% yticks = [.001, .01, .1, 1];
% ytickLabels = {'0.001', '0.01', '0.1', '1'};
% 
% xticks = [0.1, 1, 10, 100];
% xtickLabels = {'0.1', '1', '10', '100'};
% set(gca, 'ytick', yticks, 'ytickLabel', ytickLabels, 'xtick', xticks, 'xtickLabel', xtickLabels, 'ylim', ylims);


line_w = 6;
fig_position = get(gcf, 'position');
fig_ar = fig_position(3)/fig_position(4);
fontsize = 18;
% line_w = 2;
set(h_fit, 'linewidth', line_w, 'markersize', 8)
xlabel('Complexity', 'fontsize', fontsize);
% ylabel('Gain', 'fontsize', fontsize);
ylabel('Efficiency', 'fontsize', fontsize);
% set(hnd(1), 'color', 'k')

h_text = 1;
%%
if ishandle(h_text(1))
    delete(nonzeros(h_text));
end
h_text = zeros(size(allFontNames_human));

for fi = 1:length(allFontNames_human)    
    
    fontName = allFontNames_human{fi};
    
    xi = font_complexities_human(fi);
    yi = human_efficiencies(fi);
    

    if any(strcmp(fontName, {'Braille', 'Checkers4x4'}))
        %%
%         fontName = Checkers4x4;
        allLetters = loadLetters(fontName, 'big');
        if strcmp(fontName, 'Braille')
            let_idx = 4;
        else
            let_idx = 1;
        end
        nudge_amount = [.02, .02];
        letIm  = allLetters(:,:,let_idx);
        allIm{fi} = letIm;
        
        [x_fig,y_fig] = ds2nfu(h_ax_main, xi, yi);
        w = .03;
        h = w * size(letIm,1)/size(letIm,2) * fig_ar;

        pos = [x_fig - w/2 + nudge_amount(1), y_fig - h/2 + nudge_amount(2), w, h];
        h_axes_let(fi) = axes('position', pos);
        h_im_let(fi) = imagesc(1-letIm);


        clrmap = gray(100);
        clrmap = clrmap(50:end, :);

        colormap(h_axes_let(fi), clrmap)
        set(h_axes_let(fi), 'xtick', [], 'ytick', [], 'visible', 'off');
            3;
        
    else
%         continue;
        fontSize = 18;
        upper_tf = fontName(end) == 'U'; if upper_tf, fontName = fontName(1:end-1); end
        bold_tf = fontName(end) == 'B';  if bold_tf, fontName = fontName(1:end-1); end

        fontName_sys = fontName;
        switch fontName
            case 'Kuenstler', fontName_sys = 'Kunstler Script';
            case 'Courier', fontName_sys = 'Courier New';
        end

        col = .6*[1,1,1];
         if strcmp(fontName, 'words3')
             txt = 'was';
             fontName_sys = 'Bookman';
         elseif strcmp(fontName, 'words5')
             txt = 'which';
             fontName_sys = 'Bookman';
         elseif any(strcmp(fontName, {'Braille', 'Checkers4x4'}))
    %          txt = '';
              txt = fontName(1:2);
             col = 'r';
         elseif any(strcmp(fontName, {'Bookman', 'Courier', 'Kuenstler', 'Hebraica', 'Yung', 'Sloan', 'Helvetica'}))
             txt = 'a';
         else
             txt = fontName(1:2);
             col = 'r';
         end
         
         if strcmp(fontName, 'Sloan')
             fontSize = fontSize * 2/3;
         end
    %          let_idx = 4; % for braille

         if upper_tf || any(strcmp(fontName, {'Sloan', 'Kuenstler'}))
             txt = upper(txt);
         end

        h_text(fi) = text(xi, yi, txt, ...
            'horiz', 'cent', 'vert', 'mid', 'fontname', fontName_sys, 'fontSize', fontSize, ...
            'fontweight', iff(bold_tf, 'bold', 'normal'), 'color', col, 'parent', h_ax_main);
    end   
    
end
% h_points = plot(h_ax_main, font_complexities_human, human_efficiencies, 'ro');

%%
% set(nonzeros(h_text), 'fontsize', 19, 'color', .7*[1,1,1] );
%%
set(gcf, 'position', [1197         338         536         412]);
set(h_ax_main, 'units', 'pixels', 'position', [101    55   348   327]);

3;
%%



%%
%{

    'Bookman'
    'BookmanU'
    'BookmanB'
    'Courier'
    'Helvetica'
    'KuenstlerU'
    'Sloan'
    'Arabic'
    'Armenian'
    'Yung'
    'Devanagari'
    'Hebraica'
    'Braille'
    'Checkers4x4'
    'words3'
    'words5'
    'words5_many'
allIm = cell(1,nFonts);

for i = 1:length(allFontNames_human)    
    
    for fi = 1:nFonts
        allLetters = loadLetters(allFontNames{fi}, 'big');
        if strcmp(allFontNames{fi}, 'Braille')
            let_idx = 4;
        else
            let_idx = 1;
        end
        allIm{fi} = allLetters(:,:,let_idx);
    end   
    
end

% S_ex = load('exampleLetters.mat');
% allIm = S_ex.allIm;

imH = cellfun(@(x) size(x,1), allIm);
imW = cellfun(@(x) size(x,2), allIm);

for i = 1:length(allFontNames_human)
    
    xi = font_complexities_human(i);
    yi = human_efficiencies(i);
    
    ds2nfu(

    
end

    


    ax_pos = getModifiedAxPosition(h_ax);
            
            
            
            ax_pos = get(gca, 'position');
            
            
            
            fig_pos = get(gcf, 'position');
            fig_ar = fig_pos(4)/fig_pos(3);
            
            ax_log_xlim = log10(get(h_ax, 'xlim'));
%             ax_log_ylim = log10(get(h_ax, 'ylim'));
                                    
            log_cmp = log10(font_complexities_model);
            
            %%
            
            log_lims = lims(log10(font_complexities_model), .25, [], 1);
            font_complexities_spaced = logspace(log_lims(1), log_lims(2), nFonts);            
            log_cmp_spaced = log10(font_complexities_spaced);
            
            %%
            for fi = 1:nFonts
                pos_i_cent = (log_cmp_spaced(fi)-ax_log_xlim(1))/diff(ax_log_xlim);
                w = .07;
                h = w * example_imH/example_imW / fig_ar;
                pos_i_cent_fig = ax_pos(1) + ax_pos(3)*pos_i_cent;
%                 pos_i = [(pos_i_cent_fig - w/2), ax_pos(2)+ax_pos(4)-h*1.5, w, h];
                pos_i = [(pos_i_cent_fig - w/2), ax_pos(2)+ h*.6, w, h];
                
                h_ax_let(fi) = axes('position', pos_i);
                image_fi = 1-allIm{fi};
                smooth_w = 0.5;
%                 image_fi = gaussSmooth( gaussSmooth(image_fi, smooth_w, 1), smooth_w, 2);
                
                h_im_let(fi) = imagesc(image_fi);
                ticksOff(h_ax_let(fi))
                colormap(h_ax_let(fi), 'gray');
                set(h_ax_let(fi), 'visible', 'off')
                
            end

%}