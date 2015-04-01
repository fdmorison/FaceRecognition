function image = preprocessImage( name, content )
    
    % Calc PCA features
    grayContent = rgb2gray(content);
    pcaFeatures = pca(grayContent);
    pcaFeatures = pcaFeatures(1:5000);

    % Calc surf features
    surfFeatures = detectSURFFeatures(grayContent);

    % Format result
    image = struct(...
         'name'    ,name...
        ,'content' ,content...
        ,'features',pcaFeatures...
    );

end

