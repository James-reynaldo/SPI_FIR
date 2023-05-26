% Specify filter order and cutoff frequency
filterOrder = 12;
cutoffFrequency = 0.2;  % Normalized cutoff frequency (range: 0 to 1)

% Generate filter coefficients
coefficients = fir1(filterOrder, cutoffFrequency);

% Display the coefficients
disp(coefficients);