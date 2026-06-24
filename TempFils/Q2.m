clc; 
clear; 
close all;

% ==================================================
% --------- Part a: Read raw video frames ---------
% ==================================================
% Open the first frame file in read mode
fid1 = fopen('frame0.raw', 'r');
% Read data into a 176x144 matrix and transpose it to correct orientation
frame1 = fread(fid1, [176 144])';
% Close the first file
fclose(fid1);

% Open the second frame file in read mode
fid2 = fopen('frame1.raw', 'r');
% Read and transpose the second frame
frame2 = fread(fid2, [176 144])';
% Close the second file
fclose(fid2);

% ==================================================
%  Part b: Macroblock division and Motion Estimation
% ==================================================

[rows, cols] = size(frame2);
blockSize = 16;

% Initialize matrices to store outputs
PredictedFrame = zeros(rows, cols);
MV_h = zeros(rows/blockSize, cols/blockSize); % Horizontal motion vectors
MV_v = zeros(rows/blockSize, cols/blockSize); % Vertical motion vectors

% Loop through frame2 in 16x16 macroblocks
for r = 1:blockSize:rows
    for c = 1:blockSize:cols
        % Extract current Macroblock (MB) from frame2
        MB = frame2(r:r+blockSize-1, c:c+blockSize-1);
        
        % Call MotionEstimation function (frame1 is the ReferenceFrame)
        [mvh, mvv, PMB] = MotionEstimation(r, c, MB, frame1);
        
        % Store the predicted macroblock to construct the full predicted frame
        PredictedFrame(r:r+blockSize-1, c:c+blockSize-1) = PMB;
        
        % Store motion vectors for each block
        mb_row = (r-1)/blockSize + 1;
        mb_col = (c-1)/blockSize + 1;
        MV_h(mb_row, mb_col) = mvh;
        MV_v(mb_row, mb_col) = mvv;
    end
end

% ==================================================
%  Part c: Reconstruct and Display the second frame
% ==================================================
% The PredictedFrame matrix already contains the reconstructed frame 
% from the macroblocks in Part b. We will just display it here.

figure('Name', 'Part C: Frame Reconstruction', 'NumberTitle', 'off');

% Show Original Frame 2
subplot(1, 2, 1);
% Note: Since fread reads data as double, we cast it to uint8 for correct
% display with imshow.
imshow(uint8(frame2));
title('Original Frame 2');

% Show Reconstructed (Predicted) Frame
subplot(1, 2, 2);
imshow(uint8(PredictedFrame));
title('Reconstructed Frame');

% ==================================================
% --- Part d: Calculate and Display Error Frame ---
% ==================================================
% Calculate the difference between Original Frame 2 and Predicted Frame
ErrorFrame = frame2 - PredictedFrame;

figure('Name', 'Part D: Error Frame', 'NumberTitle', 'off');
% Display the Error Frame with the specified range [-255 255]
imshow(ErrorFrame, [-255 255]);
title('Error Frame (Original 2 - Predicted)');
colorbar; % Adding a colorbar helps to see the distribution of errors


% ==================================================
% --- Part e: Display all three frames together ---
% ==================================================
figure('Name', 'Part E: All Frames Comparison', 'NumberTitle', 'off');

% 1. Original Frame 2
subplot(1, 3, 1);
imshow(uint8(frame2));
title('Original Frame 2');

% 2. Predicted Frame
subplot(1, 3, 2);
imshow(uint8(PredictedFrame));
title('Predicted Frame');

% 3. Error Frame
subplot(1, 3, 3);
imshow(ErrorFrame, [-255 255]);
title('Error Frame');



