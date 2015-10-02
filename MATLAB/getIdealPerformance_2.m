function idealP = getIdealPerformance(fontName)

%     allFontNames = {'Braille', 'Sloan', 'Helvetica', 'Georgia', 'Yung', 'Kuenstler'};

    redo = 1;
    idealPerformanceFile = [lettersPath 'idealPerformance.mat'];
    if ~exist(idealPerformanceFile, 'file') || redo
        S_ideal = getIdealPerformanceForFonts;
        save(idealPerformanceFile, '-struct', 'S_ideal')
    else
        S_ideal = load(idealPerformanceFile);
    end

    idealP = S_ideal.(fontName);
    




end


function S = getIdealPerformanceForFonts
    simple = 1;
    if simple
        nOris = 1; nXs = 1; nYs = 1;
    end

    noisyLettersPath = [lettersPath 'NoisyLetters' filesep];
    fontNames = subdirs(noisyLettersPath);
    
%     allfiles = dir([noisyLettersPath '*.mat']);
%     fontNames = unique( arrayfun(@(f) strtok(f.name, '-'), allfiles, 'un', 0) );
    
    logSNRs = [0:4];
    for fi = 1:length(fontNames)
        S.(fontNames{fi}).SNRs = logSNRs;
        for snr_i = 1:length(logSNRs)
            filename=sprintf('%s-%dori%dx%dy-%02.0fSNR.mat',fontNames{fi},nOris, nXs, nYs,logSNRs(snr_i)*10);
            S_noisy = load([lettersPath 'NoisyLetters' filesep filename]);
            
            S.(fontNames{fi}).pctCorr(snr_i) = S_noisy.idealProportionCorrect * 100;
            3;
        end
        S.(fontNames{fi}).complexity_bool = S_noisy.complexity_bool_mean;
        S.(fontNames{fi}).complexity_grey = S_noisy.complexity_grey_mean;
    end
    3;


end

function sub_folder_names = subdirs(fldr)
    s = dir(fldr);
    s = s([s.isdir]);
    sub_folder_names = {s.name};
    sub_folder_names = sub_folder_names([~strcmp(sub_folder_names, '.') & ~strcmp(sub_folder_names, '..')]);

end