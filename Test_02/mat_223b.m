%tx_sig_gen.m
clear all;
close all;
rand(1,1264);  % Cambie los ultimos 3 digitos por los ultimos 3 numeros de su carne.
Ts = 1;
L  = 16;
t_step = Ts/L;
%%%%%%%%%<1. Generacion de onda del pulso > %%%%%%%%%%%%%%%%%%%%%%
ro = 0.25 % factor de Roll Off
pt = rcosdesign(ro,6,L,'normal');% funcion para generar un filtro
%denominado de conseno alzado, el cual ayuda a disminuir el Interferencia 
%enre los sibolos, 
% "ro" guarda los valores de roll-off, este valor
%determina el ancho de banda del filtro, los valores que puede tomar
%se encutran entre 0 y 1
% el valor de 6 determina cuanto dura un el filtro,  se usa como base
% la duracion del simbolo
% L tiene un valor de 16, correspondiente al valor del submuestreo es decir
%cuantas muestras se toman del simbolo  para se transmitido, en este caso
%16
%la funcion corre de forma 'normal'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% 
pt = pt/(max(abs(pt))); %rescaling to match rcosine
%%%%% esta linea se usa para normalizar la funcion 

%%%%%%%%%<2. Generacion de 100 simbolos binarios >%%%%%%%%%%%%%%%%%%%%
Ns = 100 % son 100 simbolos binrios generados al azar
data_bit = (rand(1,Ns)>0.5);
% estos datos son aleatorios 

%%%%%%%%%<3. Unipolar a Bipolar (modulacion de amplitud)>%%%%%%%%%%%%%%
% es decir que pasa de valore entre 0 y 1 a valores entre -1 a 1
amp_modulated = 2*data_bit-1; % 0=> -1,  1=>1

%%%%%%%%%<4.  Modulacion de pulsos >%%%%%%%%%%%%%%%%%%%%%%%%%%%%
impulse_modulated = [];
for n=1:Ns
    delta_signal = [amp_modulated(n)  zeros(1, L-1)];
    impulse_modulated =[impulse_modulated  delta_signal];
end

%%%%%%%%<5.Formacion de pulsos (filtrado de transmision)>%%%%%%%%%%
tx_signal = conv(impulse_modulated, pt);
figure(100)
subplot(2,1,1)
stem(t_step:t_step:(Ns*Ts), impulse_modulated, '.');
axis([0 Ns*Ts -2*max(abs(impulse_modulated)) 2*max(abs(impulse_modulated))]);
grid on
title('impulse modulated');

subplot(2,1,2)
plot(t_step:t_step:(t_step*length(tx_signal)), tx_signal);
axis([0 Ns*Ts -2*max(abs(tx_signal)) 2*max(abs(tx_signal))]);
grid on
title('pulse shaped');

%%%%%%%%% <7. Diagrama de Ojo> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ventana de 3 símbolos
window_len = 3*L;

% Número de ventanas posibles (hasta cubrir tx_signal)
num_windows = floor(length(tx_signal)/window_len);

figure;
hold on;
for k = 1:num_windows-1
    tmp = tx_signal((k-1)*window_len+1 : k*window_len);
    plot(tmp, 'b');
end
title('Diagrama de Ojo (ventana = 3 bits)');
xlabel('Muestras'); ylabel('Amplitud');
grid on;


figure(200)
for k = 3:floor(Ns/2)-1   % k representa la k-ésima muestra
    tmp = tx_signal(((k-1)*2*L+1):(k*2*L));   % Extrae 2 símbolos muestreados
    plot(t_step*(0:(2*L-1)), tmp);
    axis([0 2 min(tx_signal) max(tx_signal)]);
    grid on; hold on;
    pause;   % Espera a que el usuario presione una tecla
end
hold off;
