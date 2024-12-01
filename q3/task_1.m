clear;
clc;

% Task 1: Find loud words from the audio file with start time and end time given

% First we read the audio file
[audioSignal, fs] = audioread('./audios/6.wav'); 

% Convert to mono if stereo
if size(audioSignal, 2) > 1
    audioSignal = mean(audioSignal, 2);  % Convert stereo to mono by averaging channels
end

% Then from the text file we get the words, start time and end time
fileID = fopen('./text/6.txt', 'r'); 
data = textscan(fileID, '%s %f %f %f', 'Delimiter', ' \t', 'MultipleDelimsAsOne', true);
fclose(fileID);

words = data{1};
start_time = data{2};
end_time = data{3};

loudness=zeros(1,length(words));
rms=zeros(1,length(words));

% We set a threshold for rms energy to determine the loud word
threshold = 0.112;

for i = 1:length(start_time)
    %  We set the start and end index using the start and end time
    start_index = floor(start_time(i) * fs) + 1;
    end_index = (floor(end_time(i) * fs));
    
    % We calculate the rms energy of the word
    segment = audioSignal(start_index:end_index);
    rms_energy = sqrt(mean(segment.^2));
    rms(i)=rms_energy;
    
    % Then we compare the rms energy with the threshold to determine loud word or not
    if rms_energy > threshold
        loudness(i)=1;
    else
        loudness(i)=0;
    end
end

% Printing the final result
fprintf("Word       | Energy (RMS)     | Loudness\n");
fprintf("--------------------------------------------\n");

for i = 1:length(words)
    fprintf("%-10s | %-16f | %d\n", words{i}, rms(i), loudness(i));
end

