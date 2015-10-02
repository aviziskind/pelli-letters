function [cm, cs, cn] = classMeans(values, labels)
    nSamples = length(labels);
    dim_av = find(size(values) == nSamples);

%  allTextureStats = bsxfun(@rdivide, bsxfun(@minus, allTextureStats, meanNoisy), stdNoisy_reg);                
    [~, cls_idx, cls_n] = uniqueList(labels);
    if dim_av == 1
        classMeans_C = cellfun(@(idx) mean(values(idx,:), dim_av), cls_idx, 'un', 0);
        if nargout > 1
            classStds_C = cellfun(@(idx) std(values(idx,:), [], dim_av), cls_idx, 'un', 0);
        end
    elseif dim_av == 2
        classMeans_C = cellfun(@(idx) mean(values(:,idx), dim_av), cls_idx, 'un', 0);
        if nargout > 1
            classStds_C = cellfun(@(idx) std(values(:,idx), [], dim_av), cls_idx, 'un', 0);
        end
    end
        
    cm = cat(dim_av, classMeans_C{:});
    if nargout >= 2
        cs = cat(dim_av, classStds_C{:});
    end
    if nargout >= 3
        cn = cls_n;
    end

end