%% Comparación: Pulso Rectangular, RC, RRC y RRC⊗RRC (Octave/MATLAB)
clc; clear; close all;

%% 1. Parámetros
Ts   = 1;         % Duración del símbolo
L    = 16;        % Muestras por símbolo
a    = 0.5;       % Factor de roll-off
span = 6;         % Número de símbolos que abarca
t    = -span/2:Ts/L:span/2; % Vector de tiempo

%% 2. Pulso Rectangular
p_rect = double(abs(t) <= Ts/2);

%% 3. Pulso Raised Cosine (RC)
p_rc = sinc(t/Ts) .* cos(pi*a*t/Ts) ./ (1 - (2*a*t/Ts).^2);
% Evitar NaN en t = ±Ts/(2*a)
idx = abs(2*a*t/Ts) == 1;
p_rc(idx) = pi/4;

%% 4. Pulso Root-Raised Cosine (RRC)
p_rrc = zeros(size(t));
for k = 1:length(t)
    if t(k) == 0
        p_rrc(k) = 1 - a + 4*a/pi;
    elseif abs(t(k)) == Ts/(4*a)
        p_rrc(k) = (a/sqrt(2)) * ((1+2/pi)*sin(pi/(4*a)) + (1-2/pi)*cos(pi/(4*a)));
    else
        p_rrc(k) = (sin(pi*t(k)*(1-a)/Ts) + 4*a*t(k)/Ts*cos(pi*t(k)*(1+a)/Ts)) / ...
                   (pi*t(k)*(1-(4*a*t(k)/Ts)^2));
    end
end

%% 5. RRC ⊗ RRC (equivalente a RC completo en cadena Tx+Rx)
p_rrc_rc = conv(p_rrc, p_rrc, 'same'); % convolución
p_rrc_rc = p_rrc_rc / max(p_rrc_rc) * max(p_rc); % normalizar amplitud

%% 6. Transformadas de Fourier (espectro)
N = length(t);
f = (-N/2:N/2-1)*(L/Ts/N);  % Frecuencia normalizada

P_rect   = abs(fftshift(fft(p_rect)));
P_rc     = abs(fftshift(fft(p_rc)));
P_rrc    = abs(fftshift(fft(p_rrc)));
P_rrc_rc = abs(fftshift(fft(p_rrc_rc)));

%% 7. Graficas
figure('Name','Comparación de Pulsos');

% Pulso Rectangular en tiempo
subplot(4,2,1)
plot(t, p_rect,'LineWidth',1.5)
title('Pulso Rectangular en Tiempo')
xlabel('t [s]'); ylabel('Amplitud')
grid on

% Espectro Pulso Rectangular
subplot(4,2,2)
plot(f, P_rect,'LineWidth',1.5)
title('Espectro Pulso Rectangular')
xlabel('Frecuencia Normalizada'); ylabel('|P(f)|')
grid on

% Pulso Raised Cosine en tiempo
subplot(4,2,3)
plot(t, p_rc,'LineWidth',1.5)
title('Pulso Raised Cosine en Tiempo')
xlabel('t [s]'); ylabel('Amplitud')
grid on

% Espectro Pulso Raised Cosine
subplot(4,2,4)
plot(f, P_rc,'LineWidth',1.5)
title('Espectro Pulso Raised Cosine')
xlabel('Frecuencia Normalizada'); ylabel('|P(f)|')
grid on

% Pulso Root-Raised Cosine en tiempo
subplot(4,2,5)
plot(t, p_rrc,'LineWidth',1.5)
title('Pulso Root-Raised Cosine en Tiempo')
xlabel('t [s]'); ylabel('Amplitud')
grid on

% Espectro Pulso Root-Raised Cosine
subplot(4,2,6)
plot(f, P_rrc,'LineWidth',1.5)
title('Espectro Pulso Root-Raised Cosine')
xlabel('Frecuencia Normalizada'); ylabel('|P(f)|')
grid on

% RRC ⊗ RRC en tiempo (equivale a RC en cadena Tx+Rx)
subplot(4,2,7)
plot(t, p_rrc_rc,'LineWidth',1.5)
title('Convolución RRC ⊗ RRC en Tiempo')
xlabel('t [s]'); ylabel('Amplitud')
grid on

% Espectro RRC ⊗ RRC
subplot(4,2,8)
plot(f, P_rrc_rc,'LineWidth',1.5)
title('Espectro RRC ⊗ RRC (RC completo)')
xlabel('Frecuencia Normalizada'); ylabel('|P(f)|')
grid on

