%% Practica 1
close all;clear all;clc;
%% Figura y Componentes
screen = get(0, 'Screensize'); % Obtener resolucion de pantalla
fig = uifigure('Name', 'Practica 1'); % Crear figura con interfaz grafica
fig.WindowState = 'maximized'; % Maximizar pantalla

% Crear los ejes de las 3 graficas
ax1 = uiaxes(fig, 'Position', [0 (3/5)*screen(4) (3/4)*screen(3) (3/10)*screen(4)]);
hold(ax1,'on') % Para poder plotear sobre una grafica sin borrar lo que ya estaba
ax2 = uiaxes(fig, 'Position', [0 (3/10)*screen(4) (3/4)*screen(3) (3/10)*screen(4)]);
hold(ax2,'on') % Eje 2
ax3 = uiaxes(fig, 'Position', [0 0 (3/4)*screen(3) (3/10)*screen(4)]);
hold(ax3,'on') % Eje 3

% Crear menu para seleccionar ecuacion
dd = uidropdown(fig, 'Items', {'Ecuacion 1', 'Ecuacion 2', 'Ecuacion 3'});
dd.Position = [(5/6)*screen(3) (1/2)*screen(4)+100 100 30]; % Posicion del menu
dd.ValueChangedFcn = @(dd, event) selection(dd, ax1, ax2, ax3);% Declaracion de su funcion

% Crear caja de texto editable para el punto inicial
edt = uieditfield(fig, 'numeric'); % Tipo de dato que recibe
edt.ValueDisplayFormat = '%0.4f'; % No. de decimales(5)
edt.Position = [(5/6)*screen(3) (1/2)*screen(4) 100 30]; % Posicion

% Boton para buscar min/max
btn = uibutton(fig, 'Text', 'Buscar Min/Max'); % Texto
btn.Position = [(5/6)*screen(3) (1/2)*screen(4)-100 100 30]; % Posicion
btn.ButtonPushedFcn = @(btn, event) buttonPushed(ax1, ax2, ax3, edt, dd.Value); % Declaracion de su funcion

selection(dd, ax1, ax2, ax3); % Plotear la ecuacion 1 y sus derivadas
% Es la opcion que aparece por default cuando se ejecuta el programa
%% Funciones
function out = fx(x)% Ec.1
    out = x.^4 + 5*x.^3 + 4*x.^2 - 4*x + 1;
end
function out = fxp(x)% Ec.1 1ra Derivada
    out = 4*x.^3 + 15*x.^2 + 8*x - 4;
end
function out = fxpp(x)% Ec.1 2da Derivada
    out = 12*x.^2 + 30*x + 8;
end
function out = fa(a)% Ec.2
    out = sin(2*a);
end
function out = fap(a)% Ec.2 1ra Derivada
    out = 2*cos(2*a);
end
function out = fapp(a)% Ec.2 2da Derivada
    out = -4*sin(2*a);
end
function out = ft(t)% Ec.3
    out = sin(t) + t.*cos(t);
end
function out = ftp(t)% Ec.3 1ra Derivada
    out = 2*cos(t) - t.*sin(t);
end
function out = ftpp(t)% Ec.3 2da Derivada
    out = -3*sin(t) - t.*cos(t);
end
function selection(dd, ax1, ax2, ax3) % Plotear ecuaciones (funcion del menu)
    cla(ax1); cla(ax2); cla(ax3); % Limpiar los ejes de las graficas
    
    % Intervalos
    x = -4:0.1:1;
    a = -4:0.1:4;
    t = -5:0.1:5;

    % Tomar el valor seleccionado en el menu y plotear la grafica
    % correspondiente
    switch dd.Value
        case 'Ecuacion 1'
            plot(ax1, x, fx(x), '--b'); % Ec. 1
            ax1.Title.String = 'f(x) = x^{4} + 5x^{3} + 4x^{2} - 4x + 1, x \epsilon [-4, 1]'; 
            plot(ax2, x, fxp(x), '--g'); % Ec. 1 primera derivada
            ax2.Title.String = 'f''(x) = 4x^{3} + 15x^{2} + 8x - 4, x \epsilon [-4, 1]'; 
            plot(ax3, x, fxpp(x), '--r'); % Ec. 1 segunda derivada
            ax3.Title.String = 'f''''(x) = 12x^{2} + 30x + 8, x \epsilon [-4, 1]'; 
        case 'Ecuacion 2'
            plot(ax1, a, fa(a), '--b'); % Ec. 2
            ax1.Title.String = 'f(\alpha) = sin(2\alpha), \alpha \epsilon [-4, 4]';
            plot(ax2, a, fap(a), '--g'); % Ec. 2 primera derivada
            ax2.Title.String = 'f''(\alpha) = 2cos(2\alpha), \alpha \epsilon [-4, 4]';
            plot(ax3, a, fapp(a), '--r'); % Ec. 2 segunda derivada
            ax3.Title.String = 'f''''(\alpha) = -4sin(2\alpha), \alpha \epsilon [-4, 4]';
        case 'Ecuacion 3'
            plot(ax1, t, ft(t), '--b'); % Ec. 3
            ax1.Title.String = 'f(\theta) = sin(\theta) + \thetacos(\theta), \theta \epsilon [-5, 5]';
            plot(ax2, t, ftp(t), '--g'); % Ec. 3 primera derivada
            ax2.Title.String = 'f''(\theta) = 2cos(\theta) - \thetasin(\theta), \theta \epsilon [-5, 5]';
            plot(ax3, t, ftpp(t), '--r'); % Ec. 3 segunda derivada
            ax3.Title.String = 'f''''(\theta) = -3sin(\theta) - \thetacos(\theta), \theta \epsilon [-5, 5]';
    end
end
function buttonPushed(ax1, ax2, ax3, edt, plt) % Buscar min/max (funcion del boton)
    % Aplicar el metodo Newton
    x0 = edt.Value; % Punto inicial
    it = 6; % No. de iteraciones + 1
    for i = 1:it
        % Ver que ecuacion esta seleccionada y evaluar x0 (punto inicial)
        switch plt
            case 'Ecuacion 1'
                f = fx(x0);
                fp = fxp(x0);
                fpp = fxpp(x0);
            case 'Ecuacion 2'
                f = fa(x0);
                fp = fap(x0);
                fpp = fapp(x0);
            case 'Ecuacion 3'
                f = ft(x0);
                fp = ftp(x0);
                fpp = ftpp(x0);
        end
        % Plotear los puntos en la grafica
        circulo1 = plot(ax1, x0, f, 'o', ...
                'LineWidth', 1, ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', 'r', ...
                'MarkerSize', 5);
        circulo2 = plot(ax2, x0, fp, 'o', ...
                'LineWidth', 1, ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', 'r', ...
                'MarkerSize', 5);
        circulo3 = plot(ax3, x0, fpp, 'o', ...
                'LineWidth', 1, ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', 'r', ...
                'MarkerSize', 5);
        pause(1) % Esperar un segundo despues de plotear los puntos
        
        % Si el for no ha terminado, borrar los puntos dibujados y
        % usar el metodo de Newton para encontrar el siguiente valor
        if i < it
            delete(circulo1)
            delete(circulo2)
            delete(circulo3)
            x0 = x0 - fp/fpp; % Encontrar el siguiente valor
        % Si ya termino, buscar si x0 es un minimo o un maximo
        % dependiendo del valor de la segunda derivada
        else
            % Si es negativo imprime que es un maximo 
            if fpp < 0
                % Sin punto y coma para imprimir en consola
                str = {' Maximo:', strcat(' x=', num2str(x0), ', f(x)=', num2str(f))};
                text(ax1, x0, f, str, 'FontSize', 13);
            % Si es positivo imprime que es un minimo 
            elseif fpp > 0
                str = {' Minimo:', strcat(' x=', num2str(x0), ', f(x)=', num2str(f))};
                text(ax1, x0, f, str, 'FontSize', 13);
            end
            % Imprimir las coordenadas del punto final
            text(ax2, x0, fp, strcat(' f''(x)=', num2str(fp)), 'FontSize', 13);
            text(ax3, x0, fpp, strcat(' f''''(x)=', num2str(fpp)), 'FontSize', 13);
        end
        edt.Value = x0;
    end 
    % Imprimir en Command Window el resultado
    str(1) % Si es minimo o maximo
    x0 % El maximo o minimo
    f % La funcion evaluada en ese punto
end
%% Resultados
% Ecuacion 1
% Minimo en x = -2.9603
% Maximo en x = -1.0975
% Minimo en x = 0.3078
% Ecuacion 2
% Minimo en x = -3.9270
% Maximo en x = -2.3562
% Minimo en x = -0.7854
% Maximo en x = 0.7854
% Minimo en x = 2.3562
% Maximo en x = 3.9270
% Ecuacion 3
% Maximo en x = -3.6436
% Minimo en x = -1.0769
% Maximo en x = 1.0769
% Minimo en x = 3.6436