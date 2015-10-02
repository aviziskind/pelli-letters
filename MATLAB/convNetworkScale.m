%%
%     clear all
%     clc

%     nstates = [6,16,120];
%     nstates = [6,50];
%     nstates = [6, 16, 128, 120];

      nstates = [16, 64, 512, 120];  filtsizes = [5, 5, 3];  poolsizes = [2, 2, 3];
%     nstates = [6, 16, 64, 120]; filtsizes = [5, 3, 3]; poolsizes = [2, 2, 2];



%           nstates = [6, 16, 64, 120];    filtsizes = [5, 5, 3];  poolsizes = [2, 2, 2];
%         nstates = [16, 64, 512, 120];  filtsizes = [5, 3, 3]; poolsizes = [2, 2, 2];
        nstates = [16, 64, 512, 120];  filtsizes = [5, 3, 3]; poolsizes = [2, 2, 3];


        
        
%         nstates = [6, 16, 64, 120];    filtsizes = [5, 5, 3]; poolsizes = [2, 2, 2];
%         nstates = [6, 16, 64, 120];    filtsizes = [5, 5, 3]; poolsizes = [2, 2, 3];
%         nstates = [6, 16, 64, 120];    filtsizes = [5, 3, 3]; poolsizes = [2, 2, 2];
        nstates = [6, 16, 64, 120];    filtsizes = [5, 3, 3]; poolsizes = [2, 2, 3];
        
        
    nfeats = 1; 
    fanin = [1,4,16];
%     filtsizes = [5,4];
    

%     poolsizes = [4,2];
%     poolsizes = [3, 3, 3];
%     poolsizes = [2, 2, 2];

    strides = poolsizes; %[4];
    pooltype = 2;

%     height = 29;
%     width = 39;
    
%     height = 36;
%     width = 88;
%     height = 96;
%     width = 96;
%     height = 64;  width = 64;
    height = 32;  width = 32;
%     height = 56;  width = 56;
    
    noutputs = 26;

    nConvLayers = length(nstates)-1;
    
    % 1. first conv layer
    
    
%     nOut_conv1_h = height - filtsizes(1) + 1;
%     nOut_conv1_w = width - filtsizes(1) + 1;
%     nOut_pool1_h = floor( (nOut_conv1_h - poolsizes(1))/strides(1)) + 1;
%     nOut_pool1_w = floor( (nOut_conv1_w - poolsizes(1))/strides(1)) + 1;
% 
%     nOut_conv2_h = nOut_pool1_h - filtsizes(2) + 1;
%     nOut_conv2_w = nOut_pool1_w - filtsizes(2) + 1;
% 
%     nOut_pool2_h = floor( (nOut_conv2_h - poolsizes(2))/strides(2)) + 1;
%     nOut_pool2_w = floor( (nOut_conv2_w - poolsizes(2))/strides(2)) + 1;
%     codesize = nstates(2) * nOut_pool2_h * nOut_pool2_w;
 
%     nOut_pool1_chk = length( poolsizes(1) : strides(1) : nOut_conv1_h ); 
%     assert(isequal(nOut_pool1_side, nOut_pool1_chk))
%     nOut_pool2_chk = length( poolsizes(2) : strides(2) : nOut_conv2_side );
%     as     sert(nOut_pool2_side == nOut_pool2_chk);

    nOut_conv_h = zeros(1, nConvLayers);
    nOut_conv_w = zeros(1, nConvLayers);
    nOut_pool_h = zeros(1, nConvLayers);
    nOut_pool_w = zeros(1, nConvLayers);
    
    
    fprintf('\n\n\n-------------------------------\n');

            
    for layer_i = 1:nConvLayers
        

        if layer_i == 1
            nstates_prev = nfeats;
            height_prev = height;
            width_prev = width;
        else
            nstates_prev = nstates(layer_i-1);
            
            height_prev = nOut_pool_h(layer_i-1);
            width_prev = nOut_pool_w(layer_i-1);
        end

        nOut_conv_h(layer_i) = height_prev - filtsizes(layer_i) + 1;
        nOut_conv_w(layer_i) = width_prev - filtsizes(layer_i) + 1;
        
        
        
        nOut_pool_h(layer_i) = floor( (nOut_conv_h(layer_i) - poolsizes(layer_i) )/strides(layer_i)) + 1;
        nOut_pool_w(layer_i) = floor( (nOut_conv_w(layer_i) - poolsizes(layer_i) )/strides(layer_i)) + 1;
                
        n_pool_h_cover =   (nOut_pool_h(layer_i) - 1) * strides(layer_i) + poolsizes(layer_i);
        dropped_h = nOut_conv_h(layer_i) - n_pool_h_cover;
        
        n_pool_w_cover =   (nOut_pool_w(layer_i) - 1) * strides(layer_i) + poolsizes(layer_i);
        dropped_w = nOut_conv_w(layer_i) - n_pool_w_cover;
        pad_str = '';
        if (dropped_h > 0 || dropped_w > 0)
            nOut_pool_h(layer_i) = ceil( (nOut_conv_h(layer_i) - poolsizes(layer_i) )/strides(layer_i)) + 1;
            nOut_pool_w(layer_i) = ceil( (nOut_conv_w(layer_i) - poolsizes(layer_i) )/strides(layer_i)) + 1;
            
            n_pool_h_cover_ext =   (nOut_pool_h(layer_i) - 1) * strides(layer_i) + poolsizes(layer_i);
            n_pool_w_cover_ext =   (nOut_pool_w(layer_i) - 1) * strides(layer_i) + poolsizes(layer_i);
            
            n_to_pad_h = n_pool_h_cover_ext - nOut_conv_h(layer_i);
            n_to_pad_w = n_pool_w_cover_ext - nOut_conv_w(layer_i);
            pad_str = sprintf(' add %dx%d padding', n_to_pad_h, n_to_pad_w);
        end

        
        nParams_thisLayer = nstates(layer_i) * nOut_pool_h(layer_i) * nOut_pool_w(layer_i);
        
        
        fprintf('Conv %d\n', layer_i)
        fprintf('[%d] Input:  %d x  %d x %d\n',  3*(layer_i)-2,  nstates_prev, height_prev, width_prev);
        fprintf('    <%d filters of size: %d x %d>\n', nstates(layer_i), filtsizes(layer_i), filtsizes(layer_i))
        fprintf('    Output: %d x  %d x %d\n\n', nstates(layer_i), nOut_conv_h(layer_i), nOut_conv_w(layer_i))

        % 2. first pooling layer
        fprintf('     Pooling %d \n', layer_i)
        fprintf('     [%d] Input:  %d x  %d x %d\n', 3*(layer_i)-1,  nstates(layer_i),  nOut_conv_h(layer_i),  nOut_conv_w(layer_i))
        fprintf('         <pooling: %d x %d>  \n', poolsizes(layer_i), poolsizes(layer_i))
        fprintf('         Output: %d x  %d x %d  [=%d] [[covers %dx%d, dropped %d, %d %s. ]]\n\n', nstates(layer_i), nOut_pool_h(layer_i),  nOut_pool_w(layer_i), nParams_thisLayer, ...
            n_pool_h_cover, n_pool_w_cover, dropped_h, dropped_w, pad_str);
        
    end
    
    
    codesize = nstates(nConvLayers) * nOut_pool_h(nConvLayers) * nOut_pool_w(nConvLayers);
    
    % reshape
    fprintf('Reshape \n')
    fprintf('[%d] Input:  %d x  %d x %d\n', nConvLayers*3 +1, nstates(nConvLayers), nOut_pool_h(nConvLayers), nOut_pool_w(nConvLayers))
    fprintf('    Output: %d \n\n', codesize)
    
     % linear
    fprintf('Linear \n')
    fprintf('[%d] Input:  %d \n', nConvLayers*3 +2, codesize)
    fprintf('    Output: %d \n\n', nstates(end))
    
    % linear
    fprintf('Linear \n')
    fprintf('[%d] Input:  %d \n', nConvLayers*3 +4, nstates(end))
    fprintf('     Output: %d \n\n', noutputs)
    
    %%

    nOut_conv_h
    nOut_conv_w
    nOut_pool_h
    nOut_pool_w
    %%
    
    
    %{
    
    
    %%
%     nstates = [6,16,120];
%     nstates = [3,8,60];
    nstates = [3,8,60];
    nfeats = 1; 
    fanin = [1,4,16];
    filtsizes = [5,4];

    poolsizes = [4,2];
    strides = [2,2];
    pooltype = 2;

%     height = 29;
%     width = 39;
    
    height = 25;
    width = 29;
    
    noutputs = 26;

    % 1. first conv layer
    
    
    nOut_conv1_h = height - filtsizes(1) + 1;
    nOut_conv1_w = width - filtsizes(1) + 1;
    nOut_pool1_h = floor( (nOut_conv1_h - poolsizes(1))/strides(1)) + 1;
    nOut_pool1_w = floor( (nOut_conv1_w - poolsizes(1))/strides(1)) + 1;

    nOut_conv2_h = nOut_pool1_h - filtsizes(2) + 1;
    nOut_conv2_w = nOut_pool1_w - filtsizes(2) + 1;

    nOut_pool2_h = floor( (nOut_conv2_h - poolsizes(2))/strides(2)) + 1;
    nOut_pool2_w = floor( (nOut_conv2_w - poolsizes(2))/strides(2)) + 1;
    codesize = nstates(2) * nOut_pool2_h * nOut_pool2_w;
 
%     nOut_pool1_chk = length( poolsizes(1) : strides(1) : nOut_conv1_h ); 
%     assert(isequal(nOut_pool1_side, nOut_pool1_chk))
%     nOut_pool2_chk = length( poolsizes(2) : strides(2) : nOut_conv2_side );
%     as     sert(nOut_pool2_side == nOut_pool2_chk);

%     nOut_conv_h = [nOut_conv1_h, nOut_conv2_h]
%     nOut_conv_w = [nOut_conv1_w, nOut_conv2_w]
%     nOut_pool_h = [nOut_pool1_h, nOut_pool2_h]
%     nOut_pool_w = [nOut_pool1_w, nOut_pool2_w]


    fprintf('\n\n\n-------------------------------\n');
    fprintf('Conv 1\n')
    fprintf('[1] Input:  %d x  %d x %d\n', nfeats, height, width)
    fprintf('    Output: %d x  %d x %d\n\n', nstates(1), nOut_conv1_h, nOut_conv1_w)

    % 2. first pooling layer
    fprintf('Pooling 1 \n')
    fprintf('[3] Input:  %d x  %d x %d\n', nstates(1), nOut_conv1_h, nOut_conv1_w)
    fprintf('    Output: %d x  %d x %d\n\n', nstates(1), nOut_pool1_h, nOut_pool1_w)

    % 3. second conv layer
    fprintf('Conv 2\n')
    fprintf('[4] Input:  %d x  %d x %d\n', nstates(1), nOut_pool1_h, nOut_pool1_w)
    fprintf('    Output: %d x  %d x %d\n\n', nstates(2), nOut_conv2_h, nOut_conv2_w)

    % 4. second pooling layer
    fprintf('Pooling 2 \n')
    fprintf('[6] Input:  %d x  %d x %d\n', nstates(2), nOut_conv2_h, nOut_conv2_w)
    fprintf('    Output: %d x  %d x %d\n\n', nstates(2), nOut_pool2_h, nOut_pool2_w)

    % reshape
    fprintf('Reshape \n')
    fprintf('[7] Input:  %d x  %d x %d\n', nstates(2), nOut_pool2_h, nOut_pool2_w)
    fprintf('    Output: %d \n\n', codesize)
    
     % linear
    fprintf('Linear \n')
    fprintf('[8] Input:  %d \n', codesize)
    fprintf('    Output: %d \n\n', nstates(3))
    
    % linear
    fprintf('Linear \n')
    fprintf('[10] Input:  %d \n', nstates(3))
    fprintf('     Output: %d \n\n', noutputs)
    
    %%
%}
    
    
%{    
    -------------------------------
Conv 1
[1] Input:  1 x  25 x 29
    Output: 3 x  21 x 25

Pooling 1 
[3] Input:  3 x  21 x 25
    Output: 3 x  9 x 11

Conv 2
[4] Input:  3 x  9 x 11
    Output: 8 x  6 x 8

Pooling 2 
[6] Input:  8 x  6 x 8
    Output: 8 x  3 x 4

Reshape 
[7] Input:  8 x  3 x 4
    Output: 96 

Linear 
[8] Input:  96 
    Output: 60 

Linear 
[10] Input:  60 
     Output: 26 
     
     
     
              
     
     
     
     
     
     
     
     
     -------------------------------
Conv 1
[1] Input:  1 x  25 x 29
    Output: 3 x  21 x 25

Pooling 1 
[2] Input:  3 x  21 x 25
    Output: 3 x  9 x 11

Conv 2
[4] Input:  3 x  9 x 11
    Output: 8 x  6 x 8

Pooling 2 
[5] Input:  8 x  6 x 8
    Output: 8 x  3 x 4

Reshape 
[7] Input:  8 x  3 x 4
    Output: 96 

Linear 
[8] Input:  96 
    Output: 60 

Linear 
[10] Input:  8 
     Output: 26 
     
     
     %}