function [noiseFilter_str, noiseFilter_str_nice] = noiseFilterOptStr(letterOpts, niceStrFields)
    makeNiceStr = ~isempty(niceStrFields);
    noiseFilter_str_nice = '';
    
    useNoiseFilter = isfield(letterOpts, 'noiseFilter') && ~isempty(letterOpts.noiseFilter);
    noiseFilter_str = '';
    
    if useNoiseFilter
        
        [testFilt_str, testFilt_str_nice] = getFilterStr(letterOpts.noiseFilter);
        % a) define training noise string
        
                
        % final test noise filter:
        noiseFilter_str = ['_' testFilt_str];
        if length(noiseFilter_str) == 1
            noiseFilter_str = '';
        end
        
        if makeNiceStr && (any(strcmpi(niceStrFields, 'testNoise') | strcmpi(niceStrFields, 'noiseFilter')))
            % define nice training noise string: (even if filter = 'same', still display what kind of filter it is ):
                        
            noiseFilter_str_nice = sprintf('Noise: %s. ', testFilt_str_nice);

        end
        
        
        
    end
    
end
    
    
    
    %{
    
    function [noiseFilter_str, noiseFilter_str_nice] = noiseFilterOptStr(letterOpts, niceStrFields)
    makeNiceStr = ~isempty(niceStrFields);
    noiseFilter_str_nice = '';
    
    useNoiseFilter = isfield(letterOpts, 'noiseFilter') && ~isempty(letterOpts.noiseFilter);
    noiseFilter_str = '';
    
    if useNoiseFilter
        
        [testFilt_str, testFilt_str_nice] = getFilterStr(letterOpts.noiseFilter);
                % a) define training noise string
        % get the training noise string -- only write explicitly if training noise different
        % from testing noise.
        
        trainNoise_str = '';
        doExplicitTrainNoise = isfield(letterOpts, 'trainingNoise') && ~strcmpi(letterOpts.trainingNoise, 'same') && ~isequal(letterOpts.noiseFilter, letterOpts.trainingNoise);
        if doExplicitTrainNoise
            [trainFilt_str, trainFilt_str_nice] = getFilterStr(letterOpts.trainingNoise, 1);
            trainNoise_str = ['_tr' trainFilt_str];
                        
        end
                
        % final test noise filter:
        noiseFilter_str = ['_' testFilt_str trainNoise_str];
        if length(noiseFilter_str) == 1
            noiseFilter_str = '';
        end
        
        if makeNiceStr 
            % define nice training noise string: (even if filter = 'same', still display what kind of filter it is ):
            if any(strcmpi(niceStrFields, 'TrainNoise'))
                if strcmpi(letterOpts.trainingNoise, 'same')
                    trainingNoise_str_nice = 'Trained on same noise; ';
                elseif isfield(letterOpts, 'trainingNoise') 
                    [~, trainFilt_str_nice] = getFilterStr(letterOpts.trainingNoise, 1);
                    trainingNoise_str_nice = sprintf('Trained on %s', trainFilt_str_nice);
                else
                    error('check!');
%                     [~, trainFilt_str_nice] = getFilterStr(letterOpts.noiseFilter, 1);
%                     trainingNoise_str_nice = sprintf('Trained on %s', trainFilt_str_nice);
                end
                noiseFilter_str_nice = [noiseFilter_str_nice trainingNoise_str_nice];
            end
        
            if any(strcmpi(niceStrFields, 'testNoise') | strcmpi(niceStrFields, 'noiseFilter'))
                testNoiseFilter_str_nice = sprintf('Test: %s. ', testFilt_str_nice);
                noiseFilter_str_nice = [noiseFilter_str_nice testNoiseFilter_str_nice];
            end
        end
        
        
    end
    %}