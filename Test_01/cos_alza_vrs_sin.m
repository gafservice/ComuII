%% Parámetros
Ts = 1;        % Duración del símbolo
L = 16;        % Número de muestras por símbolo
a = 0.5;       % Factor de roll-off
t = -3:Ts/L:3; % Vector de tiempo para el eje x

%% Pulso coseno alzado (raised cosine)
p_rc = sinc(t/Ts) .* cos(pi*a*t/Ts) ./ (1 - (2*a*t/Ts).^2);

% Evitar NaN en t = ±Ts/(2*a)
p_rc(t == Ts/(2*a)) = pi/4;
p_rc(t == -Ts/(2*a)) = pi/4;

%% Pulso rectangular para comparación
p_rect = double(abs(t) <= Ts/2);

%% Transformada de Fourier (espectro)
N = length(t);
f = (-N/2:N/2-1)*(L/Ts/N);  % Frecuencia normalizada

P_rc = abs(fftshift(fft(p_rc)));
P_rect = abs(fftshift(fft(p_rect)));

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

