% The file will model neurons which fire depending on the orientation (angle, radians) of
% the stimuli. 

clear all

%% 1.0 
% Parameters
c = 0; % Contrast of stimuli
epsilon = 0; % Selectiviy of the input 
N = 50; % Number of nuerons 

%% 1.1 Define function
function out = h_input(theta0, theta, c, epsilon)

    out = c*((1-epsilon) + epsilon * cos(2*(theta-theta0)));

end
theta = linspace(-pi/2, pi/2, 50);

%% 1.2 Plot with theta0 = 0, c = 3, epsilon = 0.1
% Parameters 
theta0 = 0;
c = 3;
epsilon = 0.1;

% Output
h = h_input(theta0, theta, c, epsilon);

% Plot
fig = figure('Visible', 'off'); % Create an invisible figure
scatter(theta, h,"filled");
xlabel("Neurons preferred orientatio");
ylabel("Magnitude of the input");
exportgraphics(gcf, "1-2.png", 'Resolution', 300);

%% 1.3 Inputs are non-linearly filtered given a function g 

% Define function
function g = g_function(h, T, beta)

    g = zeros(size(h));
    g(h <= T) = 0;  % Function for h < T
    g(h > T & h <= T + 1/beta) = beta * (h(h > T & h <= T + 1/beta)-T);
    g(h > T + 1/beta) = 1;

end

% Parameters to plot
T = 0;
beta = 0.1;
h = linspace(-15,15);
g = g_function(h, T, beta);

%% 1.4 Plot 1.3 with parameters
% Plot
% fig = figure('Visible', 'off'); % Create an invisible figure
scatter(h, g,"filled");
xlabel("h");
ylabel("g");
exportgraphics(gcf, "1-4.png", 'Resolution', 300);

%% 2.1 Rate based neurons 

% Parameters
tau = 5e-3; % Time constant
step = 1e-3; % Time step
T = 0;
beta = 0.1;
h = linspace(-15,15);
g = g_function(h, T, beta);

% Function
function m = m_function(g, step, tau)
    
    % Define placeholder for m
    size_g = size(g);
    m = zeros(size_g);

    % Loop over 100ms
    for i = 1:size_g(2)-1

        % Eulers function
        m(i+1) = m(i) + step/tau * (-m(i) + g(i));

    end 
end

m = m_function(g, step, tau);

% Plot
scatter(h,m, "filled");
xlabel("Input h")
ylabel("Activity (m)")
exportgraphics(gcf, "2-1.png", 'Resolution', 300);

%% 2.2 Orientation Tuning 
% This scenerio describes the firing when the only source of input is the
% thalamus; there is no connection between neurons 

% Parameters
N = 50;
Ni = 30;
theta_0 = 0;
m_0 = m; % Initial activity
epsilon = 0.9;
c = 1.5;

function activity = network_activity(N, Ni, theta_0, m_0, epsilon, c)

    theta = linspace(-pi/2, pi/2, N);
    h = h_input(theta_0, theta, c, epsilon);
    g = g_function(h, 0, 0.1);
    m = m_function(g, 1e-3, 1e-5);

    time_axis = size(m, 2) * Ni;
    


    
end

n_activity = network_activity(N, Ni, init_activity, epsilon, c);
n_activity_scaled_100 = n_activity * 100;