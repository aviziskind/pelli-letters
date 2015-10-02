function s = num2decstr(x)
    if abs(x - round(x)) > 1e-5
        x = round(x*10);
    end
    s = num2str(x);

end