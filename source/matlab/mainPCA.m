% Read the video file
% ../../resources/data/videos/Seq01_1080.avi
% ../../resources/data/videos/Seq05_1080.avi
% ../../resources/data/videos/Seq15_1080.avi
% tilted_face.avi
filename = '../../resources/data/videos/Seq05_1080.avi';
reader   = vision.VideoFileReader(filename); 
frame    = step(reader);

% Initialize the Video Player
settings = [100 100 [size(frame, 2), size(frame,1)]+30];
player   = vision.VideoPlayer('Position',settings);

% Initialize the face detector using the Viola-Jones
detector = vision.CascadeObjectDetector(...
     'ClassificationModel','FrontalFaceLBP'... % 'FrontalFaceCART', 'FrontalFaceLBP'
    ,'MinSize'            ,[80  80]...
    ,'MaxSize'            ,[240 240]...
);

% Load the face database to memory
database = loadImages('../../resources/data/database/');

% Auxilary settings
history        = []; % History of faces detected in each of the previous N frames
historyCount   = []; % Number of faces detected in each of previous N frames
historySize    = 30; % Maximum history size 
boxMaxDistance = 15; % Maximum euclidean distance used to identify boxes of same face through frames
faceDimension  = 250;
faceAbsoluteThresholdDistance = 2.75;

% Run the video
while ~isDone(reader)

    % Try detect faces
    boxes = step(detector, frame);
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
            % Crop face from frame
            box  = boxes(i,:);
            face = imcrop(frame, box);
            face = imresize(face,[faceDimension faceDimension]);
            % Recognize it
            name  = '????';
            query = preprocessImage(name,face);
            [result,d] = getSimilarFacesPCA(query,database,faceAbsoluteThresholdDistance);
            if ( ~isempty(result) )
                name = strcat(result(1).name,' |',num2str(d(1)));
            end
            % Show the person's name in the box
            box   = getMovingAverage(box,history,historySize,boxMaxDistance);
            frame = insertObjectAnnotation(frame, 'rectangle', box, name);            
        end            
    end    
    % Show the frame
    step(player, frame);
    % get the next frame
    frame = step(reader);
end

% Release resources
release(reader);
release(player);
