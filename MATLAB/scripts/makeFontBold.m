function boldLetters = makeFontBold(letters, boldFactor, letB)


    [h_orig, w_orig, nLetters] = size(letters); %#ok<ASGLU>
    h_margin = 4;
    w_margin = 4;
    lettersPadded = padarray(letters, [h_margin, w_margin], 0, 'both');
    
    letB = padarray(letB, [h_margin, w_margin], 0, 'both');
    
    [m,n, ~] = size(lettersPadded);
    
%     italicLettersPadded = zeros(size(letters));
    for let_idx = 1:nLetters
        
%         let_orig = letters(:,:,let_idx);
        let_padded = lettersPadded(:,:,let_idx);
        
        let_bold = makeLetterBold(let_padded, boldFactor, letB);
        
        
        
        lettersPadded(:,:,let_idx) = let_bold(1:m, 1:n);
        
%         let_sheared_cent = shiftAndCropToMatchCOM(let_sheared, let_orig)
        
%         lettersPadded(:,:,let_idx) = 
        
        
    end

    lettersPadded = centerAlignLetters(lettersPadded);
    margin = 0;
    [~, ~, ~, ~, boldLetters] = findLetterBounds(lettersPadded, margin);



end


function let_bold = makeLetterBold(let, boldFactor, letB)
%%

    method = 'simple';
    
    if strcmp(method, 'simple')
        
        nPixOrig = sum(let(:));
        curIncrease = 0;
        shift_amt = 0;
        while curIncrease < boldFactor
            shift_amt = shift_amt + 1;
            let_shL = circshift(let, [0, -shift_amt]);
            let_shR = circshift(let, [0,  shift_amt]);
            let_shU = circshift(let, [-shift_amt, 0]);
            let_shD = circshift(let, [shift_amt,  0]);
        
            toAdd = ~let & (let_shL | let_shR);
            curIncrease = (nPixOrig + sum(toAdd(:))) / nPixOrig;
        end
        
        
%         let2 = let * w(1) + let_shL * w(2) + let_shR * w(3) + let_shU * w(4) + let_shD * w(5);
%         let2 = sigmoid(let2, 1, .1, .5);
        
        
        
%         wgt = [1, 
        [m,n] = size(let);
        [j_grid, i_grid] = meshgrid(1:n, 1:m);

        let_dist = zeros(size(let));
        for i = 1:m
            di = i_grid - i;
            for j = 1:n
                dj = j_grid - j;

                rsqr = di.^2 + dj.^2;

                let_dist(i,j) = sqrt( sum( sum( let.^2 ./ (.1 + rsqr) ) ) );
    %             let_dist(i,j) = sqrt( sum( sum( let.^2 rsqr ) ) ) ;

            end
        end
        
        
        
        
    elseif strcmp(method, 'general')

        [m,n] = size(let);
        [j_grid, i_grid] = meshgrid(1:n, 1:m);

        let_dist = zeros(size(let));
        for i = 1:m
            di = i_grid - i;
            for j = 1:n
                dj = j_grid - j;

                rsqr = di.^2 + dj.^2;

                let_dist(i,j) = sqrt( sum( sum( let.^2 ./ (.1 + rsqr) ) ) );
    %             let_dist(i,j) = sqrt( sum( sum( let.^2 rsqr ) ) ) ;

            end
        end

        w = [1, 1, 1, 1, 1];
        let_shL = circshift(let, [0, -1]);
        let_shR = circshift(let, [0, 1]);
        let_shU = circshift(let, [-1, 0]);
        let_shD = circshift(let, [1, 0]);
        w = w/sum(w);
        let2 = let * w(1) + let_shL * w(2) + let_shR * w(3) + let_shU * w(4) + let_shD * w(5);
        let2 = sigmoid(let2, 1, .1, .5);


        subplot(1,3,1);
        imagesc(let); axis image;
        subplot(1,3,2);
        imagesc(letB); axis image;

    %     let_dist(let_dist < 2) = 0;
        subplot(1,3,3);
        imagesc(let_dist); axis image; % colorbar;
    %     for 

3;
    end


end