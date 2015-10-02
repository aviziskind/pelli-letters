function [x_itp] = fourierInterpImage(x, interpCmd, itpN)
    % This function interpolates the image X using the fourier transform.
    % itpM : the degree of interpolation (itpM == 2 --> ~twice as many points as original)
            
    if ~exist('interpCmd', 'var') || isempty(interpCmd)
        interpCmd = 'mult';
    end
    if ~exist('itpN', 'var') || isempty(itpN)
        itpN = 2;
    end            
    
    [nrows,ncols] = size(x);

    switch interpCmd
        case 'mult',       
            nrows_new = nrows*itpN;
            ncols_new = ncols*itpN;
            
            
            
        case 'newsize',
            nrows_new = itpN(1); 
            ncols_new = itpN(2);
            
    end
    
    nrows_add = nrows_new - nrows;
    ncols_add = ncols_new - ncols;
    
%     assert(m > 1 && n > 1);
    
    X = fft2(x);
    % Y(1) is DC

    mid_m = round(nrows/2);
    mid_n = round(ncols/2);
    X_itp = X*(itpN^2);
    % interpolate rows
    if odd(nrows) || (itpN == 1)
        X_itp = [X_itp(1:mid_m,:); zeros(nrows_add, ncols); X_itp(mid_m+1:end,:)];
    else
        X_itp = [X_itp(1:mid_m,:); X_itp(mid_m+1,:)/2; zeros(nrows_add-1, ncols); X_itp(mid_m+1,:)/2; X_itp(mid_m+2:end,:)];
    end
    
    
    % interpolate columns
    if odd(ncols) || (itpN == 1)
        X_itp = [X_itp(:,1:mid_n), zeros(nrows_new, ncols_add), X_itp(:, mid_n+1:end)];
    else
        X_itp = [X_itp(:,1:mid_n), X_itp(:, mid_n+1)/2, zeros(nrows_new, ncols_add-1), X_itp(:, mid_n+1)/2, X_itp(:, mid_n+2:end)];
    end
        
    x_itp = ifft2(X_itp, 'symmetric');



end
    
   %{ 
    
    
    
    
    % 1. determine dt.
    if (length(t) == 1)  % allow for t = dt
        dt = t;        
        t = (0:length(f)-1)*dt;
    elseif (length(t) ~= length(f))
        error('t must either be of length 1 or length f');
    end       

    % 2. determine T.
    if nargin < 3
        T = t(end) + diff(t(1:2)); % even if t was initially scalar, it is a vector now.
    end

    % rescale time period from 0:T to 0:2pi
    w = (2*pi)/T;
    t = t(:)*w;
    f = f(:);
    dt = t(2) - t(1);
    dts = [diff(t); dt];
    nCyc = (t(end)+dt-t(1))/(2*pi);

    % F1 component
    

    

    
% 
    fft_1 = fourierTransform(1, dts, t, f, T);
%     fft1 = fourierTransform(1, dts, t, f, T);
%     assert(abs(fft_1) == abs(fft1));

    fft_2 = fourierTransform(1, dts, t, f, T);
    fft2 = fourierTransform(1, dts, t, f, T);
    assert(abs(fft_2) == abs(fft2));
    
    
    F1 = 2*sqrt(2)* abs(fft_1);
    DC = fourierTransform(0, dts, t, f, T);

    if (F1 < 1e-10*DC)
        phi = NaN;
    else
        phi = angle(fft_1);
        phi = mod(phi, 2*pi);
    end        
    
    % convert negative phases (-pi:0) to positive (pi:2*pi);
           
    
    
    
end

% function F = fourierTransform(k, dts, t, f, T)  
%     y = 1/sqrt(T) * sum( dts .* f .* exp(-1i * 2*pi* k * t/T) );
% end
% function f = invFourierTransform(w, dts, t, F, T)  
%     y = 1/sqrt(T) * sum( dts .* F .* exp(1i * 2*pi* k * t/T) );
% end

% function F = fourierTransform(f, j)  
%     Ny = length(f);
%     k = [0:Ny-1];
%     if isempty(j)
%         j 
%     F = 1/sqrt(Ny) * sum( exp(-2*pi*1i*j*k/Ny) .* f );
%     
% end
% function f = invFourierTransform(F, j)  
%     Ny = length(F);
%     k = [0:Ny-1];
%     f = 1/sqrt(Ny) * sum( exp(2*pi*1i*j*k/Ny) .* F );
% end



% 
% 
%     f = f(:);
%     if (length(t) == length(f))
%         dt = t(2) - t(1);
%         t = t(:);
%     elseif (length(t) == 1)
%         dt = t;
%         t = [(0:length(f)-1)*dt]';
%     end    
%     if nargin < 3
%         L = T;%t(end);
%     else
%         L = t(end)-t(1);
%     end
%     % rescale T to 0:2pi
% %     t = t(:)*(2*pi)/T;
% 
%     dts = [diff(t); dt];
%     
%     
%     % DC component
%     DC = abs( sum(f .* dts) ) / L;
% 
%     % F1 component
%     fourierTransform = @(w)   (1/sqrt(2))* sum( dts .* exp(1i * w * t) .* f) /L;
%     f1 = fourierTransform(1);
%     f_1 = fourierTransform(-1);
%     c = 2;
%     F1 = c * sqrt( (abs(f1))^2 + (abs(f_1))^2 );

%         for j = 1:Nmax
%             y_itp = y_itp + 2* exp(1i * j * T_itp) * Y(j+1,:); 
%         end        


%}