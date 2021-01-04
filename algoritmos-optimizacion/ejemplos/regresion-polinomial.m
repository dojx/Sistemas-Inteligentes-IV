% Ejercicio 4
% Estrategia Evolutiva: mu + 1

clear all; close all; clc;

load('data.mat');

[M,~] = size(xp);
G = 2000; % # de generaciones
mu = 100; % # de padres
D = 5; % Dimension de problema
w = zeros(1, D);
% Funciones
g = @(w) w(1) + xp* w(2) + xp.^2*w(3) + xp.^3*w(4) + xp.^4*w(5);
f = @(w) 1/(2*M)*sum((yp-g(w)).^2);

plot(xp(:),yp(:),'rx'); hold on;

% Inicializacion de vectores
x = zeros(D, mu+1);
sigma = zeros(D, mu+1);
fitness = zeros(1, mu+1);

% Limites
xl = -3;
xu = 2;

% Inicializacion aleatoria y fitness
for i=1:mu
    x(:,i) = xl + (xu - xl).*rand(D,1);
    sigma(:,i) = 0.2*rand(D,1);
    fitness(i) = f(x);
end

% Estrategia evolutiva
for t=1:G
    r1 = randi([1 mu]);
    r2 = r1;
    while r1==r2
        r2 = randi([1 mu]);
    end   
    x(:, mu + 1) = recombinacion(x(:, r1),x(:, r2));
    sigma(:, mu + 1) = recombinacion(sigma(:, r1),sigma(:, r2));
    r = normrnd(0, sigma(:, mu + 1),[D 1]);
    x(:,mu + 1) = x(:, mu+1) + r;
    fitness(mu + 1) = f(x(:, mu+1));
    [~, I] = sort(fitness);
    x = x(:, I);
    sigma = sigma(:, I);
    fitness = fitness(I);
end

% Buscar minimo
[~, I] = min(fitness);
w(1) = x(1, I); 
w(2)=x(2, I); 
w(3)=x(3, I); 
w(4)=x(4, I); 
w(5)=x(5, I);

% Plotear solucion
x = min(xp):0.01:max(xp);
y = w(1) + x*w(2) + x.^2*w(3) + x.^3*w(4) + x.^4*w(5);
plot(x,y);

% Recombinacion sexual intermedia
function y = recombinacion(x1, x2)
    y = 0.5*(x1 + x2);
end


