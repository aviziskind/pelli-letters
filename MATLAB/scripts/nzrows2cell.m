function C = nzrows2cell(M, blankVal)
    if nargin < 2
        blankVal = 0;
    end

    nrows = size(M,1);
    C = cell(nrows, 1);
    for ri = 1:nrows
        row_vals = M(ri,:);
        row_vals = row_vals(row_vals ~= blankVal);
        C{ri} = row_vals;
    end
end