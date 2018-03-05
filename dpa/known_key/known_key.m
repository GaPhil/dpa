%%%%%%%%%%%%%%%%%%%%
% Loading the data %
%%%%%%%%%%%%%%%%%%%%

% declaration of the SBOX (needed to calculate the power hypothesis)
SBOX =[099 124 119 123 242 107 111 197 048 001 103 043 254 215 171 118 ...
202 130 201 125 250 089 071 240 173 212 162 175 156 164 114 192 ...
183 253 147 038 054 063 247 204 052 165 229 241 113 216 049 021 ...
004 199 035 195 024 150 005 154 007 018 128 226 235 039 178 117 ...
009 131 044 026 027 110 090 160 082 059 214 179 041 227 047 132 ...
083 209 000 237 032 252 177 091 106 203 190 057 074 076 088 207 ...
208 239 170 251 067 077 051 133 069 249 002 127 080 060 159 168 ...
081 163 064 143 146 157 056 245 188 182 218 033 016 255 243 210 ...
205 012 019 236 095 151 068 023 196 167 126 061 100 093 025 115 ...
096 129 079 220 034 042 144 136 070 238 184 020 222 094 011 219 ...
224 050 058 010 073 006 036 092 194 211 172 098 145 149 228 121 ...
231 200 055 109 141 213 078 169 108 086 244 234 101 122 174 008 ...
186 120 037 046 028 166 180 198 232 221 116 031 075 189 139 138 ...
112 062 181 102 072 003 246 014 097 053 087 185 134 193 029 158 ...
225 248 152 017 105 217 142 148 155 030 135 233 206 085 040 223 ...
140 161 137 013 191 230 066 104 065 153 045 015 176 084 187 022];

numberOfTraces = 150;           % number of traces to be loaded - unknown_key
% numberOfTraces = 200;           % number of traces to be loaded
traceSize = 550000;             % number of samples in each trace - unknown_key
% traceSize = 370000;             % number of samples in each trace

offset = 0;                     % different beginning of the power trace - unknown_key
% offset = 40000;                 % different beginning of the power trace
segmentLength = 30000;          % different length of the power trace - unknown_key
% segmentLength = 50000;          % different length of the power trace

% columns and rows are used as inputs to
% the function loading the plaintext / ciphertext.
columns = 16;
rows = numberOfTraces;

% myload processes the binary file containing the measured traces and
% stores the data in the output matrix so that the traces can be used for
% for the key recovery proccess.
traces = myload('traces-unknown_key.bin', traceSize, offset, segmentLength, numberOfTraces);

% myin is used to load the plaintext and ciphertext to the corresponding
% matrices.
plaintext = myin('plaintext_unknown_key.txt', columns, rows);
ciphertext = myin('ciphertext_unknown_key.txt', columns, rows);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the power traces %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

firstround = 7000;

subplot(3, 1, 1), plot(mean(traces));                          % plot mean of all traces
subplot(3, 1, 2), plot(mean(traces( : , 1 : firstround)));     % first round
subplot(3, 1, 3), plot(mean(traces( : , 1 : firstround)'));    % first round transpose


%%%%%%%%%%%%%%%%
% Key recovery %
%%%%%%%%%%%%%%%%

% Create the power hypothesis for each byte of the key and then correlate
% the hypothesis with the power traces to extract the key.
% Task consists of the following parts :
% - create the power hypothesis
% - extract the key using the results of the mycorr function
% variables declaration
byteStart = 1;
byteEnd = 16;
keyCandidateStart = 0;
keyCandidateStop = 255;
result = zeros(1, 16);

% for every byte in the key do :
for BYTE = byteStart : byteEnd
% Create the power hypothesis matrix (dimensions: rows = numberOfTraces, columns = 256).
% The number 256 represents all possible bytes (e.g., 0x00..0xFF).
powerHypothesis = zeros(numberOfTraces, 256);
    for K = keyCandidateStart : keyCandidateStop
        for N = 1 : numberOfTraces
        % -- > create the power hypothesis here < --
            XOR = bitxor(plaintext(N, BYTE), K);
            sboxVal = SBOX(XOR + 1);
            Hw = byte_Hamming_weight(sboxVal + 1);
            powerHypothesis(N, K + 1) = Hw;
        end
    end
% function mycorr returns the correlation coefficients matrix calculated
% from the power consumption hypothesis matrix powerHypothesis and the
% measured power traces. The resulting correlation coeficients stored in
% the matrix CC are later used to extract the correct key.
    CC = mycorr(powerHypothesis, traces);
% -- > do some operations here to find the correct byte of the key < --

keyVal = 0;
segIndex = 0;
HighestCoef = 0;
    for K = keyCandidateStart : keyCandidateStop
        for seg = 1 : segmentLength
            if(CC(K + 1, seg) > HighestCoef)
                HighestCoef = CC(K + 1, seg);
                kIndex = K;
                segIndex = seg;
            end
        end
    end
    kIndex;
    result(1, BYTE) = kIndex;
end

for i = 1 : 16
    fprintf ( "Byte %d of the key is 0x%2.2X \n ", i , result(i) );
%     fprintf ( "%2.2X ", result(i) );
end