%% Comparación de Pulsos: Rectangular, RC y RRC (MATLAB con rcosdesign)
clc; clear; close all;

%% 1. Parámetros
Ts   = 1;        % Duración del símbolo
L    = 16;       % Muestras por símbolo
a    = 0.5;      % Factor de roll-off
span = 6;        % Pulso abarca 6 símbolos
t    = -span/2:Ts/L:span/2; % Vector de tiempo

%% 2. Pulso Rectangular
p_rect = double(abs(t) <= Ts/2);

%% 3. Pulso Raised Cosine (RC) usando rcosdesign
p_rc = rcosdesign(a, span, L, 'normal');
t_rc = linspace(-span/2, span/2, length(p_rc));

%% 4. Pulso Root-Raised Cosine (RRC) usando rcosdesign
p_rrc = rcosdesign(a, span, L, 'sqrt');
t_rrc = linspace(-span/2, span/2, length(p_rrc));

%% 5. Transformadas de Fourier (Magnitud)
N = max([length(t), length(p_rc), length(p_rrc)]);
f = (-N/2:N/2-1)*(1/N);  % Frecuencia normalizada

P_rect = abs(fftshift(fft(p_rect, N)));
P_rc   = abs(fftshift(fft(p_rc, N)));
P_rrc  = abs(fftshift(fft(p_rrc, N)));

%% 6. Graficas
figure('Name','Comparación de Pulsos', 'Color','w');

% Pulso Rectangular en tiempo
subplot(3,2,1)
plot(t, p_rect,'LineWidth',1.5)
title('Pulso Rectangular en Tiempo')
xlabel('t [símbolos]'); ylabel('Amplitud')
grid on

% Espectro Pulso Rectangular
subplot(3,2,2)
plot(f, P_rect,'LineWidth',1.5)
title('Espectro Pulso Rectangular')
xlabel('Frecuencia Normalizada'); ylabel('|P(f)|')
grid on

% Pulso Raised Cosine en tiempo
subplot(3,2,3)
plot(t_rc, p_rc,'LineWidth',1.5)
title('Pulso Raised Cosine en Tiempo')
xlabel('t [símbolos]'); ylabel('Amplitud')
grid on

% Espectro Pulso Raised Cosine
subplot(3,2,4)
plot(f, P_rc,'LineWidth',1.5)
title('Espectro Pulso Raised Cosine')
xlabel('Frecuencia Normalizada'); ylabel('|P(f)|')
grid on

% Pulso Root-Raised Cosine en tiempo
subplot(3,2,5)
plot(t_rrc, p_rrc,'LineWidth',1.5)
title('Pulso Root-Raised Cosine (sqrt) en Tiempo')
xlabel('t [símbolos]'); ylabel('Amplitud')
grid on

% Espectro Pulso Root-Raised Cosine
subplot(3,2,6)
plot(f, P_rrc,'LineWidth',1.5)
title('Espectro Pulso Root-Raised Cosine (sqrt)')
xlabel('Frecuencia Normalizada'); ylabel('|P(f)|')
grid on
