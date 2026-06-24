clc; 
clear; 
close all;

% 1- Read the image and store it in variable I
I = imread('cameraman.tif');

% Get image dimensions (for loops and size calculations)
[h, w] = size(I);
total_pixels = h * w;

% 2- Calculate initial entropy & theoretical minimum size (in KB)
E = entropy(I);
size_KB = (E * total_pixels) / (8 * 1024);
disp(['Initial Entropy: ', num2str(E)]);

% Display the original image
A = figure('Name', 'Answer to questions', 'Position', [100, 100, 1000, 800]);
subplot(2, 2, 1);
imshow(uint8(I));
title('Original Image');
xlabel(['Entropy: ', num2str(E, '%.4f'), ' | Est. Size: ', num2str(size_KB, '%.1f'), ' KB']);

% Create an empty matrix to store the final image
IFinal = zeros(h, w);

% Base Quantization matrix Q (as given in the assignment)
Q_base = [16, 11, 10, 16, 24, 40, 51, 61;
          12, 12, 14, 19, 26, 58, 60, 55;
          14, 13, 16, 24, 40, 57, 69, 56;
          14, 17, 22, 29, 51, 87, 80, 62;
          18, 22, 37, 56, 68, 109, 103, 77;
          24, 35, 55, 64, 81, 104, 113, 92;
          49, 64, 78, 87, 103, 121, 120, 101;
          72, 92, 95, 98, 112, 100, 103, 99];

%% Base Q (No changes)
Q = Q_base;

% 3- Block-by-block processing (8x8 blocks)
for i = 1:8:h
    for j = 1:8:w
        
        % Extract an 8x8 block and convert to double
        block = double(I(i:i+7, j:j+7));
        
        % a) 2D DCT Transform
        B = dct2(block);
        
        % b) Quantization (element-wise division and rounding)
        Bq = round(B ./ Q);
        
        % c) De-quantization (element-wise multiplication)
        B_dequant = Bq .* Q;
        
        % d) Inverse DCT and place in the final image
        block_reconstructed = idct2(B_dequant);
        IFinal(i:i+7, j:j+7) = block_reconstructed;
        
    end
end

% 4- Calculate final entropy and theoretical size
EFinal = entropy(uint8(IFinal));
size_KB = (EFinal * total_pixels) / (8 * 1024);

% 5- Display the reconstructed image
subplot(2, 2, 2);
imshow(uint8(IFinal));
title('Compressed & Reconstructed Image');
xlabel(['Entropy: ', num2str(EFinal, '%.4f'), ' | Est. Size: ', num2str(size_KB, '%.1f'), ' KB']);
disp(['Final Entropy for Base Q (No changes): ', num2str(EFinal)]);


%% Q = 2 * Q_base
Q = 2 * Q_base;

for i = 1:8:h
    for j = 1:8:w
        block = double(I(i:i+7, j:j+7));
        B = dct2(block);
        Bq = round(B ./ Q);
        B_dequant = Bq .* Q;
        block_reconstructed = idct2(B_dequant);
        IFinal(i:i+7, j:j+7) = block_reconstructed;
    end
end

EFinal2 = entropy(uint8(IFinal));
size_KB2 = (EFinal2 * total_pixels) / (8 * 1024);

subplot(2, 2, 3);
imshow(uint8(IFinal));
title('Reconstructed Image (Q = Q * 2)');
xlabel(['Entropy: ', num2str(EFinal2, '%.4f'), ' | Est. Size: ', num2str(size_KB2, '%.1f'), ' KB']);
disp(['Final Entropy for Base Q * 2 : ', num2str(EFinal2)]);


%% Q = 4 * Q_base
Q = 4 * Q_base;

for i = 1:8:h
    for j = 1:8:w
        block = double(I(i:i+7, j:j+7));
        B = dct2(block);
        Bq = round(B ./ Q);
        B_dequant = Bq .* Q;
        block_reconstructed = idct2(B_dequant);
        IFinal(i:i+7, j:j+7) = block_reconstructed;
    end
end

EFinal4 = entropy(uint8(IFinal));
size_KB4 = (EFinal4 * total_pixels) / (8 * 1024);

subplot(2, 2, 4);
imshow(uint8(IFinal));
title('Reconstructed Image (Q = Q * 4)');
xlabel(['Entropy: ', num2str(EFinal4, '%.4f'), ' | Est. Size: ', num2str(size_KB4, '%.1f'), ' KB']);
disp(['Final Entropy for Base Q * 4 : ', num2str(EFinal4)]);
