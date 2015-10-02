function split_C = splitDelimStr(str, nParts, delim)

    if nargin < 2
        nParts = 2;
    end
    if nargin < 3
        delim = ';';
    end

    str_C = strsplit(str, delim);
    if length(str_C) < nParts
        nParts = length(str_C);
    end
    
    L = cellfun(@length, str_C);
    cum_frac = cumsum(L)/sum(L);
    split_C = cell(1, nParts);
    
    idx_prev = 0;
    for i = 1:nParts-1
       idx = indmin(abs(cum_frac - i/nParts));
       
       str_i = strjoin(str_C(idx_prev+1:idx), delim);
       if ~isempty(str_i) && str_i(1) == ' ';
           str_i = str_i(2:end);
       end
       split_C{i} = str_i;
       
       if i == nParts-1
          str_j = strjoin(str_C(idx+1:end), delim); 
           if ~isempty(str_j) && str_j(1) == ' ';
               str_j = str_j(2:end);
           end
          split_C{nParts} = str_j;
       end
       idx_prev = idx;

    end
    

end