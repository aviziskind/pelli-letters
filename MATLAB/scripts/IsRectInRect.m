function inside = IsRectInRect(r,rect)

% inside = IsRectInRect(r,rect)
%
% Is rect r inside the rect?
%
% Also see PsychRects.
 
% 6/26/13  dgp  Wrote it.
 
if (IsInRect(r(1),r(2),rect) && IsInRect(r(1),r(4),rect) && IsInRect(r(3),r(2),rect) && IsInRect(r(3),r(4),rect))
    inside = 1;
else
    inside = 0;
end

% function bool = IsRectInRect(rectA, rectB)
% 
%     bool = ( (rectA(1) >= rectB(1)) && (rectA(2) >= rectB(2)) && ...
%            (rectA(3) <= rectB(3)) && (rectA(4) <= rectB(4)) );
%     
% end