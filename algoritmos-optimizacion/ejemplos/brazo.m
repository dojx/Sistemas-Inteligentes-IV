% Ejercicio 9
clear all; close all; clc;

N = 100; % Poblacion

w = [0 0 0]; 

F = 1.2;
CR = 0.6;
G = 200; % Generaciones
D = 3; % Dimension del problema

xl = (pi/180)*[-160 -150 -135]';
xu = (pi/180)*[160 150 135]';

x = ones(D, N); % Individuos
v = ones(D, N); % Vector mutado
u = ones(D, N); % Vector de prueba
r1 = 1;
r2 = 1;
r3 = 1;

td = [0.4 0.4 0.4]';

fit = @(ti) norm(td - ti);

a = [0 0.3 0.25]';
alpha = [pi/2 0 0]';
d = [0.35 0 0]';
off = [0 0 0]';

L1 = Revolute('a',a(1),'alpha',alpha(1),'d',d(1),'offset',off(1));%Articulacion 1
L2 = Revolute('a',a(2),'alpha',alpha(2),'d',d(2),'offset',off(2));%Articulacion 2
L3 = Revolute('a',a(3),'alpha',alpha(3),'d',d(3),'offset',off(3));%Articulacion 3
bot = SerialLink([L1 L2 L3],'name','3DOF');% Final

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
    
    ti_x = directa(x(:, j), bot);
    ti_u = directa(u(:, j), bot);

    if fit(ti_u) <  fit(ti_x)
      x(:, j) = u(:, j);
    end  
    
    x(:, j) = restart(x(:, j), xl, xu);
  end
end

xmin = x(:, 1);
for i = 2:N
  if fit(xmin) > fit(x(:, i)) 
    xmin = x(:, i);
  end
end

xmin

bot.fkine(xmin)

function ti = directa(w, bot)  
     T_03 = bot.fkine(w);     
     ti = T_03(1:3, 4);
end

function x = restart(x, xl, xu) % Penalizacion
  if (xl(1) > x(1) || xu(1) < x(1))
     x(1) = xl(1) + (xu(1) - xl(1))*rand;
  end
  if (xl(2) > x(2) || xu(2) < x(2))
     x(2) = xl(2) + (xu(2) - xl(2))*rand;
  end
  if (xl(3) > x(3) || xu(3) < x(3))
     x(3) = xl(3) + (xu(3) - xl(3))*rand;
  end
end