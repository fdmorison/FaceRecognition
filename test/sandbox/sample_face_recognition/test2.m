database = loadImages('../../../resources/data/database/');
queries  = loadImages('../../../resources/data/query/');
N        = numel(queries);

for i=1:N
    % Next query
    query = queries(i);
    % Retrieve more similar faces
    [result,distances] = getSimilarFaces(query,database,99);   
    % Concat resulting faces
    faces = query.content;
    faces = insertText(faces,[0 0],query.name,'FontSize',30,'BoxColor','green');  
    for j=1:numel(result)
        person = result(j);
        dist   = distances(j);
        face   = person.content;
        face   = insertText(face,[0 0  ],person.name,'FontSize',30);
        face   = insertText(face,[0 210],num2str(dist),'FontSize',30);
        faces  = cat(2,faces,face);
    end
    % Show results
    subplot(N,1,i); 
    imshow(faces);
end



    


