function [freq_cycPerPix, filterGain_v_freq] = filterGain(Z, N, normalizeFilt_flag)

    [m,n] = size(Z);

    
    if nargin < 2
        N = size(Z);
    end
    normalizeFilt = exist('normalizeFilt_flag', 'var') && ~isempty(normalizeFilt_flag);
    
    Zexp = zeros(N);
    Zexp(1:m, 1:n) = Z;

    rps_ext = radialPowerSpectrum(Zexp);
    if normalizeFilt
        rps_ext = rps_ext /max(rps_ext);
    end
    % rps = rps/max(rps);

%     freq_cycPer2Pix = linspace(0, 1, N/2);

    freq_cycPerPix = linspace(0, 1, N(1)/2) / 2;

    filterGain_v_freq = rps_ext(1:N(1)/2);

end


