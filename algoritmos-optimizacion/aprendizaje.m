%Practica 8
clear; clc; close all;

N = 100; % Poblacion
D = 2; % Dimension
G = 200; % Generaciones
x = zeros(D,N);
c=x;
fit = zeros(1,N);
fitness=fit;
%f = @(x,y) (x-2).^2+(y-2).^2; % Esfera
xl = [-5 -5]';
xu = [5 5]';

for i=1:N
x(:,i) = xl + (xu-xl).*rand(D,1);
end

for z=1:G
  for i=1:N

  for a=1:N
    fit(a) = f(x(1,a),x(2,a));
  end

     [~,gla]=min(fit);
    tf=randi([1,2],1,1);
    for j=1:D
    xj=sum(x(j,:))/N;
    c(j,i)=x(j,i)+rand*(x(j,gla)-tf*xj);
    end
    if f(c(1,i),c(2,i))<f(x(1,i),x(2,i))
    x(:,i)=c(:,i);
    end


    k=i;
    while k==i
    k=randi([1,N],1,1);
    end

    if f(x(1,i),x(2,i))<f(x(1,k),x(2,k))

    for j=1:D
    c(j,i)=x(j,i)+rand*(x(j,i)-x(j,k));

    end

    else

       for j=1:D
       c(j,i)=x(j,i)+rand*(x(j,k)-x(j,i));
       end

    end

     if f(c(1,i),c(2,i))<f(x(1,i),x(2,i))
    x(:,i)=c(:,i);
    end
  end
  for a=1:N
    fit(a) = f(x(1,a),x(2,a));
  end
end
for i=1:N
fitness(i) = f(x(1,i),x(2,i));
end
[~,gl]=min(fitness);
z=x;
disp([' mínimo global en: x=' num2str(z(1,gl)) ', y=' num2str(z(2,gl)) ', f(x,y)=' num2str(f(z(1,gl),z(2,gl)))])%
function y = f(a, b)  
  xx=[a,b]; % vector a usar en las funciones 

  % GRIEWANK
  % sum = 0;
  % prod = 1;
  % 
  % for ii = 1:2
  % 	xi = xx(ii);
  % 	sum = sum + xi^2/4000;
  % 	prod = prod * cos(xi/sqrt(ii));
  % end
  % 
  % y = sum - prod + 1;

  %RASTRIGIN
  sum = 0;
  for ii = 1:2
    xi = xx(ii);
    sum = sum + (xi^2 - 10*cos(2*pi*xi));
  end

  y = 10*2 + sum;
end