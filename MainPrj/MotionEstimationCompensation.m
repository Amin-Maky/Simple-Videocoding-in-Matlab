function [PredictedFrame, MVR, MVC] = MotionEstimationCompensation(CurrentFrame, ReferenceFrame)
    % MotionEstimationCompensation: Performs Full-Search block matching 
    % to find motion vectors (ME) and constructs the predicted frame (MC).
    %
    % Inputs:
    %   CurrentFrame   - The frame we want to encode
    %   ReferenceFrame - The previously reconstructed frame
    %
    % Outputs:
    %   PredictedFrame - The motion-compensated frame
    %   MVR            - Matrix of Row/Vertical motion vectors
    %   MVC            - Matrix of Column/Horizontal motion vectors

    % Convert to double for precise SAD calculation
    CurrentFrame = double(CurrentFrame);
    ReferenceFrame = double(ReferenceFrame);
    
    [h, w] = size(CurrentFrame);
    blockSize = 16;   % 16x16 macroblocks (As per Homework PDF)
    searchRange = 15; % Standard search window [-15, 15]
    
    % Initialize outputs
    PredictedFrame = zeros(h, w);
    
    % Number of macroblocks in row and column directions
    numRowsMB = floor(h / blockSize);
    numColsMB = floor(w / blockSize);
    
    % Matrices to store motion vectors for each macroblock
    MVR = zeros(numRowsMB, numColsMB);
    MVC = zeros(numRowsMB, numColsMB);
    
    % Loop over all 16x16 macroblocks in the frame
    for mb_r = 1:numRowsMB
        for mb_c = 1:numColsMB
            
            % Top-left pixel coordinates of the current macroblock
            r = (mb_r - 1) * blockSize + 1;
            c = (mb_c - 1) * blockSize + 1;
            
            % Extract Current Macroblock
            MB = CurrentFrame(r:r+blockSize-1, c:c+blockSize-1);
            
            minSAD = inf;
            best_i = r;
            best_j = c;
            
            % Define search window boundaries (prevent out-of-bound errors)
            r_start = max(1, r - searchRange);
            r_end = min(h - blockSize + 1, r + searchRange);
            c_start = max(1, c - searchRange);
            c_end = min(w - blockSize + 1, c + searchRange);
            
            % Full Search within the window
            for i = r_start:r_end
                for j = c_start:c_end
                    
                    % Extract Candidate Block from Reference Frame
                    candidateBlock = ReferenceFrame(i:i+blockSize-1, j:j+blockSize-1);
                    
                    % Calculate Sum of Absolute Differences (SAD)
                    SAD = sum(abs(MB(:) - candidateBlock(:)));
                    
                    % Update minimum SAD and best coordinates
                    if SAD < minSAD
                        minSAD = SAD;
                        best_i = i;
                        best_j = j;
                    end
                end
            end
            
            % 1. MOTION ESTIMATION: Save relative motion vectors
            % MVR: Row displacement, MVC: Col displacement
            MVR(mb_r, mb_c) = best_i - r;
            MVC(mb_r, mb_c) = best_j - c;
            
            % 2. MOTION COMPENSATION: Place best block into Predicted Frame
            PredictedFrame(r:r+blockSize-1, c:c+blockSize-1) = ReferenceFrame(best_i:best_i+blockSize-1, best_j:best_j+blockSize-1);
            
        end
    end
end
