%% Practica 2
close all; clear all; clc;

%% Figura y componentes
screen = get(0, 'Screensize'); % Obtener resolucion de pantalla
fig = uifigure('Name', 'Practica 2'); % Crear figura para interfaz grafica
fig.Position = [(screen(3)/2)-150 (screen(4)/2)+100 300 250]; % Posicion y dimensiones de figura

% Crear menu para seleccionar funcion
ddMenu = uidropdown(fig, 'Items', {'Funcion 1', 'Funcion 2'});
ddMenu.Position = [100 200 100 30]; % Posicion del menu

% Boton para busqueda aleatoria
randBtn = uibutton(fig, 'Text', 'Busqueda Aleatoria'); % Texto
randBtn.Position = [75 150 150 30]; % Posicion

% Boton para gradiente descendiente
gradBtn = uibutton(fig, 'Text', 'Gradiente Descendiente'); % Texto
gradBtn.Position = [75 100 150 30]; % Posicion

% Tabla para las entradas
inicialLB = uilabel(fig, 'Text', 'p0 ='); % Etiqueta
inicialLB.Position = [75 40 50 25]; % Posicion de etiqueta
inicialTB = uitable(fig, 'Data', [-2; 0], 'Position', [100 20 125 60]); % Tabla
set(inicialTB, 'ColumnEditable', true); % Hacer editable

%% Funciones
% Declaracion de las funciones para los botones
randBtn.ButtonPushedFcn = @(randomBtn, event) randBtnPushed(ddMenu.Value, screen);
gradBtn.ButtonPushedFcn = @(gradBtn, event) gradBtnPushed(ddMenu.Value, inicialTB.Data, screen);

function randBtnPushed(opcion, screen) % Funcion para boton de busqueda aleatoria
    % Figuras para las graficas
    gFig = figure; gFig2 = figure;
    % Posicion de las figuras
    gFig.Position = [(screen(3)/2)-505 (screen(4)/2)-340 500 350];
    gFig2.Position = [(screen(3)/2)+5 (screen(4)/2)-340 500 350];
    % Ejes en las figuras
    ax = axes(gFig); ax2 = axes(gFig2);
    hold(ax, 'on'); hold(ax2, 'on');
    % Inicializacion de variables
    fbest = inf; xbest = 0; ybest = 0;
    % Checar que funcion se eligio
    switch opcion
        case 'Funcion 1'
            % Limites para Funcion 1
            xl = -2; xu = 2;
            yl = -2; yu = 2;
            [x, y] = meshgrid(xl:0.1:xu, yl:0.1:yu); % Meshgrid para la entrada
            z = f1(x, y); % Salidas
            surf(ax, x, y, z); % Graficar funcion en la 1ra figura
            contour(ax2, x, y, z, 20); % Graficar contour en la 2da figura
            % Algoritmo de busqueda aleatoria
            for i = 1:10000 % iteraciones
                x = xl + (xu - xl)*rand;
                y = yl + (yu - yl)*rand;
                fval = f1(x, y); % Evaluar nuevos puntos
                if fval < fbest % Checar si el nuevo valor es menor
                    fbest = fval;
                    xbest = x;
                    ybest = y;
                end
            end
        case 'Funcion 2'
            % Limites para Funcion 2
            xl = -8; xu = 12;
            yl = -8; yu = 12;
            [x, y] = meshgrid(xl:0.3:xu, yl:0.3:yu); % Meshgrid para la entrada
            z = f2(x, y); % Salidas
            surf(ax, x, y, z); % Graficar funcion en la 1ra figura
            contour(ax2, x, y, z, 20); % Graficar contour en la 2da figura
            % Algoritmo de busqueda aleatoria
            for i = 1:10000
                x = xl + (xu - xl)*rand;
                y = yl + (yu - yl)*rand;
                fval = f2(x, y); % Evaluar nuevos puntos
                if fval < fbest % Checar si el nuevo valor es menor
                    fbest = fval;
                    xbest = x;
                    ybest = y;
                end
            end
    end
    % Plotear puntos finales en las 2 figuras
    plot3(ax, xbest, ybest, fbest, 'rx', 'LineWidth', 2, 'MarkerSize', 10);
    plot3(ax2, xbest, ybest, fbest, 'rx', 'LineWidth', 2, 'MarkerSize', 10);
    legend('Contour', 'Minimo');
    view(ax, 30, 15); % Cambiar vista (posicion de camera) de la primera figura
    % Imprimir en consola resultados
    fbest
    xbest
    ybest
end
function gradBtnPushed(opcion, p0, screen) % Funcion para boton de gradiente descendiente
    % Figuras para las graficas
    gFig = figure; gFig2 = figure;
    % Posicion de figuras
    gFig.Position = [(screen(3)/2)-505 (screen(4)/2)-340 500 350];
    gFig2.Position = [(screen(3)/2)+5 (screen(4)/2)-340 500 350];
    % Ejes en las figuras
    ax = axes(gFig); ax2 = axes(gFig2);
    hold(ax, 'on'); hold(ax2, 'on');
    view(ax, 30, 15);% Cambiar vista (posicion de camera) de la primera figura
    % Inicializacion de variable para el algoritmo
    h = 0.2;
    switch opcion
        case 'Funcion 1'
            % Limites para Funcion 1
            xl = -2; xu = 2;
            yl = -2; yu = 2;
            % Graficar funcion entre los limites
            [x, y] = meshgrid(xl:0.1:xu, yl:0.1:yu); % Entradas
            z = f1(x, y); % Evaluacion de entradas
            surf(ax, x, y, z) % Figura 1
            contour(ax2, x, y, z, 20); % Figura 2
            % Plotear puntos iniciales
            plot3(ax, p0(1), p0(2), f1(p0(1), p0(2)), 'rx', 'LineWidth', 2, 'MarkerSize', 10);
            plot3(ax2, p0(1), p0(2), f1(p0(1), p0(2)), 'rx', 'LineWidth', 2, 'MarkerSize', 10);
            % Algoritmo gradiente descendiente
            for i = 1:30
                % Encontrar nuevo punto
                p0 = [p0(1); p0(2)] - h*f1Gradient(p0(1), p0(2));
                % Plotear el nuevo punto
                point = plot3(ax, p0(1), p0(2), f1(p0(1), p0(2)), 'gx', 'LineWidth', 2, 'MarkerSize', 10);
                point2 = plot3(ax2, p0(1), p0(2), f1(p0(1), p0(2)), 'gx', 'LineWidth', 2, 'MarkerSize', 10);
                pause(0.1) % Esperar
                % Si no han terminado las iteraciones borrar los puntos
                % dibujados
                if i < 30
                    delete(point)
                    delete(point2)
                end
            end
            % Imprimir en consola los resultados
            p0
            f1(p0(1), p0(2))
        case 'Funcion 2'
            % Limites para Funcion 2
            xl = -8; xu = 12;
            yl = -8; yu = 12;
            % Graficar funcion entre los limites
            [x, y] = meshgrid(xl:0.3:xu, yl:0.3:yu); % Entradas
            z = f2(x, y); % Salidas
            surf(ax, x, y, z) % Figura 1 
            contour(ax2, x, y, z, 20); % Figura 2
            % Plotear puntos iniciales
            plot3(ax, p0(1), p0(2), f2(p0(1), p0(2)), 'rx', 'LineWidth', 2, 'MarkerSize', 10);
            plot3(ax2, p0(1), p0(2), f2(p0(1), p0(2)), 'rx', 'LineWidth', 2, 'MarkerSize', 10);
            % Algoritmo gradiente descendiente
            for i = 1:30
                % Encontrar nuevo punto
                p0 = [p0(1); p0(2)] - h*f2Gradient(p0(1), p0(2));
                % Plotear el nuevo punto
                point = plot3(ax, p0(1), p0(2), f2(p0(1), p0(2)), 'gx', 'LineWidth', 2, 'MarkerSize', 10);
                point2 = plot3(ax2, p0(1), p0(2), f2(p0(1), p0(2)), 'gx', 'LineWidth', 2, 'MarkerSize', 10);
                pause(0.1) % Esperar
                % Si no han terminado las iteraciones borrar los puntos
                % dibujados
                if i < 30
                    delete(point)
                    delete(point2)
                end
            end
            % Imprimir en consola los resultados
            p0
            f2(p0(1), p0(2))
    end
    % Leyenda para la grafica en la figura 2
    legend(ax2, 'contour', 'p0', 'pf')
end
function out = f1(x, y) % Funcion 1
    out = x.*exp(-(x.^2)-(y.^2));
end
function out = f1Gradient(x, y) % Gradiente de Funcion 1
    out = [(1 - 2*x^2)*exp(-(x.^2)-(y.^2)); -2*x*y*exp(-(x.^2)-(y.^2))];
end
function out = f2(x, y) % Funcion 2
%     d = 2;
%     out = 0;
%     for i = 1:d
%         out = out + (x(i) - 2)^2;
%     end
    % Ya que solo importan los primeros dos valores del vector de entrada
    % Seria lo mismo que la siguente funcion
    out = (x - 2).^2 + (y - 2).^2;
end
function out = f2Gradient(x, y) % Gradiente de Funcion 2
    out = [2*(x - 2); 2*(y - 2)];
end