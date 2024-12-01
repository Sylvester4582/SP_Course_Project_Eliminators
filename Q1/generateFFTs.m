[referenceFiles, mainPath] = uigetfile({'*.wav;*.mp3', 'Audio Files (*.wav, *.mp3)'}, ...
    'Select the three Reference Files', 'MultiSelect', 'on');

references_FFTs = cell(1, 3);

for i = 1:3
    fullFileName = fullfile(mainPath, referenceFiles{i});

    [audioData, sampleRate] = audioread(fullFileName);

    Y = fft(audioData);
    L = length(audioData);
    f = sampleRate * (0:(L - 1)) / L;
    references_FFTs{i} = abs(Y);
end

save('references_FFTs.mat', 'references_FFTs');
