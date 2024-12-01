fs = 128;

% Load ECG signals
data1 = load('E1.mat');
data2 = load('E2.mat');
data3 = load('E3.mat');

E1 = data1.E1;
E2 = data2.E2;
E3 = data3.E3;

n1 = length(E1);
n2 = length(E2);
n3 = length(E3);

t1 = (0:n1-1)/fs;
t2 = (0:n2-1)/fs;
t3 = (0:n3-1)/fs;

figure;

% Plot E1 signal
subplot(3, 2, 1);
plot(t1, E1);
title('ECG Signal E1');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plot FFT of E1 signal
subplot(3, 2, 2);
fft_E1 = abs(fftshift(fft(E1)));
f1 = (-n1/2:n1/2-1) * (fs / n1);
plot(f1, fft_E1);
title('FFT of E1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-60 60]);
grid on;

% Plot E2 signal
subplot(3, 2, 3);
plot(t2, E2);
title('ECG Signal E2');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plot FFT of E2 signal
subplot(3, 2, 4);
fft_E2 = abs(fftshift(fft(E2)));
f2 = (-n2/2:n2/2-1) * (fs / n2);
plot(f2, fft_E2);
title('FFT of E2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-60 60]);
grid on;

% Plot E3 signal
subplot(3, 2, 5);
plot(t3, E3);
title('ECG Signal E3');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plot FFT of E3 signal
subplot(3, 2, 6);
fft_E3 = abs(fftshift(fft(E3)));
f3 = (-n3/2:n3/2-1) * (fs / n3);
plot(f3, fft_E3);
title('FFT of E3');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-60 60]);
grid on;