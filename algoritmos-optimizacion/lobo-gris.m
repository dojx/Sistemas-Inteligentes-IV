% Practica 9

% Parametros
G = 200; % Generaciones
N = 100; % No. de lobos

% Para calcular vectores de ajuste
l_a = 1.5; 
a_min = 0;
a_max = 2;

% Funcion
n = 2; % 1 = Griewank, 2 = Rastrigin, 3 = Esfera

% Encontrar mejor solucion
[x, fitness] = GWO(G, N, l_a, a_min, a_max, n);
[~, I] = sort(fitness);

% Imprimir en consola
x_best = x(:, I(1))
fx_best = f(x_best, n)

function [x, fitness] = GWO(G, N, l_a, a_min, a_max, n)
  % Dimension del problema
  D = 2;

  % Limites
  xl = -10 * ones(D, 1);
  xu = 10 * ones(D, 1);

  % Inicializacion de vectores
  x = zeros(D, N);
  fitness = zeros(1, N);
  a = zeros(D, 3);
  c = a;

  % Graficar funcion
  [gx, gy] = meshgrid(xl(1):0.2:xu(1), xl(2):0.2:xu(2));
  gz = gf(gx, gy, n);        
  contour(gx, gy, gz, 10); hold on;
  xlim([xl(1) xu(1)]); ylim([xl(2) xu(2)]);

  % Inicializar lobos y fitness
  for i = 1:N
    x(:, i) = xl + (xu - xl).*rand(D, 1);
    fitness(i) = f(x(:, i), n);
  end

  for i = 1:G
    % Animacion de generaciones
    px = x(1, :); py = x(2, :);
    plotGen = plot3(px, py, gf(px, py, n), 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'r', 'MarkerSize', 7);
    pause(0.1);
    if i < G % Borrar la generacion anterior en la grafica
      delete(plotGen);
    end

    % Encontrar alfa, beta y delta
    [~, I] = sort(fitness);
    x_a = x(:, I(1)); 
    x_b = x(:, I(2));
    x_d = x(:, I(3));

    % Calcular vectores de ajuste
    for j = 1:3
      for k = 1:D
        a(j, k) = 2*l_a*rand - l_a;
        c(j, k) = 2*rand;
      end
    end

    % Rodear presa y encontrar nuevas soluciones
    for j = 1:N
      d_a = abs(c(1).*x_a - x(:, j));
      d_b = abs(c(2).*x_b - x(:, j));
      d_d = abs(c(3).*x_d - x(:, j));

      x_1 = x_a - a(1).*d_a;
      x_2 = x_b - a(2).*d_b;
      x_3 = x_d - a(3).*d_d;

      x(:, j) = (x_1 + x_2 + x_3)/3;

      fitness(j) = f(x(:, j), n);
    end
    % Decrementar l_a
    l_a = a_min + (a_max - a_min)*(1 - i/G);
  end
end

function y = f(x, n)
  if n == 1
    % Griewank
    suma = sum(x.^2/4000);
    produ = 1;
    for i = 1:length(x)
      produ = produ * cos(x(i)/sqrt(i));
    end
    y = suma - produ + 1;
  end
  
  if n == 2
    % Rastrigin
    y = 10*length(x) + sum(x.^2 - 10*cos(2*pi*x));
  end
  
  if n == 3
    % Esfera
    y = x(1)^2 + x(2)^2;
  end
end

function out = gf(x, y, n)
  if n == 1
  % Griewank
  out = (x.^2)/4000 + (y.^2)/4000 - cos(x) .* cos(y/sqrt(2)) + 1;
  end

  if n == 2
  % Rastrigin
  out = 20 + (x.^2 - 10*cos(x.*2.*pi)) + (y.^2 - 10*cos(y.*2.*pi));
  end

  if n == 3
  % Esfera
  out = x.^2 + y.^2;
  end
end
