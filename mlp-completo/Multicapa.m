classdef Multicapa < handle
    properties
        pesos % Arreglo de celdas
        acts % Vector para las funciones de activaciones seleccionadas
        precision % Porcentaje de datos que se han clasificado correctamente
    end
    
    methods
        function obj = Multicapa(dim, caps, acts)
            obj.pesos{1} = rand(caps(1), dim + 1) * 5 - 2.5;
            for i = 2 : length(caps)
                obj.pesos{i} = rand(caps(i), caps(i - 1) + 1) * 5 - 2.5;
            end
            obj.acts = acts;
        end
        
        function entrenar_clasico(obj, entradas, deseadas, eta, epocas)   
            for i = 1 : epocas
                obj.precision = 0;
                for j = 1 : size(entradas, 2)
                    % Hacia adelante
                    % Calcular salida
                    entrada = entradas(:, j);
                    [y, hist_x, hist_v] = obj.predecir(entrada);
                    deseada = deseadas(:, j);
                    
                    if (y >= 0.5 && deseada == 1) || (y < 0.5 && deseada == 0)
                        obj.precision = obj.precision + (1 / size(entradas, 2));
                    end
                    err = deseada - y;

                    % Hacia adelante
                    % Calcular gradientes
                    grads = cell(1, length(obj.pesos));
                    grads{end} = err .* Multicapa.activacion_d(hist_v{end}, obj.acts(end, :));
                    for k = (length(obj.pesos) - 1) : -1 : 1 
                        derivada = Multicapa.activacion_d(hist_v{k}, obj.acts(k, :));
                        grads{k} = derivada .* obj.pesos{k + 1}(:, 2:end)' * grads{k + 1};
                    end

                    % Actualizar pesos
                    for k = (length(obj.pesos)) : -1 : 1 
                        obj.pesos{k} = obj.pesos{k} + eta * grads{k} * hist_x{k}';
                    end
                end   
            end
        end
        
        function [y, hist_x, hist_v] = predecir(obj, entrada)         
            x = [1; entrada];
            hist_x = cell(1, length(obj.pesos));
            hist_v = cell(1, length(obj.pesos));

            for j = 1 : length(obj.pesos)
                hist_x{j} = x;
                v = obj.pesos{j} * x;
                hist_v{j} = v;
                y = Multicapa.activacion(v, obj.acts(j, :));
                x = [1; y];
            end       
        end
    end
    
    methods (Static)
        function y = activacion(x, act)
            switch act
                case 'LIN'
                    y = x;
                case 'TAN'
                    y = tanh(x);
                case 'SIG'
                    y = 1 ./ (1 + exp(-x));
                otherwise
                    y = x;
            end
        end
        
        function y = activacion_d(x, act)
            switch act
                case 'LIN'
                    y = ones(length(x), 1);
                case 'TAN'
                    y = (1 - tanh(x)) .* (1 + tanh(x));
                case 'SIG'
                    y = (1 ./ (1 + exp(-x))) .* (1 - (1 ./ (1 + exp(-x))));
                otherwise
                    y = ones(length(x), 1);
            end
        end
    end
end