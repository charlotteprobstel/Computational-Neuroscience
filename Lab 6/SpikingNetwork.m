% Defining network model parameters
vt = 1;                     % Spiking threshold
tau_m = 10;                 % Membrane time constant [ms]
g_m = 1;                    % Neuron conductance
Nsig = 0.25;                   % Variance amplitude of current
Nmean = 0.75;                % Mean current to neurons
tau_I = 10;                 % Time constant to filter the synaptic inputs
N = 500000;                   % Number of neurons in total
NE = 0.5*N;                 % Number of excitatory neurons
NI = 0.5*N;                 % Number of inhibitory neurons
dt = 1;                     % Simulation time bin [ms]
T = 300/dt;                 % Simulation length 
W = 2/sqrt(N);                  % Connectivity strength

% Initialization
rng(100);
v = rand(N,1)*vt;           % membrane potential
vv = zeros(N,1);            % variable that notes if v crosses the threshold
Iback = zeros(N,1);         % building up the external current
SP = 0;                     % recording spike times
Ichem = zeros(N,1);         % current coming from synaptic inputs
Iext = zeros(N,1);     % external current
raster = [];                % save spike times for plotting

% loop over the time
for t = 1:T
    Iback = Iback + dt/tau_I*(-Iback +randn(N,1));          % generate a colored noise for the current
    Iext = Iback/sqrt(1/(2*(tau_I/dt)))*Nsig+Nmean;         % rescaling the noise current to have the correct mean and variance

    Ichem(1:NE) = Ichem(1:NE) + dt/tau_I*(-Ichem(1:NE) + W*(sum(vv(1:NE))-vv(1:NE))-W*(sum(vv(NE+1:end)))); % current to excitatory neurons coming from the synaptic inputs
    Ichem(NE+1:end) = Ichem(NE+1:end) + dt/tau_I*(-Ichem(NE+1:end) -W*(sum(vv(NE+1:end))-vv(NE+1:end))+W*(sum(vv(1:NE)))); % current to inhibitory neurons coming from the synaptic inputs
    Itot = Iext+Ichem;
    %%%%%%%%%%% To insert integrate-and-fire model here  %%%%%%%%%%%%%
    v= v+ dt./tau_m.*(-g_m*v+Itot); % IF neuron model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % save the incoming synaptic current of neuron 1
    sample_syn_current(1,t) = Ichem(1);

    % Inserting an extra spike for Step 4
    %if t == 200
        %v(200:201)= vt;
    %end

    vv =(v>=vt);  % spike if voltage crosses the threshold
    
    v = (1-vv).*v;                                      % reset after spike
    SP = find(vv);                                      % find the spike times
    raster=[raster;t*ones(length(SP),1),SP];            % save spike times for plotting
end

% Plot the raster output
% h = figure; hold on;
% plot(raster(:,1)*dt, raster(:,2),'.b')
% xlim([100 300])
% xlabel('time [ms]','fontsize',20)
% ylabel('neuron index','fontsize',20)
% set(gca,'fontsize',20);
% set(gca,'YDir','normal');
% saveas(gcf,"Figure 6.4.2 - Adding an extra spike at t = 200.png")

%% STEP 4 
% % raster_old = raster
% h = figure; hold on;
% plot(raster_old(:,1)*dt, raster_old(:,2),'.b')
% plot(raster(:,1)*dt, raster(:,2),'.r')
% xlim([150 300])
% xlabel('time [ms]','fontsize',20)
% ylabel('neuron index','fontsize',20)
% set(gca,'fontsize',20);
% set(gca,'YDir','normal')
% saveas(gcf,"Figure 6.4 - Adding an extra spike at t = 200.png")

%% STEP 5 
% Plot the incoming synaptic current

% plot(sample_syn_current,'b')
% xlim([100 300])
% xlabel('time [ms]','fontsize',20)
% ylabel('incoming synaptic current','fontsize',20)
% set(gca,'fontsize',20);
% set(gca,'YDir','normal')

%Save the synaptic currents for each run, as you vary N. Uncomment and
%comment lines depending on which N you are using on this network run.
%syn_current_N_500 = sample_syn_current;
%syn_current_N_5000 = sample_syn_current;
%syn_current_N_50000 = sample_syn_current;
%syn_current_N_500000 = sample_syn_current;


%In order to plot numerous currents on a single plot as N is varied, run
%the script as you vary N while saving the relevant syn_current_N_XXXX
%(above). Then plot the below figure, for weights scaled either by 1/N or
%1/sqrt(N). 
h = figure; hold on;
plot(syn_current_N_500);
plot(syn_current_N_5000);
plot(syn_current_N_50000);
plot(syn_current_N_500000);
xlim([100 300])
xlabel('time [ms]','fontsize',20)
ylabel('incoming synaptic current','fontsize',20)
set(gca,'fontsize',20);
set(gca,'YDir','normal')
legend('N=500','N=5000','N=50000','N=500000')
saveas(gcf, "Figure 6.6 - N changes and scaled by 1 div sqrt of N.png")