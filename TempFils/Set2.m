clc; 
clear; 
close all;

% --- Read Original Image ---
img = double(imread('cameraman.tif'));
[rows, cols] = size(img);

% Calculate Entropy and Size for Original Image
n_orig = hist(img(:), 0:255);
p_orig = n_orig(n_orig > 0) / numel(img);
entropy_orig = -sum(p_orig .* log2(p_orig));
size_orig_bytes = rows * cols; % 8 bits (1 byte) per pixel

% --- Standard quantization matrix (to generate BQ) ---
Q = [16 11 10 16 24 40 51 61;
     12 12 14 19 26 58 60 55;
     14 13 16 24 40 57 69 56;
     14 17 22 29 51 87 80 62;
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];

BQ = zeros(rows, cols);

% Compute DCT and quantization for the whole image
for r = 1:8:rows
    for c = 1:8:cols
        block = img(r:r+7, c:c+7);
        BQ(r:r+7, c:c+7) = round(dct2(block) ./ Q);
    end
end

% ==========================================
% --- Part 1: Calculate entropy using 'hist' command ---
% ==========================================

BQ_1D = BQ(:);
n = hist(BQ_1D, min(BQ_1D):max(BQ_1D));
n(n == 0) = [];
p = n / numel(BQ_1D);
entropy_BQ = -sum(p .* log2(p));

% Theoretical compressed size based on Shannon Entropy (in bytes)
size_comp_bytes = (rows * cols * entropy_BQ) / 8;

% ==========================================
% --- Image Reconstruction (IDCT) ---
% ==========================================
img_recon = zeros(rows, cols);

for r = 1:8:rows
    for c = 1:8:cols
        block_q = BQ(r:r+7, c:c+7);
        % Dequantization
        block_deq = block_q .* Q;
        % Inverse DCT
        img_recon(r:r+7, c:c+7) = idct2(block_deq);
    end
end
img_recon = uint8(img_recon); % Convert back for display
img_orig_display = uint8(img);

% ==========================================
% --- Part 2: ZigZag Scan ---
% ==========================================

zigzag_idx = [1, 9, 2, 3, 10, 17, 25, 18, 11, 4, 5, 12, 19, 26, 33, 41, ...
              34, 27, 20, 13, 6, 7, 14, 21, 28, 35, 42, 49, 57, 50, 43, 36, ...
              29, 22, 15, 8, 16, 23, 30, 37, 44, 51, 58, 59, 52, 45, 38, 31, ...
              24, 32, 39, 46, 53, 60, 61, 54, 47, 40, 48, 55, 62, 63, 56, 64];

num_blocks = (rows * cols) / 64;
zigzag_matrix = zeros(num_blocks, 64);
block_counter = 1;

for r = 1:8:rows
    for c = 1:8:cols
        current_block = BQ(r:r+7, c:c+7);
        zigzag_vector = current_block(zigzag_idx);
        zigzag_matrix(block_counter, :) = zigzag_vector;
        block_counter = block_counter + 1;
    end
end

% ==========================================
% --- Part 3: Run-Level Encoding ---
% ==========================================

run_level_encoded = cell(num_blocks, 1);

for i = 1:num_blocks
    vector = zigzag_matrix(i, :);
    last_non_zero = find(vector ~= 0, 1, 'last');
    
    if isempty(last_non_zero)
        run_level_encoded{i} = [0, 0];
        continue;
    end
    
    run_count = 0;
    block_rl = []; 
    
    for j = 1:last_non_zero
        if vector(j) == 0
            run_count = run_count + 1;
        else
            level = vector(j);
            block_rl = [block_rl; run_count, level];
            run_count = 0; 
        end
    end
    block_rl = [block_rl; 0, 0];
    run_level_encoded{i} = block_rl;
end

% ==========================================
% --- Visualization ---
% ==========================================

% Figure 1: Original vs Compressed Images
figure('Name', 'Image Compression Results', 'Position', [100, 100, 900, 450]);

% Original Image
subplot(2, 1, 1);
imshow(img_orig_display);
title(sprintf('Original Image\nSize: %d Bytes\nEntropy: %.4f bits/pixel', size_orig_bytes, entropy_orig));

% Reconstructed (Compressed) Image
subplot(2, 1, 2);
imshow(img_recon);
title(sprintf('Compressed (Reconstructed)\nTheoretical Size: %d Bytes\nEntropy (BQ): %.4f bits/pixel', round(size_comp_bytes), entropy_BQ));

% Figure 2: Visualizing ZigZag Matrix
figure('Name', 'ZigZag Matrix Visualization', 'Position', [150, 150, 800, 400]);
% Displaying only the first 100 blocks so the pixels are visible
imagesc(zigzag_matrix(1:100, :));
caxis([0, 10]);
colormap(jet); % Adds color to different coefficient values
colorbar;
title('ZigZag Matrix (First 100 Blocks)');
xlabel('ZigZag Sequence Index (1 to 64)');
ylabel('Block Number');

% Figure 3: Visualizing ZigZag Matrix (Binary / Zero vs Non-Zero)
figure('Name', 'ZigZag Matrix Visualization', 'Position', [150, 150, 800, 400]);

binary_matrix = (zigzag_matrix(1:100, :) ~= 0); 
imagesc(binary_matrix);

colormap(flipud(gray));
title('ZigZag Matrix - Non-Zero Coefficients (First 100 Blocks)');
xlabel('ZigZag Sequence Index (1 to 64)');
ylabel('Block Number');



