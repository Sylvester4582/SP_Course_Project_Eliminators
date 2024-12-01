load('references_FFTs.mat', 'references_FFTs');

[files, path] = uigetfile({'*.wav;*.mp3', 'Audio Files (*.wav, *.mp3)'}, ...
    'Select Audio Files to be Tested', 'MultiSelect', 'on');

if ischar(files)
    files = {files};
end

numFiles = length(files);
frequencyRanges = [8300, 20000;
                   4800, 21000;
                   8000, 24000;
                   ];

for j = 1:numFiles
    fullFileName = fullfile(path, files{j});
    [audioData, sampleRate] = audioread(fullFileName);

    Y = fft(audioData);
    L = length(audioData);
    f = sampleRate * (0:(L - 1)) / L;
    Y_FFT = abs(Y);
    differences = zeros(1, 3);

    for i = 1:3
        range = find(f >= frequencyRanges(i, 1) & f <= frequencyRanges(i, 2));
        differences(i) = sum(abs(references_FFTs{i}(range) - Y_FFT(range)));
    end

    [~, minIndex] = min(differences);

    disp(['The given bird sound (', files{j}, ') is similar to that of bird-', num2str(minIndex)]);
    % disp(differences);
end
