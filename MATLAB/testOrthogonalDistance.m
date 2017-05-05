function testOrthogonalDistance

%%
    fontName = 'Bookman';
    fontSize = 'k15';
    
    allLetters = loadLetters(fontName, fontSize);
    %%
    nLet = size(allLetters, 3);
    allDists = 0:20;
    nDists = length(allDists);
    
    ccs = zeros(nDists, nDists);
    
    allLetters_pad = padarray2(allLetters, nDists, nDists, nDists, nDists, 0);
    
    progressBar('init-', nDists*nDists);
    for horiz_i = 1:nDists
        for vert_j = 1:nDists
            
            ccs_k = zeros(nLet, nLet);
            for k1 = 1:nLet
                
                lets_shifted  = circshift(allLetters_pad, [allDists(horiz_i), allDists(vert_j)]);
                
%                 ccs_k = zeros(1,nLet-1);
%                 let_idxs = setdiff(1:nLet, k1);
                for k2 = 1:nLet
                    
                    ccs_k(k1,k2) = pearsonR(allLetters_pad(:,:,k1), lets_shifted(:,:, k2 ) );
                    
                    
                end
            
            
                ccs(horiz_i, vert_j) = mean(ccs_k(:));
            end
            progressBar;
        end
    end
    %%
    figure(1); clf;
    imagesc(ccs); axis image; colorbar;
    xlabel('Horizontal Shift'); ylabel('Vertical Shift'); title({'Mean correlation coefficient between letters.', ['Font = ' fontName, ' Size = ' fontSize]})
    %%
    
    figure(2); clf;
    plot(allDists, ccs(1,:), 'bo-'); 
    hold on
    plot(allDists, ccs(:,1), 'rs-'); 
    drawHorizontalLine(0);
    plot(allDists, diag(ccs), 'g*-'); 
    legend({'cc vs horizontal shift', 'cc vs vertical shift', 'cc vs horizontal & vertical shift'})
    xlabel('Shift'); ylabel('CC');
    %%

    figure(3); imagesc(tileImages(allLetters)); 
    colormap(gray(256)); imageToScale([], 1); ticksOff; title([fontName, ' ' fontSize]);








end