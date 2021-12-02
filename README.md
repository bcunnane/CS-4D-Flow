[Home](https://bcunnane.github.io/)  
[View Code](https://github.com/bcunnane/CS_4D_flow)

### Siemens CS 4D Flow sequence for muscle strain analysis

I assisted a project demonstrating the feasibility of using the Siemens CS 4D Flow sequence, originally designed for blood flow imaging, to analyze strain in a volume during muscle contraction. Earlier muscle volume strain experiments utilized multiple 2D slices, requiring careful positioning and possible information loss between slices. In contrast, this new sequence avoids these issues with a 3D volume acquisition made practical by highly accelerated compressed sensing. I assisted setting up and executing an experiment similar to that described in 1b and developed a MATLAB script for processing the resulting VEPC DICOMs (see below). The 3D strain tensors were successfully calculated for voxels in the volume, demonstrating this sequence’s usefulness for skeletal muscle research despite blood flow being much faster than muscle contraction. Working with compressed sensing is exciting because of the technological possibilities faster imaging enables, so I am looking forward to continuing to develop this project in the coming months. 

## DICOM processing

The processing steps are:

1. Import DICOM phase data as single matrix where each 'slice' of the volume is an image frame.
2. If imported images are unsigned, perform linear rescaling using RescaleSlope and RescaleIntercept values in DICOM header info.
3. Repeat for each velocity direction x, y, and z. Use the DICOM header info to assign velocity direction ('Through' = vz, 'ap' = vx, 'fh' = vy).
4. Import the combined magnitude DICOM data as magnitude, m.
5. Read the header info of each DICOM to get slice locations. Determine where the slice locations repeat, indicating a new time frame.

## Testing

Velocity data collected from the Siemens sequence was evaluated using the following steps. The example below uses the 21092116RH dataset collected at SDSU, which has 24 slices and 50 frames. 

- Display a montage of all frame 1 slices in the magnitude data. Select a "slice of interest" in the magnitude data on which to draw the region of interest (ROI).

![Slice Montage](images/slice montage.png)
> Montage of frame 1 of all slices. Used to select slice with clearest view of MG muscle. 

- Draw the ROI on medial gastrocnemius (MG) muscle and transform into a mask.
- Select all frames corresponding to the slice of interest in the velocity data. Use the mask to select data within the ROI for these slices. 
- Calculate average velocity in the ROI for each frame and plot the results.
- Repeat for each velocity direction x, y, and z.

![ROI and Velocity Plots](images/21092116RH CS4dFlow slice 14 velocities rescaled.png)
> Velocity plots for ROI on MG muscle
