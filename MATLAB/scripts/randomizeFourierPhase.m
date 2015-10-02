function Xrand = randomizeFourierPhase(X)

    Xf = fft2(X);
    
    Xf_mag = abs(Xf);
    Xf_angle = angle(Xf);
    fftshift
    
    
    Xf_angle_rand = rand(size(Xf))*2*pi - pi;
    
    
    Xf_rand = Xf_mag .* exp(1i * Xf_angle_rand);
    
    numDims = ndims(X);
    for k = 1:numDims
        m = size(X, k);
        p = ceil(m/2);
        idx1 = p+1:m;
        idx2 = 1:p;
        idx{k} = [ 1:p];
        [idx_lo, idx_hi] = getFourierIdxs(m);
        
    end


    Xrand = ifft2(Xf_rand, 'symmetric');

    
%     Xf_real = real(Xf);
%     Xf_imag = imag(Xf);


end

