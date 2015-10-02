function s = datasetsPath
    
%     persistent lettersPath_str
%     if isempty(lettersPath_str)
%         lettersPath_str = [codePath 'MATLAB' filesep  'nyu' filesep 'letters' filesep];
%     end
%     lettersPath_str = [codePath 'MATLAB' filesep  'nyu' filesep 'letters' filesep];
%     s = lettersPath_str;

    s = [lettersDataPath 'datasets' fsep 'MATLAB' fsep];     
     
     
end