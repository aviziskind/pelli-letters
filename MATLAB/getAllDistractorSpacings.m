function [allDistractSpacings_pix, allDistractSpacings] = getAllDistractorSpacings(xrange, fontWidth, nDistractors, testTargetPosition)
    
    letterSpacingPixels = 1;
    dx = xrange(2);
    Nx = (xrange(3)-xrange(1))/dx + 1;
   
    minXSpacing = ceil( (fontWidth + letterSpacingPixels)/dx );
        
    assert(Nx == round(Nx));
    
    %%
    if strcmp(testTargetPosition, 'all')
        testTargetPosition = 1:Nx;
    end
    minPos = min(testTargetPosition);
    maxPos = max(testTargetPosition);

    maxDistOnLeft  = minPos - 1;
    maxDistOnRight = Nx - maxPos;

    if nDistractors == 1
        maxXSpacing = max(maxDistOnLeft, maxDistOnRight);
    elseif nDistractors == 2
        maxXSpacing = min(maxDistOnLeft, maxDistOnRight);
    end
    
    allDistractSpacings = minXSpacing : maxXSpacing;
    allDistractSpacings_pix = allDistractSpacings * dx;
   
end        


%{
old version:
function [allDistractSpacings_pix, allDistractSpacings] = getAllDistractorSpacings(xrange, fontWidth, nDistractors)
    
    letterSpacingPixels = 1;
    dx = xrange(2);
    Nx = (xrange(3)-xrange(1))/dx + 1;
   
    assert(Nx == round(Nx));
    allDistractSpacings_poss = [1: (Nx-1)/nDistractors ];

    allDistractSpacings_tf_use = allDistractSpacings_poss*dx >= fontWidth + letterSpacingPixels;
    allDistractSpacings = allDistractSpacings_poss(allDistractSpacings_tf_use);
    allDistractSpacings_pix = allDistractSpacings * dx;
end        
%}