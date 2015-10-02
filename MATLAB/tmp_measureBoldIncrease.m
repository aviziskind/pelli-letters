%%
allSizes = [7:40, 42:2:60, 64:4:72];
% allSizes = [15];

nSizes = length(allSizes);

% fontName = 'Helvetica';
fontName = 'Sloan';

all_rs = zeros(1, nSizes);

for i = 1:nSizes

    allLet = loadLetters(fontName, allSizes(i));
    allLetB = loadLetters([fontName 'B'], allSizes(i));

    areas = zeros(1, 26);
    areasB = zeros(1, 26);

    for j = 1:26
        let = allLet(:,:,j);
        letB = allLetB(:,:,j);

        areas(j) = sum(sum(let));
        areasB(j) = sum(sum(letB));

    end
%%
%     figure(5); plot(areas, areasB, '.')
    all_rs(i) = mean(areasB ./ areas);
    
end

plot(allSizes, all_rs, 'o-');
title(fontName);