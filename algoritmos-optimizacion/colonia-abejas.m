clear all; close all; clc;

G = 100;
N = 100;
LMax = 20;
Pf = 50;
Po = N - Pf;
D = 2;
k = 1;

x = ones(D, Pf); % Individuos
v = ones(D, Pf); 
L = ones(1, Pf);
aptitudes = ones(1, Pf);
proba = ones(1, Pf);

for i = 1:N
  x(:, i) = xl + (xu - xl).*rand(D, 1);
end

% Empleadas
for i = 1:Pf
  while k ~= i
    k = randi([1 Pf]);
  end
  j = randi([1 D]);
  fi = rand*2 - 1;
  v(:, i) = x(:, i);
  v(j, i) = x(j, i) + fi*(x(j, i) - x(j, k));
  if f(v(:, i)) < f(x(:, i))
    x(:, i) = v(:, i);
    L(i) = 0;
  else
    L(i) = L(i) + 1;
  end
end

sumApt = 0;
for i = 1:Pf
  aptitudes(i) = aptitud(x(:, i));
  sumApt = sumApt + aptitudes(i);
end

for i = 1:Pf
  proba(i) = aptitudes(i)/sumApt;
end

% Observadoras
for i = 1:Po
  m = ruleta(x, proba);
  k = rand
end

function out = aptitud(x)
  if f(x) >= 0
    out = 1/(1 + f(x));
  else
    out = 1 + abs(f(x));
  end
end

function out = ruleta(poblacion, proba)
    % Seleccion por ruleta
    out = zeros(2, 1);
    r = rand; % Numero aleatorio
    pSum = 0; % Variable que ira guardando la suma de probabilidades de cada individuo
    for i = 1:length(poblacion)
        pSum = pSum + proba(i);
        if pSum >= r % Elegir como padre si la suma es mayor al # aleatorio
            out = poblacion(:, i);
            return
        end
    end
end