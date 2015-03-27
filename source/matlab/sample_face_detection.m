faceDetector = vision.CascadeObjectDetector('FrontalFaceLBP');

I = imread('fotos/foto3.jpg');
bboxes = step(faceDetector, I);

IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');

figure, 
imshow(IFaces), 
title('Detected faces');