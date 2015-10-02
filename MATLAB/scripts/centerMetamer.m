function met_cent = centerMetamer(met)
    if size(met,3) > 1
        met_cent = zeros(size(met));
        for i = 1:size(met,3)
            for j = 1:size(met,4)
                met_cent(:,:,i,j) = centerMetamer(met(:,:,i,j));            
            end
        end
        return;
    end

    [n1, n2] = size(met);

    mn2 = mean(met,1); % mean across dim2 (average across dim1)
    mn1 = mean(met,2); % mean across dim1 (average across dim2)
    
    idx_m1 = circMean(mn1);
    idx_m2 = circMean(mn2);
    %%
    met_cent = circshift(met, [(n1/2) - idx_m1, (n2/2)-idx_m2]);
    
    show = 0;
    if show
        %%
       figure(3); clf; 
        subplot(1,2,1);
        imagesc(met); axis square;
        subplot(1,2,2);
        imagesc(met_cent); axis square;
        colormap('gray');
        
    end
    3;
    
    
end



