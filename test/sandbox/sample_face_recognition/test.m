database = loadImages('database/');
queries  = loadImages('query/');

query = queries(1);
[res,dist] = getSimilarFaces(query,database,999);

N = numel(res);
I = [];
for i=1:N 
    face = res(i).content;
    face = insertText(face,[0 0],num2str(dist(i)));    
    I = cat(1,I,face);
end

figure
subplot(1,2,1); 
imshow(query.content);
title('Query')

subplot(1,2,2); 
imshow(I);
title(strcat('Result'));
    


