close all; 
clear; clc;

load data_nolineal

capas = [8 1];
acts = ['SIG'; 'SIG'];

X = normalizar(X);
D = normalizar(D);

mlp = Multicapa(1, capas, acts);
mlp.entrenar(X, D, 0.01, 1000);

gx = 0:0.01:1;
gy = gx;
for i = 1 : length(gx)
    gy(i) = mlp.predecir(gx(i));
end

plot(X, D, 'b*')
hold on 
plot(gx, gy, 'r')

%% Funciones
function y = normalizar(x)
    y = x;
    min_val = min(x);
    max_val = max(x);
    for i = 1 : length(x)
       y(i) =  (x(i) - min_val) / (max_val - min_val);
    end
end