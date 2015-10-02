function signal = reconstructSignal(signalMatrix)
%     useScore = nargin > 1 && isequal(useScoreFlag, 1);

    [height, width, nLetters, nOris, nX, nY] = size(signalMatrix); %#ok<ASGLU>
    signal(nLetters, nOris, nX, nY) = struct;
    
    for let_i=1:size(signal,1)
        for ori_i=1:size(signal,2)
            for xi=1:size(signal,3)
                for yi=1:size(signal,4)
                    x = signalMatrix(:,:,let_i,ori_i,xi,yi);
                    signal(let_i,ori_i,xi,yi).image = x;
                    signal(let_i,ori_i,xi,yi).E1 = sum(x(:).^2);
                end
            end
        end
    end

end


