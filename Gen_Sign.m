% tx_sig_gen.m
clear all;
close all;
rng(1264);  % Cambie la semilla según su carnet si lo requiere

Ts = 1;     % Duración de un símbolo
L  = 16;    % Muestras por símbolo
t_step = Ts/L;

%%%%%%%%% <1. Generación del pulso Raised Cosine> %%%%%%%%%%%%%%%%%%%%%%
a = 0.25;                              % Factor de roll-off (0.25)
span = 6;                              % Pulso abarca 6 símbolos
pt = rcosdesign(a, span, L, 'normal'); % Pulso Raised Cosine
pt = pt / max(abs(pt));                % Normalización

%%%%%%%%% <2. Generación de 100 símbolos binarios> %%%%%%%%%%%%%%%%%%%%%
Ns = 100;                              % Número de símbolos
data_bit = (rand(1, Ns) > 0.5);        % Secuencia binaria aleatoria

%%%%%%%%% <3. Modulación unipolar a bipolar> %%%%%%%%%%%%%%%%%%%%%%%%%%%
amp_modulated = 2*data_bit - 1;        % 0 => -1, 1 => +1

%%%%%%%%% <4. Modulación de impulsos> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
impulse_modulated = [];
for n = 1:Ns
    delta_signal = [amp_modulated(n) zeros(1, L-1)];
    impulse_modulated = [impulse_modulated delta_signal];
end

%%%%%%%%% <5. Señal transmitida (filtrada con RC)> %%%%%%%%%%%%%%%%%%%%
tx_signal = conv(impulse_modulated, pt);

%%%%%%%%% <6. Graficar resultados> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
stem(data_bit,'LineWidth',1.2);
title('Datos Binarios (100 símbolos)');
xlabel('Símbolo'); ylabel('Bit');
grid on;

subplot(3,1,2);
plot(impulse_modulated,'LineWidth',1.2);
title('Señal por Impulsos (antes del filtro)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

subplot(3,1,3);
plot(tx_signal,'LineWidth',1.2);
title('Señal Transmitida t(x) = s(t) muestreada (RC, roll-off=0.25)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;