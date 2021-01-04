% Ejercicio 7

clear all; close all; clc;

G = 400; % Generaciones
N = 200; % Poblacion
F = 1.2;
CR = 0.6;
M = 3;

%Limites
xl = -5 * ones(3, 1);
xu = 5 * ones(3, 1);

% Puntos iniciales
x1 = [1 2.5 4.5];
x2 = [4 3 1];
  
plot(x1, x2, 'o'); hold on;
plot(x1, x2, 'o');

axis([-20 20 -20 20])

e = @(w) (w(1) - x1).^2 + (w(2) - x2).^2 - w(3).^2; % Funcion error
f = @(w) 1/2*M * sum(e(w).^2); % Funcion a optimizar

w = ones(3, N); % Individuos
v = ones(3, N); % Vector mutado
u = ones(3, N); % Vector de prueba
r1 = 1;
r2 = 1;
r3 = 1;

for i = 1:N
  w(:, i) = xl + (xu - xl).*rand(3, 1); % Inicializacion aleatoria
end

for i = 1:G
  % Evolucion Diferencial
  for j = 1:N
    while j == r1 || j == r2 || j == r3 || r1 == r2 || r1 == r3 || r2 == r3
      r1 = randi([1 N]);
      r2 = randi([1 N]);
      r3 = randi([1 N]);
    end
    v(:, j) = w(:, r1) + F*(w(:, r2) - w(:, r3));

    for k = 1:3
      if rand <= CR
        u(k, j) = v(k, j);
      else
        u(k, j) = w(k, j);
      end
    end

    if f(u(:, j)) < f(w(:, j)) 
      w(:, j) = u(:, j);
    end  
  end
end

% Buscar mejor solucion
wbest = w(:, 1);
for i = 2:N
  if f(wbest) < f(w(:, i))
    wbest = w(:, i);
  end
end
wbest
f(wbest)

% Imprimir circulo
tht = -pi:0.1:pi;
x = wbest(1) + wbest(3)*cos(tht);
y = wbest(2) + wbest(3)*sin(tht);
linspace(-pi, pi, 100);
plot(x,y)
