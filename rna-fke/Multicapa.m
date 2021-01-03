classdef Multicapa < handle
    properties
        K % Matriz de ganancias de Kalman
        P % Matriz de covarianza de error de prediccion
        H % Derivadas parciales de la salida de la red con respecto a cada peso
        R % Error de covarianza de medicion
        Q % Matriz de covarianza del ruido del proceso
        w % Vector que contiene todos los pesos
        pesos % Arreglo de celdas
        acts % Vector para las funciones de activaciones seleccionadas
        predicciones % Vector de predicciones hechas por la red
    end
    
    methods
        function obj = Multicapa(dim, caps, acts)
            obj.pesos{1} = rand(caps(1), dim + 1) * 2 - 1;
            obj.w = reshape(obj.pesos{1}', [1, numel(obj.pesos{1})]);
            for i = 2 : length(caps)
                obj.pesos{i} = rand(caps(i), caps(i - 1) + 1) * 2 - 1;
                obj.w = [obj.w reshape(obj.pesos{i}', [1, numel(obj.pesos{i})])];
            end
            obj.w = obj.w';
            obj.acts = acts;
            obj.H = zeros(length(obj.w), 1);
            obj.K = zeros(length(obj.w), 1);
            obj.P = eye(length(obj.w));
            obj.Q = eye(length(obj.w)) * 0.01;
            obj.R = 0.001;
        end
        
        function entrenar(obj, entradas, deseadas, eta, epocas)   
            for i = 1 : epocas
                for j = 1 : size(entradas, 2)
                    entrada = entradas(:, j);
                    [y, hist_x, hist_v] = obj.predecir(entrada);
                    obj.predicciones(j) = y;
                    deseada = deseadas(:, j);                  
                    
                    err = deseada - y;
                    
                    dy_dv = Multicapa.activacion_d(hist_v{end}, obj.acts(end, :));
                    for m = 1 : length(hist_x{end})
                        obj.H(length(obj.H) - length(hist_x{end}) + m) =  dy_dv * hist_x{end}(m);
                    end
                    
                    if length(obj.pesos) > 1
                        dyo_dv = Multicapa.activacion_d(hist_v{end - 1}, obj.acts(end - 1, :));
                        for k = 1 : length(dyo_dv)
                            for m = 1 : length(hist_x{end - 1})
                                obj.H((k - 1) * length(hist_x{end - 1}) + m) = dy_dv * obj.pesos{end}(k+1) * dyo_dv(k) * hist_x{end - 1}(m);
                            end
                        end
                    end
                     
                    obj.K = obj.P * obj.H * (obj.R + obj.H' * obj.P * obj.H)^(-1);
                    obj.w = obj.w + (eta * obj.K * err);
                    obj.P = obj.P - (obj.K * obj.H' * obj.P) + obj.Q;
                    
                    obj.pesos = obj.reconstruir_pesos(obj.w);
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
        
        function w = reconstruir_pesos(obj, pesos)
            offset = 1;
            w = cell(1, length(obj.pesos));
            for i = 1 : length(w)
                filas = size(obj.pesos{i}, 1); 
                vec = pesos(offset : offset + numel(obj.pesos{i}) - 1);
                offset = offset + numel(obj.pesos{i});
                w{i} = reshape(vec, filas, []);
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