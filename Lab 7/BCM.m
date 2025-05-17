clear all
% Params

N = 2;                      % number of inputs
T = 10^4;                   % time of simulations
dt = 1;                     % simulation time step
alpha_w = 10^(-6);          % learning rate for weights
ytarget = 10;               % output target 
x = [20,0;0,20];            % inputs have two patterns one (0-20) and two (20-0)
tau_theta = 50;             % time constant for theta

% Init
y = zeros(1,T);             % output
w = 0.5*ones(N,T);          % weights
theta = 5*ones(1,T);        % sliding threshold theta

% Simul
for t = 1:T-1
    p = round(rand)+1;                                                       % presentation of pattern 1 or 2 randomly
    y(t) = w(:,t)'*x(:,p);                                                   % compute the output
    theta(t+1) = theta(t)+dt/tau_theta*(y(t)^2/ytarget - theta(t));          % update sliding theshold
    w(:,t+1) = w(:,t) + alpha_w*x(:,p)*y(t)*(y(t)-theta(t));                 % update of the weights
    w(:,t+1) = (w(:,t+1)>0).*w(:,t+1);                                       % weigths can't be negative: hard bound at zero
end

% Plot
figure;subplot(3,1,1);plot(w'); ylabel('w');
subplot(3,1,2); plot(theta); ylabel('\theta')
subplot(3,1,3); plot(y(1:t-1), '.'); ylabel('y');xlabel('time')