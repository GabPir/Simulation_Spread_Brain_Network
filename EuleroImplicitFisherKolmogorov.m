function [t,y] = EuleroImplicitFisherKolmogorov(time, y0, dt, alpha, L, k)

% Eulero Implicit, Fisher-Kolmogorov equation
% y' = alpha * y * (1 - y) - L * y    % -L (instead of +L)
% y(t0) = y0

% Inizializzazione
m = round((time - 0) / dt); % Number of temporal steps
n = length(y0);     % Number of nodes
y = zeros(n,m);     % Solution matrix
t = zeros(1, m);    % Time vector
y(:, 1) = y0;       % Initial condition (1 in a specific node, 0 in elsewhere)
t(1) = 0;           % Initial time 0

% Implementation
for i = 1:m-1
    t(i+1) = t(i) + dt; 
    fun = @(yy) yy - y(:, i) - dt * (alpha * yy .* (1 - yy) - k* L * yy);    % -L      
    
    options = optimoptions('fsolve', 'Display', 'off', 'TolFun', 1e-6, 'TolX', 1e-6, 'MaxIterations', 10000);
    y(:, i+1) = fsolve(fun, y(:, i));     % Solving iteratively
end

y = y';
t = t';
end
