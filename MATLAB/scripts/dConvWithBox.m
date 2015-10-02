
function y_deconv = dConvWithBox(x, y, boxWidth)
%%
    dx = diff(x(1:2));
%     y = y/max(y);
    
    x_box = 0:dx:boxWidth;
    y_box = ones( 1, length(x_box) );
    y_box = y_box/ sum(y_box);
    

    nToAdd = length(y_box)-1;
    nBefore = ceil(nToAdd/2);
    nAfter = nToAdd-nBefore;

    y_padded = padarray( padarray(y, [0, nBefore], 'replicate', 'pre'), [0, nAfter], 'replicate', 'post');
    
    x_padded = [[-nBefore:-1]*dx + x(1), x, x(end)+[1:nAfter]*dx ]; 
    
    y_deconv = deconv(y_padded, y_box);

    show = 0;
    if show
        %%
        figure(845); clf; hold on;
        plot(x,y, 'bs-');
        plot(x_padded,y_padded, 'bo-');
        plot(x_box, y_box, 'rs:');
        plot(x, y_deconv, 'm^-')
        
    end
    
end

