% Ejercicio 5

clear all; close all; clc;

load('data_2.mat');

c1 = (y == 0);
c2 = (y == 1);

G = 400; % Generaciones
N = 200; % Población
F = 1.2;
CR = 0.6;
M = length(x1);
lambda = 5;

xl = 0 * ones(3, 1);
xu = 10 * ones(3, 1);

plot(x1(c1), x2(c1), 'o'); hold on;
plot(x1(c2), x2(c2), 'o');

h = @(w) w(1) + w(2)*x1 + w(3)*x2;
g = @(w) 1./(1 + exp(-h(w)));
f = @(w) 1/2*M * sum((y - g(w)).^2) + (lambda/M)*(w(2)^2 + w(3)^2);

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

    if f(u(:, j)) < f(w(:, j)) 
      w(:, j) = u(:, j);
    end  
  end
end

wbest = w(:, 1);
for i = 2:N
  if f(wbest) < f(w(:, i))
    wbest = w(:, i);
  end
end
wbest
f(wbest)

xn1 = -2:0.1:10;
xn2 = (-wbest(1) - wbest(2)*xn1)/wbest(3);
plot(xn1,xn2,'-');
