clear;
clc;

% Task-2 Audio Segmentation and Loud Word Detection without Timestamps

[audioSignal, fs] = audioread('./audios/1.wav');

if size(audioSignal, 2) > 1
    audioSignal = mean(audioSignal, 2);  
end

fileID = fopen('./text/1.txt', 'r');
data = textscan(fileID, '%s %f %f %d', 'Delimiter', ' \t', 'MultipleDelimsAsOne', true);
fclose(fileID);

words = data{1}; 

window_duration = 0.025; 
window_samples = round(window_duration * fs);
hop_length = round(window_samples / 2);  

energy = zeros(1, ceil(length(audioSignal) / hop_length));
for i = 1:length(energy)
    start_idx = 1 + (i-1) * hop_length;
    end_idx = min(start_idx + window_samples - 1, length(audioSignal));
    
    window = audioSignal(start_idx:end_idx);
    energy(i) = sum(window.^2);
end

energy = energy / max(energy);
% energy = movmean(energy,1);

energy_threshold = 0.01;  
speech_regions = energy > energy_threshold;

speech_segments = find(diff([0, speech_regions, 0]) ~= 0);
speech_segments = reshape(speech_segments, 2, [])';
speech_segments = speech_segments * hop_length;

rms = zeros(1, size(speech_segments, 1));
loudness = zeros(1, size(speech_segments, 1));

if size(speech_segments, 1) > length(words)
    speech_segments = speech_segments(1:length(words), :);
elseif size(speech_segments, 1) < length(words)
    speech_segments = [speech_segments; zeros(length(words) - size(speech_segments, 1), 2)];
end

rms_threshold = 0.12;  

for i = 1:size(speech_segments, 1)
    if speech_segments(i,1) > 0 && speech_segments(i,2) <= length(audioSignal)
        segment = audioSignal(speech_segments(i,1):speech_segments(i,2));
        
        rms_energy = sqrt(mean(segment.^2));
        rms(i) = rms_energy;
        
        if rms_energy > rms_threshold
            loudness(i) = 1;
        else
            loudness(i) = 0;
        end
    end
end

fprintf("Word       | Energy (RMS)     | Loudness\n");
fprintf("--------------------------------------------\n");
for i = 1:min(length(words), length(rms))
    fprintf("%-10s | %-16f | %d\n", words{i}, rms(i), loudness(i));
end
disp("--------------------------------------------")

bar(rms);
hold on;
yline(rms_threshold, 'r--', 'LineWidth', 2, 'Label', 'Threshold');
title('RMS Energy per Speech Segment');
xlabel('Speech Segments');
ylabel('RMS Energy');
if length(words) <= 20
    xticks(1:length(words));
    xticklabels(words);
    xtickangle(45);
end
hold off;

figure;
plot(energy);
hold on;
yline(energy_threshold, 'r--', 'LineWidth', 2, 'Label', 'Energy Threshold');
title('Energy Envelope');
xlabel('Time Windows');
ylabel('Normalized Energy');
hold off;