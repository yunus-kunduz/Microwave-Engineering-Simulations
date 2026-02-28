% =========================================================================
% MICROVAWE ENGINEERING: TRANSMISSION LINE STANDING WAVE SIMULATION
% Author: Yunus Kunduz
% Description: Simulates forward and backward voltage waves on a lossless 
% transmission line, demonstrating the formation of standing waves and VSWR.
% =========================================================================

clc; clear; close all;

%% --- 1. PARAMETRE TANIMLAMALARI ---
V_inc = 10;           % Ileri giden dalga genligi (Incident Wave) [Volt]
V_ref = 10;           % Yansiyan dalga genligi (Reflected Wave) [Volt]
w = 1e9;              % Acisal frekans (Angular Frequency) [rad/s]
c = 3e8;              % Isik hizi (Speed of Light) [m/s]
v_p = 0.6 * c;        % Dielektrik ortamdaki yayilim hizi (Phase Velocity)

% Yayilim Sabiti (Propagation Constant) -> gamma = alpha + j*beta
% Kayipsiz hat (Lossless) oldugu icin alpha = 0.
gamma = 0 + 1i * (w / v_p); 

L = 2;                % Iletim hatti uzunlugu [Metre]
z = linspace(0, L, 1000); % Uzaysal eksen (Mekan)

%% --- 2. MUHENDISLIK HESAPLAMALARI ---
Gamma_L = V_ref / V_inc;                                % Yansima Katsayisi
VSWR = (1 + abs(Gamma_L)) / (1 - abs(Gamma_L));         % Duran Dalga Orani (Voltage Standing Wave Ratio)

%% --- 3. ANIMASYON VE GRAFIKLER ---
% Animasyon penceremizi profesyonel bir sekilde ayarlayalim
fig = figure('Name', 'Transmission Line Simulation', 'Color', 'w', 'Position', [100, 100, 800, 600]);

for t = 0:(1e-10):(15e-9) % Animasyon dongusu
    
    % Dalga Denklemleri (Zaman ve Mekana Bagli)
    V_forward  = V_inc * exp(-gamma * z) * exp(1i * w * t);
    V_backward = V_ref * exp(gamma * z) * exp(1i * w * t);
    V_total    = V_forward + V_backward; % Toplam gerilim (Standing Wave)
    
    clf; % Ekrani temizle
    
    % --- UST GRAFIK: Dinamik Dalga Yayilimi ---
    subplot(2,1,1);
    plot(z, real(V_total), 'k', 'LineWidth', 2); hold on;
    plot(z, real(V_forward), 'b--', 'LineWidth', 1.5);
    plot(z, real(V_backward), 'r--', 'LineWidth', 1.5);
    hold off;
    
    % Formatlama
    title(sprintf('Duran Dalga Olusumu (Zaman: %.2f ns)', t * 1e9), 'FontSize', 12);
    xlabel('Hattaki Konum - z (Metre)', 'FontWeight', 'bold');
    ylabel('Gerilim (Volt)', 'FontWeight', 'bold');
    axis([0 L -25 25]);
    grid on;
    legend('Toplam Dalga (Standing)', 'Ileri Giden (Incident)', 'Yansiyan (Reflected)', 'Location', 'northeast');
    
    % --- ALT GRAFIK: Gerilim Zarfi (Voltage Envelope) ---
    subplot(2,1,2);
    plot(z, abs(V_total), 'LineWidth', 2, 'Color', [0.2 0.6 0.2]); % Maksimum tepe noktalar
    hold on;
    plot(z, -abs(V_total), 'LineWidth', 2, 'Color', [0.2 0.6 0.2]); % Minimum dip noktalar
    hold off;
    
    % Formatlama
    title(sprintf('Gerilim Zarfi (Envelope) | VSWR: %.2f | Yansima Katsayisi (\\Gamma): %.2f', VSWR, Gamma_L), 'FontSize', 12);
    xlabel('Hattaki Konum - z (Metre)', 'FontWeight', 'bold');
    ylabel('Genlik |V|', 'FontWeight', 'bold');
    axis([0 L -25 25]);
    grid on;
    
    drawnow(); % Animasyonu kare kare ekrana bas
end
