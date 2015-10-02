function testGPU


    X = rand(10000, 'single');
    G = gpuArray(X);
    
    tic;
    X2 = X.*X;
    t1 = toc;
    
    tic;
    G2 = G.* G;
    t2 = toc;
    
    t1/t2




end