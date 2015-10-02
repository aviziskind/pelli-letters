function inputs_n = normalizeInputsByStd( inputs, dim )
    inputs_mean = mean(inputs, dim);
    inputs_std = std(inputs, 0, dim);
        
    inputs_n = bsxfun(@rdivide, bsxfun(@minus, inputs, inputs_mean), inputs_std);
            
end
