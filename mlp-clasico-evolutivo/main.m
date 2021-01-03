close all; clear; clc;

%% Parametros
capas = [10 1];
acts = ['SIG'; 'LIN'];

%% Data 1
% figure(1)
% load data1
% [p_c1, p_e1] = crear_perceptrones(x, d, capas, acts);
% subplot(1, 2, 1)
% plot_multicapa(x, d, p_c1, 0);
% title('Metodo Clasico')
% subplot(1, 2, 2)
% plot_multicapa(x, d, p_e1, 0);
% title('Metodo Evolutivo')

%% Data 2
% figure(2)
% load data2
% [p_c2, p_e2] = crear_perceptrones(x, d, capas, acts);
% subplot(1, 2, 1)
% plot_multicapa(x, d, p_c2, 0);
% title('Metodo Clasico')
% subplot(1, 2, 2)
% plot_multicapa(x, d, p_e2, 0);
% title('Metodo Evolutivo')

%% Data 3
figure(3)
load data3
dn = normalizar(d);
[p_c3, p_e3] = crear_perceptrones(x, dn, capas, acts);

subplot(1, 2, 1)
plot_multicapa(x, d, p_c3, 1);
title('Metodo Clasico')
subplot(1, 2, 2)
plot_multicapa(x, d, p_e3, 1);
title('Metodo Evolutivo')

%% Funciones
function [p_c, p_e] = crear_perceptrones(x, d, capas, acts)
    p_c = Multicapa(1, capas, acts);
    p_e = Multicapa(1, capas, acts);
    
    epocas_c = 20000;
    epocas_e = 100;
    
    p_c.entrenar_clasico(x, d, 0.01, epocas_c);
    p_e.entrenar_evolutivo(x, d, epocas_e);
end

function plot_multicapa(x, d, perceptron, desnorm)
    plot(x, d, 'b*');
    hold on
    
    xlim([min(x) max(x)])
    
    xg = linspace(min(x), max(x), 50);
    yg = linspace(0, 0, 50);
    for i = 1 : length(xg)
        yg(i) = perceptron.predecir(xg(i));
    end
    
    % Desnormalizar 
    if desnorm == 1
        for i = 1 : length(yg)
            yg(i) =  (max(d) - min(d)) * yg(i) + mean(d);
        end
    end
    
    ylim([min(yg) max(yg)])
    
    plot(xg, yg)
end

function y = normalizar(x)
    y = x;
    prom = mean(x);
    min_val = min(x);
    max_val = max(x);
    for i = 1 : length(x)
       y(i) =  (x(i) - prom) / (max_val - min_val);
    end
end