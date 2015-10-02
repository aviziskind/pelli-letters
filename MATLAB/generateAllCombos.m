function allIndexCombos = generateAllCombos(nLetters)

    nIndices = length(nLetters);

    if nIndices == 1
        v1 = 1:nLetters(1);
        allIndexCombos = v1;

    elseif nIndices == 2
        v1 = 1:nLetters(1);
        v2 = 1:nLetters(2);
        [v1_g, v2_g] = meshgrid(v1, v2);
        allIndexCombos = [v1_g(:), v2_g(:)];

    elseif nIndices == 3
        v1 = 1:nLetters(1);
        v2 = 1:nLetters(2);
        v3 = 1:nLetters(3);
        [v2_g, v1_g, v3_g] = meshgrid(v2, v1, v3);
        allIndexCombos = [v1_g(:), v2_g(:), v3_g(:)];        

    end


end