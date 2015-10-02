function com = centerOfMass(img)


    [nRows,nCols] = size(img);

    [j_grid, i_grid] = meshgrid(1:nCols, 1:nRows);
    %%
    X = [i_grid(:)'; j_grid(:)'];
        
    com = 1/sum(img(:)) * X * img(:);



end

