function [fn, f_path] = getFileName(fontName, logSNR, letterOpts)
    
%     switch letterOpts.stimType
%         case {'NoisyLetters', 'NoisyLettersTextureStats', 'NoisyLettersOverFeat'},
            
    switch letterOpts.expName
        case 'Crowding',    
            [fn, f_path] = getCrowdedLetterFileName(fontName, logSNR, letterOpts); 
        case {'Complexity', 'ChannelTuning', 'Grouping', 'TestConvNet'} %,
            [fn, f_path] = getNoisyLetterFileName(fontName, logSNR, letterOpts);            
        otherwise
            error('Unknown experiment name');
    end
    
    
end

