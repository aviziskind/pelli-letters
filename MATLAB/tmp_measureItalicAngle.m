%%


% allLet = loadLetters('KuenstlerU', 20);
% allLeti = loadLetters('KuenstlerUI', 20);
allLet = loadLetters('Sloan', 20);
allLeti = loadLetters('SloanI', 20);
%%

allAngles_best_shear = [];
allAngles_best_deshear = [];

%%

for let_idx = 12; %21:26;
        
    let = allLet(:,:,let_idx);
    leti = allLeti(:,:,let_idx);

    marginToAdd = 10;

    L = max([size(let,1), size(let,2), size(leti,1), size(leti,2)]);


    let(L,L)  = 0; 
    let = padarray(let, marginToAdd*[1, 1], 0, 'both');
    leti(L,L) = 0;
    leti = padarray(leti, marginToAdd*[1, 1], 0, 'both');


    figure(10); clf;
    subplot(2,4,1)
    imagesc(let); axis square; hold on;
    com_roman = centerOfMass(let);
%     plot(com_roman(1), com_roman(2), 'rx');
    title('Roman')
    %%

    subplot(2,4,2)
    imagesc(leti); axis square; hold on;
    com_italic = centerOfMass(leti);
%     plot(com_italic(1), com_italic(2), 'rx');
    title('Italic')
    % im_sheared = shearImage(leti, 12);

    % courier i: 12.25;
    % sloan L: 10
    % helvetica : 12  (11.9

    %%
    doFindBestDeshearAngle = true;

        %     allAngles = [10:.01:15];  courier
         allAngles = [5:.05:12]; % sloan

%          allAngles = [16:.1:24]; % Kuenstler

    
    
    if doFindBestDeshearAngle

        %     im_sheared = shearImage(let, -12.25);
        %%
        

        [angle_best_deshear, anglesErr_deshear, leti_desheared] = getBestShearAngleToMatchImages(leti, let, -allAngles);
        % figure(66); 
        % plot(allAngles, anglesErr, 'o-')
        % % allAngles = [12];

        allAngles_best_deshear(let_idx) = angle_best_deshear;

        subplot(2,4,3:4); plot(allAngles, anglesErr_deshear, 'o-'); xlim(lims(allAngles));

    else
        leti_desheared = shearImage(leti, -10);
        
    end
        
%     com_let = centerOfMass(let);
    
    leti_desheared = shiftAndCropToMatchCOM(leti_desheared, let);    
    
    % leti_desheared = shearImage(let, -allAngles(angle_i));
    subplot(2,4,5); 
    imagesc(leti_desheared); axis square; hold on;
    com_leti_d = centerOfMass(leti_desheared);
    % plot(com_leti_d(2), com_leti_d(1), 'rx');
    title('Italic -desheared');
%%


    let_negShear = shearImage(let, 18);

    % leti_desheared = shearImage(let, -allAngles(angle_i));
    subplot(2,4,3); 
    imagesc(let_negShear); axis square; hold on;
%     com_leti_d = centerOfMass(leti_desheared);
    % plot(com_leti_d(2), com_leti_d(1), 'rx');
    title('Roman -desheared');
    
    
    %%
    doFindBestShearAngle = true;
    if doFindBestShearAngle
        [angle_best_shear, anglesErr_shear, let_sheared] = getBestShearAngleToMatchImages(let, leti, allAngles);
        % figure(66); 
        % plot(allAngles, anglesErr, 'o-')
        % % allAngles = [12];

        % leti_desheared = shearImage(let, -allAngles(angle_i));
        

        subplot(2,4,7:8); plot(allAngles, anglesErr_shear, 'o-'); xlim(lims(allAngles));
        allAngles_best_shear(let_idx) = angle_best_shear;
    else
        let_sheared = shearImage(let, 10);
        
    end
        
    
    [m,n] = size(let);
    let_sheared = let_sheared(1:m, 1:n);
    
    let_sheared = shiftAndCropToMatchCOM(let_sheared, leti);    
    
    subplot(2,4,6); 
    imagesc(let_sheared); axis square; hold on;
    com_leti_d = centerOfMass(let_sheared);
    % plot(com_leti_d(1), com_leti_d(2), 'rx');
    title('Roman sheared')
    
    drawnow;
    imageToScale([], 3);
    3;
    
end
%%
3;

nAngles = length(allAngles);

allShifts = [-1:1]; nShifts = length(allShifts);
minErrForAngle = zeros(1,nAngles);
% maxCorr

for angle_i = 1:nAngles
    let_sheared = shearImage(let, -allAngles(angle_i));
    
    com_im_sheared = centerOfMass(let_sheared);
    let_sheared_cent = circshift(let_sheared, flipud( -round(com_im_sheared - com_italic) ) );

    com_new = centerOfMass(let_sheared_cent);    

    allErrs = zeros(nShifts, nShifts);
    
    for ishift_idx = 1:nShifts
        for jshift_idx = 1:nShifts
            let_sheared_cent_shft = circshift(let_sheared_cent, [allShifts(ishift_idx), allShifts(jshift_idx)]);
           
            allErrs(ishift_idx, jshift_idx) = sum( (let_sheared_cent_shft(:) - leti(:)).^2 );
        end
    end
    minErrForAngle(angle_i) = min(allErrs(:));
    
end
%%
subplot(2,4,6);
imagesc(let_sheared_cent); axis square; hold on;
plot(com_new(1), com_new(2), 'rx');
plot(com_italic(1), com_italic(2), 'go');
title('Roman Sheared');

    
%%
for i = 1:nAngles
    
%             im_sheared_shifted = 
            
            imagesc(let_sheared);
            axis square;
            
    

end



%%

h_idxs = 10:80;
n = length(h_idxs);

w = zeros(1, n);
for i = 1:n
    xx = 1:L;
    wgts = let_sheared(h_idxs(i),:);
    
    w(i) = sum(xx .* wgts) / sum(wgts);
    
    
%     w(i) =  wgt_mean(1:L, );
end
%
subplot(1,4,4);
ii = ~isnan(w);
w = w(ii);
w = gaussSmooth(w, 3);
xx = xx(ii);
plot(xx, w); xlim([0, length(w)]);

% axis ij
% axis xy