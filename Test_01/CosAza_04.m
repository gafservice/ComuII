%% Comparación de ISI con Pulsos Coseno Alzado (Raised Cosine)
clc; clear; close all;

%% 1. Parámetros
Ts = 1;                     % Duración de un símbolo
L  = 16;                    % Muestras por símbolo
span = 4;                    % Pulso truncado en símbolos
roll_offs = [0 0.5 1];       % Factores de roll-off
colors = {'r','g','b'};      % Colores para cada curva
Nsym = 5;                    % Número de símbolos a transmitir

%% 2. Generar secuencia de símbolos BPSK (+1/-1)
data = randi([0 1], 1, Nsym)*2 - 1;

%% 3. Graficar secuencia transmitida (Dominio temporal)
figure('Renderer','painters');
subplot(2,1,1)
hold on; grid on
xlabel('Tiempo [símbolos]')
ylabel('Amplitud')
title('Secuencia de símbolos transmitidos con pulsos RC')
legend_entries = cell(1,length(roll_offs));

for k = 1:length(roll_offs)
    beta = roll_offs(k);
    
    % Pulso Raised Cosine truncado
    pulse = rcosdesign(beta, span, L, 'normal');
    
    % Convolución símbolo * pulso
    tx_signal = conv(data, pulse);
    
    % Vector de tiempo
    t = linspace(0, Nsym*Ts, length(tx_signal));
    
    % Graficar señal transmitida
    plot(t, tx_signal, 'Color', colors{k}, 'LineWidth', 1.5)
    legend_entries{k} = ['\beta = ' num2str(beta)];
end

% Marcar instantes de muestreo
for n = 0:Nsym-1
    plot([n*Ts n*Ts], ylim, 'k--')
end

legend(legend_entries, 'Location','Best')

%% 4. Graficar amplitud de símbolos en los instantes de muestreo
subplot(2,1,2)
hold on; grid on
xlabel('Símbolo n')
ylabel('Amplitud')
title('Amplitud de los símbolos en t = nTs')

for k = 1:length(roll_offs)
    beta = roll_offs(k);
    pulse = rcosdesign(beta, span, L, 'normal');
    tx_signal = conv(data, pulse);
    
    pulse_len = length(pulse);
    tx_len = length(tx_signal);
    
    % Primer índice de muestreo centrado en el primer símbolo
    first_idx = ceil(pulse_len/2);
    
    % Vector de índices seguro
    sample_idx = first_idx : L : first_idx + (Nsym-1)*L;
    sample_idx(sample_idx > tx_len) = [];  % evita exceder el tamaño
    
    % Extraer muestras
    samples = tx_signal(sample_idx);
    
    % Ajustar longitud de samples a Nsym
    if length(samples) > Nsym
        samples = samples(1:Nsym);
    elseif length(samples) < Nsym
        samples = [samples zeros(1, Nsym-length(samples))];
    end
    
    stem(0:Nsym-1, samples, 'Color', colors{k}, 'LineWidth', 1.2, 'MarkerFaceColor', colors{k})
end

legend(legend_entries, 'Location','Best')

%% 5. Espectro de las señales transmitidas
figure('Renderer','painters');
hold on; grid on
xlabel('Frecuencia Normalizada (ciclos/símbolo)')
ylabel('|P(f)|')
title('Espectro de los pulsos RC transmitidos')

for k = 1:length(roll_offs)
    beta = roll_offs(k);
    pulse = rcosdesign(beta, span, L, 'normal');
    tx_signal = conv(data, pulse);
    N = length(tx_signal);
    
    F = linspace(-0.5,0.5,N);                % Frecuencia normalizada
    Pt = abs(fftshift(fft(tx_signal)));       % Magnitud del espectro
    
    plot(F, Pt, 'Color', colors{k}, 'LineWidth', 1.5)
end

legend(legend_entries, 'Location','Best')
xlim([-0.5 0.5])
