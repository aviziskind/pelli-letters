function h = rectanglePix(pos, varargin)
    h = annotation('rectangle', [.1, .1, .1 .1], 'units', 'pixels', 'position', pos, varargin{:});
end