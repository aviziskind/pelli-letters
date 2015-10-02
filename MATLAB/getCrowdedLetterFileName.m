function [fn, f_path] = getCrowdedLetterFileName(fontName, logSNR, crowdedLetterOpts)
%     getCrowdedLetterFileName('Train', fontName, xs, ys);
    fontSizeStyle = crowdedLetterOpts.sizeStyle;
    crowdedLetterOpts.logSNR = logSNR;

    crowdedOpts_str = getCrowdedLetterOptsStr(crowdedLetterOpts);
    
    fn = sprintf('%s-%s_%s.mat', fontName, fontSizeStyle, crowdedOpts_str);
    3;
    
    if nargout > 1
        f_path = [datasetsPath 'Crowding' filesep crowdedLetterOpts.stimType filesep fontName filesep];
    end

end

%{


two paradigms:

paradigm #1
--train with 1 letter at all possible positions [1,2,3,4,5]
--test with 2 letters where distances = {1,2,3,4} 
--hard to define target vs distractor - use multiple possible labels paradigm
--maybe no need to add gaussian noise, but probably good to do anyway

_x_10_10_100__Train_all_snrX
_x_10_10_100__Test_all_snrX

paradigm #2
--train with 1 letter at only at position 1 out of [1,2,3,4,5]
--test on 2 letters where letter 1 is at position1, letter 2 varies in {2,3,4,5} 
--well defined target (use single label testing paradigm), can use threshold (measure tdr)
--probably need to add gaussian noise to learn to suppress inputs at other positions

_x_10_10_100__Train_1_snrX
_x_10_10_100__Test_1_tdrY_snrX == 


%}



