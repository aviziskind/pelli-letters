function fig_showSampleSnakes

    fontSize = 'k32';
    allWiggles = [0 : 20 : 90];
%     spacing_pix = 30;
     nWig = length(allWiggles);
     
%      get
 
    let_use = 'N';
    for j = 1:nWig
        wigSettings = struct('orientation', allWiggles(j));
        wiggle_str = getSnakeWiggleStr(wigSettings);
        [S, b] = loadLetters(['Snakes' wiggle_str], fontSize);
        idx_use = find(b.letters_char == let_use,1);
        let = S(:,:,idx_use);
        allLet{j} = let;
        
    end

   
    figure(5); clf;
    for i = 1:nWig
        subplotGap(1, nWig, i);
        imagesc(allLet{i});
        colormap('gray');
        axis image;
        ticksOff;
        imageToScale([], 2)
    end
  
    3;

end