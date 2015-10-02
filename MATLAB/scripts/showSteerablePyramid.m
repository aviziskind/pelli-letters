function showSteerablePyramid
    %%
    L = 128; r = L/2*(3/4);
    x = 1:L; y = 1:L; [xg, yg] = meshgrid(x,y);
    cx = L/2; cy = L/2;
    X = (xg - cx).^2 + (yg - cy).^2 < r.^2;
    X = double(X);
    smooth_w = 0;
    X = gaussSmooth( gaussSmooth(X, smooth_w, 1), smooth_w, 2);
    
    
    figure(65); clf;
    imagesc(X);
    %%
%     S = load('sampleImage.mat');
%     X = S.X;
    
    showFilters = 0;
    if showFilters
        Sf = load('SteerableFilters.mat');        
        displayPyramidCross(Sf.allFilts_band_sm);
    end
    
    
    
%     X = pgmRead('nuts.pgm');
%%
    nOri = 4;
    nScl = 3;
    [pyr,pind,steermtx,harmonics] = buildSCFpyr(X, nScl, nOri-1, 1);
    %%
    nBands = size(pind,1);
    allBands = cell(1,nBands);
    for bnd_i = 1:nBands
        indices = pyrBandIndices(pind,bnd_i);
        allBands{bnd_i} = reshape(pyr(indices), pind(bnd_i,:));        
    end
    
    %%
    allBands_ori = reshape( allBands(2:end-1), [nOri, nScl]);
%     bandSzs = cellfun(@length, allBands_ori(1,:));
    %%
    
    showInGrid = 0;
    if showInGrid
        subN = 4;
    %     ceil(nBands/subM);
        subM = ceil(nBands/subN);

        clf;
        for bnd_i = 2:nBands-1
            subplot(subM, subN, bnd_i-1);
            imagesc(allBands{bnd_i}); axis equal tight;
            ticksOff;
        end
        imageToScale([], 2);
        colormap('gray');
    end
    %%
    
    spc = 20;
    scl = 2;
    margin = 20;
    cent_margin = 60;
    %%
    figure(67); clf;
    displayPyramidCross(allBands_ori, 1);
    %%
%     , scl, spc, margin, cent_margin);
    
%%
        save_folder = [lettersPath fsep 'Figures' fsep 'Slides' fsep];
                fname1 = sprintf('Psych_%s_%.2f.emf', fontName, allLogSNRs_fine(snr_i));
%             hgsave(fig_a, [save_folder fname]);
            print(fig_a, [save_folder fname1], '-dmeta', '-r300');
    
    
    
end



%{

%         allFilts_band = Sf.allFilts_band;
        bnds = Sf.allFilts_band(:,3);
        
        Sf.allFilts_band_sm = allFilts_band;

    allFilts_band(:,1) = bnds;
        %%
        
        for ori_i = 1:4
            Xf = bnds{ori_i};
            n = size(Xf,1);
            
            for lev = 2:3
                %%
%                 lev = 4;
                itpM = 2^(lev-1);
                
                N = n*itpM;
                band_itp1 = [];
                band_itp = [];

                shiftAmt = itpM/2-1;
                
%                 x5 = 1:length(Xf5);
%                 x5_L = [x5(1)-.5, x5(end)+1];
%                 [x5_itp, band_itp5] = fourierInterp(x5, Xf5, itpM,x5_L );
%                 band_itp5 = circshift(band_itp5, itpM/2-1);
%                 figure(55); clf; hold on;
% %                 plot(x5, Xf5, 'rs')
%                 plot(band_itp5, '.-');
%                 drawVerticalLine(length(band_itp5)/2);
                

                for i = 1:n
                    [xi, band_itp1(i,:)] = fourierInterp([], Xf(i,:), itpM, 'circ');
                end
                for i = 1:N
                    [xi, band_itp(:,i)] = fourierInterp([], band_itp1(:,i), itpM, 'circ');
                end
                
                band_itp = circshift(band_itp, shiftAmt*[1,1]);
                allFilts_band{ori_i, lev} = band_itp;
                
            end
            
        end

%}