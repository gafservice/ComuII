% tx_sig_gen_1264.m
% Generación de señal PAM-4 con Raised Cosine y diagrama de ojo
clear all; close all;
rng(1264);  % Semilla según carné

Ts = 1;     % Duración de un símbolo
L  = 16;    % Muestras por símbolo
t_step = Ts/L;

%%%%%%%%% <1. Pulso Raised Cosine> %%%%%%%%%%%%%%%%%%%%%%
a = 0.25;                              % Factor roll-off
span = 6;                              % Pulso abarca 6 símbolos
pt = rcosdesign(a, span, L, 'normal'); % Pulso Raised Cosine
pt = pt / max(abs(pt));                % Normalización

%%%%%%%%% <2. Generación de Ns símbolos PAM-4> %%%%%%%%%%
Ns = 1264;   % <<---- MODIFICADO (antes era 100, ahora 1XXX según carné)
amp_modulated = 2*ceil(rand(1, Ns)*4) - 5;  
% <<---- MODIFICADO (antes: 2*data_bit - 1, ahora genera {-3,-1,1,3})

%%%%%%%%% <3. Modulación de impulsos> %%%%%%%%%%%%%%%%%%%
impulse_modulated = [];
for n = 1:Ns
    delta_signal = [amp_modulated(n) zeros(1, L-1)];
    impulse_modulated = [impulse_modulated delta_signal];
end

%%%%%%%%% <4. Señal transmitida (filtrada con RC)> %%%%%%
tx_signal = conv(impulse_modulated, pt);

%%%%%%%%% <5. Graficar señales base> %%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
stem(amp_modulated(1:50),'LineWidth',1.2); 
% <<---- MODIFICADO (antes mostraba bits 0/1, ahora símbolos PAM-4)
title('Símbolos PAM-4 (50 primeros)');
xlabel('Símbolo'); ylabel('Nivel PAM-4');
grid on;

subplot(3,1,2);
plot(impulse_modulated(1:200),'LineWidth',1.2);
title('Señal por Impulsos (primeros 200 muestras)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

subplot(3,1,3);
plot(tx_signal(1:400),'LineWidth',1.2);
title('Señal Transmitida (primeros 400 muestras)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

%%%%%%%%% <6. Diagrama de Ojo (3 símbolos)> %%%%%%%%%%%%%
window_len = 3*L;                       
num_windows = floor(length(tx_signal)/window_len);

figure;
hold on;
for k = 1:num_windows-1
    tmp = tx_signal((k-1)*window_len+1 : k*window_len);
    plot(tmp,'b');
end
title('Diagrama de Ojo PAM-4 (ventana = 3 símbolos)'); 
% <<---- MODIFICADO (ahora es PAM-4, antes binario)
xlabel('Muestras'); ylabel('Amplitud');
grid on;

%%%%%%%%% <7. Sobreposición de periodos de 2 símbolos> %%
figure(200)
for k = 3:floor(Ns/2)-1   
    tmp = tx_signal(((k-1)*2*L+1):(k*2*L));
    plot(t_step*(0:(2*L-1)), tmp);
    axis([0 2 min(tx_signal) max(tx_signal)]);
    grid on; hold on;
    pause;  
end
hold off;
