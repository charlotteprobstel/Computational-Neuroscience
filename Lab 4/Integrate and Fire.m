%Integrate and Fire Model
clear all

% Variables
tau_v = 0.01;
R = 1;
tau_threshold = 10;

% Axis
step = 0.001;
time_axis = 0:step:0.1;

% Parameters
I = [9 11 15];

% Function
function [v] = voltage(tau_v, R, I, tau_threshold, step)
    
    % Define placeholder for voltage 
    v = zeros(100,1);

    % Loop over 100ms
    for i = 1:100

        % Check that the voltage is below the threshold
        if v(i) >= tau_threshold
            v(i+1) = 0;
        
        % Otherwise, add to the voltage
        else
            v(i+1) = v(i) + step/tau_v * (-v(i) + R*I);
        end
    end 
end

v = voltage(tau_v, R, 9, tau_threshold, step);


% Plot all the functions
for i = 1:3
    y = voltage(tau_v, R, I(i), tau_threshold, step);
    plot(time_axis, y);
    hold on
end

% Plot details
legend("I = 9", "I = 11", "I = 15")
title("Voltage across a membrane depending on the constant current")
xlabel("Time / s")
ylabel("Voltage / V")
saveas(gcf,"Integrate and Fire Model - Eueler.png")

%%Comments
% The higher the current, the faster the neuron reaches the threshold
% The higher the current, the higher the firing rate
% At a current of 9 amps, the neuron never reaches the threshold.

