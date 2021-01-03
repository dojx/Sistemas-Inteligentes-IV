classdef Multicapa < handle
    properties
        pesos % Arreglo de celdas
        acts % Vector para las funciones de activaciones seleccionadas
        predicciones % Vector de predicciones hechas por la red
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
            for i = 0 : epocas
                % Hacia adelante
                % Calcular salida
                entrada = entradas(:, mod(i, size(entradas, 2)) + 1);
                [y, hist_x, hist_v] = obj.predecir(entrada);
                obj.predicciones(mod(i, size(entradas, 2)) + 1) = y;
                deseada = deseadas(:, mod(i, size(deseadas, 2)) + 1);
                err = deseada - y;

                % Hacia adelante
                % Calcular gradientes
                grads = cell(1, length(obj.pesos));
                grads{end} = err .* Multicapa.activacion_d(hist_v{end}, obj.acts(end, :));
                for j = (length(obj.pesos) - 1) : -1 : 1 
                    derivada = Multicapa.activacion_d(hist_v{j}, obj.acts(j, :));
                    grads{j} = derivada .* obj.pesos{j + 1}(:, 2:end)' * grads{j + 1};
                end
                
                % Actualizar pesos
                for j = (length(obj.pesos)) : -1 : 1 
                    obj.pesos{j} = obj.pesos{j} + eta * grads{j} * hist_x{j}';
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