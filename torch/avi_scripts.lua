
--dofile (paths.home .. '/Code/myscripts/torch/load_all_torch_scripts.lua')
local prefix_str = ''
if paths.dirp('/home/avi') then
    prefix_str = '~';
    dofile                '/f/scripts/torch/load_all_torch_scripts.lua'
    runAllScriptsInFolder('/f/scripts/torch-training/')
    
elseif paths.dirp('/home/ziskind') then
    prefix_str = '~';
    dofile                '/home/ziskind/f/scripts/torch/load_all_torch_scripts.lua'
    runAllScriptsInFolder('/home/ziskind/f/scripts/torch-training/')
else
    print("Unknown username");
end

--dofile (prefix_str .. '/f/scripts/torch/load_all_torch_scripts.lua')
--runAllScriptsInFolder(prefix_str .. '/f/scripts/torch-training/')




