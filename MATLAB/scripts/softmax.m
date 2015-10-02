function smax = softmax(v)
    
%     v = v/max(v);
    expV = exp(v);
    smax = expV / sum(expV);

end