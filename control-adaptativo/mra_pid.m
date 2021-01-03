close all; 
clear; clc;

k = 1; % Resorte
b = 0.1; % Amortiguador
m = 2; % Masa
F = 0; % Fuerza externa

x = 0; % Posicion de masa
x_p = 0; % Velocidad
x_d = 2; % Posicion deseada

w = [3 1 0.01]'; % Pesos (ganancias PID)

e = [0 0 0]'; % Errores PID
e_old = 0; % Error en paso anterior

t = 0.01; % Tiempo de integracion
S = 15; % Tiempo total de simulacion

% Matrices para graficas
x_plot = zeros(1, S / t);
xp_plot = zeros(1, S / t);
xd_plot = zeros(1, S / t);
w_plot = zeros(3, S / t);
q_plot = x_plot;
time = t : t : S; % Vector de tiempo

%% Simulacion
for i = 1 : (S / t)
    % Calcular errores
    e(1) = x_d - x; % Proporcional
    e(2) = e(2) + e(1) * t; % Integral
    e(3) = (e(1) - e_old)/t; % Derivativa
    
    F = w' * e; % Calcular fuerza 
    
    w_plot(:, i) = w; % Guardar pesos
    
    x_pp = (F - k*x - b*x_p)/m; % Calcular aceleracion
    x_p = x_p + x_pp * t; % Calcular velocidad
    x = x + x_p * t + (1/2)*x_pp*t^2; % Calcular posicion
    
    % Guardar para las graficas
    x_plot(i) = x;
    xp_plot(i) = x_p;
    xd_plot(i) = x_d;
    q_plot(i) = F;
    
    % Actualizar error anterior
    e_old = e(1);
end
%% Graficas
figure(1)
grid on
hold on
plot(time, xd_plot, 'r', 'LineWidth', 1.5);
plot(time, x_plot, 'b', 'LineWidth', 1.5);
xlabel('t')
legend('x_d', 'x')
title('Posicion vs posicion deseada')

figure(2)
grid on
hold on
plot(time, xp_plot, 'r', 'LineWidth', 1.5);
xlabel('t')
legend('xp')
title('Velocidad en x', 'LineWidth', 1.5)

figure(3)
grid on
hold on
plot(time, q_plot, 'r', 'LineWidth', 1.5);
xlabel('t')
legend('F')
title('Fuerzas')

figure(4)
grid on
hold on
plot(time, w_plot(1, :), 'r', 'LineWidth', 1.5);
plot(time, w_plot(2, :), 'g', 'LineWidth', 1.5);
plot(time, w_plot(3, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('k_p', 'k_i', 'k_d')
title('Evolucion de pesos (ganancias PID)')

pid_plot = [x_plot; xp_plot; xd_plot; w_plot; q_plot];
save('pid.mat', 'pid_plot')