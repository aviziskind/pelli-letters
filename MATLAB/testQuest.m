% testQuest
%%
% allLogSNRs = [0,1,2,2.5,3,4,5];

% rng(0);
allLogSNRs = -3:.05:5; %linspace(-1,4,nSNRs);
allSNRs = 10.^allLogSNRs;
% allSNRs = 10.^allLogSNRs;
nSNRs = length(allSNRs);


gamma = 1/26;
weibull = @(beta, c) (beta(1) - (beta(1)-gamma).* exp (- (( (c) ./beta(2)).^(beta(3)) ) ) );

th_true = 67;
beta_true = [1, th_true, 1];
func_true = @(x) weibull(beta_true, x);

psi_true = @(x) weibull(beta_true, 10.^(x));
psi0 = @(x) weibull([1 1 1], 10.^(x));






y_true = func_true(allSNRs);

dx = diff(allLogSNRs(1:2));
dydx = diff(y_true(1:end-1),1)/(dx);
idx_use = 2:nSNRs-1;


sf = y_true(idx_use) .* (1-y_true(idx_use)) ./ (dydx.^2);
% sf = (dydx.^2);
sf = rescaleBetween0and1( log10(sf) );


% allSNRs = logspace(-1, 4, 100);
figure(5); clf; hold on;
plot(allLogSNRs, y_true, '.');
plot(allLogSNRs(idx_use), sf, 'r-');
drawVerticalLine( allLogSNRs(idx_use(findLocalMinima(sf))) )
h_err = errorbar(allLogSNRs, nan(1,nSNRs), nan(1,nSNRs), 'ro-');

h_T = line([1, 1]*log10(th_true), [0, 1], 'color', 'b', 'linestyle', ':');



% allSNRs = logspace(-1, 4, 100);
% figure(50); clf; hold on;
% plot(allSNRs, y_true, '.');
% % plot(allSNRs(idx_use), sf, 'r-');
% set(gca, 'xscale', 'log');
% % drawVerticalLine( allSNRs(idx_use(findLocalMinima(sf))) )
% h_err = errorbar(allSNRs, nan(1,nSNRs), nan(1,nSNRs), 'ro-');
% 
% h_T = line([1, 1], [0, 1], 'color', 'k');






th0 = 15;
expQ0 = gaussian(allLogSNRs, log10(th0), log10(50));
expQ0 = expQ0 / max(expQ0);
Q0 = log(expQ0);
% plot(allSNRs, expQ0);

q = quest([], 'init', allLogSNRs, Q0, psi0);


beta0 = [1, th0, 1];
func0 = @(x) weibull(beta0, x);

% idx0 = indmin(abs(allSNRs-th0));

plot(allLogSNRs, 10.^(q.S), 'g');
plot(allLogSNRs, 10.^(q.F), 'r');

figure(6); clf; hold on;
plot(allLogSNRs, Q0, '.-');


nTrials = 200;

[all_snr_try, all_success] = deal( zeros(1, nTrials) );

allNCorr = zeros(1,nSNRs);
allNTrials = zeros(1,nSNRs);
% allPcorr = nan(1,nSNRs);
% allPcorr_std = nan(1, nSNRs);

pCorrBinCents = [50, 60, 70, 80];
pCorrBinEdges = binCent2edge(pCorrBinCents);


offset_max = 2;

Qn = Q0;
for i = 1:nTrials
    % do a trial.
    
    idx_snr_try = quest(q, 'next_trial');
    
    if nTrials < 10
        offset = 0;
    else
        offset = randi(2*offset_max+1)-offset_max-1;
    end
%     snr
    
    idx_snr_try = idx_snr_try + offset;
    snr_try = allSNRs(idx_snr_try);
    log_snr_try = log10(snr_try);
    tf_success = rand < func_true(snr_try);
    
    
    
    all_success(i) = tf_success;
    all_snr_try(i) = snr_try;
    
    allNCorr(idx_snr_try) = allNCorr(idx_snr_try) + tf_success;
    allNTrials(idx_snr_try) = allNTrials(idx_snr_try) + 1;
    
    q = quest(q, 'add_trial', log_snr_try, tf_success);
        
    figure(6);
    plot(allLogSNRs, q.Qn - max(q.Qn), color_s(i))
    ylim([-10, 0]);
    
    
    allPcorr = allNCorr ./ allNTrials;
    allPcorr_std = sqrt( allPcorr .* (1 - allPcorr) ./ allNTrials);
    idx_use = allNTrials > 2 & between(allPcorr, 0, 1);

    allPcorr(~idx_use) = nan;
    
    set(h_err, 'ydata', allPcorr(:), 'udata', allPcorr_std(:), 'ldata', allPcorr_std(:));
    T_like = q.logT_like;
    set(h_T, 'xdata', T_like*[1,1]);
    
end


% figure(7); clf; hold on;
% plot((all_snr_try), 'o-');
% drawHorizontalLine(th_true)


%%
%{
pcorr = [0.0903, 0.3178, 0.8922, 0.9875, 0.9997,  1, 1];

[th, bestFitFunc] = getSNRthreshold(allLogSNRs, pcorr);


%        bestFitFunc = @(x) weibull(b_best_fit, x)*100;
       
       figure(55); clf; hold on;
       plot(allSNRs, pcorr*100, 'bo');
       set(gca, 'xscale', 'log');
       
       pcorrect_fine = bestFitFunc(allSNRs_fine);
       plot(allSNRs_fine,pcorrect_fine, ['b-'], 'linewidth', 1)
%}       
       
       
       
       
       
       
       
       