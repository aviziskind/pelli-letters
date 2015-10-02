function d = distFromPointToLine(pt, ln)

    if numel(pt) == 2
        pt = pt(:)';
    end

    x1 = pt(:,1);
    y1 = pt(:,2);
    
    m = ln(1);
    c = ln(2);
    
    d = (y1 - m*x1 - c) ./ sqrt(m^2 + 1);
    
end
