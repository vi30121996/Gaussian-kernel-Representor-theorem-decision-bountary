% Load the data
load('data32.mat');

% Assign numerical labels
labels = [ones(size(stars,1), 1); -ones(size(circles,1), 1)];

% Concatenate the data
data = [stars; circles];

% Gaussian kernel function
GaussianKernel = @(x, y, h) exp(-1/h * sum((x - y).^2));

% Set the specific values for h and lambda
h = 0.1;
lambda = 1;

% Initialize kernel matrix
K = zeros(size(data,1));

% Compute kernel matrix
for i = 1:size(data,1)
    for j = 1:size(data,1)
        K(i,j) = GaussianKernel(data(i,:), data(j,:), h);
    end
end

% Alpha
alpha = (K + lambda * eye(size(K))) \ labels;

% Grid for contour plot
[x1_range, x2_range] = meshgrid(min(data(:,1)):0.01:max(data(:,1)), min(data(:,2)):0.01:max(data(:,2)));

% Compute the function values on the grid
Z = zeros(size(x1_range));
for i = 1:size(x1_range,1)
    for j = 1:size(x1_range,2)
        x_new = [x1_range(i,j), x2_range(i,j)];
        for k = 1:size(data,1)
            Z(i,j) = Z(i,j) + alpha(k) * GaussianKernel(x_new, data(k,:), h);
        end
    end
end

% Plot the decision boundary
figure;
contour(x1_range, x2_range, Z, [0 0], 'k', 'LineWidth', 2); hold on;

% Plot the data points
scatter(stars(:,1), stars(:,2), 'b', 'filled'); hold on;
scatter(circles(:,1), circles(:,2), 'g', 'filled'); hold on;

% Generate a random new point
x1_min = min(data(:,1));
x1_max = max(data(:,1));
x2_min = min(data(:,2));
x2_max = max(data(:,2));
x_new = [x1_min + (x1_max - x1_min) * rand(), x2_min + (x2_max - x2_min) * rand()];

% New point categorization
phi_hat_x_new = zeros(size(data,1), 1);
for k = 1:size(data,1)
    phi_hat_x_new(k) = alpha(k) * GaussianKernel(x_new, data(k,:), h);
end

if sum(phi_hat_x_new) > 0
    disp('New point is categorized as a "star"');
    scatter(x_new(1), x_new(2), 'r', 'filled'); % Plot the new point in red
else
    disp('New point is categorized as a "circle"');
    scatter(x_new(1), x_new(2), 'm', 'filled'); % Plot the new point in magenta
end

% Format the plot
title(['Decision boundary (h=', num2str(h), ', λ=', num2str(lambda), ')']);
xlabel('x1');
ylabel('x2');
legend('Decision boundary', 'Stars', 'Circles', 'New Point');
