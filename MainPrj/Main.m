%% Main Video Encoder Script
clear; clc;

% 1. Configuration
inputFile = 'foreman_qcif.yuv';  % Set your input file name here
outputFile = 'EncodedVideo.mpeg';
H = 144; W = 176;               % Standard QCIF dimensions (change if needed)
numFrames = 298;                % Number of frames to encode
Q_intra = 8;                    % Quantization for intra frames
Q_inter = 16;                   % Quantization for prediction error (as required by the assignment)

fid_in = fopen(inputFile, 'r');
fid_out = fopen(outputFile, 'wb');
fid_rec = fopen('reconstructed.yuv', 'wb');

% Frame Buffer for Reference
refFrame = zeros(H, W);

for f = 1:numFrames
    % Read Y component of current frame
    Y = fread(fid_in, [W, H], 'uint8')';
    % Skip U and V components (assuming 4:2:0 format)
    fread(fid_in, (W/2)*(H/2)*2, 'uint8');
    
    if isempty(Y), break; end
    
    if f == 1
        %% --- INTRA FRAME ENCODING ---
        % 1. DCT & Quantization
        [QuantizedCoeffs, ReconstructedFrame] = ProcessBlock(Y, Q_intra);
        
        % 2. Entropy Coding (Block by Block)
        for i = 1:8:H
            for j = 1:8:W
                block = QuantizedCoeffs(i:i+7, j:j+7);
                LRL = ZigzagScanAndLRL(block);
                bits = HuffCoding(LRL);
                fwrite(fid_out, bits, 'ubit1');
            end
        end
        
        % Update Reference Frame for next Inter frame
        refFrame = ReconstructedFrame;
        
    else
        %% --- INTER FRAME ENCODING ---
        % 1. Motion Estimation & Compensation
        [PredictedFrame, MVR, MVC] = MotionEstimationCompensation(Y, refFrame);
        
        % 2. Encode Motion Vectors (MV)
        % Note: HuffCodingMV usually expects matrices or vectors
        mv_bits = HuffCodingMV(MVR, MVC);
        fwrite(fid_out, mv_bits, 'ubit1');
        
        % 3. Calculate Prediction Error (Residual)
        Residual = Y - PredictedFrame;
        
        % 4. Process Error (DCT & Quantization with Q_inter)
        [QuantizedError, ReconstructedError] = ProcessBlock(Residual, Q_inter);
        
        % 5. Entropy Coding of Residual (Block by Block)
        for i = 1:8:H
            for j = 1:8:W
                block = QuantizedError(i:i+7, j:j+7);
                LRL = ZigzagScanAndLRL(block);
                bits = HuffCoding(LRL);
                fwrite(fid_out, bits, 'ubit1');
            end
        end
        
        % 6. Update Reference Frame (Reconstructed frame = Predicted + Reconstructed Error)
        % This ensures the encoder and decoder stay in sync
        refFrame = PredictedFrame + ReconstructedError;
    end
    
    % Optional: Write reconstructed frame to a YUV file to check quality
    WriteFrame(refFrame, fid_rec);
    
    fprintf('Frame %d encoded.\n', f);
end

fclose(fid_in);
fclose(fid_out);
fclose(fid_rec);

disp('Encoding Finished.');
