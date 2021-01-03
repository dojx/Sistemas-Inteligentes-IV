close all;
clear; clc;

%% Datos de entrenamiento
img = imread('rangers.png');
img_n = zeros(size(img));

[H, W, ~] = size(img);
K = H * W;

% Preparar las entradas
x = zeros(3, K);
x(1, :) = reshape(img(:, :, 1), [1 K]);
x(2, :) = reshape(img(:, :, 2), [1 K]);
x(3, :) = reshape(img(:, :, 3), [1 K]);

%% RNA competitiva
M = 4; % Numero de neuronas (grupos)
P = 3; % Dimension de entrada

w = 255 * rand(P, M); % Matriz de pesos
h = zeros(1, M); % Vector para guardar valores de h
ys = zeros(1, K);

eta = 0.0001; % Factor de aprendizaje
epocas = 15; % Numero de epocas o iteraciones

for g = 1 : epocas
    for i = 1 : K
        % Calcular h
        in = [x(1, i) x(2, i) x(3, i)]';
        for j = 1 : M
            h(j) =  w(:, j)'*in - (1/2)*(w(:, j)'*w(:, j));
        end
        
        % Salida de la red
        [~, r] = max(h); % Encontrar neurona ganadora
         
        % Guardar nada mas la posicion de la ganadora
        ys(i) = r;
        
        % Actualizacion de pesos
        w(:, r) = w(:, r) + eta*(in - w(:, r));
    end
    disp(['Epoca: ' num2str(g)]);
end

%% Resultados
figure(1)
subplot(1, 2, 1)
hold on
grid on
scatter3(x(1, :), x(2, :), x(3, :), 'k*');
for i = 1 : M
    % Agrupar
    subplot(1, 2, 1)
    scatter3(x(1, ys == i), x(2, ys == i), x(3, ys == i), 'o', 'MarkerEdgeColor', w(:, i)'/255);
     
    % Plotear neurona
    subplot(1, 2, 2)
    hold on
    grid on
    scatter3(w(1, i), w(2, i), w(3, i), 'filled', 'MarkerFaceColor', w(:, i)'/255);
end
legend('Grupo 1', 'Grupo 2', 'Grupo 3', 'Grupo 4')

%% Crear nueva imagen
for i = 1 : K
    x(:, i) = round(w(:, ys(i)));
end
img_n(:, :, 1) = reshape(x(1, :), [H, W]);
img_n(:, :, 2) = reshape(x(2, :), [H, W]);
img_n(:, :, 3) = reshape(x(3, :), [H, W]);

% Comparar imagenes
figure(2)
subplot(1, 2, 1)
imshow(img)
subplot(1, 2, 2)
imshow(uint8(img_n))