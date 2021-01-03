close all;
clear; clc;

load data_clasificacion

capas = [8 1];
acts = ['TAN'; 'SIG'];

mlp = Multicapa(2, capas, acts);
mlp.entrenar(X, D, 0.01, 1000);

xg = linspace(min(X(1, :)), max(X(1, :)), 50);
yg = linspace(min(X(2, :)), max(X(2, :)), 50);
[x, y] = meshgrid(xg, yg);
z = zeros(50, 50);
for i = 1 : length(x)
    for j = 1 : length(y)
        z(i, j) = mlp.predecir([x(i, j); y(i, j)]);
    end
end

contour(x, y, z, 1)
hold on

plot(X(1, D == 0), X(2, D == 0), 'r*');
plot(X(1, D == 1), X(2, D == 1), 'b*');