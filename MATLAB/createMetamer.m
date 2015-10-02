function [metamers, seedUsed, stats] = createMetamer(textureStats, imSize, initSeed, seedStep, all_nIter)
    madeMetamer = 0;
    curSeed = initSeed;
    show = 0;
    if ~exist('seedStep', 'var') 
        seedStep = 10;
    end
    if ~exist('all_nIter', 'var')
        all_nIter = 25;
    end
%     fprintf( char(let_idx + A_offset) );
    while ~madeMetamer
        try
            [met_final, ~, metamers, stats] = textureSynthesis(textureStats, [imSize, curSeed], all_nIter, [], [], [], show);
            assert(isequal(metamers(:,:,end), met_final)) 
            madeMetamer = true;
            seedUsed = curSeed;
        catch Merr
            if strcmp(Merr.identifier, 'MATLAB:roots:NonFiniteInput')
                curSeed = curSeed + seedStep;

            else
                rethrow(Merr)
            end
        end
    end

    3;
    
    
end