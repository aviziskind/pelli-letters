function tryRotate(X, fig_id)
    if nargin > 1
        figure(fig_id)
    end
    
    clf; colormap('gray');
    subplot(2,2,1); imagesc(X); title('X'); colorbar;
    subplot(2,2,2); imagesc(log10(abs(X))); title('log10(abs(X))'); colorbar;

    X_rot = rotateLetters(X, 15);
    subplot(2,2,3); imagesc(X_rot); title('X_rot'); colorbar;
    subplot(2,2,4); imagesc(log10(abs(X_rot))); title('log10(abs(X_rot))'); colorbar;

    imageToScale([], 4);
%     X_rot = rotateLetters(X, 15);
%     subplot(2,2,5); imagesc(abs(X_rot)); title('abs(X_rot)');
%     subplot(3,2,4); imagesc(log10(abs(X_rot))); title('log10(abs(X_rot))');

end