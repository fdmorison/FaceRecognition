% Read the video file
% ../../resources/data/videos/Seq01_1080.avi
% ../../resources/data/videos/Seq05_1080.avi
% ../../resources/data/videos/Seq15_1080.avi
% tilted_face.avi
filename = 'tilted_face.avi';
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
dataset  = double(vertcat(database.features));
searcher = KDTreeSearcher(dataset);
indexIntervals = [0, cumsum([database.featuresCount])] + 1;

% Auxilary settings
history        = [];  % History of faces detected in each of the previous N frames
historyCount   = [];  % Number of faces detected in each of previous N frames
historySize    = 30;  % Maximum history size 
boxMaxDistance = 15;  % Maximum euclidean distance used to identify boxes of same face through frames
faceDimension  = 250; % Size to crop faces

absoluteDistanceThreshold = 0.25; % When retrieving faces, skip very distant features
relativeDistanceThreshold = 0.8;  % When retrieving faces, skip very close features

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
        % Recognize the faces in each box
        for i=1:N 
            % Crop face from frame
            box  = boxes(i,:);
            face = imcrop(frame, box);
            face = imresize(face,[faceDimension faceDimension]);
            % Recognize it
            name  = '????';
            query = preprocessImage(name,face);            
            % Select good matches based on distances
            [matches, distance] = knnsearch(dataset,query.features,'K',2);
            goodRatioMatches    = distance(:,1) < distance(:,2) * relativeDistanceThreshold;
            goodDistanceMatches = distance(:,1) < absoluteDistanceThreshold;
            %goodMatches         = matches(goodDistanceMatches & goodRatioMatches,1);
            goodMatches         = matches(goodDistanceMatches,1);
            % Count number of features that matched from each image 
            counts = histc(goodMatches(:,1), indexIntervals);     
            % Measure distance from query to neighbors (crescent)
            [~,rank] = sort(counts(1:end-1),'descend');
            result   = database(rank);
            if ( ~isempty(result) )
                name = result(1).name;
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
