function LRL = ZigzagScanAndLRL(BQ_block)
    % GenerateLRL_Block: Performs Zigzag scan on an 8x8 quantized block
    % and generates the Last-Run-Level (LRL) matrix.
    %
    % Input:
    %   BQ_block - 8x8 Quantized DCT coefficients block
    % Output:
    %   LRL      - N x 3 matrix where columns are [LAST, RUN, LEVEL]
    
    % 1. Zigzag Scanning Array
    zigzag_idx = [1, 9, 2, 3, 10, 17, 25, 18, 11, 4, 5, 12, 19, 26, 33, 41, ...
                  34, 27, 20, 13, 6, 7, 14, 21, 28, 35, 42, 49, 57, 50, 43, 36, ...
                  29, 22, 15, 8, 16, 23, 30, 37, 44, 51, 58, 59, 52, 45, 38, 31, ...
                  24, 32, 39, 46, 53, 60, 61, 54, 47, 40, 48, 55, 62, 63, 56, 64];
              
    % Apply zigzag scan to get a 1x64 vector
    Z = BQ_block(zigzag_idx); 
    
    % 2. Separate DC and AC coefficients
    DC = Z(1);
    AC = Z(2:end);
    
    % Find indices of non-zero AC coefficients
    non_zero_ac_idx = find(AC ~= 0);
    
    % 3. Generate LRL Matrix
    if isempty(non_zero_ac_idx)
        % Case A: All AC coefficients are zero
        if DC == 0
            LRL = [1, 0, 0]; % Entire block is zero
        else
            LRL = [1, 0, DC]; % Only DC is non-zero, and it's the LAST one
        end
    else
        % Case B: There are non-zero AC coefficients
        num_ac = length(non_zero_ac_idx);
        LRL = zeros(num_ac + 1, 3);
        
        % First row is always DC (LAST is 0 because ACs follow)
        LRL(1, :) = [0, 0, DC];
        
        % Process AC coefficients
        prev_idx = 0;
        for k = 1:num_ac
            curr_idx = non_zero_ac_idx(k);
            
            % Is this the last non-zero coefficient in the block?
            if k == num_ac
                last = 1;
            else
                last = 0;
            end
            
            % Calculate RUN (number of zeros before this coefficient)
            run = curr_idx - prev_idx - 1; 
            
            % LEVEL is the value of the non-zero coefficient
            level = AC(curr_idx);          
            
            % Add to LRL matrix
            LRL(k+1, :) = [last, run, level];
            
            % Update previous index
            prev_idx = curr_idx;
        end
    end
end
