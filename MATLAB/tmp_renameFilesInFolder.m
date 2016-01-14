function tmp_renameFilesInFolder(baseFolder)
    if nargin < 1
    %     baseFolder = [torchPath 'Results' filesep 'CrowdedLetters' filesep];
    %     baseFolder = [torchPath 'Results' filesep 'TrainingWithNoise' filesep];
    %     baseFolder = [torchPath 'TrainedNetworks' filesep 'TrainingWithNoise' filesep];
    %     baseFolder = [torchPath 'Results' filesep 'MetamerLetters' filesep];
%         baseFolder = ['D:\Users\Avi\Code\MATLAB\nyu\letters\fonts\fonts_from_word\GeorgiaU\'];
%         baseFolder = [lettersPath 'NoisyLetters\Kuenstler\'];
%         baseFolder = [torchPath];
%         baseFolder = [lettersPath 'fonts' filesep];
%         baseFolder = [lettersPath];
        baseFolder = [codePath 'nyu' fsep 'letters' fsep 'data' fsep 'Results' fsep 'Complexity_NYU' fsep 'NoisyLetters' fsep] ;
        
        if ~onLaptop
%             baseFolder = ['/misc/vlgscratch2/LecunGroup/ziskind/lettersData/'];
            baseFolder = ['~/lettersData/Results/Complexity_NYU/NoisyLetters/'];
        end

%         baseFolder = 'D:\Users\Avi\Code\MATLAB\nyu\letters\datasets\NoisyLettersStats\Bookman\~reduced\';
        
    end
    fprintf('Searching in %s ... \n', baseFolder);

%     global fid
    
    recurseSubfolders = 1;
        skipOldFolders = 1;
    
    s1 = dir([baseFolder '*.mat']);
    s2 = dir([baseFolder '*.t7']);
    s3 = dir([baseFolder '*.csv']);
    s4 = dir([baseFolder '*.png']);

%     s1 = dir([baseFolder '*.mat']);

    status = 0;
    s = [s1; s2; s3; s4];
    
    if ispc
        rename_cmd = 'rename';
        destFolder_str = '';
    else
        rename_cmd = 'mv';
        destFolder_str = baseFolder;
    end
    for i = 1:length(s)
        name_i = s(i).name;
%         p_i = strfind(name_i, '_nopool'); f_i = strfind(name_i, '_fs');
%         if ~isempty(p_i) && ~isempty(f_i) && p_i < f_i
%         if ~isempty(strfind(name_i, '_nopool'))  && isempty(strfind(name_i, '_fs'))
%             new_name_i = strrep(name_i, '_Conv', '__Conv');
%         if ~isempty(strfind(name_i, '2x[21]_1y'))  || isempty(strfind(name_i, '2x[21]_1y_c1'))  
%             new_name_i = switchPoolFsOrder(name_i);
%         if ~isempty(strfind(name_i, 'metamers'))
%         if ~isempty(strfind(name_i, 'Kuenstler')) || ~isempty(strfind(name_i, 'KuenstlerU'))
%         if ~isempty(strfind(name_i, 'k18')) && ~isempty(strfind(name_i, '_tw'))
%         if ~isempty(strfind(name_i, 'Conv_')) && isempty(strfind(name_i, 'F')) 
%             fprintf('%s\n', name_i)
%             3;
%         end
%         if ~isempty(strfind(name_i, 'Conv_3_8_60_')) 
%         if ~isempty(strfind(name_i, 'Complexity_'))
%         if ~isempty(strfind(name_i, 'NoisyTextureStats')) 
%         if ~isempty(strfind(name_i, 'BookmanBold')) 

%         if ~isempty(strfind(name_i, 'SNR-')) 

%         if ~isempty(strfind(name_i, 'CrowdedLetters')) && isempty(regexp(name_i, 'N\d_K\d_M\d', 'once'))
%         if ~isempty(strfind(name_i, 'scl'))
%         if ~isempty(strfind(name_i, 'Snakes')) && (~isempty(strfind(name_i, '-32')) || ~isempty(strfind(name_i, '_32-')) )
%         if ~isempty(strfind(name_i, '__trN')) 
        if ~isempty(strfind(name_i, '[64x64]_trfSVHN_rt')) || ~isempty(strfind(name_i, '[80x80]_trfSVHN_rt'))

            
            
            name_i_orig = name_i;
%             new_name_i = name_i_orig;
            
            new_name_i = name_i_orig;
            new_name_i = strrep(new_name_i, '[64x64]_trfSVHN_rt', '[64x64]_tr32x32_trfSVHN_rt');
            new_name_i = strrep(new_name_i, '[80x80]_trfSVHN_rt', '[80x80]_tr32x32_trfSVHN_rt');

%             new_name_i = strrep(new_name_i, '__trN', '_trN');
%             new_name_i = strrep(new_name_i, '-32_', '-k32_');
%             new_name_i = strrep(new_name_i, '_32-', '_k32-');

%             new_name_i = strrep(new_name_i, 'SnakesN', 'Snakes_N');
%             new_name_i = strrep(new_name_i, 'SnakesOr', 'Snakes_Or');
%             new_name_i = strrep(new_name_i, 'SnakesOf', 'Snakes_Of');

%             new_name_i = name_i;
%             new_name_i = strrep(name_i, 'GPU128', 'GPU');
%             new_name_i = strrep(name_i, 'SNR-', 'SNRn');
%             new_name_i = strrep(new_name_i, '1scl', 'N1');
%             new_name_i = strrep(new_name_i, '2scl', 'N2');
%             new_name_i = strrep(new_name_i, '3scl', 'N3');
%             new_name_i = strrep(new_name_i, '4scl', 'N4');
% %             
%             new_name_i = strrep(new_name_i, '3a', 'M3');
%             new_name_i = strrep(new_name_i, '4a', 'M4');
%             new_name_i = strrep(new_name_i, '5a', 'M5');
%             new_name_i = strrep(new_name_i, '7a', 'M7');
%             new_name_i = strrep(new_name_i, '9a', 'M9');
% 
%             new_name_i = strrep(new_name_i, '-2ori-', '_K2_');
%             new_name_i = strrep(new_name_i, '-3ori-', '_K3_');
%             new_name_i = strrep(new_name_i, '-4ori-', '_K4_');
% 
%             new_name_i = strrep(new_name_i, '-2ori_', '_K2_');
%             new_name_i = strrep(new_name_i, '-3ori_', '_K3_');
%             new_name_i = strrep(new_name_i, '-4ori_', '_K4_');
% 
%             new_name_i = strrep(new_name_i, '_2ori_', '_K2_');
%             new_name_i = strrep(new_name_i, '_3ori_', '_K3_');
%             new_name_i = strrep(new_name_i, '_4ori_', '_K4_');
%             
% 
%             assert(isempty(strfind(new_name_i, 'scl')))
%             assert(isempty(strfind(new_name_i, 'ori')))
%             assert(isempty(strfind(new_name_i, 'a_')))
            
            3;
            %%
%             new_name_i = tmp_reorderResultsFilenameStructure(name_i_orig);

            
%             new_name_i = strrep(new_name_i, 'SNR0_1_2__',       'SNR0t2__');
%             new_name_i = strrep(new_name_i, 'SNR0_1_2_3_4__',   'SNR0t4__');
%             new_name_i = strrep(new_name_i, 'SNR2_3_4__',       'SNR2t4__');
%             new_name_i = strrep(new_name_i, 'SNR2_3_4_5__', 'SNR2t5__');
%             new_name_i = strrep(new_name_i, '_SNR00', '');
%             new_name_i = strrep(new_name_i, '--', '-n');
%             new_name_i = strrep(new_name_i, 'Conv_12_240__', 'Conv_12_F240__');
%             new_name_i = strrep(new_name_i, 'Conv_12_240_n', 'Conv_12_F240_n');
%             new_name_i = strrep(new_name_i, 'Conv_12_240_p', 'Conv_12_F240_p');
%             new_name_i = strrep(new_name_i, 'Complexity_', 'NoisyLetters_');
%             new_name_i = strrep(new_name_i, 'NoisyTextureStats', 'NoisyLetterTextureStats');
%             new_name_i = strrep(new_name_i, 'BookmanBoldU', 'BookmanUB');
%             new_name_i = strrep(new_name_i, 'BookmanBold', 'BookmanB');


             if ~strcmp(new_name_i, name_i_orig)
%             new_name_i = strrep(new_name_i, 'Bold', 'B');
%                 disp(['  ' name_i_orig]);
                disp(['       ' new_name_i]);
%                 if ~isempty(fid)
%                     fprintf(fid, '%s\n', new_name_i);
%                 end
%                 disp('-----------');
                addQuotes = ispc;
                if addQuotes
                    cmd_str = sprintf('%s "%s%s" "%s%s"', rename_cmd, baseFolder, name_i_orig, destFolder_str, new_name_i);
                else
                    cmd_str = sprintf('%s %s%s %s%s',     rename_cmd, baseFolder, name_i_orig, destFolder_str, new_name_i);
                end
                [status, output] = system(cmd_str); 
                if status ~= 0
                    display(cmd_str)
                    error(output);
                end
                3;
            end
        end       
        
    end

    if recurseSubfolders
        s_sub = subfolders(baseFolder);
        for si = 1:length(s_sub)
            if skipOldFolders && ~isempty(strfind(s_sub{si}, 'old'))
                continue
            end
            tmp_renameFilesInFolder([baseFolder s_sub{si} filesep]);
        end
        
    end

    
%     fclose(fid);
end


function str_new = switchPoolFsOrder(str)
us_i = strfind(str, '_');
nopool_i = strfind(str, 'nopool');
firstUafterpool = us_i (find(us_i > nopool_i,1));

fs_i = strfind(str, 'fs');
firstUafterFs = us_i (find(us_i > fs_i,1));
%%
% str(nopool_i : firstUafterpool)
% str(fs_i: firstUafterFs)

assert(firstUafterpool+1 == fs_i);
str_new = str([1:nopool_i-1, fs_i:firstUafterFs, nopool_i:firstUafterpool, firstUafterFs+1:end]);
assert(length(str) == length(str_new));

end

function new_name_i = strrep_f(new_name_i, a,b)
    new_name_i = strrep(new_name_i, [a '1ori'], [b '1ori']);
    new_name_i = strrep(new_name_i, [a '_'], [b '_']);
    new_name_i = strrep(new_name_i, [a 'f'], [b 'f']);
    new_name_i = strrep(new_name_i, [a 'n'], [b 'n']);
    new_name_i = strrep(new_name_i, [a 'p'], [b 'p']);
end


function name_i = tmp_reorderResultsFilenameStructure(name_i_orig)
    
    [~,name_i,file_ext] = fileparts(name_i_orig);
    
    name_i = strrep(name_i, '_GPU', '__GPU');
    
    name_split = strsplit(name_i, '__');
    n = length(name_split);
    seg_type = cell(1,n);
    
    new_order = {'1title', '2a_opts', '2b_crowdedTrOpts', '2c_crowdedTestOpts',  '2d_metOpts',  '3network', '4GPU', '5trial'};
    
    for seg_i = 1:n
        s_i = name_split{seg_i};
        if seg_i == 1
            seg_type{seg_i} = '1title';
            
        elseif any(strncmp(s_i, {'1oxy'}, 4)) || ~isempty(regexp(s_i, '\d+(x|y|ori)\[\d+\]', 'once'))
            seg_type{seg_i} = '2a_opts';
            
        elseif ~isempty(regexp(s_i, 'x\d+-\d+-\d+', 'once'))
            seg_type{seg_i} = '2b_crowdedTrOpts';
            
        elseif any(strncmp(s_i, {'1let', '2let'}, 4))
            seg_type{seg_i} = '2c_crowdedTestOpts';
            
        elseif ~isempty(regexp(s_i, '\d+x\d+_it\d+', 'once'))
            seg_type{seg_i} = '2d_metOpts';
            
        elseif any(strncmp(s_i, {'Conv', 'MLP'}, 3))
            seg_type{seg_i} = '3network';
            
        elseif strncmp(s_i, 'GPU', 3)
            seg_type{seg_i} = '4GPU';
            
        elseif ~isempty(regexp(s_i, 'tr\d', 'once'))
            seg_type{seg_i} = '5trial';
            
        else
            error('Unknown segment type : %s', s_i)
        end
        
    end
    
    [~, new_idx] = sort(seg_type);
    
    name_split_ordered = name_split(new_idx);
    name_ordered = strjoin(name_split_ordered, '__');
    
    name_ordered = strrep(name_ordered, '__GPU', '_GPU');
    name_i = [name_ordered file_ext];
    3;

end

%{
            a = '60_160_1200_'; b = '60_160_F1200_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '30_80_600_'; b = '30_80_F600_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '6_32_120_'; b = '6_32_F120_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '6_64_120_'; b = '6_64_F120_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '6_8_120_'; b = '6_8_F120_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '6_4_120_'; b = '6_4_F120_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '9_24_180_'; b = '9_24_F180_';  new_name_i = strrep_f(new_name_i, a,b);

            a = '1_15_'; b = '1_F15_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '2_15_'; b = '2_F15_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '3_15_'; b = '3_F15_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '12_100_'; b = '12_F100_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '12_50_'; b = '12_F50_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '6_100_'; b = '6_F100_';  new_name_i = strrep_f(new_name_i, a,b);
            a = '6_50_'; b = '6_F50';  new_name_i = strrep_f(new_name_i, a,b);

%}