%% Actividad 2
% Nombre: Diego Omar Jimenez Navarro
% Codigo: 213526346

%% Main
close all; clear; clc;

n = input('Elige un Adaline:\n 1. data1.mat\n 2. data2.mat\n');
p = adaline(n);
n = input('Elige el tipo de entrenamiento:\n 1. Clasico\n 2. Evolutivo (PSO)\n');
[p, it] = entrenar(p, n);
plot_adaline(p, it)

%% Funciones
% Crear un perceptron (estructura)
function p = adaline(n)
    p.eta = 0.01; % Factor de aprendizaje
    switch n
        case 1 % data1.mat
            data = load('data1.mat');
            p.w = rand(2, 1) * 10 - 5; % Pesos aleatorios (bias, w1)
        case 2 % data2.mat
            data = load('data2.mat');
            p.w = rand(3, 1) * 10 - 5; % Pesos aleatorios (bias, w1, w2)
        otherwise
            disp('Opcion invalida');
    end
    p.x = data.X;
    p.d = data.D;  
end

% Entrenar
function [p, it] = entrenar(p, n)
    switch n
        case 1
            [p, it] = clasico(p);
        case 2
            [p, it] = evolutivo(p);
        otherwise
            disp('Opcion invalida');
    end
end

% Entrenamiento clasico
function [p, it] = clasico(p)
    n = size(p.x, 2); % Numero de entradas
    it = 0; % Numero de iteraciones que han pasado
    
    % Correr hasta se completen todas las iteraciones
    while it < 40000
        % Concatena 1 a la entrada, para el bias
        x = [1; p.x(:, mod(it, n) + 1)]; 
        y = dot(x, p.w(:, end)); % Salida de funcion de activacion
        err = p.d(mod(it, n) + 1) - y; % Calcular error
        
        % Actualizar los pesos y guardar los valores
        p.w(:, end + 1) = p.w(:, end) + (p.eta * err * x);
        it = it + 1; % Incrementar iteraciones
    end
end

% Entrenamiento evolutivo (PSO)
function [p, it] = evolutivo(p)
    N = 25; % Tamano de poblacion
    w = 0.6; % Factor de inercia
    c1 = 2; % Factor de aprendizaje cognitivo
    c2 = 2; % Factor de aprendizaje social
    it = 0; % Numero de generaciones que han pasado
    d = size(p.x, 1) + 1; % Dimension del problema (se suma 1 para el bias)
    
    % Inicializacion de vectores de poblacion y velocidad
    x = zeros(d, N);
    v = zeros(d, N);

    % Generar aleatoriamente los vectores
    xl = -3 * ones(d, 1);
    xu = 3 * ones(d, 1);
    for i = 1:N
        x(:, i) = xl + (xu - xl) .* rand(d, 1);
        v(:, i) = xl + (xu - xl) .* rand(d, 1);
    end
    xb = x;
    
    % Correr hasta que el ultimo vector de pesos (la mejor posicion global)
    % tenga un fitness menor a 0.02
    while it < 25
        for j = 1:N % Actualizar vector de mejores posiciones dependiendo de su evaluacion
            if fitness(x(:, j), p.x, p.d) < fitness(xb(:, j), p.x, p.d)
                xb(:, j) = x(:, j);
            end
        end
        xg = xb(:, 1); % Suponer que la mejor posicion global es primer elemento de xb
        for j = 2:N % Buscar la mejor posicion global
            if fitness(xb(:, j), p.x, p.d) < fitness(xg, p.x, p.d)
                xg = xb(:, j);
            end
        end
        for j = 1:N % Actualizar vectores de velocidades y poblacion
            v(:, j) = w * v(:, j) + c1 * rand * (xb(:, j) - x(:, j)) + c2 * rand * (xg - x(:, j));
            x(:, j) = x(:, j) + v(:, j);
        end
        p.w(:, end + 1) = xg;
        it = it + 1;
    end
end

% Funcion objetivo
% w es el vector de pesos que se esta evaluando
% px los datos de entrenamiento
% pd los valores deseados
function f = fitness(w, px, pd)
    k = size(px, 2);
    f = 0;
    for i = 1:k
        x = [1; px(:, i)];
        y = dot(x, w);
        f = f + (1 / (2 * k)) * (pd(i) - y) ^ 2;
    end
end

%% Funciones para plotear
% Plotear puntos y linea de separacion
function plot_adaline(p, it)
    % Crear figura nueva
    figure
    hold on
    
    if size(p.x, 1) == 1
        % Plotear todos los puntos
        plot(p.x, p.d, 'r*', 'MarkerSize', 8) 
        % Dibujar linea de separacion
        x = min(p.x):max(p.x);
        y = (p.w(2, end) * x) + p.w(1, end);
        plot(x, y, 'b-')
    else
        % Plotear todos los puntos
        scatter3(p.x(1, :), p.x(2, :), p.d);
        % Clasificar matriz de datos
        X = min(p.x(1,:))-1:max(p.x(1,:))+1;
        Y = min(p.x(2,:))-1:max(p.x(2,:))+1;
        [x, y] = meshgrid(X, Y);     
        z = zeros(size(x, 1), size(x, 2));
        for i = 1:size(x, 1)
            for j = 1:size(x, 2)
                z(i, j) = p.w(2, end)*x(i, j) + p.w(3, end)*y(i, j) + p.w(1, end);
            end
        end
        % Dibujar plano de separacion
        surf(x, y, z);
    end
    
    % Numero de iteraciones que se necesitaron para entrenar 
    title("Iteraciones: " + it);
    
    % Plotear evolucion de bias y pesos
    plot_pesos(p.w, it)
end

% Plotear evolucion de bias y pesos
function plot_pesos(w, it)
    figure
    hold on
    
    subplot(3, 1, 1)  
    plot(0:it, w(1, :), 'r')
    title("Bias")
    
    subplot(3, 1, 2)
    plot(0:it, w(2, :), 'g')
    title("W1")
    
    % Si es el Adaline es para "data2.mat"
    if size(w, 1) == 3
        subplot(3, 1, 3)
        plot(0:it, w(3, :), 'b')
        title("W2")
    end
end