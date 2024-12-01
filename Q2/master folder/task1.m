fs = 128;

data1 = load('E1.mat');
ECG1 = data1.E1;

ECG1 = 2 * (ECG1 - min(ECG1)) / (max(ECG1) - min(ECG1)) - 1;

t1 = (0:length(ECG1) - 1) / fs;

[~, locs] = findpeaks(ECG1, 'MinPeakHeight', 0.4, 'MinPeakDistance', 0.3 * fs);

RR_intervals = diff(locs) / fs;

HR = 60 ./ RR_intervals;

HR_time = t1(locs(2:end));

figure;
subplot(3, 1, 1);
plot(t1, ECG1);
hold on;
plot(t1(locs), ECG1(locs), 'ro');
title('Normalized ECG Signal with R-peaks');
xlabel('Time (s)');
xlim([0 10]);
ylabel('Amplitude');
legend('Normalized ECG Signal', 'R-peaks');
grid on;
hold off;

subplot(3, 1, 2);
stem(HR_time, HR, 'filled');
title('Heart Rate (HR) as a Function of Time');
xlabel('Time (s)');
xlim([0 10]);
ylabel('Heart Rate (bpm)');
grid on;

num_minutes = floor(max(HR_time) / 60);
avg_HR_per_minute = zeros(1, num_minutes);
for i = 1:num_minutes
    start_time = (i-1) * 60;
    end_time = i * 60;
    avg_HR_per_minute(i) = mean(HR(HR_time >= start_time & HR_time < end_time));
end

avg_HR_time = (1:num_minutes) * 60;

subplot(3, 1, 3);
stem(avg_HR_time / 60, avg_HR_per_minute, 'filled');
title('Average Heart Rate Per Minute');
xlabel('Time (minutes)');
xlim([0 max(avg_HR_time / 60)]);
ylabel('Average Heart Rate (bpm)');
grid on;
