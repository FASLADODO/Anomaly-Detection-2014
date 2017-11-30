function [centroids] = train(data, label, k, metric)
    [class] = litekmeans(data, k, 'distance', metric);
    centroids = [];
    type = zeros(size(label));
    for i = 1:k
       %type = vertcat(type,mode(label(find(class(:,1) == i))));
       type(class == i) = mode(label(find(class(:,1) == i)));

       %centroids = vertcat(centroids, mean(data(find(class(:,1) == i),:)));
    end
    for j = 1:max(type)
        centroids = vertcat(centroids, mean(data(find(type(:,1) == j),:)));
    end
end