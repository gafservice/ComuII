% tx_rx_sqrt_PAM4.m
% Simulacion de doble implementacion de filtro de coseno alzado de raiz cuadrada

clear all; close all;
rng(1264);  % Semilla segun carne
Ts = 1;     % Duracion de un simbolo
L  = 16;    % Muestras por simbolo
t_step = Ts/L;

%%%%%%%%% <1. Pulso Raised Cosine de Raiz Cuadrada> %%%%%%%%%%
a = 0.0;                              % Factor roll-off
span = 6;                              % Pulso abarca 6 simbolos
pt_sqrt = rcosdesign(a, span, L, 'sqrt'); % Filtro de raiz cuadrada
pt_sqrt = pt_sqrt / max(abs(pt_sqrt));  % Normalizacion

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

%%%%%%%%% <4. Senal Transmitida (filtrada con SRRC)> %%%%%%
% Se aplica el filtro SRRC en el transmisor
tx_signal = conv(impulse_modulated, pt_sqrt);

%%%%%%%%% <5. Recepcion (Aplicacion del segundo filtro SRRC)> %%%%%%
% Se simula la recepcion al aplicar el mismo filtro en la señal recibida
rx_signal = conv(tx_signal, pt_sqrt);
% NOTA: En un sistema real, se decima la señal despues de la convolucion
% para obtener los simbolos originales.

%%%%%%%%% <6. Graficar senales base y final> %%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
stem(amp_modulated(1:50),'LineWidth',1.2);
title('Simbolos PAM-4 (50 primeros)');
xlabel('Simbolo'); ylabel('Nivel PAM-4');
grid on;

subplot(3,1,2);
plot(tx_signal(1:400),'LineWidth',1.2);
title('Senal Transmitida (con filtro SRRC)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

subplot(3,1,3);
plot(rx_signal(1:400),'LineWidth',1.2);
title('Senal Recibida (con doble filtro SRRC)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;

%%%%%%%%% <7. Diagrama de Ojo de la Senal Recibida> %%%%%%%%%%%%%
% Se genera el diagrama de ojo de la señal que ha pasado por ambos filtros
window_len = 3*L;
num_windows = floor(length(rx_signal)/window_len);
figure;
hold on;
for k = 1:num_windows-1
    tmp = rx_signal((k-1)*window_len+1 : k*window_len);
    plot(tmp,'b');
end
title('Diagrama de Ojo PAM-4 (con doble filtro SRRC)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;
hold off;

%%%%%%%%% <8. Sobreposicion de periodos de 2 simbolos (rx_signal)> %%%%%%
figure(200);
hold on;
for k = 3:floor(Ns/2)-1
    tmp = rx_signal(((k-1)*2*L+1):(k*2*L));
    plot(t_step*(0:(2*L-1)), tmp);
    axis([0 2 min(rx_signal) max(rx_signal)]);
    grid on;
    xlabel('Tiempo');
    ylabel('Amplitud');
    title('Diagrama de Ojo PAM-4 (ventana = 2 simbolos)');
    pause;
end
hold off;