[Home](https://bcunnane.github.io/)  
[View Code](https://github.com/bcunnane/CS_4D_flow)

## Processing DICOMs collected from Siemens CS 4D flow sequence

Most of my data is collected at UC San Diego's Radiology Imaging Laboratory on a 1.5T GE scanner. This allows for equipment and software developed in the past to be easily used A scanner is also available at SDSU

This script was developed to process velocity encoded phase contrast (VEPC) data collected from the Siemens CS 4D flow sequence. The processing steps are:

1. Import DICOM phase data as single matrix where each 'slice' of the volume is an image frame. Repeat for each velocity direction x,y, and z. Use the DICOM header info to assign velocity direction ('Through' = vz, 'ap' = vx, 'fh' = vy).
2. Import the combined magnitude DICOM data as magnitude, m.
3. Read the header info of each DICOM to get slice locations. Determine where the slice locations repeat, indicating a new frame.


## Testing


4. Select a magnitude "slice of interest" on which to draw the region of interest (ROI). Draw ROI on medial gastrocnemius (MG) muscle and transform into a mask.
5. Select all frames corresponding to the slice of interest in the velocity data. Use the mask to select data within the ROI for these slices. Calculate average velocity in the ROI for each frame, then plot the results.

160 x 80 x 1200
(there are 24 slices and 50 frames)
