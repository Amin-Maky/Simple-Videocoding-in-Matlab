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
% --- Part 3: Run-Level-Last Encoding & f Mapping ---
% ==========================================

Level_Min = -4097;
all_f_values = []; % Array to store all f values from the entire image

run_level_last_encoded = cell(num_blocks, 1);

for i = 1:num_blocks
    vector = zigzag_matrix(i, :);
    last_non_zero = find(vector ~= 0, 1, 'last'); % Find the index of the last non-zero value
    
    if isempty(last_non_zero)
        % If the block is entirely zero, no symbol is generated
        run_level_last_encoded{i} = [];
        continue;
    end
    
    run_count = 0;
    block_rll = []; 
    
    for j = 1:last_non_zero
        if vector(j) == 0
            run_count = run_count + 1;
        else
            Level = vector(j);
            Run = run_count;
            
            % Determine the Last value
            if j == last_non_zero
                Last = 1;
            else
                Last = 0;
            end
            
            % Calculate variable f according to the formula
            f = Last + 2 * (Run + 64 * (Level - Level_Min));
            
            % Store the [Last, Run, Level, f] combination for observation
            block_rll = [block_rll; Last, Run, Level, f];
            
            % Add f to the overall list to calculate entropy
            all_f_values = [all_f_values; f];
            
            run_count = 0; % Reset the zero counter
        end
    end
    run_level_last_encoded{i} = block_rll;
end

% ==========================================
% --- Part 4: Calculate Entropy of f symbols ---
% ==========================================

if ~isempty(all_f_values) % Just to be sure
    % Calculate histogram of f values
    % Since f numbers can be very large with wide gaps between them, 
    % using 'unique' is a better approach than 'min:max' in 'hist'.
    [unique_f, ~, idx] = unique(all_f_values);
    n_f = accumarray(idx, 1);
    
    p_f = n_f / numel(all_f_values);
    entropy_f = -sum(p_f .* log2(p_f));
    
    fprintf('Entropy of original image: %.4f bits/pixel\n', entropy_orig);
    fprintf('Entropy of BQ (2D pixels): %.4f bits/pixel\n', entropy_BQ);
    fprintf('Entropy of mapped f symbols: %.4f bits/symbol\n', entropy_f);
else
    disp('No non-zero coefficients found to calculate entropy.');
end



% ==========================================
% --- Part 5: Scale Comparison (BQ vs f) ---
% ==========================================

if ~isempty(all_f_values) % Just to be sure
    total_pixels = rows * cols;
    total_f_symbols = numel(all_f_values);
    
    % 1. Total Volume in bits
    total_bits_BQ = total_pixels * entropy_BQ;
    total_bits_f = total_f_symbols * entropy_f;
    
    % 2. Equivalent Bits Per Pixel (bpp)
    bpp_BQ = entropy_BQ; % Already in bits/pixel
    bpp_f = total_bits_f / total_pixels; % Distributed over original pixels
    
    % Compression Ratios (compared to 8-bit original image)
    CR_BQ = 8 / bpp_BQ;
    CR_f = 8 / bpp_f;
    
    fprintf('\n--- Scale Comparison (BQ vs f) ---\n');
    fprintf('Total symbols to encode : BQ = %d | f = %d (%.2f%% reduction)\n', ...
            total_pixels, total_f_symbols, (1 - total_f_symbols/total_pixels)*100);
            
    fprintf('Total ideal size (bits) : BQ = %.0f bits | f = %.0f bits\n', ...
            total_bits_BQ, total_bits_f);
            
    fprintf('Equivalent bpp          : BQ = %.4f bpp  | f = %.4f bpp\n', ...
            bpp_BQ, bpp_f);
            
    fprintf('Compression Ratio       : BQ = %.2f:1    | f = %.2f:1\n', ...
            CR_BQ, CR_f);
end

