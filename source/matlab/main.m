% Read the video file
filename = 'tilted_face.avi'; % videos/Seq05_1080.avi videos/Seq01_1080.avi tilted_face.avi
reader   = vision.VideoFileReader(filename); 
image    = step(reader);

% Initialize a Video Player
settings = [100 100 [size(image, 2), size(image, 1)]+30];
player   = vision.VideoPlayer('Position',settings);

% Create a detector object using the Viola-Jones algorithm
faceDetector = vision.CascadeObjectDetector(...
     'ClassificationModel','FrontalFaceCART'... % 'FrontalFaceCART', 'FrontalFaceLBP'
    ,'MinSize'            ,[75  75]...
    ,'MaxSize'            ,[250 250]...
);

% Auxilary settings
history        = []; % History of faces detected in each of the previous N frames
historyCount   = []; % Number of faces detected in each of previous N frames
historySize    = 30; % Maximum history size 
boxMaxDistance = 15; % Maximum euclidean distance used to identify boxes of same face through frames

% Run the video
while ~isDone(reader)

    % Try detect faces
    boxes = step(faceDetector, image);
    N     = size(boxes,1);
    
    % If some face is detect...
    if (N > 0)          
        % Store the boxes of the last N detections
        history      = [boxes; history];
        historyCount = [N      historyCount];
        if ( numel(historyCount) > historySize )
            historyCount = historyCount(1:historySize);    % truncate          
            history      = history(1:sum(historyCount),:); % truncate
        end
        % Recognize the faces
        for i=1:N 
            % Next face
            box  = boxes(i,:);
            face = imcrop(image,box);
            box  = getMovingAverage(box,history,historySize,boxMaxDistance);
            % TODO Recognize the face
            name = 'Joaozinho';
            % Draw the box around the face and write its name
            image = insertObjectAnnotation(image, 'rectangle', box, name);    
        end            
    end
    
    % Display the frame
    step(player, image);
    % get the next frame
    image = step(reader);
    %pause(0.5);
end

% Release resources
release(reader);
release(player);
