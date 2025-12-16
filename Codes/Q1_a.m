clc; clear; close all;

N = 50;
n = (0:N-1)';
Ts = 1;
K = 4;
Delta = Ts / 10;

k_n = randi([-K, K], N, 1);

t_ideal = n * Ts;
t_jittered = t_ideal + (k_n * Delta);

epsilon = k_n * (Delta/Ts);
H = zeros(N, N);
for r = 1:N
    for c = 1:N
        val = (r-1) - (c-1) + epsilon(r);
        H(r, c) = sinc(val);
    end
end
H_inverse = inv(H);

t_fine = linspace(0, (N-1)*Ts, 500);

sig1_func = @(t) sin(2 * pi * 0.05 * t);
x1_true_fine = sig1_func(t_fine);
x1_jittered  = sig1_func(t_jittered);
x1_estimated = H_inverse * x1_jittered;

figure
darkBlue = [0, 0, 0.6];
subplot(3, 1, 1);
plot(t_fine, x1_true_fine, 'k-', 'LineWidth', 2);
title('Signal 1: Original Continuous Signal');
grid on;

subplot(3, 1, 2);
stem(t_jittered, x1_jittered, 'Color', darkBlue, 'MarkerFaceColor', darkBlue, 'MarkerSize', 5);
title('Signal 1: Jittered Samples');
grid on;

subplot(3, 1, 3);
plot(t_fine, x1_true_fine, 'k-', 'LineWidth', 0.5); hold on;
plot(t_ideal, x1_estimated, '.-', 'Color', darkBlue, 'LineWidth', 1.5, 'MarkerSize', 12);
title('Signal 1: Reconstructed Signal');
grid on;

mse1 = mean((sig1_func(t_ideal) - x1_estimated).^2);
fprintf('Signal 1 MSE: %.10f\n', mse1);

sig2_func = @(t) 0.5*sin(2*pi*0.03*t) + 0.3*cos(2*pi*0.08*t);
x2_true_fine = sig2_func(t_fine);
x2_jittered  = sig2_func(t_jittered);
x2_estimated = H_inverse * x2_jittered;

figure
subplot(3, 1, 1);
plot(t_fine, x2_true_fine, 'k-', 'LineWidth', 2);
title('Signal 2: Original Continuous Signal');
grid on;

subplot(3, 1, 2);
stem(t_jittered, x2_jittered, 'Color', darkBlue, 'MarkerFaceColor', darkBlue, 'MarkerSize', 5);
title('Signal 2: Jittered Samples');
grid on;

subplot(3, 1, 3);
plot(t_fine, x2_true_fine, 'k-', 'LineWidth', 0.5); hold on;
plot(t_ideal, x2_estimated, '.-', 'Color', darkBlue, 'LineWidth', 1.5, 'MarkerSize', 12);
title('Signal 2: Reconstructed Signal');
grid on;

mse2 = mean((sig2_func(t_ideal) - x2_estimated).^2);
fprintf('Signal 2 MSE: %.10f\n', mse2);

sig3_func = @(t) sinc(0.15 * (t - 25));
x3_true_fine = sig3_func(t_fine);
x3_jittered  = sig3_func(t_jittered);
x3_estimated = H_inverse * x3_jittered;

figure
subplot(3, 1, 1);
plot(t_fine, x3_true_fine, 'k-', 'LineWidth', 2);
title('Signal 3: Original Continuous Signal');
grid on;

subplot(3, 1, 2);
stem(t_jittered, x3_jittered, 'Color', darkBlue, 'MarkerFaceColor', darkBlue, 'MarkerSize', 5);
title('Signal 3: Jittered Samples');
grid on;

subplot(3, 1, 3);
plot(t_fine, x3_true_fine, 'k-', 'LineWidth', 0.5); hold on;
plot(t_ideal, x3_estimated, '.-', 'Color', darkBlue, 'LineWidth', 1.5, 'MarkerSize', 12);
title('Signal 3: Reconstructed Signal');
grid on;

mse3 = mean((sig3_func(t_ideal) - x3_estimated).^2);
fprintf('Signal 3 MSE: %.10f\n', mse3);

mse_all = [mse1 mse2 mse3];

figure
bar(mse_all);
title('Mean Squared Error for All Signals');
xlabel('Signal Number');
ylabel('MSE');
set(gca, 'XTickLabel', {'Signal 1', 'Signal 2', 'Signal 3'});
grid on;
