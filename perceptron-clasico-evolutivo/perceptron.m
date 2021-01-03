%% Actividad 1
% Nombre: Diego Omar Jimenez Navarro
% Codigo: 213526346

%% Main
close all; clear; clc;

n = input('Elige un perceptron:\n 1. Compuerta AND\n 2. Compuerta OR\n 3. data.mat\n');
p = perceptron(n);
n = input('Elige el tipo de entrenamiento:\n 1. Clasico\n 2. Evolutivo (PSO)\n');
[p, it] = entrenar(p, n);
plot_perceptron(p, it)
while 1
    n = input('Desea clasificar otro punto?:\n  1. Si\n  2. No\n');
    if n == 2 
        break;
    end
    x = input('Coordenada X: ');
    y = input('Coordenada Y: ');
    figure(1)
    plot_extra(p.w(:, end), [x; y]);
end

%% Funciones
% Crear un perceptron (estructura)
function p = perceptron(n)
    p.w = rand(3, 1) * 4 - 2; % Pesos aleatorios
    p.eta = 0.01; % Factor de aprendizaje
    p.extras = [];
    switch n
        case 1 % AND
            p.x = [0 0 1 1; 0 1 0 1]; % Entradas
            p.d = [-1 -1 -1 1]; % Deseadas      
        case 2 % OR
            p.x = [0 0 1 1; 0 1 0 1];
            p.d = [-1 1 1 1]; 
        case 3 % data.mat
            data = load('data.mat');
            p.x = data.X;
            p.d = data.D;   
            p.extras = data.Xg; % Datos extra
        otherwise
            disp('Opcion invalida');
    end
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
    correctos = 0; % Numero de clasificaciones correctas
    
    % Correr hasta que todas las entradas se han
    % clasificado correctamente
    while correctos ~= n 
        % Concatena 1 a la entrada, para el bias
        x = [1; p.x(:, mod(it, n) + 1)]; 
        y = signo(dot(x, p.w(:, end))); % Salida de funcion de activacion

        if y == p.d(mod(it, n) + 1) % Se clasifico correctamente
            correctos = correctos + 1;
            p.w(:, end + 1) = p.w(:, end);
        else % No se clasifico correctamente
            correctos = 0; % Resetear numero de correctos
            err = p.d(mod(it, n) + 1) - y; % Calcular error
            % Actualizar los pesos y guardar los valores
            p.w(:, end + 1) = p.w(:, end) + (p.eta * err * x);
        end

        it = it + 1; % Incrementar iteraciones
    end
end

% Entrenamiento evolutivo (PSO)
function [p, it] = evolutivo(p)
    N = 20; % Tamano de poblacion
    w = 0.6; % Factor de inercia
    c1 = 2; % Factor de aprendizaje cognitivo
    c2 = 2; % Factor de aprendizaje social
    it = 0; % Numero de generaciones que han pasado
    
    % Inicializacion de vectores de poblacion y velocidad
    x = zeros(3, N);
    v = zeros(3, N);

    % Generar aleatoriamente los vectores
    xl = -3 * ones(3, 1);
    xu = 3 * ones(3, 1);
    for i = 1:N
        x(:, i) = xl + (xu - xl) .* rand(3, 1);
        v(:, i) = xl + (xu - xl) .* rand(3, 1);
    end
    xb = x;
    xg = xb(:, 1);
    
    % Correr hasta que todas las entradas se han
    % clasificado correctamente
    while fitness(xg, p.x, p.d) > 0
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

% Funcion de activacion signo
function y = signo(x)
    if x >= 0
        y = 1;
    else
        y = -1;
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
        y = signo(dot(x, w));
        f = f + (1 / (2 * k)) * (pd(i) - y) ^ 2;
    end
end

%% Funciones para plotear
% Plotear puntos y linea de separacion
function plot_perceptron(p, it)
    % Crear figura nueva
    figure
    hold on
    
    % Plotear las entradas en azul o rojo dependiendo de su clasificacion
    plot(p.x(1, p.d == 1), p.x(2, p.d == 1), 'r*', 'MarkerSize', 8) 
    plot(p.x(1, p.d == -1), p.x(2, p.d == -1), 'b*', 'MarkerSize', 8)
    
    min_val = min(p.x, [], 2); % Valores minimos de 'x' y 'y'
    max_val = max(p.x, [], 2); % Valores maximos de 'x' y 'y'
    
    % Limites del plot, con un poco de margen
    xlim([min_val(1)-0.5 max_val(1)+0.5])
    ylim([min_val(2)-0.5 max_val(2)+0.5])
    
    % Dibujar linea de separacion
    x = min_val(1) - 0.5:max_val(1) + 0.5;
    y = (-p.w(2, end) * x - p.w(1, end)) / p.w(3, end);
    plot(x, y)
    
    % Plotear puntos extra
    if ~isempty(p.extras)
        for i = 1:size(p.extras, 2)
            plot_extra(p.w(:, end), p.extras(:, i));
        end
    end
    
    % Numero de iteraciones que se necesitaron para entrenar 
    title("Iteraciones: " + it);
    
    % Plotear evolucion de bias y pesos
    plot_pesos(p.w, it)
end

% Clasificar otros puntos despues entrenar
function plot_extra(w, x)
    plot(x(1), x(2), 'k*', 'MarkerSize', 8)
    y = signo(dot([1; x], w));
    if y == 1
        plot(x(1), x(2), 'ro', 'MarkerSize', 8);
    else
        plot(x(1), x(2), 'bo', 'MarkerSize', 8);
    end
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
    
    subplot(3, 1, 3)
    plot(0:it, w(3, :), 'b')
    title("W2")
end