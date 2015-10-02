function allLetters_margin = addMarginToPow2(allLetters, marginPixels)
%%
    sz = size(allLetters);
    logL = nextpow2(max(sz([1,2])) + marginPixels);
    L = 2^logL;

    lv = L-sz(1);
    l_up = round(lv/2); l_down = lv-l_up;
    
    lh = L-sz(2);
    l_left = round(lh/2); l_right = lh-l_left;
  %%  
    allLetters_margin = addMargin(allLetters, [l_up, l_down, l_left, l_right]);

    newSz = size(allLetters_margin);
    assert( all ( newSz([1,2]) == L) );


end