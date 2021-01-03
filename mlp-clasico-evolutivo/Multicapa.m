classdef Multicapa < handle
    properties
        pesos % Arreglo de celdas
        acts % Vector para las funciones de activaciones seleccionadas
    end
    
    methods
        function obj = Multicapa(dim, caps, acts)
            obj.pesos{1} = rand(caps(1), dim + 1) * 10 - 5;
            for i = 2 : length(caps)
                obj.pesos{i} = rand(caps(i), caps(i - 1) + 1) * 10 - 5;
            end
            obj.acts = acts;
        end
        
        function entrenar_clasico(obj, entradas, deseadas, eta, epocas)          
            for i = 0 : epocas
                % Hacia adelante
                % Calcular salida
                entrada = entradas(:, mod(i, size(entradas, 2)) + 1);
                [y, hist_x, hist_v] = obj.predecir(entrada);
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
        
        function entrenar_evolutivo(obj, entradas, deseadas, epocas)
            N = 25; % Tamano de poblacion
            w = 0.6; % Factor de inercia
            c1 = 2; % Factor de aprendizaje cognitivo
            c2 = 2; % Factor de aprendizaje social
            it = 0; % Numero de generaciones que han pasado
            d = 0; % Dimension del problema
            for i = 1 : length(obj.pesos)
                d = d + numel(obj.pesos{i});
            end

            % Inicializacion de vectores de poblacion y velocidad
            x = zeros(d, N);
            v = zeros(d, N);

            % Generar aleatoriamente los vectores
            xl = -3 * ones(d, 1);
            xu = 3 * ones(d, 1);
            for i = 1:N
                x(:, i) = xl + (xu - xl) .* rand(d, 1);
                v(:, i) = xl + (xu - xl) .* rand(d, 1);
            end
            xb = x;

            % Correr por iteraciones
            while it < epocas
                for j = 1:N % Actualizar vector de mejores posiciones dependiendo de su evaluacion
                    if obj.fitness(x(:, j), entradas, deseadas) < obj.fitness(xb(:, j), entradas, deseadas)
                        xb(:, j) = x(:, j);
                    end
                end
                xg = xb(:, 1); % Suponer que la mejor posicion global es primer elemento de xb
                for j = 2:N % Buscar la mejor posicion global
                    if obj.fitness(xb(:, j), entradas, deseadas) < obj.fitness(xg, entradas, deseadas)
                        xg = xb(:, j);
                    end
                end
                for j = 1:N % Actualizar vectores de velocidades y poblacion
                    v(:, j) = w * v(:, j) + c1 * rand * (xb(:, j) - x(:, j)) + c2 * rand * (xg - x(:, j));
                    x(:, j) = x(:, j) + v(:, j);
                end
                it = it + 1;
            end
            
            % Reconstruir pesos
            obj.pesos = obj.reconstruir_pesos(xg);
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
        
        function f = fitness(obj, w, entradas, deseadas)
            w = obj.reconstruir_pesos(w);          
            f = 0;
            for i = 1 : size(entradas, 2)
                x = [1; entradas(i)];
                for j = 1 : length(w)
                    v = w{j} * x;
                    y = Multicapa.activacion(v, obj.acts(j, :));
                    x = [1; y];
                end 
                f = f + (1 / size(entradas, 2)) * (deseadas(i) - y) ^ 2;
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