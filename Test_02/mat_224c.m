% tx_sig_gen_2pam.m
% Generacion de senal 2-PAM con Raised Cosine y diagrama de ojo
clear all; close all;
rng(1264);  % Semilla segun carne
Ts = 1;     % Duracion de un simbolo
L  = 16;    % Muestras por simbolo
t_step = Ts/L;

%%%%%%%%% <1. Pulso Raised Cosine> %%%%%%%%%%%%%%%%%%%%%%
a = 0.25;                              % Factor roll-off
span = 6;                              % Pulso abarca 6 simbolos
pt = rcosdesign(a, span, L, 'normal'); % Pulso Raised Cosine
pt = pt / max(abs(pt));                % Normalizacion

%%%%%%%%% <2. Generacion de Ns simbolos 2-PAM> %%%%%%%%%%
Ns = 1264;
data_bit = (rand(1, Ns) > 0.5);          % Genera bits binarios (0 y 1)
amp_modulated = 2 * data_bit - 1;        % Convierte bits a valores 2-PAM (-1 y 1)

%%%%%%%%% <3. Modulacion de impulsos> %%%%%%%%%%%%%%%%%%%
impulse_modulated = [];
for n = 1:Ns
    delta_signal = [amp_modulated(n) zeros(1, L-1)];
    impulse_modulated = [impulse_modulated delta_signal];
end

%%%%%%%%% <4. Senal transmitida (filtrada con RC)> %%%%%%
tx_signal = conv(impulse_modulated, pt);

%%%%%%%%% <5. Graficar senales base> %%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
stem(amp_modulated(1:50),'LineWidth',1.2);
title('Simbolos PAM-2 (50 primeros)');
xlabel('Simbolo'); ylabel('Nivel PAM-2');
grid on;

subplot(3,1,2);
plot(impulse_modulated(1:200),'LineWidth',1.2);
title('Senal por Impulsos (primeros 200 muestras)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

subplot(3,1,3);
plot(tx_signal(1:400),'LineWidth',1.2);
title('Senal Transmitida (primeros 400 muestras)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

%%%%%%%%% <6. Diagrama de Ojo (3 simbolos)> %%%%%%%%%%%%%
window_len = 3*L;
num_windows = floor(length(tx_signal)/window_len);
figure;
hold on;
for k = 1:num_windows-1
    tmp = tx_signal((k-1)*window_len+1 : k*window_len);
    plot(tmp,'b');
end
title('Diagrama de Ojo PAM-2 (ventana = 3 simbolos)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

%%%%%%%%% <7. Sobreposicion de periodos de 2 simbolos> %%
figure(200)
for k = 3:floor(Ns/2)-1
    tmp = tx_signal(((k-1)*2*L+1):(k*2*L));
    plot(t_step*(0:(2*L-1)), tmp);
    axis([0 2 min(tx_signal) max(tx_signal)]);
    grid on; hold on;
    pause;
end
hold off;