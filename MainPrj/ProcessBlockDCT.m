function IFinal = ProcessBlockDCT(I, Q)
    % This function takes an image and performs DCT, quantization,
    % dequantization, and inverse DCT on 8x8 blocks.

    % Convert image to double for more precise calculations
    I = double(I);
    
    % Get image dimensions
    [h, w] = size(I);
    
    % Create an empty matrix for the final image
    IFinal = zeros(h, w);

    % 3- Block-by-block processing (separate 8x8 blocks)
    for i = 1:8:h
        for j = 1:8:w
            
            % Extract the 8x8 block (block B)
            B = I(i:i+7, j:j+7);
            
            % a) 2D DCT transform
            B_dct = dct2(B);
            
            % b) Quantization using matrix Q
            Bq = round(B_dct ./ Q);
            
            % c) Dequantization of matrix Bq
            % B_dequant = Bq .* Q;
            
            % d) Inverse DCT transform and place into final image
            % block_reconstructed = idct2(B_dequant);
            % IFinal(i:i+7, j:j+7) = block_reconstructed;
            IFinal(i:i+7, j:j+7) = Bq;
            
        end
    end
end
