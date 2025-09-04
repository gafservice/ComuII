% tx_sig_gen_PAM4_PSD_marks.m
% Generacion de senal PAM-4 y PSD con marcas de 6 dB

clear all; close all;
rng(1264);
Ts = 1;
L = 16;

figure(300);
hold on;
grid on;
title('PSD de la Senal PAM-4 para Diferentes Factores de Roll-off con marcas de 6 dB');
xlabel('Frecuencia Normalizada (Fs)');
ylabel('PSD (dB/Hz)');
axis([0 1 -10 15]);

rolloff_factors = [0, 0.25, 0.5, 0.7, 1];
line_colors = {'b', 'g', 'r', 'c', 'm'};

for i = 1:length(rolloff_factors)
    a = rolloff_factors(i);
    span = 6;
    pt = rcosdesign(a, span, L, 'normal');
    pt = pt / max(abs(pt));
    Ns = 1264;
    amp_modulated = 2*ceil(rand(1, Ns)*4) - 5;
    impulse_modulated = [];
    for n = 1:Ns
        delta_signal = [amp_modulated(n) zeros(1, L-1)];
        impulse_modulated = [impulse_modulated delta_signal];
    end
    tx_signal = conv(impulse_modulated, pt);
    
    [Pxx, F] = pwelch(tx_signal, L*8, [], 2048, 16);
    PSD_dB = 10*log10(Pxx);
    plot(F, PSD_dB, line_colors{i}, 'LineWidth', 1.5);

    % Encuentra el valor maximo de PSD y el nivel de 6 dB por debajo
    [max_psd, ~] = max(PSD_dB);
    target_psd = max_psd - 6;

    % Encuentra el indice mas cercano a la frecuencia donde la PSD cae a target_psd
    [~, idx] = min(abs(PSD_dB - target_psd));
    
    % Agrega una linea horizontal para el nivel de 6 dB
    plot([0, F(idx)], [target_psd, target_psd], '--', 'Color', line_colors{i});
    
    % Agrega un punto en el ancho de banda de 6 dB
    plot(F(idx), target_psd, 'o', 'MarkerFaceColor', line_colors{i}, 'MarkerSize', 6);
end

legend('r = 0', 'r = 0.25', 'r = 0.5', 'r = 0.7', 'r = 1');
hold off;