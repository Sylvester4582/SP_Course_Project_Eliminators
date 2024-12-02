clear;
clc;
% Task 1: Find loud words from the audio file with start time and end time given

[audioSignal, fs] = audioread('./audios/.1.wav');

if size(audioSignal, 2) > 1
    audioSignal = mean(audioSignal, 2);  
end

fileID = fopen('./text/1.txt', 'r');
data = textscan(fileID, '%s %f %f %d', 'Delimiter', ' \t', 'MultipleDelimsAsOne', true);
fclose(fileID);

words = data{1}; 
start_time = data{2}; 
end_time = data{3}; 

loudness = zeros(1, length(words));
rms = zeros(1, length(words));

threshold = 0.1;

for i = 1:length(start_time)
    start_index = floor(start_time(i) * fs) + 1;
    end_index = floor(end_time(i) * fs);
    
    segment = audioSignal(start_index:end_index);
    
    rms_energy = sqrt(mean(segment.^2));
    rms(i) = rms_energy;
    
    if rms_energy > threshold
        loudness(i) = 1;
    else
        loudness(i) = 0;
    end
end

fprintf("Word       | Energy (RMS)     | Loudness\n");
fprintf("--------------------------------------------\n");
for i = 1:length(words)
    fprintf("%-10s | %-16f | %d\n", words{i}, rms(i), loudness(i));
end
disp("--------------------------------------------")

figure;
bar(rms);
hold on;
yline(threshold, 'r--', 'LineWidth', 2, 'Label', 'Threshold');
title('Word RMS Energy');
xlabel('Words');
ylabel('RMS Energy');
xticks(1:length(words));
xticklabels(words);
xtickangle(45);
legend('RMS Energy', 'Location', 'best');
hold off;