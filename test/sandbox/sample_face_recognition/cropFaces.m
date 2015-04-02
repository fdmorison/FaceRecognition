% Create a detector object using the Viola-Jones algorithm
detector = vision.CascadeObjectDetector(...
     'ClassificationModel','FrontalFaceCART'... % 'FrontalFaceCART', 'FrontalFaceLBP'
    ,'MinSize'            ,[50 50]...
    ,'MaxSize'            ,[300 300]...    
);

path    = '../../../resources/fotos/';
entries = dir(path);
count   = 1;
dim     = 250;

for i=1:numel(entries)
    directory = entries(i);
    if (directory.isdir && strcmp(directory.name,'.')==0 && strcmp(directory.name,'..')==0)
        person = directory.name;
        photos = dir(strcat(path,person,'/*.jpg'));
        count  = 1;
        for j = 1:numel(photos)
            photo    = photos(j);
            filepath = strcat(path,person,'/',photo.name);
            content  = im2double(imread(filepath));
            boxes    = step(detector, content);
            for z=1:size(boxes,1);
                box   = boxes(z,:);
                face  = imcrop(content, box);
                face  = imresize(face, [dim dim]);
                fname = strcat(person,num2str(count),'.jpg');
                imwrite(face,fname);
                count = count + 1;
            end
        end
    end
end
