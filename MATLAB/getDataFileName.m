function [file_name, folder] = getDataFileName(fontName, snr, letterOpts)
        
    switch letterOpts.expName
        case {'Complexity', 'ChannelTuning', 'Grouping', 'Uncertainty'},
            file_name = getNoisyLetterFileName(fontName, snr, letterOpts);
            
%         case 'NoisyLettersTextureStats',  
%             file_name = getNoisyLettersTextureStatsFileName(fontName, snr, letterOpts);
% %             fldr_name = 'NoisyLettersStats';
% 
%         case 'NoisyLettersOverFeat',  

        case 'Crowding',     
            letterOpts.trainTargetPosition = letterOpts.testTargetPosition;
            file_name = getCrowdedLetterFileName(fontName, snr, letterOpts);
    end

    sub_folder_name = letterOpts.stimType;
    folder = [datasetsPath sub_folder_name filesep fontName filesep];
end