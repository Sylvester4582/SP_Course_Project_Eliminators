[files, path] = uigetfile({'*.wav;*.mp3', 'Audio Files (*.wav, *.mp3)'}, ...
    'Select Audio Files', 'MultiSelect', 'on');

numFiles = length(files);
figure;

for i = 1:numFiles
    fullFileName = fullfile(path, files{i});

    [audioData, sampleRate] = audioread(fullFileName);

    % lpFilt = designfilt('lowpassfir', 'PassbandFrequency', 0.45, ...
    %     'StopbandFrequency', 0.55, 'PassbandRipple', 1, ...
    %     'StopbandAttenuation', 60, 'DesignMethod', 'kaiserwin');

    % filteredAudio = filter(lpFilt, audioData);

    % Y = fft(filteredAudio);
    % L = length(filteredAudio);
    % f = sampleRate * (0:(L - 1)) / L;

    Y = fft(audioData);
    L = length(audioData);
    f = sampleRate * (0:(L - 1)) / L;

    subplot(numFiles, 1, i);
    plot(f, abs(Y));
    grid on;
    [~, name, ext] = fileparts(files{i});
    title(['Magnitude of Fourier Transform - ', name, ext]);
    xlabel('Frequency (Hz)');
    ylabel('|Y(f)|');
end
