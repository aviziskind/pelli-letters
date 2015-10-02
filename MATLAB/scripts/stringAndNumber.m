function [str, num] = stringAndNumber(strWithNum)
    
    maxForNum = 3;
    L = length(strWithNum);
    
    
    for n = maxForNum : -1 : 1
        stringSub = strWithNum(L-n+1 : L);
        numLastN = str2double(stringSub);
        if ~isnan(numLastN)
            str = strWithNum(1: L-n);
            num = numLastN;
            return
        end
    end
    
    %  no numbers at end - just return full string 
    str = strWithNum;
    num = [];
            
end
