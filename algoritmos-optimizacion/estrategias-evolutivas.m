%% Practica 4
close all; clear all; clc;

% Parametros
funcion = 1; % # de funcion
metodo = 2; % 1 = (mu + lambda)-ES, 2 = (mu, lambda)-ES
G = 100; % # de generaciones
mu = 50; % # de Padres
lmda = 70; % # de Hijos
% NOTA: lmda > mu para el metodo 2, (mu, lambda)-ES

[poblacion, sgma, fitness] = estrategiaEvolutiva(G, mu, lmda, funcion, metodo);

[~, n] = min(fitness); % Indice de aptitud maxima
minimo = poblacion(:, n) % Individuo con mas aptitud (se acerco mas al minimo)
fminimo = fxy(poblacion(1, n), poblacion(2, n), funcion) % Funcion evaluada en el punto minimo encontrado

function [poblacion, sgma, fitness] = estrategiaEvolutiva(G, mu, lmda, funcion, metodo)
  % Figura y ejes para las graficas
  fig1 = figure('Name', 'Surface', 'Position', [200 300 600 500]);
  fig2 = figure('Name', 'Contour', 'Position', [1000 300 600 500]);
  ax1 = axes(fig1); ax2 = axes(fig2);
  hold(ax1, 'on'); hold(ax2, 'on');

  % Limites
  if funcion == 1
      xyl = [-2 -2]'; xyu = [2 2]'; % Limites para funcion 1
  elseif funcion == 2
      xyl = [-2 -2]'; xyu = [6 6]'; % Limites para funcion 2
  end

  % Graficar funcion
  [x, y] = meshgrid(xyl(1):0.1:xyu(1), xyl(2):0.1:xyu(2));
  z = fxy(x, y, funcion);        
  % Figura 1: Surface    
  surf(ax1, x, y, z); hold on; view(ax1, 30, 15);
  % Figura 2: Contour
  contour(ax2, x, y, z, 20); hold on;
  
  % Inicializacion de vectores para padres e hijos
  padres = zeros(2, mu);
  hijos = zeros(2, lmda);
  sgmaPadres = zeros(2, mu);
  sgmaHijos = zeros(2, lmda);
  fitnessPadres = zeros(1, mu);
  fitnessHijos = zeros(1, lmda);
  
  % Generar aleatoriamente vector de padres y vector de sigmas
  for i = 1:mu
    padres(:, i) = xyl + (xyu - xyl).*rand(2, 1);
    sgmaPadres(:, i) = rand(2, 1)/2;
    fitnessPadres(i) = fxy(padres(1, i), padres(2, i), funcion); % Evaluar a cada padre
  end
  
  % Hasta completar todas las generaciones G
  for i = 1:G
    % Graficar generacion
    x = padres(1, :); y = padres(2, :);
    plotGen1 = plot3(ax1, x, y, fxy(x, y, funcion), 'ko', 'LineWidth', 2, ...
      'MarkerFaceColor', 'r', 'MarkerSize', 7); % Plotear a cada individuo en surface
    plotGen2 = plot3(ax2, x, y, fxy(x, y, funcion), 'ko', 'LineWidth', 2, ...
      'MarkerFaceColor', 'r', 'MarkerSize', 7); % Plotear a cada individuo en contour
    pause(0.01);
    if i < G % Borrar la generacion anterior en la grafica
      delete(plotGen1);
      delete(plotGen2);
    end
    for j = 1:lmda % Hasta llenar vector de hijos
      r1 = randi([1 mu]); % Numero entero aleatorio entre 1 y mu
      r2 = r1;
      while r1 == r2 % Buscar otro entero aleatorio diferente al 1ro
        r2 = randi([1 mu]);
      end
      hijos(:, j) = recombination(padres(:, r1), padres(:, r2)); % Generar hijo
      sgmaHijos(:, j) = recombination(sgmaPadres(:, r1), sgmaPadres(:, r2)); % Generar sigma de hijo
      % Vector con elementos de la distribucion normal
      % donde 0 es la media, y sgmaHijos la desviacion estandar
      r = normrnd(0, sgmaHijos(:, j), [2 1]);
      hijos(:, j) = hijos(:, j) + r; % Mutacion
      fitnessHijos(j) = fxy(hijos(1, j), hijos(2, j), funcion); % Evaluacion de hijos
    end
    if metodo == 1
      poblacion = [padres hijos]; % Juntar padres e hijos en una sola poblacion
      sgmaPoblacion = [sgmaPadres sgmaHijos]; % Juntar sigmas de padres e hijos
      fitnessPoblacion = [fitnessPadres fitnessHijos]; % Juntar evaluaciones de padres e hijos
      [fitnessPoblacion, I] = sort(fitnessPoblacion); % Ordenar evaluciones de orden ascendente
      poblacion = poblacion(:, I); % Ordenar poblacion de acuerdo a su evaluacion
      sgmaPoblacion = sgmaPoblacion(:, I); % Ordenar sigmas de poblacion de acuerdo a su evaluacion
    
      padres = poblacion(:, 1:mu); % Igualar padres a los "mu" mejores de la poblacion
      sgmaPadres = sgmaPoblacion(:, 1:mu); % Igualar sigmas a los "mu" mejores sigmas de la poblacion
      fitnessPadres = fitnessPoblacion(1:mu); % Igualar evaluaciones a los "mu" mejores evaluaciones de la poblacion
    elseif metodo == 2
      [fitnessHijos, I] = sort(fitnessHijos); % Ordenar evaluciones de los hijos de orden ascendente
      hijos = hijos(:, I); % Ordenar hijos de acuerdo a su evaluacion
      sgmaHijos = sgmaHijos(:, I); % Ordenar sigmas de hijos de acuerdo a su evaluacion

      padres = hijos(:, 1:mu); % Igualar padres a los "mu" mejores de los hijos
      sgmaPadres = sgmaHijos(:, 1:mu); % Igualar sigmas a los "mu" mejores sigmas de los hijos
      fitnessPadres = fitnessHijos(1:mu); % Igualar evaluaciones a los "mu" mejores evaluaciones de los hijos
    end
  end
  poblacion = padres; % Poblacion final
  sgma = sgmaPadres; % Vector de sigmas final
  fitness = fitnessPadres; % Vector de evaluaciones final
end

function out = recombination(x1, x2)
  out = (x1 + x2)/2; % Recombinacion sexual intermedia
end

function out = fxy(x, y, n) % Ecuaciones
  if n == 1 % Funcion 1
      out = x.*exp(-(x.^2)-(y.^2));
  elseif n == 2 % Funcion 2
      out = (x - 2).^2 + (y - 2).^2;
  end
end