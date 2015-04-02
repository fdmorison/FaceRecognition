database = loadImages('../../../resources/data/database/');
queries  = loadImages('../../../resources/data/query/');
N        = numel(queries);

dataset  = double(vertcat(database.features));
searcher = KDTreeSearcher(dataset);
indexIntervals = [0, cumsum([database.featuresCount])] + 1;

absoluteDistanceThreshold = 0.25;
relativeDistanceThreshold = 0.8;

for i=1:N
    % Next query
    query = queries(i);
    % Retrieve more similar faces
    [matches, distance] = knnsearch(dataset,query.features,'K',3);    

    % Select good matches based on distances
    goodRatioMatches    = distance(:,1) < distance(:,2) * relativeDistanceThreshold;
    goodDistanceMatches = distance(:,1) < absoluteDistanceThreshold;
    goodMatches         = matches(goodDistanceMatches & goodRatioMatches,1);

    % Count number of features that matched from each image 
    counts = histc(goodMatches(:,1), indexIntervals);
     
    % Measure distance from query to neighbors (crescent)
    [~,rank] = sort(counts(1:end-1),'descend');
    result   = database(rank);

    % Concat resulting faces
    faces = query.content;
    faces = insertText(faces,[0 0],query.name,'FontSize',30,'BoxColor','green');  
    for j=1:numel(result)
        person = result(j);
        face   = person.content;
        face   = insertText(face,[0 0  ],person.name,'FontSize',30);
        faces  = cat(2,faces,face);
    end
    % Show results
    subplot(N,1,i); 
    imshow(faces);
end



    


