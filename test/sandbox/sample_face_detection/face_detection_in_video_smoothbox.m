% Read the video file
reader = vision.VideoFileReader('Seq01_1080.avi'); % Seq01_1080.avi tilted_face.avi
image  = step(reader);

% Initialize a Video Player to Display the Results
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
            history      = [boxes;        history ];
            historyCount = [size(boxes,1) historyCount];
            if ( numel(historyCount) > historySize )
                historyCount = historyCount(1:historySize);            
                history  = history(1:sum(historyCount),:);
            end
            % For each box,
            % replace it by the average of previous boxes
            for i=1:N;
                box  = boxes(i,:);
                prev = getNearestNeighbor(box,history,historySize,boxMaxDistance);
                boxes(i,:) = mean(prev,1);
            end
        end
    end  
    detectionTimeout = mod(detectionTimeout+1,detectionDelay);
    % Annotate and Display the frame
    image = insertObjectAnnotation(image, 'rectangle', boxes, 'Joaozinho');    
    step(player, image);
    % get the next frame
    image = step(reader);
    %pause(0.5);
end

release(reader);
release(player);
