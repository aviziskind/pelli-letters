function [allStrings_diff, string_common] = extractCommonStrings(allStrings, delims, strExclude)

    if nargin < 3
        strExclude = {};
    end
    strings_common_C = {};
    nStrings = length(allStrings);
    allStrings_sep = cell(1, nStrings);
    delims_C = num2cell(delims);
    for i = 1:length(delims_C)
        delims_C{i} = [delims_C{i} ' '];
    end
    % break up into sub-strings
    for i = 1:nStrings
        allStrings_sep{i} = strsplit( allStrings{i}, delims_C);
        for j = 1:length(allStrings_sep{i})
            while length(allStrings_sep{i}{j}) > 1 && any(allStrings_sep{i}{j}([1, end]) == ' ')
                if allStrings_sep{i}{j}(1) == ' '
                    allStrings_sep{i}{j} = allStrings_sep{i}{j}(2:end);
                end
                if allStrings_sep{i}{j}(end) == ' '
                    allStrings_sep{i}{j} = allStrings_sep{i}{j}(1:end-1);
                end
                
            end
            
        end
    end
    %%
    % find common sub-strings

    for j = 1:length(allStrings_sep{1})
        string_element = allStrings_sep{1}{j};
        
        if ~isempty(strExclude)
            n = min(cellfun(@length, strExclude));
            if any(strncmp(string_element, strExclude, n))
                continue;
            end
        end
        
        isInAllStrings = true;
        for k = 2:nStrings
            if ~any(strcmp(string_element, allStrings_sep{k}))
                isInAllStrings = false;
            end
        end
        
        if isInAllStrings
           strings_common_C{end+1} = string_element; %#ok<AGROW>
        end
        
    end
    
    string_common = strjoin(strings_common_C, '; ');
    %%
    allStrings_sep_diff = allStrings_sep;
    allStrings_diff = cell(1, nStrings);
    for i = 1:nStrings
    
        for j = 1:length(strings_common_C)
            idx_rm = find(strcmp(strings_common_C{j}, allStrings_sep_diff{i}));
            assert(length(idx_rm) == 1);
            allStrings_sep_diff{i}(idx_rm) = [];
        end
    
        allStrings_diff{i} = strjoin(allStrings_sep_diff{i}, '; ');
    end
    
    


end
