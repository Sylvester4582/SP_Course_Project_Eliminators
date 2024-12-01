% Directory paths
referenceDir = 'C:\IIIT-H\Study Material\Sem-3\Signal Processing\Course Project\Signals\Project_BirdRecognition\Reference';
taskDir = 'C:\IIIT-H\Study Material\Sem-3\Signal Processing\Course Project\Signals\Project_BirdRecognition\Task';

% Load and plot reference audio
referenceFiles = dir(fullfile(referenceDir, '*.wav'));
figure('Name', 'Reference Audio Waveforms');

for i = 1:length(referenceFiles)
    % Read audio file
    fileName = fullfile(referenceDir, referenceFiles(i).name);
    [audioData, sampleRate] = audioread(fileName);

    % Time vector
    time = (0:length(audioData) - 1) / sampleRate;

    % Plot waveform
    subplot(length(referenceFiles), 1, i);
    plot(time, audioData);
    title(['Waveform: ', referenceFiles(i).name]);
    xlabel('Time (s)');
    ylabel('Amplitude');
end
