clc; clear; close all;

%% Parámetros
T = 1;              % Duración del símbolo
Fs = 100;           % Frecuencia de muestreo
t = -5*T:1/Fs:5*T;  % Vector de tiempo
beta = 0.5;         % Roll-off

%% Pulso rectangular
p_rect = double(abs(t) <= T/2);

%% Pulso coseno alzado
p_rc = sinc(t/T) .* cos(pi*beta*t/T) ./ (1 - (2*beta*t/T).^2);
p_rc(t==T/(2*beta)) = pi/4; % evitar NaN en t = ±T/(2*β)
p_rc(t==-T/(2*beta)) = pi/4;

%% Transformada de Fourier
N = length(t);
f = (-N/2:N/2-1)*(Fs/N);

P_rect = abs(fftshift(fft(p_rect)));
P_rc = abs(fftshift(fft(p_rc)));

%% Graficas
figure;
subplot(2,2,1)
plot(t, p_rect,'LineWidth',1.5)
title('Pulso Rectangular en Tiempo')
xlabel('t'); ylabel('Amplitud')

subplot(2,2,2)
plot(f, P_rect,'LineWidth',1.5)
title('Espectro del Pulso Rectangular')
xlabel('Frecuencia'); ylabel('|P(f)|')

subplot(2,2,3)
plot(t, p_rc,'LineWidth',1.5)
title('Pulso Coseno Alzado en Tiempo')
xlabel('t'); ylabel('Amplitud')

subplot(2,2,4)
plot(f, P_rc,'LineWidth',1.5)
title('Espectro del Pulso Coseno Alzado')
xlabel('Frecuencia'); ylabel('|P(f)|')

