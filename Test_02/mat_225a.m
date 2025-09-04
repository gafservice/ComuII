%tx_sig_gen.m
clear all;
close all;
rand(1,1234);  % Use su numero de carnet
Ts = 1;
L  = 16;
t_step = Ts/L;

%%%%%%%%%<1. Generacion de onda del pulso > %%%%%%%%%%%%%%%%%%%%%%
ro = 1.00; % CAMBIE ESTE VALOR: 0, 0.5, 0.75, 1
pt = rcosdesign(ro,6,L,'normal');
pt = pt/(max(abs(pt))); % normalizacion del pulso

%%%%%%%%%<2. Generacion de simbolos binarios >%%%%%%%%%%%%%%%%%%%%
Ns = 1000;
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
figure(200);
for k = 3:floor(Ns/2)-1
    tmp = tx_signal(((k-1)*2*L+1) : (k*2*L));
    plot(t_step * (0:(2*L-1)), tmp);
    axis([0 2 min(tx_signal) max(tx_signal)]);
    grid on;
    hold on;
end
hold off;
title(['Diagrama de Ojo con ro = ', num2str(ro)]);
xlabel('Tiempo (segundos)');
ylabel('Amplitud');