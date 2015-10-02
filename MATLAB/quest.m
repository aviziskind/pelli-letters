%initialize
% q = quest([], 'init', allLogSNRs, Q0, psi);
% 
% idxLogSNR_next = quest(q, 'next_trial');
% 
% q = quest(q, 'add', log_snr_i, tf_success_i);
% 
% q = quest(q, 'T_like');

function varargout = quest(q, cmd, varargin)


%     cmd = varar
    switch cmd
        case 'init',
            [q.allLogSNRs, q.Q0, q.psi] = deal(varargin{:});
            q.allSNRs = 10.^q.allLogSNRs;
            q.nSNRs = length(q.allLogSNRs);
            q.idx_th0 = indmin(abs(q.allLogSNRs));

       
            q.S = log10( q.psi( (-q.allLogSNRs) ) );
            q.F = log10( 1- q.psi( (-q.allLogSNRs) ) );
            q.Qn = q.Q0;
            
            varargout = {q};
            
        case 'next_trial',
            varargout = {indmax(q.Qn)};
            

        case 'estimate',
            
            L = q.Qn - q.Q0; 
            if indmax(L) == 1 || indmax(L) == length(L)
                L = q.Qn;
            end
%             i_max = indmax(L);
            %%
%             tic;
            x_snr = q.allLogSNRs;
            dsnr = diff(x_snr(1:2));
            x_snr_itp = x_snr(1) : 0.005 * dsnr : x_snr(end);
            L_itp = interp1(x_snr, L, x_snr_itp, 'spline');
            [Lmax, ind_max_itp] = max(L_itp);
            snr_Lmax = x_snr_itp(ind_max_itp);
%             toc;
            %% estimate confidence interval:
%             conf_val = 0.975;
            conf_val = 0.95;
            dist = fzero(@(x) (chi2cdf(x,1)-conf_val), 10)/2;
            % left side
            idx_left = 1:ind_max_itp;
            idx_ci(1) = indmin( abs(L_itp(idx_left) - Lmax + dist) );
            
            idx_right = ind_max_itp:length(x_snr_itp);
            idx_ci(2)= indmin( abs(L_itp(idx_right) - Lmax + dist) ) + idx_right(1)-1;
            
            %%
            
            
            snr_ci = x_snr_itp(idx_ci);
%             ci = x_snr_itp
            show = 0;
            if show
                %%
                figure(58); clf; hold on;
                plot(x_snr, L, 'bo'); 
                plot(x_snr_itp, L_itp, 'r.');
                
                plot(snr_Lmax, Lmax, 'k*');
                
%                 plot(x_snr_itp, yy, 'r.-'); hold on;
%                 yy = L_itp - Lmax;
                plot(x_snr_itp(idx_ci), L_itp(idx_ci), 'ks-');
                

            end            
            varargout = {10.^snr_Lmax, 10.^snr_ci};
            % right side:
            %%
            
            
        case 'add_trial',
            [log_snr_i, tf_success_i] = deal(varargin{:});
            
            idx_logSNR_trial = indmin(abs(q.allLogSNRs - log_snr_i));
            assert( abs(q.allLogSNRs(idx_logSNR_trial) - log_snr_i) < 1e-10 )
            
%             log_snr_try = q.allLogSNRs(idx_snr_try);
              
    
%             allNCorr(idx_snr_try) = allNCorr(idx_snr_try) + tf_success;
%             allNTrials(idx_snr_try) = allNTrials(idx_snr_try) + 1;
    
            nshift = (idx_logSNR_trial - q.idx_th0);
            if tf_success_i
                S_shifted = shiftOver(q.S, nshift);
                q.Qn = q.Qn + S_shifted;
            else
                F_shifted = shiftOver(q.F, nshift);
                q.Qn = q.Qn + F_shifted;
            end   

            q.logT_post = q.allLogSNRs(indmax(q.Qn - q.Q0));
            q.logT_like = q.allLogSNRs(indmax(q.Qn));
            q.T_post = 10.^(q.logT_post);
            q.T_like = 10.^(q.logT_like);
            
            varargout = {q};
            
        otherwise
            error('Unknown command : %s', cmd);
    end
            
            
end


       
       