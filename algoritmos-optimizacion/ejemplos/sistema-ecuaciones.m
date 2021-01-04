% Ejercicio 5
format long
clear all; close all; clc;

G = 1000; % Generaciones
N = 200; % Población
F = 1.2;
CR = 0.6;

xl = 0 * ones(3, 1);
xu = 4 * ones(3, 1);

a = @(w) 2*w(1) + w(2) - 8;
b = @(w) 4*w(1) + 3*w(2) + 5*w(3) - 25;
c = @(w) w(1) + 2*w(3) - 4;
d = @(w) 3*w(1) + w(2) + 10*w(3) - 20;
err = @(w) a(w) + b(w) + c(w) + d(w);
%f = @(w) 10*w(1) + 5*w(2) + 17*w(3) - 57;

w = ones(3, N); % Individuos
v = ones(3, N); % Vector mutado
u = ones(3, N); % Vector de prueba
r1 = 1;
r2 = 1;
r3 = 1;

for i = 1:N
  w(:, i) = xl + (xu - xl).*rand(3, 1);
end

for i = 1:G
  % Evolución Diferencial
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

    if abs(err(u(:, j))) < abs(err(w(:, j)))
      w(:, j) = u(:, j);
    end  
  end
end

wbest = w(:, 1);
for i = 2:N
  if abs(err(wbest)) < abs(err(w(:, i)))
    wbest = w(:, i)
  end
end
wbest
err(wbest)
