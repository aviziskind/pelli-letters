function [nTot, S, nEachField] = nTextureStatisticsForParams(Nsc, Nor, Na, useAllStats_flag)

%     fieldnms = {'pixelStats' 'pixelLPStats' 'autoCorrReal' 'autoCorrMag' 'magMeans' 'cousinMagCorr' 'parentMagCorr', 'cousinRealCorr' 'parentRealCorr' 'varianceHPR'};
    fieldnms = {'pixelStats', 'pixelLPStats', 'autoCorrReal', 'autoCorrMag', 'magMeans', 'cousinMagCorr', 'parentMagCorr',  'cousinRealCorr' 'parentRealCorr', 'varianceHPR'};

    useAllStats = exist('useAllStats_flag', 'var') && isequal(useAllStats_flag, 1);
    
    Na_sqr = (Na^2+1)/2;
    
    S.pixelStats = 6;                     % orig size = 6
    S.pixelLPStats = 2*(Nsc+1);           % orig size = [Nsc+1, 2]
    S.varianceHPR = 1;                    % orig size = 1
    
    S.autoCorrReal = Na_sqr * (Nsc+1);    % orig size = [Na, Na, Nsc+1]
    S.autoCorrMag  = Na_sqr * Nsc * Nor;  % orig size = [Na, Na, Nsc, Nor]

    if useAllStats
        S.magMeans = (Nsc*Nor)+2;           % orig size = (Nsc*Nor)+2
    else
        S.magMeans = 0;
    end
    
    
    if useAllStats % also include diagonal terms
        Nor_sqr = Nor*(Nor+1)/2;
    else  % just include values above diagonal 
        Nor_sqr = Nor*(Nor-1)/2;
    end

    S.cousinMagCorr = Nor_sqr * Nsc;  % orig size =  [Nor,Nor,Nsc+1]
    
    S.parentMagCorr = Nor * Nor * (Nsc-1);    % orig size =  [Nor,Nor,Nsc]
    
    if useAllStats
        S.cousinRealCorr = (Nor_sqr * Nsc) +  25;  % orig size = [2*Nor,2*Nor,Nsc+1];
    else
        S.cousinRealCorr = 0;
    end

    S.parentRealCorr = (2*Nor^2)*(Nsc-1);     % orig size =   [2*Nor,2*Nor,Nsc];
    if useAllStats
        S.parentRealCorr = S.parentRealCorr + Nor*5;
    end

    nTot = 0;
    for i = 1:length(fieldnms)
        n_i = S.([fieldnms{i}]);
        nEachField.(fieldnms{i}) = n_i;
        nTot = nTot + prod(n_i);
    end
    
            
end

%{
    S.pixelStats_size = [1 6];
    S.pixelLPStats_size = [Nsc+1, 2];
    S.autoCorrReal_size = [Na,Na,Nsc+1];
    S.autoCorrMag_size = [Na,Na,Nsc,Nor];
    S.magMeans_size = [(Nsc*Nor)+2 1];
    S.cousinMagCorr_size = [Nor,Nor,Nsc+1];
    S.parentMagCorr_size = [Nor,Nor,Nsc];
    
    S.cousinRealCorr_size = [2*Nor,2*Nor,Nsc+1];
    S.parentRealCorr_size = [2*Nor,2*Nor,Nsc];
    
    S.varianceHPR_size = [1 1];
%}

%{
%%
N = 4;
K = 4;
M = 7;

ms = 2*(N+1) + 1 + 6;
rcc = (N+1)*(M^2+1)/2;
cm = N*K*(M^2+1)/2 + N*K*(K-1)/2 + K^2*(N-1);
csp = 2*K^2*(N-1);

nTot = ms+rcc+cm+csp; % = 710
%}