%% Comparación de Pulsos: Rectangular, RC y RRC (MATLAB con rcosdesign)
clc; clear; close all;

%% 1. Parámetros
Ts   = 1;                 % Duración del símbolo
L    = 16;                % Muestras por símbolo
span = 6;                 % Pulso abarca 6 símbolos
a    = 0.5;               % Factor de roll-off
colors = {'k','b','r'};   % Rectangular, RC, RRC
labels = {'Rectangular','RC (\beta=0.5)','RRC (\beta=0.5)'};

%% 2. Vector de tiempo
t = -span/2:Ts/L:span/2;  % Tiempo centrado en 0

%% 3. Pulso Rectangular
p_rect = double(abs(t) <= Ts/2);

%% 4. Pulso Raised Cosine usando rcosdesign
p_rc = rcosdesign(a, span, L, 'normal');  % RC

%% 5. Pulso Root Raised Cosine usando rcosdesign
p_rrc = rcosdesign(a, span, L, 'sqrt');   % RRC

%% 6. Transformadas de Fourier (Magnitud)
N = max([length(p_rect), length(p_rc), length(p_rrc)]);
f = (-N/2:N/2-1)*(1/N);  % Frecuencia normalizada

P_rect = abs(fftshift(fft(p_rect, N)));
P_rc   = abs(fftshift(fft(p_rc, N)));
P_rrc  = abs(fftshift(fft(p_rrc, N)));

%% 7. Graficas
figure('Name','Comparación de Pulsos (Rectangular, RC y RRC)');

% --- Tiempo ---
subplot(2,1,1)
hold on; grid on
plot(t, p_rect, 'Color', colors{1}, 'LineWidth', 1.5)
plot(linspace(-span/2, span/2, length(p_rc)), p_rc, 'Color', colors{2}, 'LineWidth', 1.5)
plot(linspace(-span/2, span/2, length(p_rrc)), p_rrc, 'Color', colors{3}, 'LineWidth', 1.5)
xlabel('Tiempo [símbolos]')
ylabel('Amplitud')
title('Comparación de Pulsos en Tiempo')
legend(labels, 'Location', 'Best')

% Marcar límites truncados de RC y RRC
ymax = max([p_rc,p_rrc]);
plot([-span/2, -span/2], [0 ymax], 'k--', 'LineWidth', 1)
plot([ span/2,  span/2], [0 ymax], 'k--', 'LineWidth', 1)
text(-span/2, ymax*0.9, ['- ' num2str(span/2) 'T_s'], 'HorizontalAlignment','right')
text( span/2, ymax*0.9, ['+ ' num2str(span/2) 'T_s'], 'HorizontalAlignment','left')

% --- Frecuencia ---
subplot(2,1,2)
hold on; grid on
plot(f, P_rect, 'Color', colors{1}, 'LineWidth', 1.5)
plot(f, P_rc,   'Color', colors{2}, 'LineWidth', 1.5)
plot(f, P_rrc,  'Color', colors{3}, 'LineWidth', 1.5)
xlabel('Frecuencia Normalizada (ciclos/símbolo)')
ylabel('|P(f)|')
title('Comparación de Pulsos en Frecuencia')
legend(labels, 'Location', 'Best')
xlim([-0.5 0.5])
