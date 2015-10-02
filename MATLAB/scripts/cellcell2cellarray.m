function ca = cellcell2cellarray(cc)
    ca = cellfun(@(c) [c{:}], cc, 'un', 0);        
end