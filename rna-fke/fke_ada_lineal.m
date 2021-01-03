close all; 
clear; clc;

load data_lineal

capas = 1;
acts = 'LIN';

ada = Multicapa(1, capas, acts);
ada.entrenar(X, D, 0.001, 1000);

gx = -5:15;
w = ada.pesos{1}
gy = gx * w(2) + w(1);

plot(X, D, 'b*')
hold on 
plot(gx, gy, 'r')