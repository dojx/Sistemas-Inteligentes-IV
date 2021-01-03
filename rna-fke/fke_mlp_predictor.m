close all;
clear; clc;

load data_predictor

p = 10;

entradas = zeros(p, length(X) - p);

for i = 1 : length(X) - p
    entradas(:, i) = X(i : p + i - 1); 
end

deseadas = X(p + 1 : end);

capas = [3 1];
acts = ['SIG'; 'LIN'];

mlp = Multicapa(p, capas, acts);
mlp.entrenar(entradas, deseadas, 0.1, 10);

plot(X)
hold on
plot([zeros(1, p) mlp.predicciones], 'g', 'LineWidth', 2)