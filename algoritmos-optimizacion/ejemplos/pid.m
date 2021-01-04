% Ejercicio 9
clear all; close all; clc;

N = 100; % Poblacion

w = [2 0 0]; % kp, ki, kd
xd = @(t) 0.5*sin(0.5*t);
fit = @(x_plot, u_plot, time) rms(xd(time) - x_plot) + 0.1/100/0.01 * norm(u_plot) ; % fitness

F = 1.2;
CR = 0.6;
G = 100; % Generaciones
D = 3; % Dimension del problema

xl = 0 * ones(D, 1);
xu = 5 * ones(D, 1);

x = ones(D, N); % Individuos
v = ones(D, N); % Vector mutado
u = ones(D, N); % Vector de prueba
r1 = 1;
r2 = 1;
r3 = 1;

for i = 1:N
  x(:, i) = xl + (xu - xl).*rand(D, 1);
end

for i = 1:G
  % Evolucion Diferencial
  for j = 1:N
    while j == r1 || j == r2 || j == r3 || r1 == r2 || r1 == r3 || r2 == r3
      r1 = randi([1 N]);
      r2 = randi([1 N]);
      r3 = randi([1 N]);
    end
    v(:, j) = x(:, r1) + F*(x(:, r2) - x(:, r3));

    for k = 1:D
      if rand <= CR
        u(k, j) = v(k, j);
      else
        u(k, j) = x(k, j);
      end
    end
    
    [x_plot_u, u_plot_u, time_u] = func(u(:, j));
    [x_plot_x, u_plot_x, time_x] = func(x(:, j));

    if fit(x_plot_u, u_plot_u, time_u) <  fit(x_plot_x, u_plot_x, time_x)
      x(:, j) = u(:, j);
    end  
  end
end

% Buscar el minimo de la poblacion
xmin = x(:, 1);
for i = 2:N
  [x_plot1, u_plot_u, time1] = func(xmin);
  [x_plot2, u_plot_x, time2] = func(x(:, i));
  if fit(x_plot1, u_plot_u, time1) > fit(x_plot2, u_plot_x, time2) 
    xmin = x(:, i);
  end
end

xmin

[x_plot, ~, time] = func(xmin);
plot(time, x_plot); 
hold on;
plot(time, xd(time));
figure
plot(time, u_plot_x);

function [x_plot, u_plot, time] = func(w)
  x = 0;
  v = 0;
  t = 0.01;

  E = 0;
  e_old = 0;

  S = 100;
  N = S/t;
  
  x_plot = zeros(1, N);
  u_plot = x_plot;
  time = x_plot;
  
  xd = @(t) 0.5*sin(0.5*t);
  fit = @(xd, x_plot) rms(xd(time) - x_plot);

  for i = 1:N
    e = xd(i*t) - x;
    E = E + e*t;

    u = w(1)*e + (w(2)*E + 1000*(w(2) < 0)) + w(3)*((e - e_old)/t); % aceleracion
    e_old = e;

    v = v + u*t;
    x = x + v*t + (0.5)*u*t^2;

    x_plot(i) = x;
    u_plot(i) = u;
    time(i) = i*t;
  end
end