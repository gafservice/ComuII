% tx_sig_gen_PAM4_sin_RC.m
% Generacion de senal PAM-4 sin Raised Cosine
clear all; close all;
rng(1264);  % Semilla segun carne
Ts = 1;     % Duracion de un simbolo
L  = 16;    % Muestras por simbolo
t_step = Ts/L;

%%%%%%%%% <1. Pulso (Pulso rectangular) > %%%%%%%%%%%%%%%%%%%%%%
% Se omite el pulso de coseno alzado
pt = ones(1, L);
pt = pt / max(abs(pt));                % Normalizacion

%%%%%%%%% <2. Generacion de Ns simbolos PAM-4> %%%%%%%%%%
Ns = 1264;
amp_modulated = 2*ceil(rand(1, Ns)*4) - 5;  
% Genera los simbolos 4-arios {-3, -1, 1, 3}

%%%%%%%%% <3. Modulacion de impulsos> %%%%%%%%%%%%%%%%%%%
impulse_modulated = [];
for n = 1:Ns
    delta_signal = [amp_modulated(n) zeros(1, L-1)];
    impulse_modulated = [impulse_modulated delta_signal];
end

%%%%%%%%% <4. Senal transmitida (filtrada con pulso rectangular)> %%%%%%
% Se utiliza un pulso rectangular en lugar del pulso de coseno alzado
tx_signal = conv(impulse_modulated, pt);

%%%%%%%%% <5. Graficar senales base> %%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
stem(amp_modulated(1:50),'LineWidth',1.2);
title('Simbolos PAM-4 (50 primeros)');
xlabel('Simbolo'); ylabel('Nivel PAM-4');
grid on;
subplot(3,1,2);
plot(impulse_modulated(1:200),'LineWidth',1.2);
title('Senal por Impulsos (primeros 200 muestras)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;
subplot(3,1,3);
plot(tx_signal(1:400),'LineWidth',1.2);
title('Senal Transmitida (sin Raised Cosine)');
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
title('Diagrama de Ojo PAM-4 (sin Raised Cosine)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;
hold off;

%%%%%%%%% <7. Sobreposicion de periodos de 2 simbolos> %%
figure(200);
hold on;
for k = 3:floor(Ns/2)-1
    tmp = tx_signal(((k-1)*2*L+1):(k*2*L));
    plot(0:(2*L-1), tmp);
    axis([0 2*L min(tx_signal) max(tx_signal)]);
    grid on;
    xlabel('Muestras');
    ylabel('Amplitud');
    title('Diagrama de Ojo PAM-4 (ventana = 2 simbolos, sin RC)');
    pause;
end
hold off;