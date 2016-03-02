function fig_showSampleFonts
%%
    fontSize = 'k32';
%     allWiggles = [0 : 20 : 90];

%     spacing_pix = 30;
%      nWig = length(allWiggles);

     allFontNames      = {'Sloan', 'Bookman', 'Helvetica', 'Yung', 'KuenstlerU'};
    nFonts = length(allFontNames);
%      get
 
    clims = [-.7, 1.2];
    imSize = [64, 64];
    noise_std = .1;
%     let_use = 'A';
    for j = 1:nFonts
%         wigSettings = struct('orientation', allWiggles(j));
%         wiggle_str = getSnakeWiggleStr(wigSettings);
        [S, b] = loadLetters(allFontNames{j}, fontSize);
%         idx_use = find(b.letters_char == let_use,1);
        
        idx_use = 1;
        let = S(:,:,idx_use);
        padTB = imSize(1) - size(let,1); padT = floor(padTB/2); padB = padTB-padT;
        padLR = imSize(2) - size(let,2); padL = floor(padLR/2); padR = padLR-padL;
        
        let2 = padarray(let, [padT, padL], 0, 'pre');
        let3 = padarray(let2, [padB, padR], 0, 'post');
        let = let3;
        ns = noise_std * randn(size(let));
        
        allLet{j} = let + ns;
        
    end

    
   
    figure(5); clf;
    for i = 1:nFonts
        subplotGap(1, nFonts, i);
        imagesc(allLet{i});
        colormap('gray');
        axis image;
        ticksOff;
        caxis(clims);
    end
  imageToScale([], 1);
    3;

end