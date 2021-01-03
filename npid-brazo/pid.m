close all; 
clear; clc;

x_d = [0.4 0.3 0.2]'; % Posicion cartesiana deseada
q = [pi/4 pi/4 0.1]'; % Posicion articular inicial
u = [0 0 0]'; % Fuerza externa

% Ganancias
kp = [1 1 1]'; % Ganancias proporcionales
ki = [0.01 0.01 0.01]'; % Ganancias integrales
kd = [0.001 0.001 0.001]'; % Ganancias derivativas

% Errores PID
ep = [0 0 0]'; % P
ei = ep; % I
ed = ep; % D
e_old = ep; % Error en paso anterior

t = 0.01; % Tiempo de integracion
S = 15; % Tiempo total de simulacion

% Manipulador
l_1 = 0.5;
l_2 = 0.3;

% Matrices de transformacion
T_01 = @(q) [cos(q(1)) 0 sin(q(1)) 0; sin(q(1)) 0 -cos(q(1)) 0; 0 1 0 l_1; 0 0 0 1];
T_12 = @(q) [cos(q(2)) -sin(q(2)) 0 l_2*cos(q(2)); sin(q(2)) cos(q(2)) 0 l_2*sin(q(2)); 0 0 1 0; 0 0 0 1];
T_23 = @(q) [1 0 0 q(3); 0 1 0 0; 0 0 1 0; 0 0 0 1];

% Matriz Jacobiana
J = @(q) [-(q(3)+l_2)*sin(q(1))*cos(q(2)) -(q(3)+l_2)*cos(q(1))*sin(q(2)) cos(q(1))*cos(q(2));
          (q(3)+l_2)*cos(q(1))*cos(q(2)) -(q(3)+l_2)*sin(q(1))*sin(q(2)) cos(q(2))*sin(q(1));
          0 (q(3)+l_2)*cos(q(2)) sin(q(2))];
      
% Matrices para graficas
q_plot = zeros(3, S / t);
qp_plot = zeros(3, S / t);
x_plot = zeros(3, S / t);
xd_plot = zeros(3, S / t);
u_plot = zeros(3, S / t);
time = t : t : S; % Vector de tiempo      
      
% Simulacion
for i = 1 : S/t
    % Calcular posicion cartesiana
    T_03 = T_01(q) * T_12(q) * T_23(q);
    x = T_03(1:3, 4);
    
    % Calcular errores
    ep = x_d - x; % Proporcional
    ei = ei + ep * t; % Integral
    ed = (ep - e_old)/t; % Derivativa
    
    % Fuerza de entrada (salida de red)
    u =  kp.*ep + ki.*ei + kd.*ed;
    
    % Calcular velocidad y posicion articular
    q_p = pinv(J(q))*u;
    q = q + q_p * t;
    
    % Guardar para las graficas
    q_plot(:, i) = q;
    qp_plot(:, i) = q_p;
    x_plot(:, i) = x;
    xd_plot(:, i) = x_d;
    u_plot(:, i) = u;
end

% Graficas
figure(1)
grid on
hold on
plot(time, x_plot(1, :), 'r', 'LineWidth', 1.5);
plot(time, xd_plot(1, :), '--m', 'LineWidth', 1.5);
plot(time, x_plot(2, :), 'g', 'LineWidth', 1.5);
plot(time, xd_plot(2, :), '--k', 'LineWidth', 1.5);
plot(time, x_plot(3, :), 'b', 'LineWidth', 1.5);
plot(time, xd_plot(3, :), '--c', 'LineWidth', 1.5);
xlabel('t')
legend('x', 'xd', 'y', 'yd', 'z', 'zd')
title('Posicion cartesiana y posicion deseada')

figure(2)
grid on
hold on
plot(time, q_plot(1, :), 'r', 'LineWidth', 1.5);
plot(time, q_plot(2, :), 'g', 'LineWidth', 1.5);
plot(time, q_plot(3, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('q_1', 'q_2', 'q_3')
title('Posicion articular')

figure(3)
grid on
hold on
plot(time, qp_plot(1, :), 'r', 'LineWidth', 1.5);
plot(time, qp_plot(2, :), 'g', 'LineWidth', 1.5);
plot(time, qp_plot(3, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('qp_1', 'qp_2', 'qp_3')
title('Velocidad articular')

figure(4)
grid on
hold on
plot(time, u_plot(1, :), 'r', 'LineWidth', 1.5);
plot(time, u_plot(2, :), 'g', 'LineWidth', 1.5);
plot(time, u_plot(3, :), 'b', 'LineWidth', 1.5);
xlabel('t')
legend('u_1', 'u_2', 'u_3')
title('Fuerzas de entrada')