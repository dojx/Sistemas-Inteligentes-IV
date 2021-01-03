%% Data 1 a 3
close all;
clear; clc;

%% Parametros recomendados
% data1: M = 15, sigma = 2.0
% data2 y data3: M = 25, sigma = 1.0

load data1

x = X; % Entradas
d = Y'; % Deseadas

[~, K] = size(x); % Numero de entradas
M = 15; % Numero de neuronas en capa oculta

[~, mu] = kmeans(x', M); % Centros de RBF
sigma = 2.0; % Para funcion gaussiana

G = zeros(K, M); % Matriz de salidas
w = rand(M, 1) * 4 - 2; % Vector de pesos

for g = 1 : 10 % Epocas
    for k = 1 : K % Por cada entrada
        for m = 1 : M % Por cada neurona     
            % Calcular salida capa oculta
            G(k, m) = exp((-(x(k)-mu(m)).^2)./(sigma^2)); 
        end
    end
    y = G * w; % Calcular salida de la red
    w = pinv(G) * d; % Actualizar pesos
end

%% Resultados
figure
hold on
grid on
plot(x, d, 'o', 'LineWidth', 2, 'MarkerSize', 8)
plot(x, y, '-', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('x')
ylabel('y')
legend('Datos de entrenamiento', 'Salida NN-RBF', 'Location', 'best')