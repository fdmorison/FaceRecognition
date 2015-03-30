% Read the video file
filename = 'tilted_face.avi'; % videos/Seq05_1080.avi videos/Seq01_1080.avi tilted_face.avi
reader   = vision.VideoFileReader(filename); 
image    = step(reader);

% Initialize a Video Player
settings = [100 100 [size(image, 2), size(image, 1)]+30];
player   = vision.VideoPlayer('Position',settings);

% Create a detector object using the Viola-Jones algorithm
faceDetector = vision.CascadeObjectDetector('FrontalFaceLBP'); % 'FrontalFaceCART', 'FrontalFaceLBP'

% Auxilary settings
detectionTimeout = 0;  % Timeout in frames before firing a new detection
detectionDelay   = 1;  % Maximum Limit for detectionTimeout (set 1 to detect all frames)
history          = []; % History of faces detected in each of the previous N frames
historyCount     = []; % Number of faces detected in each of previous N frames
historySize      = 40; % Maximum history size 
boxMaxDistance   = 15; % Maximum euclidean distance used to identify boxes of same face through frames

% Run the video
while ~isDone(reader)
    % Detection Step
    if (detectionTimeout == 0)
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
            % For each box,
            % replace it by the average of previous boxes
            boxes = getMovingAverages(boxes,history,historySize,boxMaxDistance);
        end
    end
    detectionTimeout = mod(detectionTimeout+1,detectionDelay);
	% Recognize People in the image
	name = 'Joaozinho';
	
    % Annotate and Display the frame
    image = insertObjectAnnotation(image, 'rectangle', boxes, name);    
    step(player, image);
    % get the next frame
    image = step(reader);
    %pause(0.5);
end

% Release resources
release(reader);
release(player);
