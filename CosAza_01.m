%% Comparación de Pulsos Coseno Alzado - Tiempo y Frecuencia
clc; clear; close all;

%% 1. Parámetros
Ts = 1;                          % Duración del símbolo
L  = 16;                         % Muestras por símbolo
span = 6;                        % Pulso abarca 6 símbolos
roll_offs = [0 0.25 0.5 0.75 1]; % Factores de roll-off
colors = {'r','g','b','m','k'};  % Colores para cada curva

%% 2. Crear figura
figure('Renderer','painters');

%% 3. Graficar en tiempo
subplot(2,1,1)
hold on; grid on
xlabel('Tiempo (símbolos)')
ylabel('Amplitud')
title('Pulso Coseno Alzado en Tiempo')
legend_entries = cell(1,length(roll_offs));

for k = 1:length(roll_offs)
    beta = roll_offs(k);
    pt = rcosdesign(beta, span, L, 'normal');         % Pulso coseno alzado
    t = linspace(-span/2*Ts, span/2*Ts, length(pt));  % Vector de tiempo
    
    plot(t, pt, 'Color', colors{k}, 'LineWidth', 1.5)
    legend_entries{k} = ['\beta = ' num2str(beta)];
end

legend(legend_entries, 'Location','Best')

%% 4. Graficar en frecuencia
subplot(2,1,2)
hold on; grid on
xlabel('Frecuencia Normalizada (ciclos/símbolo)')
ylabel('|P(f)|')
title('Espectro de Pulsos Coseno Alzado')

for k = 1:length(roll_offs)
    beta = roll_offs(k);
    pt = rcosdesign(beta, span, L, 'normal');
    N = length(pt);
    F = linspace(-0.5, 0.5, N);        % Frecuencia normalizada
    Pt = abs(fftshift(fft(pt)));       % Magnitud del espectro
    
    plot(F, Pt, 'Color', colors{k}, 'LineWidth', 1.5)
end

legend(legend_entries, 'Location','Best')
