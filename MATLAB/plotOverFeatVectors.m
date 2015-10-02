%%

% whichFeat = 'texture';
whichFeat = 'overfeat';
% 
dsetPath = '/media/Storage/Users/Avi/Code/MATLAB/nyu/letters/datasets/';
switch whichFeat
    case 'texture',  pth = [dsetPath 'NoisyLettersTextureStats/Bookman/'];
    case 'overfeat', pth = [dsetPath 'NoisyLettersOverFeat/Bookman/'];
end

snrs = [5];
nSNRs = length(snrs);
[S, X, X_cmean, X_cstd, X_cls_n, idx_feat_use_C] = deal( cell(1, nSNRs) );

let_idxs = [6, 25];

for set_i = 1:nSNRs

    
    switch whichFeat
        case 'texture',
            S{set_i} = load(sprintf('%sBookman_k40-1oxy-[64x64]_N3_K4_M5-%d0SNR.mat', pth, snrs(set_i)));
        case 'overfeat',
%             size_str = 'k68';
            size_str = '128-64';
            layerId = 16;
            c = 127;
            offset = 0  ;
            OF_str = getOverFeatStr(struct('layerId', layerId, 'OF_contrast', c, 'OF_offset', offset));
            
            S{set_i} = load(sprintf('%sBookman_%s-1oxy-[231x231]%s-%d0SNR.mat', pth, size_str, OF_str, snrs(set_i)));
    end
    
    [uLabels, labels_idx] = uniqueList( S{set_i}.labels );
    X{set_i} = squeeze(S{set_i}.inputMatrix);
    idx_feat_use_C{set_i} = find( any(X{set_i}(:, [labels_idx{let_idxs}], 2) );
end
%%



if length(idx_feat_use_C) > 1
    idx_feat_use = intersectAll(idx_feat_use_C{:});
else
    idx_feat_use = idx_feat_use_C{1};
end

for set_i = 1:nSNRs
    X{set_i} = X{set_i}(idx_feat_use, :);
    X{set_i} = normalizeInputsByStd( X{set_i}, 2);

    [nFeatures, nSamples] = size(X{1});
    trainFrac = 0.5;
    trainUse = round(nSamples*trainFrac);
    trainTF = 1:nSamples <= trainUse;
    testTF = 1:nSamples > trainUse;
%     trainIdx = 1:trainUse;
%     testIdx = trainUse+1 : nSamples;
    
    [X_cmean{set_i}, X_cstd{set_i}, X_cls_n{set_i}] = classMeans(X{set_i}(:, trainTF), S{set_i}.labels(trainTF));

end


blues = arrayfun(@(i) [0 0 i], linspace(.6, 1, nSNRs), 'un', 0);
reds = arrayfun(@(i) [i 0 0], linspace(.6, 1, nSNRs), 'un', 0);
allCols = {cat(1, blues{:}), cat(1, reds{:})};


% colrs1 = copper(nSNRs);
% colrs2 = cool(nSNRs);
% allCols = {colrs1, colrs2};

nFeatures = size(X{1}, 1);
[snr_use_for_ordering, snr_idx] = max(snrs);
tic;
% ovlaps = zeros(1, nFeatures);
% for i = 1:nFeatures
%     ovlaps(i) = quadProdGaussians(  X_cmean{snr_idx}(i, let_idxs(1)), X_cstd{snr_idx}(i, let_idxs(1)), ...
%                                     X_cmean{snr_idx}(i, let_idxs(2)), X_cstd{snr_idx}(i, let_idxs(2)) );
    m1 = X_cmean{snr_idx}(:, let_idxs(1));
    m2 = X_cmean{snr_idx}(:, let_idxs(2));

    s1 = X_cstd{snr_idx}(:, let_idxs(1));
    s2 = X_cstd{snr_idx}(:, let_idxs(2));
    
    s_pool = sqrt(s1.^2 + s2.^2);
    diffs = abs(m1 - m2) ./ s_pool;
    sgns = sign(m1 - m2);
    
%     ovlaps(i) = quadProdGaussians(  , , ...
%                                     X_cmean{snr_idx}(i, let_idxs(2)), X_cstd{snr_idx}(i, let_idxs(2)) );
    
[diffs_sorted, ord_best_feat] = sort(diffs, 'descend');

if strcmp(whichFeat, 'overfeat')
    idx_use = ord_best_feat(1:100);
else
    idx_use = ord_best_feat(1:100);
end

% end
toc;

figure(6); clf; hold on;
for set_i = 1:nSNRs
    for let_i = 1:length(let_idxs)
        let_idx = let_idxs(let_i); 

        cols = allCols{let_i};    
        idx_this_let = find(S{set_i}.labels == let_idx & testTF);
        
        Xi = bsxfun(@times, X{set_i}(idx_use, idx_this_let ), sgns(idx_use) );
        plot(Xi,  '.-', 'color', cols(set_i,:) );
    end
end




