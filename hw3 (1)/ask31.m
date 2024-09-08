% Number of random variables
N = 1000;

% Random variables uniformly distributed in [0, 1]
x_rand = rand(N,1);

% Bandwidths
h_values = [0.001, 0.004, 0.01, 0.1];  % reduced h values

% Plotting range
x = -0.5:0.01:1.5;

% Create figure
figure;

% Define colors
colors = ['r', 'g', 'b', 'm'];

% Loop over bandwidths
for i = 1:length(h_values)
    h = h_values(i);
    
    % Initialize density estimate
    f = zeros(size(x));
    
    % Loop over random variables
    for j = 1:N
        % Gaussian kernel with your definition
f = f + (1/(sqrt(2*pi*h)))*exp(-((x-x_rand(j)).^2)/(2*h));
    end
    
    % Normalize
    f = f / N;
    
    % Plot with specific color
    plot(x, f, colors(i), 'DisplayName', ['h = ' num2str(h)]);
    
    hold on;
end

% Labeling
xlabel('x');
ylabel('Density');
legend('show');

hold off;
