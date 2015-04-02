function [result,dist] = getSimilarFaces(query,neighbors,maxDistance)

    N      = numel(neighbors);
    result = [];
    dist   = [];
    
    if (N > 0)
        % Measure distance from query to neighbors
        for i = 1:N
            neighbor = neighbors(i);
            distance = sqrt(sum((query.pcafeatures-neighbor.pcafeatures).^2));
            if (distance <= maxDistance)
                dist   = [dist   distance];
                result = [result neighbor];
            end
        end
        % Sort neighbors by distance to query
        [dist,index] = sort(dist); 
        result = result(index);
    end

end