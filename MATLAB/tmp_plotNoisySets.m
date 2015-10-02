%%
noisySets = [allNoisySets{:}];
    
pctCorr_img = [noisySets.propLetterCorrect_ideal_image];
pctCorr_txt_best = [noisySets.propLetterCorrect_ideal_texture];

figure(41); clf; hold on; box on;
plot(all_SNRs, pctCorr_img, 'bo-')
plot(all_SNRs, pctCorr_txt_best, 'k*-')
        
%%        
% pCorr = getMinSqrErrorPctCorrect(templates_wgt, inputMtx_wgt, labels);
n1 = noisySets(1);

nStats = numel(noisySet.signal(1).textureStats);

nSets = length(noisySets);
%%
for set_i = 1:nSets
    %%
    Si = noisySets(set_i);

    allTextureStats = reshape(Si.textureStats, [nStats, length(Si.textureStats(1,:))]);
    allTextureStats_raw_C{set_i} = allTextureStats;
    
    meanNoisy = mean(allTextureStats,2);
    stdNoisy  =  std(allTextureStats, [], 2);
    stdNoisy_reg = max(stdNoisy, eps(class(allTextureStats)) );
    
    meanNoisy_C{set_i} = meanNoisy;
    stdNoisy_C{set_i} = stdNoisy;
    
    allTextureStats = bsxfun(@rdivide, bsxfun(@minus, allTextureStats, meanNoisy), stdNoisy_reg);                
    
    classTemplates = classMeans(allTextureStats, Si.labels);
    
    
    setClassTemplates_C{set_i} = classTemplates;
    
    pCorr_cheat(set_i) = getMinSqrErrorPctCorrect(classTemplates', allTextureStats', Si.labels);
    
    allTextureStats_normIndiv_C{set_i} = allTextureStats;
    
     show = 0;
    if show
%                     subplot(2,1,1); plot(signalTemplates)
%                     subplot(2,1,2); plot(allTextureStats)
        figure(set_i);
        colrs = jet(length(uCls));
        clf; hold on; box on;
        for i = 1:length(uCls)
%             plot(allTextureStats(:,cls_idx{i}), 'color', colrs(i,:));
            plot(classTemplates(:,i), 'color', colrs(i,:));
        end
    end
end
%%

% globMean = mean([meanNoisy_C{:}],2);
globMean_raw = mean([allTextureStats_raw_C{:}],2);
globStd_raw = max( std([allTextureStats_raw_C{:}],[], 2), eps('single'));

%%

for set_i = 1:nSets
    allTextureStats_normGlob_C{set_i} = bsxfun(@rdivide, bsxfun(@minus, allTextureStats_raw_C{set_i}, globMean_raw), globStd_raw);      
end
%%
labels_glob = [noisySets.labels];

allTextureStats_normGlob = [allTextureStats_normGlob_C{:}];
classTemplates_normGlob = classMeans(allTextureStats_normGlob, labels_glob);

%%

allTextureStats_normIndiv = [allTextureStats_normIndiv_C{:}];
globMean_normIndiv = mean([allTextureStats_normIndiv_C{:}],2);
% globStd_norm = max( std([allTextureStats_C{:}],[], 2), eps('single'));

classTemplates_normIndiv = classMeans(allTextureStats_normIndiv, labels_glob);

for set_i = 1:nSets
    
    pCorr_globNorm(set_i) = getMinSqrErrorPctCorrect(classTemplates_normGlob', allTextureStats_normGlob_C{set_i}', noisySets(set_i).labels);

    pCorr_indivNorm(set_i) = getMinSqrErrorPctCorrect(classTemplates_normIndiv', allTextureStats_normIndiv_C{set_i}', noisySets(set_i).labels);

end
%%
figure(41); clf; hold on; box on;
plot(all_SNRs, pctCorr_img, 'bo-')
plot(all_SNRs, pCorr_cheat/100, 'k*-')
plot(all_SNRs, pCorr_globNorm/100, 'ro-')
plot(all_SNRs, pCorr_indivNorm/100, 'go-')
%%


figure(55); clf;
allMeanNoisy = [meanNoisy_C{:}];
allStdNoisy = [stdNoisy_C{:}];
plot(allMeanNoisy);

%{ 
1. (Cheating): normalize each one individually, train/test individually
2. Normalize individually, using each own mean/std, (then test on global mean/std)
3. Normalize globally (using global mean/std), test on global mean/std
%}
        %%
                %%
               
              
               
                
        
        