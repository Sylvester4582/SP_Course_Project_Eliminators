clear;
clc;

% Task 1: Find loud words from the audio file without start time and end time given

% First we read the audio file
[audioSignal, fs] = audioread('./audios/6.wav'); 

% Then from the text file we get the words, start time and end time
fileID = fopen('./text/6.txt', 'r'); 
data = textscan(fileID, '%s %f %f %f', 'Delimiter', ' \t', 'MultipleDelimsAsOne', true);
fclose(fileID);

words = data{1};

%  We determine the no. of letters in each word and find total no. of letters
numLetters = cellfun(@length, words);
totalLetters = sum(numLetters); 

% Then we divide the audio signal according to no. of words in the audio and each segment length is set proportional to no. of letters in each word
segmentProportions = numLetters / totalLetters; % Proportion of audio for each word
segmentLengths = round(segmentProportions * (length(audioSignal)-0.44*fs)); 

threshold = 0.1; 

loudness = zeros(1, length(words));
rms = zeros(1, length(words));

% Here we set an initial start time (By hearing all the audios, the minimum start time was 0.44s)
start_index = floor(0.44*fs);
for i = 1:length(words)
    % End index is calculated according to segmentation length calculated above
    end_index = min(start_index + segmentLengths(i) - 1, length(audioSignal)); 
    
    % We calculate the rms of the segment of the segment
    segment = audioSignal(start_index:end_index);
    rms_energy = sqrt(mean(segment.^2));
    rms(i) = rms_energy;
    
    % Then we compare the rms energy with the threshold to determine loud word or not
    if rms_energy > threshold
        loudness(i) = 1;
    else
        loudness(i) = 0;
    end
    
    start_index = end_index + 1;
end

% Printing the final result
fprintf("Word       | Energy (RMS)     | Loudness\n");
fprintf("--------------------------------------------\n");

for i = 1:length(words)
    fprintf("%-10s | %-16f | %d\n", words{i}, rms(i), loudness(i));
end

t=0:1/fs:(length(audioSignal)-1)/fs;
figure;
subplot(2,1,1)
plot(t,audioSignal);
xlabel('t')
ylabel('Audio Signal')

subplot(2,1,2)
plot(rms)
ylabel('rms-energy')
xlabel('word-index');

