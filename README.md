[Home](https://bcunnane.github.io/)  
[View Code](https://github.com/bcunnane/CS_4D_flow)

## Processing DICOMs collected from Siemens CS 4D flow sequence

1. Import dicom phase data as 160 x 80 x 1200 matrix where each 'slice' of the volume is an image frame.
2. Repeat for each direction and the final combined magnitude. 'Through' = vz, 'ap' = vx, 'fh' = vy, 'mag' = m.
3. Read header to get slice locations. Determine where the slice locations repeat, indicating a new frame (there are 24 slices and 50 frames).
4. Select a magnitude "slice of interest" to draw ROI. Draw ROI on MG and transform into a mask.
5. Select all frames corresponding to the slice of interest in the velocity data. Use the mask to select data within the ROI for these slices. Calculate average velocity in the ROI for each frame, then plot the results.
