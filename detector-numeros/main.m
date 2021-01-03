close all; clear; clc;

load data.mat

%% Parametros
capas = [32 32 32 10];
acts = ['TAN'; 'TAN'; 'TAN'; 'SIG'];

% Entrenamiento
X = data(1:40000, 1:end-10)';
D = data(1:40000, end-9:end)';

perc = Multicapa(784, capas, acts);
perc.entrenar_clasico(X, D, 0.1, 1);

% Precision con datos de generalizacion
precision_g = 0;
for i = 40001 : 50000
    xg = data(i, 1:end-10)';
    dg = data(i, end-9:end)';
    prediccion = perc.predecir(xg);
    [~, i1] = max(dg);
    [c1, i2] = max(prediccion);
    if i1 == i2
        precision_g = precision_g + (1 / 10000);
    end
end
precision_g
