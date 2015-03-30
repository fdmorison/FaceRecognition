% Read the video file
reader = vision.VideoFileReader('tilted_face.avi');
image  = step(reader);

% Initialize a Video Player to Display the Results
settings = [100 100 [size(image, 2), size(image, 1)]+30];
player   = vision.VideoPlayer('Position',settings);

% Create a detector object using the Viola-Jones algorithm
faceDetector = vision.CascadeObjectDetector('FrontalFaceLBP'); % 'FrontalFaceCART', 'FrontalFaceLBP'

% Auxilary settings
detectionTimeout = 0;
detectionDelay   = 5;

% Run the video
while ~isDone(reader)
    % Detect and put a box in the faces
    if (detectionTimeout == 0)
        boxes = step(faceDetector, image);
    end
    detectionTimeout = mod(detectionTimeout+1,detectionDelay);    
    % Annotate and Display the frame
    image = insertObjectAnnotation(image, 'rectangle', boxes, 'Face');    
    step(player, image);
    % get the next frame
    image = step(reader);
    %pause(0.05);
end

release(reader);
release(player);
