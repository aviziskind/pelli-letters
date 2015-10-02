function c = getFourierComplexity(X)

    if iscell(X)
        %%
        for i = length(X):-1:1
        
           Xi = X{i};
           Fi = fftshift(fft2(Xi));
           F_mag = sqrt(real(Fi).^2 + imag(Fi).^2);   
        
           sumX = sum(Xi(:));
           Areas(i) = sumX;
           sqrperim_exp(i) = sumX * 16;
           perim_exp(i) = sqrt(sqrperim_exp(i));
           
            [m,n] = size(Xi);

            idx_mid_m = floor(m/2) + 1;
            idx_mid_n = floor(n/2) + 1;

            perim_calc(i) = 1;
            
            
%             Fc = Fi(idx_mid_m:end, idx_mid_n:end);
%             rampc = ramp(idx_mid_m:end, idx_mid_n:end);
%             
%             dFc = Fc .* rampc;
            
            %%
%             imagesc(ifft(ifftshift(  ramp .*  fftshift(fft(Xi))  )) )
            
%             imagesc(ifft( ifftshift(  fftshift(fft(Xi)))  , 'symmetric' ) )
%%
            ramp = bsxfun(@plus, [1:m]', [1:n]) - idx_mid_m - idx_mid_n;
            c = 1;
            
            Fi = fftshift(fft2(Xi));
            dF = c * abs(ramp) .* Fi;
%             fprintf('mid = %.1f\n', dF(idx_mid_m, idx_mid_n));
            
            dX = ifft2( ifftshift( dF ), 'symmetric' );
            
%             dX = ifft2( ifftshift( abs(ramp) .* fftshift(fft2(Xi)))  , 'symmetric' );
            figure(44); imagesc( abs(dX) )
            axis xy; colorbar; 
            caxis(max(abs(lims(dX(:))))*[-1, 1]);
            s = mean( abs(dX(:)) ) * size(Xi,1);
%             exp(i) = sum(abs(dX(:)));
            
            title(sprintf('sum = %.1f [%d]', s, perim_exp(i)));
            
            perim_calc(i) = s;
    %%
            
            
        end
        
        figure(45);
        plot(1:length(X), perim_calc ./ perim_exp, 'o-') ;
        %%
        figure(46); clf;
        plot(1:length(X), (perim_calc/16).^2 ./ Areas)
        
        3;
        
    end
    
    
    
    
    F = fftshift(fft2(X));
    F_mag = sqrt(real(F).^2 + imag(F).^2);
    
    sumX = sum(X(:));
    
    
    
    idx_mid_m = floor(m/2) + 1;
    idx_mid_n = floor(n/2) + 1;
    
    assert(F_mag(idx_mid_m, idx_mid_n) == sumX);
    
    
    A = sumX;
    
    %%
    ramp = bsxfun(@plus, [1:m]', 1:n) - idx_mid_m - idx_mid_n;
    %%
    c = 1;
    F_mag(idx_mid_m, idx_mid_n) = 0;
    F0 = F;
    
    F0(idx_mid_m, idx_mid_n) = 0;
    
    %
    r0 = [F0(idx_mid_m,:), F0(:,idx_mid_m)'];
    Psqr = sum(abs(real(r0(:))));
    
    
    
%     Psqr = sum(F_mag(:));
    
    c = Psqr / A;


end