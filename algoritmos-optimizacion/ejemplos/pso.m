%% Practica 5
close all; clear all; clc;

G = 200; % # de generaciones
w = 0.6; % Factor de inercia
c1 = 2; % Factor de aprendizaje cognitivo
c2 = 2; % Factor de aprendizaje social
N = 100; % Tamano de poblacion
func = 1; % 1:Griewank, 2:Rastrigin, 3:Esfera

% Llamar funcion enjambre con parametros elegido
[x, v, xb, xg] = enjambre(G, w, c1, c2, N, func);

% Buscar el minimo de la poblacion
xmin = x(:, 1);
for i = 2:N
  if f(x(1, i), x(2, i), func) < f(xmin(1), xmin(2), func)
    xmin = x(:, i);
  end
end

% Imprimir en consola
xmin
fxmin = f(xmin(1), xmin(2), func)

% Optimizacion por Enjambre de Particulas
function [x, v, xb, xg] = enjambre(G, w, c1, c2, N, func)
  % Inicializacion de vectores de poblacion y velocidad
  x = zeros(2, N);
  v = zeros(2, N);

  % Generar aleatoriamente vectores
  xl = -10 * ones(2, 1);
  xu = 10 * ones(2, 1);
  for i = 1:N
    x(:, i) = xl + (xu - xl).*rand(2, 1);
    v(:, i) = xl + (xu - xl).*rand(2, 1);
  end
  xb = x; % Vector de mejores posiciones

  % Graficar funcion
  % Figura y ejes para las graficas
  fig1 = figure('Name', 'Surface', 'Position', [200 300 600 500]);
  fig2 = figure('Name', 'Contour', 'Position', [1000 300 600 500]);
  ax1 = axes(fig1); xlim(ax1, [xl(1) xu(1)]); ylim(ax1, [xl(2) xu(2)]);
  ax2 = axes(fig2); xlim(ax2, [xl(1) xu(1)]); ylim(ax2, [xl(2) xu(2)]);
  switch func % Limite en Z dependiendo de la funcion
    case 1
      zlim(ax1, [0 2.5]);
    case 2
      zlim(ax1, [0 250]);
    case 3
      zlim(ax1, [0 250]);     
  end
  hold(ax1, 'on'); hold(ax2, 'on');
  [gx, gy] = meshgrid(xl(1):0.2:xu(1), xl(2):0.2:xu(2));
  gz = f(gx, gy, func);        
  % Figura 1: Surface    
  surf(ax1, gx, gy, gz); hold on; view(ax1, 30, 50);
  % Figura 2: Contour
  contour(ax2, gx, gy, gz, 10); hold on;

  for i = 1:G
    % Graficar generacion
    px = x(1, :); py = x(2, :);
    plotGen1 = plot3(ax1, px, py, f(px, py, func), 'ko', 'LineWidth', 2, ...
      'MarkerFaceColor', 'r', 'MarkerSize', 7); % Plotear a cada individuo en surface
    plotGen2 = plot3(ax2, px, py, f(px, py, func), 'ko', 'LineWidth', 2, ...
      'MarkerFaceColor', 'r', 'MarkerSize', 7); % Plotear a cada individuo en contour
    pause(0.1);
    if i < G % Borrar la generacion anterior en la grafica
      delete(plotGen1);
      delete(plotGen2);
    end
    for j = 1:N % Actualizar vector de mejores posiciones dependiendo de su evaluacion
      if f(x(1, j), x(2, j), func) < f(xb(1, j), xb(2, j), func)
        xb(:, j) = x(:, j);
      end
    end
    xg = xb(:, 1); % Inicializar mejor posicion global como primer elemento de xb
    for j = 2:N % Buscar la mejor posicion global
      if f(xb(1, j), xb(2, j), func) < f(xg(1), xg(2), func)
        xg = xb(:, j);
      end
    end
    for j = 1:N % Actualizar vectores de velocidades y poblacion
      v(:, j) = w*v(:, j) + c1*rand*(xb(:, j) - x(:, j)) + c2*rand*(xg - x(:, j));
      x(:, j) = x(:, j) + v(:, j);
    end
  end
end

function out = f(x, y, func)
  switch func
    case 1 % Griewank
      out = (x.^2)/4000 + (y.^2)/4000 - cos(x) .* cos(y/sqrt(2)) + 1;
    case 2 % Rastrigin
      out = 20 + (x.^2 - 10*cos(x.*2.*pi)) + (y.^2 - 10*cos(y.*2.*pi));
    case 3 % Esfera
      out = x.^2 + y.^2;
  end
end
