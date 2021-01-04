clc; clear all; close all;
G = 200; % Generaciones
N = 100; % Poblacion
D = 2; % Dimension del problema

% Factor de recombinacion [0,2]
% Rango de diferenciacion entre (xr2 - xr3)
% Evita estancamiento
F = 1.2;
% Constante de recombinacion [0,1]
% Relacion entre exploracion y explotacion
CR = 0.6;

xl = -10 * ones(D, 1);
xu = 10 * ones(D, 1);

x = ones(D, N); % Individuos
v = ones(D, N); % Vector mutado
u = ones(D, N); % Vector de prueba
r1 = 1;
r2 = 1;
r3 = 1;

for i = 1:N
  x(:, i) = xl + (xu - xl).*rand(D, 1);
end

% Graficar funcion
[gx, gy] = meshgrid(xl(1):0.2:xu(1), xl(2):0.2:xu(2));
gz = gf(gx, gy);        
contour(gx, gy, gz, 10); hold on;
xlim([xl(1) xu(1)]); ylim([xl(2) xu(2)]);

for i = 1:G
  % Animacion de generaciones
  px = x(1, :); py = x(2, :);
  plotGen = plot3(px, py, gf(px, py), 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'r', 'MarkerSize', 7);
  pause(0.1);
  if i < G % Borrar la generacion anterior en la grafica
    delete(plotGen);
  end
  
  % Evolucion Diferencial
  for j = 1:N
    while j == r1 || j == r2 || j == r3 || r1 == r2 || r1 == r3 || r2 == r3
      r1 = randi([1 N]);
      r2 = randi([1 N]);
      r3 = randi([1 N]);
    end
    v(:, j) = x(:, r1) + F*(x(:, r2) - x(:, r3));

    for k = 1:D
      if rand <= CR
        u(k, j) = v(k, j);
      else
        u(k, j) = x(k, j);
      end
    end

    if f(u(:, j)) < f(x(:, j)) 
      x(:, j) = u(:, j);
    end  
  end
end

% Buscar el minimo de la poblacion
xmin = x(:, 1);
for i = 2:N
  if f(x) < f(xmin)
    xmin = x(:, i);
  end
end

% Imprimir en consola
xmin
fxmin = f(xmin)

%% Funciones
function out = f(x)
  %% Griewank
%   suma = sum(x.^2/4000);
%   produ = 1;
%   for i = 1:length(x)
%     produ = produ * cos(x(i)/sqrt(i));
%   end
%   out = suma - produ + 1;

  %% Rastrigin
  out = 10*length(x) + sum(x.^2 - 10*cos(2*pi*x));
  
%   %% Esfera
%   out = x(1)^2 + x(2)^2;
end
function out = gf(x, y)
%   %% Griewank
%   out = (x.^2)/4000 + (y.^2)/4000 - cos(x) .* cos(y/sqrt(2)) + 1;

  %% Rastrigin
  out = 20 + (x.^2 - 10*cos(x.*2.*pi)) + (y.^2 - 10*cos(y.*2.*pi));

%   %% Esfera
%   out = x.^2 + y.^2;
end