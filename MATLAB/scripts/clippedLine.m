function y = clippedLine(beta, x, opt)
    if nargin < 3
        opt = struct;
    end

    logXaxes = isfield(opt, 'xLog') && isequal(opt.xLog, 1);
    logYaxes = isfield(opt, 'yLog') && isequal(opt.yLog, 1);
    
    x1 = beta(1);
    x2 = beta(2);
    
    y1 = beta(3);
    y2 = beta(4);
    
    idx1 = x < x1;
    idx_ramp = ibetween(x, x1, x2);
    idx2 = x > x2;
    y = zeros(size(x));
    
    y(idx1) = y1;
    y(idx2) = y2;
    
    if logYaxes
        y1 = log10(y1); 
        y2 = log10(y2); 
    end
    
    x_use = x;
    if logXaxes
        x1 = log10(x1);
        x2 = log10(x2);
        
        x_use = log10( x );
    end 
    
    
    m = (y1-y2)/(x1-x2);
    c = (y1 - m*x1); 
        
    if logYaxes
        y(idx_ramp) = 10.^( m*x_use(idx_ramp) + c );    
    else
        y(idx_ramp) = m*x_use(idx_ramp) + c;
    end
    
end