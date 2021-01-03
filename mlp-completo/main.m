%% Actividad 5
% Nombre: Diego Omar Jimenez Navarro
% Codigo: 213526346
%%
close all; clear; clc;

%% Parametros
capas = [10 1];
acts = ['TAN'; 'SIG'];

%% Data 1
figure(1)
load data1.mat
perc = Multicapa(2, capas, acts);

X = [normalizar(X(1, :)); normalizar(X(2, :))];

perc.entrenar_clasico(X, D, 0.1, 500);

plot(X(1, D == 0), X(2, D == 0), 'bo')
hold on
plot(X(1, D == 1), X(2, D == 1), 'ro')

xg = linspace(min(X(1, :)), max(X(1, :)), 50);
yg = linspace(min(X(2, :)), max(X(2, :)), 50);
[x, y] = meshgrid(xg, yg);
z = zeros(50, 50);
for i = 1 : length(x)
    for j = 1 : length(y)
        z(i, j) = perc.predecir([x(i, j); y(i, j)]);
    end
end

Xg = [normalizar(Xg(1, :)); normalizar(Xg(2, :))];
Dg = zeros(1, size(Xg, 2));
for i = 1 : size(Xg, 2)
    Dg(i) = perc.predecir(Xg(:, i));
end
plot(Xg(1, Dg < 0.5), Xg(2, Dg < 0.5), 'bx')
plot(Xg(1, Dg >= 0.5), Xg(2, Dg >= 0.5), 'rx')

contour(x, y, z, 1)

%% Data 2
% figure(2)
% load data2.mat
% perc2 = Multicapa(2, capas, acts);
% 
% perc2.entrenar_clasico(X, D, 0.1, 500);
% xg = linspace(min(X(1, :)), max(X(1, :)), 50);
% yg = linspace(min(X(2, :)), max(X(2, :)), 50);
% [x, y] = meshgrid(xg, yg);
% z = zeros(50, 50);
% for i = 1 : length(x)
%     for j = 1 : length(y)
%         z(i, j) = perc2.predecir([x(i, j); y(i, j)]);
%     end
% end
% 
% plot(X(1, D == 0), X(2, D == 0), 'bo')
% hold on
% plot(X(1, D == 1), X(2, D == 1), 'ro')
% 
% Dg = zeros(1, size(Xg, 2));
% for i = 1 : size(Xg, 2)
%     Dg(i) = perc2.predecir(Xg(:, i));
% end
% plot(Xg(1, Dg < 0.5), Xg(2, Dg < 0.5), 'bx')
% plot(Xg(1, Dg >= 0.5), Xg(2, Dg >= 0.5), 'rx')
% 
% contour(x, y, z, 1)

%% Imprimir precisiones
perc.precision * 100
perc2.precision * 100

%% Funciones
function y = normalizar(x)
    y = x;
    min_val = min(x);
    max_val = max(x);
    for i = 1 : length(x)
       y(i) =  (x(i) - min_val) / (max_val - min_val);
    end
end