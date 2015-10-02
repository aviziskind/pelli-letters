function h = ellipsePix(pos, varargin)
    h = annotation('ellipse', [.1, .1, .2 .2], 'units', 'pixels', 'position', pos, varargin{:});
end