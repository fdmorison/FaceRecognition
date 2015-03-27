% Read Input Image
filename = 'fotos/foto3.jpg';
image    = imread(filename);

% Create a detector object using the Viola-Jones algorithm
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART'); % 'FrontalFaceCART', 'FrontalFaceLBP'

% Detect faces
faceBoxes = step(faceDetector, image);

% Put a box in each detected face
result = insertObjectAnnotation(image, 'rectangle', faceBoxes, 'Face');

% Show the result
figure, 
imshow(result), 
title('Detected faces');