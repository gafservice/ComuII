%tx_sig_gen.m
clear all;
close all;
rand(1,1234);  % Cambie los ultimos 3 digitos por los ultimos 3 numeros de su carne.
Ts = 1;
L  = 16;
t_step = Ts/L;

%%%%%%%%%<1. Generacion de onda del pulso > %%%%%%%%%%%%%%%%%%%%%%
ro = 0.25; % factor de Roll Off
pt = rcosdesign(ro,6,L,'normal');
pt = pt/(max(abs(pt))); %rescaling to match rcosine

%%%%%%%%%<2. Generacion de 1000 simbolos binarios >%%%%%%%%%%%%%%%%%%%%
Ns = 1000; % Se usa un numero grande para un buen diagrama de ojo
data_bit = (rand(1,Ns)>0.5);

%%%%%%%%%<3. Unipolar a Bipolar (modulacion de amplitud)>%%%%%%%%%%%%%%
amp_modulated = 2*data_bit-1; % 0=> -1,  1=>1

%%%%%%%%%<4.  Modulacion de pulsos >%%%%%%%%%%%%%%%%%%%%%%%%%%%%
impulse_modulated = [];
for n=1:Ns
    delta_signal = [amp_modulated(n)  zeros(1, L-1)];
    impulse_modulated =[impulse_modulated  delta_signal];
end

%%%%%%%%<5.Formacion de pulsos (filtrado de transmision)>%%%%%%%%%%
tx_signal = conv(impulse_modulated, pt);

%%%%%%%%<6. Generacion del Diagrama de Ojo >%%%%%%%%%%%%%%%%%%%%
figure(200); % Crea la figura para el diagrama de ojo
plot_duration = 2 * L; % Duracion de 2 simbolos para cada segmento
for k = 1:floor(Ns/2)-1
    % Extrae un segmento de la senal que dura 2 Ts
    tmp = tx_signal(((k-1)*plot_duration+1) : (k*plot_duration));
    
    % Grafica el segmento en la misma figura
    plot(t_step * (0:(plot_duration-1)), tmp);
    
    axis([0 2 min(tx_signal) max(tx_signal)]);
    grid on;
    hold on;
end
hold off;
title('Diagrama de Ojo');
xlabel('Tiempo (segundos)');
ylabel('Amplitud');