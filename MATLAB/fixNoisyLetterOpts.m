function opt = fixNoisyLetterOpts(opt)
    
    if isfield(opt, 'OriXY') && isstruct(opt.OriXY);
%         flds = fieldnames(opt.OriXY);
%         for i = 1:length(flds)
%             opt.(flds{i}) = opt.OriXY.(flds{i});
%         end
    end     
    
    
        OriXY = opt.OriXY;
        assert(isstruct(OriXY))
%         if isfield(OriXY, 'oris')
%             [allLetterOpts(i).oris, allLetterOpts(i).xs, allLetterOpts(i).ys]  = deal( OriXY.oris, OriXY.xs, OriXY.ys );
%         end
        if isfield(OriXY, 'fonts')
            opt.fullFontSet = OriXY.fonts;
        end
        if isfield(OriXY, 'styles')
            opt.fullStyleSet  = OriXY.styles;
        end         

    
    
    
%     -- make sure fontName is in a table, even if just a single font.
    if ischar(opt.fontName)
        opt.fontName = {opt.fontName};
    end
    if ischar(opt.trainingFonts) 
        opt.trainingFonts = {opt.trainingFonts};
    end
    
%     -- remove 'retrainFromLayer' if trainNoise is same as testNoise, && trainFonts = testFonts
    differentTrainTestNoise = isfield(opt, 'trainingNoise') && ~strcmp(opt.trainingNoise, 'same') && ~strcmp(filterStr(opt.noiseFilter, 1), filterStr(opt.trainingNoise, 1));
    differentTrainTestFonts = isfield(opt, 'trainingFonts') && ~strcmp(opt.trainingFonts, 'same') && ~strcmp(abbrevFontStyleNames(opt.trainingFonts), abbrevFontStyleNames(opt.fontName) );
            
    if ~differentTrainTestNoise && ~differentTrainTestFonts 
        opt.retrainFromLayer = [];
    end
    
    
%     -- if training on SVHN, make sure trainingImageSize matches size of SVHN training set
    if isfield(opt, 'trainingFonts') && ~strcmp(opt.trainingFonts, 'same') && ~isempty(strfind( abbrevFontStyleNames(opt.trainingFonts), 'SVHN')) && ...
        isfield(opt.trainingFonts, 'svhn_opts') && isfield(opt.trainingFonts.svhn_opts, 'imageSize') 
            opt.trainingImageSize = opt.trainingFonts.svhn_opts.imageSize;
    end
    
   
end