% function LettersForTraining
% May 2013 by Denis Pelli
% Make letters in noise so that Olivier can implement a machine learner
% that will produce a letter classifier. We want 10,000 images for each
% condition. We fix letter signalContrast at 1, and use several noise
% levels. We specify the series by E/N. Pelli et al. 2006 found that:
% Bookman, log Eideal=-2.60, eff=9%,
% uppercase Bookman, log Eideal=-2.63, eff=9%
% Sloan, log Eideal=-2.59, eff=10.8%
% log N = -3.60 and N = 0.00025 deg^2.
% log E/N re ideal: 0, 0.5, 1, 1.5, 2.
% Relative to human, that will range roughly -1 to 1, which seems fine.

% We call the 10,000 32x32 images a "set". We'll try out several fonts,
% but, initially, we might start with Sloan. We'll use only 9 letters:
% DHKNORSVZ. Each set will have a fixed letter signalContrast and noise
% noiseContrast. The noise is zero-mean Gaussian. The image "background" is
% currently set to zero, but we assume a background of 1 in computing
% signal and noise contrasts. The letter signalContrast is Weber
% signalContrast, the difference in luminance from the background divided
% by the background. letter signalContrast is 1. The noise signalContrast
% is RMS contrast. We want to try many different noise levels. We might
% train at a low noise level and test at a high noise level, or vice versa.
% I propose to make five sets, each at a different noise level.
%
% The dataset is a Matlab save file containing a "targets" matrix of grey
% scales, each row corresponding to a letter in noise. To do so we flatten
% each 32x32 noisy letter into a 1024 line vector. The targets matrix is
% thus of size 10,000 x 1024. 
Screen('Preference', 'SkipSyncTests', 1);


quickTest=0;
clear set
setSize=10000; % normally 10,000.
signalContrast=1;
background=0;
% targetKind='gabor';
targetKind='text';
observer='machine';
% targetKind='whiteDisk';
% targetKind='blackDisk';
%fontSize=22; % nominal size of the text
Screen('Preference', 'TextRenderer', 1);
textFont='Sloan'; bold=0; textSignals={'D','H','K','N','O','R','S','V','Z'}; fontSize=28; % Sloan
%textFont='Kuenstler Script LT'; Screen('Preference', 'TextRenderer', 2); bold=1; fontSize=20;
%textFont='KuenstlerScript LT TwoBold'; bold=1; fontSize=20; % for old 32-bit Psychtoolbox
textFont='Georgia'; bold=0; fontSize=11; 
% textFont='Kunstler Script';
% textFont='Braille';
% textFont='Yung';
textSignals={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
% textSignals={'f', 'g', 'h', 't'};
%capitalize=1;
capitalize=1;
scl_factor = 10;
imageWidth=32*scl_factor;
imageHeight=32*scl_factor;
examineBounds=0;
orientations=[-40:40:40];
xs=[-6:6:6]/2;
ys=[-6:6:6]/2;
orientations=0;
xs=0;
ys=0;
xs=round(xs);
ys=round(ys);
if quickTest
    examineBounds=1;
    textSignals={textSignals{1:3}}; 
    signalContrast=1;
    setSize=10; % normally 10,000.
    magnification=10;
    imageWidth=magnification*imageWidth;
    imageHeight=magnification*imageHeight;
    fontSize=magnification*fontSize;
    xs=magnification*xs;
    ys=magnification*ys;
end

overflowCheck=1;
human=0;
if human
    distanceCm=50; % viewing distance
    cyclesPerDeg=1; % cycles per deg, if gabor
    diskDeg=1.1; % diameter, if disk
    spaceConstantFraction=0.5; % fraction of period
    degPerCm=57/distanceCm;
    % pixPerCm=45; % for MacBook at native resolution.
    pixPerCm=1366/25.7; % =53. for 11" MacAir at highest resolution
    pixPerDeg=pixPerCm/degPerCm;
    % fprintf('FIRST pixPerDeg %.1f\n',pixPerDeg);
else
    pixPerDeg=1;
end
fprintf('\n%s %s\n',mfilename,datestr(now));

try
    if ~streq(observer,'ideal') || streq(targetKind,'text')
        oldVisualDebugLevel = Screen('Preference','VisualDebugLevel', 3);
        oldSupressAllWarnings = Screen('Preference','SuppressAllWarnings', 1);
        whichScreen = max(Screen('Screens'));
        whichScreen=0;
        HideCursor;
        window = Screen('OpenWindow', whichScreen);
        black = BlackIndex(window);  % Retrieves the CLUT color code for black.
        white = WhiteIndex(window);  % Retrieves the CLUT color code for white.
        gray = (black + white) / 2;  % Computes the CLUT color code for gray.
        Screen('FillRect', window, gray);
        Screen('Flip', window);
        originalTextFont=Screen(window,'TextFont');
        originalTextSize=Screen(window,'TextSize');
        originalTextStyle=Screen(window,'TextStyle');
        % measure frame rate
        Screen(window,'Flip');
        t=GetSecs;
        for i=1:10
            Screen(window,'Flip');
        end
        t=GetSecs-t;
        framesPerSec=10/t;
    else
        window=-1;
    end
    if window >= 0
        screenRect=Screen('Rect', window);
        screenWidthPix=RectWidth(screenRect);
        fprintf('Actual screenWidthPix %.0f\n',screenWidthPix);
    else
        screenWidthPix=1366;
        fprintf('Assuming screenWidthPix %.0f\n',screenWidthPix);
    end
    fprintf('Using Screen textRenderer %d\n',Screen('Preference', 'TextRenderer'));
    switch(targetKind)
        case 'gabor'
            scratchHeight=6*spaceConstantFraction/cyclesPerDeg*pixPerDeg;
            scratchHeight=ceil(scratchHeight);
            scratchWidth=scratchHeight;
        case {'whiteDisk','blackDisk'}
            scratchHeight=diskDeg*pixPerDeg;
            scratchHeight=ceil(scratchHeight);
            scratchWidth=scratchHeight;
        case {'text'}
            scratchHeight=ceil(3*fontSize)+max([ys,0])-min([ys,0]);
            scratchWidth=ceil(1+0.75*scratchHeight*max(cellfun(@length,textSignals)))+max([xs,0])-min([xs,0]);
            shapes=length(textSignals);
    end
    scratchHeight = scratchHeight*5;
    scratchWidth = scratchWidth*5;
    fprintf('target is %s\n',targetKind);
    fprintf('setSize %d\n',setSize);
    fprintf('textFont %s, fontSize %d, bold %d, shapes %d\n',textFont,fontSize,bold,shapes);
    %     fprintf('cyclesPerDeg %.1f, spaceConstantFraction %.1f\n',cyclesPerDeg,spaceConstantFraction);
    fprintf('%s ',textSignals{:})
    fprintf('\n');
    fprintf('Orientations (deg) ');
    fprintf('%.0f,',orientations);
    fprintf('\n');
    fprintf('xs (pix) ');
    fprintf('%.0f,',xs);
    fprintf('\n');
    fprintf('ys (pix) ');
    fprintf('%.0f,',ys);
    fprintf('\n');
    fprintf('imageHeight %.0f, imageWidth %.0f, \n',imageHeight,imageWidth);
    fprintf('scratchHeight %.0f, scratchWidth %.0f, \n',scratchHeight,scratchWidth);
    %     fprintf('offsetFractionOfTarget %.2f\n',offsetFractionOfTarget);
    
%     [ymesh,xmesh]=ndgrid(1:imageHeight,1:imageWidth); % one cell per check
%     xmesh=xmesh-mean(mean(xmesh));
%     ymesh=ymesh-mean(mean(ymesh));
%     period=(pixPerDeg/cyclesPerDeg); 
%     spaceConstant=period*spaceConstantFraction; % in checks
    % create the noise-free signal images
    clear signal
    for i=1:shapes
        % signal gamut is [-1 1].
%         rad=(90-signal(i).ori)*pi/180;
%         x=xmesh-signal(i).x;
%         y=ymesh-signal(i).y;
        switch(targetKind)
%             case 'gabor',
%                 signal(i).image=exp(-(x.^2+y.^2)/spaceConstant^2).*sin(2*pi*(cos(rad)*x+sin(rad)*y)/period);
%             case 'whiteDisk',
%                 signal(i).image=double((x.^2+y.^2)<(0.5*scratchHeight)^2);
%             case 'blackDisk',
%                 signal(i).image=double((x.^2+y.^2)<(0.5*scratchHeight)^2);
%                 signal(i).image=-signal(i).image;
            case 'text',
                Screen(window,'TextFont',textFont);
                font=Screen(window,'TextFont');
                if ~strcmp(font,textFont)
                    fprintf('Sorry, can''t find font ''%s''.\n',textFont);
                    clear screen; ShowCursor;
                    error('Sorry, can''t find font ''%s''.',textFont)
                end
                signalRect=[0,0,scratchWidth,scratchHeight];
                signalRect=CenterRect(signalRect,screenRect);
                Screen(window,'FillRect',0,signalRect);
                Screen(window,'TextFont',textFont);
                Screen(window,'TextSize',fontSize);
                Screen(window,'TextStyle',bold);
                HideCursor;
                x0=round(signalRect(RectLeft)/2+signalRect(RectRight)/2);
                y0=round(signalRect(RectTop)/3+signalRect(RectBottom)*2/3);
                % Find signalBounds. 
                % All text is on same baseline, horizontally centered.
                string=textSignals{i};
                if capitalize
                    string=upper(string);
                end
                %string=['     ',string,'      '];
                bounds=Screen('TextBounds',window,string);
                width=RectWidth(bounds)*2;
                Screen(window,'FillRect',0);
                Screen(window,'DrawText',string,x0-width/2,y0,255,0,1);
                Screen('Flip', window,0,1);
                
                 
                target=Screen(window,'GetImage',signalRect);
                target=target(:,:,1);
                for io=1:length(orientations)
                    newTarget=imrotate(target,orientations(io),'bilinear','crop');
                    [y,x]=find(newTarget>0);
                    signalBounds=[min(x)-1,min(y)-1,max(x),max(y)];
                    scratchRect=[0,0,size(target,2),size(target,1)];
                    for ix=1:length(xs)
                        for iy=1:length(ys)
                            signal(i,io,ix,iy).orientation=orientations(io);
                            signal(i,io,ix,iy).x=xs(ix);
                            signal(i,io,ix,iy).y=ys(iy);
                            signal(i,io,ix,iy).string=string;
                            if ~IsRectInRect(signalBounds,scratchRect)
                                error('Out of bounds, before x,y shift. Reduce letter size.');
                            end
                            signal(i,io,ix,iy).scratchBounds=OffsetRect(signalBounds,xs(ix),ys(iy));
                            if ~IsRectInRect(signal(i,io,ix,iy).scratchBounds,scratchRect)
                                error('Out of bounds, after x,y shift. Reduce letter size.');
                            end
%                             if ~IsRectInRect(signal(i,io,ix,iy).scratchBounds,[0,0,imageWidth,imageHeight])
%                                 error('Out of bounds. Reduce letter size.');
%                             end
                            t=double(newTarget)/255;
                            signal(i,io,ix,iy).scratch=circshift(t,[ys(iy),xs(ix)]);
                        end
                    end
                end
                if examineBounds
                    FlushEvents('keyDown','mouseDown')
                    newTarget=imrotate(target,0,'bilinear','crop');
                    [y,x]=find(newTarget>0);
                    signalBounds=[min(x)-1,min(y)-1,max(x),max(y)];
                    signalBounds=OffsetRect(signalBounds,signalRect(RectLeft),signalRect(RectTop)); % screen coordinates
                    Screen(window,'FrameRect',127,InsetRect(signalBounds,-1,-1),1);	% visual check of bounding box
                    %Screen('CopyWindow',window,window,signalBounds,signalBounds,'notSrcCopy'); % visual check of bounding box
                    Screen(window,'TextFont',originalTextFont);
                    Screen(window,'TextSize',24);
                    Screen(window,'TextStyle',0);
                    Screen(window,'DrawText','Click to continue.',200,450,255);
                    Screen('Flip', window);
                    GetClicks;
                    Screen(window,'FillRect');
                end
                ShowCursor;
                Screen(window,'TextFont',originalTextFont);
                Screen(window,'TextSize',originalTextSize);
                Screen(window,'TextStyle',originalTextStyle);
        end
    end
    Screen('CloseAll');
    ShowCursor;
    FlushEvents('KeyDown');
    if window>=0
        Screen('Preference','VisualDebugLevel', oldVisualDebugLevel);
        Screen('Preference','SuppressAllWarnings', oldSupressAllWarnings);
    end
    
    
    
    scratchBounds=signal(1,1,1,1).scratchBounds;
    for i=1:shapes
        for io=1:length(orientations)
            for ix=1:length(xs)
                for iy=1:length(ys)
                    scratchBounds=UnionRect(scratchBounds,signal(i,io,ix,iy).scratchBounds);
                end
            end
        end
    end
    fprintf('scratchBounds %d,%d,%d,%d, width %d, height %d\n',scratchBounds(:),RectWidth(scratchBounds),RectHeight(scratchBounds));
    if RectWidth(scratchBounds)>imageWidth || RectHeight(scratchBounds)>imageHeight
        fprintf('%dx%d letter bounds exceeds specified %dx%d image size.\n',RectWidth(scratchBounds),RectHeight(scratchBounds),imageWidth,imageHeight);
        ratio=max(RectWidth(scratchBounds)/imageWidth,RectHeight(scratchBounds)/imageHeight);
        fprintf('Try reducing the fontSize from %d to %d\n',fontSize,floor(fontSize/ratio));
        error('Letter too big.');
    end
    imageRect=[0,0,imageWidth,imageHeight];
    signalBounds=CenterRect(scratchBounds,imageRect);
    fprintf('signalBounds %d,%d,%d,%d, width %d, height %d\n',signalBounds(:),RectWidth(signalBounds),RectHeight(signalBounds));
    for i=1:shapes
        for io=1:length(orientations)
            for ix=1:length(xs)
                for iy=1:length(ys)
                    signal(i,io,ix,iy).image=zeros(imageHeight,imageWidth);
                    signal(i,io,ix,iy).image(signalBounds(2)+1:signalBounds(4),signalBounds(1)+1:signalBounds(3))=signal(i,io,ix,iy).scratch(scratchBounds(2)+1:scratchBounds(4),scratchBounds(1)+1:scratchBounds(3));
                    signal(i,io,ix,iy).E1=dot(signal(i,io,ix,iy).image(:),signal(i,io,ix,iy).image(:))/pixPerDeg^2;
                    signal(i,io,ix,iy).rho=dot(signal(1,1,1,1).image(:),signal(i,io,ix,iy).image(:))/pixPerDeg^2/sqrt(signal(1,1,1,1).E1.*signal(i,io,ix,iy).E1);
                    signal(i,io,ix,iy).pixArea=pixPerDeg^-2;
                end
            end
        end
    end
    logE1=log10([signal(:).E1]);
    fprintf('signal log E1 %.2f�%.2f\n',mean(logE1),std(logE1));
    fprintf('cross-correlation of signal(1,1) and signal(:,:)\n');
    for i=1:shapes
%         fprintf('%.3f, ',signal(i,:).rho);
%         fprintf('\n');
    end
    logEstimatedEOverNIdealThreshold=-2.6- -3.60; % We could use a fancier formula from my 2006 paper that takes rho into account. But this is fine for typical fonts.
    
    
     showAllLetters = 1;
    if showAllLetters
        %%
       
        nLetters = length(signal);
        mm = floor(sqrt(nLetters)); nn = ceil(nLetters / mm);
        sigMatrix = zeros(imageHeight, imageWidth, nLetters);

        for i = 1:nLetters
            sigMatrix(:,:,i) = signal(i,1,1).image;
        end
        margin = 4;
        sumSigs = sum(sigMatrix,3);
        
        bnd_T = find( sum(sumSigs,1), 1, 'first');
        bnd_B = find( sum(sumSigs,1), 1, 'last');
        bnd_L = find( sum(sumSigs,2), 1, 'first');
        bnd_R = find( sum(sumSigs,2), 1, 'last');
        
        idxT = max( bnd_T - margin, 1);
        idxB = min( bnd_B + margin, imageHeight);
        idxL = max( bnd_T - margin, 1);
        idxR = min( bnd_B + margin, imageWidth);
        
        nW = bnd_R-bnd_L+1;
        nH = bnd_B-bnd_T+1;
        %%
        sigMatrix_trunc = sigMatrix(idxT:idxB, idxL:idxR, :);
        
         figure(20); clf;
        for i = 1:nLetters
            % bnd = signal(i).scratchBounds;
            subplotGap(mm,nn,i);
            imagesc(sigMatrix_trunc(:,:,i));
            set(gca, 'xtick', [], 'ytick', []); axis square;
        end
        colormap('gray')
        
%         calculateFontComplexity(sigMatrix(:,:,1), 0, 1)
        
        [mComplex] = calculateFontComplexity(sigMatrix, 2);
        3;
        
    end
    %%
    filename = 'fonts_lims.mat';
    fld_name = sprintf('%s_b%d_s%d', strrep(textFont, ' ', '_'), bold, fontSize);
    S.(fld_name) = [nW, nH];
   
    append_str = iff(exist(filename, 'file'), {'-append'}, {});
        save(filename, '-struct', 'S', append_str{:});
        3;

    %%
    3;
    % Create one set of stimuli for each condition. Typically we'll have
    % 10000 stimuli in each set, and have five sets differing in noise
    % signalContrast.
    
    n.noiseType='gaussian';
    switch n.noiseType
        case 'gaussian',
            n.noiseBound=2;
            temp=randn([1,20000]);
            n.noiseList=find(sign(temp.^2-n.noiseBound^2)-1);
            n.noiseList=temp(n.noiseList);
            clear temp;
            n.noiseList=n.noiseList/std(n.noiseList);
        case 'uniform',
            n.noiseBound=1;
            n.noiseList=-1:1/1024:1;
        case 'binary',
            n.noiseBound=1;
            n.noiseList=[-1 1];
        otherwise,
            clear screen; ShowCursor;
            error(sprintf('Unknown noiseType ''%s''',n.noiseType));
    end
    n.noiseSize=[imageHeight,imageWidth];
    
    clear set stimulus
    fprintf('Now computing sets.\n');
    fprintf(['MATLAB Figure 1 will display 5 stimuli (left column). One row per condition.\n'...
        'The noise drops as you go down the column. Within a row, you see (left)\n'...
        'a letter-in-noise stimulus, then (middle) just the letter signal, and\n'...
        'then (right) just the noise, computed by subtracting the letter from the stimulus.\n']);
    figure(1);
    clf;
    cond=0;
    for logEOverNReIdeal=-1:3
        cond=cond+1;
        set.logEOverNReIdeal=logEOverNReIdeal;  
        logE=mean(logE1)+2*log10(signalContrast);
        logN=logE-(logEOverNReIdeal+logEstimatedEOverNIdealThreshold);
        set.logEOverN=logE-logN;
        noiseContrast=sqrt((10^logN)*(pixPerDeg)^2);
        set.noiseContrast=noiseContrast;
        set.signalContrast=signalContrast;
        set.background=background;
%         fprintf('Set %d. logEOverNReIdeal %5.2f, logEOverN %5.2f, signalContrast %.2f, noiseContrast %.3f\n', background %.0f, cond, logEOverNReIdeal, logE-logN, signalContrast,noiseContrast);
        set.signal=signal;
        set.signalBounds=signalBounds;
        for s=1:length(signal(:))
            set.signal(s).image=signalContrast*set.signal(s).image;
        end
        for i=1:setSize
            noise=RandSample(n.noiseList,n.noiseSize);
            %                 noise=Magnify2DMatrix(noise,checkPix);
            noiseImage=noiseContrast*noise;
            if overflowCheck
                fprintf('noise mean %.1f, sd %.1f, min %.1f, max %.1f\n',mean(noiseImage(:)),std(noiseImage(:)),min(noiseImage(:)),max(noiseImage(:)));
            end
            whichSignal=randi(shapes);
            whichOrientation=randi(length(orientations));
            whichX=randi(length(xs));
            whichY=randi(length(ys));
            s=set.signal(whichSignal,whichOrientation,whichX,whichY).image;
            set.stimulus(i).image=set.background+noiseImage+s;
            set.stimulus(i).whichSignal=whichSignal;
            set.stimulus(i).text=textSignals(whichSignal);
            set.stimulus(i).orientation=orientations(whichOrientation); 
            set.stimulus(i).whichOrientation=whichOrientation;
            set.stimulus(i).x=xs(whichX);
            set.stimulus(i).whichX=whichX;
            set.stimulus(i).y=ys(whichY);
            set.stimulus(i).whichY=whichY;
        end
%         fprintf('%d ',cond);
        set.fontSize=fontSize;
        set.textFont=textFont;
        set.bold=bold;
        set.orientations=orientations;
        set.xs=xs;
        set.ys=ys;
        set.shapes=shapes;
        
        % Test ideal classifier
        correctLetter=0;
        correctOrientation=0;
        correctXY=0;
        correctSignal=0;
        trials=0;
        clear err
        for s=set.stimulus
            for i=1:length(set.signal(:))
                err(i)=sum(sum((s.image-set.background-set.signal(i).image).^2));
            end
            [junk,i]=min(err);
            [i,io,ix,iy]=ind2sub(size(set.signal),i);
            if i==s.whichSignal
                correctLetter=correctLetter+1;
            end
            if io==s.whichOrientation
                correctOrientation=correctOrientation+1;
            end
            if ix==s.whichX && iy==s.whichY
                correctXY=correctXY+1;
            end
            %            fprintf('signal(%d,%d,%d,%d) classified as %d,%d,%d,%d\n',s.whichSignal,s.whichOrientation,whichX,whichY,i,io,ix,iy);
            trials=trials+1;
        end
        set.idealProportionCorrect=correctLetter/trials;
        fprintf('Set %d. logEOverNReIdeal %5.2f, logEOverN %5.2f, signalContrast %.2f, noiseContrast %.3f, correctLetter %.3f, correctOrientation %.3f, correctXY %.3f\n', ...
            cond, set.logEOverNReIdeal, set.logEOverN, set.signalContrast,set.noiseContrast,set.idealProportionCorrect,correctOrientation/trials,correctXY/trials);
 
        filename=sprintf('%s%do%dx%dy%02.0fSNR',set.textFont,length(orientations),length(xs),length(ys),10*set.logEOverN);
        filename=strrep(filename,' ','-');

        % Show the stimulus, signal, and stimulus minus signal, which
        % should be just noise. One for each set. The SUBPLOT command is
        % fragile. If the images won't fit, the SUBPLOT routines fails with
        % a mysterious error. Use the mouse to enlarge the Figure window
        % and try again.
        figure(1);
        fig=1+3*(cond-1);
        rows=5;
        snImage=set.stimulus(1).image;
        subplot(rows,3,fig,'align'); imshow(snImage,[-1 1]); xlabel(filename);
        which=set.stimulus(1).whichSignal;
        whichOrientation=set.stimulus(1).whichOrientation;
        whichX=set.stimulus(1).whichX;
        whichY=set.stimulus(1).whichY;
        sImage=set.signal(which,whichOrientation,whichX,whichY).image;
        subplot(rows,3,fig+1,'align'); imshow(sImage,[-1 1]);
        nImage=snImage-sImage;
        subplot(rows,3,fig+2,'align'); imshow(nImage,[-1 1]);
        energy=sum(sum((sImage-1).^2));
        noiseLevel=var(nImage(:));
%         fprintf('cond %d, log E/N nominal %.2f, actual %.2f\n',cond,set.logEOverN,log10(energy/noiseLevel));
        
        % Save to disk in block format for Olivier.
        targetMatrix=zeros(size(set.stimulus(1).image,1),size(set.stimulus(1).image,2),length(set.stimulus));
        for i=1:length(set.stimulus)
            targetMatrix(:,:,i)=set.stimulus(i).image;
            labels(i)=set.stimulus(i).whichSignal;
        end
        idealProportionCorrect=set.idealProportionCorrect;
        signalMatrix=zeros(imageWidth,imageHeight,size(signal,1),size(signal,2),size(signal,3),size(signal,4));
        for i=1:size(signal,1)
            for io=1:size(signal,2)
                for ix=1:size(signal,3)
                    for iy=1:size(signal,4)
                        signalMatrix(:,:,i,io)=signal(i,io,ix,iy).image;
                    end
                end
            end
        end
        readme=sprintf([...
            'MATLAB save file "%s.mat" \n' ...
            'has %d target images at SNR log E/N %.2f,\n'...
            '%d possible letters, %s font, size %d, %d orientations, %d xs, %d ys\n'...
            'signalContrast %.3f, noiseContrast %.3f, background %.1f \n'...
            'The optimal classifier correctly identifies %.3f of these targets.\n'...
             'The file contains several arrays and a text string:\n\n' ...
            '"readme" contains this explanatory text.\n' ...
            '"signalMatrix" is a %dx%dx%dx%dx%dx%d matrix, the indices (x,y,i,io,ix,iy) represent\n'...
            '     horizontal, vertical, which letter, which orientation, which x offset, which y offset.\n' ...
            '"targetMatrix" is a %dx%dx%d matrix containing %d %dx%d images to be classified.\n' ...
            '     Each target image is a signal plus noise.\n' ...
            '"labels" contains the letter index (1 to %d) for each target. \n' ...
            '     This is the correct classification to be learned or tested.\n'...
            '"idealProportionCorrect" is the performance %.3f of the ideal classifier on these targets.\n'...
            '"signalBounds" is a rect, a 4-element array [xmin,ymin,xmax,ymax]=[%d,%d,%d,%d], indicating\n' ...
            '     the zero-based min and max of the x and y coordinates of letter\n'...
            '     ink among all the signal images.\n' ...
            '"signal" is a %dx%dx%dx%d-element struct array, with one struct per letter and condition. The struct \n' ...
            '     includes the name ("string") and "image".\n' ...
            '\nNote that the optimal classifier''s threshold is roughly 1.0 log E/N, \n' ...
            'and the human threshold is roughly 2.0 log E/N.\n'...
            ],filename,length(set.stimulus),set.logEOverN,...
            length(signal),set.textFont,set.fontSize,length(set.orientations),length(set.xs),length(set.ys),...
            set.signalContrast,set.noiseContrast,set.background,set.idealProportionCorrect,...
            size(signalMatrix,1),size(signalMatrix,2),size(signalMatrix,3),size(signalMatrix,4),size(signalMatrix,5),size(signalMatrix,6),...
            size(targetMatrix),size(targetMatrix,3),size(targetMatrix,1),size(targetMatrix,2), ...
            size(signal,1),...
            idealProportionCorrect,...
            signalBounds,...
            size(signal,1),size(signal,2),size(signal,3),size(signal,4));
        save(filename,'readme','signalMatrix','targetMatrix','labels','idealProportionCorrect','signalBounds','signal');
        clear targetMatrix
    end
    fprintf('%s',readme);  
    fprintf('Done.\n');
catch
%     ListenChar;
    Screen('CloseAll');
    ShowCursor;
    if window>=0
        Screen('Preference','VisualDebugLevel', oldVisualDebugLevel);
        Screen('Preference','SuppressAllWarnings', oldSupressAllWarnings);
    end
    psychrethrow(psychlasterror);
end

