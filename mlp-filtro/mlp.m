%% Actividad 4 - MLP
% Nombre: Diego Omar Jimenez Navarro
% Codigo: 213526346
%%
close all; clear; clc

load data_5

p = 10;

entradas = zeros(p, length(V) - p);

for i = 1 : length(V) - p
    entradas(:, i) = V(i : p + i - 1); 
end

deseadas = V(p + 1 : end);

capas = [3 2 1];
acts = ['SIG'; 'SIG'; 'LIN'];

perc = Multicapa(p, capas, acts);
perc.entrenar_clasico(entradas, deseadas, 0.1, length(V) * 5);

plot(V, 'b')
hold on
plot([zeros(1, p) perc.predicciones], 'g', 'LineWidth', 1.5)
