function image = preprocessImage( name, content )
    
    % Calc PCA features
    grayContent = rgb2gray(content);
    pcaFeatures = pca(grayContent);
    pcaFeatures = pcaFeatures(1:6*250);
    %pcaFeatures = pcaFeatures((246*250)+1:end);
    
    % Calc surf features
    surfPoints   = detectSURFFeatures(grayContent);
    surfFeatures = extractFeatures(grayContent,surfPoints);
    
    % Format result
    image = struct(...
         'name'         , name...
        ,'content'      , content...
        ,'features'     , surfFeatures...
        ,'featuresCount', size(surfFeatures,1)...
        ,'pcafeatures'  , pcaFeatures...
    );

end

