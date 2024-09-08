% Load data
loadedData = load('data33.mat'); 

% The loaded data is a struct; we need to extract the matrix from it.
fieldnames = fields(loadedData); 
data = loadedData.(fieldnames{1}); 

% Transpose data to have 200 rows and 2 columns
data = data';

% Check if data loaded correctly
if size(data, 1) < 200 || size(data, 2) < 2
    error('Not enough data points. Please use a dataset with at least 200 data points.')
end

% K-means clustering
k = 2;
max_iterations = 100;
[Idx, ~] = myKmeans(data, k, max_iterations);

% Calculate error rates
error1 = sum(Idx(1:100) ~= mode(Idx(1:100)));
error2 = sum(Idx(101:end) ~= mode(Idx(101:end)));
kmeans_error_rate = (error1 + error2) / size(data, 1);

% Display 2D error rates
disp(['2D Error rate for group 1: ', num2str(error1/100)]);
disp(['2D Error rate for group 2: ', num2str(error2/100)]);
disp(['2D Total error rate: ', num2str(kmeans_error_rate)]);

% Create 3D data
data3D = [data, vecnorm(data, 2, 2).^2];

% K-means clustering in 3D
[Idx3D, ~] = myKmeans(data3D, k, max_iterations);

% Calculate error rates in 3D
error1_3D = sum(Idx3D(1:100) ~= mode(Idx3D(1:100)));
error2_3D = sum(Idx3D(101:end) ~= mode(Idx3D(101:end)));
kmeans_error_rate_3D = (error1_3D + error2_3D) / size(data, 1);

% Display 3D error rates
disp(['3D Error rate for group 1: ', num2str(error1_3D/100)]);
disp(['3D Error rate for group 2: ', num2str(error2_3D/100)]);
disp(['3D Total error rate: ', num2str(kmeans_error_rate_3D)]);

% Plot 2D clusters
figure;
gscatter(data(:, 1), data(:, 2), Idx);
title('K-means Clustering in 2D');
xlabel('X');
ylabel('Y');

% Plot 3D clusters
figure;
scatter3(data3D(:, 1), data3D(:, 2), data3D(:, 3), 15, Idx3D, 'filled');
title('K-means Clustering in 3D');
xlabel('X');
ylabel('Y');
zlabel('Z');

%  K-means function
function [idx, centroids] = myKmeans(data, k, max_iterations)
    [m, n] = size(data);
    centroids = data(randperm(m, k), :); 
    idx = zeros(m, 1);

    for iteration = 1:max_iterations
        old_centroids = centroids;

        % Assign each data point to the closest centroid
        for i = 1:m
            [~, idx(i)] = min(vecnorm(data(i,:) - centroids, 2, 2));
        end

        % Recalculate centroids
        for i = 1:k
            centroids(i, :) = mean(data(idx == i, :), 1);
        end

        if old_centroids == centroids
            break;
        end
    end
end
