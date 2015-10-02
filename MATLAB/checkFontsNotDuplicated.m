function checkFontsNotDuplicated
%%
    S = loadLetters;
    fn = fieldnames(S);
    fontNames = fn( cellfun(@(s) isempty(strfind(s, '_')), fn) );

    for font_i = 1:length(fontNames)
        %%
        fontName_i = fontNames{font_i}; 
        fprintf('%s\n', fontName_i);
        Sf = S.(fontName_i);
        allSizes = sort(Sf.sizes);
        for sz_i = 1:length(allSizes)-1
            fld_i = sprintf('%s_%02d', fontName_i, allSizes(sz_i));
            Sf_i = S.(fld_i);
            for sz_j = sz_i+1:length(Sf.sizes)
                fld_j = sprintf('%s_%02d', fontName_i, allSizes(sz_j));
                Sf_j = S.(fld_j);
%                 fprintf('%s : comparing %d vs %d\n', fontName_i, sz_i, sz_j);
                
                ok1 = ~isequal(Sf_i.letters, Sf_j.letters);
                ok2 = any( Sf_i.size_av < Sf_j.size_av );
                
                isException = strcmp(  fontName_i, 'CourierUB') && Sf.sizes(sz_i) == 21 &&  Sf.sizes(sz_j) == 22;
                assert(ok1);
                assert(ok2 || isException)
                if ~(ok2 || isException)
%                     fprintf('Failed for 
                    fprintf('Failed for %s : comparing %d vs %d\n', fontName_i, Sf.sizes(sz_i), Sf.sizes(sz_j));
                    %%
                    figure(1); clf;
                    imagesc(tileImages(Sf_i.letters, 6, 5, 3, 0));axis equal tight
                    colormap('gray'); axis image; ticksOff; imageToScale([], 1)
                    
                    figure(2); clf;
                    imagesc(tileImages(Sf_j.letters, 6, 5, 3, 0));axis equal tight
                    colormap('gray'); axis image; ticksOff; imageToScale([], 1)
                    3;
                    
                end
            end
        end
                
            
        
    end


end

% %%
%     base_dir = [lettersPath 'fonts' filesep 'fonts_from_word' filesep];
%     font_dirs = subfolders(base_dir);
%     %%
%     for dir_i = 1:length(font_dirs)
%         %%
%         p = ;
%         files = dir([base_dir font_dirs{dir_i} filesep '*.png']
%         
%         
%     end
% 

% rfontsEqual(
