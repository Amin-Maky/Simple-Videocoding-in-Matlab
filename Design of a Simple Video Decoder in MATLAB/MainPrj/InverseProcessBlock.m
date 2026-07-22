function ReconstructedBlock = InverseProcessBlock(LRL, Q)
    % InverseProcessBlock: Reconstructs an 8x8 spatial block from decoded LRL symbols.
    % Inputs:
    %   LRL - Nx3 matrix where each row is [LAST, RUN, LEVEL]
    %   Q   - Quantization matrix
    % Output:
    %   ReconstructedBlock - 8x8 double matrix (spatial domain / residual)

    %% 1. Inverse LRL (Run-Length Decoding)
    Z = zeros(1, 64);
    
    % The first element is always the DC coefficient.
    % Based on the encoder logic: if LRL(1,:) is [1, 0, DC], 
    % it implies no non-zero AC coefficients exist.
    Z(1) = LRL(1, 3);
    
    % If LAST is not 1 in the first row, additional AC coefficients exist
    if LRL(1, 1) == 0
        ptr = 2; % Pointer for AC coefficients (indices 2 to 64)
        for k = 2:size(LRL, 1)
            last  = LRL(k, 1);
            run   = LRL(k, 2);
            level = LRL(k, 3);
            
            % Skip consecutive zeros based on the RUN value
            ptr = ptr + run; 
            
            % Boundary check to prevent index out of bounds
            if ptr > 64 
                break;
            end
            
            % Place the coefficient (LEVEL)
            Z(ptr) = level;
            ptr = ptr + 1;
            
            % Terminate if the EOB (End Of Block) marker is reached
            if last == 1
                break;
            end
        end
    end

    %% 2. Inverse ZigZag Scan
    % Standard 8x8 zigzag scan order used in the encoder
    zigzag_idx = [ ...
         1,  9,  2,  3, 10, 17, 25, 18, 11,  4,  5, 12, 19, 26, 33, 41, ...
        34, 27, 20, 13,  6,  7, 14, 21, 28, 35, 42, 49, 57, 50, 43, 36, ...
        29, 22, 15,  8, 16, 23, 30, 37, 44, 51, 58, 59, 52, 45, 38, 31, ...
        24, 32, 39, 46, 53, 60, 61, 54, 47, 40, 48, 55, 62, 63, 56, 64];
        
    BQ_block = zeros(8, 8);
    % Map the linearized Z array back to the 8x8 matrix structure
    BQ_block(zigzag_idx) = Z;

    %% 3. Inverse Quantization
    % Dequantize the block (Element-wise multiplication with the Quantization matrix)
    B_deq = BQ_block .* Q;

    %% 4. Inverse 2D DCT
    % Transform back to the spatial domain
    ReconstructedBlock = idct2(B_deq);
end
