function R = ZigZagScan(BQ_block)
    % This function takes an 8x8 block and returns a 1x64 zigzag vector
    
    % Zigzag index array for an 8x8 matrix (based on MATLAB's column-major order)
    zigzag_idx = [1, 9, 2, 3, 10, 17, 25, 18, 11, 4, 5, 12, 19, 26, 33, 41, ...
                  34, 27, 20, 13, 6, 7, 14, 21, 28, 35, 42, 49, 57, 50, 43, 36, ...
                  29, 22, 15, 8, 16, 23, 30, 37, 44, 51, 58, 59, 52, 45, 38, 31, ...
                  24, 32, 39, 46, 53, 60, 61, 54, 47, 40, 48, 55, 62, 63, 56, 64];
              
    % Convert the block to a zigzag vector using linear indexing
    R = BQ_block(zigzag_idx);
    
    % Ensure the output is strictly a row vector (1x64)
    R = reshape(R, 1, 64);
end
