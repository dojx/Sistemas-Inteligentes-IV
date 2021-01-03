%% Data 4 a 6
close all;
clear; clc;

%% Parametros recomendados
% data4: M = 70, sigma = 3.0
% data5 y data6: M = 100, sigma = 4.0

load data4

x = [X(:)'; Y(:)']; % Entradas (2 x K)
d = Z(:); % Salidas

[~, K] = size(x); % Numero de entradas
M = 70; % Numero de neuronas

[~, mu] = kmeans(x', M); % Centros de los RBF
sigma = 3.0; % Para funcion gaussiana

G = zeros(K, M); % Matriz de salidas
w = rand(M, 1) * 4 - 2; % Vector de pesos

for g = 1 : 10 % Epocas
    for k = 1 : K % Por cada entrada
        for m = 1 : M % Por cada neurona
            aux = norm(x(:, k) - mu(m, :)'); % Norma
            G(k, m) = exp(-(aux)^2/sigma^2); % Calcular salida oculta
        end
    end
    y = G * w; % Calcular salida de la red
    w = pinv(G) * d; % Actualizar pesos
end

%% Resultados
% Reconstruir surface
gz = zeros(size(Z));
for i = 1 : size(X, 1)
    for j = 1 : size(X, 2)
        idx = (i - 1) * size(X, 1) + j; 
        gz(i, j) = y(idx);
    end
end

% Comparar
figure
hold on
grid on
subplot(1, 2, 1)
surf(X, Y, Z)
title('Original')
subplot(1, 2, 2)
surf(X, Y, gz)
title('NN-RBF')