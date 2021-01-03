%% Actividad 4 - Adaline
% Nombre: Diego Omar Jimenez Navarro
% Codigo: 213526346

%% Main
close all; clear; clc;

n = input('Elige un Adaline:\n 1. data1.mat\n 2. data2.mat\n 3. data3.mat\n 4. data4.mat\n 5. data5.mat\n');
ada = adaline(n);
[ada, it] = clasico(ada);
plot_adaline(ada)

%% Funciones
% Crear un adaline (estructura)
function ada = adaline(n)
    ada.eta = 0.000001; % Factor de aprendizaje
    switch n
        case 1 % data1.mat
            data = load('data_1.mat');
        case 2 % data2.mat
            data = load('data_2.mat');
        case 3 % data3.mat
            data = load('data_3.mat');
        case 4 % data4.mat
            data = load('data_4.mat');
        case 5 % data5.mat
            data = load('data_5.mat');
        otherwise
            disp('Opcion invalida');
    end
    p = 5;
    ada.w = rand(p + 1, 1) * 0.2 - 0.1; % Pesos aleatorios (bias, w1)
    [ada.x, ada.d] = crear_entradas(data.V, p);
    ada.predicciones = zeros(1, length(data.V) - p);
end

% Preparar entradas en una matriz
function [x, d] = crear_entradas(V, p)
    x = zeros(p, length(V) - p);
    for i = 1 : length(V) - p
        x(:, i) = V(i : p + i - 1); 
    end
    d = V(p + 1 : end);
end

% Entrenamiento clasico
function [ada, it] = clasico(ada)
    n = size(ada.x, 2); % Numero de entradas
    it = 0; % Numero de iteraciones que han pasado
    
    % Correr hasta se completen todas las iteraciones
    while it < n * 3
        % Concatena 1 a la entrada, para el bias
        x = [1; ada.x(:, mod(it, n) + 1)]; 
        y = dot(x, ada.w(:, end)); % Salida de funcion de activacion
        ada.predicciones(mod(it, n) + 1) = y;
        
        err = ada.d(mod(it, n) + 1) - y; % Calcular error
        
        % Actualizar los pesos y guardar los valores
        ada.w = ada.w + (ada.eta * err * x);
        it = it + 1; % Incrementar iteraciones
    end
end

%% Funciones para plotear
% Plotear puntos
function plot_adaline(p)
    figure
    hold on
    plot(p.x(1, :), 'b')
    plot([zeros(1, 5) p.predicciones], 'g', 'LineWidth', 1.5)
end