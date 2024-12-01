[files, path] = uigetfile({'*.wav;*.mp3', 'Audio Files (*.wav, *.mp3)'}, ...
    'Select Audio Files', 'MultiSelect', 'on');

if ischar(files)
    files = {files};
end

numFiles = length(files);
figure;

for i = 1:numFiles
    fullFileName = fullfile(path, files{i});
    [audioData, sampleRate] = audioread(fullFileName);

    t = (0:length(audioData) - 1) / sampleRate;

    subplot(numFiles, 1, i);
    plot(t, audioData);
    grid on;
    title(['Audio Signal: ', files{i}]);
    xlabel('Time (s)');
    ylabel('Amplitude');
end
