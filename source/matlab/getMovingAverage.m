function result = getMovingAverage(item,history,k,maxDistance)

    neighbors = getNearestNeighbors(item,history,k,maxDistance);
    result    = mean(neighbors,1);

end

