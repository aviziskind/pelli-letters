function [freqs, Gain] = getChannelFromThresholds(f, th, noiseType, channel_opt)
% the threshold as a function of cutoff frequency is th(f).

    if nargin <= 1
        if nargin < 1
            f = 'Ziskind';
        end
        if isequal(f, 'Pelli')
            observer='LL';
            freqs_tested  = [0.1, 0.5, 1, 2, 4, 8, 16];
            % threshold energy: maximum likelihood monotonic estimates from Solomon & Pelli, Figure 3
            switch observer
                case 'LL',
                    EOverN_lo = [0, 0.0007, .1, 1, 18.5,65, 65]; % observer LL
                    EOverN_hi = [65, 65, 65, 44, 10.5, 0, 0]; % observer LL
                case 'JS',
                    EOverN_lo = [0.5, 0.5, .6, 2, 15, 80, 80]; % observer JS
                    EOverN_hi = [80, 80, 80, 65, 36, 8, 0.5]; % observer JS
            end
            smooth_w = 0;
        elseif isequal(f, 'Ziskind')
            freqs_tested =  [0.5, 0.71, 1, 1.41, 2, 2.83, 4, 5.66, 8, 11.31, 16];
            E_lo = [ 0.0003    0.0017    0.0032    0.0181    0.0752    0.2168    1.4894    6.1094   65.4636  192.3092  171.7908];
            E_hi = [ 189.0648  189.9587  189.2344  187.0682  187.0682  185.3532  126.7652   75.1623   42.9536   19.6336   12.6474];

            E_all = 150;
            maxFreq=32; %% wild guess
            N= 1;% N=1./freqs_tested.^2; % power spectral density = power/bandwidth
            EOverN_lo=E_lo./N
            N=1;%1./(maxFreq^2-freqs_tested.^2); % power spectral density = power/bandwidth
            EOverN_hi=E_hi./N
            EOverN_hi(1:3)=EOverN_hi(4); % impose monotononicity
            smooth_w = 0;
        end
        figure(1); clf;
        plot(freqs_tested, EOverN_lo, 'bs-'); hold on;
        plot(freqs_tested, EOverN_hi, 'rs-');
        plot(freqs_tested, EOverN_lo + EOverN_hi, 'go-');
        xlabel('Frequency'); ylabel('Threshold');
        xlims = [freqs_tested(1)-.1, freqs_tested(end)+1];
        f_tick = round(freqs_tested * 10) / 10;
        set(gca, 'xscale', 'log',  'xlim', xlims, 'xtick', f_tick);
        legend('Low pass', 'High pass');

        [f, G_lo] = getChannelFromThresholds(freqs_tested, EOverN_lo, 'lo', smooth_w);
        [f, G_hi] = getChannelFromThresholds(freqs_tested, EOverN_hi, 'hi', smooth_w);
        figure(2); clf;
        plot(f, G_lo+0.001, 'bo-'); hold on;
        plot(f, G_hi+0.001, 'ro-');
        f_tick2 = round(f * 10) / 10;
        %set(gca, 'xscale', 'log', 'yscale', 'log', 'xlim', [f(1)-.1, f(end)+1], 'xtick', f_tick2);
        set(gca, 'xscale', 'log', 'yscale', 'log', 'xlim', [.1, 100]);
        xlabel('Frequency'); ylabel('Gain');
        legend('Low pass', 'High pass');
        return;
    end

    if nargin < 4
        channel_opt = struct;
    end

    if isfield(channel_opt, 'E_all')
       E_all = channel_opt.E_all;    
    end
    if isfield(channel_opt, 'E0')
       E0    = channel_opt.E0;    
    end
    if isfield(channel_opt, 'minGain')
        minGain = channel_opt.minGain;
    end


    doSmooth = isfield(channel_opt, 'smoothW') && (channel_opt.smoothW > 0);

    if doSmooth
        th = exp( smooth_gauss( log (th), channel_opt.smoothW ) );
    end

    %     E = th.^2;       % Energy = (threshold contrast)^2
    E=th; % the data from Solomon and Pelli are energy thresholds.
    
    sizeE_orig = size(E);
    if ~isvector(E)
        E = permuteReshapeData(E, 1);
    end

    
    if ~exist('E_all', 'var')
        E_all = max(E(:));  % Estimate E_all (Energy of white noise threshold) as max of all E's
    end
    if ~exist('E0', 'var')
        E0 = min(E(:));        % Estimate E_0 (intrinsic internal noise) as min of all E's
    end
    if ~exist('minGain', 'var')
        minGain = 1e-4;
    end


    E_star     = E - E0;  % E* = E - E_0
    E_all_star = E_all - E0;

    
    [nFreqs, nSets] = size(E);
    n = length(f);
    freqs = zeros(1, n-1);
    Gain  = zeros(1, n-1);

    switch noiseType, 
        case {'hi', 'lo'}

            enforceMonotonic = 1;

            if strcmp(noiseType, 'hi')
                sgn = -1;
                if enforceMonotonic
                   for i = 1:n-1
                        if E_star(i) < E_star(i+1)
                            idx_firstLess = find(E_star < E_star(i+1), 1);
                            idxs = idx_firstLess : i+1;
                            E_star( idxs) = 10.^ mean( log10( E_star (idxs)) );
                        end
                   end

                end


            elseif strcmp(noiseType, 'lo')
                sgn = 1;

                for i = 1:n-1
                    if E_star(i) > E_star(i+1)
                        idx_firstGreater = find(E_star > E_star(i+1), 1);
                        idxs = idx_firstGreater : i+1;
                        E_star( idxs) = 10.^ mean( log10( E_star (idxs)) );
                    end
                end

            end

            for i = 1:n-1
                freqs(i) = sqrt( (f(i)^2 + f(i+1)^2)/2 );
                GSquared= (sgn/(pi*E_all_star))  * (E_star(i+1)-E_star(i))/(f(i+1)^2 - f(i)^2);
                Gain(i)=sqrt(GSquared);
            end

        case 'band',

    %         deconv(
    %%
            freqs = f;
            logfreqs = log2(freqs);
            widthBox = 1;

            logE = log(E);

            Gain = dConvWithBox(logfreqs, logE-min(logE), widthBox);


        otherwise,
            error('Unknown noise type: use "hi", "lo", or "band"');


    end






    Gain( Gain < minGain) = minGain;
    % the channel can now be plotted with :
    % >> plot(freqs, Gain)
end




function p = gaussian(x, mu, sigma)
p = 1./(sqrt(2*pi*sigma^2)) .* exp( -((x-mu).^2)./(2*sigma^2));
end


function Y2 = smooth_gauss(Y1, w, dim, circularFlag, leaveOutCenterFlag)
if (w == 0)
    Y2 = Y1;
    return;
end

is_vec = isvector(Y1);
if is_vec
    Y1 = Y1(:);
else
    if ~exist('dim', 'var') || isempty(dim)
        dim = 1;
    end
    sizeY1 = size(Y1);
    Y1 = permuteReshapeData(Y1, dim);
end

N = size(Y1, 1);
n_std_gaussians = 4; % how many std deviations of gaussian to actually implement
n_g = max(ceil(n_std_gaussians*w), 2);

circularSmooth = exist('circularFlag', 'var') && ~isempty(circularFlag);
leaveOutCenter = exist('leaveOutCenterFlag', 'var') && ~isempty(leaveOutCenterFlag) && leaveOutCenterFlag;

g = gaussian(-n_g:n_g, 0, w);
if leaveOutCenter
    g(n_g+1) = 0;
end
g = g/sum(g);


if circularSmooth
    idx_pre  = mod([N-n_g+1:N]-1, N)+1;
    idx_post = mod([1:n_g]-1, N)+1;
    %         Y1 = [Y1(idx_pre); Y1; Y1(idx_post)];
    Y1 = [Y1(idx_pre,:); Y1; Y1(idx_post,:)];
else
    %         Y1 = [bsxfun(@times, ones(n_g, 1), rowsOfX(Y1, 1));
    %               Y1;
    %               bsxfun(@times, ones(n_g, 1), rowsOfX(Y1, N))];
    Y1 = [ones(n_g, 1) * Y1(1,:); Y1; ones(n_g, 1) * Y1(N,:)];
end

N = round(length(g)/2);
N2 = length(g)-N;

Y2 = myConv(Y1, g, 1);
N_y2 = size(Y2,1);

idx = [n_g + N  :  N_y2-N2-n_g];
Y2 = Y2(idx,:);

if ~is_vec
    Y2 = permuteReshapeData(Y2, dim, sizeY1);
end

end



function Y = myConv(X, c, dim, convShape)
persistent cur_C cur_c cur_nx
% - allows efficient convolution of all columns of a n-dimensional
% array X with the vector 'c'
% includes the option of returning only a 2-d subsection of the
% convolution using the argument 'convShape'
sizeX = size(X);
if nargin < 3
    dim = find(sizeX > 1, 1);
end
if nargin < 4
    sameShape = false;
else
    switch convShape
        case 'full', sameShape = false;
        case 'same', sameShape = true;
        otherwise error('Unknown convolution shape');
    end
end

m = length(c);

X = X(:);
%     X = permuteReshapeData(X, dim);

n_x = sizeX(1);

if ~isempty(cur_c) && isequal(cur_c, c) && (cur_nx == n_x)
    C = cur_C;
else
    C = convmtx(c(:),n_x);
    cur_c = c;
    cur_C = C;
    cur_nx = n_x;
end


if sameShape
    idx = ceil(m/2)-1 + [1:n_x];
    %         Y = Y(idx,:);
    C = C(idx,:);
end

Y = C*X;

%     Y = permuteReshapeData(Y, dim, sizeX);

end