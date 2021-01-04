% Ejercicio 8

clear all; close all; clc;


% vm = 7.0;
% q = 1.5;
% 
% X = [5; 1];
% 
% x = [0; 0]; 
% v = [vm*cos(q); vm*sin(q)];

% a = [0; -9.81]; 
% t = 0.01;
% S = 2;

G = 300; % Generaciones
N = 100; % Poblacion
F = 1.2;
CR = 0.6;

%Limites
xl = [0; pi/4];
xu = [10; pi/2];

% vn = @(x) [x(1)*cos(x(2)); x(1)*sin(x(2))];
% fvx = @(x) vn(x) + a*t;
% fx = @(x) x + fvx(x)*t + 0.5*a*t^2;
% e = @(x) norm(X - fx(x));

w = ones(2, N); % Individuos
v = ones(2, N); % Vector mutado
u = ones(2, N); % Vector de prueba
r1 = 1;
r2 = 1;
r3 = 1;

for i = 1:N
  w(:, i) = xl + (xu - xl).*rand(2, 1); % Inicializacion aleatoria
end

for i = 1:G
  % Evolucion Diferencial
  for j = 1:N
    while j == r1 || j == r2 || j == r3 || r1 == r2 || r1 == r3 || r2 == r3
      r1 = randi([1 N]);
      r2 = randi([1 N]);
      r3 = randi([1 N]);
    end
    v(:, j) = w(:, r1) + F*(w(:, r2) - w(:, r3));

    for k = 1:2
      if rand <= CR
        u(k, j) = v(k, j);
      else
        u(k, j) = w(k, j);
      end
    end
    
    if tiro(u(:, j)) < tiro(w(:, j)) 
      w(:, j) = u(:, j);
    end  
  end
end

x = [0; 0];
v = [w(1, 10)*cos(w(2)); w(2, 10)*sin(w(2))];
s = 2;
t = 0.01;
a = [0; -9.81];
X = [5; 1];

for i = 1:(s/t) 
  v = v + a*t;
  x = x + v*t + 0.5*a*t^2;
    
  clf
  hold on
  grid on

  Dibujar_Circulo(x,0.5,[0 0 1])
  Dibujar_Circulo(X,0.5,[0 1 0])

  xlabel('x')
  ylabel('y')

  axis([-5 15 -5 15])
  pause(t)
end

function z = tiro(x)
  xd = [5; 1];
  a = [0; -9.81];
  v = [x(1)*cos(x(2)); x(1)*sin(x(2))];
  t = 0.01;
  s = 2;
  minn = 9999;
  for i = 1:(s/t)
    v = v + a*t;
    x = x + v*t + (0.5)*a*t^2;
    if norm(xd - x) < minn
      z = norm(xd - x);
      minn = z;
    end
  end
  z = z + 1000*penalty(x(2));
end

function z = penalty(q) 
  if pi/4 < q < pi/2
    z = 0;
  else
    z = 1;
  end
end


function Dibujar_Circulo (p,r,color)
  theta = linspace(0,2*pi,50);

  x = p(1) + r*cos(theta);
  y = p(2) + r*sin(theta);

  plot(x,y,'-','LineWidth',2,'MarkerSize',10,'color',color)
  plot(p(1),p(2),'.r','LineWidth',2,'MarkerSize',10)
end