%% Comparación de Pulsos Rectangulares - Tiempo y Frecuencia
clc; clear; close all;

%% 1. Parámetros
Ts = 1;           % Duración del símbolo
L  = 16;          % Muestras por símbolo
span = 6;         % Número de símbolos que abarca el pulso (para compatibilidad con RC)
roll_offs = [0 0.25 0.5 0.75 1]; % Solo para etiqueta, no afecta al pulso rectangular
colors = {'r','g','b','m','k'};  % Colores para cada curva

%% 2. Crear figura
figure('Renderer','painters');

%% 3. Graficar en tiempo
subplot(2,1,1)
hold on; grid on
xlabel('Tiempo [símbolos]')
ylabel('Amplitud')
title('Pulso Rectangular en Tiempo')
legend_entries = cell(1,length(roll_offs));

for k = 1:length(roll_offs)
    % Pulso rectangular de duración Ts
    pt = ones(1, span*L);  % mismo largo que RC para compatibilidad
    t = linspace(-span/2*Ts, span/2*Ts, length(pt));
    
    plot(t, pt, 'Color', colors{k}, 'LineWidth', 1.5)
    legend_entries{k} = ['Pulso rectangular (label \beta = ' num2str(roll_offs(k)) ')'];
end

% Marcar los límites
ymax = max(pt);
plot([-span/2, -span/2], [0 ymax], 'k--', 'LineWidth', 1.2)
plot([ span/2,  span/2], [0 ymax], 'k--', 'LineWidth', 1.2)
text(-span/2, ymax*0.9, ['- ' num2str(span/2) 'T_s'], ...
    'HorizontalAlignment','right','Color','k')
text( span/2, ymax*0.9, ['+ ' num2str(span/2) 'T_s'], ...
    'HorizontalAlignment','left','Color','k')

xlim([-span/2-1, span/2+1])
ylim([0 ymax*1.2])
legend(legend_entries, 'Location','Best')

%% 4. Graficar en frecuencia
subplot(2,1,2)
hold on; grid on
xlabel('Frecuencia Normalizada (ciclos/símbolo)')
ylabel('|P(f)|')
title('Espectro de Pulsos Rectangulares')

for k = 1:length(roll_offs)
    pt = ones(1, span*L);  % mismo pulso rectangular
    N = length(pt);
    F = linspace(-0.5, 0.5, N);
    Pt = abs(fftshift(fft(pt)));
    
    plot(F, Pt, 'Color', colors{k}, 'LineWidth', 1.5)
end

legend(legend_entries, 'Location','Best')
xlim([-0.5 0.5])
