clc; clear; close all;

%% 1. Parámetros
Ts   = 1;         % Duración del símbolo
L    = 16;        % Muestras por símbolo
a    = 0.5;       % Factor de roll-off
span = 6;         % Número de símbolos que abarca
t    = -span/2:Ts/L:span/2; % Vector de tiempo

%% 2. Pulso Root-Raised Cosine (RRC) usando rcosdesign
p_rrc = rcosdesign(a, span, L, 'sqrt');

%% 3. Transformada de Fourier (Magnitud)
N = length(t);
f = (-N/2:N/2-1)*(1/N);  % Frecuencia normalizada
P_rrc  = abs(fftshift(fft(p_rrc)));

%% 4. Instantes de muestreo
n_sym = -span/2:span/2;        % múltiplos de Ts
sample_idx = round((n_sym + span/2) * L + 1); % índices de MATLAB
samples = p_rrc(sample_idx);    % valores del pulso en múltiplos de Ts

%% 5. Graficas
figure('Name','Pulso SRRC y Puntos de Muestreo');

% Pulso SRRC en tiempo
subplot(2,1,1)
plot(linspace(-span/2, span/2, length(p_rrc)), p_rrc, 'b','LineWidth',1.5)
hold on; grid on
stem(n_sym, samples, 'r','LineWidth',1.2,'MarkerFaceColor','r') % puntos de muestreo
xlabel('Tiempo [símbolos]')
ylabel('Amplitud')
title('Pulso Root-Raised Cosine (SRRC) con Puntos de Muestreo')
legend('SRRC','Valores en t=nT_s','Location','Best')

% Espectro
subplot(2,1,2)
plot(f, P_rrc,'b','LineWidth',1.5)
grid on
xlabel('Frecuencia Normalizada (ciclos/símbolo)')
ylabel('|P(f)|')
title('Espectro del Pulso SRRC')
