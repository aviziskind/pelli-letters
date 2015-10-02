function [oxy_str, oxy_str_nice] = getOriXYStr(varargin)
    skipDx = 0;
    if nargin == 3
        [oris, xs, ys] = varargin{:};
    elseif iscell(varargin{1})
        [oris, xs, ys] = varargin{1}{:};
    elseif isstruct(varargin{1}) && isfield(varargin{1}, 'oris')
        [oris, xs, ys] = deal(varargin{1}.oris, varargin{1}.xs, varargin{1}.ys);
        skipDx = (nargin == 2) && isequal(varargin{2}, 1);
    else
        oxy_str = ''; oxy_str_nice = ''; 
        return;
    end
        
%     skipDx_nice = skipDx;
    skipDx_nice = 0;

    doNiceStr = nargout > 1;
    
    nOri = length(oris);
    nX = length(xs);
    nY = length(ys);
    
    variableNori = length(oris) == 1 && oris(1) < 0; fixedNori = ~variableNori;
    variableNx = length(xs) == 1 && xs(1) < 0; fixedNx = ~variableNx;
    variableNy = length(ys) == 1 && ys(1) < 0; fixedNy = ~variableNy;

    assert(fixedNori);
    if (nOri == 1 && nX == 1 && nY == 1) && (fixedNx && fixedNy)
        oxy_str = '1oxy';
        
        % oxy_str_nice = 'No uncertainty; ';
        oxy_str_nice = '1 position';
    else
    
        if skipDx
            getLimitsStr_func = @(x) '';
        else
            getLimitsStr_func = @(x) getLimitsStr(x);
        end
        
        if skipDx_nice
            getLimitsStr_func_nice = @(x) '';
        else
            getLimitsStr_func_nice = @(x) getLimitsStr(x);
        end
            
        
        [ori_str, x_str, y_str] = deal('');
        if doNiceStr
            [ori_str_nice, x_str_nice, y_str_nice] = deal('');
        end

        
        % orientations
        if nOri > 1
            ori_str = sprintf('%dori%s_', nOri, getLimitsStr_func(oris));
            if doNiceStr
                ori_str_nice = sprintf('%doris%s, ', nOri, getLimitsStr_func_nice(oris));
            end
        end

        % x positions
        if fixedNx
            if nX > 1 
                x_str = sprintf('%dx%s_', nX, getLimitsStr_func(xs));
                if doNiceStr
                    x_str_nice = sprintf('%dx%s, ', nX, getLimitsStr_func_nice(xs));
                end
            end
        else
            xs_sample = [0, abs(xs)];
            x_str = sprintf('Ax%s_', getLimitsStr_func(xs_sample));
            if doNiceStr
                x_str_nice = sprintf('%All X%s, ', nX, getLimitsStr_func_nice(xs_sample));
            end
        end
            
        % y positions
        if fixedNy
            if nY > 1
                y_str = sprintf('%dy%s_', nY, getLimitsStr_func(ys));
                if doNiceStr
                    y_str_nice = sprintf('%dy%s, ', nY, getLimitsStr_func_nice(ys));
                end
            end
        else
            ys_sample = [0, abs(ys)];
            y_str = sprintf('Ay%s_', getLimitsStr_func(ys_sample));
            if doNiceStr
                y_str_nice = sprintf('%All Y%s, ', nY, getLimitsStr_func_nice(ys_sample));
            end
            
        end

        oxy_str = sprintf('%s%s%s',  ori_str, x_str, y_str);
        oxy_str = oxy_str(1:end-1); % remove trailing '_'

        if doNiceStr
            oxy_str_nice = [ori_str_nice, x_str_nice, y_str_nice];
            if ~isempty(oxy_str_nice)
                oxy_str_nice = oxy_str_nice(1:end-2);  % remove trailing ', '
            end

        end
    end
    
end

