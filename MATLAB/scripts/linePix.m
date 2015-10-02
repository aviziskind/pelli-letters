function h = linePix(x, y, varargin)
    h = annotation('line', [0, 1], [0, 1], 'units', 'pixels', 'x', x, 'y', y, varargin{:});
end