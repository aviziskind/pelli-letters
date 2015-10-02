function fld_name = shortenFieldName(fld_name)
    fld_name_orig = fld_name;
    fld_name = strrep(fld_name, '_ideal', '');
    fld_name = strrep(fld_name, '-', '_');
    fld_name = strrep(fld_name, '[', '_');
    fld_name = strrep(fld_name, ']', '_');
    fld_name = strrep(fld_name, '__', '_');
    fld_name = strrep(fld_name, '.mat', '');
    fld_name = strrep(fld_name, '.', 'p');
    fld_name = strrep(fld_name, '1oxy', '1S');
    fld_name = strrep(fld_name, '_nopool', '0p');
    fld_name = strrep(fld_name, 'ptMAX', 'pM');
    fld_name = strrep(fld_name, 'MAX', 'M');
    fld_name = strrep(fld_name, 'Cls', 'C');
    fld_name = strrep(fld_name, '_SNR', '_S');
    fld_name = strrep(fld_name, 'ori', 'o');
    fld_name = strrep(fld_name, '_Conv_', '_C');
    fld_name = strrep(fld_name, 'GPU', 'G');
    fld_name = strrep(fld_name, '_tr', '');
  
    fld_name = strrep(fld_name, 'TrainingWithNoise', 'TWN');
    fld_name = strrep(fld_name, 'NoisyLettersTextureStats', 'NLTS');
    fld_name = strrep(fld_name, 'NoisyLetters', 'NL');
    fld_name = strrep(fld_name, 'NoisyTextureStats', 'NTS');
    fld_name = strrep(fld_name, 'CrowdedLetters_', '');
    fld_name = strrep(fld_name, 'pink', 'f');
    fld_name = strrep(fld_name, 'let', 'l');
    fld_name = strrep(fld_name, 'DNR', 'D');
    fld_name = strrep(fld_name, 'Complexity', 'C');
    fld_name = strrep(fld_name, '__', '_');
    fld_name = compressFontNames(fld_name);
  %%  
    maxFieldLength = 63;
    if length(fld_name) > maxFieldLength
        fld_name = strrep(fld_name, '_', '');
        fld_name = strrep(fld_name, '64x64', '64');
    end
    
    if length(fld_name) > maxFieldLength
        fld_hash = DataHash(fld_name_orig, struct('Method', 'SHA-1'));
        hashLength = length(fld_hash);
        fld_name = [fld_name(1: (maxFieldLength-hashLength)), fld_hash];
        
%         fld_hash2 = DataHash(fld_name_orig, struct('Method', 'SHA-1'));
        
%          'SHA-1', 'SHA-256', 'SHA-384', 'SHA-512', 'MD2', 'MD5'.
%            Known methods for Java 1.3 (Matlab 6.5):
%              'MD5', 'SHA-1'.
%            Default: 'MD5'.
        
%         error('name too long')
    end
    
end



function str = compressFontNames(str)
                              
      allFontName_abbrevs = struct('Armenian', 'A', ...
                                 'Bookman', 'M', ...
                                 'Braille', 'L', ...
                                 'Checkers4x4', 'C', ...
                                 'Courier', 'R', ...
                                 'Devanagari', 'D', ...
                                 'Helvetica', 'H', ...
                                 'Hebraica', 'I', ...
                                 'Kuenstler', 'K', ...
                                 'Sloan', 'S', ...
                                 'Yung', 'Y', ...
                                 ...
                                 'SVHN', 'N', ...
                                 ...
                                 'Snakes', 'G' ... % gabor
                             );
                              
      fontNames = fieldnames(allFontName_abbrevs);
      for i = 1:length(fontNames)
         
          str = strrep(str, fontNames{i}, allFontName_abbrevs.(fontNames{i}) );
          
      end
      
    
end
