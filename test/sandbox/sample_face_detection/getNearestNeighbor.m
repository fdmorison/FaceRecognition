function result = getNearestNeighbor(query,neighbors,k,maxDistance)

    N = size(neighbors,1); % lines
    M = size(neighbors,2); % columns
    
    if (N == 0)
        result = query;
    else
        % Measure distances
        distances = zeros(N,1);
        for row = 1:N         
            distances(row,1) = sqrt(sum((query-neighbors(row,:)).^2));
        end
        % Sort neighbors by distance to query
        neighbors = sortrows([neighbors distances],M+1);
        % Remove neighbors whose distance is to large
        neighbors = neighbors(neighbors(:,M+1)<maxDistance,:);        
        N = size(neighbors,1);
        % Select first k elements
        if (k < N)
            neighbors = neighbors(1:k,:);
        end       
        result = neighbors(:,1:M);
    end

end

