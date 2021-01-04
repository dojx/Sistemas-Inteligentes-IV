% Diego Omar Jimenez Navarro
close all, clear all, clc, format compact

% No. de puntos para cada grupo
K = 100;
% Inicializar puntos aleatorios para cada grupo
q = .6; % Offset
A = [rand(1,K)-q; rand(1,K)+q];
B = [rand(1,K)+q; rand(1,K)+q];
C = [rand(1,K)+q; rand(1,K)-q];
D = [rand(1,K)-q; rand(1,K)-q];
% Plotear puntos
figure(1)
plot(A(1,:),A(2,:),'k+')
hold on
grid on
plot(B(1,:),B(2,:),'bd')
plot(C(1,:),C(2,:),'k+')
plot(D(1,:),D(2,:),'bd')
% Texto
text(.5-q,.5+2*q,'Class A')
text(.5+q,.5+2*q,'Class B')
text(.5+q,.5-2*q,'Class A')
text(.5-q,.5-2*q,'Class B')

% Agrupar dos grupos como un solo grupo
% A con C y B con D
a = -1; 
c = -1; 
b =  1; 
d =  1; 

% Juntar los grupos para entrenar
P = [A B C D];
% Salidas deseadas para cada grupo
T = [repmat(a,1,length(A)) repmat(b,1,length(B)) ...
     repmat(c,1,length(C)) repmat(d,1,length(D)) ];

% Utilizar herramientas de "Deep Learning Toolbox"
% Para crear red neuronal
% No. de neuronas para cada capa oculta (2)
net = feedforwardnet([5 3]); 
% Tipo de entrenamiento
% 'traingd' = gradiente descendiente
% 'trainlm' = levenberg-marquardt
net.trainFcn = 'traingd'; 

% Parametro para red de entrenamiento
net.divideParam.trainRatio = 1; 
net.divideParam.valRatio   = 0; 
net.divideParam.testRatio  = 0;

% Entrenar
[net,tr,Y,E] = train(net,P,T);

% Ver red 
view(net)

% Plotear respuesta deseada sobre respuesta obtenida
figure(2)
plot(T','linewidth',2)
hold on
plot(Y','r--')
grid on
legend('Targets','Network response','location','best')
ylim([-1.25 1.25])

% Crear meshgrid
span = -1:.005:2;
[P1,P2] = meshgrid(span,span);
pp = [P1(:) P2(:)]';

% Pasar meshgrid por red entrenada
aa = net(pp);

% Plotear resultados de entrenamiento
figure(1)
mesh(P1,P2,reshape(aa,length(span),length(span))-5);
colormap cool
view(2)