clear all
close all
clc

% Caricamento matrice
currentFilePath = mfilename('fullpath'); 
currentFolder = fileparts(currentFilePath); 
cd(currentFolder)

Path = fullfile(currentFolder,'dati','Age-Structured', 'pop.mat');
data = load(Path);
fieldnames(data)
U = data.U;
U(U < 0) = 0;


[time_steps, age_steps, num_nodes] = size(U);  

y_tot = zeros(time_steps, num_nodes);     

a = linspace(0, 30, age_steps);

% Integrale in da
for k = 1:num_nodes
    for t = 1:time_steps
        y_tot(t,k) = trapz(a(:), U(t,:,k));
    end
end


n_year = 30;
n_steps_in_a_year = round(time_steps/n_year);



targetFolder = fullfile(currentFolder, 'dati', 'Age-Structured', 'pop');
if ~exist(targetFolder, 'dir')
    mkdir(targetFolder);
end



year_end_indices = n_steps_in_a_year:n_steps_in_a_year:(n_year * n_steps_in_a_year);
for year = 1:n_year
    index = year_end_indices(year);
    year_data = y_tot(index, :);
    fileID = fopen(fullfile(targetFolder, sprintf('node_states_year_%d.txt', year)), 'w');
    fprintf(fileID, '%f\n', year_data);
    fclose(fileID);
end


start_year = 5;
end_year = 30;
increment = 0.5;
for year = start_year:increment:end_year
    index = round(year * n_steps_in_a_year); 
    year_data = y_tot(index, :);  
    
    file_name = sprintf('node_states_year_%.1f.txt', year);
    
    fileID = fopen(fullfile(targetFolder, file_name), 'w');
    fprintf(fileID, '%f\n', year_data);
    fclose(fileID);
end


t = linspace(0, 30, time_steps);
a = linspace(0, 30, age_steps);


% Visualizzazione delle soluzioni
figure(1);
subplot(1,2,1);
surf(a, t, U(:, :, 26));
shading interp;
xlabel('Age','FontSize', 14);
ylabel('Time', 'FontSize', 14);
zlabel('Concentration', 'FontSize', 14);
title('Initial node solution', 'FontSize', 16);

figure(1);
subplot(1,2,2);
surf(a, t, U(:, :, 3));
shading interp;
xlabel('Age', 'FontSize', 14);
ylabel('Time', 'FontSize', 14);
zlabel('Concentration', 'FontSize', 14);
title('Peripheral node solution', 'FontSize', 16);




hold off


%% Plot results over the years

T_considerato = time_steps; 
N_anni = 30;

figure;
hold on;

for i = 1:size(y_tot, 2)
    y_node = y_tot(1:T_considerato, i);
    plot(1:T_considerato, y_node);      
end


xlabel('Time (Years)');
ylabel('Concentration');
ylim([0 1.005]);  

num_ticks = N_anni / 4; 

tick_positions = linspace(0, N_anni, num_ticks);

set(gca, 'XTick', linspace(1, T_considerato, num_ticks));  
set(gca, 'XTickLabel', num2str(tick_positions', '%.1f'));  

hold off;