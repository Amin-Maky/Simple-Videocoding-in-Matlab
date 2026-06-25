# Simple Video Encoding in Matlab

This project implements a simplified, custom video encoder in MATLAB. It processes raw YUV video files (specifically the Luminance/Y component) and demonstrates fundamental video compression techniques including Intra-frame and Inter-frame encoding, Motion Estimation, DCT, Quantization, and Entropy Coding.

## Overview

The encoder is designed to process the `foreman_qcif.yuv` video sequence (Resolution: $176 \times 144$). It generates a custom encoded bitstream (`EncodedVideo.mpeg`) and a reconstructed video file (`reconstructed.yuv`) to verify the encoding/decoding loop's integrity.

**Note:** The output `.mpeg` file is a custom raw bitstream containing Huffman codes and is not a standard playable video file.

## Features & Encoding Pipeline

*   **Luminance Processing:** Only the Y (luminance) component of the video is processed to simplify the pipeline.
*   **Intra-frame Encoding (First Frame):** 
    *   Divides the frame into $8 \times 8$ blocks.
    *   Applies Discrete Cosine Transform (DCT).
    *   Quantizes the coefficients (using $Q_{intra}$).
    *   Performs Zigzag scanning and Level-Run-Length (LRL) encoding.
    *   Applies Huffman coding to generate the bitstream.
*   **Inter-frame Encoding (Subsequent Frames):**
    *   Performs Full-Search Motion Estimation on $16 \times 16$ Macroblocks to find Motion Vectors (MVs).
    *   Generates a Predicted Frame via Motion Compensation.
    *   Calculates the Residual (Error) between the current frame and predicted frame.
    *   Encodes the Residual using the same $8 \times 8$ DCT, Quantization ($Q_{inter}$), Zigzag, and Huffman pipeline.
    *   Encodes the Motion Vectors using a dedicated Huffman table.

## Prerequisites

*   **MATLAB** (Base installation is sufficient, no specific toolboxes are strictly required for the core custom functions).
*   Input video file: `foreman_qcif.yuv` (QCIF format, $176 \times 144$) placed in the root directory.

## How to Run

1. Ensure all `.m` files and `foreman_qcif.yuv` are in the same directory.
2. Open MATLAB and navigate to the project directory.
3. Run the main script:
```matlab
   Main
```
4. The script will process the frames and output progress in the console. 
5. Upon completion, two new files will be generated:
   *   `EncodedVideo.mpeg`: The custom compressed bitstream.
   *   `reconstructed.yuv`: The reconstructed Y-component video (can be viewed using a raw YUV player like YUV Player, set to Y-only or grayscale, $176 \times 144$).

## Project Structure

*   `Main.m`: The main orchestrator script that runs the frame loop, handles file I/O, and manages the reference frames.
*   `ProcessBlock.m`: Handles $8 \times 8$ block DCT, Quantization, Dequantization, and Inverse DCT. Returns both quantized coefficients and the reconstructed image block.
*   `MotionEstimationCompensation.m`: Performs block-matching motion estimation ($16 \times 16$ blocks) and generates the motion-compensated predicted frame.
*   `ZigzagScanAndLRL.m`: Converts 2D quantized DCT blocks into a 1D zigzag array and computes the Level-Run-Length sequence.
*   `HuffCoding.m` & `HuffCodingMV.m`: Applies Huffman entropy coding to the LRL sequences and Motion Vectors, respectively.
*   `WriteFrame.m`: Handles writing the reconstructed matrices to the `reconstructed.yuv` file in the correct row-major format.
