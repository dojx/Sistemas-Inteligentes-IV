clear all; close all; clc;

load data_noLineal % xp y yp

plot(xp, yp, 'ro') % Plotear puntos
grid on
hold on

M = 41; % Numero de elementos

% Metodo gradiente descendente
f = @(m,b) 1/(2*M)*sum(yp - m.*exp(b.*xp)); % Funcion exponencial
gradm = @(m,b) sum((exp(b.*xp).*(yp - exp(b.*xp).*m))/-M); % Derivada parcial con respecto a m
gradb = @(m,b) sum((m.*xp*exp(b.*xp)*(yp - exp(b.*xp).*m))/-M); % Derivada parcial con respecto a b

% Punto inicial
m = 0.9;
b = 0.23;
h = 0.000001; % Incremento
x = 0:0.01:13; % Vector de entrada

% Calcular m y b
for i = 1:200
	m = m - h.*gradm(m, b);
	b = b - h.*gradm(m, b);
end

% Plotear solucion
plot(x, m*(exp(b.*x)));

% Imprimir en consola resultados
m
b

% Minimo
[~, n] = min(m*exp(b.*x));
minx = x(n)
miny = m.*exp(b.*x(n))