clear all; close all; clc;

x = [2.3 4.2 5.1 8.2 11];
yd = [7.9 12.5 15 22.7 27];

plot(x, yd, 'ro')
grid on
hold on

f=@(m,b) 0.5*sum((yd-(m.*x+b)).^2);
gradm= @(m,b) sum(yd-(m.*x + b).*(-x));
gradb= @(m,b) sum(yd - (m.*x+b));

m = 2;
b = 4;
h = 0.000001;
x = 0:0.01:13;

for i = 1:100
	m = m - h.*gradm(m, b);
	b = b - h.*gradm(m, b);
end

plot(x, m*x + b)
m
b
[~, n] = min(m*x + b);
minx = x(n)
miny = m*x(n) + b