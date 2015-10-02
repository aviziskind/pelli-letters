%%

mainDir = 'D:\Users\Avi\Code\MATLAB\nyu\letters\fonts\fonts_from_word\~screenshots\';

subs = subfolders(mainDir);

for i = 1:length(subs)
    %%
    sub_i = subs{i}; 
    sub_folder_i = [mainDir sub_i '\'];
    
    
    subs2 = subfolders(sub_folder_i);
    %%
    for j = 1:length(subs2)
        %%
        sub_j = subs2{j};
        
        sub_folder_j = [sub_folder_i sub_j '\' ];
        
        screenshots_folder = [sub_folder_j 'screenshots\'];
        if exist(screenshots_folder, 'dir')
            cmd_str = sprintf('move %s*.png %s', screenshots_folder, sub_folder_j);
            a1 = system(cmd_str);
            rmdir(screenshots_folder)

        end
        
        
    end
    
    
end