function [metStr, metStr_nice] = getMetamerLetterOptsStr(metamerFileParams, niceStrFields)
    makeNiceStr = nargin > 1 && ~isempty(niceStrFields);
    metStr_nice = '';
    
    imageSize = metamerFileParams.imageSize;
    nIter = metamerFileParams.nIter;
    Nscl = metamerFileParams.Nscl;
    Nori = metamerFileParams.Nori;
    Na = metamerFileParams.Na;
    
    test_str = iff(isfield(metamerFileParams, 'tf_test') && isequal(metamerFileParams.tf_test, 1), '_test', '');

    metStr = sprintf('%dx%d_it%d-%dscl-%dori-%da%s', imageSize,imageSize, nIter, Nscl, Nori, Na, test_str);

end