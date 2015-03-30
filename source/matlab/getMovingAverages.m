function result = getMovingAverages(items,history,k,maxDistance)

    N = size(items,1);
    for i=1:N;
        item       = items(i,:);
        neighbors  = getNearestNeighbors(item,history,k,maxDistance);
        items(i,:) = mean(neighbors,1);
    end
    result = items;

end

