function [mvh, mvv, PMB] = MotionEstimation(r, c, MB, ReferenceFrame)
    % MotionEstimation finds the best matching block in the ReferenceFrame
    
    [rows, cols] = size(ReferenceFrame);
    blockSize = 16;
    searchRange = 15; % Standard search window [-15, 15]
    
    minSAD = inf;
    best_i = r;
    best_j = c;
    
    % Define search window boundaries (ensure we don't go out of frame bounds)
    r_start = max(1, r - searchRange);
    r_end = min(rows - blockSize + 1, r + searchRange);
    c_start = max(1, c - searchRange);
    c_end = min(cols - blockSize + 1, c + searchRange);
    
    % Full Search Block Matching
    for i = r_start:r_end
        for j = c_start:c_end
            % Extract candidate block from Reference Frame
            candidateBlock = ReferenceFrame(i:i+blockSize-1, j:j+blockSize-1);
            
            % Calculate Sum of Absolute Differences (SAD)
            SAD = sum(abs(MB(:) - candidateBlock(:)));
            
            % Update minimum SAD and best matching coordinates
            if SAD < minSAD
                minSAD = SAD;
                best_i = i;
                best_j = j;
            end
        end
    end
    
    % Calculate relative motion vectors (displacement)
    mvv = best_i - r; % Vertical motion vector
    mvh = best_j - c; % Horizontal motion vector
    
    % Output the best matching block (Predicted Macroblock)
    PMB = ReferenceFrame(best_i:best_i+blockSize-1, best_j:best_j+blockSize-1);
end
