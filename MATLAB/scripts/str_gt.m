function tf = str_gt(s1, s2)
    n1 = length(s1);
    n2 = length(s2);
%     n_min = min(n1, n2);
%     
%     if ~strncmp(s1, s2, n_min)
%         tf = s1(1:n_min) > s2(1:n_min);
%         
%     else
%         tf = n1 > n2;
%         end
%         tf =
%         if 
%     
%     n_max = max(n1, n2);
%     s1 = num2str(s1);
%     s2 = num2str(s2);
    n = max(n1, n2);
    s1(n1+1:n) = 0;
    s2(n2+1:n) = 0;
    cmp = s1 - s2;
    idx_nz = find(cmp, 1);
    tf = 0;
    if ~isempty(idx_nz)
        tf = cmp(idx_nz) > 0;
    end        

end