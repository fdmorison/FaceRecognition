function result = loadImages( directory )

    files  = dir(strcat(directory,'*.jpg'));
    length = numel(files);
    result = [];

    for i=1:length
        path    = strcat(directory,files(i).name);        
        content = im2double(imread(path));
        name    = strrep(files(i).name,'.jpg',' ');
        image   = preprocessImage(name,content);
        result  = [result image];
    end

end

