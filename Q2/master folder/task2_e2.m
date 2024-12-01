fs = 128;

data2 = load('E2.mat');
E2 = data2.E2;

n = length(E2);
t = (0:n-1)/fs;

cutoff_freq = 30;
E2_filtered = lowpass(E2, cutoff_freq, fs, 'ImpulseResponse', 'iir');

E2_first_derivative = diff(E2_filtered) * fs;
E2_second_derivative = diff(E2_filtered, 2) * fs^2;

t_first_derivative = t(1:end-1);
t_second_derivative = t(1:end-2);

figure;
subplot(2, 1, 1);
fft_pre_filtered = abs(fft(E2));
f = (0:length(fft_pre_filtered)-1) * (fs / length(fft_pre_filtered));
plot(f, fft_pre_filtered);
title('Pre-filtered FFT of E2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 60]);
grid on;

subplot(2, 1, 2);
fft_post_filtered = abs(fft(E2_filtered));
plot(f, fft_post_filtered);
title('Post-filtered FFT of E2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 60]);
grid on;

[~, locs_second_derivative] = findpeaks(E2_second_derivative, 'MinPeakHeight', 3000, 'MinPeakDistance', 0.4 * fs);

peak_locs_second_derivative = round(locs_second_derivative);
peak_locs_second_derivative = peak_locs_second_derivative(peak_locs_second_derivative > 0 & peak_locs_second_derivative <= length(E2_second_derivative));

RR_intervals_second_derivative = diff(peak_locs_second_derivative) / fs;

HR_second_derivative = 60 ./ RR_intervals_second_derivative;

HR_time_second_derivative = t(peak_locs_second_derivative(2:end));

figure;
subplot(4, 1, 1);
plot(t, E2_filtered);
title('Filtered ECG Signal E2');
xlabel('Time (s)');
xlim([0 10]);
ylabel('Amplitude');
legend('Filtered ECG Signal');
grid on;

subplot(4, 1, 2);
plot(t_first_derivative, E2_first_derivative);
title('First Derivative of the Filtered ECG Signal');
xlabel('Time (s)');
xlim([0 10]);
ylabel('Amplitude');
grid on;

subplot(4, 1, 3);
plot(t_second_derivative, E2_second_derivative);
hold on;
plot(t_second_derivative(peak_locs_second_derivative), E2_second_derivative(peak_locs_second_derivative), 'ro');
title('Second Derivative of the Filtered ECG Signal with R-peaks');
xlabel('Time (s)');
xlim([0 10]);
ylabel('Amplitude');
grid on;
hold off;

subplot(4, 1, 4);
stem(HR_time_second_derivative, HR_second_derivative, 'filled');
title('Heart Rate (HR) as a Function of Time (from Second Derivative)');
xlabel('Time (s)');
xlim([0 10]);
ylabel('Heart Rate (bpm)');
grid on;

num_minutes = floor(max(HR_time_second_derivative) / 60);
avg_HR_per_minute = zeros(1, num_minutes);
for i = 1:num_minutes
    start_time = (i-1) * 60;
    end_time = i * 60;
    avg_HR_per_minute(i) = mean(HR_second_derivative(HR_time_second_derivative >= start_time & HR_time_second_derivative < end_time));
end

avg_HR_time = (1:num_minutes) * 60;

figure;
stem(avg_HR_time / 60, avg_HR_per_minute, 'filled');
title('Average Heart Rate Per Minute');
xlabel('Time (minutes)');
xlim([0 max(avg_HR_time / 60)]);
ylabel('Average Heart Rate (bpm)');
grid on;