function [result,dist] = getSimilarFaces(query,neighbors,maxDistance)

    N      = numel(neighbors);
    result = [];
    dist   = [];
    
    if (N > 0)      
        for i = 1:N
            distance = sqrt(sum((query.features-neighbors(i).features).^2));
            if (distance <= maxDistance)
                dist   = [dist distance];
                result = [result neighbors(i)];
            end
        end
        % Sort neighbors by distance to query
        [dist,index] = sort(dist);       
        result = result(index);
    end

end

