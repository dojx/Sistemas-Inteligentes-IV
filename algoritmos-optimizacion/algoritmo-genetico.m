%% Practica 3
close all; clear all; clc;

%% Parametros
pobTotal = 100; % Tamano poblacional (# par)
genTotal = 200; % # de generaciones
probMut = 0.01; % Probabilidad de mutacion
funcion = 1; % # de funcion

% Algoritmo Genetico: Regresa poblacion final y sus aptitudes
[poblacion, aptitud] = algorGenetico(pobTotal, genTotal, probMut, funcion);

[~, n] = max(aptitud); % Indice de aptitud maxima
minimo = poblacion(:, :, n) % Individuo con mas aptitud (se acerco mas al minimo)
fminimo = fxy(poblacion(1, 1, n), poblacion(2, 1, n), funcion) % Funcion evaluada en el punto minimo encontrado

%% Funciones
function [poblacion, aptitud] = algorGenetico(pobTotal, genTotal, probMut, n) % Funcion main
    if n == 1
        xyl = [-2 -2]'; xyu = [2 2]'; % Limites para funcion 1
    elseif n == 2
        xyl = [-2 -2]'; xyu = [6 6]'; % Limites para funcion 2
    end

    % Graficar funcion
    [x, y] = meshgrid(xyl(1):0.1:xyu(1), xyl(2):0.1:xyu(2));
    z = fxy(x, y, n);
    figure(1) % Figura 1: Surface    
    surf(x, y, z); hold on;
    figure(2)
    contour(x, y, z, 20); hold on; % Figura 2: Contour

    % Generar poblacion inicial
    limites = [xyl xyu];
    poblacion = generarPoblacion(pobTotal, limites);

    % Crear nuevas generaciones
    for i = 1:genTotal % No. total de generaciones
        x = squeeze(poblacion(1, :, :)); y = squeeze(poblacion(2, :, :)); % Reducir las dimensiones de 1x1xn a nx1
        figure(2)
        plotGen = plot3(x, y, fxy(x, y, n), 'ko', 'LineWidth', 2, ...
                'MarkerFaceColor', 'r', 'MarkerSize', 7); % Plotear a cada individuo
        pause(0.05);
        if i < genTotal % Borrar la generacion anterior en la grafica
            delete(plotGen);
        end
        aptitud = aptitudPoblacion(poblacion, n); % Calcular aptitudes para la funcion elegida
        proba = probaPadres(aptitud); % Calcular probabilidades de ser elegido
        nuevaGen = zeros(2, 1, length(poblacion)); % Inicializar nueva generacion
        for j = 1:2:length(poblacion) - 1 % Incremento de 2 para cada 2 hijos
            padres = zeros(2, 1, 2); % Inicializacion de padres
            while padres(:, :, 1) == padres(:, :, 2) % Mientras los 2 padres sean el mismo
                padres(:, :, 1) = seleccionPadre(poblacion, proba);  % Seleccionar padre 1
                padres(:, :, 2) = seleccionPadre(poblacion, proba);  % Seleccionar padre 2
            end
            hijos = generarHijos(padres); % Generar hijos
            hijos = mutarHijos(hijos, probMut, limites); % Posiblemente mutar hijos
            nuevaGen(:, :, j:j+1) = hijos; % Ir guardando los hijos en la nueva generacion (2 a la vez)
        end
        poblacion = nuevaGen; % Eliminar a la generacion anterior e igualarla a la nueva
    end
end

function out = generarPoblacion(n, limites)
    % Generar aleatoriamente la poblacion inicial
    xyl = limites(:, 1); xyu = limites(:, 2); % Limites para [x, y]
    out = zeros(2, 1, n);
    for i = 1:n
        out(:, :, i) = xyl + (xyu - xyl).*rand(2,1);
    end
end

function out = aptitudPoblacion(poblacion, n)
    % Calcular aptitud de cada individuo
    out = zeros(length(poblacion), 1);
    for i = 1:length(poblacion)
        f = fxy(poblacion(1, 1, i), poblacion(2, 1, i), n); % Evaluacion en la funcion elegida
        if f >= 0 % Si es igual o mayor a 0
            out(i) = 1/(1 + f);
        else % Si es menor a 0
            out(i) = 1 + abs(f);
        end
    end
end

function out = probaPadres(aptitud)
    % Calcular la probabilidad de ser elegido de cada individuo
    out = zeros(length(aptitud), 1);
    for i = 1:length(aptitud)
        out(i) = aptitud(i)/sum(aptitud); % Aptitud de cada individuo entre el total
    end
end

function out = seleccionPadre(poblacion, proba)
    % Seleccion por ruleta
    out = zeros(2, 1);
    r = rand; % Numero aleatorio
    pSum = 0; % Variable que ira guardando la suma de probabilidades de cada individuo
    for i = 1:length(poblacion)
        pSum = pSum + proba(i);
        if pSum >= r % Elegir como padre si la suma es mayor al # aleatorio
            out = poblacion(:, :, i);
            return
        end
    end
end

function out = generarHijos(padres)
    % Creacion de hijos
    out = zeros(2, 1, 2);
    pcruce = 1; % Punto cruce
    % Hijo 1: Mitad padre 1, mitad padre 2
    out(1:pcruce, :, 1) = padres(1:pcruce, :, 1);
    out(pcruce + 1:2, :, 1) = padres(pcruce + 1:2, :, 2);
    % Hijo 2: Mitad padre 2, mitad padre 1
    out(1:pcruce, :, 2) = padres(1:pcruce, :, 2);
    out(pcruce + 1:2, :, 2) = padres(pcruce + 1:2, :, 1);
end

function hijos = mutarHijos(hijos, probMut, limites)
    xyl = limites(:, 1); xyu = limites(:, 2); % Limites
    for i = 1:2 % Para cada hijo
        for j = 1:2 % Para cada elemento del cromosoma
            if rand < probMut; % Si es mayor el # aleatorio mutar al elemento
                hijos(j, :, i) = xyl(j) + (xyu(j) - xyl(j))*rand;
            end
        end
    end
end

function out = fxy(x, y, n) % Ecuaciones
    if n == 1 % Funcion 1
        out = x.*exp(-(x.^2)-(y.^2));
    elseif n == 2 % Funcion 2
        out = (x - 2).^2 + (y - 2).^2;
    end
end