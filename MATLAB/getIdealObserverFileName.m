function [file_name, folder] = getIdealObserverFileName(fontName, snr, letterOpts)
        
    if iscell(fontName) || isstruct(fontName)
        fontName = abbrevFontStyleNames(fontName);
    end
    
    file_name = getDataFileName(fontName, snr, letterOpts);
    file_name = strrep(file_name, '.mat', '_ideal.mat');
    
    sub_folder_name = letterOpts.stimType;
    folder = [lettersDataPath 'IdealObserver' filesep sub_folder_name filesep fontName filesep];
    
end

