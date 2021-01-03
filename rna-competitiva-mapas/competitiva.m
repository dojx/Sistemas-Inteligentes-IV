close all;
clear; clc;

%% Cargar datos
% Archivo
% load data.mat
% x = data;

% Mis datos
x1 = [rand(1, 20) - 2.25; rand(1, 20) - 2.25];
x2 = [rand(1, 20) - 0.75; rand(1, 20) - 0.75];
x3 = [rand(1, 20) + 0.75; rand(1, 20) + 0.75];
x4 = [rand(1, 20) + 2.25; rand(1, 20) + 2.25];
x = [x1 x2 x3 x4];

%% Inicializacion
M = 4; % Numero de neuronas
[P, K] = size(x); % Tamano de entradas

eta = 0.1; % Factor de aprendizaje

w = randn(P, M); % Matriz de pesos
h = zeros(M, 1); % Vector para guardar valores de h
ys = zeros(M, K); % Matriz para guardar salidas de la red

epocas = 200; % Numero de epocas o iteraciones

for g = 1 : epocas
    for i = 1 : K
        % Calcular h
        for j = 1 : M
            h(j) =  w(:, j)'*x(:, i) - (1/2)*(w(:, j)'*w(:, j));
        end
        
        % Salida de la red
        [mx, r] = max(h);
        y = zeros(M, 1);
        y(r) = 1;
        
        % Si es la ultima iteracion, guardar las salidas
        if g == epocas
            ys(:, i) = y;
        end
        
        % Actualizacion de pesos
        w(:, r) = w(:, r) + eta*(x(:, i) - w(:, r));
    end
end

%% Graficas de clasificaciones
% Grupo 1
plot(w(1, 1), w(2, 1), 'rs', 'MarkerSize', 6, 'LineWidth', 2)
hold on
grid on
plot(x(1, ys(1, :) == 1), x(2, ys(1, :) == 1), 'ro', 'MarkerSize', 6, 'LineWidth', 2)

% Grupo 2
plot(w(1, 2), w(2, 2), 'gs', 'MarkerSize', 6, 'LineWidth', 2)
plot(x(1, ys(2, :) == 1), x(2, ys(2, :) == 1), 'go', 'MarkerSize', 6, 'LineWidth', 2)

% Grupo 3
plot(w(1, 3), w(2, 3), 'bs', 'MarkerSize', 6, 'LineWidth', 2)
plot(x(1, ys(3, :) == 1), x(2, ys(3, :) == 1), 'bo', 'MarkerSize', 6, 'LineWidth', 2)

% Grupo 4
plot(w(1, 4), w(2, 4), 'ms', 'MarkerSize', 6, 'LineWidth', 2)
plot(x(1, ys(4, :) == 1), x(2, ys(4, :) == 1), 'mo', 'MarkerSize', 6, 'LineWidth', 2)

% Graficar todos los puntos
plot(x(1, :), x(2, :), 'k*', 'MarkerSize', 6)
legend('Neurona 1', 'Grupo 1', 'Neurona 2', 'Grupo 2', 'Neurona 3', 'Grupo 3', 'Neurona 4', 'Grupo 4')
legend('Location', 'northwest')
title('Competitiva')