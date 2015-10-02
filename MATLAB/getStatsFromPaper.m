function stat = getStatsFromPaper(fontName, fldName)

    persistent allStats
    
    if isempty(allStats)
        allStats.Bookman     = struct('complexity', 107, 'efficiency', .090, 'overlap', 0.34, 'th_ideal', -2.60, 'th_human', -1.55, 'nObservers', 19);
        allStats.BookmanU    = struct('complexity', 139, 'efficiency', .090, 'overlap', 0.36, 'th_ideal', -2.63, 'th_human', -1.58, 'nObservers', 2);
        allStats.BookmanB    = struct('complexity',  57, 'efficiency', .155, 'overlap', 0.53, 'th_ideal', -2.44, 'th_human', -1.63, 'nObservers', 3);
        allStats.Courier     = struct('complexity', 100, 'efficiency', .112, 'overlap', 0.45, 'th_ideal', -2.56, 'th_human', -1.61, 'nObservers', 3);
        allStats.Helvetica   = struct('complexity',  67, 'efficiency', .142, 'overlap', 0.41, 'th_ideal', -2.45, 'th_human', -1.60, 'nObservers', 4);
        allStats.KuenstlerU  = struct('complexity', 451, 'efficiency', .025, 'overlap', 0.22, 'th_ideal', -2.73, 'th_human', -1.12, 'nObservers', 2);
        allStats.Sloan       = struct('complexity',  65, 'efficiency', .108, 'overlap', 0.58, 'th_ideal', -2.59, 'th_human', -1.62, 'nObservers', 5);

        allStats.Arabic      = struct('complexity', 137, 'efficiency', .061, 'overlap', 0.21, 'th_ideal', -2.50, 'th_human', -1.28, 'nObservers', 2);
        allStats.Armenian    = struct('complexity', 106, 'efficiency', .094, 'overlap', 0.33, 'th_ideal', -2.54, 'th_human', -1.51, 'nObservers', 1);
        allStats.Yung        = struct('complexity', 199, 'efficiency', .051, 'overlap', 0.32, 'th_ideal', -2.67, 'th_human', -1.38, 'nObservers', 2);
        allStats.Devanagari  = struct('complexity',  99, 'efficiency', .097, 'overlap', 0.61, 'th_ideal', -2.34, 'th_human', -1.32, 'nObservers', 2);
        allStats.Hebraica    = struct('complexity',  90, 'efficiency', .106, 'overlap', 0.48, 'th_ideal', -2.51, 'th_human', -1.53, 'nObservers', 2);

        allStats.Braille     = struct('complexity',  28, 'efficiency', .308, 'overlap', 0.55, 'th_ideal', -2.34, 'th_human', -1.83, 'nObservers', 2);
        allStats.Checkers4x4 = struct('complexity',  52, 'efficiency', .066, 'overlap', 0.48, 'th_ideal', -2.50, 'th_human', -1.32, 'nObservers', 2);

        allStats.words3       = struct('complexity', 304, 'efficiency', .033, 'overlap', 0.34, 'th_ideal', -2.64, 'th_human', -1.16, 'nObservers', 4);
        allStats.words5       = struct('complexity', 481, 'efficiency', .022, 'overlap', 0.32, 'th_ideal', -2.62, 'th_human', -0.97, 'nObservers', 3);
        allStats.words5_many  = struct('complexity', 499, 'efficiency', .034, 'overlap', 0.32, 'th_ideal', -2.28, 'th_human', -0.81, 'nObservers', 2);
    end

    allFonts = fieldnames(allStats);
    for i = 1:length(allFonts)
        stat_i = allStats.(allFonts{i});
        n_denom = max(1, stat_i.nObservers-1);
        allStats.(allFonts{i}).efficiency_stderr_est = (2*stat_i.efficiency/10)/sqrt(n_denom);
    end
    
    
    stat = allStats;
    if nargin < 1 || isempty(fontName)
        return;
    end
    
    if ~isfield(allStats, fontName)
        error('Unknown font : %s', fontName)
    end
    
    stat = allStats.(fontName);
    if nargin < 2  || isempty(fldName)
        return;
    end
    
    
    if ~isfield(allStats.(fontName), fldName)
        error('Unknown field : %s', fldName);
    end
    
    stat = stat.(fldName);
    
end



%{
    humanThreshold_E = struct(...
        'Bookman',      -1.55,  ... 
        'BookmanUpper', -1.58,  ...
        'BookmanBold',  -1.63,  ...
        'Courier',      -1.61,  ...
        'Helvetica',    -1.60,  ...
        'Kuenstler',    -1.12,  ...
        'Sloan',        -1.62,  ...
        'Arabic',       -1.28,  ...
        'Armenian',    -1.51,  ...
        'Yung',        -1.38,  ...  % Chinese
        'Devanagari',  -1.32,  ...
        'Hebraica',    -1.53,  ... % Hebrew
        'Braille',     -1.83,  ... % 2x3 Checkers
        'Checkers4x4', -1.32,  ...
        'ThreeLetterWords', -1.16,   ...
        'FiveLetterWords',  -0.97  ...
        );

   idealThreshold_E = struct(...
        'Bookman',      -2.60,  ... 
        'BookmanUpper', -2.63,  ...
        'BookmanBold',  -2.44,  ...
        'Courier',      -2.56,  ...
        'Helvetica',    -2.45,  ...
        'Kuenstler',    -2.73,  ...
        'Sloan',        -2.59,  ...
        'Arabic',       -2.50,  ...
        'Armenian',    -2.54,  ...
        'Yung',        -2.67,  ...  % Chinese
        'Devanagari',  -2.34,  ...
        'Hebraica',    -2.51,  ... % Hebrew
        'Braille',     -2.34,  ... % 2x3 Checkers
        'Checkers4x4', -2.50,  ...
        'ThreeLetterWords', -2.64,   ...
        'FiveLetterWords',  -2.62  ...
        );
%}