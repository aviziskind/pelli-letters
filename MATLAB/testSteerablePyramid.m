function testSteerablePyramid

    n0 = 128;
    mag = @(X) sqrt( real(X).^2  + imag(X).^2 );
    X = discImage(n0, 50);
    FX = fftshift(fft2(X));
    figure(11); 
    subplot(1,2,1); graySqrIm(X);
    subplot(1,2,2); graySqrIm(mag(FX));
    
    
    %%

    x = linspace(-pi, pi, n0);
    y = x;
    K = 4; %Nor
    N = 2; %Nscl
    
    [xs, ys] = meshgrid(x, y);
    [theta, r] = cart2pol(xs, ys);
    theta = mod(theta, 2*pi);
    %%
    prevL_factor = 1;
    
    for n = 1:N
        %%
        
        r_use = r / 2^(n-1);
        L_factor = 1/(2^(n-1));

        L = getL(r_use, theta);
        
        L0 = L/2;
        H0 = sqrt(1 - L0.^2);
        
        if n == 1
            %%
            figure(1); clf;
            subplotGap(2,3, 1,1); 
            subplotGap(2,3, 1,2); imagesc(L0); axis xy equal tight;
            subplotGap(2,3, 1,3); imagesc(H0); axis xy equal tight;

            subplotGap(2,3, 2,2); imagesc(  ifft2(ifftshift( L0 .* FX), 'symmetric') ); axis xy equal tight;
            subplotGap(2,3, 2,3); imagesc(  ifft2(ifftshift( H0 .* FX), 'symmetric') ); axis xy equal tight;
            
            
        end
        3;
        

        for k = 1:K
            B{k} = prevL_factor .* getBk(r_use, theta, k-1, K);
        end

        
        subM = 1;
        subN = K+2;
        figure(n); clf;
        subplotGap(subM,subN,1,1);
        imagesc(x, y, L); axis xy equal tight; colormap gray;
        set(gca, 'xtick', [], 'ytick', []);
        title('L');
        colorbar;
        
%         figure(2); 
        for k = 1:K
            subplotGap(subM,subN,1, k+1);
            imagesc(x, y, abs(B{k})); axis xy equal tight;
            set(gca, 'xtick', [], 'ytick', []);
            colorbar;
            title(sprintf('B: k = %d', k));
        end
       
        subplotGap(subM,subN,K+2);
        Bsqr = cellfun(@(a) a.^2, B, 'un', 0);
        sumB = sum(cat(3, Bsqr{:}), 3);
        imagesc(x, y, sumB + (0.5*L).^2); axis xy equal tight;
        set(gca, 'xtick', [], 'ytick', []);

        colorbar;

        colormap gray;
        prevL_factor = L;
        3;
    end
        
%     figure(3); 
%     imagesc(x, y, B2); axis xy; colormap gray;
%     figure(4);  
%     imagesc(x, y, B3); axis xy; colormap gray;
%     figure(5);  
%     imagesc(x, y, B4); axis xy; colormap gray;
    3;
    

end

function L = getL(r, theta)
    L = zeros(size(r));
    
    i1 = between(r, pi/4, pi/2);
    i2 = r <= pi/4;
    i3 = r >= pi/2;
    L(i1) = 2*cos( (pi/2)*log2(4*r(i1)/pi));
    L(i2) = 2;
    L(i3) = 0;   

end

function [Bk, H, Gk] = getBk(r, theta, k, K)
    
    H = H_r(r);
    Gk = Gk_theta(theta, k, K);
    Bk = H .* Gk;
        
end

function H = H_r(r)
    H = zeros(size(r));

    i1 = between(r, pi/4, pi/2);
    i2 = r >= pi/2;
    i3 = r <= pi/4;
    H(i1) = cos( (pi/2)*log2(2*r(i1)/pi));
    H(i2) = 1;
    H(i3) = 0;   

end

function Gk = Gk_theta(theta, k, K)
    Gk = zeros(size(theta));
%%
    alpha_k = (2^(K-1))*(factorial(K-1)/sqrt(K*factorial(2*(K-1)))) ;
    
%     i1 = abs(theta-pi*k/K) < pi/2;
    i1 = circDist(theta, pi*k/K, pi) < pi/2;
    Gk(i1) = alpha_k * (cos (theta(i1)-pi*k/K)) .^(K-1); 

end

function graySqrIm(X)
    imagesc(X);  axis xy equal tight; set(gca, 'xtick', [], 'ytick', []); colormap('gray')
end

function X = subsample(X, k)
    X = X(1:k:end, 1:k:end);
end


