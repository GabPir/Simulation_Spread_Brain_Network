clear all
close all
clc

% Caricamento matrice
currentFilePath = mfilename('fullpath'); 
currentFolder = fileparts(currentFilePath); 
cd(currentFolder);
L_path = fullfile(currentFolder,'matrici', 'L_matrix.csv');
L = importdata(L_path);

Nnodi = length(L);

% Parametri differenze finite
Amax = 30; % Lunghezza del dominio eta'†
T = 30; % Tempo totale
Na = 1200; % Numero di punti eta'†
Nt = 1200; % Numero di passi temporali
da = Amax / Na; % Passo et√†
dt = T / Nt; % Passo temporale
a = linspace(0, Amax, Na); % Griglia eta'
t = linspace(0, T, Nt); % Griglia temporale


% Parametri equazione
beta = 1.7; % parametro di clearance
alpha = 0.00004; % coefficiente diffusione
r_max = 4.2; % coefficiente massima crescita
a0 = 0;

eps = 10^(-6);
% Condizione iniziale
u1_0 = @(a) 0.006 * (a < 5.5);     % Condizione iniziale nodi con proteine
u2_0 = @(a) 0+eps; % Condizione iniziale nodi senza proteina

% Inizializzazione soluzini array tridimensionale soluzioni
U = zeros(Nt, Na, Nnodi);
for k = 1:Nnodi
    U(1, :, k) = 0;
end
U(1, :, 26) = u1_0(a(:));
U(1, :, 66) = u1_0(a(:));

% Definizione della velocita'†
v = @(a) 1;

% Condizioni al bordo Dirichlet 
uL = 0; 
 


% Loop temporale per la soluzione
for n = 1:Nt-1

    Utot = trapz(a(:), U(n,:,k));
            
    for i = 2:Na-1
        % Step differenze finite
        for k = 1: Nnodi
            U(n+1, i, k) = U(n, i,k) -  (1 * dt / (2 * da)) * (U(n, i+1,k) - U(n, i-1,k)) + (1 * dt^2 / (2 * da^2)) * (U(n, i+1,k) - 2 * U(n, i,k) + U(n, i-1,k)) ...
                + dt * (1/(sqrt(1+a(i))))*(-beta*U(n, i, k)*(1-Utot) - alpha*L(k,:) * squeeze(U(n, i, :)));
            if U(n+1, i, k) < 0
                U(n+1, i, k) = 0;
            end
        end 
        
    end
    % Condizioni al bordo per Dirichlet
    % Per usare la formula del trapezio sono necessari piu' di due nodi,
    % separiamo i due casi
    t_oldest = min(n, Na);
    f = zeros(1,t_oldest);
    if t_oldest == 1
        for k = 1:Nnodi 
            U(n+1, 1, k) = U(n, 1, k);
        end

    else  
        for k = 1:Nnodi
            % calcoliamo il totale di u
            Utot = trapz(a(:), U(n,:,k));
            

            for i = 1:t_oldest
                   f(i) = r_max/(1+exp((-a(i))))*(1-Utot/1)*U(n,i,k);
            end
            
            U(n+1, 1, k) = trapz(a(1:t_oldest), f);
         end
    end    

    % Condizioni al bordo destro (Neumann)
    U(n+1, end, :) = U(n+1, end-1, :); 
end



% Visualizzazione delle soluzioni
figure(1);
subplot(1,2,1);
surf(a, t, U(:, :, 26));
shading interp;
xlabel('et√†');
ylabel('Tempo');
zlabel('u1(x,t)');
title('Soluzione nodo iniziale');

figure(1);
subplot(1,2,2);
surf(a, t, U(:, :, 3));
shading interp;
xlabel('Et√†');
ylabel('Tempo');
zlabel('u1(x,t)');
title('Soluzione nodo periferico');



totTau = zeros(1,Nnodi);
newTau = zeros(1,Nnodi);
medTau = zeros(1,Nnodi);
oldTau = zeros(1,Nnodi);

% valori totali proteine in ogni nodo al tempo t finale
for k = 1:Nnodi
    totTau(k) = trapz(a(:), U(end-1,:,k));

end



