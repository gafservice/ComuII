%tx_sig_gen.m
clear all;
close all;

% Cargar el paquete de comunicaciones para acceder a rcosine
pkg load communications

rand(1,1264);  % Cambie los ultimos 3 digitos por los ultimos 3 numeros de su carne.
Ts = 1;
L  = 16;
t_step = Ts/L;

%%%%%%%%%<1. Generacion de onda del pulso > %%%%%%%%%%%%%%%%%%%%%%
ro = 0.25; % factor de Roll Off

% Implementacion del filtro de coseno alzado usando la formula base
t_span = -3:t_step:3;
pt = zeros(size(t_span));

for i = 1:length(t_span)
    t = t_span(i);
    if abs(t) < 1e-9 % Caso t=0
        pt(i) = 1;
    elseif abs(abs(t) - Ts/(2*ro)) < 1e-9 % Casos t = +/- Ts/(2*ro)
        pt(i) = (sin(pi*t/Ts)/(pi*t/Ts)) * (pi/4);
    else
        % Formula general
        pt(i) = (sin(pi*t/Ts)/(pi*t/Ts)) * (cos(pi*ro*t/Ts)/(1-(2*ro*t/Ts)^2));
    end
end

pt = pt/(max(abs(pt))); %rescaling to match rcosine

%%%%%%%%%<2. Generacion de 100 simbolos binarios >%%%%%%%%%%%%%%%%%%%%
Ns = 100; % son 100 simbolos binrios generados al azar
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

%%%%%%%%<6. Graficacion >%%%%%%%%%%
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
