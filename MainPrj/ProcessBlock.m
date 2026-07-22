function [QuantizedCoeffs, ReconstructedImage] = ProcessBlock(I, Q)
    % ProcessBlockDCT: Performs 2D DCT, Quantization, Dequantization, and
    % Inverse DCT.
    % Inputs:
    %   I - Input image/frame (Original Frame for Intra, or Error Frame
    %   for Inter)
    %   Q - 8x8 Quantization matrix or a scalar value (e.g., 16)
    %
    % Outputs:
    %   QuantizedCoeffs    - Matrix of quantized DCT coefficients 
    %   (goes to ZigZag Scan)
    %   ReconstructedImage - Decoded image/error 
    %   (goes to Reference Frame buffer)

    % Convert input to double precision for accurate calculations
    I = double(I);
    
    % Get dimensions of the image
    [h, w] = size(I);
    
    % Initialize output matrices to preallocate memory (speeds up the loop)
    QuantizedCoeffs = zeros(h, w);
    ReconstructedImage = zeros(h, w);

    % Process the image block-by-block (8x8 blocks)
    for i = 1:8:h
        for j = 1:8:w
            
            % 1. Extract the current 8x8 block
            B = I(i:i+7, j:j+7);
            
            % ----------------- ENCODER PATH -----------------
            % 2. Forward 2D DCT transform
            B_dct = dct2(B);
            
            % 3. Quantization using matrix/scalar Q
            Bq = round(B_dct ./ Q);
            
            % Save to output (this goes to the Entropy Coder)
            QuantizedCoeffs(i:i+7, j:j+7) = Bq;
            
            
            % ---------------- DECODER PATH ------------------
            % 4. Dequantization (Inverse Quantization)
            B_dequant = Bq .* Q;
            
            % 5. Inverse 2D DCT transform
            B_reconstructed = idct2(B_dequant);
            
            % Save to output (this goes to the Reference Frame Buffer)
            ReconstructedImage(i:i+7, j:j+7) = B_reconstructed;
            
        end
    end
end
