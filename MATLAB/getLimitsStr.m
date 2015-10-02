function str = getLimitsStr(x)
    if length(x) > 1
        dxs = round(diff(x));
        assert( all(dxs(1) == dxs));
        str = sprintf('[%d]', round(dxs(1)) );
    else
        str = '';
    end

end

