% MainDecoder.m
% Complete decoder implementation, synchronized with Main.m encoder logic.

clear; clc; 

% 1. Read the entire bitstream into memory
fid_in = fopen('EncodedVideo.mpeg', 'r');
if fid_in == -1, error('Error: Could not open the file.'); end
bitStream = fread(fid_in, inf, 'ubit1');
bitStream = bitStream(:)'; % Ensure row vector format
fclose(fid_in);

p = 1; % Pointer for traversing the bitstream array
total_bits = length(bitStream);

outfile = fopen('Decoded.yuv', 'w');
if outfile == -1, error('Error: Could not create output file.'); end

% 2. Initialization 
H = 144;         % Frame height
W = 176;         % Frame width
numFrames = 298; % Total number of frames based on encoder configuration
Q_intra = 8;
Q_inter = 16;
ReferenceFrame = zeros(H, W);

%% 3. Main Decoding Loop
for frame_idx = 1:numFrames
    
    % Terminate if the bitstream is exhausted
    if p > total_bits
        disp('End of bitstream reached.');
        break;
    end
    
    CurrentFrame = zeros(H, W);
    disp(['Decoding Frame: ', num2str(frame_idx)]);
    
    if frame_idx == 1
        % ==========================================
        % I-Frame Decoding
        % ==========================================
        for i = 1:8:H
            for j = 1:8:W
                % Requirement #2: Extract 1500-bit segments for optimized decoding
                end_idx = min(p + 1500, total_bits);
                [LRL, len] = HuffDecoding(bitStream(p:end_idx));
                p = p + len;
                
                ResidualBlock = InverseProcessBlock(LRL, Q_intra);
                CurrentFrame(i:i+7, j:j+7) = ResidualBlock;
            end
        end
        
    else
        % ==========================================
        % P-Frame Decoding
        % ==========================================
        PredictedFrame = zeros(H, W);
        
        % a) Read Motion Vectors (MVs)
        for i = 1:16:H
            for j = 1:16:W
                % Requirement #3: Extract 30-bit segments for MV decoding
                end_idx = min(p + 30, total_bits);
                [mvr, mvc, len] = HuffDecodingMV(bitStream(p:end_idx));
                p = p + len;
                
                % Apply boundary constraints to prevent out-of-bounds access
                ref_i = max(1, min(H - 15, i + mvr));
                ref_j = max(1, min(W - 15, j + mvc));
                PredictedFrame(i:i+15, j:j+15) = ReferenceFrame(ref_i:ref_i+15, ref_j:ref_j+15);
            end
        end
        
        % b) Read prediction error blocks
        ReconstructedError = zeros(H, W);
        for i = 1:8:H
            for j = 1:8:W
                end_idx = min(p + 1500, total_bits);
                [LRL, len] = HuffDecoding(bitStream(p:end_idx));
                p = p + len;
                
                ResidualBlock = InverseProcessBlock(LRL, Q_inter);
                ReconstructedError(i:i+7, j:j+7) = ResidualBlock;
            end
        end
        
        % c) Reconstruction: Sum of motion prediction and residual error
        CurrentFrame = PredictedFrame + ReconstructedError;
    end
    
    % ========================================================
    % Write decoded frame to output file using WriteFrame utility
    % ========================================================
    WriteFrame(CurrentFrame, outfile);
    
    % Update ReferenceFrame for the next inter-frame prediction
    ReferenceFrame = CurrentFrame;
end

% Close output file and clean up
fclose(outfile);
disp('Decoding finished and Decoded.yuv is created successfully.');
