%%%%%%%%%%%%%%%%%%%%
% Loading the data %
%%%%%%%%%%%%%%%%%%%%

numberOfTraces = 200;           % number of traces to be loaded
traceSize = 370000;             % number of samples in each trace

offset = 40000;                 % different beginning of the power trace
segmentLength = 50000;          % different length of the power trace

% columns and rows are used as inputs to
% the function loading the plaintext / ciphertext.
columns = 16;
rows = numberOfTraces;

% myload processes the binary file containing the measured traces and
% stores the data in the output matrix so that the traces can be used for
% for the key recovery proccess. 
traces = myload('traces-00112233445566778899aabbccddeeff.bin', traceSize, offset, segmentLength, numberOfTraces);

% myin is used to load the plaintext and ciphertext to the corresponding
% matrices.
plaintext = myin('plaintext.txt', columns, rows);
ciphertext = myin('ciphertext.txt', columns, rows);
