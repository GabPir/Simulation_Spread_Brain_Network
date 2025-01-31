clear all
close all
clc

% Get the path
currentFilePath = mfilename('fullpath'); 
currentFolder = fileparts(currentFilePath); 

cd(currentFolder);

L_path = fullfile(currentFolder, 'matrici', 'L_matrix.csv');
L = importdata(L_path);


%% General parameters
t0 = 0;            % Initial time
Tmax = 30;         % Final time
time = 365*Tmax; 
dt = 1;            % 1 day


% Initial condition
eps = 10^(-6);
y0 = zeros(81, 1)+eps;     % To avoid initial instabilities (negative values)

alpha = 0.0027;    % Growth rate
init = 0.001;       % Node where the disease begins, elsewhere ~ 0
y0(26) = init;      % Right entorhinal    
y0(66) = init;      % Left entorhinal        

k = 0.00001;   %Constant to regulate the diffusion term




%%%%%%%%%%%%%%%%
%% Runge-Kutta%%
%%%%%%%%%%%%%%%%

t_eval = t0:dt:time;            %point is which we want the solution to be evalueated
options = odeset('RelTol',1e-6, 'AbsTol',1e-8);


%[T_RK, y_RK] = ode23s(@(t, y) FisherKolmogorovFun(y, alpha, L, k), t_eval, y0, options);
[T_RK, y_RK] = ode45(@(t, y) FisherKolmogorovFun(y, alpha, L, k), t_eval, y0, options);


%% Plot results (in years)

n_years = Tmax;
num_ticks = 6;   %Every 5 years
t_subset = 365 * n_years;    
T_RK_sub = T_RK(1:t_subset);    %If we want to plot less year

figure;
hold on;
%title('Runge-Kutta');

for i = 1:size(y_RK, 2)
    y_node = y_RK(1:t_subset, i);
    plot(T_RK_sub / 365, y_node);  
end

xlabel('Time (Years)'); 
ylabel('Concentration');
ylim([0 1+0.005]);

tick_positions = 0:5:max(T_RK_sub)/365+1; 

set(gca, 'XTick', tick_positions);
set(gca, 'XTickLabel', num2str(tick_positions', '%.1f'));

hold off;


%% Plot with special labels (entorhinal nodes)

n_years = Tmax;
num_ticks = 6;   %Every 5 years
t_subset = 365 * n_years;    
T_RK_sub = T_RK(1:t_subset);    %If we want to plot less year

figure;
hold on;

%title('Runge-Kutta');

% Nodes of interest
nodes_of_interest = [26, 66]; 


label_offsets = [0.01, -0.05]; 
for i = 1:size(y_RK, 2)
    y_node = y_RK(1:t_subset, i);
    if ismember(i, nodes_of_interest)
        plot(T_RK_sub / 365, y_node, 'LineWidth', 2);
        
        node_idx = find(nodes_of_interest == i);
        text(T_RK_sub(end) / 365, y_node(end) + label_offsets(node_idx), ...
            sprintf('Node %d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    else
        plot(T_RK_sub / 365, y_node, 'Color', [0.8, 0.8, 0.8]);
    end
end

xlabel('Time (Years)'); 
ylabel('Concentration');
ylim([0 1+0.005]);


tick_positions = 0:5:max(T_RK_sub)/365+1; 

set(gca, 'XTick', tick_positions);
set(gca, 'XTickLabel', num2str(tick_positions', '%.1f'));

hold off;






%% Save node states every year

n_years = Tmax;
t_subset = 365 * n_years;    
T_RK_sub = T_RK(1:t_subset);    %If we want to plot less year

year_end_indices = 365:365:t_subset;

targetFolder = fullfile(currentFolder, 'dati', 'Fisher-Kolmogorov', 'RK', 'kol');
if ~exist(targetFolder, 'dir')
    mkdir(targetFolder);
end

for year = 1:n_years
    index = year_end_indices(year);
    year_data = y_RK(index, :);
    fileID = fopen(fullfile(targetFolder, sprintf('node_states_year_%d.txt', year)), 'w');
    fprintf(fileID, '%f\n', year_data);
    fclose(fileID);
end



%% Save node states from 5 to 20 years every 1/2 year (more detailed info)
n_years = Tmax;
t_subset = 365 * n_years;    
T_RK_sub = T_RK(1:t_subset);    %If we want to plot less year

start_year = 5;  
end_year = 20;   
increment = 1/2;

targetFolder = fullfile(currentFolder, 'dati', 'Fisher-Kolmogorov', 'RK', 'kol');
if ~exist(targetFolder, 'dir')
    mkdir(targetFolder);
end

for year = start_year:increment:end_year
    index = round(year * 365); 
    year_data = y_RK(index, :);  
    
    file_name = sprintf('node_states_year_%.1f.txt', year);
    
    fileID = fopen(fullfile(targetFolder, file_name), 'w');
    fprintf(fileID, '%f\n', year_data);
    fclose(fileID);
end





%{
%%%%%%%%%%%%%%%%%%%%
%% Euler Implicit %%
%%%%%%%%%%%%%%%%%%%%
[T_I, y_I] = EuleroImplicitFisherKolmogorov(time, y0, dt, alpha, L, k);


%% Plot results (in years)

n_years = Tmax;
num_ticks = 6;   %Every 5 years
t_subset = 365 * n_years;    
T_I_sub = T_I(1:t_subset);    %If we want to plot less years

figure;
hold on;
%title('Euler');

for i = 1:size(y_I, 2)
    y_node = y_I(1:t_subset, i); 
    plot(T_I_sub / 365, y_node);  
end

xlabel('Time (Years)');
ylabel('Concentration');
ylim([0 1+0.005]);  

tick_positions = 0:5:max(T_I_sub)/365+1;  
set(gca, 'XTick', tick_positions);
set(gca, 'XTickLabel', num2str(tick_positions', '%.0f'));  

hold off;



%% Plot with special labels (entorhinal nodes)
n_years = Tmax;
num_ticks = 6;   %Every 5 years
t_subset = 365 * n_years;    
T_I_sub = T_I(1:t_subset);    %If we want to plot less years

figure;
hold on;
%title('Euler');

nodes_of_interest = [26, 66]; % Nodes of interest

label_offsets = [0.01, -0.05]; 
for i = 1:size(y_I, 2)
    y_node = y_I(1:t_subset, i);
    if ismember(i, nodes_of_interest)
        plot(T_I_sub / 365, y_node, 'LineWidth', 2); 
        
        node_idx = find(nodes_of_interest == i);
        text(T_I_sub(end) / 365, y_node(end) + label_offsets(node_idx), ...
            sprintf('Node %d', i), ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    else
        plot(T_I_sub / 365, y_node, 'Color', [0.8, 0.8, 0.8]);
    end
end

xlabel('Time (Years)');
ylabel('Concentration');
ylim([0 1+0.005]);

min_year = min(T_I_sub) / 365;
max_year = max(T_I_sub) / 365;
tick_positions = linspace(min_year, max_year, num_ticks);

set(gca, 'XTick', tick_positions);
set(gca, 'XTickLabel', num2str(tick_positions', '%.1f')); 

hold off;



%% Save node states every year
n_years = Tmax;
t_subset = 365 * n_years;    
T_I_sub = T_I(1:t_subset); 

year_end_indices = 365:365:t_subset;

targetFolder = fullfile(currentFolder, 'dati', 'Fisher-Kolmogorov', 'EI', 'kol');
if ~exist(targetFolder, 'dir')
    mkdir(targetFolder);
end

for year = 1:n_years
    index = year_end_indices(year);
    year_data = y_I(index, :);
    fileID = fopen(fullfile(targetFolder, sprintf('node_states_year_%d.txt', year)), 'w');
    fprintf(fileID, '%f\n', year_data);
    fclose(fileID);
end



%% Save node states from 5 to 20 years every 1/2 year (more detailed info)
n_years = Tmax;
t_subset = 365 * n_years;    
T_I_sub = T_I(1:t_subset);   

start_year = 5;  
end_year = 20;   
increment = 1/2;  

targetFolder = fullfile(currentFolder, 'dati', 'Fisher-Kolmogorov', 'EI', 'kol');
if ~exist(targetFolder, 'dir')
    mkdir(targetFolder);
end

for year = start_year:increment:end_year
    index = round(year * 365); 
    year_data = y_I(index, :);  
    
    file_name = sprintf('node_states_year_%.1f.txt', year);
    
    fileID = fopen(fullfile(targetFolder, file_name), 'w');
    fprintf(fileID, '%f\n', year_data);
    fclose(fileID);
end

%}
