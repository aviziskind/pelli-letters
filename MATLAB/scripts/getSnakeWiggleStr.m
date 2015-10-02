function [str, str_nice, nWigglesTot] = getSnakeWiggleStr( wiggleSettings )
    
    haveNoWiggle = isfield(wiggleSettings, 'none');

    haveOriWiggle = isfield(wiggleSettings, 'orientation');
    if haveOriWiggle && any(wiggleSettings.orientation == 0)
        wiggleSettings.orientation = nonzeros(wiggleSettings.orientation);
        haveNoWiggle = true;
        haveOriWiggle = ~isempty(wiggleSettings.orientation);
    end
    
    haveOffsetWiggle = isfield(wiggleSettings, 'offset');
    if haveOffsetWiggle && any(wiggleSettings.offset == 0);
        wiggleSettings.offset = nonzeros(wiggleSettings.offset);
        haveNoWiggle = true;
        haveOffsetWiggle = ~isempty(wiggleSettings.offset);
    end

    
    havePhaseWiggle = isfield(wiggleSettings, 'phase');
    if havePhaseWiggle && any(wiggleSettings.phase == 0)
        wiggleSettings.phase = nonzeros(wiggleSettings.phase);
        haveNoWiggle = true;
        havePhaseWiggle = ~isempty(wiggleSettings.phase);
    end
    
%     sep = '_';
    sep = '';
    sep_nice = '; ';
    
    str = '';
    str_nice = '';
    nWigglesTot = 0;

    if haveNoWiggle
        noWiggleStr = 'N';
        noWiggleStr_nice = 'No Wiggle';
        
        str = appendToStr(str, noWiggleStr, sep);
        str_nice = appendToStr(str_nice, noWiggleStr_nice, sep_nice);
        nWigglesTot = nWigglesTot + 1;
    end
    
    
    if haveOriWiggle
        oriAnglesStr = sprintf('Or%s', toOrderedList(wiggleSettings.orientation));
        
        str = appendToStr(str, oriAnglesStr, sep);
        str_nice = appendToStr(str_nice, oriAnglesStr, sep_nice);
        nWigglesTot = nWigglesTot + length(wiggleSettings.orientation);
    end

    if haveOffsetWiggle
        offsetAnglesStr = sprintf('Of%s', toOrderedList(wiggleSettings.offset));
        
        str = appendToStr(str, offsetAnglesStr, sep);
        str_nice = appendToStr(str_nice, offsetAnglesStr, sep_nice);
        
        nWigglesTot = nWigglesTot + length(wiggleSettings.offset);
    end
    
    if havePhaseWiggle
        phaseAnglesStr = 'Ph';
        
        str = appendToStr(str, phaseAnglesStr, sep);
        str_nice = appendToStr(str_nice, phaseAnglesStr, sep_nice);
        
        nWigglesTot = nWigglesTot + 1;
    end
    

end


%{

function s = getSnakeWiggleStr( wiggleSettings )
    if length(wiggleSettings) > 1
        allWiggleTypes = {wiggleSettings.type};
        ori_idx = find(strcmp(allWiggleTypes, 'orientation'));
        offset_idx = find(strcmp(allWiggleTypes, 'offset'));
        phase_idx = find(strcmp(allWiggleTypes, 'phase'));
        
        s = '';
        if ~isempty(ori_idx)
            s = appendToStr(s, getSnakeWiggleStr( struct('type', 'orientation',  unique( [wiggleSettings(ori_idx).angle])  )), '_');
        end
        if ~isempty(offset_idx)
            s = appendToStr(s, getSnakeWiggleStr( struct('type', 'offset',  unique( [wiggleSettings(offset_idx).angle])  )), '_');
        end
        if ~isempty(phase_idx)
            s = appendToStr(s, getSnakeWiggleStr( struct('type', 'offset',  1, '_') ) );
        end
        return
        
    end
    
%     if isstruct(wiggleType) && nargin == 1
        wiggleAngle = wiggleSettings.angle;
        wiggleType = wiggleSettings.type;
%     end
    
    if strcmp(wiggleType, 'none')
        wiggleAngle = 0;
    end    

    if wiggleAngle == 0
        s = '';
        return
    end
    
    wiggleAngle_str = toOrderedList(wiggleAngle, []);
    
    switch wiggleType
        case 'orientation', s = sprintf('Or%s', wiggleAngle_str); 
        case 'offset', s = sprintf('Of%s', wiggleAngle_str); 
        case 'phase', s = sprintf('Ph'); 
    end

end
%}