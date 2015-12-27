function checkIfEnoughMemory(memRequired_MB, min_ratio)

    if nargin < 2
        min_ratio = 2;
    end

    memAvailable_MB = memoryAvailable_MB;
    ratio = memAvailable_MB / memRequired_MB;
    if ratio < min_ratio
        error('Not enough memory: %.1f MB required but only have %.1f (=%.1f, < %.1f times the memory required)\n', memRequired_MB, memAvailable_MB, ratio, min_ratio);
    else
        fprintf('Enough memory: %.1f MB required, and have %.1f (= %.1f times the memory required)\n', memRequired_MB, memAvailable_MB, ratio);
    end
    
    
end