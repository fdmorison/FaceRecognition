% Create a detector object using the Viola-Jones algorithm
detector = vision.CascadeObjectDetector(...
     'ClassificationModel','FrontalFaceCART'... % 'FrontalFaceCART', 'FrontalFaceLBP'
    ,'MinSize'            ,[50 50]...
    ,'MaxSize'            ,[300 300]...    
);

path  = '../../../resources/fotos/';
files = dir(strcat(path,'*.jpg'));
count = 1;

for i=1:numel(files)
    % Detect faces
    filename = strcat(path,files(i).name);
    image    = double(imread(filename))/256;
    boxes    = step(detector, image);
    N        = size(boxes,1);
    % Crop faces
    for j = 1:N   
        box   = boxes(j,:);
        face  = imcrop(image, box);
        face  = imresize(face, [100 100]);
        fname = strcat('face',num2str(count),'.jpg');
        imwrite(face,fname);
        count = count + 1;
    end 
end

