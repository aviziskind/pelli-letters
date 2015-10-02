function testExpandOptionsToList
    options_test = struct('netType','ConvNet', ...
                         'stride', 2, ...
                         'doPooling', 1, ... 
                         'tbl_allNStates', {{ 1, 2 }}, ...
                         'tbl_filtsizes', {{ [6,16], [6,12] }} ...
                           );

    list_test = expandOptionsToList(options_test);
    
    display('=================Initial options table');
    display(options_test)
    
    display('=================Final list of tables:');
    for i = 1:length(list_test)
        display(sprintf('Table %d : ', i));
        display(list_test(i));
    end
    
end