clear;
clc;
% Task 1: Find loud words from the audio file with start time and end time given

% Read the audio file
[audioSignal, fs] = audioread('./audios/9.mp3');

% Convert to mono if stereo
if size(audioSignal, 2) > 1
    audioSignal = mean(audioSignal, 2);  % Convert stereo to mono by averaging channels
end

% Read word timings from text file
fileID = fopen('./text/9.txt', 'r');
data = textscan(fileID, '%s %f %f %d', 'Delimiter', ' \t', 'MultipleDelimsAsOne', true);
fclose(fileID);

% Extract words, start times, and end times
words = data{1}; 
start_time = data{2}; 
end_time = data{3}; 

% Initialize arrays for loudness and RMS values
loudness = zeros(1, length(words));
rms = zeros(1, length(words));

% Set threshold for RMS energy to determine loud words
threshold = 0.1;

% Process each word segment
for i = 1:length(start_time)
    % Calculate start and end indices
    start_index = floor(start_time(i) * fs) + 1;
    end_index = floor(end_time(i) * fs);
    
    % Extract audio segment
    segment = audioSignal(start_index:end_index);
    
    % Calculate RMS energy
    rms_energy = sqrt(mean(segment.^2));
    rms(i) = rms_energy;
    
    % Determine if word is loud based on threshold
    if rms_energy > threshold
        loudness(i) = 1;
    else
        loudness(i) = 0;
    end
end

% Print results in a formatted table
fprintf("Word       | Energy (RMS)     | Loudness\n");
fprintf("--------------------------------------------\n");
for i = 1:length(words)
    fprintf("%-10s | %-16f | %d\n", words{i}, rms(i), loudness(i));
end
disp("--------------------------------------------")

% Plot bar graph of RMS values with words on x-axis
figure;
bar(rms);
hold on;
% Add a horizontal line for the threshold across the entire plot
yline(threshold, 'r--', 'LineWidth', 2, 'Label', 'Threshold');
title('Word RMS Energy');
xlabel('Words');
ylabel('RMS Energy');
xticks(1:length(words));
xticklabels(words);
xtickangle(45);
legend('RMS Energy', 'Location', 'best');
hold off;