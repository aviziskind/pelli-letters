function humanP = getHumanPerformance(fontName, toReturn)

    if nargin < 2
        toReturn = 'efficiency';
    end
    
    if ~isfield(humanThreshold_E, fontName)
        c = getFontComplexity(fontName);
        humanP = 91 / c;
        return;
    end
    
    stats = getStatsFromPaper(fontName);
    human_th = stats.th_human;
    ideal_th = stats.th_ideal;
    eff_calc = 10^(ideal_th - human_th);
    eff = stats.efficiency;
    
    assert(abs(eff_calc - eff) < 1e-5);

    switch toReturn
        case 'efficiency', humanP = eff;
        case 'threshold', humanP = human_th;
            
    end
    
    
end

