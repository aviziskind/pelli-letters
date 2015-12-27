function [fn, f_path] = getFileName(fontName, logSNR, letterOpts)
    
%     switch letterOpts.stimType
%         case {'NoisyLetters', 'NoisyLettersTextureStats', 'NoisyLettersOverFeat'},
            
    switch letterOpts.expName
        case {'Complexity', 'ChannelTuning', 'Grouping', 'TestConvNet', 'Uncertainty', 'Crowding'} %,
            [fn, f_path] = getNoisyLetterFileName(fontName, logSNR, letterOpts);            
%         case 'Crowding',    
%             [fn, f_path] = getCrowdedLetterFileName(fontName, logSNR, letterOpts); 
        otherwise
            error('Unknown experiment name');
    end
    
    
end

