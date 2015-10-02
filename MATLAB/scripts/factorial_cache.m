function f = factorial_cache(n)
%     factorials_saved = [1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800  479001600, 6227020800, 87178291200, 1307674368000, 20922789888000, 355687428096000, 6402373705728000, 121645100408832000, 2432902008176640000];            
    factorials_saved = [1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800  479001600];            
    f = factorials_saved(n);
end


% function f = factorial_cache(n)
%     persistent factorials_saved
%         
%     if length(factorials_saved) < n || (factorials_saved(n) == 0)
%         factorials_saved(n) = factorial(n);
%     end
%     f = factorials_saved(n);
%     
%     
% end
