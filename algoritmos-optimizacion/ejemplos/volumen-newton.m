clear all; close all; clc;

L = 20;
f = @(l) ((L - 2*l).^2).*l; % 2l^3 - 4l^2L - lL^2 
fp = @(l) (L^2 - 8*l.*L + 12*l.^2);
fpp = @(l) (-8*L + 24*l);

l = 0:0.1:10;
x0 = 3;

hold on

for i = 1:10
    x0 = x0 - fp(x0)/fpp(x0);
end
x0
f(x0)

subplot(3, 1 ,1)
plot(l, f(l), '-b');
hold on
plot(x0, f(x0), 'ro', ...
                'LineWidth', 1, ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', 'r', ...
                'MarkerSize', 5);
            
subplot(3, 1 ,2)
plot(l, fp(l), '-b');
hold on
plot(x0, fp(x0), 'ro', ...
                'LineWidth', 1, ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', 'r', ...
                'MarkerSize', 5);
            
subplot(3, 1 ,3)
plot(l, fpp(l), '-b');
hold on
plot(x0, fpp(x0), 'ro', ...
                'LineWidth', 1, ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', 'r', ...
                'MarkerSize', 5);