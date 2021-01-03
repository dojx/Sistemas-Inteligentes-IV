clc; clear;

%% Load prev data
r = readcell('cell2.txt');
arr = cell2mat(r);

pesos{1} = reshape(arr(1:25120), [32, 785]);
pesos{2} = reshape(arr(25121:26176), [32, 33]);
pesos{3} = reshape(arr(26177:27232), [32, 33]);
pesos{4} = reshape(arr(27233:end), [10, 33]);

load data.mat

%% Parametros
capas = [32 32 32 10];
acts = ['TAN'; 'TAN'; 'TAN'; 'SIG'];

% Entrenamiento
X = data(1:40000, 1:end-10)';
D = data(1:40000, end-9:end)';

perc = Multicapa(784, capas, acts);
perc.pesos = pesos;
perc.entrenar_clasico(X, D, 0.01, 1);

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