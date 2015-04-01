% Read Input Image
filename = '../../../resources/fotos/fabricio2.jpg';
image    = double(imread(filename))/256;

% Create a detector object using the Viola-Jones algorithm
detector = vision.CascadeObjectDetector(...
     'ClassificationModel','FrontalFaceCART'... % 'FrontalFaceCART', 'FrontalFaceLBP'
    ,'MinSize'            ,[50 50]...
    ,'MaxSize'            ,[250 250]...    
);

% Detect faces
boxes = step(detector, image);
N     = size(boxes,1);

% Crop faces
for i = 1:N   
    % Next face
    box  = boxes(i,:);
    face = imcrop(image, box);
    % Detect SURF features and return SURFPoints object
    gray   = rgb2gray(face);
    points = detectSURFFeatures(gray);
    coeff  = pca(gray);
    % Identify person in the original image
    image = insertObjectAnnotation(image, 'rectangle', boxes, 'Fulano');
    % Plot
    figure
    imshow(face);
    hold on;
    plot(points.selectStrongest(10));
end

% Show the result
figure, 
imshow(image), 
title('Detected faces');

