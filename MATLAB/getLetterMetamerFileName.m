function fn = getLetterMetamerFileName(fontName, metamerFileParams) %, metamerLetterOpts)
    
%     if ~tf_pca
%         pca_str = '';
%     else
%         pca_str = '_PCA';
%     end        
%     
%     ori_x_y_str = getNoisyLetterOptsStr(oris, xs, ys);
    
    met_str = getMetamerLetterOptsStr(metamerFileParams);
    fontSize = num2str(metamerFileParams.fontSize);

    fn = sprintf('%s-%s_%s.mat',fontName,fontSize, met_str);
    3;
end

