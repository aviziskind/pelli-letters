function letterSignals = generateLetterSignals(allLetters, xs, ys, orientations, params)
    if nargin < 5
        params = struct;
    end

    if ~isfield(params, 'pixPerDeg') 
        params.pixPerDeg = 1;
    end
    if ~isfield(params, 'imageHeight') 
        params.imageHeight = size(allLetters, 1);
    end
    if ~isfield(params, 'imageWidth') 
        params.imageWidth = size(allLetters, 2);
    end
    if ~isfield(params, 'horizPosition')
        params.horizPosition = 'centered';
    end
    if ~isfield(params, 'vertPosition')
        params.vertPosition = 'centered';
    end
    if ~isfield(params, 'allowLettersToFallOffImage') 
        params.allowLettersToFallOffImage = 0;
    end

    
        %%
        
    pixPerDeg = params.pixPerDeg;
    imageHeight = params.imageHeight;
    imageWidth = params.imageWidth;
    horizPosition = params.horizPosition;
    horizCentered = strcmp(horizPosition, 'centered');
    vertPosition = params.vertPosition;
    vertCentered = strcmp(vertPosition, 'centered');
    allowLettersToFallOffImage = params.allowLettersToFallOffImage;
    
%     includeFields = params.includeFields;
    

    nX = length(xs);
    nY = length(ys);
    nOris = length(orientations);

    Dx = xs(end)-xs(1);
    Dy = ys(end)-ys(1);
    
    fprintf('Creating letter signals ... ');

    
    
    allLetters_allOrientations = allLetters;        
    if ~iscell(allLetters_allOrientations) && length(orientations) > 1
        %%
        allLetters_allOrientations = rotateLetters(allLetters, orientations);
    end
    
    
    
    if iscell(allLetters_allOrientations)
        nLetters = size(allLetters_allOrientations{1},3);
    else
        nLetters = size(allLetters_allOrientations,3);
    end
    
    letterSignals(nLetters, nX, nY, nOris) = struct;

%     progressBar('init-', nLetters * nOris * nX * nY)
%         letter_i = allLetters(:,:,let_i);
    for ori_i=1:nOris
        if iscell(allLetters_allOrientations)
            allLetters = allLetters_allOrientations{ori_i}; %imrotate(letter_i, orientations(ori_i), 'bilinear');
        end
            
        [idxT, idxB, idxL, idxR] = findLetterBounds(allLetters, 0, 1);

        
        [let_h, let_w, nLetters] = size(allLetters);
        
        for let_i=1:nLetters
            
            letter_i = allLetters(:,:,let_i);
            if horizCentered
                h_offset = floor((imageWidth - (let_w+Dx) )/2);
            else
                h_offset = horizPosition;
            end
            
            if vertCentered
                v_offset = floor((imageHeight- (let_h+Dy) )/2);
            else
                v_offset = vertPosition;
            end               
                
            idx_horiz0 = [1:let_w]+h_offset;
            idx_vert0  = [1:let_h]+v_offset;
    
            for xi=1:nX
                
                idx_horiz = idx_horiz0 + xs(xi);
                
                horizIdx_inImage = ibetween(idx_horiz, [1, imageWidth]);
                if ~allowLettersToFallOffImage
                    assert(all(horizIdx_inImage)); % ALL of the letter must be in the image?
                end
%                 assert(any(horizIdx_inImage)) % SOME of the letter must be in the image
                
                idx_horiz_full = idx_horiz;
                idx_horiz = idx_horiz(horizIdx_inImage);
                
                for yi=1:nY
                    idx_vert = idx_vert0 + ys(yi);
                    
                    vertIdx_inImage = ibetween(idx_vert, [1, imageHeight]);
                    if ~allowLettersToFallOffImage
                        assert(all(vertIdx_inImage)); % ALL of the letter must be in the image?
                    end
%                     assert(any(vertIdx_inImage)); % SOME of the letter must be in the image

                    idx_vert_full = idx_vert;
                    idx_vert = idx_vert(vertIdx_inImage);
                    
                    curImage = zeros(imageHeight, imageWidth, 'single');
                    curImage(idx_vert, idx_horiz) = letter_i(vertIdx_inImage, horizIdx_inImage);
                    curE1 = sum(letter_i(:) .^2)/pixPerDeg^2; % use actual letter to calculate E1, in case is cut off in actual image.
%                     curE1 = sum(curImage(:) .^2)/pixPerDeg^2;
                    
                    letterSignals(let_i,xi,yi,ori_i).image = curImage;
                    letterSignals(let_i,xi,yi,ori_i).E1 = curE1;
                    
                    if ori_i == 1 && let_i == 1 && xi == 1 && yi == 1
                        image1 = curImage;
                        E1_1 = curE1;
                    end
                    x_bnd = lims( idx_horiz_full(idxL(let_i):idxR(let_i) ))';
                    y_bnd = lims( idx_vert_full( idxT(let_i):idxB(let_i)) )';

                    letterSignals(let_i,xi,yi,ori_i).rho=dot(image1(:),curImage(:))/pixPerDeg^2/sqrt(E1_1 * curE1);                    
                    letterSignals(let_i,xi,yi,ori_i).x_bnd = x_bnd;
                    letterSignals(let_i,xi,yi,ori_i).y_bnd = y_bnd;

                    
%                     letterSignals(let_i,xi,yi,ori_i).pixArea=pixPerDeg^-2;
                end
            end
        end
    end
    fprintf(' done.\n');

    
    
        %{
    [let_h, let_w, nLet] = size(allLetters);
    x_offset = floor((imageWidth - (let_w+Dx) )/2);
    y_offset = floor((imageHeight- (let_h+Dy) )/2);
    
%     progressBar('init-', nLetters * nOris * nX * nY)
    for let_i=1:nLetters
%         letter_i = allLetters(:,:,let_i);
        
        letter_i = allLetters(:,:,let_i); %imrotate(letter_i, orientations(ori_i), 'bilinear');

        idx_horiz0 = [1:let_w]+x_offset;
        idx_vert0  = [1:let_h]+y_offset;

        for xi=1:nX
            idx_horiz = idx_horiz0 + xs(xi);
            assert(all(ibetween(idx_horiz, [1, imageWidth])))

            for yi=1:nY
                idx_vert = idx_vert0 + ys(yi);

                assert(all(ibetween(idx_vert, [1, imageHeight])))

                letterSignals(let_i,xi,yi).image = zeros(imageHeight, imageWidth, precision);
                letterSignals(let_i,xi,yi).image(idx_vert, idx_horiz) = letter_i;
                letterSignals(let_i,xi,yi).x_bnd = lims(idx_horiz(idxL(let_i):idxR(let_i)))';
                letterSignals(let_i,xi,yi).y_bnd = lims(idx_vert)';
                letterSignals(let_i,xi,yi).x_offset = x_offset;
                letterSignals(let_i,xi,yi).y_offset = y_offset;
                letterSignals(let_i,xi,yi).letter_idx = let_i;

%                 letterSignals(let_i,xi,yi).E1=dot(letterSignals(let_i,xi,yi).image(:),letterSignals(let_i,xi,yi).image(:))/pixPerDeg^2;
%                 letterSignals(let_i,xi,yi).rho=dot(letterSignals(1,1,1,1).image(:),letterSignals(let_i,xi,yi).image(:))/pixPerDeg^2/sqrt(letterSignals(1,1,1,1).E1.*letterSignals(let_i,xi,yi).E1);
%                 letterSignals(let_i,xi,yi).pixArea=pixPerDeg^-2;
            end
        end
        
    end
    fprintf('done\n');
    
    %}

    
end