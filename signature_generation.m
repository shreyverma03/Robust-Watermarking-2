%% Signature generation algorithm matrices U and V
function signature = signature_generation(U, V, key)

% Proposed algorithm
% 1. Sum the column of orthogonal matrices and create 1-D array
Usum = sum(U);
Vsum = sum(V);

% 2. Based on the threshold, map the array values into corresponding binary digits
Usum_threshold = median(Usum);  % threshold based on median value
Vsum_threshold = median(Vsum);

% transform Usum martix to binary using above threshold
Usum(find(Usum > Usum_threshold)) = 1;
Usum(find(Usum < Usum_threshold)) = 0;

% transform Vsum martix to binary using above threshold
Vsum(find(Vsum > Vsum_threshold)) = 1;
Vsum(find(Vsum < Vsum_threshold)) = 0;

clear('Usum_threshold', 'Vsum_threshold');

% XOR the 2 matrices to obtain 1-D array of dimension 1x512
R1 = double(bitxor(uint8(Usum), uint8(Vsum)));

rand('seed', key);
% produce binary sequence to perform XOR with R1
R2 = randi([0 1], 1, length(R1));

signature = double(bitxor(uint8(R1), uint8(R2)));

clear('Usum', 'Vsum', 'R1','R2','Result');
end