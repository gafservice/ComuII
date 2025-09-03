clc; clear; close all;

% Parámetros del filtro
alpha = 0.35;   % Factor de roll-off
span = 6;       % Duración del filtro en símbolos
L = 8;          % Muestras por símbolo

% Diseño del filtro coseno alzado
h = rcosdesign(alpha, span, L, 'normal');

% --- Gráficas ---
% Respuesta al impulso
figure;
stem(h, 'filled');
title(['Respuesta al impulso (Coseno alzado, \alpha = ', num2str(alpha), ')']);
xlabel('Índice de muestra');
ylabel('Amplitud');
grid on;

% Respuesta en frecuencia
[H, f] = freqz(h, 1, 1024, 'whole');
f = f/pi; % Normalizar frecuencia (0 a 1 corresponde a 0 a π rad)
figure;
plot(f, 20*log10(abs(H)));
title(['Respuesta en frecuencia (Coseno alzado, \alpha = ', num2str(alpha), ')']);
xlabel('Frecuencia normalizada (\times \pi rad/muestra)');
ylabel('Magnitud (dB)');
grid on;
