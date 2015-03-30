% Read the video file
reader = vision.VideoFileReader('tilted_face.avi');
image  = step(reader);

% Initialize a Video Player to Display the Results
settings = [100 100 [size(image, 2), size(image, 1)]+30];
player   = vision.VideoPlayer('Position',settings);

% Run the video
while ~isDone(reader)
    % Display the annotated video frame using the video player object
    step(player, image);
    % get the next frame
    image = step(reader);
    pause(0.05);
end

release(reader);
release(player);
