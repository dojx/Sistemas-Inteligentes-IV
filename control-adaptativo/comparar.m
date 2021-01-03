close all;
clear; clc;

load pid.mat
load npid.mat

t = 0.01;
S = 15;

time = t : t : S;

figure(1)
grid on
hold on
plot(time, pid_plot(3, :), 'g', 'LineWidth', 1.5);
plot(time, pid_plot(1, :), 'r', 'LineWidth', 1.5);
plot(time, npid_plot(1, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('x_d', 'x pid', 'x npid')
title('Posicion vs posicion deseada')

figure(2)
grid on
hold on
plot(time, pid_plot(2, :), 'r', 'LineWidth', 1.5);
plot(time, npid_plot(2, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('xp pid', 'xp npid')
title('Velocidad en x', 'LineWidth', 1.5)

figure(3)
grid on
hold on
plot(time, pid_plot(7, :), 'r', 'LineWidth', 1.5);
plot(time, npid_plot(7, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('F pid', 'F npid')

figure(4)
grid on
hold on
plot(time, pid_plot(4, :), '--m', 'LineWidth', 1.5);
plot(time, pid_plot(5, :), '--k', 'LineWidth', 1.5);
plot(time, pid_plot(6, :), '--c', 'LineWidth', 1.5);
plot(time, npid_plot(4, :), 'r', 'LineWidth', 1.5);
plot(time, npid_plot(5, :), 'g', 'LineWidth', 1.5);
plot(time, npid_plot(6, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('k_{p0}', 'k_{i0}', 'k_{d0}', 'k_p', 'k_i', 'k_d')
title('Evolucion de pesos (ganancias PID)')